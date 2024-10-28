#!/bin/bash

# Check if arguments were passed
if [ "$#" -lt 1 ]; then
  echo "Usage: $0 <ruta_benchmark1> <ruta_benchmark2> ... <ruta_benchmarkN>"
  exit 1
fi

# Create directory for results
output_dir="balibase_results/"
mkdir -p "$output_dir"

# Align all sequences of benchmarks passed as arguments
align_sequences() {
  for benchmark_path in "$@"; do
    echo "Processing benchmark: $benchmark_path ..."
    base_benchmark=$(basename "$benchmark_path")
    mkdir -p "$output_dir/$base_benchmark"

    for file in "$benchmark_path"/*.in_tfa; do
      base_name=$(basename "$file" .in_tfa)

      # MAFFT
      mafft --auto "$file" > "$output_dir$base_benchmark/${base_name}_mafft.aln"
      seqret -sequence "$output_dir$base_benchmark/${base_name}_mafft.aln" -outseq "$output_dir$base_benchmark/${base_name}_mafft.msf" -osformat2 msf

      # MUSCLE
      muscle -in "$file" -out "$output_dir$base_benchmark/${base_name}_muscle.aln"
      seqret -sequence "$output_dir$base_benchmark/${base_name}_muscle.aln" -outseq "$output_dir$base_benchmark/${base_name}_muscle.msf" -osformat2 msf

      # ClustalW
      clustalw -infile="$file" -outfile="$output_dir$base_benchmark/${base_name}_clustalw.aln"
      seqret -sequence "$output_dir$base_benchmark/${base_name}_clustalw.aln" -outseq "$output_dir$base_benchmark/${base_name}_clustalw.msf" -osformat2 msf

      # T-Coffee
      #t_coffee -infile="$file" -output=fasta_aln -outfile "$output_dir$base_benchmark/${base_name}_tcoffee.aln"
      #seqret -sequence "$output_dir$base_benchmark/${base_name}_tcoffee.aln" -outseq "$output_dir$base_benchmark/${base_name}_tcoffee.msf" -osformat2 msf

      # POA
      poa -read_fasta "$file" -clustal "$output_dir$base_benchmark/${base_name}_poa.aln" -matrix /usr/share/poa/blosum80.mat
      seqret -sequence "$output_dir$base_benchmark/${base_name}_poa.aln" -outseq "$output_dir$base_benchmark/${base_name}_poa.msf" -osformat2 msf

      # Dialign
      edialign -sequence "$file" -outfile .fasta -outseq "$output_dir$base_benchmark/${base_name}_dialign.aln"
      seqret -sequence "$output_dir$base_benchmark/${base_name}_dialign.aln" -outseq "$output_dir$base_benchmark/${base_name}_dialign.msf" -osformat2 msf

    done
  done
}

extract_auto_line() {
  local result_file="$1"
  local output_tsv="$2"

  # Find the line that starts with "auto"
  local line=$(grep "^auto" "$result_file")

  if [[ -n "$line" ]]; then
    # Extract relevant fields with awk and cut
    local benchmark=$(echo "$line" | awk '{print $2}' | cut -d'/' -f2)
    local sequence=$(echo "$line" | awk '{print $2}' | cut -d'/' -f3)
    local sp=$(echo "$line" | awk '{print $3}')
    local tc=$(echo "$line" | awk '{print $4}')

    # Add the data to the TSV file
    echo -e "$benchmark\t$sequence\t$sp\t$tc" >> "$output_tsv"
  else
    echo "Warning: No 'auto' line found in $result_file"
  fi
}

evaluate_alignments() {
  echo "Evaluating alignments with Bali-score..."

  # Create the TSV file with the header
  local output_tsv="alignment_results.tsv"
  echo -e "benchmark\tsequence\tSP\tTC" > "$output_tsv"

  for benchmark_path in "$@"; do
    local base_benchmark=$(basename "$benchmark_path")

    # Search for MSF files in the benchmark
    for msf_file in "$benchmark_path"*.msf; do
      if [[ ! -f "$msf_file" ]]; then
        echo "Warning: No MSF files found in $benchmark_path"
        continue
      fi

      local msf_name=$(basename "$msf_file" .msf)
      local search_pattern="$output_dir$base_benchmark/${msf_name}_*.msf"
      local matching_files=( $search_pattern )

      if [[ ${#matching_files[@]} -eq 0 ]]; then
        echo "Warning: No alignment found for $msf_name in $output_dir$base_benchmark."
        continue
      fi

      for aln_file in "${matching_files[@]}"; do
        local file_name=$(basename "$aln_file")
        local algorithm="${file_name#*_}"
        algorithm="${algorithm%%.*}"

        local result_file="$output_dir$base_benchmark/${msf_name}_${algorithm}_score.txt"

        echo "Evaluating $aln_file against $msf_file: result $result_file"

        # Run the evaluation with bali_score
        ./BAliBASE_R9/src/bali_score "$msf_file" "$aln_file" -v > "$result_file"

        # Extract the relevant line and add it to the TSV
        extract_auto_line "$result_file" "$output_tsv"

      done
    done
  done

  echo "Results saved to $output_tsv"
}


# Script execution
align_sequences "$@"
evaluate_alignments "$@"

echo "Analysis completed. The results are in $output_dir."