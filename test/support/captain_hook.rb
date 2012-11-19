module HttpMonkey::Support

  # Add *before_suite* and *after_suite* on tests.
  #
  # Examples
  #
  #  describe "Sample spec" do
  #
  #    def self.before_suite
  #      puts "before all"
  #    end
  #    def self.after_suite
  #      puts "after all"
  #    end
  #
  #    it "should test something"
  #  end
class CaptainHook

    def before_suites(suites, type); end
    def after_suites(suites, type); end

    def before_suite(suite)
      suite.before_suite if suite.respond_to?(:before_suite)
    end
    def after_suite(suite)
      suite.after_suite if suite.respond_to?(:after_suite)
    end

    def before_test(suite, test); end
    # methods "pass, skip, failure, error" should call this
    #def after_test(suite, test, test_runner)
    #end

    def pass(suite, test, test_runner); end
    def skip(suite, test, test_runner); end
    def failure(suite, test, test_runner); end
    def error(suite, test, test_runner); end

  end

end
