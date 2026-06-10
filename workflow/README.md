# How to set pipeline parameters?
## - FastQC -
i.  FastQC obtain the input files defined in `sample_sheet.csv`

ii.  Outputs go to `results/fastqc/raw/`

iii.  The report generated will help you to define downstream decisions

## - Fastp -
Fastp is a tool designed to provide ultrafast preprocessing and quality control for Fastq data.

i. `-e` => filter reads by its average quality score\n

ii. `-2` => enable adapter detection for Paired-End data to get ultra-clean data

iii. `--correction` => enable base correction in overlapped region (only for Paired-End data)

iv. `--json` => json report file name

v. `--html` => html report file name

## - DADA2 -
This step utilizes DADA2 to infer the exact amplicon sequence variants (ASVs) present in each sample.

i. The dada2.smk workflow automatically calculates the optimum truncation length based on a minimum quality score threshold `q_threshold`. You can set this threshold in the `config/config/yaml` file. Default value is = `30`.

ii. To ensure robust trimming, the calculation of truncation length uses a sliding window of bases to identify the drop in base quality. The window_size can be modified in the config file. Default is = `5` bases.

iii. This step will output the final ASV table, taxonomy assignments, quality profile plots, and error rates plot.
