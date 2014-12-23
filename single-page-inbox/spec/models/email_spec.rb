require 'spec_helper'

describe Email do
  describe '#mark_read!' do
    it 'marks messages read' do
      email = Email.new(to:'foo',from:'bar',subject:'baz',body:'bang')
      expect(email).to_not be_read
      email.mark_read!
      expect(email).to be_read
    end
  end
end
