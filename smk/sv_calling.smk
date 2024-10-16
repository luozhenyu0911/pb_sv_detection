# cuteSV calling

rule cuteSV:
    input:
        "bam/{id}.sorted.bam"
    output:
        "cuteSV/{id}.cuteSV.vcf"
    params:
        ref = REF
        outdir = "cuteSV"
    threads:
        24
    shell:
        "cuteSV --genotype --max_cluster_bias_INS  1000 --diff_ratio_merging_INS 0.9 "
        "--max_cluster_bias_DEL 1000 --diff_ratio_merging_DEL 0.5 -t {threads} -s 2 -l 30 "
        "{input} {params.ref} {output} {params.outdir}"

# sniffles calling

rule sniffles:
    input:
        "bam/{id}.sorted.bam"
    output:
        "sniffles/{id}.sniffles.vcf"
    params:
        ref = REF
        outdir = "sniffles"
    threads:
        24
    shell:
        "sniffles --minsvlen 30 -t {threads} -i {input} -v {output}"

# pbsv calling

rule pbsv_step1:
    input:
        bam = "bam/{id}.sorted.bam"
        trf_bed = config['trf_bed']
    output:
        "pbsv/{id}.svsig.gz"
    params:
        ref = REF
        outdir = "pbsv"
    threads:
        24
    shell:
        "pbsv discover {input.bam} {output} --tandem-repeats {input.trf_bed}"

rule pbsv_step2:
    input:
        svsig = "pbsv/{id}.svsig.gz"
    output:
        "pbsv/{id}.pbsv.vcf"
    params:
        ref = REF
        outdir = "pbsv"
    threads:
        24
    shell:
        "pbsv call --gt-min-reads 2 -m 30 --hifi -j {threads} {params.ref} {input.svsig} {output}"

# svim calling

rule svim:
    input:
        "bam/{id}.sorted.bam"
    output:
        "svim/{id}.svim.vcf"
    params:
        ref = REF
        pwd = PWD
        outdir = "svim"
    threads:
        24
    shell:
        "svim alignment --minimum_depth 2 --min_sv_size 30 {params.outdir} {input} {params.ref} && "
        "ln -s  {params.PWD}/{params.outdir}/variants.vcf {params.PWD}/{output} && "

# merge SVs from different callers by SURVIVOR

rule merge_svs:
    input:
        "cuteSV/{id}.cuteSV.vcf",
        "sniffles/{id}.sniffles.vcf",
        "pbsv/{id}.pbsv.vcf",
        "svim/{id}.svim.vcf"
    output:
        "merged/{id}.merged.vcf"
    params:
        SURVIVOR = config['SURVIVOR']
    shell:
        "ls {input} > vcf.list && {params.SURVIVOR} merge vcf.list 1000 2 1 1 0 50 {output}"

