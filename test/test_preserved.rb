#!/usr/bin/env ruby

require 'test/unit'
require 'hpricot'

class TestPreserved < Test::Unit::TestCase
  def test_simple
    str = "<p>Hpricot is a <b>you know <i>uh</b> fine thing.</p>"
    doc = Hpricot(str)
    assert_equal str, doc.to_original_html
  end
end
