require "http_monkey"

require "minitest/autorun"
require "minitest/reporters"

require "webmock/minitest"
require "mocha"

MiniTest::Unit.runner = MiniTest::SuiteRunner.new
MiniTest::Unit.runner.reporters << MiniTest::Reporters::SpecReporter.new

WebMock.disable_net_connect!
