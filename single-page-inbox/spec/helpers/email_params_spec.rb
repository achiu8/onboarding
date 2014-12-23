require 'spec_helper'

describe '#email_params' do
  it 'filters non-whitelisted params' do
    params = EmailParamsHelpers::email_params(to:'foo', from:'bar', subject:'baz', body:'bang', labels:[], id:1)
    expect(params).to eq(to:'foo', from:'bar', subject:'baz', body:'bang')
  end
end
