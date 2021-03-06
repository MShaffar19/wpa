% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/email_rank.R
\name{email_rank}
\alias{email_rank}
\title{Email Hours Ranking}
\usage{
email_rank(data, hrvar = extract_hr(data), mingroup = 5, return = "table")
}
\arguments{
\item{data}{A Standard Person Query dataset in the form of a data frame.}

\item{hrvar}{A list of HR Variables to consider in the scan.
Defaults to all HR attributes identified.}

\item{mingroup}{Numeric value setting the privacy threshold / minimum group size.
Defaults to 5.}

\item{return}{A character vector specifying what to return.
Valid values include "table" (default). Features are being considered for alternative return options but are currently
unavailable.}
}
\value{
When 'table' is passed in \code{return}, a summary table is returned as a data frame.
}
\description{
This function scans a standard query output for groups with high levels of 'Weekly Email Collaboration'.
Returns a table with a all of groups (across multiple HR attributes) ranked by hours of digital collaboration.
}
\details{
Uses the metric \code{Email_hours}.
See \code{create_rank()} for applying the same analysis to a different metric.
}
\seealso{
Other Emails: 
\code{\link{email_dist}()},
\code{\link{email_fizz}()},
\code{\link{email_line}()},
\code{\link{email_summary}()},
\code{\link{email_trend}()}
}
\concept{Emails}
