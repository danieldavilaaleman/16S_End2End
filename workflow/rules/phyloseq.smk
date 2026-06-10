rule phyloseq:
    input:
        asv_table_rds = "results/dada2/asv_table.rds",
        taxonomy_rds = "results/dada2/taxonomy.rds",
        metadata = config["sample_sheet"]
    output:
        alpha_plot = "results/phyloseq/alpha_plot.png",
        beta_plot = "results/phyloseq/beta_plot.png",
        ps_object = "results/phyloseq/ps_object.rds"
    params:
        plot_richness_x_axis = config["phyloseq"]["plot_richness_x_axis"],
        plot_richness_measures = config["phyloseq"]["alpha_measures"],
        plot_richness_color = config["phyloseq"]["alpha_color"],
        bar_plot_taxlevel = config["phyloseq"]["tax_level"],
        bar_plot_x_axis = config["phyloseq"]["barPlot_x_axis"]
    conda:
        "../../envs/phyloseq.yaml"
    script:
        "../scripts/phyloseq.R"
