class ServerInfoStats
  def initialize(options)
    @role = options[:role]
  end

  def get_role
    @role ? @role : "master"
  end
end