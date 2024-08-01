require "minitest/autorun"
require "minitest/pride"
require "./app/store_object"

class ServerInfoStatsTest < Minitest::Test 
  def setup
    options = {"role": "master"}
    @stats = ServerInfoStats.new(options)
  end
end