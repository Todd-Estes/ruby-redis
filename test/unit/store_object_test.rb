require "minitest/autorun"
require "minitest/pride"
require "./app/store_object"

class StoreObjectTest < Minitest::Test 
  def setup
    @store_object = StoreObject.new(value = "doggo")
  end

  def test_it_exists
    assert_instance_of StoreObject, @store_object
  end

  def test_it_has_a_value
    assert_equal "doggo", @store_object.value
  end
end