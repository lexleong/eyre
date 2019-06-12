# Eyre
A snakemake workflow that process fastq files of bacterial pathogens to produce:
1. Sequencing yield (fq), 
2. Species identification (Kraken2), 
3. de novo assemblies (shovill) and their qc (fa)
4. Subtyping (MLST)
5. Antimicrobial resistance profile (abricate)

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

3. SISTR
Installation can be performed according to [sistr_cmd](https://github.com/phac-nml/sistr_cmd).
```
conda create -n sistr sistr_cmd
```
## Workflow

1. Create input folder
```
$ mkdir input
```
2. Create symbolic links from fastq dir

3. Create config.yaml file

The config.yaml file should contains matching sampleID to the fastq files.

```
samples:
- SampleID
- SampleID2

salmonella:
- SampleID

```

4. Run script on sbatch

# Disclaimer
This workflow is specific to working in slurm and conda environments. It is used mainly by SA Pathology MID PHL for downstream processing of the whole genome sequencing output.
