library("phyloseq")
library("Biostrings")
library("ggplot2")

theme_set(theme_classic())

# Define Snakemake config variables from rule phyloseq
asvs <- snakemake@input[["asv_table_rds"]]
metadata <- snakemake@input[["metadata"]]
taxonomy_table <- snakemake@input[["taxonomy_rds"]]
ps_object <- snakemake@output[["ps_object"]]
alpha_plot_path <- snakemake@output[["alpha_plot"]]
alpha_x_axis <- snakemake@params[["plot_richness_x_axis"]]
richness_measures <- snakemake@params[["plot_richness_measures"]]
richness_color <- snakemake@params[["plot_richness_color"]]
tax_level <- snakemake@params[["bar_plot_taxlevel"]]
bar_axis <- snakemake@params[["bar_plot_x_axis"]]

# Read the created data frames from dada2.smk rule
asv_table <- readRDS(asvs)
taxonomy <- readRDS(taxonomy_table)

# Create the phyloseq output directory
outdir <- dirname(alpha_plot_path) # This return "results/phyloseq"
dir.create(dirname(alpha_plot_path), recursive = TRUE, showWarnings = FALSE)

# Construct metadata to create a phyloseq object
samples.out <- rownames(asv_table)
samdf <- read.csv(metadata, header = TRUE)
rownames(samdf) <- samples.out

# Create the phyloseq object
ps <- phyloseq(otu_table(asv_table, taxa_are_rows=FALSE),
               sample_data(samdf),
               tax_table(taxonomy))

# Keep short names for ASVs rather than full DNA sequence
dna <- Biostrings::DNAStringSet(taxa_names(ps))
names(dna) <- taxa_names(ps)
ps <- merge_phyloseq(ps, dna)
taxa_names(ps) <- paste0("ASV", seq(ntaxa(ps)))
ps


# Save alpha-diversity plot
a <- plot_richness(ps, x = alpha_x_axis, measures=c(richness_measures), color = richness_color)

alpha_plot_name <- file.path(outdir,"alpha_plot.png")

png(file = alpha_plot_name, width = 900, height = 900, res = 150)
print(a)
dev.off()

# Save the phylose object as RDS file
saveRDS(ps, ps_object)


## Beta - diversity
# Transform data to proportions as appropiate for Bray-Curtis distances

ps.prop <- transform_sample_counts(ps, function(otu) otu/sum(otu))
ord.nmds.bray <- ordinate(ps.prop, method = "NMDS", distance = "bray")

# Save beta-diversity plot
b <- plot_ordination(ps.prop, ord.nmds.bray, color = richness_color, title="Bray NMDS")

beta_plot_name <- file.path(outdir,"beta_plot.png")

png(file = beta_plot_name, width = 900, height = 900, res = 150)
print(b)
dev.off()

# Bar plot
top20 <- names(sort(taxa_sums(ps), decreasing = TRUE))[1:20]
ps.top20 <- transform_sample_counts(ps, function(OTU) OTU/sum(OTU))
ps.top20 <- prune_taxa(top20, ps.top20)
c <- plot_bar(ps.top20, x=bar_axis, fill=tax_level) + facet_wrap(~.data[[alpha_x_axis]], scales = "free_x") # alpha_x_axis contains the snakemake parameter, to access that value use .data[[]] 

bar_plot_name <- file.path(outdir,"bar_plot.png")

png(file = bar_plot_name, width = 900, height = 900, res = 150)
print(c)
dev.off()











