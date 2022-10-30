# frozen_string_literal: true

require "test_helper"

require "classlist/remove"

class TestClasslistRemove < Minitest::Test
  def test_inherits_from_classlist
    classlist = Classlist::Remove.new("foo")
    assert_kind_of(Classlist, classlist)
  end
end

class TestAddingToClasslist < Minitest::Test
  def test_removes_tokens_from_the_classlist
    classlist = Classlist.new("foo bar baz")
    remove = Classlist::Remove.new("baz foo")

    result = classlist + remove

    assert_equal(Classlist.new("bar"), result)
  end

  def test_ignores_tokens_not_in_the_classlist
    classlist = Classlist.new("foo bar")
    remove = Classlist::Remove.new("something")

    result = classlist + remove

    assert_equal(Classlist.new("foo bar"), result)
  end

  def test_does_not_change_an_empty_classlist
    classlist = Classlist.new("")
    remove = Classlist::Remove.new("something")

    result = classlist + remove

    assert_equal(Classlist.new(""), result)
  end
end
