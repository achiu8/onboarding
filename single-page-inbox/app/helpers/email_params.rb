module EmailParamsHelpers
  extend self
  def email_params(params)
    {
      to:params[:to],
      from:params[:from],
      subject:params[:subject],
      body:params[:body]
    }
  end
end
helpers EmailParamsHelpers
