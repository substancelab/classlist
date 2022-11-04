# frozen_string_literal: true

require "classlist"

# Classlist::Reset is a classlist that removes all tokens from the original
# classlist when merged.
class Classlist::Reset < Classlist
  def merge(original)
    original.entries.replace(entries)
  end
end
