require_relative './mock_socket.rb'
require_relative './../socket_server.rb'

class MMockSocketServer < MSocketServer
  def initialize
    super
    @mock_socket = nil
  end

  # call onconnect proc
  def start
    raise ArgumentError 'start was called twice' if @mock_socket
    @mock_socket = MMockSocket.new
    @handler_connect.call @mock_socket
    return @mock_socket
  end
end
