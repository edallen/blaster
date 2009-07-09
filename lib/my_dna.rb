# The Blaster project is copyright 2008, 2009, Stanford University, released as open source under the MIT license.
class MyDNA < Bio::Sequence::NA
  def is_gcat?
    self !~ /[^gcat]/i
  end
  
  
  
  def loopback?(win_len)
    # NOTE -- assumption here of minimum unpaired bases in hairpin of 3, holding in variable loop_bend
    # NOTE -- #subseq tests out as being 1-based.
    loop_bend = 3
    loopback = FALSE
    win_start_max = self.length - (win_len * 2) +1 - loop_bend 
    1.upto(win_start_max) do |win_start|
      win_end = win_start + win_len -1
      window = self.subseq(win_start,win_end)
      trail_seq = self.subseq(win_end+1+loop_bend,self.length)
      win_re = window.complement.to_re
      #puts "win_start: #{win_start}   win_end: #{win_end}   trail_seq: #{trail_seq} window: #{window}  win_re: #{win_re.to_s}"
      if trail_seq =~ win_re
        loopback = TRUE
        break
      end
    end
    return loopback
  end
  
  def cg_center?
    self[19..20] =~ /[CGcg][CGcg]/
  end
  
  def run_of_four_bases?
    self =~ /AAAA|TTTT|CCCC|GGGG|aaaa|tttt|cccc|gggg/
  end
  
  def gc_18_to_22?
      # should be true when gc out of the 45-55% range for 40mers
      no_at = self.gsub("A","").gsub("T","").gsub("a","").gsub("t","").length
      (18..22).include?(no_at)
  end
  
  def pass_all_screens?
    loopback_match_length = 8
    
    if ! self.is_gcat?
      return false
    end
    
    if ! self.cg_center?
      #puts "failed cg center"
      return false 
    end

    if self.run_of_four_bases?
      #puts "failed run of 4 bases"
      return false
    end

    if ! self.gc_18_to_22?
      #puts "failed gc 18 to 22"
      return false
    end

    if self.loopback?(loopback_match_length)
      #puts "failed loopback"
      return false
    end
    return true
  end
end