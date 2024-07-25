require "socket"
require_relative "store_object"

class YourRedisServer
  def initialize(port)
    @port = port
    @storage = {}
  end


  # def echo_initiated?(command_group)
  #   command_group[0] == "echo"
  # end

  # def add_echo_output(command_group, param)
  #   if command_group[1]
  #     raise CustomError, "(error) ERR wrong number of arguments for 'echo' command"
  #   else
  #     puts "adding echo output"
  #     command_group.append(param)
  #   end 
  # end

  # def initiate_command(command_group, param)
  #   puts "initiating command"
  #   command_group.append(param)
  # end

  # def get_command_response(command_group)
  #   response = "*2\r\n$#{command_group[0].bytesize}\r\nECHO\r\n$#{command_group[1].bytesize}\r\n#{command_group[1]}\r\n"
  # end

  # def parses?(request_line)
  #   request_line
  # end

  def start
    server = TCPServer.new(@port)
    loop do
      Thread.start(server.accept) do |client_socket|
        # command_group = []
        # output_executed = false
        begin
          while request_line = client_socket.gets
            puts "Received request: #{request_line}"
            # next unless parses?(request_line)
            param = request_line.chomp.downcase

            case param 
            when "ping"
                ping(client_socket)
            when "echo"
                echo(client_socket)
            when "set"
                set(client_socket)
            when "get"
                get(client_socket)

              # if echo_initiated?(command_group)
              #   add_echo_output(command_group, param)
              #   puts "command group: #{command_group}"
              #   response = get_command_response(command_group)
              #   client_socket.puts response
              # else
              #   initiate_command(command_group, param)
              # end
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

  def echo(client_socket)
    _ = client_socket.gets
    message = client_socket.gets.chomp
    client_socket.puts("$#{message.size}\r\n#{message}\r\n")
  end

  def ping(client_socket)
    client_socket.puts "+PONG\r\n"
  end

  def set(client_socket)
    _ = client_socket.gets
    key = client_socket.gets.chomp
    _ = client_socket.gets
    value = client_socket.gets.chomp
    _ = client_socket.gets
    _ = client_socket.gets
    _ = client_socket.gets
    px = client_socket.gets.chomp


    @storage[key] = StoreObject.new(value = value, px = px)
    puts "store object created"
    puts @storage[key].is_expired?
    client_socket.puts "+OK\r\n"
  end

  def get(client_socket)
    _ = client_socket.gets
    key = client_socket.gets.chomp
    message = @storage[key]
    if message
      client_socket.puts("$#{message.size}\r\n#{message}\r\n")
    else
      client_socket.puts("$-1\r\n")
    end
  end
end

YourRedisServer.new(6379).start
