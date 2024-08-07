require 'securerandom'

class ServerInfoStats
  def initialize(options)
    @role = options[:role]
    @master_replid = nil
    @master_repl_offset = "0"
    @rdb = ["524544495330303131fa0972656469732d76657205372e322e30fa0a72656469732d62697473c040fa056374696d65c26d08bc65fa08757365642d6d656dc2b0c41000fa08616f662d62617365c000fff06e3bfec0ff5aa2"].pack('H*')
  end

  def get_role
    @role ? @role : "master"
  end

  def get_master_replid
    @master_replid ? @master_replid : generate_replid
  end

  def get_master_repl_offset
    @master_repl_offset
  end    

  def get_rdb
    @rdb
  end

  private

  def generate_replid
    @master_replid = SecureRandom.hex(40)
    return @master_replid
  end
end