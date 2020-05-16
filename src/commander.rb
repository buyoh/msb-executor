require_relative './room_manipulator.rb'

class CommanderImpl

  def initialize(room, roomManipulator_class)
    @roomManipulator_class = roomManipulator_class
    @room = room
    @manipulator = @roomManipulator_class.new(@room)
  end

  def command(commands)
    # run
    # TODO: 非同期で実行する
    commands.each do |elem|
      case elem['key']
      when 'write'
        path = elem['path']
        @manipulator.write path, elem['data']
      when 'cmd'
        @manipulator.run elem['cmd']
      else
        next  # unreached
      end
    end
  end
end

class Commander < CommanderImpl
  def initialize(room)
    super room, RoomManipulator
  end
end
