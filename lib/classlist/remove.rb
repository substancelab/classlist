# frozen_string_literal: true

require "classlist/operation"

# Classlist::Remove is an operation that removes tokens from the original
# classlist when added to it.
class Classlist::Remove < Classlist::Operation
  private

  def apply_self(target)
    target.remove(entries)
  end
end
