# frozen_string_literal: true

require "test_helper"

require "classlist/add"

class TestClasslistAdd < Minitest::Test
  def test_inherits_from_classlist
    classlist = Classlist::Add.new("foo")
    assert_kind_of(Classlist, classlist)
  end
end

class TestAddingToClasslist < Minitest::Test
  def test_adds_tokens_to_the_classlist
    classlist = Classlist.new("foo bar")
    add = Classlist::Add.new("baz")

    result = classlist + add

    assert_equal(Classlist.new("foo bar baz"), result)
  end

  def test_ignores_tokens_already_in_the_classlist
    classlist = Classlist.new("foo bar")
    add = Classlist::Add.new("foo something")

    result = classlist + add

    assert_equal(Classlist.new("foo bar something"), result)
  end

  def test_adds_to_an_empty_classlist
    classlist = Classlist.new("")
    add = Classlist::Add.new("something")

    result = classlist + add

    assert_equal(Classlist.new("something"), result)
  end
end
