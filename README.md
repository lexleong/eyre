# Eyre
A snakemake workflow that process fastq files of bacterial pathogens to produce:
1. Sequencing yield (fq), 
2. Species identification (Kraken2), 
3. de novo assemblies (shovill) and their qc (fa)
4. Subtyping (MLST)
5. Antimicrobial resistance profile (abricate)

# Requirements
1. Nullarbor 
It is best to install Nullarbor using conda

```
conda create -n nullarbor nullarbor
```

2. Snakemake

```
conda install snakemake
```

