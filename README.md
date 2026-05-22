# 16S_EndToEnd - End-to-End 16S rRNA Amplicon Metagenomics Analysis
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT) ![Static Badge](https://img.shields.io/badge/workflow-Snakemake-green?logo=Snakemake&link=https%3A%2F%2Fsnakemake.github.io) ![Static Badge](https://img.shields.io/badge/Analysis-16S%20Metagenomics-red)


A reproducible Snakemake workflow for 16S rRNA metagenomic data analysis and visualization.

---

## 📖 Table of Contents

- [Overview](#-overview)
- [What is 16S rRNA gene sequencing?](#-what-is-16s-rrna-gene-sequencing)
- [Biological Question](#-biological-question)
- [Dataset](#-dataset)
- [Snakemake pipeline summary](#-snakemake-pipeline-summary)
- [Requirements and instalation](#-requirements-and-installation)
- [Usage](#-usage)
- [Author](#-author)

---
## 🔬 Overview

Ad-hoc scripting makes microbiome analyses error-prone, difficult to scale and hard to reproduce. To solve this, 16S_EndToEnd uses Snakemake to provide a fully automated and scalable workflow that processes raw 16S sequencing FASTQ files into publication-ready figures.

16S_EndToEnd performs:
- Raw read quality control and trimming using **[FASTQC](https://github.com/s-andrews/fastqc)** and **[fastp](https://github.com/opengene/fastp)**.
- ASV inference using **[DADA2](https://benjjneb.github.io/dada2/)**
- Taxonomic classification against the **[SILVA version 138.2](https://benjjneb.github.io/dada2/training.html)** database.
- Alpha and beta diversity analysis.
- Phylogenetic tree generation using **[MAFFT](https://github.com/GSLBiotech/mafft)** and **[FastTree](https://github.com/morgannprice/fasttree)**
- Differential abundance testing with **[MaAsLin3](https://huttenhower.sph.harvard.edu/maaslin3)**.
- Visualizations generations.

## 📖 What is 16S rRNA gene sequencing?
The 16S rRNA gene is highly conserved in all bacteria and archaea, making it a universal marker to identify microorganisms within a biological sample. The 16S rRNA gene sequencing is a widely used method to study microbial community composition and diversity.

##  🧪 Biological question?
As a test for 16S_EndToEnd pipeline I am using publicly available microbiome data to answer the question: How does the gut microbiome composition differ between feeding tolerant and intolerant preterm infants? Data reference from: https://doi.org/10.1099/jmm.0.002138. 

**Note** that 16S_EndToEnd pipeline was developed to work on every 16S Amplicon sequencing data so you can use it with condifence 🧑‍💻

This analysis focus on extends the findings from a publicly available study (PRJNA1406357):
- Taxonomic shifts at phylum and genus level.
- Evaluate microbial diversity (alpha diversity).
- Community-level compositional differences (beta diversity).
- Differentially abundant taxa between groups.

## 📊 Dataset
| Information | Details |
|---|---|
| Accession number | [PRJNA1406357](https://www.ncbi.nlm.nih.gov/bioproject/PRJNA1406357) |
| Region | 16S rRNA gene amplicon sequencing targeting the V3-V4 regions |
| Sequencing Platform | Illumina MiSeq (2x250 bp) |
| Samples | 49 (34 from the feeding tolerant group and 15 from the feeding intolerant group) |

Download instructions of the Raw FASTQ files are provided in [`data/README.md`](data/README.md).

## 🐍 Snakemake pipeline summary

```
              Raw FASTQ data
                   |
                   ▼
          Quality Control (FastQC)
                   |
                   ▼
     Adapter and Quality trimming (Fastp)
                   |
                   ▼
      Denoising sequencing data (DADA2)
                   |
                   ▼
     Taxonomic classification (SILVA 138.2)
                   |
                   ▼
     Phylogenetic Tree (MAFFT + FastTree)
                   |
                   ▼
         Diversity Analysis (phyloseq)
                   |
                   ▼
       Differential Abundance (MaAsLin3)
                   |
                   ▼
             Visualization
```
---

## ⚙️ Requirements and installation

### Option 1 — Conda (Recommended)

```bash
# Clone the repository
git clone https://github.com/franciscodanieldavi/16S_EndToEnd.git
cd 16S_EndToEnd

# Create and activate the conda environment
conda env create -f envs/environment.yml
conda activate 16S_EndToEnd
```

### Option 2 — R packages only

```r
# Run from R console
source("envs/r_packages.R")
```

### 🛠️ Dependencies 

| Tool | Version | Analysis |
|---|---|---|
| DADA2 | 1.30 | ASV inference |
| phyloseq | 1.46 | Microbiome data structures & analysis |
| ggplot2 | 3.5 | Visualization |
| fastp | 1.3.3 | Quality control and filtering |
| MAFFT | 7.x | Multiple sequence alignment |
| FastTree | 2.x | Phylogenetic tree inference |
| MaAsLin3 | 3.x | Multivariable association analysis |
| Snakemake | 8.x | Workflow management |

---












## 👤 Author

**Francisco Daniel Davila Aleman**
🔗 GitHub: [@danieldavilaaleman](https://github.com/danieldavilaaleman)

---
## 📄 License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.

