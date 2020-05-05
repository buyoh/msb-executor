require_src 'app_server.rb'
require_src 'msocket/mock/mock_socket_server.rb'

RSpec.describe 'AppServer' do
  
  it 'not json' do
    mss = MMockSocketServer.new
    server = AppServer.new
    server.listen(mss)

    mock_socket = mss.start
    mock_socket.emulate_recieve '{{{{{{sushi'
    expect(mock_socket.post_queue[0]['stat']).to eq(false)
  end

  it 'ping' do
    mss = MMockSocketServer.new
    server = AppServer.new
    server.listen(mss)

    mock_socket = mss.start
    mock_socket.emulate_recieve '{"act":"ping"}'
    expect(mock_socket.post_queue[0]['stat']).to eq(true)
    expect(mock_socket.post_queue[0]['date']).to be > (Time.now.to_i-99)
  end
end