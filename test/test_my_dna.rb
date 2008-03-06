#!/usr/local/bin/ruby
# test_my_dna.rb
require 'rubygems'
require 'bio'
require 'test/unit'
require '../lib/my_dna'

class TestMyDNA < Test::Unit::TestCase
  def test_loopback_true
    dna = MyDNA.new('aaaaaaaaatttttttttt')
    assert( dna.loopback?(3), "#{dna} has a loopback" )
    dna = MyDNA.new('AAAAAAAAATTTTTTTTTT')
    assert( dna.loopback?(3), "#{dna} has a loopback" )
    dna = MyDNA.new('cgcgcgcgcgcgcgcgcgcgcgcgcgcgcgcgcgcg')
    assert( dna.loopback?(5), "#{dna} has a loopback" )
    dna = MyDNA.new('CGCGCGCGCGCGCGCGCGCGCGCGCGCGCGCGCGCG')
    assert( dna.loopback?(5), "#{dna} has a loopback" )
  end
  
  def test_loopback_false
    dna = MyDNA.new('acacacacac')
    assert(!dna.loopback?(3), "#{dna} has no loopback" )
  end
  
  def test_cg_center_true
    dna = MyDNA.new('cgcgcgcgcgcgcgcgcgcgcgcgcgcgcgcgcgcgcgcgcgcgcgcgcgcgcgcgcgc')
    assert(dna.cg_center?)
    dna = MyDNA.new('ggggggggggggggggggggggggggggggggggggggggggggggggggg')
    assert(dna.cg_center?)
    dna = MyDNA.new('ccccccccccccccccccccccccccccccccccccccccccccccccccc')
    assert(dna.cg_center?)
    dna = MyDNA.new('CGCGCGCGCGCGCGCGCGCGCGCGCGCGCGCGCGCGCGCGCGCGCGCGCGCGCGCGCGC')
    assert(dna.cg_center?)
    dna = MyDNA.new('GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG')
    assert(dna.cg_center?)
    dna = MyDNA.new('CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC')
    assert(dna.cg_center?)
  end
  
  def test_cg_center_false
     dna = MyDNA.new('cgcgcgcgcgcgcgatatatatatatatatatatatatatatatcgcgcgcgcgcgcgcgcgc')
     assert(!dna.cg_center?)
     dna = MyDNA.new('ggggggggggggttttttttttttttttttttttttgggggggggggggggg')
     assert(!dna.cg_center?)
     dna = MyDNA.new('ccccccccccccaaaaaaaaaaaaaaaaaaaaaaaaaaaccccccccccccc')
     assert(!dna.cg_center?)
     dna = MyDNA.new('CGCGCGCGCGCGCGATATATATATATATATATATATATATATATCGCGCGCGCGCGCGCGCGC')
     assert(!dna.cg_center?)
     dna = MyDNA.new('GGGGGGGGGGGGTTTTTTTTTTTTTTTTTTTTTTTTGGGGGGGGGGGGGGGG')
     assert(!dna.cg_center?)
     dna = MyDNA.new('CCCCCCCCCCCCAAAAAAAAAAAAAAAAAAAAAAAAAAACCCCCCCCCCCCC')
     assert(!dna.cg_center?)
  end
  
  def test_run_of_four_bases
    dna = MyDNA.new('cgcgcgcgcgcgcgatatatatatatatatatatatatatatatcgcgcgcgcgcgcgcgcgc')
    assert(!dna.run_of_four_bases?)
    dna = MyDNA.new('ggggggggggggttttttttttttttttttttttttgggggggggggggggg')
    assert(dna.run_of_four_bases?)
    dna = MyDNA.new('ccccccccccccaaaaaaaaaaaaaaaaaaaaaaaaaaaccccccccccccc')
    assert(dna.run_of_four_bases?)
    dna = MyDNA.new('CGCGCGCGCGCGCGATATATATATATATATATATATATATATATCGCGCGCGCGCGCGCGCGC')
    assert(!dna.run_of_four_bases?)
    dna = MyDNA.new('GGGGGGGGGGGGTTTTTTTTTTTTTTTTTTTTTTTTGGGGGGGGGGGGGGGG')
    assert(dna.run_of_four_bases?)
    dna = MyDNA.new('CCCCCCCCCCCCAAAAAAAAAAAAAAAAAAAAAAAAAAACCCCCCCCCCCCC')
    assert(dna.run_of_four_bases?)
    dna = MyDNA.new('cgcgcgcgcgcgcgatatatatatatatattttatatatatatatcgcgcgcgcgcgcgcgcgc')
    assert(dna.run_of_four_bases?)
  end
  
  def test_gc_18_to_22
    dna = MyDNA.new('CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC')
    assert(!dna.gc_18_to_22?)
    dna = MyDNA.new('cgcgcgcgcgcgcgcgcgcgcgcgcgcgcgcgcgcgcgcg')
    assert(!dna.gc_18_to_22?)
    dna = MyDNA.new('atatatatatatatatatatatatatatatatatatatat')
    assert(!dna.gc_18_to_22?)
    dna = MyDNA.new('atatatatatatatatagcgcgcgcgcgcgcgcgcgcgcg')
    assert(!dna.gc_18_to_22?)
    dna = MyDNA.new('atatatatatatatatatcgcgcgcgcgcgcgcgcgcgcg')
    assert(dna.gc_18_to_22?)
  end
  
  def test_pass_all_screens?
     dna = MyDNA.new('atatatatatatatatatcgcgcgcgcgcgcgcgcgcgcg')
     assert(!dna.pass_all_screens?)
     dna = MyDNA.new('acataagtacatcacgcgcgcgcgcgtgcgtgcgatttat')
     assert(dna.pass_all_screens?)
  end
end 

