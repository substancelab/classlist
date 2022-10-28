# frozen_string_literal: true

require_relative "classlist/version"

class Classlist
  class Error < StandardError; end

  attr_reader :entries

  # Adds the given tokens to the list, omitting any that are already present.
  def add(tokens)
    entries = build_entries(tokens)
    entries.each do |entry|
      self.entries.push(entry) unless self.entries.include?(entry)
    end
  end

  def initialize(entries = [])
    @entries = build_entries(entries)
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
    return false unless entries.include?(old_token)

    if entries.include?(new_token)
      entries.delete(old_token)
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

  # Removes an existing token from the list and returns false. If the token
  # doesn't exist it's added and the function returns true.
  #
  # If force is included, it turns the toggle into a one way-only operation. If
  # set to false, then token will only be removed, but not added. If set to
  # true, then token will only be added, but not removed.
  def toggle(token, force = nil)
    if entries.include?(token)
      entries.delete(token) unless force == true
      result = false
    else
      entries.push(token) unless force == false
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
    end
  end
end
