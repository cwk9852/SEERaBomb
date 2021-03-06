\name{mkDF}
\alias{mkDF}
\title{Converts seerSet$L series to a data.frame}
\description{Creates a data.frame of observed and expected cases for each first and second cancer and treatment. 
Use of this function is deprecated. Use getDF() instead, if needed: csd now calls getDF internally for the 
most recent time series, so even it may not need to be called directly.}
\usage{mkDF(seerSet,srs)} 
\arguments{
  \item{seerSet}{seerSet object produced by tsd(). }
  \item{srs}{Series. The time series of interest. NULL (default) implies the currently active series, which is
     the most recent. A number i implies the ith series. A string identifies the series by name (numeric vectors 
     will be coerced to such a string via paste0("b",paste(brks,collapse="_")) where brks = vector of time breakpoints.}
}
   
\value{A data.frame in long format that can be used by ggplot.  }
  

\author{Tom Radivoyevitch (radivot@ccf.org)}
\seealso{\code{\link{SEERaBomb-package}, \link{mk2D}, \link{tsd}} }
\examples{
\dontrun{ 
library(SEERaBomb)
load("~/data/SEER/mrgd/cancDef.RData") #load in canc
load("~/data/SEER/mrgd/popsae.RData") # load in popsae
canc=canc\%>\%select(-reg,-recno,-agerec,-numprims,-COD,
          -age19,-age86,-radiatn,-ICD9,-db,-histo3) 
popsa=popsae\%>\%group_by(db,race,sex,age,year)\%>\%summarize(py=sum(py)) # sum on regs
pm=seerSet(canc,popsa,Sex="male",ageStart=0,ageEnd=100) #pooled (races) male seerSet
pm=mk2D(pm,secondS=c("AML","MDS"))
brks=c(0,1,5)
firstS=c("NHL","MM")
pm=tsd(pm,brks=brks,trts=c("rad","noRad"),firstS=firstS)
mkDF(pm)
}
}

\keyword{internal}
