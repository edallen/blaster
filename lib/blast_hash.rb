# The Blaster project is copyright 2008, 2009, Stanford University, released as open source under the MIT license.
class BlastHash < Hash 
  # Ruby library & gem requires
  require 'rubygems'
  require 'bio'
  require 'yaml'
  require 'pathname'
  
  # blaster project requires
  require 'my_dna'
  config_path = File.expand_path(File.dirname(__FILE__) + "/../config/config.yaml")
  @@config = YAML.load_file(config_path)
  @@results_folder_path = Pathname.new(@@config[:blast_path] + @@config[:results_dir])
  
  def initialize(nc_id,bac_results_folder)
    @nc_id = nc_id
    @yaml_path = Pathname.new(bac_results_folder + "#{@nc_id}_blast_hash.yaml")
  end
  
  def fill
    if File.exist?(@yaml_path)
      h_yaml = YAML.load_file(@yaml_path)
      raise "No h_yaml contents to load" if h_yaml.length == 0
      h_yaml.each{|y_key,y_val| self[y_key] = y_val}
    else
      self.fill_from_whole_genome()
      raise "No blast_hash contents to write to file" if self.length == 0
      self.write_to_yaml()
    end
  end
  
  def fill_from_whole_genome
    fasta_txt = self.read_fasta_file()
    fasta = Bio::FastaFormat.new(fasta_txt)
    whole_seq = MyDNA.new(fasta.seq)
    hash_count = 0
    good_count = 0
    if whole_seq.length < 60
      just_one = true
      puts "length: #{whole_seq.length.to_s}" 
    else
      just_one = false
    end
    test_seq = MyDNA.new(whole_seq.slice!(0..39))
    puts ""
    puts "First test_seq in blast_hash:  " + test_seq
    puts "just_one: #{just_one.to_s}"
    
    while just_one | (whole_seq.length > 19) 
      if hash_count > 0 then
        test_seq = test_seq[20..39] + whole_seq.slice!(0..19)
      end
      hash_count = hash_count + 1
      just_one = false
      if test_seq.pass_all_screens?
        # puts "#{test_seq} passed all screens" 
        good_count = good_count + 1
        self[hash_count] = test_seq
      else
        # puts "#{test_seq} failed a screen"
      end
    end
  end
  
  def write_to_yaml
    File.open(@yaml_path, 'w') do |f|
      f << self.to_yaml
    end
  end
  
  def read_fasta_file
    fasta_file_path = Pathname.new(@@config[:blast_path] + @@config[:data_dir] + @nc_id + ".fna")
    fasta_txt = ""
    File.open(fasta_file_path).each do |line|
      fasta_txt << line
    end
    puts 'Read fasta file'
    fasta_txt
  end
  
  def write_to_fasta(bac_dir,nc_id)
    # NEED TO NAME OUTFILE
    raise "empty blasthash for #{nc_id}" if self.length == 0
    @fasta_out_file = bac_dir + "#{nc_id}_blast_candidates.fasta"
    out_file = File.open(@fasta_out_file,"w")
    self.each{|fas_key,fas_seq| out_file.puts ">#{nc_id}_" << fas_key.to_s; out_file.puts fas_seq }
    puts 'wrote fasta file'
    out_file.close()
  end

end