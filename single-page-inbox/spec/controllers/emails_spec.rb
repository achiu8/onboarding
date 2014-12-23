require 'spec_helper'

describe 'Emails Controller' do

  before :each do |example|
    if example.metadata[:prevent_chaos]
      #Put the monkey in his cage
      expect(Kernel).to receive(:rand).with(5).and_return(1)
    end
  end

  describe "GET '/inbox/matt.baker@example.com'" do
    it "loads inbox" do
      get '/inbox/matt.baker@example.com'
      expect(last_response).to be_ok
    end
  end

  describe "GET '/user/:user/emails'", prevent_chaos:true do
    before :each do
      expect(Email).to receive(:where)
        .with(to:'foo@bar.com')
        .and_return([
          Email.new(to:'foo',from:'bar',subject:'baz',body:'bang')
        ])
    end

    it "fetches emails" do
      get '/user/foo@bar.com/emails'
      expect(last_response).to be_ok
    end

    it 'returns json' do
      get '/user/foo@bar.com/emails'
      expect(last_response.content_type).to eq('application/json')
    end

    it 'contains just the summary' do
      get '/user/foo@bar.com/emails'
      json_response = JSON.parse(last_response.body)
      email = json_response["email"][0]
      expect(email).to_not include("body")
    end
  end

  describe "POST '/emails'", prevent_chaos:true do
    before :each do
      expect(Email).to receive(:create!)
      .with(to:'foo@bar.com', from:'bar@baz.com', subject:'a', body:'b')
    end

    it "creates a new Email" do
      post '/emails', to:'foo@bar.com', from:'bar@baz.com', subject:'a', body:'b'
      expect(last_response).to be_ok
    end

    it 'returns json' do
      post '/emails', to:'foo@bar.com', from:'bar@baz.com', subject:'a', body:'b'
      expect(last_response.content_type).to eq('application/json')
    end
  end

  describe "GET '/emails/labels'", prevent_chaos:true do
    before :each do
      email = double('email', id:1)
      email2 = double('email2', id:2)
      label1 = Label.new(name:'foo', color:'white', id:1)
      label2 = Label.new(name:'bar', color:'black', id:2)
      expect(Email).to receive(:where)
        .with(id:["1","2"])
        .and_return([email, email2])
      expect(email).to receive(:labels).and_return([label1])
      expect(email2).to receive(:labels).and_return([label2])
    end

    it "fetches labels" do
      get '/emails/labels', emails:"1,2"
      expect(last_response).to be_ok
      expect(last_response.body).to eq({
        "error"=>false,
        "labels"=>{
            "1" => [{"color"=>"white","name"=>"foo","id"=>1}],
            "2" => [{"color"=>"black","name"=>"bar","id"=>2}]
          }
        }.to_json)
    end

    it 'returns json' do
      get '/emails/labels', emails:"1,2"
      expect(last_response.content_type).to eq('application/json')
    end
  end

  describe "POST '/labels'", prevent_chaos:true do
    before :each do
      expect(Label).to receive(:create!).with(name:'foo', color:'0c0')
    end

    it 'creates a new label' do
      post '/labels', name:'foo', color:'0c0'
      expect(last_response).to be_ok
    end

    it 'returns json' do
      post '/labels', name:'foo', color:'0c0'
      expect(last_response.content_type).to eq('application/json')
    end
  end

  describe "POST '/emails/:id/read'", prevent_chaos:true do
    let(:email_id) { '1' }
    before :each do
      email = double('email')
      expect(Email).to receive(:find).with(email_id).and_return(email)
      expect(email).to receive(:mark_read!)
    end

    it 'assigns a label' do
      post "/emails/#{email_id}/read"
      expect(last_response).to be_ok
    end

    it 'returns json' do
      post "/emails/#{email_id}/read"
      expect(last_response.content_type).to eq('application/json')
    end
  end

  describe "POST '/emails/:id/labels'", prevent_chaos:true do
    let(:email_id) { '1' }
    let(:label_id) { '2' }
    before :each do
      labels = double('labels')
      email = double('email', labels:labels)
      label = double('label')

      expect(Email).to receive(:find).with(email_id).and_return(email)
      expect(Label).to receive(:find).with(label_id).and_return(label)
      expect(email.labels).to receive(:<<).with(label)
    end

    it 'assigns a label' do
      post "/emails/#{email_id}/labels", label_id:label_id
      expect(last_response).to be_ok
    end

    it 'returns json' do
      post "/emails/#{email_id}/labels", label_id:label_id
      expect(last_response.content_type).to eq('application/json')
    end
  end

  describe "DELETE '/emails/:id/labels/:label_id'", prevent_chaos:true do
    let(:email_id) { '1' }
    let(:label_id) { '2' }

    before :each do
      labels = double('labels')
      email = double('email', labels:labels)
      label = double('label')

      expect(Email).to receive(:find).with(email_id).and_return(email)
      expect(Label).to receive(:find).with(label_id).and_return(label)
      expect(email.labels).to receive(:remove).with(label)
    end

    it 'assigns a label' do
      delete "/emails/#{email_id}/labels/#{label_id}"
      expect(last_response).to be_ok
    end

    it 'returns json' do
      delete "/emails/#{email_id}/labels/#{label_id}"
      expect(last_response.content_type).to eq('application/json')
    end
  end
end
