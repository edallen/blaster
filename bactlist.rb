#!/usr/local/bin/ruby

# Ed Allen, Stanford Genome Technology Center
# Started May 5, 2008
# Finished May 6, 2008

# Builds bacteria.yaml file from data directory of *.fna files
# Assumes typical fasta headers with space before and after genus and species names and single fasta record per file.

$: << File.expand_path(File.dirname(__FILE__) + "/./lib")
# Ruby library & gem requires
require 'rubygems'
require 'yaml'
require 'pathname'

class BactList
  def initialize
    config_path = File.expand_path(File.dirname(__FILE__) + "/config/config.yaml")
    @config = YAML.load_file(config_path)
    @data_dir_path = Pathname.new(@config[:blast_path] + @config[:data_dir])
    @bacteria_file_path = Pathname.new(@config[:blast_path] + @config[:data_dir] + @config[:bacteria_file])
  end

  def fill_bacteria_array
    @a_bacts = []
    @r_sub = Regexp.new("[\s[:punct:]]")
    Dir.chdir(@data_dir_path)
    Dir.glob("*.fna") do |fn|
      ncid = File.basename(fn,".fna")
      File.open(fn,"r") do |f| 
        line = f.gets.chomp!
        puts line
        a_words = line.split(" ")
        id_block,genus,species,*a_strain = a_words
        strain = (a_strain.join(" ").split(','))[0].gsub(@r_sub,"_")
        puts "strain: " + strain
        @a_bacts<< {:nc_id=>ncid,:genus=>genus,:species=>species,:strain=>strain}
        puts @a_bacts.to_s
      end
    end
  end

  def bact_hash_to_yaml
    File.open(@bacteria_file_path,"w"){|f| YAML.dump(@a_bacts, f)}
  end
end

bl = BactList.new()
bl.fill_bacteria_array
bl.bact_hash_to_yaml