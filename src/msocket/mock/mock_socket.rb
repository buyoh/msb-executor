require_relative '../socket.rb'
require 'json'

class MMockSocket < MSocket
  def initialize
    super
    @post_queue = []
  end

  def post(msg)
    super
    @post_queue << JSON.parse(msg)
  end

  def close()
    raise ArgumentError 'close was called twice' unless self.connected?
    super
    @handler_disconnect.call
  end

  # - - - - - - - - - - - - - - - - - -

  def emulate_recieve(text)
    @handler_recieve.call text
  end

  def post_queue
    @post_queue
  end

end