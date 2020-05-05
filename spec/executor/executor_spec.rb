require_src './executor/executor.rb'

RSpec.describe 'Executor' do
  
  it 'execute echo (nocheck output)' do
    ex = Executor.new(cmd: 'echo "hello"')
    _, st = ex.execute
    expect(st.success?).to eq(true)
  end

  it 'echo; check output with pipe' do
    r, w = IO.pipe
    ex = Executor.new(cmd: 'echo "hello"', stdout: w)
    _, st = ex.execute
    line = r.gets.chomp
    expect(st.success?).to eq(true)
    expect(line).to eq('hello')
    r.close
    w.close
  end

  it 'sed; check in,out with pipe' do
    rr, rw = IO.pipe
    wr, ww = IO.pipe
    ex = Executor.new(cmd: 'sed -e "s/ll/11/g"', stdin: rr, stdout: ww)
    rw.puts 'hello'
    rw.close
    _, st = ex.execute
    line = wr.gets.chomp
    expect(st.success?).to eq(true)
    expect(line).to eq('he11o')
    rr.close
    ww.close
    wr.close
  end

  it 'ruby; check in,out,err with pipe' do
    rr, rw = IO.pipe
    wr, ww = IO.pipe
    er, ew = IO.pipe
    ex = Executor.new(cmd: 'ruby -e "s=gets;STDOUT.puts s.upcase;STDERR.puts s.downcase"',
      stdin: rr, stdout: ww, stderr: ew)
    rw.puts 'Hello'
    rw.close
    _, st = ex.execute
    outline = wr.gets.chomp
    errline = er.gets.chomp
    expect(st.success?).to eq(true)
    expect(outline).to eq('HELLO')
    expect(errline).to eq('hello')
    [rr,rw,wr,ww,er,ew].each(&:close)
  end

  it 'timeout' do
    ex = Executor.new(cmd: 'sleep 5', timeout: 1)
    start = Time.now
    _, st = ex.execute
    finish = Time.now
    expect(st.nil?).to eq(true)
    expect(finish - start).to be <= 2
  end

end