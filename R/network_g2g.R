# --------------------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See LICENSE.txt in the project root for license information.
# --------------------------------------------------------------------------------------------

#' @title Create a network plot with the group-to-group query
#'
#' @description
#' Pass a data frame containing a group-to-group query and return a network plot.
#' Automatically handles "Collaborators_within_group" and "Other_collaborators" within query data.
#'
#' @param data Data frame containing a G2G query.
#' @param time_investor String containing the variable name for the Time Investor column.
#' @param collaborator String containing the variable name for the Collaborator column.
#' @param metric String containing the variable name for metric.
#' @param exc_threshold Exclusion threshold to apply.
#' @param subtitle String to override default plot subtitle.
#' @param return Character vector specifying what to return, defaults to "plot".
#' Valid inputs include:
#'   - "plot": return a network plot.
#'   - "table": return a raw data table used to plot the network.
#'   - "network": return an **igraph** object
#'
#' @import ggplot2
#' @import dplyr
#'
#' @examples
#' # Return a network plot
#' g2g_data %>%
#'   network_g2g(time_investor = "TimeInvestors_Organization",
#'               collaborator = "Collaborators_Organization",
#'               metric = "Collaboration_hours")
#'
#' @export
network_g2g <- function(data,
                        time_investor,
                        collaborator,
                        metric,
                        exc_threshold = 0.1,
                        subtitle = "Collaboration Across Organizations",
                        return = "plot"){

  plot_data <-
    data %>%
    rename(TimeInvestorOrg = time_investor,
           CollaboratorOrg = collaborator,
           Metric = metric) %>%
    mutate(CollaboratorOrg = case_when(CollaboratorOrg == "Collaborators Within Group" ~ TimeInvestorOrg,
                                     TRUE ~ CollaboratorOrg)) %>%
    group_by(TimeInvestorOrg, CollaboratorOrg) %>%
    filter(TimeInvestorOrg != "Other_Collaborators" &
             CollaboratorOrg!="Other_Collaborators") %>%
    summarise_at("Metric", ~mean(.)) %>%
    group_by(TimeInvestorOrg) %>%
    mutate(metric_prop = Metric / sum(Metric, na.rm = TRUE)) %>%
    select(TimeInvestorOrg, CollaboratorOrg, metric_prop) %>%
    ungroup()

  if(return == "table"){

    plot_data

  } else if(return %in% c("plot", "network")){

    ## Network object
    mynet_em <-
      plot_data %>%
      filter(metric_prop > exc_threshold) %>%
      mutate_at(vars(TimeInvestorOrg, CollaboratorOrg), ~sub(pattern = " ", replacement = "\n", x = .)) %>%
      mutate(metric_prop = metric_prop * 10) %>%
      igraph::graph_from_data_frame(directed = FALSE)

    if(return == "network"){

      mynet_em # Return igraph object

    } else {

      ## Plot object
      mynet_em %>%
        ggraph::ggraph(layout = "fr") +
        ggraph::geom_edge_link(aes(edge_width = metric_prop * 1), edge_alpha = 0.5, edge_colour = "grey") +
        ggraph::geom_node_point(size = 20, colour = "lightblue") +
        ggraph::geom_node_text(aes(label = name), size = 3, repel = FALSE) +
        ggplot2::theme(panel.background = ggplot2::element_rect(fill = 'white'), legend.position = "none") +
        theme_wpa_basic() +
        labs(title = "Group to Group Collaboration",
             subtitle = subtitle,
             x = "",
             y = "",
             caption = paste("Displays only collaboration above ", exc_threshold * 100, "% of node's total collaboration", sep = "")) +
        theme(axis.line = element_blank(),
              axis.text = element_blank(),
              legend.position = "none")

    }

  } else {

    stop("Please enter a valid input for `return`.")

  }
}

#' @rdname network_g2g
#' @export
g2g_network <- network_g2g
