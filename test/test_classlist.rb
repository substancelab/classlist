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

class TestClasslistEach < Minitest::Test
  def test_iterates_over_the_entries
    classlist = Classlist.new("foo bar baz")
    result = []
    classlist.each do |token|
      result << token
    end
    assert_equal(["foo", "bar", "baz"], result)
  end
end

class TestClasslistEquality < Minitest::Test
  def test_equal_to_itself
    classlist = Classlist.new("foo bar")
    assert_equal(classlist, classlist)
  end

  def test_equal_to_another_classlist_with_same_tokens
    one = Classlist.new("foo bar")
    other = Classlist.new("foo bar")
    assert_equal(one, other)
  end

  def test_not_equal_to_another_classlist_with_same_tokens_in_different_order
    one = Classlist.new("foo bar")
    other = Classlist.new("bar foo")
    refute_equal(one, other)
  end
end

class TestClassListItem < Minitest::Test
  def test_returns_the_token_at_index
    classlist = Classlist.new("foo bar")
    assert_equal("foo", classlist.item(0))
  end

  def test_returns_nil_if_index_is_greater_than_length
    classlist = Classlist.new("foo bar")
    assert_nil(classlist.item(3))
  end

  def test_returns_nil_if_index_is_lower_than_zero
    classlist = Classlist.new("foo bar")
    assert_nil(classlist.item(-1))
  end
end

class TestClasslistIncludes < Minitest::Test
  def test_returns_true_if_list_contains_the_token
    classlist = Classlist.new("foo bar baz")
    assert(classlist.include?("bar"))
  end

  def test_returns_false_if_list_does_not_contain_the_token
    classlist = Classlist.new("foo bar baz")
    refute(classlist.include?("something"))
  end

  def test_it_is_case_sensitive
    classlist = Classlist.new("this")
    refute(classlist.include?("THIS"))
  end

  def test_aliased_as_contains
    classlist = Classlist.new("foo bar baz")
    assert(classlist.contains("foo"))
  end
end

class TestClasslistLength < Minitest::Test
  def test_returns_the_number_of_tokens
    classlist = Classlist.new("foo bar")
    assert_equal(2, classlist.length)
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

class TestClasslistToggle < Minitest::Test
  def test_it_removes_token_if_it_exists
    classlist = Classlist.new("class anotherclass")
    classlist.toggle("class")
    assert_equal(["anotherclass"], classlist.to_a)
  end

  def test_it_returns_false_if_token_was_removed
    classlist = Classlist.new("class anotherclass")
    refute(classlist.toggle("class"))
  end

  def test_it_adds_token_if_it_does_not_exist
    classlist = Classlist.new("anotherclass")
    classlist.toggle("class")
    assert_equal(["anotherclass", "class"], classlist.to_a)
  end

  def test_it_returns_true_if_token_was_added
    classlist = Classlist.new("anotherclass")
    assert(classlist.toggle("class"))
  end

  def test_force_false_removes_token_if_it_exists
    classlist = Classlist.new("class anotherclass")
    classlist.toggle("class", false)
    assert_equal(["anotherclass"], classlist.to_a)
  end

  def test_force_false_does_not_add_token_if_it_does_not_exist
    classlist = Classlist.new("anotherclass")
    classlist.toggle("class", false)
    assert_equal(["anotherclass"], classlist.to_a)
  end

  def test_force_false_returns_false
    classlist = Classlist.new("anotherclass")
    refute(classlist.toggle("class", false))
  end

  def test_force_true_adds_token_if_it_does_not_exist
    classlist = Classlist.new("anotherclass")
    classlist.toggle("class", true)
    assert_equal(["anotherclass", "class"], classlist.to_a)
  end

  def test_force_true_does_not_add_token_if_it_exist
    classlist = Classlist.new("class anotherclass")
    classlist.toggle("class", true)
    assert_equal(["class", "anotherclass"], classlist.to_a)
  end

  def test_force_true_returns_true
    classlist = Classlist.new("class anotherclass")
    refute(classlist.toggle("class"))
  end

  def test_raises_error_when_token_contains_space
    classlist = Classlist.new("class anotherclass")
    assert_raises(Classlist::ArgumentError) {
      classlist.toggle("with space")
    }
  end
end

class TestClasslistStringRepresentation < Minitest::Test
  def test_it_returns_a_string_that_can_be_used_in_class_attribute
    classlist = Classlist.new("foo bar")
    assert_equal("foo bar", classlist.to_s)
  end
end

class TestClasslistValue < Minitest::Test
  def test_returns_a_string_that_can_be_used_in_class_attribute
    classlist = Classlist.new("foo bar")
    assert_equal("foo bar", classlist.value)
  end
end
