class BlastFlora 
  # Ruby library & gem requires
  require 'yaml'
  require 'pathname'
  
  def initialize
    config_path = File.expand_path(File.dirname(__FILE__) + "/../config/config.yaml")
    @config = YAML.load_file(config_path)
    @bacteria_file_path = Pathname.new(@config[:blast_path] + @config[:data_dir] + @config[:bacteria_file])
    @a_bacteria = open(@bacteria_file_path) {|f| YAML.load(f)}
  end
  attr_accessor :config, :bacteria_file_path, :a_bacteria
  
end
