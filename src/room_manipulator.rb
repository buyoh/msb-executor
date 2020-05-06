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

  # push to queue
  def write(path, string, opt = {})
    @queue << [:write_q, path, string, opt]
  end

  # push to queue
  def run(command)
    @queue << [:run_q, command, {}]
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

  def flush
    @room.chdir do
      while !@queue.empty?
        elem = @queue.shift
        m = elem.shift
        __call__ m, *elem
      end
    end
  end

  def write_q(path, string, opt)
    z = IO.write(path, string, opt)
    @result << z
  end
  private :write_q

  def run_q(command, opt)
    e = Executor.new({
      cmd: command,
      stdout: ['stdout.log', 'a'],
      stderr: ['stderr.log', 'a']
    }.merge(opt))
    _, stt = e.execute
    @result << e.exitstatus
  end
  private :run_q

end
