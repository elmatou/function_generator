describe 'Function' do
  it 'instantiate a new function' do
    expect{ Function.new }.to raise_error(ArgumentError)
    expect{ Function.new {} }.not_to raise_error
  end

  it '[] return a value' do
    f1 = Function.new {|x| x*x }
    f2 = Function.new {|x,t| x*t }
    # expect{ f1[] }.to raise_error
    expect(f1[2]).to eq 4
    expect(f1[3]).to eq 9
    
    # expect{ f2[2] }.to raise_error
    expect(f2[2,3]).to eq 6
    expect(f2[0,3]).to eq 0
  end
end

describe 'TimeBasedFunction' do

  let!(:fsin) { TimeBasedFunction.new {|t| Math.sin(t) } }
  let!(:ft) { TimeBasedFunction.new {|t| t } }

  it 'start/stop' do
    expect(fsin.started_at).to be_nil 
    fsin.start
    expect(fsin.started_at).not_to be_nil
    fsin.stop
    expect(fsin.started_at).to be_nil 
  end

  it 'return value based on Time' do
    expect(fsin.value).to be_nil 
    fsin.start
    expect(fsin.value).not_to be_nil
    abscissa, ordinate = fsin.value(true)
    expect(ordinate).to eq Math.sin(abscissa)
  end

  it 'run' do
    expect{ ft.run(50) }.to raise_error ArgumentError
    # results = []
    # ft.run(50, 10) {|r| results << r }
    # ft.runner.join
    # expect(results).to eq [nil]
  end
end
