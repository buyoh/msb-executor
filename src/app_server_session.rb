require_relative './executor/executor_room.rb'
require_relative './commander.rb'

class AppServerSessionImpl

  def initialize(executorRoom_class, commander_class)
    @executorRoom_class = executorRoom_class
    @commander_class = commander_class
    @onpost = nil
    @room = nil
  end

  # handler posting to client
  def onpost(&pc)
    @onpost = pc
  end

  #

  def close_room
    if @room
      @room.close
      @room = nil
    end
  end

  def close
    close_room
    # note: discard @onpost ??
  end

  #

  def handle(data)
    act = data['act']
    data['id'] ||= rand(1e9.to_i).to_s

    if AppServerSessionImpl.handleable?(act)
      accepted, reason = __send__("handle_#{act}", data)
      if accepted == true
        @onpost.call({
          accept: true, id: data['id']
        })
      elsif accepted == false
        @onpost.call({
          accept: false, id: data['id'],
          reason: reason.to_s
        })
      end
    else
      @onpost.call({
        accept: false, id: data['id'],
        reason: 'unknown act'
      })
    end
  end

  def self.handleable?(act)
    ['ping', 'openroom', 'closeroom', 'commands', 'run', 'run_interactive'].include?(act)
  end

  # ping (for test)
  def handle_ping(data)
    @onpost.call({
      accept: true, id: data['id'],
      date: Time.now.to_i
    })
    return nil
  end

  # room for executor
  def handle_openroom(data)
    return [false, 'illegal states'] if @room
    room = @executorRoom_class.new
    return true
  end

  # room for executor
  def handle_closeroom(data)
    return [false, 'illegal states'] if @room
    close_room
    return true
  end

  # upload and write files
  def handle_commands(data)
    li = data['run']
    return [false, 'illegal arguments'] unless li.is_a? Array
    commander = @commander_class.new(@room)
    commander.command(li)
    return true  # TODO: tekitou
  end

  # exec
  def handle_run(data)
    # noblock, async
    return false
  end

  def handle_run_interactive(data)
    # interactive running mode
    return false
  end

end

class AppServerSession < AppServerSessionImpl
  def initialize
    super ExecutorRoom, Commander
  end
end

