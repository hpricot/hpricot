#!/usr/bin/env ruby

require 'test/unit'
require 'hpricot'
require 'load_files'

class TestParser < Test::Unit::TestCase
  def setup
    @basic = Hpricot.parse(TestFiles::BASIC)
    @boingboing = Hpricot.parse(TestFiles::BOINGBOING)
  end

  # def test_set_attr
  #   @basic.search('//p').set('class', 'para')
  #   assert_equal '', @basic.search('//p').map { |x| x.attributes }
  # end

  def test_get_element_by_id
    assert_equal 'link1', @basic.get_element_by_id('link1').get_attribute('id').to_s
    assert_equal 'link1', @basic.get_element_by_id('body1').get_element_by_id('link1').get_attribute('id').to_s
  end

  def test_get_element_by_tag_name
    assert_equal 'link1', @basic.get_elements_by_tag_name('a')[0].get_attribute('id').to_s
    assert_equal 'link1', @basic.get_elements_by_tag_name('body')[0].get_element_by_id('link1').get_attribute('id').to_s
  end

  def test_scan_basic
    assert_equal 'link1', @basic./('#link1').first.get_attribute('id').to_s
    assert_equal 'link1', @basic./('p a').first.get_attribute('id').to_s
    assert_equal 'link1', (@basic/:p/:a).first.get_attribute('id').to_s
    assert_equal 'link1', @basic.search('p').search('a').first.get_attribute('id').to_s
    assert_equal 'link2', (@basic/'p').filter('.ohmy').search('a').first.get_attribute('id').to_s
    assert_equal (@basic/'p')[2], (@basic/'p').filter(':nth(2)')[0]
    assert_equal 4, (@basic/'p').filter('*').length
    assert_equal 4, (@basic/'p').filter('* *').length
    eles = (@basic/'p').filter('.ohmy')
    assert_equal 1, eles.length
    assert_equal 'ohmy', eles.first.get_attribute('class').to_s
    assert_equal 3, (@basic/'p:not(.ohmy)').length
    assert_equal 3, (@basic/'p').not('.ohmy').length
    assert_equal 3, (@basic/'p').not(eles.first).length
    assert_equal 2, (@basic/'p').filter('[@class]').length
    assert_equal 'last final', (@basic/'p[@class~="final"]').first.get_attribute('class').to_s
    assert_equal 1, (@basic/'p').filter('[@class~="final"]').length
    assert_equal 2, (@basic/'p > a').length
    assert_equal 1, (@basic/'p.ohmy > a').length
    assert_equal 2, (@basic/'p / a').length
    assert_equal 2, (@basic/'link ~ link').length
    assert_equal 3, (@basic/'title ~ link').length
  end

  def test_scan_boingboing
    assert_equal 60, (@boingboing/'p.posted').length
    assert_equal 1, @boingboing.search("//a[@name='027906']").length
  end

  def test_abs_xpath
    assert_equal 60, @boingboing.search("/html/body//p[@class='posted']").length
    assert_equal 60, @boingboing.search("/*/body//p[@class='posted']").length
    divs = @boingboing.search("//script/../div")
    assert_equal 2,  divs.length
    assert_equal 1,  divs.search('a').length
    assert_equal 16, @boingboing.search('//div').search('p/a/img').length
    imgs = @boingboing.search('//div/p/a/img')
    assert_equal 16, imgs.length
    assert imgs.all? { |x| x.qualified_name == 'img' }
  end

  def test_predicates
    assert_equal 1, @boingboing.search('//input[@checked]').length
    assert_equal 2, @boingboing.search('//link[@rel="alternate"]').length
    p_imgs = @boingboing.search('//div/p[/a/img]')
    assert_equal 16, p_imgs.length
    assert p_imgs.all? { |x| x.qualified_name == 'p' }
    p_imgs = @boingboing.search('//div/p[a/img]')
    assert_equal 21, p_imgs.length
    assert p_imgs.all? { |x| x.qualified_name == 'p' }
  end

  def test_alt_predicates
    assert_equal 2, @boingboing.search('//table/tr:last').length
    assert_equal "<p xmlns=\"http://www.w3.org/1999/xhtml\"\n>The third paragraph</p\n>",
        @basic.search('p:eq(2)').html
    assert_equal 'last final', @basic.search('//p:last-of-type').first.get_attribute('class').to_s
  end

  def test_many_paths
    assert_equal 23, @boingboing.search('//div/p[a/img]|//link[@rel="alternate"]').length
    assert_equal 62, @boingboing.search('p.posted, link[@rel="alternate"]').length
  end
end
