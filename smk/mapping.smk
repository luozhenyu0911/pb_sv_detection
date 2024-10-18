

rule map_reads:
    input:
        fq = "data/read.fq.gz",
        ref = config["params"]["ref_map_fa"]
    output:
        bam = "alns/{id}.sort.bam".format(id=SAMPLE)
    threads:
        config["threads"]
    params:
        readgroup = r'@RG\tID:{0}\tSM:{0}\tPL:{1}'.format(config['samples']['id'],
                                                        config['params']['platform'])
    shell:
        "minimap2 -t {threads} -ax map-hifi --MD -Y -R '{params.readgroup}' {input.ref} {input.fq} | "
        "samtools sort -@ {threads} > {output.bam}"

rule index_bam:
    input:
        bam = "alns/{id}.sort.bam"
    output:
        bai = "alns/{id}.sort.bam.bai"
    threads:
        config["threads"]
    shell:
        "samtools index -@ {threads} {input.bam}"

# calculate depth for the alignment file
rule depth:
    input:
        bam = "alns/{id}.sort.bam",
        bai = "alns/{id}.sort.bam.bai",
        ref = REF
    output:
        "alns/{id}.mosdepth.summary.txt"
    threads:
        config["threads"]
    params:
        prefix = SAMPLE
    shell:
        "mosdepth {params.prefix} {input.bam} -t {threads} -f {input.ref} --fast-mode --no-per-base"
