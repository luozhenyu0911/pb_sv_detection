# This is a Snakemake rule to map reads to a reference genome using minimap2.
import os
import glob
# def get_fq(wildcards):
#     fq_list = glob.glob(os.path.join(config["samples"]["fq_path"], config["params"]['id']+"*"))
#     return fq_list

# rule link_fq:
#     input:
#         get_fq
#     output:
#         "data/read.fq.gz"
#     params:
#         config["params"]['PWD']
#     rule:
#         if len(get_fq) == 1:
#             shell("ln -s {input} {params}/{output}")
#         else:
#             shell("cat {input} > {params}/{output}")

def get_fq(wildcards):
    fq_list = glob.glob(os.path.join(config["samples"]["fq_path"], config["samples"]['id']+"*.f*q.gz"))
    return fq_list

rule link_fq:
    input:
        get_fq
    output:
        "data/read.fq.gz"
    params:
        config["params"]['PWD']
    shell:
        "ln -s {input} {params}/{output}"

rule fastp_qc:
    input:
        "data/read.fq.gz"
    output:
        "data/{id}.multiqc_report.html"
    params:
        outdir="data",
        filename="{id}.multiqc_report.html"
    threads:
        config['threads']
    shell:
        "source /BIGDATA2/gzfezx_shhli_2/miniconda3/etc/profile.d/conda.sh && "
        "conda activate viromes && "
        "fastqc -t {threads} {input} -o {params.outdir} && multiqc {params.outdir} -o {params.outdir} -n {params.filename} && "
        "conda deactivate"

# rule multiqc_qc:
#     input:
#         "data/{id}.read_fastp.html"
#     output:
#         "data/{id}.multiqc_report.html"
#     params:
#         "--outdir {output.dir}"
#     threads:
#         config['threads']
#     shell:
#         "multiqc {input} {params}"