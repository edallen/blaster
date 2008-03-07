class BlastFlora 
  def initialize
    @config = YAML.load_file("config/config.yaml")
    @bacteria_file_path = Pathname.new(@config[:blast_path] + @config[:data_dir] + @config[:bacteria_file])
    @a_bacteria = open(@bacteria_file_path) {|f| YAML.load(f)}
  end
end