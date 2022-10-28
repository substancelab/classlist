# frozen_string_literal: true

require_relative "classlist/version"

class Classlist
  class Error < StandardError; end

  attr_reader :entries

  def initialize(entries = [])
    @entries = build_entries(entries)
  end

  def to_a
    entries
  end

  def to_s
    entries.join(" ")
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
    end
  end
end
