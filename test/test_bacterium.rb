#!/usr/local/bin/ruby
# test_bacterium.rb
require 'rubygems'
require 'bio'
require 'test/unit'
require '../lib/bacterium'

# MODEL
# class TestLoopback < Test::Unit::TestCase
#   def test_loopback_true
#     dna = MyDNA.new('aaaattttt')
#     assert( dna.loopback?(3), "#{dna} has a loopback" )
#   end
#   
#   def test_loopback_false
#     dna = MyDNA.new('acacacacac')
#     assert_not_nil( dna.loopback?(3), "#{dna} has no loopback" )
#   end
# end