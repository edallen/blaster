require 'rexml/document'
require 'rexml/streamlistener'
include REXML

class BlastListener
  include StreamListener
  def initialize(genus,species,ncid,bac_dir)
      @genus = genus
      @species = species
      @target = "Iter_num"
      @iteration = []
      @iter_num = 0
      @iteration_query_def = ""
      @hit_def = ""
      @score = ""
      @evalue = ""
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
      @hit_num = tag_text
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
      puts "@hit_def: #{@hit_def}, @score: #{@score}, @evalue: #{@evalue}, @hit_num: #{@hit_num}"
      @target = "Hit_def"
    end
  end

  def bin 
    # Doing simplest possible initial binning attempt, not evaluating score or evalue, just binning as a bad match if
    # not matched to both genus and species
    a_species = []
    a_genus = []
    a_other = []
    genus_reg = Regexp.new("^|\s#{@genus}\s")
    species_reg = Regexp.new("\s#{@species}\s")
    genus_match = true
    species_match = true
    @iteration.each do |i|
      puts "i in iteration.each: " + i
      hit_def = i[0]
      if hit_def =~ genus_reg then
        if hit_def =~ species_reg then
          # do nothing - genus_match defaults to true
        else
          species_match = false
        end
      else
        genus_match = false
      end
    end
    if species_match then
      # add to species list
      a_species<< @iteration_query_def
      puts @iteration_query_def + " added to species list"
    elsif genus_match then
      # add to genus list
      a_genus<< @iteration_query_def
      puts @iteration_query_def + " added to genus list"
    else
      # add to other list
      a_other<< @iteration_query_def
      puts @iteration_query_def + " added to other matches list"
    end
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