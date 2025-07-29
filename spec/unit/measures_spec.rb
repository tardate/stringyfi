# frozen_string_literal: true

require 'spec_helper'

describe StringyFi::Measures do
  let(:note_class) { StringyFi::Note }
  let(:measures) { described_class.new }

  before do
    measures << [
      note_class.new('G', 4, 1, 1, 'half'),
      note_class.new('G', 2, 0, 1, 'quarter')
    ]
    measures << [
      note_class.new('G', 3, 0, 1, 'whole'),
      note_class.new('A', 4, 0, 1, '32nd'),
      note_class.new('G', 4, 1, 1, 'eighth')
    ]
  end

  describe '#shortest_fractional_duration' do
    subject { measures.shortest_fractional_duration }
    it 'returns the shortest of any note' do
      expect(subject).to eql(1 / 32.0)
    end
  end

  describe '#octave_range' do
    subject { measures.octave_range }
    it 'returns the lowest and highest as an array' do
      expect(subject).to eql([2, 4])
    end
  end
end
