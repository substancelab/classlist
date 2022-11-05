# frozen_string_literal: true

require "test_helper"

require "classlist/reset"

class TestClasslistReset < Minitest::Test
  def test_inherits_from_classlist
    classlist = Classlist::Reset.new("foo")
    assert_kind_of(Classlist::Operation, classlist)
  end
end

class TestAddingToClasslist < Minitest::Test
  def test_replaces_existing_tokens_in_the_classlist
    classlist = Classlist.new("foo bar baz")
    reset = Classlist::Reset.new("baz foo")

    result = classlist + reset

    assert_equal(Classlist.new("baz foo"), result)
  end

  def test_replaces_an_empty_classlist
    classlist = Classlist.new("")
    reset = Classlist::Reset.new("something")

    result = classlist + reset

    assert_equal(Classlist.new("something"), result)
  end
end
