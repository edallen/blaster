class Bacterium
  require 'yaml'
  
  require 'blast_hash'
  
  config_path = File.expand_path(File.dirname(__FILE__) + "/../config/config.yaml")
  @@config = YAML.load_file(config_path)
  @@data_folder_path = Pathname.new(@@config[:blast_path] + @@config[:data_dir])
  @@results_folder_path = Pathname.new(@@config[:blast_path] + @@config[:results_dir])
  @@db_folder_path = Pathname.new(@@config[:blast_path] + @@config[:db_dir])
  
  def initialize(nc_id,genus,species,strain,fill)
    @blast_results_path = ""
    @date = ""
    @h_blast_candidates_file = ""
    @human_match_path = ""
    @no_human_match_path = ""
    @nc_id = nc_id
    @genus = genus
    @species = species
    @strain = strain
    # The next step takes much longer than it looks, since it makes the fortymers and screens them.
    self.set_dir_name()
    @blast_hash = BlastHash.new(@nc_id,@bac_results_dir)
    @blast_hash.fill() if fill == true
    puts "Bacterium initialized"
  end
  
  attr_accessor :nc_id, :genus, :species, :strain, :blast_hash, :bac_results_dir
  attr_accessor :h_blast_candidates_file, :blast_results_path, :date, :human_match_path, :no_human_match_path
  
  def set_dir_name
    #@date = `date +%F_%H_%M_%S`.chomp
    @date = `date +%F`.chomp
    # keep the dir name in an instance variable for use in other methods
    @bac_results_dir = Pathname.new(@@results_folder_path.to_s + self.id_name() + "_" + @date + "/")
  end
  
  def id_name
    id_name = "" << @nc_id << "_" << @genus[0,1] << "_" << @species << "_" << @strain
  end

  def set_blast_candidate_file_name
    @blast_candidates_file = @bac_results_dir + @nc_id + "_blast_candidates.fasta"
  end

  def make_dir
    # Create the output dir in blast/results/ named for computer and human readability plus timestamp
    #  in case of multiple runs varying conditions.
    begin
      puts "bac results dir: #{@bac_results_dir}"
      if ! File.exist?(@bac_results_dir)
        Dir.mkdir(@bac_results_dir)
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
    @blast_results_path
    a_hum_ext = @@config[:human_db_exts]
    a_hum_ext.each do |ext|
      human_db_file = "#{@@config[:human_db_root]}#{ext}"
      db_path = Pathname.new("" << @@db_folder_path + human_db_file)
      `blastall -p blastn -i #{@h_blast_candidates_file}   -d #{db_path} -m 9  > #{@blast_results_path} `
    end
  end
  
  def bin_human
    # Bin human matches vs non_matched
    @human_match_path = @bac_results_dir + "matched_#{@nc_id}"
    @no_human_match_path = @bac_results_dir + "unmatched_#{@nc_id}"

    # Read in 40mers list. Build array of names, and hash of {name=>sequence}.
    f = File.open(@blast_candidates_file ,"r")
    file_data = f.read
    f.close
    # regex looks for name lines beginning with ">"
    regex = />(\S*)$/
    a_ids = []
    h_sequences = {}
    key = ""
    value = ""

    file_data.each do |line| 
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
    File.open(@blast_results_path) do |file|
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

end