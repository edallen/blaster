class Bacterium
  require 'yaml'
  @@config = YAML.load_file("../config/config.yaml")
  @@data_folder_path = Pathname.new(@@config[:blast_path] + @@config[:data_dir])
  @@results_folder_path = Pathname.new(@@config[:blast_path] + @@config[:results_dir])
  @@db_folder_path = Pathname.new(@@config[:blast_path] + @@config[:db_dir])
  
  def initialize(nc_id,genus,species,strain)
    @nc_id = nc_id
    @genus = genus
    @species = species
    @strain = strain
    # The next step takes much longer than it looks, since it makes the fortymers and screens them.
    @blast_hash = BlastHash.new(@nc_id)
    @bac_results_dir =""
    @h_blast_candidates_file = ""
  end
  
  def id_name
    @nc_id + "_" + @genus + "_" + @species + "_" + @strain
  end
  
  def candidates_file
     @blast_candidates_file = @bac_results_dir + @nc_id + "_blast_candidates.fasta"
  end
  
  def make_dir
    # Create the output dir in blast/results/ named for computer and human readability plus timestamp
    #  in case of multiple runs varying conditions.
    begin
      date = `date +%F_%H_%M_%S`
      # keep the dir name in an instance variable for use in other methods
      @bac_results_dir = Pathname.new(@@results_folder_path + id_name() + "_" + date)
      Dir.mkdir(@bac_results_dir)
      @blast_candidates_file = @bac_results_dir + @nc_id + "_blast_candidates.fasta"
    end
    rescue  SystemCallError
      $stderr.print "Failed to create results directory:" + $!
      raise
    end
    
  end
  
  def blast_human
    # blast against human blast db segments
    # input is @h_blast_candidates_file
    # intermediate blast results file is @blast_results_path
    # outputs are @h_human_bin and @h_blast_candidates (after subtraction of @h_human_bin)
    
    a_hum_ext = @@config[:human_db_exts]
    a_hum_ext.each do |ext|
      db_path = Pathname.new(@@db_folder_path + @@config[:human_db_root] + a_hum_ext)
      `blastall -p blastn -i #{@h_blast_candidates_file}   -d #{db_path} -m 9  > #{@blast_results_path} `
    end
  end
  
  def bin_human
    # Bin human matches vs non_matched
    # PATCHED IN FROM bin_fortymers.rb NEEDS WORK
    # Setting up all file paths - needs generalization
    nc_id_root = "2946"

    in_file = fortymer_path + "all_NC_00#{nc_id_root}_40mers"
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
  end
  def bin_other
  end
  def bin_genus
  end
  def bin_species
  end
  def parse_other
    # read in results file created in #blast_other
    # decide for each input sequence, whether it falls into the other, genus, or species bin
    # call the appropriate bin routine
    
  end
  def blast_other
    # blast against other blast db segments, output is a results file to parse
    
  end
  def
end