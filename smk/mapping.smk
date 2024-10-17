

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
    shell:
        "samtools index {input.bam}"


