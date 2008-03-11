#!/usr/local/bin/ruby
# test_my_dna.rb
require 'rubygems'
require 'bio'
require 'yaml'
require 'test/unit'
require '../lib/blast_flora'

class TestBlastFlora < Test::Unit::TestCase
  def test_initialize
    blaster = BlastFlora.new()
    assert_not_nil( blaster.config, "BlastFlora initialization failure, nil config" )
    assert( blaster.a_bacteria[0][:nc_id]="NC_000913", "incorrect nc_id" )
    blaster.a_bacteria.each {|a| puts a[:nc_id].to_s}
  end
 
end