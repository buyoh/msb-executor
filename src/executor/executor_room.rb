require 'fileutils'
require 'tmpdir'

# -----------------------------------------------------------------------------
# setup Executor workdirectory
# usually, use ExecutorRoom.start('path'){ foobar }
# 
class ExecutorRoom

  def initialize()
    workdir = Dir.tmpdir+'/maisandbox-x'  # TODO: refactor this
    FileUtils.mkdir_p workdir
    @dir = Dir.mktmpdir('ex_', workdir)
  end

  def destroy
    FileUtils.rm_rf @dir, secure: true
  end

  def dir
    @dir
  end

  def chdir(&pc)
    Dir.chdir @dir do
      pc.call
    end
  end

  def self.start(*args, &pc)
    this = ExecutorRoom.new(*args)
    this.instance_eval do
      chdir do
        Object.new.instance_eval do
          pc.call
        end
      end
      destroy
    end
  end

end
