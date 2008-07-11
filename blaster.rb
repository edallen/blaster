#!/usr/local/bin/ruby

# Ed Allen, Stanford Genome Technology Center, begun 4 March 2008
# First scratch partial version Feb 20, 2008

$: << File.expand_path(File.dirname(__FILE__) + "/./lib")
# Ruby library & gem requires
require 'rubygems'
require 'bio'
require 'yaml'

# Blaster project requires
require 'my_dna'
require 'blast_flora'
require 'blast_hash'
require 'bacterium'

blaster = BlastFlora.new()
puts "made a BlastFlora object"
# Iterate over a_bacteria, making a Bacterium object for each, and tell it to blast itself.
blaster.a_bacteria.each do |b|
  begin
    bac = Bacterium.new(b[:nc_id],b[:genus],b[:species],b[:strain], true)
    puts "step 2"
    puts "made Bacterium for #{b[:nc_id]} #{b[:genus]} #{b[:species]} #{b[:strain]}"
    puts "step 3"
    bac.set_blast_candidate_file_name()
    puts "set candidate file name"
    bac.blast_hash.write_to_fasta(bac.bac_results_dir,bac.nc_id)
    puts "wrote out candidates file"
    bac.blast_human()
    puts "blasted against human DB"
    bac.bin_human()
    puts "Binned human db blast results"
    bac.blast_other()
    puts "blasted against other DB"
    bac.parse_other()
    puts "parsed and binned other db blast results"
  rescue => error
    puts "Error for this input genome file"
    puts "#{error.class}: #{error.message}"
  end
end




