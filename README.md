# 🦠 16S_EndToEnd - End-to-End 16S rRNA Amplicon Metagenomics Analysis
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT) ![Static Badge](https://img.shields.io/badge/workflow-Snakemake-green?logo=Snakemake&link=https%3A%2F%2Fsnakemake.github.io) ![Static Badge](https://img.shields.io/badge/Analysis-16S%20Metagenomics-red)


> A reproducible Snakemake workflow for 16S rRNA metagenomic data analysis and visualization.

---

## 📖 Table of Contents

- [Overview](#-overview)
- [What is 16S rRNA gene sequencing?](#-what-is-16s-rrna-gene-sequencing)



---
## 🔬 Overview

Ad-hoc scripting makes microbiome analyses error-prone, difficult to scale and hard to reproduce. To solve this, 16S_EndToEnd uses Snakemake to provide a fully automated and scalable workflow that processes raw 16S sequencing FASTQ files into publication-ready figures.

16S_EndToEnd performs:
- Raw read quality control and trimming using **[FASTQC](https://github.com/s-andrews/fastqc)** and **[fastp](https://github.com/opengene/fastp)**.
- ASV inference using **[DADA2](https://benjjneb.github.io/dada2/)**
- Taxonomic classification against the **[SILVA version 138.2](https://benjjneb.github.io/dada2/training.html)** database.
- Alpha and beta diversity analysis.
- Differential abundance testing with **[MaAsLin3](https://huttenhower.sph.harvard.edu/maaslin3)***

## 📖 What is 16S rRNA gene sequencing?
The 16S rRNA gene is highly conserved in all bacteria and archaea, making it a universal marker to identify microorganisms within a biological sample. The 16S rRNA gene sequencing is a widely used method to study microbial community composition and diversity.
