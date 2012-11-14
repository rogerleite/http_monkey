require "test_helper"

describe HttpMonkey::Middlewares::DefaultHeaders do

  before do
    @mock_app = stub("app", :call => "stubbed")
  end

  let(:fake_env) { Hash.new }
  subject { HttpMonkey::M::DefaultHeaders }

  it "always call app" do
    @mock_app.expects(:call).with(fake_env)
    subject.new(@mock_app).call(fake_env)
  end

  it "sets header" do
    middle = subject.new(@mock_app, {"X-Custom" => "value"})
    middle.call(fake_env)

    fake_env["HTTP_X_CUSTOM"].must_equal("value")
  end

  it "not overwrite header" do
    fake_env["HTTP_X_CUSTOM"] = "request"
    middle = subject.new(@mock_app, {"X-Custom" => "value"})
    middle.call(fake_env)

    fake_env["HTTP_X_CUSTOM"].must_equal("request")
  end

end
