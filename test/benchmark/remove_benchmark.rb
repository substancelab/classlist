# frozen_string_literal: true

require_relative "benchmark_helper"

# #remove is still O(n) per call (Array#delete has to shift elements), so
# removing n tokens from an n-entry list is O(n^2) - unlike #add/#toggle,
# which the entries Set made effectively O(1) per call.
Bench.scale_check("#remove with many distinct tokens", small: 500, large: 4000, expected_order: 2) do |n|
  tokens = (0...n).map { |i| "c#{i}" }
  list = Classlist.new(tokens)
  list.remove(tokens)
end
