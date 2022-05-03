#!/bin/sh

input=${1?Error:no SampleSheet.csv given}

dir=$( dirname $input)

### Load module

source /phe/tools/miniconda3/etc/profile.d/conda.sh

conda activate eyre

### Running bcl2fastq

BCL=$(sbatch --job-name bcl2fastq --mem 100G --ntasks 16 --time 960:00:00 -D /phe/tools/eyre/log/ --wrap "bcl2fastq --sample-sheet $input --runfolder-dir $dir --no-lane-splitting --ignore-missing-bcls --ignore-missing-filter --ignore-missing-positions --output-dir $dir/BaseCalls")

### Create folder
folder=$(awk -F ',' 'FNR == 4 {print $2}' $input)

mkdir -p /scratch/eyre/$folder

cd /scratch/eyre/$folder

### Creating config file
awk -F ',' 'BEGIN{ print "samples:"}; FNR > 21 {if($0 !~/NEG/ && $0 !~/Metagenomic/) print "- " $2|"sort -u"}' $input > config.yaml
awk -F ',' 'BEGIN{ print "negative:"}; ( $0 ~/NEG/ ){print "- " $2 }' $input >> config.yaml

### Create input folder

mkdir -p /scratch/eyre/$folder/input

cd /scratch/eyre/$folder/input

### Pausing following jobs until bcl2fastq started properly

secs=$((30))
while [ $secs -gt 0 ]; do
   echo -ne "Waiting $secs\033[0K\r"
   sleep 1
   : $((secs--))
done

### Create symlinks

for i in `ls $dir/BaseCalls/$folder/*.fastq.gz | cut -f 8 -d "/" | cut -f 1 -d "_" | sort -u`
do 
	ln -fs $dir/BaseCalls/$folder/"$i"_*R1_001.fastq.gz /scratch/eyre/$folder/input/"$i"_R1.fastq.gz
  ln -fs $dir/BaseCalls/$folder/"$i"_*R2_001.fastq.gz /scratch/eyre/$folder/input/"$i"_R2.fastq.gz
done
 
### Load eyre module

source /phe/tools/miniconda3/etc/profile.d/conda.sh

conda activate eyre

## Identify job_id of bcl2fastq on slurm

array=(${BCL// / })
JOBID=${array[3]}

### Running eyre on slurm
sbatch --dependency=afterok:${JOBID} --job-name eyre --mem 100G --ntasks 16 --time 960:00:00 -D /scratch/eyre/$folder/ --wrap "snakemake -j 16 --configfile /scratch/eyre/$folder/config.yaml --snakefile /phe/tools/eyre/scripts/Snakefile"
