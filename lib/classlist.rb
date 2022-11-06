# frozen_string_literal: true

require "forwardable"

require_relative "classlist/version"

class Classlist
  class ArgumentError < ::ArgumentError; end

  class Error < StandardError; end

  extend Forwardable
  def_delegators :@entries, :each

  attr_reader :entries, :operations

  # Returns the Classlist resulting from adding other to this classlist.
  def +(other)
    result = if other.is_a?(Classlist)
      other.merge(self)
    else
      entries + build_entries(other)
    end

    Classlist.new(result)
  end

  def ==(other)
    return false unless other.is_a?(self.class)

    entries == other.entries
  end

  # Adds the given tokens to the list, omitting any that are already present.
  def add(tokens)
    entries = build_entries(tokens)
    entries.each do |entry|
      self.entries.push(entry) unless self.entries.include?(entry)
    end
  end

  def add_operation(other)
    @operations << other
  end

  def include?(token)
    entries.include?(token)
  end
  alias_method :contains, :include?

  def initialize(entries = [])
    @entries = build_entries(entries)
    @operations = []
  end

  # Returns the item in the list by its index, or null if the index is greater
  # than or equal to the list's length.
  def item(index)
    return nil if index.negative?

    entries[index]
  end

  # An integer representing the number of objects stored in the object.
  def length
    entries.length
  end

  # Returns a list of tokens in this classlist merged with the given classlist.
  def merge(classlist)
    (classlist.entries + entries).uniq
  end

  # Removes the specified tokens from the classlist, ignoring any that are not
  # present.
  def remove(tokens)
    entries = build_entries(tokens)
    entries.each do |entry|
      self.entries.delete(entry)
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
      index = entries.index(old_token)
      entries[index] = new_token
    end

    true
  end

  def to_a
    entries
  end

  def to_s
    entries.join(" ")
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

    if entries.include?(token)
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

  private

  attr_writer :entries

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
end
