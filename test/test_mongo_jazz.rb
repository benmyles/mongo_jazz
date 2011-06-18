require File.expand_path(File.dirname(__FILE__)) + "/helper"

class TestMongoJazz < Test::Unit::TestCase
  should "validate" do
    c = Customer.new

    assert_equal [["jumps", "is missing"]], c.validate
    c.doc['jumps'] = 75
    assert_equal [], c.validate
    c.doc['jumps'] = 100_001
    assert_equal [["jumps", "nobody has THAT many jumps"]], c.validate
    c.doc['jumps'] = 75
    assert_equal [], c.validate

    c.doc['emails']  = []
    c.doc['emails'] << { 'addr' => "invalidemail", "type" => "personal" }
    assert_equal [["emails[0].addr", "email is invalid"]], c.validate
    c.doc['emails'][0]['type'] = "invalid"
    assert_equal [["emails[0].addr", "email is invalid"],
                  ["emails[0].type", "email type is invalid"]], c.validate
    c.doc['emails'][0]['addr'] = "foo@bar.com"
    c.doc['emails'][0]['type'] = "personal"
    assert_equal [], c.validate
  end
end
