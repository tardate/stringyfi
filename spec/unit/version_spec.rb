# frozen_string_literal: true

require 'spec_helper'

describe StringyFi do
  it 'has a version' do
    expect(described_class::VERSION).to match(/\d+\.\d+\.\d+/)
  end
end
