# Eyre
A snakemake workflow that process fastq files of bacterial pathogens to produce:
1. Sequencing yield (fq), 
2. Species identification (Kraken2), 
3. de novo assemblies (shovill) and their qc (fa)
4. Subtyping (MLST)
5. Antimicrobial resistance profile (abricate)


It is a similar workflow as Nullarbor, but it only runs isolate specific analysis. No phylogenetic tree and pangenome analysis will be generated.

### Requirements
1. Nullarbor 

It is best to install [Nullarbor](https://github.com/tseemann/nullarbor) using conda. 

```
$ conda create -n nullarbor nullarbor
```

2. Snakemake 

The snakemake software should be added to the Nullarbor conda environment
```
$ conda activate nullarbor
(nullarbor) $ conda install snakemake
```

3. An executable script to create config file

```
$ cat create_configfile.sh
#!/bin/sh
ls input/*_R1.fastq.gz | cut -f 2 -d "/" | cut -f 1 -d "_" | awk 'BEGIN{ print "samples:"}; ( $0 !~ /NEG/ ){print "- " $0 }' > config.yaml
echo "This script will remove Negative controls with string "NEG" within their IDs. If it is something else, manually remove the sample from the config.yaml file"

$ chmod +x create_configfile.sh
```

4. An executable script for compiling sequencing yield (fa) results
*NOTE: The Eyre pipeline will look for the compile_seq_data.sh from the sacgf.ersa.edu:/data/sacgf/microbio/lleong/commands/ directory. If it is used on a different server, please change this directory in the eyre snakefile
```
$ cat compile_seq_data.sh
#!/bin/sh
input=${@?Error:no input given}
awk 'BEGIN{ print "#Acession\tReads\tYield\tGeeCee\tMinLen\tAvgLen\tMaxLen\tModeLen\tPhred\tAvgQual"}; {print $2}' $input | tr '\n' '\t' | sed $'s/input/\\\n&/g' | sed 's/input\///g;s/_R1.fastq.gz//g' | sed -e '$a\'

$ chmod +x compile_seq_data.sh
```
5. An executable script for compiling Kraken results
```
$ cat compile_kraken.sh
#!/bin/sh
input=${@?Error:no input given}
awk 'BEGIN{ print "#FILE\tSpecies Identification\tPercentage"}; ($4=="S" && $1>=20) {print FILENAME "\t" $6 " " $7 "\t" $1}' $input > kraken_raw.tab
mkdir kraken
tail -n +2 kraken_raw.tab | awk 'BEGIN { FS="\t" } { c[$1]++; l[$1,c[$1]]=$0 } END { for (i in c) { if (c[i] > 1) for (j = 1; j <= c[i]; j++) print l[i,j]>"kraken/failed.out" } }; {name=$2; gsub(/[ ]/, "_", name); print>"kraken/"name".tab";}'

$ chmod +x compile_kraken.sh
```

6. Kraken database

Modification on the Snakefile is required to direct the pipeline script to the directory path containing kraken2 database files (hash.k2d, taxo.k2d, and opts.k2d).

7. Slurm job submitting file (conda-eyre.sub)

```
#!/bin/bash

### Job Name
#SBATCH --job-name=eyre

### Set email type for job
### Accepted options: NONE, BEGIN, END, FAIL, ALL
#SBATCH --mail-type=ALL

### email address for user
#SBATCH --mail-user=[username.email.com]
### Queue name that job is submitted to
#SBATCH --partition=[your batch]

### Request nodes
#SBATCH --ntasks=16
#SBATCH --mem=50gb
#SBATCH --time=5:00:00

echo Running on host `hostname`
echo Time is `date`

#module(s) if required module load application_module
source ~/miniconda3/etc/profile.d/conda.sh
conda activate nullarbor


snakemake -j 16 --snakefile [/path/to/your/snakemake/Snakefile] --configfile [/path/to/your/config.yaml]
```

## Workflow

1. Create input folder
```
$ mkdir input
```
2. Create symbolic links from fastq dir
```
ln -s /path/to/your/file/filename_R1.fastq.gz ./input/filename_R1.fastq.gz

ln -s /path/to/your/file/filename_R2.fastq.gz ./input/filename_R1.fastq.gz
```

3. Create config.yaml file
```
bash create_configfile.sh
```

The config.yaml file should contains matching sampleID to the fastq files.

```
samples:
- SampleID
- SampleID2
```

4. Run script on sbatch

```
$ sbatch -x sacgf conda-eyre.sub
```

### Etymology

The [Nullarbor](https://en.wikipedia.org/wiki/Nullarbor_Plain) is a huge treeless plain that spans the area between South Australia and Western Australia. If one were to travel from Adelaide to Nullarbor, one will have to go through [Eyre Peninsula](https://en.wikipedia.org/wiki/Eyre_Peninsula). So a South Australian public health microbiologist has to perform the Eyre pipeline prior to the [Nullarbor pipeline](https://github.com/tseemann/nullarbor) for their bacterial WGS. 

## Disclaimer
This workflow is specific to working in slurm and conda environments. It is used mainly by SA Pathology MID PHL for downstream processing of the whole genome sequencing output.
