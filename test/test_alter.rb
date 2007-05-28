#!/usr/bin/env ruby

require 'test/unit'
require 'hpricot'
require 'load_files'

class TestAlter < Test::Unit::TestCase
  def setup
    @basic = Hpricot.parse(TestFiles::BASIC)
  end
  
  def test_before
    test0 = "<link rel='stylesheet' href='test0.css' />"
    @basic.at("link").before(test0)
    assert_equal 'test0.css', @basic.at("link").attributes['href']
  end

  def test_after
    test_inf = "<link rel='stylesheet' href='test_inf.css' />"
    @basic.search("link")[-1].after(test_inf)
    assert_equal 'test_inf.css', @basic.search("link")[-1].attributes['href']
  end

  def test_wrap
    ohmy = (@basic/"p.ohmy").wrap("<div id='wrapper'></div>")
    assert_equal 'wrapper', ohmy[0].parent['id']
    assert_equal 'ohmy', Hpricot(@basic.to_html).at("#wrapper").children[0]['class']
  end
  
  def test_add_class
    first_p = @basic["p:first"].add_class("testing123")
    assert first_p[0].attributes["class"].split(" ").include?("testing123")
    assert Hpricot(@basic.to_html)["p:first"][0].attributes["class"].split(" ").include?("testing123")
    assert !Hpricot(@basic.to_html)["p:gt(0)"][0].attributes["class"].split(" ").include?("testing123")
  end
  
  def test_change_attributes
    all_ps = @basic["p"].attr("title", "Some Title")
    all_as = @basic["a"].attr("href", "http://my_new_href.com")
    assert_changed(@basic, "p", all_ps) {|p| p.attributes["title"] == "Some Title"}
    assert_changed(@basic, "a", all_as) {|a| a.attributes["href"] == "http://my_new_href.com"}
  end
  
  def assert_changed original, selector, set, &block
    assert set.all? &block
    assert Hpricot(original.to_html)[selector].all? &block
  end
end
