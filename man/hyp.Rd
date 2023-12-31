% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/hyp.R
\name{hyp}
\alias{hyp}
\title{A hyp object}
\description{
A hyp object

A hyp object
}
\section{See Also}{


\code{multihyp}
}

\examples{
data <- data.frame(replicate(5,sample(0:1,10,rep=TRUE)))
args <- list("arg_1"=1, "arg_2"=2, "arg_3"=3)
hyp_obj <- hyp$new(data, args=args)

}
\section{Public fields}{
\if{html}{\out{<div class="r6-fields">}}
\describe{
\item{\code{data}}{A dataframe returned by hypeR()}

\item{\code{plots}}{A list of plots returned by hypeR()}

\item{\code{args}}{A list of arguments passed to hypeR()}

\item{\code{info}}{Exported information for reproducibility}
}
\if{html}{\out{</div>}}
}
\section{Methods}{
\subsection{Public methods}{
\itemize{
\item \href{#method-hyp-new}{\code{hyp$new()}}
\item \href{#method-hyp-print}{\code{hyp$print()}}
\item \href{#method-hyp-as.data.frame}{\code{hyp$as.data.frame()}}
\item \href{#method-hyp-clone}{\code{hyp$clone()}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-hyp-new"></a>}}
\if{latex}{\out{\hypertarget{method-hyp-new}{}}}
\subsection{Method \code{new()}}{
Create a hyp object
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{hyp$new(data, plots = NULL, args = NULL, info = NULL)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{data}}{A dataframe returned by hypeR()}

\item{\code{plots}}{A list of plots returned by hypeR()}

\item{\code{args}}{A list of arguments passed to hypeR()}

\item{\code{info}}{Exported information for reproducibility}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
A new hyp object
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-hyp-print"></a>}}
\if{latex}{\out{\hypertarget{method-hyp-print}{}}}
\subsection{Method \code{print()}}{
Print hyp obect
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{hyp$print()}\if{html}{\out{</div>}}
}

\subsection{Returns}{
NULL
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-hyp-as.data.frame"></a>}}
\if{latex}{\out{\hypertarget{method-hyp-as.data.frame}{}}}
\subsection{Method \code{as.data.frame()}}{
Extract dataframe from hyp obect
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{hyp$as.data.frame()}\if{html}{\out{</div>}}
}

\subsection{Returns}{
NULL
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-hyp-clone"></a>}}
\if{latex}{\out{\hypertarget{method-hyp-clone}{}}}
\subsection{Method \code{clone()}}{
The objects of this class are cloneable with this method.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{hyp$clone(deep = FALSE)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{deep}}{Whether to make a deep clone.}
}
\if{html}{\out{</div>}}
}
}
}
