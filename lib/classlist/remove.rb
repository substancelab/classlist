# frozen_string_literal: true

require "classlist"

# Classlist::Remove is a classlist that removes tokens from the original
# classlist when added to it.
class Classlist::Remove < Classlist
  def merge(original)
    original.entries - entries
  end
end
