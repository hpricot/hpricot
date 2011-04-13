#!/usr/bin/env ruby

require 'test/unit'
require 'hpricot'
require 'load_files'

class TestParser < Test::Unit::TestCase
  def test_roundtrip
    @basic = Hpricot.parse(TestFiles::BASIC)
    %w[link link[2] body #link1 a p.ohmy].each do |css_sel|
      ele = @basic.at(css_sel)
      assert_equal ele, @basic.at(ele.css_path)
      assert_equal ele, @basic.at(ele.xpath)
    end
  end
  def test_attr_brackets
    doc = Hpricot('<input name="vendor[porkpies]"/>')
    assert_equal 1, (doc/'input[@name^="vendor[porkpies]"]').length
    assert_equal 1, (doc/'input[@name="vendor[porkpies]"]').length
    assert_equal 0, (doc/'input[@name$="]]]]]"]').length

    doc = Hpricot('<input name="vendor[porkpies][meaty]"/>')
    assert_equal 1, (doc/'input[@name^="vendor[porkpies][meaty]"]').length
  end
  # Colons should work according to:
  # http://www.w3.org/TR/2000/REC-xml-20001006#NT-Name
  def test_attr_double_colon
    doc = Hpricot('<input name="11:00:00PM"/>')
    assert_equal 1, (doc/'input[@name^="11:00:00PM"]').length
  end
  # This is not a name attribute, but it should not throw exceptions
  def test_attr_exclamation_mark
    doc = Hpricot('<input name="hello!"/>')
    assert_equal 1, (doc/'input[@name^="hello!"]').length
  end
end
