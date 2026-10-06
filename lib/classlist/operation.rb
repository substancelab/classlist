# frozen_string_literal: true

require "classlist"

# Classlist::Operations modify the classlist they are added to.
#
# An operation can be followed by other operations, which are applied in order
# after it. Adding to an operation returns a new operation, leaving the
# original unchanged, so an operation can be shared and gives the same result
# every time it is applied.
class Classlist::Operation < Classlist
  def ==(other)
    super && operations == other.operations
  end

  # Returns a new operation that applies this operation followed by other. A
  # plain Classlist, String or Array is added as tokens to add.
  def +(other)
    result = dup
    result.append_operation(other)
    result
  end
  alias_method :add_operation, :+

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

  protected

  # Adds other to the operations applied after this one.
  def append_operation(other)
    other = Classlist.new(other) unless other.is_a?(Classlist)
    @operations << other
  end

  private

  # Changes target by applying this operation and the operations following it.
  def apply_to(target)
    apply_self(target)
    operations.each { |operation| operation.apply(target) }
  end

  # Changes target by applying this operation alone. Subclasses implement this;
  # a plain Classlist::Operation changes nothing.
  def apply_self(target)
  end

  def initialize_copy(source)
    super
    @operations = @operations.dup
  end
end
