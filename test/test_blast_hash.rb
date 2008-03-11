#!/usr/local/bin/ruby
# test_blast_hash.rb
require 'rubygems'
require 'bio'
require 'test/unit'
require '../lib/blast_hash'

class TestBlastHash < Test::Unit::TestCase
  def test_initialize
    # MODEL
    # dna = MyDNA.new('aaaaaaaaatttttttttt')
    #     assert( dna.loopback?(3), "#{dna} has a loopback" )
  end
  def test_read_fasta_file
    # fasta_file_path = Pathname.new(@@config[:blast_path] + @@config[:data_dir] + @nc_id + ".fna")
    #     fasta_txt = ""
    #     File.open(fasta_file_path).each do |line|
    #       fasta_txt << line
    #     end
    #     fasta_txt
  end
  
  def test_write_to_fasta
    # # NEED TO NAME OUTFILE
    #     @fasta_out_file = bac_dir + nc_id + "_blast_candidates.fasta"
    #     out_file = File.open(@fasta_out_file,"w")
    #     self.each{|fas_key,fas_seq| outfile.puts ">" << fas_key; outfile.puts fas_seq }
    #     out_file.close()
  end
end
