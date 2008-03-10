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
  end
end