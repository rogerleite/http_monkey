require "http_monkey"

require "minitest/autorun"
require "minitest/reporters"

require "mocha"

require "support/fake_environment"
require "support/captain_hook"

MiniTest::Unit.runner = MiniTest::SuiteRunner.new
MiniTest::Unit.runner.reporters << MiniTest::Reporters::SpecReporter.new
MiniTest::Unit.runner.reporters << HttpMonkey::Support::CaptainHook.new

require "minion_server"

# Default App to integration tests
MirrorApp = Rack::Builder.new do
  map "/" do
    run lambda { |env|
      env['rack.input'] = env['rack.input'].read if env['rack.input'].respond_to?(:read)
      body = YAML.dump(env)
      [200, {"Content-Type" => "text/plain", "Content-Length" => body.size.to_s}, [body]]
    }
  end
end
