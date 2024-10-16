

rule map_reads:
    input:
        data/read.fq.gz,
        ref = config["ref_map_fa"]
    output:
        bam = "alns/{id}.sort.bam".format(id=config['id'])
    threads:
        threads = config["threads"]
    params:
        readgroup = r'@RG\tID:{0}\tSM:{0}\tPL:{1}'.format(config['samples']['id'],
                                                        config['params']['platform'])
    shell:
        "minimap2 -t ${threads} -ax map-hifi --MD -Y -R '{params.readgroup}' {input.ref} {input.data} | "
        "samtools sort -@ ${threads} > ${output_bam}"

rule index_bam:
    input:
        bam = "alns/{id}.sort.bam".format(id=config['id'])
    output:
        bai = "alns/{id}.sort.bam.bai".format(id=config['id'])
    shell:
        "samtools index {input.bam}"


