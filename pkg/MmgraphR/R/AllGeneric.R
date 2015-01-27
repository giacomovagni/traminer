##'--------------------------------------------------------- #
##' Author:          Pauline (Poulcheria) Adamopoulou
##' E-Mail:          padamopo@gmail.com
##' Date:            2014-11-07
##'
##' Description:				New generics for exported methods
##' 
##'
##' Overview:
##' trmatplot:          parallel coordinate plot for a
##'											probability transition matrix		
##'
##' Last modifications:
##' 2014-12-05: include all arguments in 'trmatplot' 
##' 2014-11-07: added 'trmatplot' generic
##'--------------------------------------------------------- #

trmatplot <- function(d, seed = NULL, cspal = NULL, cpal = NULL, title = NULL,
                       xlab =  NULL, ylab = NULL, ylim = NULL, xtlab = NULL,
                       pfilter = NULL, shade.col = "grey80", num = 1,
                       hide.col = NULL, lorder = NULL, verbose = FALSE, ...) UseMethod("trmatplot")