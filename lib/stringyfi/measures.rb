class StringyFi::Measures < Array
  def shortest_fractional_duration
    result = 1
    each do |measure|
      measure.each do |note|
        result = note.fractional_duration if note.fractional_duration < result
      end
    end
    result
  end

  def octave_range
    lo =  hi = nil
    each do |measure|
      measure.each do |note|
        next if note.rest?
        lo ||= note.octave
        hi ||= note.octave
        lo = note.octave if note.octave < lo
        hi = note.octave if note.octave > hi
      end
    end
    [lo, hi]
  end
end
