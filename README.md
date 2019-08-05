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
conda create -n nullarbor nullarbor
```

2. Snakemake

```
conda install snakemake
```
3. An executable helper shell script to compile seq_data

```
compile_seq_data.sh

chmod +x compile_seq_data.sh #making the shell script executable
```
4. Kraken database

Modification on the Snakefile is required to direct the pipeline script to the directory path containing kraken2 database files (hash.k2d, taxo.k2d, and opts.k2d).

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

### Etymology

The [Nullarbor](https://en.wikipedia.org/wiki/Nullarbor_Plain) is a huge treeless plain that spans the area between South Australia and Western Australia. If one were to travel from Adelaide to Nullarbor, one will have to go through [Eyre Peninsula](https://en.wikipedia.org/wiki/Eyre_Peninsula). So a South Australian public health microbiologist has to perform the Eyre pipeline prior to the [Nullarbor pipeline](https://github.com/tseemann/nullarbor) for their bacterial WGS. 

## Disclaimer
This workflow is specific to working in slurm and conda environments. It is used mainly by SA Pathology MID PHL for downstream processing of the whole genome sequencing output.
