require "minitest/spec"
require "test_helper"
require "json"

describe JPT do
  JSON.parse(File.read("test/jsonpath-compliance-test-suite/cts.json")).fetch("tests").each do |test|
    name = test["name"]

    it "test: #{name.inspect}" do
      if test.key?("result")
        result = JPT.from_jp(test.fetch("selector")).apply(test["document"])
        assert_equal(result, test["result"])
      elsif test["invalid_selector"]
        # Should this really raise? – Some "invalid selectors" just work.
        assert_raises do
          JPT.from_jp(test.fetch("selector"))
        end
      elsif test.key?("results")
        result = JPT.from_jp(test.fetch("selector")).apply(test["document"])
        assert_includes(test["results"], result)
      else
        raise "don't know how to test #{name} – #{test.inspect}"
      end
    end
  end
end
