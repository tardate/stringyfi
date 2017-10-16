class StringyFi::Note

  attr_accessor :name, :octave, :alter
  attr_accessor :tempo
  attr_accessor :fractional_duration

  def initialize(name, octave=4, alter=nil, duration=1, duration_type="quarter")
    self.name = "#{name}".upcase
    self.octave = "#{octave}".to_i
    self.alter = alter.to_i rescue 0
    self.fractional_duration = calculate_fractional_duration(duration, duration_type)
  end

  def rest?
    name == ""
  end

  def calculate_fractional_duration(duration, duration_type)
    divisor = {
      "half" => 2.0,
      "quarter" => 4.0,
      "eighth" => 8.0,
      "16th" => 16.0,
      "32nd" =>  32.0
    }[duration_type] || 1.0
    duration/divisor
  end

  # retrun [short, medium, long, very_long] repeats for the note
  # TODO: scale medium, long, very_long durations correctly
  def stringy_durations(shortest_fractional_duration)
    time_units = (fractional_duration / shortest_fractional_duration).to_i
    case
    when time_units >= 8
      [0, 0, 0, 1]
    when time_units >= 4
      [0, 0, 1, 0]
    when time_units >= 2
      [0, 1, 0, 0]
    else
      [1, 0, 0, 0]
    end
  end

  def to_stringy(current_octave)
    relative_octave = octave - current_octave + 1
    case alter
    when 1
      "#{name}#{relative_octave}S"
    when -1
      sharpy_name = {
        'B' => 'A',
        'E' => 'D',
        'A' => 'G',
        'D' => 'C',
        'G' => 'F',
      }[name]
      "#{sharpy_name}#{relative_octave}S"
    else
      "#{name}#{relative_octave}"
    end
  end

  # Returns the note name, regardless of octave
  def to_note_name
    case alter
    when 1
      "#{name}#"
    when -1
      "#{name}b"
    else
      name
    end
  end

  def to_s
    to_note_name
  end

  # Returns the note ID - unique for each frequency
  def to_note_id
    "#{octave}:#{name}:#{alter}"
  end

  def to_str
    to_note_id
  end

  def inspect
    "\"#{to_str}\""
  end

  def <=>(other)
    self.to_note_id <=> other.to_note_id
  end

end
