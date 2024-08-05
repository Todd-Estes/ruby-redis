require 'securerandom'

class ServerInfoStats
  def initialize(options)
    @role = options[:role]
    @master_replid = nil
    @master_repl_offset = "0"
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

  private

  def generate_replid
    @master_replid = SecureRandom.hex(40)
    return @master_replid
  end
end