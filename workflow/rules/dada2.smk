rule dada2:
    input:
        clean_r1 = expand("results/fastp/{sample}_clean_R1.fastq.gz", sample=SAMPLES), # This expand to create a list of files
        clean_r2 = expand("results/fastp/{sample}_clean_R2.fastq.gz", sample=SAMPLES)
    output:
        asv_table = "results/dada2/asv_table.rds",
        tax_table = "results/dada2/taxonomy.rds"
    params:
        q_threshold = config["dada2"]["q_threshold"],
        window_size = config["dada2"]["window_size"]
    conda:
        "../../envs/dada2.yaml"
    script:
        "../scripts/dada2.R"