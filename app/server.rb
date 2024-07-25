require "socket"

class YourRedisServer
  def initialize(port)
    @port = port
  end

  def start
    server = TCPServer.new(@port)
    loop do
      Thread.start(server.accept) do |client_socket, client_address|
        begin
          while request = client_socket.gets
            puts "Received request: #{request}"
            if request.chomp == "PING"
              client_socket.puts "+PONG\r\n"
            end
          end
        rescue Errno::ECONNRESET
          puts "Connection reset by peer"
        rescue => e
          puts "An error occurred: #{e.message}"
        ensure
          client_socket.close
          puts "Client connection closed"
        end
      end
    end
  end
end

YourRedisServer.new(6379).start
