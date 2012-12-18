require "test_helper"

describe HttpMonkey::Client::Response do

  let(:code) { 200 }
  let(:headers) { Hash["Content-Type", "text/plain; charset=ISO-8859-4"] }
  let(:body) { ["body test"] }

  subject { HttpMonkey::Client::Response.new(code, headers, body) }

  describe "#headers" do
    it "must be instance of HttpObjects::HeadersHash" do
      subject.headers.must_be_instance_of(HttpObjects::HeadersHash)
    end
    it "access values with style" do
      subject.headers.content_type?.must_equal(true)
      subject.headers.content_type!.must_equal("text/plain; charset=ISO-8859-4")
      subject.headers.content_type.value.must_equal("text/plain")
    end
  end

  it "must be kind of HTTPI::Response" do
    subject.must_be_kind_of(HTTPI::Response)
  end

end
