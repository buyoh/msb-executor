# -----------------------------------------------------------------------------
# 外部プロセスから接続要求を受け取ったり、情報を送ったりするための
# ソケットのインターフェース実装
# 
class MSocketServer
  # pc.call(Socket.new)
  def onconnect(&pc)
    @handler_connect = pc
  end
end
