require 'rexml/document'
require 'rexml/streamlistener'
include REXML

class BlastListener
  include StreamListener
  def initialize(genus,species,ncid,bac_dir)
    config_path = File.expand_path(File.dirname(__FILE__) + "/../config/config.yaml")
    @config = YAML.load_file(config_path)
    @evalue_threshold = @config[:evalue_threshold].to_f
    puts  "evalue threshold used: #{@evalue_threshold.to_s}"
    
    @a_ignore = @config[:ignore_genera]|[]
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
    # Considering evalue in the binning, along with simple matches to genus and species, have a special case for E coli matching Shigella
    # at genus level, should generalize to use a list of alias genera.
    puts "@genus going into regex: #{@genus}"
    puts "@species going into regex: #{@species}"
    r_genus = Regexp.new("#{@genus}\s")
    puts "r_genus : #{r_genus.to_s}"
    r_species = Regexp.new("\s#{@species}\s")
    puts "r_species : #{r_species.to_s}"
    r_shigella = Regexp.new("Shigella\s")
    r_ignore = Regexp.new("(#{@a_ignore.join("|")})\s")
    puts "r_ignore : #{r_ignore.to_s}"
    other_match = false
    genus_match = false
    species_match = false
    hit_hold = ""
    genus_hold = ""
    @iteration.each do |i|
      #How it was stored in #text:    @iteration[@hit_num] = [@hit_def,@score,@evalue]
      hit_def = i[0]
      if hit_def =~ r_genus then
        if hit_def =~ r_species then
          # do nothing - genus_match defaults to true
          species_match = true
          genus_match = true
        else
          genus_match = true
        end
      elsif @genus == "Escherichia" && hit_def =~ r_shigella
        if genus_hold == "" then
          genus_hold = hit_def
        end
        genus_match = true
      elsif hit_def =~ r_ignore
        # do nothing, ignore this match against unmeaningful genera
      else
        if hit_hold == "" then
          if i[2].to_f  < @evalue_threshold
            hit_hold = hit_def
            other_match = true
          end 
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
      if genus_hold == "" then
        @a_genus_matches<< @iteration_query_def
      else
        @a_genus_matches<< @iteration_query_def + "\t" + genus_hold
      end
      puts @iteration_query_def + " added to genus list"
    else
      # do a no_matches list???
    end
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
