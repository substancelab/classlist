# frozen_string_literal: true

require "classlist"

# Classlist::Add is a classlist that adds tokens to the original
# classlist when added to it.
class Classlist::Add < Classlist
  def merge(original)
    original.entries + entries
  end
end
