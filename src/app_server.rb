require 'json'
require_relative './app_server_session.rb'

class AppServerImpl

  def initialize(appServerSession_class)
    @appServerSession_class = appServerSession_class
    @socketserver = nil
    @sessions = []
  end

  def listen(socketserver)
    # todo: refactor me
    abort 'AppServer#listen call twice' if @socketserver != nil

    @socketserver = socketserver
    @socketserver.onconnect do |socket|
      session = @appServerSession_class.new

      session.onpost do |data|
        socket.post JSON.generate(data)
      end

      socket.ondisconnect do
        session.close
        @sessions.delete(session)
      end

      socket.onrecieve do |data|
        d = nil
        begin
          d = JSON.parse(data)
        rescue
          socket.post '{"accept":false}'
        end
        session.handle d if d
      end

    end
  end

end

class AppServer < AppServerImpl
  def initialize
    super(AppServerSession)
  end
end
