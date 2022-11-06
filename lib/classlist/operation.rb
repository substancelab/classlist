# frozen_string_literal: true

require "classlist"

# Classlist::Operations modify the original classlist
class Classlist::Operation < Classlist
  # resolve changes the original classlist
  def resolve(original_classlist)
    resolve_operations(original_classlist)
  end
end
