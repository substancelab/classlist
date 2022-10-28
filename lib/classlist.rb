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

  def to_a
    entries
  end

  def to_s
    entries.join(" ")
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
