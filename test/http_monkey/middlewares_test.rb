require "test_helper"

describe HttpMonkey::Middlewares do
  it "alias to M" do
    HttpMonkey::Middlewares.must_be_same_as(HttpMonkey::M)
  end
end
