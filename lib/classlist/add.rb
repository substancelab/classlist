# frozen_string_literal: true

require "classlist/operation"

# Classlist::Add is an operation that adds tokens to the original
# classlist when added to it.
class Classlist::Add < Classlist::Operation
  def merge(original)
    original.entries + entries
  end

  # resolve changes the original classlist
  def resolve(original)
    entries.each do |entry|
      original.add(entry)
    end

    super
  end
end
