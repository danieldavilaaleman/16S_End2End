# How to set pipeline parameters?
## - FastQC -
1.  FastQC obtain the input files defined in `sample_sheet.csv`

2.  Outputs go to `results/fastqc/raw/`

3.  The report generated will help you to define downstream decisions

## - Fastp -
Fastp is a tool designed to provide ultrafast preprocessing and quality control for Fastq data. You can modify this values directly on the shell script on `workflows/rules/fastp.smk`

1. `-e` => filter reads by its average quality score\n

2. `-2` => enable adapter detection for Paired-End data to get ultra-clean data

3. `--correction` => enable base correction in overlapped region (only for Paired-End data)

4. `--json` => json report file name

5. `--html` => html report file name

## - DADA2 -
This step utilizes DADA2 to infer the exact amplicon sequence variants (ASVs) present in each sample.

1. The  `dada2.smk` workflow automatically calculates the optimum truncation length based on a minimum quality score threshold `q_threshold`. You can set this threshold in the `config/config/yaml` file. Default value is = `30`.

2. To ensure robust trimming, the calculation of truncation length uses a sliding window of bases to identify the drop in base quality. The window_size can be modified in the config file. Default is = `5` bases.

3. This step will output the final ASV table, taxonomy assignments, quality profile plots, and error rates plot.

## - Phyloseq -
This step integrated the output from DADA2 with your sample metadata `data/sample_sheet.csv` to perform ecological analyses (alpha and beta diversity) using the `phyloseq` package.

1. The `phyloseq.smk` workflow merges the generated ASV table, taxonomy assignments, and sample metadata sheet into a `phyloseq` object (`ps_object.rbs`).
2. Generates alpha diversity plot based on your specific experimental design. You can modify x-axis groupping (`plot_richness_x_axis`), diversity metrics (`alpha_measures`), and color-coding variable (`alpha_color`) directly in the `config.yaml` files.
3. Computes distance matrices and output an ordination plot using NMDS and Bray-Curtis methods as default.
