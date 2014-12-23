get "/" do
  redirect '/inbox/matt.baker@example.com'
end

get '/inbox/:email' do
  @email = params[:email]
  erb :inbox
end

get '/user/:user/emails' do
  content_type :json
  chaos_monkey do
    emails = Email.where(to:params[:user])
    {error: false, email: emails.map(&:as_summary_json)}.to_json
  end
end


post '/emails' do
  content_type :json
  chaos_monkey do
    email = Email.create!(email_params(params))
    {error: false, email: email}.to_json
  end
end

post '/emails/:email/read' do
  content_type :json
  chaos_monkey do
    email = Email.find(params[:email])
    email.mark_read!
    {error: false, email: email}.to_json
  end
end

get '/emails/labels' do
  content_type :json
  chaos_monkey do
    email_ids = params[:emails].split(",")
    emails = Email.where(:id => email_ids)
    email_labels = Hash.new {|h,k| h[k] = {}}
    emails.each do |email|
      email_labels[email.id] = email.labels
    end
    {error: false, labels: email_labels}.to_json
  end
end

post '/labels' do
  content_type :json
  chaos_monkey do
    label = Label.create!(name: params[:name] ,color: params[:color])
    {error: false, label: label}.to_json
  end
end

post '/emails/:id/labels' do
  content_type :json
  chaos_monkey do
    email = Email.find(params[:id])
    label = Label.find(params[:label_id])
    email.labels << label
    {error: false, email: email}.to_json
  end
end

delete '/emails/:id/labels/:label_id' do
  content_type :json
  chaos_monkey do
    email = Email.find(params[:id])
    label = Label.find(params[:label_id])
    email.labels.remove(label)
    {error: false, email: email}.to_json
  end
end

get '/emails/:id' do
  content_type :json
  chaos_monkey do
    email = Email.find(params[:id])
    {error: false, email: email}.to_json
  end
end
