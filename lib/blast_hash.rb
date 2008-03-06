class BlastHash < Hash 
  @@config = YAML.load_file("../config/config.yaml")
  @@results_folder_path = Pathname.new(@@config[:blast_path] + @@config[:results_dir])
  def initialize(nc_id)
    @nc_id
    fasta = some_method_on(@nc_id)
    @whole_seq = MyDNA.new(fasta.seq)
    @hash_count = 0
    @good_count = 0
    @test_seq = MyDNA.new(@whole_seq.slice!(0..39))
    puts @test_seq
    while @whole_seq.length > 20
      if @hash_count > 0 then
        @test_seq = @test_seq[20..39] + @whole_seq.slice!(0..19)
      end
      @hash_count = @hash_count + 1
      if @test_seq.pass_all_screens?
        @good_count = @good_count + 1
        self[@hash_count] = @test_seq
      end
    end
  end
  
  def write_to_fasta(bac_dir,nc_id)
    # NEED TO NAME OUTFILE
    @fasta_out_file = bac_dir + nc_id + "_blast_candidates.fasta"
    out_file = File.open(@fasta_out_file,"w")
    self.each{|fas_key,fas_seq| outfile.puts ">" << fas_key; outfile.puts fas_seq }
    out_file.close()
  end

end