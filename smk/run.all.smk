# include the config file
# configfile: "config.yaml"

# Define the ref based on the config file
# Sort of acts like a global variable so you don't need to always type the whole thing
REF = config['params']['ref_fa']
SAMPLE = config['samples']['id']
PWD = config['params']['PWD']

# define a function to return target files based on config settings
def run_all_input(wildcards):
    run_all_files = []
    if config['modules']['quality_control']:
        run_all_files.append("data/multiqc_report.html".format(id = SAMPLE))
    if config['modules']['mapping']:
        run_all_files.append("alns/{id}.sort.bam.bai".format(id = SAMPLE))
        run_all_files.append("alns/{id}.sort.bam".format(id = SAMPLE))
    if config['modules']['sv_detection']:
        run_all_files.append("cuteSV/{id}.cuteSV.vcf".format(id = SAMPLE))
        run_all_files.append("sniffles/{id}.sniffles.vcf".format(id = SAMPLE))
        run_all_files.append("pbsv/{id}.pbsv.vcf".format(id = SAMPLE))
        run_all_files.append("svim/{id}.svim.vcf".format(id = SAMPLE))
        run_all_files.append("merged/{id}.merged.vcf".format(id = SAMPLE))
    return run_all_files


# rule run all, the files above are the targets for snakemake
rule run_all:
    input:
        run_all_input

smk_path = config['params']['smk_path']
include: smk_path+"/mapping.smk"
include: smk_path+"/qc.smk"
include: smk_path+"/sv_calling.smk"
include: smk_path+"/metasv.smk"
