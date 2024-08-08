require "minitest/autorun"
require "minitest/pride"
require "./app/server_info_stats"

class ServerInfoStatsTest < Minitest::Test 
  def setup
    options = {:role => "slave"}
    @stats1 = ServerInfoStats.new(options)
  end

  def test_it_exists
    assert_instance_of ServerInfoStats, @stats1
  end 

  def test_it_gets_role
    assert_equal "slave", @stats1.get_role
  end

  def test_it_gets_a_non_nil_master_repl_id
    refute_nil @stats1.get_master_replid
  end

  def test_it_gets_master_repl_offset
    assert_equal "0", @stats.get_master_repl_offset
  end
end
