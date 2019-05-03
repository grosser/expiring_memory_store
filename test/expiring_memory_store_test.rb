# frozen_string_literal: true
require_relative "test_helper"

SingleCov.covered!

describe ExpiringMemoryStore do
  it "has a VERSION" do
    ExpiringMemoryStore::VERSION.must_match /^[\.\da-z]+$/
  end
end
