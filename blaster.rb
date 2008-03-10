#!/usr/local/bin/ruby

# Ed Allen, Stanford Genome Technology Center, 4 March 2008

# Requires of gems & standard library
require 'rubygems'
require 'bio'
require 'yaml'

# Requires of my own code
require 'lib/my_dna'
require 'lib/blast_flora'
require 'lib/blast_hash'
require 'lib/bacterium'


# Requires of own files
## require 'screen'

# blaster.rb
# Ed Allen
# Stanford Genome Technology Center
# Feb 20, 2008



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




