library("dplyr")
library("dada2")

# Load the helper scripts
source("workflow/scripts/helper_scripts.R")

# Defining Snakemake config, input and output values
q_threshold <- snakemake@params[["q_threshold"]]
window_size <- snakemake@params[["window_size"]]
asv_table <- snakemake@output[["asv_table"]]
tax_table <- snakemake@output[["tax_table"]]

# Creating output directory
outdir <- dirname(asv_table) #The output is "results/dada2"
dir.create(dirname(asv_table), recursive = TRUE, showWarnings = FALSE)

# Getting data ready
fnFs <- snakemake@input[["clean_r1"]]
fnRs <- snakemake@input[["clean_r2"]]
sample.names <- sapply(strsplit(basename(fnFs), "_"), `[`, 1)

# Inspect read quality profiles
p <- plotQualityProfile(fnFs[1:2])
q <- plotQualityProfile(fnRs[1:2])

# Save the plotQualityProfiles as png files
fwd_quality_plot <- file.path(outdir,"fnFsQualityProfilePlot.png")
rev_quality_plot <- file.path(outdir,"fnRsQualityProfilePlot.png")

png(file = fwd_quality_plot, width = 900, height = 900, res = 150)
print(p)
dev.off()
png(file = rev_quality_plot, width = 900, height = 900, res = 150)
print(q)
dev.off()

# Get the truncLen for fnFS and fnRS based on the Quality Profile
fnFs_trunc_len <- calculate_truncLen(p$data, q_threshold = q_threshold, window_size = window_size)
fnRs_trunc_len <- calculate_truncLen(q$data, q_threshold = q_threshold, window_size = window_size)

# Filtering and trimming
# Place filtered files in filtered/ subdirectory
filtFs <- file.path(outdir, "filtered", paste0(sample.names, "_F_filt.fastq.gz"))
filtRs <- file.path(outdir, "filtered", paste0(sample.names, "_R_filt.fastq.gz"))
names(filtFs) <- sample.names
names(filtRs) <- sample.names

out <- filterAndTrim(fnFs, filtFs, fnRs, filtRs, truncLen = c(fnFs_trunc_len, fnRs_trunc_len),
                     maxN = 0, maxEE = c(2,2), truncQ = 2, rm.phix = TRUE,
                     compress = TRUE, multithread = TRUE)

# Learn the error Rates
errF <- learnErrors(filtFs, multithread = TRUE)
errR <- learnErrors(filtRs, multithread = TRUE)

# Plotting estimated error rates
P <- plotErrors(errF, nominalQ = TRUE)
Q <- plotErrors(errR, nominalQ = TRUE)

# Save the plotErrors as png files
error_plotF <- file.path(outdir,"ErrorPlotF.png")
error_plotR <- file.path(outdir,"ErrorPlotR.png")

png(file = error_plotF, width = 900, height = 900, res = 150)
print(P)
dev.off()
png(file = error_plotR, width = 900, height = 900, res = 150)
print(Q)
dev.off()

# Sample Inference
dadaFs <- dada(filtFs, err = errF, multithread = TRUE)
dadaRs <- dada(filtRs, err = errR, multithread = TRUE)

# Merge paired reads to obtained denoised sequences
mergers <- mergePairs(dadaFs, filtFs, dadaRs, filtRs, verbose = TRUE)

# Construct Amplicon Sequence Variant table
seqtab <- makeSequenceTable(mergers)

# Remove chimeras
seqtab.nochim <- removeBimeraDenovo(seqtab, method = "consensus", multithread = TRUE, verbose = TRUE)

# Create a table that tracks number of reads through the pipeline
getN <- function(x) sum(getUniques(x))
track <- cbind(out, sapply(dadaFs, getN), sapply(dadaRs, getN), sapply(mergers, getN), rowSums(seqtab.nochim))
colnames(track) <- c("input", "filtered", "denoisedF", "denoisedR", "merged", "nonchim")
rownames(track) <- sample.names

track_file <- file.path(outdir, "NumReadsTrack.csv")
write.csv(track, file = track_file)

# Assign taxonomy
taxa <- assignTaxonomy(seqtab.nochim,"data/silva_nr99_v138.2_toGenus_trainset.fa.gz", multithread = TRUE)

taxa <- addSpecies(taxa, "data/silva_v138.2_assignSpecies.fa.gz")

# Save the ASV table into an R object for Snakemake rule
saveRDS(seqtab.nochim, asv_table)
saveRDS(taxa, tax_table)

