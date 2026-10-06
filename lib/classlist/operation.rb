# frozen_string_literal: true

require "classlist"

# Classlist::Operations modify the classlist they are added to.
#
# An operation can be followed by other operations, which are applied in order
# after it. Adding to an operation returns a new operation, leaving the
# original unchanged, so an operation can be shared and gives the same result
# every time it is applied.
class Classlist::Operation < Classlist
  # Returns a new operation that applies this operation followed by other. A
  # plain Classlist, String or Array is added as tokens to add.
  def +(other)
    result = dup
    result.add_operation(other)
    result
  end

  # Adds other to the operations applied after this one.
  def add_operation(other)
    other = Classlist.new(other) unless other.is_a?(Classlist)
    @operations << other
  end

  # Changes target by applying this operation and the operations following it.
  def apply(target)
    apply_self(target)
    operations.each { |operation| operation.apply(target) }
  end
  alias_method :resolve, :apply

  def initialize(entries = [])
    super
    @operations = []
  end

  # Returns the tokens resulting from applying this operation to original,
  # without changing original.
  def merge(original)
    result = original.dup
    apply(result)
    result.entries
  end

  attr_reader :operations

  private

  def initialize_copy(source)
    super
    @operations = @operations.dup
  end
end
