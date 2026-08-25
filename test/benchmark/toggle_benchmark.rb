# frozen_string_literal: true

require_relative "benchmark_helper"

Bench.scale_check("#toggle with many distinct tokens", small: 500, large: 4000, expected_order: 2) do |n|
  list = Classlist.new
  n.times { |i| list.toggle("c#{i}") }
end
