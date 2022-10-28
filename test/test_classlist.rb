# frozen_string_literal: true

require "test_helper"

require "classlist"

class TestClasslistInitialization < Minitest::Test
  def test_it_can_be_instantiated_with_a_string
    result = Classlist.new("foo bar")
    assert_instance_of(Classlist, result)
    assert_equal ["foo", "bar"], result.entries
  end

  def test_it_can_be_instantiated_with_an_array
    result = Classlist.new(["foo", "bar"])
    assert_instance_of(Classlist, result)
    assert_equal ["foo", "bar"], result.entries
  end

  def test_it_can_be_instantiated_with_nil
    result = Classlist.new(nil)
    assert_instance_of(Classlist, result)
    assert_equal [], result.entries
  end

  def test_it_can_be_instantiated_with_another_classlist
    result = Classlist.new(Classlist.new("this"))
    assert_instance_of(Classlist, result)
    assert_equal ["this"], result.entries
  end
end

class TestClasslistArrayRepresentation < Minitest::Test
  def test_it_returns_entries
    classlist = Classlist.new("foo bar")
    assert_equal(["foo", "bar"], classlist.to_a)
  end
end

class TestClasslistStringRepresentation < Minitest::Test
  def test_it_returns_a_string_that_can_be_used_in_class_attribute
    classlist = Classlist.new("foo bar")
    assert_equal("foo bar", classlist.to_s)
  end
end
