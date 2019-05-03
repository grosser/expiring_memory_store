# frozen_string_literal: true
require "bundler/setup"

require "single_cov"
SingleCov.setup :minitest

require "maxitest/autorun"

require "expiring_memory_store/version"
require "expiring_memory_store"
