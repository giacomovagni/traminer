\name{seqcomp}
\alias{seqcomp}
\title{Compare two state sequences}
\description{
Compare two state sequences and return TRUE if they are equal and FALSE otherwise
}
\usage{
 seqcomp(x, y)
}
\arguments{
  \item{x}{a state sequence object containing a single sequence (typically the row of a main sequence 
      object, see \code{\link{seqdef}})}
  \item{y}{a state sequence object containing a single sequence (typically the row of a main sequence 
      object, see \code{\link{seqdef}})}
}

\value{TRUE if sequences are identical, FALSE otherwise}

\seealso{
 \code{\link{seqfind}, \link{seqfpos}, \link{seqpm}}
}
\examples{
data(mvad)
mvad.shortlab <- c("EM", "FE", "HE", "JL", "SC", "TR")
mvad.seq <- seqdef(mvad, states=mvad.shortlab, 15:86)

## Comparing sequences 1 and 2 in mvad.seq
seqcomp(mvad.seq[1,],mvad.seq[2,])

## Comparing sequences 176 and 211 in mvad.seq
seqcomp(mvad.seq[176,],mvad.seq[211,])
}
\keyword{misc}