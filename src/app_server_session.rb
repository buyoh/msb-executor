require_relative './executor/executor_room.rb'
require_relative './room_manipulator.rb'

class AppServerSession

  def initialize
    @onpost = nil
    # @room = nil
    @manipulator = nil
  end

  # handler posting to client
  def onpost(&pc)
    @onpost = pc
  end

  #

  def close_room
    if @manipulator
      @manipulator.close
      @manipulator = nil
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

    if ['ping'].include?(act)
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

  # ping (for test)
  def handle_ping(data)
    @onpost.call({
      accept: true, id: data['id']
      date: Time.now.to_i
    })
    return nil
  end

  # room for executor
  def handle_openroom(data)
    return [false, 'illegal states'] if @manipulator
    room = ExecutorRoom.new
    @manipulator = RoomManipulator.new(room)
    return true
  end

  # room for executor
  def handle_closeroom(data)
    return [false, 'illegal states'] if @manipulator
    close_room
    return true
  end

  # upload and write files
  def handle_commands(data)
    li = data['run']
    return [false, 'illegal arguments'] unless li.is_a? Array
    li.each do |elem|
      elem[:run]
    end
    return true
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