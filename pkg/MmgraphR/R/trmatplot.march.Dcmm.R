# renamed from trmatplot.march.Dcmm b/c implies S3 method (impossible since march isn't on CRAN)
march.Dcmm.trmatplot <- function (d, seed = NULL, type = "hidden", hstate = 1, 
                       	cspal = NULL, cpal = NULL, title = NULL,
                      	xlab =  NULL, ylab = NULL, ylim = NULL, 
												xtlab = NULL, ytlab = NULL,
												pfilter = NULL,                       	
												shade.col = "grey80",
                       	num = 1,
                       	hide.col = NULL,
                       	lorder = NULL,
												plot = TRUE,
                       	verbose = FALSE, ...){

	###
  ### Check Arguments
	###
  if ( verbose )
			cat ( " [>] check arguments\n" )
  ##
	## class
	if ( ! class ( d ) [ 1 ] == "march.Dcmm") {
			stop ( "[!] input must be an object of class march.Dcmm" )
	}

	##
	## seed
	if ( ! is.null ( seed ) & ! is.numeric ( seed ) ) {
			stop ("[!] seed must be numeric")
	}

  ##
  ## type
  if ( ! ( type %in% c ( "hidden", "visible" ) ) ) {
      stop ( "[!] matrix type must be specified as either hidden or visible" )
  }
	if ( type == "visible" & d @ orderVC == 0 ) {
      stop ( "[!] visible matrix cannot be plotted when the visible order is zero" )
  }

 	##
  ## hstate
  if ( ! is.element ( hstate, c (1 : ( d @ M ) ) ) ) {
      stop ( "[!] hstate must be an element of the set of hidden states" )
  }

  ##  
  ## cpal
  if ( ! is.null ( cpal ) ) {
      
    if ( type == "hidden" 
         & length ( cpal )!= d @ M) {
       
        stop("[!] number of colors in 'cpal' must equal number of hidden states")
    
    }
      
    if ( type=="visible" 
         & length ( cpal )!= d @ y @ K) {
        
        stop("[!] number of colors in 'cpal' must equal number of visible states")
      
    }
  
  }
	
	##
  ## cspal  
  if ( ! is.null (cspal)) {
    
    if (! cspal %in% c ( "dynamic", "harmonic" , "cold", "warm" , "heat" , "terrain" ) ){
      
      stop ( "[!] cspal must be specified as one of: dynamic, harmonic, cold, warm, heat, terrain" )
    }
  
    if ( ! is.null ( cpal ) ){
      
      stop ( "[!] only one of cpal or cspal can be specified as non-null" )
		}
	}
      
  ##
  ## pfilter

  if ( ! is.null ( pfilter ) ) {

		if  ( ! (pfilter %in% c ( "smax", "smin" ,"tmax", "tmin" ) ) ) {
      
		     stop ( "[!] pfilter must be specified as one of: smax, smin, tmax or tmin" )
    }
  
  	if ( ! is.numeric ( num ) ){
      
  	    stop ( "[!] num must be numeric")
    }
	
	  if ( pfilter == "tmax"  
       &  type == "visible"  
       &  ! is.element (num, c( 0 : (d @ y @ K) ^ ( d @ orderVC + 1 ) ) ) )  {
        
    stop("[!] num must be an element of the set of visible sequences")
      
	  }
	    
	  if ( pfilter == "tmin" 
       & type == "visible" 
       & ! is.element (num, c( 0 : (d @ y @ K) ^ ( d @ orderVC + 1 ) ) ) ) {
      
    stop("[!] num must be an element of the set of visible sequences ")
      
	  }
  
	  if ( pfilter == "tmax" 
       & type == "hidden" 
       & ! is.element (num, c( 0 : ( (d @ M ) ^ ( d @ orderHC + 1 ) ) ) ) ) {
      
    stop("[!] num must be an element of the set of hidden sequences ")
    
	  }
    
	  if ( pfilter == "tmin" 
       & type == "hidden" 
       & ! is.element (num, c( 0 : ( (d @ M ) ^ ( d @ orderHC + 1 ) ) ) ) ) {
      
        stop("[!] num must be an element of the set of hidden sequences")
    
	  }
	}

	###
  ### Create matrix
	###
  set.seed(seed)

  if ( type == "hidden" ) {
    
    M <- d @ M
        
    l <- d @ orderHC
      
    w <- march.dcmm.h.compactA ( d )
    
  }
  
	if ( type == "visible" ) {
    
 		M <-  d @ y @ K # K
    
    l <- d @ orderVC # f
      
    w <- d @ RB [ hstate , , ]
    
  }
  

	###
  ### BEGIN COMPUTATION
	###

  p <- paths ( M , l )
  
  w <- matrix ( t ( w ) , ncol = 1)
  
  w <- as.vector ( w )
  
  s <- suppressMessages ( seqdef ( p , weights = w) )
  
  st <- apply ( p , 1 , function ( x ) paste ( x , collapse = "-" ) )
  
	if ( is.null ( cpal ) ) {
		  
		if ( is.null ( cspal ) ) {
			
	#		if ( type == "hidden" ) {
      
    	  cpl <- rainbow_hcl ( M , c = 80 , l = 65 , start = 0 , end = 360 * ( M - 1 ) / M ) # cite: colorspace:::rainbow_hcl
			
  #  	}
    
		# else	if ( type == "visible" ) {
      
   #   	cpl <- heat_hcl ( M , h = c ( 100 , -100 ) , l = c ( 75 , 40), c = c ( 40 , 80 ) , power = 8 ) # ccolorspace:::heat_hcl
      
    #	}
    

		}		
    
    else if ( ! is.null ( cspal ) & cspal == "dynamic"){
      
      cpl <- rainbow_hcl ( M , c = 80 , l = 60 , start = 120, end = 390 ) # cite: colorspace:::rainbow_hcl 
    }
    
    else if ( ! is.null ( cspal ) & cspal == "harmonic"){
      
      cpl <- rainbow_hcl ( M , c = 80 , l = 60 , start = 60 , end = 240 ) # cite: colorspace:::rainbow_hcl    
    }
    
    else if ( ! is.null ( cspal ) & cspal == "cold"){
      
      cpl <- rainbow_hcl ( M , c = 80 , l = 60 , start = 270 , end = 150 ) # cite: colorspace:::rainbow_hcl
    }
    
    else if ( ! is.null ( cspal ) & cspal == "warm"){
      
      cpl <-rainbow_hcl ( M , c = 80 , l = 60 , start = 90 , end = -30 ) # cite: colorspace:::rainbow_hcl
    }
    
    else if ( ! is.null ( cspal ) & cspal == "heat"){
      
      cpl <- heat_hcl ( M , h = c ( 0, 90 ), c. = c ( 100, 100 ), l = 50, power = c ( 1/M, 1 ) )  # cite: colorspace:::heat_hcl
    }
  
    else if ( ! is.null ( cspal ) & cspal == "terrain"){
    
      cpl <- terrain_hcl ( M, h = c ( 130,  0 ), c = c ( 100, 30 ), l = 50, power = c ( 1/M, 1 ) ) # cite: colorspace:::terrain_hcl
    }
  }
  
  else {
    cpl <- cpal
  }
  
  ch <- rep( c ( cpl ) , M ^ ( l - 1 ) , each = M ) # color from first time period
  
  #ch <- rep( c(cpl), M ^ (l)) # color from last time period
  
  predat <- data.frame ( w = w , ch = ch , s = st )
  
  predat <- predat [ order ( predat $ s ) , ] # order by seq name
  
  if ( is.null ( pfilter ) ) {
    
    predat <- predat
    
  }
  
  else if ( ! is.null ( pfilter ) & pfilter == "smin" ) {
    
    predat <- ismin ( M , l , dt = predat)
    
    predat <- smin ( M , l , dt = predat , shade.col )
    
  }
  
  else if ( ! is.null ( pfilter ) & pfilter == "smax" ) {
    
    predat <- ismax ( M , l , dt = predat)
    
    predat <- smax ( M , l , dt = predat , shade.col )
    
  }
  
  else if ( ! is.null ( pfilter ) & pfilter == "tmax" )  {
    
    predat <- tmax ( M , l , dt = predat , shade.col , num = num )
    
  }
  
  else if ( ! is.null ( pfilter ) & pfilter == "tmin" ) {
    
    predat <- tmin ( M , l , dt = predat , shade.col , num = num )
    
  }
  
  dat <- data.frame ( w = as.vector ( predat $ w ) ,
                      ch = as.vector ( predat $ ch ) , 
                      s = as.vector ( predat $ s ) )
  
  dat <- dat [ order ( dat $ s ) , ] # order by seq name
  
  dat <- dat [ order ( dat $ w , decreasing = TRUE ) , ]
  
  # TITLE
  
  if ( is.null ( title ) ) {

		if ( type == "hidden" ) {
      
      ttl <- "Hidden Transition Matrix"
      
    }
    
    if ( type == "visible" ) {
      
      ttl <- paste ( "Visible Transition Matrix for Hidden State" , hstate )
      
    }
    
    else {
		
			ttl <- "Probability Transition Matrix"

		}
    
  }
  
  else if ( ! is.null ( title ) ) {
    
    ttl <- title
    
  }
  
  
  # XLAB
  
  if ( is.null ( xlab ) ) {
    
    xlb <- "Time"
    
  }
  
  else if ( ! is.null ( xlab ) ) {
    
    xlb <- xlab
    
  }
  
  # YLAB
  
  if ( is.null(ylab) ){
  
		if ( type == "hidden" ) {
      
      ylb <- "Hidden States"
      
    }
    
    if ( type == "visible" ) {
      
      ylb <- "Visible States"
      
    }
    
		else {
	
	   	ylb <- "States"
    
		}
  }
  
  else if ( ! is.null ( ylab ) ) {
    
    ylb <- ylab
    
  }
  
  #YLIM    
  
  if ( is.null ( ylim ) ){
    
    ylm <- c ( 0.5 , ( M + 0.5 ) )
    
  }
  
  else if ( ! is.null ( ylim ) ){
    
    ylm <- ylim
    
  }
  
  
  # XtLAB
  
  if ( is.null ( xtlab ) ) {
    #xt <- c(0:(M-l))
    #xt <- c(c((-l):0)) # number backwards
    
    xt <- c ( c ( 1 : l ) ) # number forwards
    
    xt <- paste( "t +" , xt )
    
    xt <- c ( "t", xt )
    
  }
  
  else if ( ! is.null ( xtlab ) ) {
    
    xt <- xtlab
    
  }
  
  # hide.col
  
  if ( ! is.null ( filter ) & ! is.null ( hide.col ) ){
    
    hd.col <- hide.col
    
  }
  
  else {
    
    hide.col <- shade.col
    
  }
  
  
  # foreground / background
  
  if ( ! is.null ( pfilter ) ) {
    
    if ( pfilter %in% c ( "smax", "tmax" ) ){
      
      lordr <- "foreground"
      
    }
    
    else if ( pfilter %in% c ( "smin" , "tmin" ) ) {
      
      lordr<-"background"
      
    }
    
  }
  
  else if ( is.null ( pfilter ) ) {
    
    lordr <- lorder
    
  }

	#	seqpcplot	
	a <- seqpcplot ( seqdata = s, title = ttl, ylab = ylb, xlab = xlb, hide.col = hide.col, lorder = lordr,
         order.align="time", ylim = ylm, cpal= dat$ch, xtlab = xt, verbose = verbose, plot = FALSE, ...) 

	# ytlab
  # alphabet: labeling the y-axis ticks with the visible states (or why not even the hidden states?)
  # yt <-d @ y @ dictionary
	if ( ! is.null ( ytlab ) ){
		a$ylevs <- c (ytlab, "")
	}
	else {
		a$ylevs
	}

	#	list arguments inhert in trmatplot
	b <- structure ( list ( type = type, 
													hstate = hstate, 
													cspal = cspal, 
													ytlab = ytlab,
													pfilter = pfilter, 
													shade.col = shade.col, 
													num = num ),
									class = "trmatplot")

	#	aggregate list of arguments
	rval <- structure ( list ( plot = a, trmatplot = b, seed = seed, verbose = verbose), class = "trmatplot")

	#	plot

	if ( plot == TRUE ) {

		plot ( a )

	}
	
	else {

		return ( rval )

	}
	
	## DATA
  invisible ( rval )
}

