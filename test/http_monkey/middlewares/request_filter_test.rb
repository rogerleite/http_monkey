require "test_helper"

describe HttpMonkey::Middlewares::RequestFilter do

  before do
    @mock_app = stub("app", :call => "stubbed")
  end

  let(:env) { HttpMonkey::Client::Environment.new }
  subject { HttpMonkey::Middlewares::RequestFilter }

  it "always call app" do
    @mock_app.expects(:call).with(env)
    subject.new(@mock_app).call(env)
  end

  it "executes block" do
    stub_req = stub("req")
    env["http_monkey.request"] = [nil, stub_req, nil]
    flag = "out block"

    middle = subject.new(@mock_app) do |env, req|
      env.must_respond_to(:monkey_request)
      req.must_be_same_as(stub_req)
      flag = "inside block"
    end
    middle.call(env)

    flag.must_equal("inside block")
  end

end
