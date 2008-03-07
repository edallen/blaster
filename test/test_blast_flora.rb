#!/usr/local/bin/ruby
# test_my_dna.rb
require 'rubygems'
require 'bio'
require 'test/unit'
require '../lib/blast_flora'

class TestBlastFlora < Test::Unit::TestCase
  def test_initialize
    blaster = BlastFlora.new()
    assert_not_nil( blaster.config, "" )
  end
end