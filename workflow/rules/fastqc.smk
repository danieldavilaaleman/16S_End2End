rule fastqc_raw:
    input:
        fq1 = lambda wc: samples.loc[wc.sample, "fq1"], # samples is the pandas DF - samples.loc indicate take [row label, column name] - wc.sample called the name of the wildcard sample
        fq2 = lambda wc: samples.loc[wc.sample, "fq2"]
    output:
        html_r1 = "results/fastqc/raw/{sample}_R1_fastqc.html",
        html_r2 = "results/fastqc/raw/{sample}_R2_fastqc.html"
    conda:
        "../../envs/fastqc.yaml"
    threads: 24
    shell:
        """
        mkdir -p results/fastqc/raw
        fastqc {input.fq1} {input.fq2} --outdir results/fastqc/raw --threads {threads}
