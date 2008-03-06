#!/usr/local/bin/ruby
# test_my_dna.rb
require 'rubygems'
require 'bio'
require 'test/unit'
require '../lib/my_dna'

class TestLoopback < Test::Unit::TestCase
  def test_loopback_true
    dna = MyDNA.new('aaaattttt')
    assert( dna.loopback?(3), "#{dna} has a loopback" )
  end
  
  def test_loopback_false
    dna = MyDNA.new('acacacacac')
    assert_not_nil( dna.loopback?(3), "#{dna} has no loopback" )
  end
end 

# METHODS NEEDING TESTS
# def cg_center?
#   self[19..20] =~ /[CG][CG]/
# end
# 
# def run_of_four_bases?
#   self =~ /AAAA|TTTT|CCCC|GGGG/
# end
# 
# def gc_18_to_22?
#     # should be true when gc out of the 45-55% range for 40mers
#     no_at = self.gsub("A","").gsub("T","").length
#     (18..22).include?(no_at)
# end
# 
# def pass_all_screens?
#   loopback_match_length = 8
#   return false if ! self.cg_center?
#   return false if self.run_of_four_bases?
#   return false if ! self.gc_18_to_22?
#   return false if self.loopback?(loopback_match_length)
#   return true
# end