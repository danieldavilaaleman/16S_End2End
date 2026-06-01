# Which are the pipeline parameters?
## Step 1 - Fastq
i.  FastQC obtain the input files defined in `sample_sheet.csv`

ii.  Outputs go to `results/fastqc/raw/`

iii.  The report generated will help you to define downstream decisions

## Step 2 - Fastp
Fastp is a tool designed to provide ultrafast preprocessing and quality control for Fastq data.

i) `-e` => filter reads by its average quality score\n

ii) `-2` => enable adapter detection for Paired-End data to get ultra-clean data

iii) `--correction` => enable base correction in overlapped region (only for Paired-End data)

iv) `--json` => json report file name

v) `--html` => html report file name
