# frozen_string_literal: true
require_relative "test_helper"

SingleCov.covered!

describe ExpiringMemoryStore do
  let(:cache) { ExpiringMemoryStore.new }

  it "has a VERSION" do
    ExpiringMemoryStore::VERSION.must_match /^[\.\da-z]+$/
  end

  describe "#get" do
    it "can read existing" do
      cache.set(:a, 1, expires_in: 10)
      cache.get(:a).must_equal 1
    end

    it "cannot read expired" do
      cache.set(:a, 1, expires_in: -10)
      cache.get(:a).must_be_nil
    end
  end

  describe "#set" do
    it "returns value" do
      cache.set(:a, 1, expires_in: 10).must_equal 1
    end

    it "can set without expires" do
      cache.set(:a, 1).must_equal 1
    end
  end

  describe "#add" do
    it "adds when new" do
      cache.add(:a, 1, expires_in: 10).must_equal true
    end

    it "adds when expired" do
      cache.add(:a, 1, expires_in: -10).must_equal true
      cache.add(:a, 1, expires_in: 10).must_equal true
    end

    it "does not add when existing" do
      cache.add(:a, 1, expires_in: 10).must_equal true
      cache.add(:a, 1, expires_in: 10).must_equal false
    end

    it "does not add when nil exists" do
      cache.add(:a, nil, expires_in: 10).must_equal true
      cache.add(:a, 1, expires_in: 10).must_equal false
    end
  end

  describe "#fetch" do
    it "executes when not found" do
      cache.fetch(:a, expires_in: 1) { 1 }.must_equal 1
      cache.get(:a).must_equal 1
    end

    it "returns when found" do
      cache.set(:a, 1, expires_in: 1)
      cache.fetch(:a, expires_in: 1) { 2 }.must_equal 1
    end

    it "caches nil" do
      cache.fetch(:a, expires_in: 1) { nil }.must_be_nil
      cache.fetch(:a, expires_in: 1) { 1 }.must_be_nil
      cache.get(:a).must_be_nil
    end
  end

  describe "#cleanup" do
    it "removes expired" do
      cache.set(:a, 1, expires_in: -10)
      cache.set(:b, 1, expires_in: 10)
      cache.set(:c, 1, expires_in: -10)
      cache.cleanup.must_equal true # does not leak internal structure
      cache.instance_variable_get(:@data).keys.must_equal [:b]
    end
  end
end
