require "test_helper"

describe HttpMonkey::Client do

  subject do
    HttpMonkey::Client.new
  end

  it "#at" do
    subject.at("http://server.com").must_be_instance_of(HttpMonkey::EntryPoint)
  end

  describe "configuration attributes" do
    it "#net_adapter" do
      subject.must_respond_to(:net_adapter)
    end
    it "#storage" do
      subject.must_respond_to(:storage)
    end
  end

  describe "#configure" do
    it "returns self" do
      subject.configure.must_be_same_as(subject)
    end
    it "yields Configuration instance" do
      flag = "out block"
      subject.configure do
        self.must_be_instance_of(HttpMonkey::Configuration)
        flag = "inner block"
      end
      flag.must_equal("inner block")
    end
  end

  describe "request error" do
    before do
      subject.configure do
        middlewares do
          self.expects(:execute).raises("request timeout")
        end
      end
    end

    let(:fake_request) do
      HTTPI::Request.new("http://fake.com")
    end

    it "raise error by default" do
      lambda {
        subject.http_request(:get, fake_request)
      }.must_raise(RuntimeError)
    end
    it "can intercept error" do
      subject.configure do
        behaviours.on_error do |client, request, error|
          [client, request, error]
        end
      end
      client, request, error = subject.http_request(:get, fake_request)
      client.must_equal(subject)
      request.must_equal(fake_request)
      error.message.must_equal("request timeout")
    end
  end

end
