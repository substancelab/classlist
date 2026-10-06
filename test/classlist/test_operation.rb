# frozen_string_literal: true

require "test_helper"

require "classlist/add"
require "classlist/remove"
require "classlist/reset"

class TestClasslistOperation < Minitest::Test
  def test_add
    base = Classlist.new("foo")
    result = base + Classlist::Add.new("bar")
    assert_equal(["foo", "bar"], result.to_a)
  end

  def test_remove
    base = Classlist.new("this that")
    result = base + Classlist::Remove.new("this")
    assert_equal(["that"], result.to_a)
  end

  def test_reset
    base = Classlist.new("this that")
    result = base + Classlist::Reset.new("something else")
    assert_equal(["something", "else"], result.to_a)
  end

  def test_remove_then_add
    result = Classlist.new("notthis")
    result += Classlist::Remove.new("notthis")
    result += Classlist::Add.new("this")
    assert_equal(["this"], result.to_a)
  end

  def test_add_then_remove
    result = Classlist.new("foo bar")
    result += Classlist::Add.new("foo bar")
    result += Classlist::Remove.new("not this")
    assert_equal(["foo", "bar"], result.to_a)
  end

  def test_adding_another_operation
    base = Classlist::Add.new("foo bar")
    result = base + Classlist::Remove.new("bar")
    assert_equal([Classlist::Remove.new("bar")], result.operations)
  end

  def test_add_operation_is_the_same_as_adding
    base = Classlist::Add.new("foo bar")
    result = base.add_operation(Classlist::Remove.new("bar"))
    assert_equal(base + Classlist::Remove.new("bar"), result)
    assert_empty(base.operations)
  end

  def test_storing_operations_in_a_variable
    change = Classlist::Remove.new("notthis") + Classlist::Add.new("this")
    assert_instance_of(Classlist::Remove, change)

    base = Classlist.new("notthis")
    result = base + change

    assert_equal(["this"], result.to_a)
  end

  def test_adding_after_removing
    base = Classlist.new("foo")
    removal = Classlist::Remove.new("foo")
    addition = Classlist::Add.new("addition")
    result = base + removal + addition
    assert_equal(["addition"], result.to_a)
  end

  def test_adding_a_classlist_instance_assumes_add
    base = Classlist.new("foo")
    removal = Classlist::Remove.new("foo")
    addition = Classlist.new("addition")
    result = base + removal + addition
    assert_equal(["addition"], result.to_a)
  end

  def test_all_the_operations
    result = Classlist.new("start") +
      Classlist::Reset.new("with") +
      Classlist::Remove.new("start") +
      Classlist::Add.new("end with") +
      Classlist::Add.new("this")

    assert_equal(["with", "end", "this"], result.to_a)
  end

  def test_adding_a_string_keeps_pending_operations
    base = Classlist.new("foo") + Classlist::Add.new("bar")
    result = base + "baz"
    assert_equal(["foo", "bar", "baz"], result.to_a)
  end

  def test_adding_an_array_keeps_pending_operations
    base = Classlist.new("foo") + Classlist::Add.new("bar")
    result = base + ["baz"]
    assert_equal(["foo", "bar", "baz"], result.to_a)
  end

  def test_adding_a_string_applies_pending_operations_first
    base = Classlist.new("foo bar") + Classlist::Remove.new("bar")
    result = base + "bar"
    assert_equal(["foo", "bar"], result.to_a)
  end

  def test_adding_a_string_after_reset_keeps_the_reset
    base = Classlist.new("foo") + Classlist::Reset.new("bar")
    result = base + "baz"
    assert_equal(["bar", "baz"], result.to_a)
  end

  def test_adding_a_string_does_not_change_the_original_classlist
    base = Classlist.new("foo") + Classlist::Add.new("bar")
    _result = base + "baz"
    assert_equal(["foo", "bar"], base.to_a)
  end

  def test_adding_a_string_keeps_composed_operations
    change = Classlist::Remove.new("foo") + Classlist::Add.new("bar")
    base = Classlist.new("foo") + change
    result = base + "baz"
    assert_equal(["bar", "baz"], result.to_a)
  end

  def test_adding_a_string_does_not_change_composed_operations_on_the_original
    change = Classlist::Remove.new("foo") + Classlist::Add.new("bar")
    base = Classlist.new("foo") + change
    _result = base + "baz"
    assert_equal(["bar"], base.to_a)
  end

  def test_adding_a_string_does_not_change_operations_shared_with_other_classlists
    change = Classlist::Remove.new("foo") + Classlist::Add.new("bar")
    first = Classlist.new("foo") + change
    second = Classlist.new("foo") + change
    _result = first + "baz"
    assert_equal(["bar"], second.to_a)
  end

  def test_adding_a_string_resolves_shared_nested_operations_consistently
    shared = Classlist::Add.new("a") + Classlist::Reset.new("b")
    base = Classlist.new +
      (Classlist::Add.new("x") + shared) +
      (Classlist::Remove.new("b") + shared)
    result = base + "z"
    assert_equal(["b", "z"], result.to_a)
    assert_equal(["b"], base.to_a)
  end

  def test_adding_a_string_does_not_change_the_original_or_the_operation
    change = Classlist::Remove.new("foo") + Classlist::Add.new("bar")
    base = Classlist.new("foo") + change
    _result = base + "baz"
    assert_equal(["bar"], base.to_a)
    assert_equal(["bar"], (Classlist.new("foo") + change).to_a)
    assert_equal([Classlist::Add.new("bar")], change.operations)
  end

  def test_adding_an_operation_does_not_change_the_classlist
    base = Classlist.new("foo")
    _result = base + Classlist::Remove.new("foo")
    assert_equal(["foo"], base.to_a)
  end

  def test_adding_operations_does_not_change_the_first_operation
    removal = Classlist::Remove.new("foo")
    _change = removal + Classlist::Add.new("bar")
    assert_equal([], removal.operations)
    assert_equal(["baz"], (Classlist.new("foo baz") + removal).to_a)
  end

  def test_a_shared_operation_gives_the_same_result_every_time
    change = Classlist::Reset.new("a") + Classlist::Remove.new("a") + Classlist::Add.new("b")
    first = Classlist.new("x") + change
    second = Classlist.new("y") + change
    assert_equal(["b"], first.to_a)
    assert_equal(["b"], second.to_a)
  end

  def test_adding_a_string_to_an_operation_adds_the_tokens
    change = Classlist::Remove.new("a") + "b"
    result = Classlist.new("a c") + change
    assert_equal(["c", "b"], result.to_a)
  end
end
