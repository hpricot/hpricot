#!/usr/bin/env ruby

require 'test/unit'
require 'hpricot'
require 'load_files'

class TestPreserved < Test::Unit::TestCase
  def assert_roundtrip str
    doc = Hpricot(str)
    yield doc if block_given?
    str2 = doc.to_original_html
    [*str].zip([*str2]).each do |s1, s2|
      assert_equal s1, s2
    end
  end

  def assert_html str1, str2
    doc = Hpricot(str2)
    yield doc if block_given?
    assert_equal str1, doc.to_original_html
  end

  def test_simple
    str = "<p>Hpricot is a <b>you know <i>uh</b> fine thing.</p>"
    assert_html str, str
    assert_html "<p class=\"new\">Hpricot is a <b>you know <i>uh</b> fine thing.</p>", str do |doc|
      (doc/:p).set('class', 'new')
    end
  end

  def test_parent
    str = "<html><base href='/'><head><title>Test</title></head><body><div id='wrap'><p>Paragraph one.</p><p>Paragraph two.</p></div></body></html>"
    assert_html str, str
    assert_html "<html><base href='/'><body><div id=\"all\"><div><p>Paragraph one.</p></div><div><p>Paragraph two.</p></div></div></body></html>", str do |doc|
      (doc/:head).remove
      (doc/:div).set('id', 'all')
      (doc/:p).wrap('<div></div>')
    end
  end

  def test_files
    assert_roundtrip TestFiles::BASIC
    assert_roundtrip TestFiles::BOINGBOING
    assert_roundtrip TestFiles::CY0
  end
end
