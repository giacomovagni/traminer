\encoding{latin1}
\name{seqedist}
\alias{seqedist}
\title{Distances between event sequences}
\description{
Compute Optimal Matching like distances between event sequences. The distance measure is fully described in \cite{Studer et al. 2010}.
}
\usage{
seqedist(seqe, idcost, vparam, interval="No", norm="YujianBo")
}
\arguments{
  \item{seqe}{an event sequence object as defined by the \code{\link{seqecreate}} function.}
  \item{idcost}{Insertion/deletion cost of the different type of event (one entry per event type).}
  \item{vparam}{The cost of moving an event of one time unit.}
  \item{norm}{Character. One of \code{"YujianBo"} (respects triangle inequality), \code{"max"} (maximum distance) or \code{"none"}.}
  \item{interval}{Character. One of \code{"No"} (absolute ages), \code{"previous"} (time spent since previous event) or \code{"next"} (time spent until next event.).}
}
\value{a distance matrix.}

\author{Matthias Studer}

\references{
Studer, M., M�ller, N.S., Ritschard, G. & Gabadinho, A. (2010), "Classer, discriminer et visualiser des s�quences d'�v�nements", 
In Extraction et gestion des connaissances (EGC 2010), \emph{Revue des nouvelles technologies de l'information RNTI}. Vol. E-19, pp. 37-48. 

}

\examples{
data(actcal.tse)
actcal.seqe <- seqecreate(actcal.tse[1:200,])[1:6,]
## We have 8 different event in this dataset
idcost <- rep(1, 8)
dd <- seqedist(actcal.seqe, idcost=idcost, vparam=.1)
}

\keyword{misc}

