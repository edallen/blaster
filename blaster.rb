#!/usr/local/bin/ruby

# Requires of gems & standard library
require 'rubygems'
require 'bio'
require 'yaml'

# Requires of my own code
require 'bin/my_dna'
require 'bin/blast_hash'
require 'bin/bacterium'

# Requires of own files
## require 'screen'

# blaster.rb
# Ed Allen
# Stanford Genome Technology Center
# Feb 20, 2008

class BlastFlora

  def initialize
    @config = YAML.load_file("config/config.yaml")
    @bacteria_file_path = Pathname.new(@config[:blast_path] + @config[:data_dir] + @config[:bacteria_file])
    @a_bacteria = open(@bacteria_file_path) {|f| YAML.load(f)}
  end
end

blaster = BlastFlora.new()
# Iterate over a_bacteria, making a Bacterium object for each, and telling it to blast itself
blaster.a_bacteria.each do |b|
  bac = Bacterium.new(b.nc_id,b.species,b.genus)
  bac_dir = bac.make_dir()
  bac.blast_hash.write_to_fasta(bac_dir,bac.nc_id)
  bac.blast_human()
  bac.blast_other()
  bac.parse_other()
end




