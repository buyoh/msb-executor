# -----------------------------------------------------------------------------
# interactive execution interface
# 
class InteractiveExecutorController

  def initialize(executor)
    raise ArgumentError if executor.nil?
    @executor = executor
    @in_rd, @in_wt = IO.pipe
    @out_rd, @out_wt = IO.pipe 
    @in_rd.close_write
    @in_wt.close_read
    @out_rd.close_write
    @out_wt.close_read
    @pid = nil
  end

  def printer
    @in_wt
  end
  def scanner
    @out_rd
  end

  def close
    [@in_rd, @in_wt, @out_rd, @out_wt].each(&:close)
  end

  def start
    raise RuntimeError unless executor.status.nil?
    executor.stdin = @in_rd
    executor.stdout = @out_wt
    executor.execute(true) do |stat|
      close
    end
  end

  def kill
    Process.kill @pid if !@pid.nil?
  end

end
