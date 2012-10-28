require "test_helper"

describe HttpMonkey do

  it "#at" do
    HttpMonkey.at("http://google.com.br").must_be_instance_of(HttpMonkey::EntryPoint)
  end

  it "#configure" do
    HttpMonkey.configure do
      net_adapter :curb
    end
    HttpMonkey.default_client.net_adapter.must_equal(:curb)
  end

  it "#build" do
    HttpMonkey.build.wont_be_same_as(HttpMonkey.default_client)
  end

end
