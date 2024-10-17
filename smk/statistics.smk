# Separate the sv types from vcf and count the number of each sv type

rule Separate_vcf_sv_types:
    input:
        "cuteSV/{id}.cuteSV.vcf",
        "sniffles/{id}.sniffles.vcf",
        "pbsv/{id}.pbsv.vcf",
        "svim/{id}.svim.vcf",
        "merged/{id}.merged.vcf"
    output:
        "cuteSV/{id}.cuteSV_stat.txt",
        "sniffles/{id}.sniffles_stat.txt",
        "pbsv/{id}.pbsv_stat.txt",
        "svim/{id}.svim_stat.txt",
        "merged/{id}.merged_stat.txt"
    params:
        python3 = config["params"]['python3'],
        src = config["params"]['src']
    run:
        for vcf in input:
            prefix = vcf.split(".")[0] +"."+ vcf.split(".")[1]
            shell("{params.python3} {params.src}/split_vcf_bysvtype.py {vcf} {prefix}")
