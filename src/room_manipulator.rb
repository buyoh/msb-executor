class RoomManipulator

  def initialize(room)
    # note: *_immとflushだけなので、メンバ変数として保持する理由が無さそう
    # app_server_sessionに持ってもらう
    @room = room
    @queue = []
    @result = []
  end

  def closed?
    @room.nil?
  end

  def close
    return nil if closed?
    @room.destroy
    @room = nil
  end
  
  def filesize_imm(path)
    @room.chdir do
      # TODO: impl me
    end
  end

  def read_imm(path, length, offset = 0, opt = {})
    # ファイルが大きいなら圧縮して送った方が良さげ
    d = nil
    @room.chdir do
      d = IO.read(path, length, offset, opt = {})
    end
    d
  end

  # manipulation method
  def write(path, string, opt)
    @room.chdir do
      z = IO.write(path, string, opt)
      @result << z
    end
  end
  private :write

  # manipulation method
  def run(command, opt)
    @room.chdir do
      e = Executor.new({
        cmd: command,
        stdout: ['stdout.log', 'a'],
        stderr: ['stderr.log', 'a']
      }.merge(opt))
      _, stt = e.execute
      @result << e.exitstatus
    end
  end
  private :run

end
