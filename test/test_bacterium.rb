#!/usr/local/bin/ruby
# test_bacterium.rb
require 'rubygems'
require 'bio'
require 'test/unit'
require '../lib/bacterium'


class TestBacterium < Test::Unit::TestCase
  def test_initialize
    bac = Bacterium.new("NC00001","Foobaria","snafui","sgtc1")
    assert( bac.genus = "Foobaria", "incorrect genus" )
    assert( bac.nc_id = "NC00001", "incorrect nc_id" )
    assert( bac.species = "snafui", "incorrect species" )
    assert( bac.strain = "sgtc1", "incorrect strain" )
  end
  def test_id_name
    # @nc_id + "_" + @genus + "_" + @species + "_" + @strain
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

