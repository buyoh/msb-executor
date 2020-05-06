require_src './executor/executor_room.rb'

RSpec.describe 'ExecutorRoom' do
  
  it 'instant room (ExecutorRoom#start)' do
    d = nil
    ExecutorRoom.start do
      d = Dir.pwd
      expect(File.exist?(d)).to eq(true)
      expect(system('mkdir foo')).to eq(true)
      expect(system('echo "test" > foo/bar.baz')).to eq(true)
    end
    expect(File.exists?(d)).to eq(false)
  end

  it 'init/destroy room (ExecutorRoom#start)' do
    er = ExecutorRoom.new
    d = er.dir
    er.chdir do
      d = Dir.pwd
      expect(Dir.pwd).to eq(d)
      expect(system('mkdir foo')).to eq(true)
      expect(system('echo "test" > foo/bar.baz')).to eq(true)
    end
    er.destroy
    expect(File.exists?(d)).to eq(false)
  end

end
