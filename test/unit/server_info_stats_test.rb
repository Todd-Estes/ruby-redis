require "minitest/autorun"
require "minitest/pride"
require "./app/server_info_stats"

class ServerInfoStatsTest < Minitest::Test 
  def setup
    options = {"role": "master"}
    @stats = ServerInfoStats.new(options)
  end

  def test_it_exists
    assert_instance_of ServerInfoStats, @stats
  end
end