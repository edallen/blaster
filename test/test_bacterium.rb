#!/usr/local/bin/ruby
# test_bacterium.rb
require 'rubygems'
require 'bio'
require 'test/unit'
require '../lib/bacterium'


class TestBacterium < Test::Unit::TestCase
  def setup
    @bac = Bacterium.new("NC_000913","Escherichia","coli","K12", false)
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
    assert_equal( @bac.id_name, "NC_000913_E_coli_K12", "id_name() is wrong")
  end

  def test_set_blast_candidate_file_name
    #@blast_candidates_file = @bac_results_dir + @nc_id + "_blast_candidates.fasta"
  end

  def test_make_dir
    @bac.make_dir()
    assert(File.exist?(@bac.bac_results_dir), "Didn't find dir #{@bac.bac_results_dir}")
    assert(File.directory?(@bac.bac_results_dir), "File #{@bac.bac_results_dir} is not a directory.")
  end
  
  def test_blast_other
     # # blast against other blast db segments, output is a results file to parse
     #      @blast_results_path = @bac_results_dir + "#{@nc_id}_blast_results_other.xml"
     #      @db_file = "#{@@config[:other_db_root]}"
     #      self.clear_blast_results_file
     #      self.blast
  end
  
  def test_clear_blast_results_file
    # File.unlink(@blast_results_path) if File.exist?(@blast_results_path)
    #    `touch #{@blast_results_path}`
  end
   
  def test_blast
    # @db_path = Pathname.new("" << @@db_folder_path + @db_file)
    #    `blastall -p blastn -i #{@blast_candidates_file }   -d #{db_path} -m 9  >> #{@blast_results_path} `
    #    puts "Blasted #{@blast_candidates_file} against #{@db_path}"
  end
  
  def test_bin_human
  
  end
  
  def test_parse_other

  end
  
end

