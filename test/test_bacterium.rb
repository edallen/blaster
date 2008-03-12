#!/usr/local/bin/ruby
# test_bacterium.rb
require 'rubygems'
require 'bio'
require 'test/unit'
require '../lib/bacterium'


class TestBacterium < Test::Unit::TestCase
  def setup
     @bac = Bacterium.new("NC_000913","Escherichia","coli","K12")
  end
  
  def teardown
  end
  
  def test_initialize
    assert( @bac.nc_id = "NC_000913", "incorrect nc_id" )
    assert( @bac.genus = "Escherichia", "incorrect genus" )
    assert( @bac.species = "coli", "incorrect species" )
    assert( @bac.strain = "K12", "incorrect strain" )
  end
  def test_id_name
    # @nc_id + "_" + @genus + "_" + @species + "_" + @strain
    assert_equal( @bac.id_name, "NC_000913_Escherichia_coli_K12", "id_name() is wrong")
  end
  
  def test_set_blast_candidate_file_name
     #@blast_candidates_file = @bac_results_dir + @nc_id + "_blast_candidates.fasta"
  end
  
  def test_make_dir
    @bac.make_dir()
    assert(File.exist?(@bac_results_dir), "Didn't find dir #{@bac_results_dir}")
    assert(File.directory?(@bac_results_dir), "File #{@bac_results_dir} is not a directory.")
  end
  
end

