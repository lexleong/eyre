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

### Etymology

The [Nullarbor](https://en.wikipedia.org/wiki/Nullarbor_Plain) is a huge treeless plain that spans the area between South Australia and Western Australia. If one were to travel from Adelaide to Nullarbor, one will have to go through [Eyre Peninsula](https://en.wikipedia.org/wiki/Eyre_Peninsula). So a South Australian public health microbiologist has to perform the Eyre pipeline prior to the [Nullarbor pipeline](https://github.com/tseemann/nullarbor) for their bacterial WGS. 

## Disclaimer
This workflow is specific to working in slurm and conda environments. It is used mainly by SA Pathology MID PHL for downstream processing of the whole genome sequencing output.
