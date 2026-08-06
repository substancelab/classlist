# frozen_string_literal: true

require_relative "benchmark_helper"

# Chaining a lot of + operations and only rendering once at the end - the
# "build once, render once" pattern that should stay cheap even when the
# incremental render-on-every-step pattern (see
# incremental_add_and_render_benchmark.rb) does not.
Bench.scale_check("chained + with a single render at the end", small: 300, large: 2400, expected_order: 2) do |n|
  list = Classlist.new(["base"])
  n.times { |i| list += Classlist.new(["c#{i}"]) }
  list.to_s
end
