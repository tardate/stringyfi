# frozen_string_literal: true

require 'nokogiri'

# Main controller for the conversion process
class StringyFi::Converter
  INITIAL_OCTAVE = 1        # setup by the stringy firmware
  OCTAVE_OFFSET = 3         # how many octaves to offset the source

  attr_accessor :filename
  attr_writer :xml_doc

  def initialize(filename)
    self.filename = filename
  end

  def convert!
    $stderr.puts "converting #{filename}.."
    shortest_fractional_duration = measures.shortest_fractional_duration
    $stderr.puts "  shortest_fractional_duration: #{shortest_fractional_duration}"
    $stderr.puts "  octave_range: #{measures.octave_range.inspect}"

    puts score_preamble
    puts score_body(shortest_fractional_duration)
    puts score_coda

    $stderr.puts '.. done.'
  end

  def score_preamble
    <<~PREAMBLE
      ;**************************************************************************
      ;** Title: #{title}
      ;** Tempo: #{tempo}
      ;** Encoded: #{encoding_date} with #{encoding_software}
      ;** Stringyfied: #{Time.now}
      ;**************************************************************************

      \ttstart DemoTune
    PREAMBLE
  end

  def score_coda
    <<~CODA
      \ttrest 8
      \ttstop
    CODA
  end

  def score_body(shortest_fractional_duration)
    lines = []
    current_octave = INITIAL_OCTAVE + OCTAVE_OFFSET
    measures.each_with_index do |measure, measure_index|
      lines << "\t; measure #{measure_index + 1}"
      measure.each do |note|
        unless note.rest?
          if note.octave != current_octave
            delta = note.octave - current_octave
            sign = delta.positive? ? '+' : '-'
            delta.abs.times do
              lines << "\ttoctave #{sign}1"
            end
            current_octave = note.octave
          end
        end
        short_repeats, medium_repeats, long_repeats, very_long_repeats = note.stringy_durations(shortest_fractional_duration)
        if note.rest?
          short_repeats.times     { lines << "\ttrest 1" }
          medium_repeats.times    { lines << "\ttrest 2" }
          long_repeats.times      { lines << "\ttrest 3" }
          very_long_repeats.times { lines << "\ttrest 4" }
        else
          short_repeats.times     { lines << "\ttnote #{note.to_stringy(current_octave)},1,0  ; #{note.to_note_id}" }
          medium_repeats.times    { lines << "\ttnote #{note.to_stringy(current_octave)},2,0  ; #{note.to_note_id}" }
          long_repeats.times      { lines << "\ttnote #{note.to_stringy(current_octave)},3,0  ; #{note.to_note_id}" }
          very_long_repeats.times { lines << "\ttnote #{note.to_stringy(current_octave)},4,0  ; #{note.to_note_id}" }
        end
      end
    end
    lines
  end

  def title
    xml_doc.xpath('//work/work-title').text
  end

  # Simplified - only supports one tempo for the piece
  # assumed for quarter note
  def tempo
    @tempo ||= xml_doc.xpath('//measure/direction/sound/@tempo').to_s.to_i
  end

  def encoding_date
    xml_doc.xpath('//identification/encoding/encoding-date').text
  end

  def encoding_software
    xml_doc.xpath('//identification/encoding/software').text
  end

  def identification
    {
      title: title,
      encoding: {
        date: encoding_date,
        software: encoding_software
      }
    }
  end

  def part_list
    xml_doc.xpath('//part-list/score-part').each_with_object([]) do |part, memo|
      h = {}
      h[:id] = part.attr('id')
      memo << h
    end
  end

  def parts
    xml_doc.xpath('//part')
  end

  # Returns measures for the piece.
  # only converts one part (for now)
  # only includes staff 1
  def measures
    @measures ||= begin
      measures = StringyFi::Measures.new
      part = parts.first
      part.xpath('measure').each_with_index do |part_measure, m|
        measures[m] ||= []
        part_measure.xpath('note').each_with_object(measures[m]) do |note, memo|
          next unless note.xpath('staff').text == '1'
          next unless note.xpath('voice').text == '1'

          pitch = note.xpath('pitch')
          duration = note.xpath('duration').text.to_i
          actual_notes = note.xpath('actual-notes').text.to_i
          normal_notes = note.xpath('normal-notes').text.to_i
          duration = duration * 1.0 * normal_notes / actual_notes if actual_notes.positive? && normal_notes.positive?
          duration_type = note.xpath('type').text
          memo << StringyFi::Note.new(
            pitch.xpath('step').text,
            pitch.xpath('octave').text,
            pitch.xpath('alter').text,
            duration,
            duration_type
          )
        end
      end
      measures
    end
  end

  def measure(measure_id)
    measures[measure_id]
  end

  def xml_doc
    @xml_doc ||= Nokogiri::XML(io_stream)
  end

  def io_stream
    File.open(filename).read
  end
end
