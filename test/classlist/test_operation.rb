# frozen_string_literal: true

require "test_helper"

require "classlist/add"
require "classlist/remove"

class TestClasslistOperation < Minitest::Test
  def test_add_as_manual_operations
    base = Classlist.new("foo")
    base.add_operation(Classlist::Add.new("bar"))
    assert_equal(["foo", "bar"], base.to_a)
  end

  def test_remove_as_manual_operations
    base = Classlist.new("this that")
    base.add_operation(Classlist::Remove.new("this"))
    assert_equal(["that"], base.to_a)
  end

  def test_remove_then_add_as_manual_operations
    base = Classlist.new("notthis")
    base.add_operation(Classlist::Remove.new("notthis"))
    base.add_operation(Classlist::Add.new("this"))
    assert_equal(["this"], base.to_a)
  end

  def test_add_then_remove_as_manual_operations
    base = Classlist.new("foo bar")
    base.add_operation(Classlist::Add.new("foo bar"))
    base.add_operation(Classlist::Remove.new("not this"))
    assert_equal(["foo", "bar"], base.to_a)
  end
end
