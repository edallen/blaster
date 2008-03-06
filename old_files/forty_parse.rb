#!/usr/local/bin/ruby

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