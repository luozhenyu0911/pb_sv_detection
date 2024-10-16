#!/usr/bin/env bash
# yhbatch -N 1 -n 24 -p rhenv
source /BIGDATA2/gzfezx_shhli_2/miniconda3/etc/profile.d/conda.sh
conda activate longreads

pwd=
smk=/BIGDATA2/gzfezx_shhli_2/software/script/WGS_SV/run.all.smk

/BIGDATA2/gzfezx_shhli_2/miniconda3/envs/cnvnator/bin/snakemake \
-d $pwd -c 24 -pk --configfile ${pwd}/config.yaml --default-resources tmpdir="\"${pwd}\"" \
-s ${smk} --rerun-triggers mtime > ${pwd}/snakemake.err.txt 2>&1 

# echo "last status $? $(hostname)" |mail -s "job done: $(pwd)" xx.email
