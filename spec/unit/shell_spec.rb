require 'spec_helper'

describe StringyFi::Shell do
  subject(:shell) { described_class.new }

  context "when no args passed" do
    it "initialises with sample fixture" do
      expect(subject).to be_a(described_class)
      expect(subject.converter.filename).to include("chromatic.xml")
    end
  end
end