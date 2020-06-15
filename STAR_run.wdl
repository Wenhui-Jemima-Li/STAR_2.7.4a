version 1.0

workflow STAR_aligner {
  input {
    Int thread
    String genomeDir
    File fastq
    File? fastq2
    Boolean compress
    String outFileNamePrefix
    String genomeDir
    File? sjdbGTFfile
    File? sjdbFileChrStartEnd
    Boolean? sjdbOverhang
    Boolean? sjdbInsertSave
    String? outFilterType
    Int? outFilterMultimapNmax
    Int? alignSJoverhangMin
    Int? alignSJDBoverhangMin
    Int? outFilterMismatchNmax
    Int? outFilterMismatchNoverReadLmax
    Int? alignIntronMin
    Int? alignIntronMax
    Int? alignMatesGapMax  
  }

  call star_align {
    input:
      thread=thread,
      genomeDir=genomeDir,
      fastq=fastq,
      fastq2=fastq2,
      compress=compress,
      outFileNamePrefix=outFileNamePrefix,
      genomeDir=genomeDir,
      sjdbGTFfile=sjdbGTFfile,
      sjdbFileChrStartEnd=sjdbFileChrStartEnd,
      sjdbOverhang=sjdbOverhang,
      sjdbInsertSave=sjdbInsertSave,
      outFilterType=outFilterType,
      outFilterMultimapNmax=outFilterMultimapNmax,
      alignSJoverhangMin=alignSJoverhangMin,
      alignSJDBoverhangMin=alignSJDBoverhangMin,
      outFilterMismatchNmax=outFilterMismatchNmax,
      outFilterMismatchNoverReadLmax=outFilterMismatchNoverReadLmax,
      alignIntronMin=alignIntronMin,
      alignIntronMax=alignIntronMax,
      alignMatesGapMax=alignMatesGapMax,   
  }

  output {
    File star_align_bam=star_align.star_align_bam
  }
}

task star_align {
  input {
    Int thread
    String genomeDir
    File fastq
    File? fastq2
    Boolean compress = true
    String outFileNamePrefix
    String genomeDir
    File? sjdbGTFfile
    File? sjdbFileChrStartEnd
    Boolean? sjdbOverhang
    Boolean? sjdbInsertSave
    String? outFilterType = "BySJout"
    Int? outFilterMultimapNmax = 20
    Int? alignSJoverhangMin = 8
    Int? alignSJDBoverhangMin = 1
    Int? outFilterMismatchNmax = 999
    Int? outFilterMismatchNoverReadLmax = 0.04
    Int? alignIntronMin = 20
    Int? alignIntronMax = 1000000
    Int? alignMatesGapMax = 1000000
  }

  String readFilesIn_tag=if compress then "--readFilesCommand gunzip -c --readFilesIn ${fastq} ~{fastq2}" else "--readFilesIn ${fastq} ~{fastq2}"

  command {
    STAR --runThreadN ${thread} \
         --genomeDir ~{genomeDir} \
         ${readFilesIn_tag} \
         --outSAMtype BAM SortedByCoordinate \
         --outFileNamePrefix ${outFileNamePrefix} \
         ~{"--sjdbGTFfile " + sjdbGTFfile} \
         ~{"--sjdbFileChrStartEnd " + sjdbFileChrStartEnd} \
         ~{"--sjdbOverhang"} \
         ~{"--sjdbInsertSave"} \
         ~{"--outFilterType " + outFilterType} \
         ~{"--outFilterMultimapNmax " + outFilterMultimapNmax} \
         ~{"--alignSJoverhangMin" + alignSJoverhangMin} \
         ~{"--alignSJDBoverhangMin" + alignSJDBoverhangMin} \
         ~{"--outFilterMismatchNmax" + outFilterMismatchNmax} \
         ~{"--outFilterMismatchNoverReadLmax" + outFilterMismatchNoverReadLmax} \
         ~{"--alignIntronMin" + alignIntronMin} \
         ~{"--alignIntronMax" + alignIntronMax}
  }

  runtime {
    docker:"jemimalwh/star:2.7.4a"
  }
  output {
    File star_align_bam="${outFileNamePrefix}.Aligned.sortedByCoord.out.bam"
  }
}
