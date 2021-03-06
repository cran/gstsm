#' Algorithm 6: Generate Candidates
#'
#' The algorithm combines SRGs that have sequences of size k, received as
#' input, to generate candidates with sequences of size k + 1. Let x and y be
#' SRGs, the conditions for this to occur are (line 3): that we have an
#' intersection of candidates over the time range,
#' intersection over the set of spatial positions (x.g n y.g), and
#' a common subsequence: <x.s2, . . . , x.sk>=<y.s1, . . . , y.sk-1>.
#'
#' @param srg Solid-Ranged-Groups
#' @param k sequence size
#' @param beta minimum group size
#' @return Ck+1 set of candidates having length k + 1
#' @export
generate_candidates <- function(srg, k, beta) {
  lines <- length(srg)

  if (lines <= 0) {
    return(srg)
  }

  n_new_elements <- 0

  time <- matrix(nrow = 0, ncol = 5)
  colnames(time) <- c("r_s", "r_e", "freq", "e_s", "e_e")

  rg <- list(time = time, group = list(), occ = list())

  ck <- list()

  i <- 1
  while (i <= lines) {
    j <- 1
    while (j <= lines) {
      if (
        (srg[[i]]$r_s < srg[[j]]$r_e) &&
        ((srg[[i]]$r_e + 1) >=
        srg[[j]]$r_s)
      ) {
        if (
          sum(
            srg[[i]]$group & srg[[j]]$group) >=
            beta
          ) {
          if (
            substr(srg[[i]]$s, 2, k) == substr(srg[[j]]$s, 1, k - 1)
          ) {
            seq <- paste0(srg[[i]]$s, substr(srg[[j]]$s, k, k))

            range_s <- max(srg[[i]]$r_s, (srg[[j]]$r_s - 1))
            range_e <- min(srg[[i]]$r_e, (srg[[j]]$r_e - 1))

            pos <- srg[[i]]$group & srg[[j]]$group

            new <- list(
              seq = seq,
              range_s = range_s,
              range_e = range_e,
              pos = pos,
              rgs = rg,
              rgs_closed = rg
            )

            n_new_elements <- n_new_elements + 1

            ck[[n_new_elements]] <- new
          }
        }
      }
      j <- j + 1
    }
    i <- i + 1
  }

  return(ck)
}
