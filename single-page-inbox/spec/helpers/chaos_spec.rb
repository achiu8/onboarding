require 'spec_helper'

describe '#chaos_monkey' do
  it 'occasionally gives you the finger' do
    expect(Kernel).to receive(:rand).and_return(0)
    expect(ChaosHelpers::chaos_monkey{'success'})
      .to eq({error: true, msg: 'Chaos monkey strikes again'}.to_json)
  end

  it 'is mostly an ok primate' do
    expect(Kernel).to receive(:rand).and_return(1)
    expect(ChaosHelpers::chaos_monkey{'success'})
    .to eq('success')
  end
end
