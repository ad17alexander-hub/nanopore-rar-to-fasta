# nanopore-rar-to-fasta
Bash pipeline to extract compressed sequencing reads, perform reference-based alignment, and generate individual FASTA files from Nanopore FASTQ data.


# RAR-to-FASTA Alignment Pipeline

This repository contains a Bash pipeline that processes sequencing data starting from compressed RAR archives and produces individual FASTA files after reference-based alignment.

The workflow is designed for Oxford Nanopore reads but can be adapted to other long-read technologies.

---

## 📌 Pipeline Overview

**Input**
- `.rar` files containing `.fastq.gz` sequencing reads
- A reference genome or marker sequence (`ref.fasta`)

**Output**
- Sorted and indexed BAM file
- A consolidated FASTA file of aligned reads
- Individual FASTA files, renamed using the project folder name as prefix

---

## 🧬 Workflow Steps

1. Extract all `.rar` archives in the working directory  
2. Merge all `.fastq.gz` files into a single FASTQ file  
3. Align reads to a reference using `minimap2`  
4. Convert SAM to BAM, sort, and index  
5. Export aligned reads to FASTA format  
6. Split the FASTA file into individual sequences  
7. Rename split FASTA files using the parent folder name  

---

## 📂 Expected Directory Structure

```text
project_folder/
├── sample1.rar
├── sample2.rar
├── pipeline.sh
└── Consolidado/
    ├── ref.fasta
    ├── merged.fastq
    ├── alignment_sorted.bam
    ├── alignment_sorted.bam.bai
    ├── completeMq.fasta
    └── split_sequencesMq/
        ├── project_folder.part_001.fasta
        ├── project_folder.part_002.fasta
        └── ...
