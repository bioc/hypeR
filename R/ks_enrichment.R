#' One-sided Kolmogorov–Smirnov test
#'
#' @param n.x The length of a ranked list
#' @param y A vector of positions in the ranked list
#' @param weights Weights for weighted score (Subramanian et al.)
#' @param weights.pwr Exponent for weights (Subramanian et al.)
#' @param absolute Takes max-min score rather than the max deviation from null
#' @param plotting Use true to generate plot
#' @param plot.title Plot title
#' @return A list of data and plots
#'
#' @importFrom stats ks.test
#' 
#' @keywords internal
.kstest <- function(n.x,
                    y, 
                    weights=NULL,
                    weights.pwr=1,
                    absolute=FALSE, # this is not really implemented, should be removed
                    plotting=FALSE, 
                    plot.title="") 
{
  n.y <- length(y)
  err <- list(score = 0, pval = 1, leading_edge = NULL, leading_hits = NULL, plot = ggempty())
  if (n.y < 1 || any(y > n.x) || any(y < 1) ) {
    return(err)
  }
  x.axis <- y.axis <- NULL
  leading_edge <- NULL # recording the x corresponding to the highest y value
  
  ## If weights are provided
  if ( !is.null(weights) ) {
    weights <- abs(weights[y])^weights.pwr
    
    Pmis <- rep(1, n.x); Pmis[y] <- 0; Pmis <- cumsum(Pmis); Pmis <- Pmis/(n.x-n.y)
    Phit <- rep(0, n.x); Phit[y] <- weights; Phit <- cumsum(Phit); Phit <- Phit/Phit[n.x]
    z <- Phit-Pmis
    
    score <- if (absolute) max(z)-min(z) else z[leading_edge <- which.max(abs(z))]
    
    x.axis <- 1:n.x
    y.axis <- z
  } 
  ## Without weights
  else {
    y <- sort(y)
    n <- n.x*n.y/(n.x + n.y)
    hit <- 1/n.y
    mis <- 1/n.x
    
    Y <- sort(c(y-1, y))    # append the positions preceding hits
    Y <- Y[diff(Y) != 0]    # remove repeated position
    y.match <- match(y, Y)  # find the hits' positions
    D <- rep(0, length(Y))
    D[y.match] <- (1:n.y)
    zero <- which(D == 0)[-1]
    D[zero] <- D[zero-1]
    
    z <- D*hit-Y*mis
    
    score <- if (absolute) max(z)-min(z) else z[leading_edge <- which.max(abs(z))]
    
    x.axis <- Y
    y.axis <- z
    
    if (Y[1] > 0) {
      x.axis <- c(0, x.axis)
      y.axis <- c(0, y.axis)
    }
    if (max(Y) < n.x) {
      x.axis <- c(x.axis, n.x)
      y.axis <- c(y.axis, 0)
    }    
  }
  leading_edge <- x.axis[leading_edge]
  leading_hits <- intersect(x.axis[x.axis <= leading_edge], y)
  
  ## One-sided Kolmogorov–Smirnov test
  results <- suppressWarnings(ks.test(1:n.x, y, alternative="less"))
  results$statistic <- score  # Use the signed statistic
  
  ## Enrichment plot
  p <- if (plotting && n.y > 0) {
    ggeplot(n.x, y, x.axis, y.axis, plot.title) +
      geom_vline(xintercept = leading_edge, linetype = "dotted", color = "red", linewidth = 0.25)
  } else {
    ggempty()
  }
  return(list(
    score = as.numeric(results$statistic),
    pval = results$p.value,
    leading_edge = leading_edge,
    leading_hits = leading_hits,
    plot = p
  ))
}
#' Enrichment test via one-sided Kolmogorov–Smirnov test
#' 
#' @param signature A vector of ranked symbols
#' @param genesets A list of genesets
#' @param weights Weights for weighted score (Subramanian et al.)
#' @param weights.pwr Exponent for weights (Subramanian et al.)
#' @param absolute Takes max-min score rather than the max deviation from null
#' @param plotting Use true to generate plot
#' @return A list of data and plots
#' 
#' @keywords internal
.ks_enrichment <- function(
    signature,
    genesets,
    weights = NULL,
    weights.pwr = 1,
    absolute = FALSE,
    plotting = TRUE) 
{
  if (!is(genesets, "list")) stop("Error: Expected genesets to be a list of gene sets\n")
  if (!is.null(weights)) stopifnot(length(signature) == length(weights))

  signature <- unique(signature)
  genesets <- lapply(genesets, unique)

  results <- mapply( function(geneset, title) {
    ranks <- match(geneset, signature)
    ranks <- ranks[!is.na(ranks)]

    ## Run ks-test
    results_in <- .kstest(
      n.x = length(signature),
      y = ranks,
      weights = weights,
      weights.pwr = weights.pwr,
      absolute = absolute,
      plotting = plotting,
      plot.title = title
    )
    #results_in[["geneset"]] <- length(geneset)
    results_in[["geneset"]] <- length(intersect(geneset, signature))
    results_in[["overlap"]] <- length(results_in$leading_hits)
    return(results_in)
  }, genesets, names(genesets), USE.NAMES = TRUE, SIMPLIFY = FALSE)

  results <- do.call(rbind, results)
  data <- data.frame(apply(results[, c("score", "pval", "geneset", "overlap")], 2, unlist),
    stringsAsFactors = FALSE
  )
  ## add list of genes in the leading edge
  data <- data %>%
    #dplyr::mutate(hits = sapply(results[, "leading_hits"], function(x) paste(signature[x], collapse = ",")))
    dplyr::mutate(hits = sapply(results[, "leading_hits"], function(x) paste(signature[x], collapse = " , ")))
  data$score <- signif(data$score, 2)
  data$pval <- signif(data$pval, 2)
  data$label <- names(genesets)
  data$signature <- length(signature)
  data$fdr <- signif(p.adjust(data$pval, method = "fdr"), 2)
  data <- data %>%
    dplyr::relocate(fdr, .after = pval) %>%
    dplyr::relocate(signature, .after = geneset) %>%
    dplyr::relocate(label) %>%
    tibble::remove_rownames() # make sure this is OK
  plots <- results[, "plot"]

  return(list(
    data = data,
    plots = plots,
    leading_hits = sapply(results[, "leading_hits"], function(x) signature[x])
  ))
}
