# frozen_string_literal: true

require "test_helper"

require "classlist/add"
require "classlist/remove"

class TestClasslistOperation < Minitest::Test
  def test_add
    base = Classlist.new("foo")
    result = base + Classlist::Add.new("bar")
    assert_equal(["foo", "bar"], result.to_a)
  end

  def test_add_as_manual_operations
    base = Classlist.new("foo")
    base.add_operation(Classlist::Add.new("bar"))
    assert_equal(["foo", "bar"], base.to_a)
  end

  def test_remove
    base = Classlist.new("this that")
    result = base + Classlist::Remove.new("this")
    assert_equal(["that"], result.to_a)
  end

  def test_remove_as_manual_operations
    base = Classlist.new("this that")
    base.add_operation(Classlist::Remove.new("this"))
    assert_equal(["that"], base.to_a)
  end

  def test_reset
    base = Classlist.new("this that")
    result = base + Classlist::Reset.new("something else")
    assert_equal(["something", "else"], result.to_a)
  end

  def test_reset_as_manual_operations
    base = Classlist.new("this that")
    base.add_operation(Classlist::Reset.new("something else"))
    assert_equal(["something", "else"], base.to_a)
  end

  def test_remove_then_add
    result = Classlist.new("notthis")
    result += Classlist::Remove.new("notthis")
    result += Classlist::Add.new("this")
    assert_equal(["this"], result.to_a)
  end

  def test_remove_then_add_as_manual_operations
    base = Classlist.new("notthis")
    base.add_operation(Classlist::Remove.new("notthis"))
    base.add_operation(Classlist::Add.new("this"))
    assert_equal(["this"], base.to_a)
  end

  def test_add_then_remove
    result = Classlist.new("foo bar")
    result += Classlist::Add.new("foo bar")
    result += Classlist::Remove.new("not this")
    assert_equal(["foo", "bar"], result.to_a)
  end

  def test_add_then_remove_as_manual_operations
    base = Classlist.new("foo bar")
    base.add_operation(Classlist::Add.new("foo bar"))
    base.add_operation(Classlist::Remove.new("not this"))
    assert_equal(["foo", "bar"], base.to_a)
  end

  def test_adding_another_operation
    base = Classlist::Add.new("foo bar")
    result = base + Classlist::Remove.new("bar")
    assert_equal([Classlist::Remove.new("bar")], result.operations)
  end

  def test_adding_another_operation_as_manual_operation
    base = Classlist::Add.new("foo bar")
    base.add_operation(Classlist::Remove.new("bar"))
    assert_equal([Classlist::Remove.new("bar")], base.operations)
  end
end
