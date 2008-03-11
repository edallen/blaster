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
    assert( @bac.id_name = "NC_000913_Escherichia_coli_K12", "id_name() is wrong")
  end
  
  def test_candidates_file
     #@blast_candidates_file = @bac_results_dir + @nc_id + "_blast_candidates.fasta"
  end
  
  def test_make_dir
    # # Create the output dir in blast/results/ named for computer and human readability plus timestamp
    #     #  in case of multiple runs varying conditions.
    #     begin
    #       date = `date +%F_%H_%M_%S`
    #       # keep the dir name in an instance variable for use in other methods
    #       @bac_results_dir = Pathname.new(@@results_folder_path + id_name() + "_" + date)
    #       Dir.mkdir(@bac_results_dir)
    #       @blast_candidates_file = @bac_results_dir + @nc_id + "_blast_candidates.fasta"
    #     end
    #     rescue  SystemCallError
    #       $stderr.print "Failed to create results directory:" + $!
    #       raise
    #     end
    #     
  end
end

