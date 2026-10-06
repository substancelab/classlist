# frozen_string_literal: true

require_relative "classlist/version"

class Classlist
  class ArgumentError < ::ArgumentError; end

  class Error < StandardError; end

  # Returns a new Classlist resulting from adding other to this classlist.
  # Neither this classlist nor other are changed.
  #
  # Adding a Classlist::Operation applies the operation. Adding a plain
  # Classlist, String or Array is the same as adding a Classlist::Add with its
  # tokens.
  def +(other)
    result = dup
    if other.is_a?(Classlist)
      other.apply(result)
    else
      result.add(other)
    end
    result
  end
  alias_method :add_operation, :+

  def ==(other)
    other.instance_of?(self.class) && ordered_tokens == other.ordered_tokens
  end

  # Adds the given tokens to the list, omitting any that are already present.
  def add(tokens)
    build_entries(tokens).each do |token|
      @tokens[token] = true
    end
    @ordered_tokens = nil
  end

  def each(&block)
    ordered_tokens.each(&block)
  end

  def entries
    ordered_tokens.dup
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

    ordered_tokens[index]
  end

  # An integer representing the number of objects stored in the object.
  def length
    @tokens.size
  end

  # Returns a list of tokens in this classlist merged with the given classlist.
  def merge(classlist)
    (classlist.entries + entries).uniq
  end

  # Removes the specified tokens from the classlist, ignoring any that are not
  # present.
  def remove(tokens)
    build_entries(tokens).each do |token|
      @tokens.delete(token)
    end
    @ordered_tokens = nil
  end

  # Replaces an existing token with a new token. If the first token doesn't
  # exist, #replace returns false immediately, without adding the new token to
  # the token list.
  def replace(old_token, new_token)
    validate_token(old_token)
    validate_token(new_token)

    return false unless include?(old_token)
    return true if old_token == new_token

    if include?(new_token)
      remove(old_token)
    else
      @tokens = @tokens.to_h { |token, _| [(token == old_token) ? new_token : token, true] }
      @ordered_tokens = nil
    end

    true
  end

  def to_a
    entries
  end

  def to_s
    ordered_tokens.join(" ")
  end
  alias_method :value, :to_s

  # Removes an existing token from the list and returns false. If the token
  # doesn't exist it's added and the function returns true.
  #
  # If force is included, it turns the toggle into a one way-only operation. If
  # set to false, then token will only be removed, but not added. If set to
  # true, then token will only be added, but not removed.
  def toggle(token, force = nil)
    validate_token(token)

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

  # Changes target by applying this classlist to it. Defined only here, so any
  # Classlist can apply any other; subclasses override #apply_to instead.
  def apply(target)
    apply_to(target)
  end

  # Returns the tokens in order as a frozen array, which is built once and
  # reused until the list changes.
  def ordered_tokens
    @ordered_tokens ||= @tokens.keys.freeze
  end

  # Replaces all tokens in the list with the given tokens.
  def reset(tokens)
    @tokens = {}
    add(tokens)
  end

  private

  # Adds the tokens in this classlist to target, so adding a plain Classlist to
  # another acts as a Classlist::Add.
  def apply_to(target)
    target.add(to_a)
  end

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

  def validate_token(token)
    raise ArgumentError, "The token can not contain whitespace." if token.to_s.match?(/\s/)
  end
end
