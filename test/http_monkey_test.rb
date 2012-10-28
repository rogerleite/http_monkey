require "test_helper"

describe HttpMonkey do

  it "#at" do
    HttpMonkey.at("http://google.com.br").must_be_instance_of(HttpMonkey::EntryPoint)
  end

end
