\name{totalResults}
     \alias{totalResults}
     \alias{totalResults, RoarDataset}
     \alias{totalResults, RoarDatasetMultipleAPA}
     \title{Returns a dataframe with results of the analysis for a \code{\linkS4class{RoarDataset}}
     or a \code{\linkS4class{RoarDatasetMultipleAPA}} object}
     \description{
         The last step of a classical Roar analyses: it returns a dataframe containing m/M values, roar 
         values and pvalues.
     }
     \usage{
      totalResults(rds)
     }
     \arguments{
       \item{rds}{
           The \code{\linkS4class{RoarDataset}} or \code{\linkS4class{RoarDatasetMultipleAPA}} with all the analysis 
           steps (\code{\link{countPrePost}},
            \code{\link{computeRoars}}, \code{\link{computePvals}}) performed.}
      }
      \value{
         The \code{\linkS4class{RoarDataset}} or the \code{\linkS4class{RoarDatasetMultipleAPA}} object given as rds 
         with all the analysis steps performed.
         If one or more steps hadn't been performed they will be called automatically (\bold{WARNING}: only
         working for \code{\linkS4class{RoarDataset}} right now).
         The resulting dataframe will have the "gene_id" of the initial annotation as row names (without
         the trailing "_PRE"/"_POST") and as columns the m/M ratio for the treatment and control conditions,
         the roar value and the Fisher test pvalue (respectively: mM_treatment, mM_control, roar, pval).
         If more than one sample has been given for a condition the "pval" column will contain the
         product of all the comparisons pvalue and there will be other columns containing
         the pvalues resulting from all the pairwise treatment vs control contrasts, with names "pvalue_X_Y" 
         where
         X represent the position of the sample in the treatment list of bam files (or GappedAlignment) and
         Y the position for the control list.
         When using \code{\linkS4class{RoarDatasetMultipleAPA}} this dataframe will report multiple
         results for each gene that corresponds to the pairings between every APA associated with that
         gene in the gtf and the gene's end - rownames in this case will be in the form geneid_apaid.
         \bold{WARNING}: this method does not filter in any way the results, therefore there will be negative
         m/M values/ROAR and also NA - in these cases there aren't enough information to draw a conclusion
         about the shortening/lengthening of the gene in the given samples and thus the pvalues
         should not be kept in consideration. Furthermore there isn't any filter on the expression level
         of the genes. See \code{\link{fpkmResults}}, \code{\link{standardFilter}} and
         \code{\link{pvalueFilter}} about results filtering possibilities.
      }
     \examples{
   library(GenomicAlignments)
   gene_id <- c("A_PRE", "A_POST", "B_PRE", "B_POST")
   features <- GRanges(
      seqnames = Rle(c("chr1", "chr1", "chr2", "chr2")),
      strand = strand(rep("+", length(gene_id))),
      ranges = IRanges(
         start=c(1000, 2000, 3000, 3600),
         width=c(1000, 900, 600, 300)),
      DataFrame(gene_id)
   )
   rd1 <- GAlignments("a", seqnames = Rle("chr1"), pos = as.integer(1000), cigar = "300M", strand = strand("+"))
   rd2 <- GAlignments("a", seqnames = Rle("chr1"), pos = as.integer(2000), cigar = "300M", strand = strand("+"))
   rd3 <- GAlignments("a", seqnames = Rle("chr2"), pos = as.integer(3000), cigar = "300M", strand = strand("+"))
   rds <- RoarDataset(list(c(rd1,rd2)), list(rd3), features)
   rds <- countPrePost(rds, FALSE)
   rds <- computeRoars(rds)
   rds <- computePvals(rds)
   dat <- totalResults(rds)
    }
\keyword{totalResults}
