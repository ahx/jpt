require "minitest/spec"
require "test_helper"
require "json"

describe JPT do
  JSON.parse(File.read("test/jsonpath-compliance-test-suite/cts.json")).fetch("tests").each do |test|
    name = test["name"]
    selector = test.fetch("selector")

    if test["invalid_selector"]
      it "fails with invalid selector #{selector.inspect} (#{name.inspect})" do
        # Should this really raise? – Some "invalid selectors" just work.
        assert_raises do
          JPT.from_jp(selector)
        end
      end
      next
    end

    it "queries #{selector.inspect} (#{name.inspect})" do
      document = test["document"]
      if test.key?("result")
        result = JPT.from_jp(selector).apply(document)
        assert_equal(result, test["result"])
      elsif test.key?("results")
        result = JPT.from_jp(selector).apply(document)
        assert_includes(test["results"], result)
      else
        raise "don't know how to test #{name} – #{test.inspect}"
      end
    end
  end
end
