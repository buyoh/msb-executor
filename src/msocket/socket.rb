# -----------------------------------------------------------------------------
# 外部プロセスから接続要求を受け取ったり、情報を送ったりするための
# ソケットのインターフェース実装
# 
class MSocket

  def initialize
    @connected = true
  end

  def ondisconnect(&pc)
    @handler_disconnect = pc
  end

  def onrecieve(&pc)
    @handler_recieve = pc
  end

  def post(msg)
    # nop
  end

  def close()
    @connected = false
  end

  def connected?
    @connected
  end
  
end