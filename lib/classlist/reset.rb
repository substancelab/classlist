# frozen_string_literal: true

require "classlist/operation"

# Classlist::Reset is an operation that removes all tokens from the original
# classlist when merged.
class Classlist::Reset < Classlist::Operation
  def merge(original)
    original.entries.replace(entries)
  end

  # #resolve changes the original classlist
  def resolve(original)
    original.entries.replace(entries)
  end
end
