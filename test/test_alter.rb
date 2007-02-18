#!/usr/bin/env ruby

require 'test/unit'
require 'hpricot'
require 'load_files'

class TestAlter < Test::Unit::TestCase
  def test_before
    @basic = Hpricot.parse(TestFiles::BASIC)
    test0 = "<link rel='stylesheet' href='test0.css' />"
    @basic.at("link").before(test0)
    assert_equal 'test0.css', @basic.at("link").attributes['href']
  end

  def test_after
    @basic = Hpricot.parse(TestFiles::BASIC)
    test_inf = "<link rel='stylesheet' href='test_inf.css' />"
    @basic.search("link")[-1].after(test_inf)
    assert_equal 'test_inf.css', @basic.search("link")[-1].attributes['href']
  end
end
