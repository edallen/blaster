#!/usr/local/bin/ruby
### RETAINED FOR REFERENCE ONLY -- broken collection partially rewritten from test scripts

#Requires of gems
require 'rubygems'
require 'bio'
# Requires of own files
require 'screen'
# screen_and_blast.rb
# Ed Allen
# Stanford Genome Technology Center
# Feb 20, 2008

class MyDNA < Bio::Sequence::NA
  include Screen
end

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
  def loopback?
    dna = MyDNA.new(self)
    dna.loopback(8)?
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

f_in =  ARGV[0] || "test.fasta"
d_working = Dir.pwd 
d_working << '/'
puts d_working

puts f_in
f = d_working + f_in
d_out = d_working + "40mer_out"
fasta_txt = ""
hash_count = 0
File.open(f).each do |line|
  fasta_txt << line
end

fasta = Bio::FastaFormat.new(fasta_txt)
# should regularize to all caps or all smalls (and adjust the tests for lowercase)

puts "entry_id  " + fasta.entry_id
puts "definition  " + fasta.definition
#p fasta.definition
puts "length  " + fasta.length.to_s
puts "sequence"
myseq = fasta.seq.to_s
h_40mers = {}
good_count = 0
testseq = myseq.slice!(0..39)
puts testseq
while myseq.length > 20
  if hash_count > 0 then
    testseq = testseq[20..39] + myseq.slice!(0..19)
  end
  hash_count = hash_count + 1
  
  myslice = testseq[19..20]
  
  if not myslice =~ /[CG][CG]/
    # puts hash_count.to_s + " has BAD center"
    next
  elsif testseq =~ /AAAA|TTTT|CCCC|GGGG/
    # puts hash_count.to_s + " has a 4 run"
    next
  elsif testseq.gc_out
    # puts hash_count.to_s + " has BAD GC CONTENT"
    next
  elsif testseq.has_loopback2?
    next
  else
    good_count = good_count + 1
    h_40mers[hash_count] = testseq
  end
end
puts "good 40mers so far: " + good_count.to_s

# make subdir of outdir
f_base = File.basename(f)
f_root = f_base.sub(".fasta","")

d_batch = d_out << "/" << f_root << "_40mers"

if not File.exist?(d_batch)
  Dir.mkdir(d_batch)
end
# write a file with a pair of lines for each 
f_out_name = f_root + "_blast_candidates"
h_40mers.each do |key, value| 
  puts "40mer " << key.to_s << ": " << value
  f_out_name = f_root + "_" + key.to_s 
  f_out = "" + d_batch + "/" + f_out_name
  
  File.open(f_out, 'w') do |f_o|
    f_o.puts ">" << f_out_name
    f_o.puts value
  end
end
##h_40mers.each do |key, value| 
##  puts "40mer " << key.to_s << ": " << value
##  f_out_name = f_root + "_" + key.to_s 
##  f_out = "" + d_batch + "/" + f_out_name
##  File.open(f_out, 'w') do |f_o|
##    f_o.puts ">" << f_out_name
##    f_o.puts value
##  end
##end

# Blast against human DB
# need array of DB files
# example: 
# For each bin, write out a fasta formatted collection file in the outpit dir
a_hum_ext = [ '00', '01', '02' ]
file_to_blast = ''
`blastall -p blastn -i all_NC_002946_40mers   -d ../db/FASTA/human_genomic.00 -m 9  > blast_2946.out `
# Bin human matches vs non_matched
# PATCHED IN FROM bin_fortymers.rb NEEDS WORK
# Setting up all file paths - needs generalization
nc_id_root = "2946"
blast_path = "/home/allen/blast"
fortymer_path = blast_path + "/40mer_out/"
all_Neis_path = fortymer_path + "all_NC_00#{nc_id_root}_40mers"
blast_out_path = fortymer_path + "blast_#{nc_id_root}.out"
match_path = fortymer_path + "matched_#{nc_id_root}"
no_match_path = fortymer_path + "unmatched_#{nc_id_root}"

# Read in 40mers list. Build array of names, and hash of {name=>sequence}.
f = File.open(all_Neis_path,"r")
all_Neis_data = f.read
f.close
# regex looks for name lines beginning with ">"
regex = />(\S*)$/
a_ids = []
h_sequences = {}
key = ""
value = ""

all_Neis_data.each do |line| 
  # ID line or sequence line? Hash is keyed by IDs with sequence in values.
  md = regex.match(line)
  if $1 != nil then
    #puts $1
    a_ids << $1
    key = $1
  else
    value = line.chomp
    h_sequences[key] = value
  end
end
#a_ids.each{|id| puts id}

a_query_hits = []
query_regex = /#\sQuery:\s(\S*)$/ 
File.open(blast_out_path) do |file|
  file.each_line do |line|
    md = query_regex.match(line)
    if $1 != nil then
      a_query_hits << $1
      #puts "Query hit: " + $1
    end
  end
end 

a_not_matched = a_ids - a_query_hits
#a_not_matched.each{|i|puts "not matched: " + i }

puts "Number of 40mers blasted: " + a_ids.length.to_s
puts "Number of 40mers showing hits: " + a_query_hits.length.to_s
puts "Number of 40mers not matched: " + a_not_matched.length.to_s

f = File.open(match_path, "w")
a_query_hits.each{|hit|f.puts ">" + hit; f.puts h_sequences[hit]}
f.close

f = File.open(no_match_path, "w")
a_not_matched.each{|miss|f.puts ">" + miss; f.puts h_sequences[miss]}
f.close
# Blast non_matched vs other DB.

# Bin no match

# Bin species only

# Bin genus matches

# Bin other match


