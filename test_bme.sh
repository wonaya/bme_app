#!/bin/bash

#SBATCH -J bme-api
#SBATCH -o bme.%j.out
#SBATCH -e bme.%j.err
#SBATCH -p normal
#SBATCH -N 3
#SBATCH -n 30
#SBATCH -t 01:00:00
#SBATCH -A iPlant-Collabs
#SBATCH --mail-user=jawon@tacc.utexas.edu
#SBATCH --mail-type=end

#input fasta
BAM=/iplant/home/shared/iplantcollaborative/example_data/bismark/bismark_output_bt2.bam
FASTA=/iplant/home/shared/iplantcollaborative/example_data/bismark/genome/chr8.fa

#param
PAIRED=1
# module part
module load samtools
module load bowtie/2.3.2
module load bismark

# Fetch data from iPlant Data Store
#iget -fT $BAM .
iget -fT $FASTA .

ARGS=""
# Build up an ARGS string for the program
ARGS="-multicore 10 "
if [ ${PAIRED} -eq 1 ]; then ARGS="${ARGS} -p "; elif [ ${PAIRED} -eq 0 ]; then ARGS="${ARGS} -s " ; fi

BAM_F=$(basename ${BAM})
FASTA_F=$(basename ${FASTA})

# Run the actual program
bismark_methylation_extractor ${ARGS} --multicore 4 --genome_folder $PWD/${FASTA_F} ${BAM_F}

#rm -Rf ${FASTA_F}
