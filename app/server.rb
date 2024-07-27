# require "socket"
# require_relative "store_object"

# class YourRedisServer
#   def initialize(port)
#     @port = port
#     @storage = {}
#   end


#   # def echo_initiated?(command_group)
#   #   command_group[0] == "echo"
#   # end

#   # def add_echo_output(command_group, param)
#   #   if command_group[1]
#   #     raise CustomError, "(error) ERR wrong number of arguments for 'echo' command"
#   #   else
#   #     puts "adding echo output"
#   #     command_group.append(param)
#   #   end 
#   # end

#   # def initiate_command(command_group, param)
#   #   puts "initiating command"
#   #   command_group.append(param)
#   # end

#   # def get_command_response(command_group)
#   #   response = "*2\r\n$#{command_group[0].bytesize}\r\nECHO\r\n$#{command_group[1].bytesize}\r\n#{command_group[1]}\r\n"
#   # end

#   # def parses?(request_line)
#   #   request_line
#   # end

#   def start
#     server = TCPServer.new(@port)
#     loop do
#       Thread.start(server.accept) do |client_socket|
#         # command_group = []
#         # output_executed = false
#         begin
#           while request_line = client_socket.gets
#             puts "Received request: #{request_line}"
#             # next unless parses?(request_line)
#             param = request_line.chomp.downcase

#             case param 
#             when "ping"
#                 ping(client_socket)
#             when "echo"
#                 echo(client_socket)
#             when "set"
#                 set(client_socket)
#             when "get"
#                 get(client_socket)

#               # if echo_initiated?(command_group)
#               #   add_echo_output(command_group, param)
#               #   puts "command group: #{command_group}"
#               #   response = get_command_response(command_group)
#               #   client_socket.puts response
#               # else
#               #   initiate_command(command_group, param)
#               # end
#             end
#           end
#         rescue Errno::ECONNRESET
#           puts "Connection reset by peer"
#         rescue => e
#           puts "An error occurred: #{e.message}"
#         ensure
#           client_socket.close
#           puts "Client connection closed"
#         end
#       end
#     end
#   end

#   def echo(client_socket)
#     _ = client_socket.gets
#     message = client_socket.gets.chomp
#     client_socket.puts("$#{message.size}\r\n#{message}\r\n")
#   end

#   def ping(client_socket)
#     client_socket.puts "+PONG\r\n"
#   end

#   def set(client_socket)
#     _ = client_socket.gets
#     key = client_socket.gets.chomp
#     _ = client_socket.gets
#     value = client_socket.gets.chomp
#     _ = client_socket.gets
#     _ = client_socket.gets
#     _ = client_socket.gets
#     px = client_socket.gets.chomp


#     @storage[key] = StoreObject.new(value = value, px = px)
#     puts "store object created"
#     puts @storage[key].is_expired?
#     client_socket.puts "+OK\r\n"
#   end

#   def get(client_socket)
#     _ = client_socket.gets
#     key = client_socket.gets.chomp
#     message = @storage[key]
#     if message
#       client_socket.puts("$#{message.size}\r\n#{message}\r\n")
#     else
#       client_socket.puts("$-1\r\n")
#     end
#   end
# end

# YourRedisServer.new(6379).start
require "socket"
require_relative "store_object"

class YourRedisServer
  def initialize(port)
    @server = TCPServer.new(port)
    @data_store = {}
  end

  def start
    loop do
      client = @server.accept
      handle_client(client)
    end
  end

  def handle_client(client)
    loop do
      request = client.gets
      break if request.nil?

      request_parts = parse_request(request, client)
      process_request(request_parts, client)
    end
    client.close
  end

  def parse_request(request, client)
    parts = []
    if request.start_with?('*')
      count = request[1..-1].to_i
      
      parts = count.times.map { parse_bulk_string(client) }
    else
      parts = [request.chomp]
    end
    parts
  end

  def parse_bulk_string(client)
    length_line = client.gets

    return nil unless length_line.start_with?('$')
    
    length = length_line[1..-1].to_i

    bulk_string = client.read(length)
    req = client.gets # Read the trailing \r\n
    bulk_string
  end

  def process_request(request_parts, client)
    command = request_parts[0]
    case command.upcase
    when "PING"
      client.puts("+PONG\r\n")
    when "ECHO"
      message, extra = request_parts[1], request_parts[2]
      if message.nil? || extra
        client.puts "-ERR wrong number of arguments for 'echo' command\r\n\r\n"
      else
        client.puts "$#{message.bytesize}\r\n#{message}\r\n"
      end
    when "SET"
      key, value, px = request_parts[1], request_parts[2], request_parts[4]
      @data_store[key] = StoreObject.new(value = value, px = px)
      client.puts "+OK\r\n"
    when "GET"
      key = request_parts[1]
      store_object = @data_store[key]
      if store_object && store_object.current?
        value = store_object.value
        client.puts "$#{value.bytesize}\r\n#{value}\r\n"
      else
        client.puts "$-1\r\n"
      end
    else
      client.puts "-ERR unknown command '#{command}'\r\n"
    end
  end
end

YourRedisServer.new(6379).start
