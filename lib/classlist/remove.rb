# frozen_string_literal: true

require "classlist/operation"

# Classlist::Remove is an operation that removes tokens from the original
# classlist when added to it.
class Classlist::Remove < Classlist::Operation
  def merge(original)
    original.entries - entries
  end

  # #resolve changes the original classlist
  def resolve(original)
    entries.each do |entry|
      original.remove(entry)
    end

    super
  end
end
