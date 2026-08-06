# frozen_string_literal: true

require_relative "benchmark_helper"

# Regression guard for https://github.com/substancelab/classlist/issues -
# in 1.1.1, Classlist#+ started mutating the receiver and pushing an
# operation onto @operations that was never cleared. Every subsequent call
# to #to_s/#to_a/#== re-resolved the *entire* history of operations, turning
# this common "add a class, render, add another, render" pattern from
# roughly O(n^2) into O(n^3).
Bench.scale_check("incremental + and render on each step", small: 300, large: 2400, expected_order: 2) do |n|
  list = Classlist.new(["base"])
  n.times do |i|
    list += Classlist.new(["c#{i}"])
    list.to_s
  end
end
