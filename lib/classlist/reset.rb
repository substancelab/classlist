# frozen_string_literal: true

require "classlist/operation"

# Classlist::Reset is an operation that removes all tokens from the original
# classlist when merged.
class Classlist::Reset < Classlist::Operation
  private

  def apply_self(target)
    target.reset(entries)
  end
end
