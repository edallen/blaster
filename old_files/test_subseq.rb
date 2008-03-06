#!/usr/bin/env ruby -wKU
# test to see if subseq method of sequence objects is zero based or 1 based for positioning.

#Requires of gems
require 'rubygems'
require 'bio'

seq = Bio::Sequence::NA.new("ATCGGGCCAAATTGGCCAATATATCGCGCG")

#puts "position 0 = " + seq.subseq(0,0)
puts "position 1 = " + seq.subseq(1,1)