module ChaosHelpers
  extend self
  def chaos_monkey
    if Kernel::rand(5) == 0
      {error: true, msg: 'Chaos monkey strikes again'}.to_json
    else
      yield
    end
  end
end
helpers ChaosHelpers
