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

  def handle_ping(data)
    @onpost.call({
      stat: true,
      date: Time.now.to_i
    })
  end

end