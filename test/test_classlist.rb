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

  def test_it_can_be_instantiated_with_nothing
    result = Classlist.new
    assert_instance_of(Classlist, result)
    assert_equal [], result.entries
  end

  def test_it_can_be_instantiated_with_another_classlist
    result = Classlist.new(Classlist.new("this"))
    assert_instance_of(Classlist, result)
    assert_equal ["this"], result.entries
  end
end

class TestClasslistAdd < Minitest::Test
  def test_it_adds_one
    classlist = Classlist.new("original")
    classlist.add("anotherclass")
    assert_equal(["original", "anotherclass"], classlist.to_a)
  end

  def test_it_adds_many
    classlist = Classlist.new("original")
    classlist.add(["this", "anotherclass"])
    assert_equal(["original", "this", "anotherclass"], classlist.to_a)
  end

  def test_it_adds_many_from_string
    classlist = Classlist.new("original")
    classlist.add("this anotherclass")
    assert_equal(["original", "this", "anotherclass"], classlist.to_a)
  end

  def test_it_ignores_existing_tokens
    classlist = Classlist.new("excellent")
    classlist.add("this is excellent")
    assert_equal(["excellent", "this", "is"], classlist.to_a)
  end
end

class TestClasslistArrayRepresentation < Minitest::Test
  def test_it_returns_entries
    classlist = Classlist.new("foo bar")
    assert_equal(["foo", "bar"], classlist.to_a)
  end
end

class TestClasslistReplace < Minitest::Test
  def test_it_replaces_one
    classlist = Classlist.new("class anotherclass")
    classlist.replace("class", "not")
    assert_equal(["not", "anotherclass"], classlist.to_a)
  end

  def test_it_does_nothing_when_token_does_not_exist
    classlist = Classlist.new("class")
    classlist.replace("water", "wine")
    assert_equal(["class"], classlist.to_a)
  end

  def test_it_returns_false_when_token_does_not_exist
    classlist = Classlist.new("class")
    refute(classlist.replace("water", "wine"))
  end

  def test_it_does_not_add_the_new_token_if_it_already_exists
    classlist = Classlist.new("there can be only one")
    classlist.replace("there", "one")
    assert_equal(["can", "be", "only", "one"], classlist.to_a)
  end
end

class TestClasslistRemove < Minitest::Test
  def test_it_removes_one
    classlist = Classlist.new("class anotherclass")
    classlist.remove("class")
    assert_equal(["anotherclass"], classlist.to_a)
  end

  def test_it_removes_many
    classlist = Classlist.new("class anotherclass")
    classlist.remove(["class", "anotherclass"])
    assert_equal([], classlist.to_a)
  end

  def test_it_removes_many_from_string
    classlist = Classlist.new("foo bar baz")
    classlist.remove("foo baz")
    assert_equal(["bar"], classlist.to_a)
  end

  def test_it_ignores_nonexisting_tokens
    classlist = Classlist.new("this is excellent")
    classlist.remove("everything")
    assert_equal(["this", "is", "excellent"], classlist.to_a)
  end
end

class TestClasslistStringRepresentation < Minitest::Test
  def test_it_returns_a_string_that_can_be_used_in_class_attribute
    classlist = Classlist.new("foo bar")
    assert_equal("foo bar", classlist.to_s)
  end
end
