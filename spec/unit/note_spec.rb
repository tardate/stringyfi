require 'spec_helper'

describe StringyFi::Note do
  let(:name) { 'G' }
  let(:octave) { '4' }
  let(:alter) { nil }
  let(:duration) { 1 }
  let(:duration_type) { "quarter" }
  subject(:note) { described_class.new(name, octave, alter, duration, duration_type) }

  describe "#stringy_durations" do
    subject { note.stringy_durations(shortest_fractional_duration)}
    context "when quarter is shortest" do
      let(:shortest_fractional_duration) { 1/4.0 }
      [
        {duration: 1, duration_type: "quarter", expect: [1, 0, 0, 0]},
        {duration: 2, duration_type: "quarter", expect: [0, 1, 0, 0]},
        {duration: 3, duration_type: "quarter", expect: [0, 1, 0, 0]},
        {duration: 4, duration_type: "quarter", expect: [0, 0, 1, 0]},
        {duration: 5, duration_type: "quarter", expect: [0, 0, 1, 0]},
        {duration: 6, duration_type: "quarter", expect: [0, 0, 1, 0]},
        {duration: 7, duration_type: "quarter", expect: [0, 0, 1, 0]},
        {duration: 1, duration_type: "half",    expect: [0, 1, 0, 0]},
        {duration: 4, duration_type: "half",    expect: [0, 0, 0, 1]},
        {duration: 1, duration_type: "whole",   expect: [0, 0, 1, 0]},
        {duration: 2, duration_type: "whole",   expect: [0, 0, 0, 1]},
      ].each do |options|
        context "and duration=#{options[:duration]}-#{options[:duration_type]}" do
          let(:duration) { options[:duration] }
          let(:duration_type) { options[:duration_type] }
          it "returns expected repeats/remainder" do
            expect(subject).to eql(options[:expect])
          end
        end
      end
    end

    context "when 32nd is shortest" do
      let(:shortest_fractional_duration) { 1/32.0 }
      [
        {duration: 1, duration_type: "32nd",    expect: [1, 0, 0, 0]},
        {duration: 1, duration_type: "quarter", expect: [0, 0, 0, 1]},
      ].each do |options|
        context "and duration=#{options[:duration]}-#{options[:duration_type]}" do
          let(:duration) { options[:duration] }
          let(:duration_type) { options[:duration_type] }
          it "returns expected repeats/remainder" do
            expect(subject).to eql(options[:expect])
          end
        end
      end
    end
  end

  describe "#to_s" do
    subject { note.to_s }
    context "when not altered" do
      it { should eql('G')}
    end
    context "when altered up" do
      let(:alter) { 1 }
      it { should eql('G#')}
    end
    context "when altered down" do
      let(:alter) { -1 }
      it { should eql('Gb')}
    end
  end

  describe "#to_str" do
    subject { note.to_str }
    context "when not altered" do
      it { should eql('4:G:0')}
    end
    context "when altered up" do
      let(:alter) { 1 }
      it { should eql('4:G:1')}
    end
    context "when altered down" do
      let(:alter) { -1 }
      it { should eql('4:G:-1')}
    end
  end

  describe "#<=>" do
    let(:other_name) { name }
    let(:other_octave) { octave }
    let(:other_alter) { alter }
    let(:other_note) { described_class.new(other_name, other_octave, other_alter) }

    subject { note <=> other_note }
    context "when same" do
      it { should eql(0) }
    end
    context "when vary by alter up" do
      let(:other_alter) { 1 }
      it { should eql(-1) }
    end
    context "when vary by octave down" do
      let(:other_octave) { 3 }
      it { should eql(1) }
    end
  end
end
