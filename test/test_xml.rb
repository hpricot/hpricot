#!/usr/bin/env ruby

require 'test/unit'
require 'hpricot'
require 'load_files'

class TestParser < Test::Unit::TestCase
  # normally, the link tags are empty HTML tags.
  # contributed by laudney.
  def test_normally_empty
    doc = Hpricot::XML("<rss><channel><title>this is title</title><link>http://fake.com</link></channel></rss>")
    assert_equal "this is title", (doc/:rss/:channel/:title).text
    assert_equal "http://fake.com", (doc/:rss/:channel/:link).text
  end
end
