# frozen_string_literal: true

require_relative "benchmark_helper"

Bench.scale_check("#remove with many distinct tokens", small: 500, large: 4000, expected_order: 2) do |n|
  tokens = (0...n).map { |i| "c#{i}" }
  list = Classlist.new(tokens)
  list.remove(tokens)
end
