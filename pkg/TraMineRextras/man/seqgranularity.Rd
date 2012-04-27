\name{seqgranularity}
\alias{seqgranularity}
\title{
  Changing sequence time granularity by aggregating positions
}
\description{
Changes time granularity of a state sequence object by aggregating successive positions into groups of a user-defined time length.
}
\usage{
seqgranularity(seqdata, tspan = 3, method = "last")
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{seqdata}{
    A state sequence object.
}
  \item{tspan}{
    Integer. Number of successive positions grouped together.
}
  \item{method}{
    Character string. Aggregating method. Currently only \code{"last"} is supported.
}
}
\details{
Successive position are aggregated by group of \code{tspan}, starting from the first position and, with method \code{"last"}, the last state in the group is assigned to the group. In case of an incomplete last group, the last state is assigned to it.
}
\value{
The resulting state sequence object. 
}
\author{
Gilbert Ritschard
}

%% ~Make other sections like Warning with
\section{Warning }{This function needs further testing.}

\seealso{
 \code{\link{seqdef}}
}
\examples{
##---- Should be DIRECTLY executable !! ----
##-- ==>  Define data, use random,
##--	or do  help(data=index)  for the standard data sets.

data(mvad)
mvad.seq <- seqdef(mvad[,17:86], xtstep=12)
mvadg.seq <- seqgranularity(mvad.seq, tspan=6)
par(mfrow=c(2,1))
seqdplot(mvad.seq, withlegend=FALSE)
seqdplot(mvadg.seq, withlegend=FALSE)
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{utility}% __ONLY ONE__ keyword per line