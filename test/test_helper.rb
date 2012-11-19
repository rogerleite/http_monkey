require "http_monkey"

require "minitest/autorun"
require "minitest/reporters"

require "mocha"

require "support/fake_environment"
require "support/captain_hook"

MiniTest::Unit.runner = MiniTest::SuiteRunner.new
MiniTest::Unit.runner.reporters << MiniTest::Reporters::SpecReporter.new
MiniTest::Unit.runner.reporters << HttpMonkey::Support::CaptainHook.new
