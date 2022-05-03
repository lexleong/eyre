# Eyre
It is a similar workflow as Nullarbor, but it only runs isolate specific analysis. No phylogenetic tree and pangenome analysis will be generated.
A snakemake workflow that process fastq files of bacterial pathogens to produce:
1. Sequencing yield (fq), 
2. Species identification (Kraken2), 
3. de novo assemblies (shovill) and their qc (fa)
4. Subtyping (MLST)
5. Antimicrobial resistance profile (abricate)


### Requirements
It is practically a snakemake workflow with all other softwares from Nullarbor.
1. Nullarbor 

It is best to install [Nullarbor](https://github.com/tseemann/nullarbor) using conda. 

```
$ conda create -n eyre nullarbor
```

2. Snakemake 

The snakemake software should be added to the Nullarbor conda environment
```
$ conda activate eyre
$ conda install snakemake
```

3. Git clone the eyre repository 
```
$ git clone https://github.com/lexleong/eyre/
```

4. Download Kraken2 database

Modification on the Snakefile is required to direct the pipeline script to the directory path containing kraken2 database files (hash.k2d, taxo.k2d, and opts.k2d).

## Workflow

1. Modify the sequencing submission sheet as per the SampleSheet.csv template 

2. Run the bcl2eyre.sh script 
```
$ bcl2eyre.sh [dir]/SampleSheet.csv
```

### Etymology

The [Nullarbor](https://en.wikipedia.org/wiki/Nullarbor_Plain) is a huge treeless plain that spans the area between South Australia and Western Australia. If one were to travel from Adelaide to Nullarbor, one will have to go through [Eyre Peninsula](https://en.wikipedia.org/wiki/Eyre_Peninsula). So a South Australian public health microbiologist has to perform the Eyre pipeline prior to the [Nullarbor pipeline](https://github.com/tseemann/nullarbor) for their bacterial WGS. 

## Disclaimer
This workflow is specific to working in slurm and conda environments. It is used mainly by SA Pathology MID PHL for downstream processing of bacterial whole genome sequencing output.
