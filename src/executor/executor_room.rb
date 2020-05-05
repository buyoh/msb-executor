require 'fileutils'

# -----------------------------------------------------------------------------
# setup Executor workdirectory
# usually, use ExecutorRoom.start('path'){ foobar }
# 
class ExecutorRoom

  def initialize(dir)
    @dir = dir
    @istempdir = false
    FileUtils.makedirs @dir
  end

  def finalize
    if @istempdir
      FileUtis.rm_rf @dir
    end
  end

  def chdir(&pc)
    Dir.chdir @dir do
      pc.call
    end
  end

  def self.start(*args, &pc)
    this = initialize(*args)
    this.instance_eval do
      chdir do
        Object.new.instance_eval do
          pc.call
        end
      end
      finalize
    end
  end

end
