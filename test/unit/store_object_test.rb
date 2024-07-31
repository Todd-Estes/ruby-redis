require "minitest/autorun"
require "minitest/pride"
require "./app/store_object"

class StoreObjectTest < Minitest::Test 
  def setup
    @store_object_1 = StoreObject.new(value = "doggo", px = 2000)
    @store_object_2 = StoreObject.new(value = "taco")
  end

  def test_it_exists
    assert_instance_of StoreObject, @store_object_1
    # assert_instance_of StoreObject, @store_object_2
  end

  def test_it_has_a_value_attribute
    assert_equal "doggo", @store_object_1.value
    assert_equal "taco", @store_object_2.value
  end


  def test_it_has_a_pexpire_attribute
    assert_equal 2000, @store_object_1.px
  end

  def test_it_has_no_pexpire_attribute
    assert_nil @store_object_2.px
  end

  def test_it_has_a_created_at_attribute
    refute_nil @store_object_1.created_at
    refute_nil @store_object_2.created_at
  end

  def test_it_is_current
    assert_equal true, @store_object_1.current?
    assert_equal true, @store_object_2.current?
  end

  def test_it_is_not_current
    secs = @store_object_1.px * 0.001 + 1
    sleep secs
    assert_equal false, @store_object_1.current?
  end
end