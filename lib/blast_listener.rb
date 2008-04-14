require 'rexml/document'
require 'rexml/streamlistener'
include REXML

class BlastListener
  include StreamListener
  def initialize(genus,species,ncid,bac_dir)
      @genus = genus
      @species = species
      @ncid = ncid
      @bac_dir = bac_dir
      
      @target = "Iter_num"
      @iteration = []
      @iter_num = 0
      @iteration_query_def = ""
      @hit_def = ""
      @score = ""
      @evalue = ""
      @a_species_matches = []
      @a_genus_matches = []
      @a_other_matches = []
      @h_sequences = {}
  end
  def reset
    # an we dry this up by combining with #initialize in some way
       @target = "Iter_num"
       @iteration = []
       @iter_num = 0
       @iteration_query_def = ""
       @hit_def = ""
       @score = ""
       @evalue = ""
  end
  
  def tag_start(name, attributes)
    #puts "Start #{name}"
    if @target == "Iter_num"
      if name == "Iteration_iter-num" then
        @target = "Iter_num_value"
      end
    elsif @target =="Hit_num"
      if name == "Hit_num" then
        @target = "Hit_num_value"
      end
    elsif @target == "Iteration_query-def" then
      if name == "Iteration_query-def" then
        @target = "Iteration_query-def_value"
      end
    elsif @target == "Hit_def" then
      if name == "Hit_def" then
        @target = "Hit_def_value"
      end
    elsif @target == "Hsp_score" then
      if name == "Hsp_score" then
        @target = "Hsp_score_value"
      end
    elsif @target == "Hsp_evalue" then
      if name == "Hsp_evalue" then
        @target = "Hsp_evalue_value"
      end
     elsif @target == "Hsp_qseq" then
        if name == "Hsp_qseq" then
          @target = "Hsp_qseq_value"
        end
    end
  end
  
  def tag_end(name)
    if name == "Iteration_hits" then
      # It's time to evaluate the iteration for which bin it goes in.
      self.bin()
      self.reset()
    elsif name == "BlastOutput_iterations" then
      # We're done. DO ANYTHING TO EXIT?
      # Or do we even need to check for being done? 
      # Will listener just stop when blast output used up?
    end
  end
  
  def text(tag_text)
    if @target == "Iter_num_value"
      puts "Iteration number: " + tag_text
      @iter_num = (tag_text.to_i) -1
      @target = "Iteration_query-def"
    elsif @target == "Iteration_query-def_value" then
      @iteration_query_def = tag_text
      @target = "Hit_num"
    elsif @target == "Hit_num_value" then
      @hit_num = (tag_text.to_i) -1
      puts "@hit_num: #{@hit_num}"
      @target = "Hit_def"
    elsif @target == "Hit_def_value" then
      @hit_def = tag_text
      @target = "Hsp_score"
    elsif @target == "Hsp_score_value" then
      @score = tag_text
      @target = "Hsp_evalue"
    elsif @target == "Hsp_evalue_value" then
      @evalue = tag_text
      @iteration[@hit_num] = [@hit_def,@score,@evalue]
      puts "@hit_def: #{@hit_def}, @score: #{@score}, @evalue: #{@evalue}, @hit_num: #{@hit_num.to_s}"
      @target = "Hsp_qseq"
    elsif @target == "Hsp_qseq_value"
      #line deleted since this is by match length and not necessarily the full 40, so not too useful to me
      @target = "Hit_num"
    end
  end

  def bin 
    # Doing simplest possible initial binning attempt, not evaluating score or evalue, just binning as a bad match if
    # not matched to both genus and species
    puts "@genus going into regex: #{@genus}"
    puts "@species going into regex: #{@species}"
    genus_reg = Regexp.new("^#{@genus}\s")
    puts "genus_reg : #{genus_reg.to_s}"
    species_reg = Regexp.new("\s#{@species}\s")
    puts "species_reg : #{species_reg.to_s}"
    
    other_match = false
    genus_match = false
    species_match = false
    hit_hold = ""
    @iteration.each do |i|
      #How it was stored in #text:    @iteration[@hit_num] = [@hit_def,@score,@evalue]
      hit_def = i[0]
      if hit_def =~ genus_reg then
        if hit_def =~ species_reg then
          # do nothing - genus_match defaults to true
          species_match = true
          genus_match = true
        else
          genus_match = true
        end
      else
        if hit_hold == "" then
          hit_hold = hit_def
          #
          if i[2]  < 1.0
            other_match = true
          end 
        end
      end
    if other_match then
      # add to other list
      @a_other_matches<< @iteration_query_def + "\t" + hit_hold
      puts @iteration_query_def + " added to other matches list"
    elsif species_match then
      # add to species list
      @a_species_matches<< @iteration_query_def
      puts @iteration_query_def + " added to species list"
    elsif genus_match then
      # add to genus list
      @a_genus_matches<< @iteration_query_def
      puts @iteration_query_def + " added to genus list"
    else
      # do a no_matches list???
    end
    # f = File.open("#{@bac_dir}/#{@ncid}_species_matches", "w")
    #     @a_species_matches.each{|hit|f.puts ">" + hit}
    #     f.close
    #     f = File.open("#{@bac_dir}/#{@ncid}_genus_matches", "w")
    #     @a_genus_matches.each{|hit|f.puts ">" + hit}
    #     f.close
    #     f = File.open("#{@bac_dir}/#{@ncid}_other_matches", "w")
    #     @a_other_matches.each{|hit|f.puts ">" + hit}
    #     f.close
  end
  
  def species_matches
    @a_species_matches
  end
  
  def genus_matches
    @a_genus_matches
  end
  
  def other_matches
    @a_other_matches
  end
  
end

# <Iteration_query-def>NC_913trunc_38</Iteration_query-def>
# <Iteration_hits>   
#   <Hit>
#     <Hit_def>Escherichia coli W3110 DNA, complete genome &gt;gi|85674274|dbj|AP009048.1| Escherichia coli W3110 DNA, complete genome</Hit_def>
#     <Hit_accession>NC_009648
#     <Hit_hsps>
#       <Hsp>
#         <Hsp_evalue>  # or other metric

# Read for <Iteration>
# Read for <Iteration_query-def>
# Take text between tags to be a key
#   Read for <Hit_def>
#      Take the text following and look for Genus and species match
#         If both match, note as possible species match, look at next hit, finishing if </Iteration_hits> met first
#         Else if only genus matches, note as possible genus match, and continue as above
#         Else (no genus match) capture Hsp_evalue, record mismatch to bin_other, start looking for next Iteration_query-def
#         If got to </Iteration_hits> then check genus vs species match level, record to pertinent bin, start looking for next Iteration or </BlastOutput_iterations> and quit
#         

# states
#   Looking for Iteration
#   Looking for Interation_query-def
#   Getting Iteration_query-def value
#   Looking for a Hit_def
#   Getting Hit_def value
#   Found Genus-Species Mismatch
#   Found Genus only match
#   Found Blast_output-iterations, write out and end
#   