require "test_helper"

describe HttpMonkey::Middlewares::RequestFilter do

  include HttpMonkey::Support::FakeEnvironment

  before do
    @mock_app = stub("app", :call => "stubbed")
  end

  subject { HttpMonkey::M::RequestFilter }

  it "always call app" do
    @mock_app.expects(:call).with(fake_env)
    subject.new(@mock_app).call(fake_env)
  end

  it "executes block" do
    flag = "out block"

    middle = subject.new(@mock_app) do |env, req|
      env.must_be_same_as(fake_env)
      req.must_be_same_as(fake_request)
      flag = "inside block"
    end
    middle.call(fake_env)

    flag.must_equal("inside block")
  end

end
