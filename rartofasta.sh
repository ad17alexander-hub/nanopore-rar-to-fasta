#!/bin/bash
# =============================================
# Pipeline: from RAR archives to individual FASTA files
# Merges FASTQ files, aligns to a reference,
# and splits aligned sequences into individual FASTA files
# Files are renamed using the parent folder name as prefix
# =============================================

# Current working directory (where .rar files are located)
WORKDIR=$(pwd)

cd "$WORKDIR" || { echo "❌ Unable to access $WORKDIR"; exit 1; }

echo "=== [1/6] Extracting RAR files in $WORKDIR ==="
unrar x '*.rar'

echo "=== [2/6] Merging all fastq.gz files into merged.fastq ==="
cat *.fastq.gz | gunzip -c > merged.fastq

echo "=== [3/6] Creating Consolidado folder and moving merged.fastq ==="
mkdir -p Consolidado
mv merged.fastq Consolidado/

cd "$WORKDIR/Consolidado" || { echo "❌ Unable to access Consolidado"; exit 1; }

# Check for reference fasta
if [ ! -f "ref.fasta" ]; then
  echo "❌ ref.fasta not found in $(pwd)"
  echo "📌 Please copy ref.fasta here before continuing."
  exit 1
fi

echo "=== [4/6] Aligning reads with minimap2 using ref.fasta ==="
minimap2 -ax map-ont ref.fasta merged.fastq > alignment.sam

echo "=== [5/6] Converting SAM to BAM and sorting ==="
samtools view -Sb alignment.sam > alignment.bam
samtools sort alignment.bam -o alignment_sorted.bam
samtools index alignment_sorted.bam

echo "=== [6/6] Generating consolidated FASTA and splitting into individual FASTA files ==="
samtools fasta alignment_sorted.bam > completeMq.fasta
mkdir -p split_sequencesMq
seqkit split -i -O split_sequencesMq completeMq.fasta

# 🔧 Rename split files using the parent directory name as prefix
prefix=$(basename "$WORKDIR")
cd split_sequencesMq
for f in completeMq.part_*; do
    mv "$f" "${prefix}.${f#completeMq.}"
done
cd ..

echo "✅ Pipeline completed successfully."
echo "👉 Individual FASTA files generated in: $WORKDIR/Consolidado/split_sequencesMq"
