#!/usr/local/bin/ruby
require 'rubygems'
require 'bio'
require './screen.rb'
# screen_and_blast.rb
# Ed Allen
# Stanford Genome Technology Center
# Feb 20, 2008

class String
 def gc_out
    # should be true when gc out of the 45-55% range for 40mers
    no_at = self.gsub("A","").gsub("T","").length
  
    if no_at < 18 or no_at > 22
      return true
    else
      return false
    end   
  end
 
end

# Read in the arguments for nc_id, genus, species.

# Return usage block if first arg is ? or "help".

# Read in path base from a yaml config file screen_and_blast_config.yaml in the same directory.
# If the config file does not exist, ask for the base path to the blast directory and write it to the file.

# Load paths

# Create output directory for nc_id of if it is not present. Log, report, and quit if failed.
# Write out log file, noting nc_id, genus and species.

# SETUP ERROR CHECKS, WHICH ABORT RUN WITH ERRORS
# Does the input sequence file exist?

# Does the database directory exist?

# Are each of the pertinent DB files there?

# Read in fasta genome file and process as per fasta40.rb

# Blast against human DB

# For each bin, write out a fasta formatted collection file in the outpit dir

# Bin human matches vs non_matched

# Blast non_matched vs other DB.

# Bin no match

# Bin species only

# Bin genus matches

# Bin other match










