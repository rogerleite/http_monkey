require "test_helper"

describe HttpMonkey::Configuration::Middlewares do

  subject { HttpMonkey::Configuration::Middlewares.new }

  class MiddleBase
    def initialize(app, args = {}, &block)
      @app = app
      @args = args
      @block = block
    end
    def call(env)
      env[:args] = @args
      env[:block] = @block
      env[:app] ||= []
      env[:app] << "before #{self.class.to_s}"
      result = @app.call(env)
      env[:app] << "after #{self.class.to_s}"
      result
    end
  end

  class Middle1 < MiddleBase; end
  class Middle2 < MiddleBase; end

  let(:app) do
    Proc.new do |env|
      env[:app] << "app"
      "OK"
    end
  end

  let(:env) do
    {:app => []}
  end

  describe "#use" do
    it "delegate args" do
      subject.use Middle1, :arg1 =>'arg1', :arg2 => "arg2"
      subject.execute(app, env)
      env[:args].must_equal({:arg1 =>'arg1', :arg2 => "arg2"})
    end
    it "delegate block" do
      subject.use Middle1 do
        "Middle1 block"
      end
      subject.execute(app, env)
      env[:block].call.must_equal("Middle1 block")
    end
  end

  describe "#execute" do
    it "without chain" do
      result = subject.execute(app, env)
      result.must_equal("OK")
    end
    it "chain of one" do
      subject.use Middle1
      subject.execute(app, env)

      env[:app].must_equal(["before Middle1", "app", "after Middle1"])
    end
    it "chain of many (maintain order)" do
      subject.use Middle1
      subject.use Middle2
      subject.execute(app, env)

      env[:app].must_equal(["before Middle1", "before Middle2", "app", "after Middle2", "after Middle1"])
    end
  end

end
