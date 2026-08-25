# frozen_string_literal: true

require_relative "benchmark_helper"

Bench.scale_check("#add with many distinct tokens", small: 500, large: 4000, expected_order: 2) do |n|
  list = Classlist.new
  list.add((0...n).map { |i| "c#{i}" })
end
