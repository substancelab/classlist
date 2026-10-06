# frozen_string_literal: true

require "forwardable"

require_relative "classlist/version"

class Classlist
  class ArgumentError < ::ArgumentError; end

  class Error < StandardError; end

  NO_OPERATIONS = [].freeze
  private_constant :NO_OPERATIONS

  extend Forwardable

  def_delegators :to_a, :each

  # Returns a new Classlist resulting from adding other to this classlist.
  # Neither this classlist nor other are changed.
  #
  # Adding a Classlist::Operation applies the operation, adding a plain
  # Classlist adds its tokens, and adding a String or Array adds the tokens in
  # it.
  def +(other)
    result = dup
    if other.is_a?(Classlist)
      other.apply(result)
    else
      result.add(other)
    end
    result
  end

  def ==(other)
    other.instance_of?(self.class) &&
      to_a == other.to_a &&
      operations == other.operations
  end

  # Adds the given tokens to the list, omitting any that are already present.
  def add(tokens)
    build_entries(tokens).each do |token|
      @tokens[token] = true
    end
  end

  # Applies the given operation to this classlist.
  def add_operation(operation)
    operation.apply(self)
  end

  # Changes target by adding the tokens in this classlist to it. Adding a plain
  # Classlist to another acts as a Classlist::Add.
  def apply(target)
    target.add(to_a)
  end

  def entries
    @tokens.keys
  end

  def include?(token)
    @tokens.key?(token)
  end
  alias_method :contains, :include?

  def initialize(entries = [])
    @tokens = {}
    add(entries)
  end

  # Returns the item in the list by its index, or null if the index is greater
  # than or equal to the list's length.
  def item(index)
    return nil if index.negative?

    entries[index]
  end

  # An integer representing the number of objects stored in the object.
  def length
    @tokens.size
  end

  # Returns a list of tokens in this classlist merged with the given classlist.
  def merge(classlist)
    (classlist.entries + entries).uniq
  end

  # Operations are resolved as soon as they are added to a plain Classlist, so
  # it never has any pending.
  def operations
    NO_OPERATIONS
  end

  # Removes the specified tokens from the classlist, ignoring any that are not
  # present.
  def remove(tokens)
    build_entries(tokens).each do |token|
      @tokens.delete(token)
    end
  end

  # Replaces an existing token with a new token. If the first token doesn't
  # exist, #replace returns false immediately, without adding the new token to
  # the token list.
  def replace(old_token, new_token)
    return false unless include?(old_token)

    if include?(new_token)
      remove(old_token)
    else
      @tokens = @tokens.to_h { |token, _| [(token == old_token) ? new_token : token, true] }
    end

    true
  end

  # Operations are resolved as soon as they are added, so there is nothing left
  # to resolve. Kept for backwards compatibility.
  def resolve_operations(_original_classlist = self)
  end

  def to_a
    entries
  end

  def to_s
    to_a.join(" ")
  end
  alias_method :value, :to_s

  # Removes an existing token from the list and returns false. If the token
  # doesn't exist it's added and the function returns true.
  #
  # If force is included, it turns the toggle into a one way-only operation. If
  # set to false, then token will only be removed, but not added. If set to
  # true, then token will only be added, but not removed.
  def toggle(token, force = nil)
    raise ArgumentError, "The token can not contain whitespace." if token.to_s.include?(" ")

    if include?(token)
      remove(token) unless force == true
      result = false
    else
      add(token) unless force == false
      result = true
    end

    if force.nil?
      result
    else
      force
    end
  end

  protected

  # Replaces all tokens in the list with the given tokens.
  def reset(tokens)
    @tokens = {}
    add(tokens)
  end

  private

  def build_entries(entries)
    case entries
    when Array
      entries
    when Classlist
      entries.entries
    when NilClass
      []
    when String
      entries.split(" ")
    else
      raise Error, "Invalid entries: #{entries.inspect}"
    end.uniq
  end

  def initialize_copy(source)
    super
    @tokens = @tokens.dup
  end
end
