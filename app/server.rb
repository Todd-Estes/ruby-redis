require "socket"

class RedisServer
  def initialize(port)
    @port = port
  end

  def start
    server = TCPServer.new(@port)
    loop do
      Thread.start(server.accept) do |client_socket|
        while request = client_socket.gets
          puts "Received request: #{request}"
          client_socket.puts "+PING\r\n"
        end
        client_socket.close
      end
    end
  end
end

RedisServer.new(6379).start