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

  def error_handling(msg, id)
    @onpost.call({
      stat: false, id: id,
      reason: msg
    })
  end

  #

  def handle(data)
    act = data['act']
    data['id'] ||= rand(1e9.to_i).to_s
    if ['ping'].include?(act)
      __send__("handle_#{act}", data)
    else
      error_handling 'unknown act', data['id']
    end
  end

  # ping (for test)
  def handle_ping(data)
    @onpost.call({
      stat: true, id: data['id']
      date: Time.now.to_i
    })
  end

  # room for executor
  def handle_openroom(data)
    if @manipulator
      error_handling 'illegal states'
      return
    end
    room = ExecutorRoom.new
    @manipulator = RoomManipulator.new(room)
  end

  # room for executor
  def handle_closeroom(data)
    if @manipulator
      error_handling 'illegal states'
      return
    end
    close_room
  end

  # upload and write files
  def handle_hogehoge(data)
    
  end

  # exec
  def handle_run(data)
    # noblock, async
  end

  def handle_run_rich(data)
    # undefined...
    # it may be nice method
  end

  def handle_run_interactive(data)
    # interactive running mode
    # perhaps, need unko.
  end

end