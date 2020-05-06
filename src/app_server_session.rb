class AppServerSession
  def initialize
    @onpost = nil
  end

  # handler posting to client
  def onpost(&pc)
    @onpost = pc
  end

  def close
    
  end

  def handle(data)
    act = data['act']
    if ['ping'].include?(act)
      return __send__("handle_#{act}", data)
    else
      return {stat: false, reason: 'unknown act'}
    end
  end

  # ping (for test)
  def handle_ping(data)
    @onpost.call({
      stat: true,
      date: Time.now.to_i
    })
  end

  # room for executor
  def handle_openroom
  end

  # room for executor
  def handle_closeroom
  end

  # upload and write files
  def handle_upload
    
  end

  # exec
  def handle_run
    # noblock, async
  end

  def handle_run_send
    # interactive
  end

end