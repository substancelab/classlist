# frozen_string_literal: true

require "benchmark"

$LOAD_PATH.unshift(File.expand_path("../../lib", __dir__))

require "classlist"
require "classlist/add"
require "classlist/remove"
require "classlist/reset"

# Small harness for catching algorithmic regressions (O(n) -> O(n^2) and
# worse), rather than measuring absolute speed. Absolute timings are too
# noisy across machines/CI runners to assert on directly, but the *ratio* of
# runtime between a small and a large input is a reasonably stable signal:
# if it grows much faster than the algorithm's expected order, something
# regressed.
module Bench
  class RegressionError < StandardError; end

  # Times the given block once for `small` and once for `large`, and raises
  # RegressionError unless the runtime scaled roughly as expected.
  #
  # expected_order: the Big-O exponent the operation should scale by, e.g.
  #   1 for O(n), 2 for O(n^2).
  # tolerance: how much slack to allow over the expected ratio before
  #   flagging a regression, to absorb machine noise.
  def self.scale_check(name, small:, large:, expected_order:, tolerance: 2)
    small_time = Benchmark.realtime { yield(small) }
    large_time = Benchmark.realtime { yield(large) }

    size_ratio = large.to_f / small
    max_allowed_ratio = (size_ratio**expected_order) * tolerance
    actual_ratio = small_time.zero? ? 0 : large_time / small_time

    ok = actual_ratio <= max_allowed_ratio

    printf(
      "%-42s n=%-5d %8.4fs  n=%-5d %8.4fs  ratio=%7.2f  max=%7.2f  %s\n",
      name, small, small_time, large, large_time, actual_ratio, max_allowed_ratio,
      ok ? "OK" : "FAIL"
    )

    return if ok

    raise RegressionError,
      "#{name}: time grew #{actual_ratio.round(2)}x for a #{size_ratio.round(2)}x increase in " \
      "input size (expected at most #{max_allowed_ratio.round(2)}x for an O(n^#{expected_order}) " \
      "operation with #{tolerance}x tolerance)"
  end
end
