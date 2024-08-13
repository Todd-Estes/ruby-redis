require "minitest/autorun"
require "minitest/pride"
require "./app/server_info_stats"

class ServerInfoStatsTest < Minitest::Test 
  def setup
    options1 = {:role => "slave"}
    options2 = {:role => nil}
    @stats1 = ServerInfoStats.new(options1)
    @stats2 = ServerInfoStats.new(options2)
  end

  def test_it_exists
    assert_instance_of ServerInfoStats, @stats1
  end 

  def test_it_gets_role
    assert_equal "slave", @stats1.get_role
  end

  def test_it_gets_master_for_role_if_attribute_is_nil
    assert_equal "master", @stats2.get_role
  end

  def test_it_gets_a_non_nil_master_repl_id
    refute_nil @stats1.get_master_replid
  end

  def test_it_gets_master_repl_offset
    assert_equal "0", @stats1.get_master_repl_offset
  end

  def test_it_returns_empty_rdb_file
    rdb = ["524544495330303131fa0972656469732d76657205372e322e30fa0a72656469732d62697473c040fa056374696d65c26d08bc65fa08757365642d6d656dc2b0c41000fa08616f662d62617365c000fff06e3bfec0ff5aa2"].pack('H*')
    assert_equal rdb, @stats1.get_rdb
  end
end
