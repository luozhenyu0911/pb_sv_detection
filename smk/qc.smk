# This is a Snakemake rule to map reads to a reference genome using minimap2.
import os
import glob
def get_fq(wildcards):
    fq_list = glob.glob(os.path.join(config["fq_path"], config['id']+"*"))
    return fq_list

rule link_fq:
    input:
        get_fq
    output:
        data/read.fq.gz
    rule:
        if len(get_fq) == 1:
            os.symlink(get_fq[0], {output})
        else:
            shell("cat {get_fq} > {output}")

rule fastp_qc:
    input:
        data/read.fq.gz
    output:
        data/read_fastp.html
    params:
        "--html {output}"
    threads: 24
    shell:
        "multiqc -i {input} -o {output}.tmp --thread {threads} --html {params}"
    shell:
        "mv {output}.tmp {output}"

rule multiqc_qc:
    input:
        "data/read_fastp.html"
    output:
        "data/multiqc_report.html"
    params:
        "--outdir {output.dir}"
    threads: 24
    shell:
        "multiqc {input} {params}"