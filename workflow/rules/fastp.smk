rule fastp_trim:
    input:
        fq1 = lambda wc: samples.loc[wc.sample, "fq1"], # samples is the pandas DF - samples.loc indicate take [row label, column name] - wc.sample called the name of the wildcard sample
        fq2 = lambda wc: samples.loc[wc.sample, "fq2"]
    output:
        clean_r1 = "results/fastp/{sample}_clean_R1.fastq.gz",
        clean_r2 = "results/fastp/{sample}_clean_R2.fastq.gz"
    conda:
        "../../envs/fastp.yaml"
    threads: 24
    shell:
        """
        mkdir -p results/fastp/
        fastp -i {input.fq1} -I {input.fq2} -o {output.clean_r1} -O {output.clean_r2} --threads {threads} \
        -e 20 -2 --correction --json {wildcards.sample}.json --html {wildcards.sample}.html
	    """
