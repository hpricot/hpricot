#!/usr/bin/env ruby

require 'test/unit'
require 'hpricot'
require 'load_files'

class TestParser < Test::Unit::TestCase
  def setup
    @basic = Hpricot.parse(TestFiles::BASIC)
    @boingboing = Hpricot.parse(TestFiles::BOINGBOING)
    @immob = Hpricot.parse(TestFiles::IMMOB)
    @uswebgen = Hpricot.parse(TestFiles::USWEBGEN)
    # @utf8 = Hpricot.parse(TestFiles::UTF8)
  end

  # def test_set_attr
  #   @basic.search('//p').set('class', 'para')
  #   assert_equal '', @basic.search('//p').map { |x| x.attributes }
  # end

  def test_scan_text
    assert_equal 'FOO', Hpricot.make("FOO").first.content
  end

  def test_get_element_by_id
    assert_equal 'link1', @basic.get_element_by_id('link1')['id']
    assert_equal 'link1', @basic.get_element_by_id('body1').get_element_by_id('link1').get_attribute('id')
  end

  def test_get_element_by_tag_name
    assert_equal 'link1', @basic.get_elements_by_tag_name('a')[0].get_attribute('id')
    assert_equal 'link1', @basic.get_elements_by_tag_name('body')[0].get_element_by_id('link1').get_attribute('id')
  end

  def test_output_basic
    @basic2 = Hpricot.parse(@basic.inner_html)
    scan_basic @basic2
  end

  def test_scan_basic
    scan_basic @basic
  end

  def scan_basic doc
    assert_equal 'link1', doc.at('#link1')['id']
    assert_equal 'link1', doc.at("p a")['id']
    assert_equal 'link1', (doc/:p/:a).first['id']
    assert_equal 'link1', doc.search('p').at('a').get_attribute('id')
    assert_equal 'link2', (doc/'p').filter('.ohmy').search('a').first.get_attribute('id')
    assert_equal (doc/'p')[2], (doc/'p').filter(':nth(2)')[0]
    assert_equal 4, (doc/'p').filter('*').length
    assert_equal 4, (doc/'p').filter('* *').length
    eles = (doc/'p').filter('.ohmy')
    assert_equal 1, eles.length
    assert_equal 'ohmy', eles.first.get_attribute('class')
    assert_equal 3, (doc/'p:not(.ohmy)').length
    assert_equal 3, (doc/'p').not('.ohmy').length
    assert_equal 3, (doc/'p').not(eles.first).length
    assert_equal 2, (doc/'p').filter('[@class]').length
    assert_equal 'last final', (doc/'p[@class~="final"]').first.get_attribute('class')
    assert_equal 1, (doc/'p').filter('[@class~="final"]').length
    assert_equal 2, (doc/'p > a').length
    assert_equal 1, (doc/'p.ohmy > a').length
    assert_equal 2, (doc/'p / a').length
    assert_equal 2, (doc/'link ~ link').length
    assert_equal 3, (doc/'title ~ link').length
  end

  def test_scan_boingboing
    assert_equal 60, (@boingboing/'p.posted').length
    assert_equal 1, @boingboing.search("//a[@name='027906']").length
  end

  def test_css_negation
    assert_equal 3, (@basic/'p:not(.final)').length
  end

  def test_remove_attribute
    (@basic/:p).each { |ele| ele.remove_attribute('class') }
    assert_equal 0, (@basic/'p[@class]').length
  end

  def test_abs_xpath
    assert_equal 60, @boingboing.search("/html/body//p[@class='posted']").length
    assert_equal 60, @boingboing.search("/*/body//p[@class='posted']").length
    assert_equal 18, @boingboing.search("//script").length
    divs = @boingboing.search("//script/../div")
    assert_equal 2,  divs.length
    assert_equal 1,  divs.search('a').length
    imgs = @boingboing.search('//div/p/a/img')
    assert_equal 15, imgs.length
    assert_equal 17, @boingboing.search('//div').search('p/a/img').length
    assert imgs.all? { |x| x.name == 'img' }
  end

  def test_predicates
    assert_equal 2, @boingboing.search('//link[@rel="alternate"]').length
    p_imgs = @boingboing.search('//div/p[/a/img]')
    assert_equal 15, p_imgs.length
    assert p_imgs.all? { |x| x.name == 'p' }
    p_imgs = @boingboing.search('//div/p[a/img]')
    assert_equal 18, p_imgs.length
    assert p_imgs.all? { |x| x.name == 'p' }
    assert_equal 1, @boingboing.search('//input[@checked]').length
  end

  def test_alt_predicates
    assert_equal 2, @boingboing.search('//table/tr:last').length
    assert_equal "<p>The third paragraph</p>",
        @basic.search('p:eq(2)').to_html
    assert_equal '<p class="last final"><b>THE FINAL PARAGRAPH</b></p>',
        @basic.search('p:last').to_html
    assert_equal 'last final', @basic.search('//p:last-of-type').first.get_attribute('class')
  end

  def test_many_paths
    assert_equal 62, @boingboing.search('p.posted, link[@rel="alternate"]').length
    assert_equal 20, @boingboing.search('//div/p[a/img]|//link[@rel="alternate"]').length
  end

  def test_body_newlines
    body = @immob.at(:body)
    {'background' => '', 'bgcolor' => '#ffffff', 'text' => '#000000', 'marginheight' => '10',
     'marginwidth' => '10', 'leftmargin' => '10', 'topmargin' => '10', 'link' => '#000066',
     'alink' => '#ff6600', 'hlink' => "#ff6600", 'vlink' => "#000000"}.each do |k, v|
        assert_equal v, body[k]
    end
  end

  def test_javascripts
    assert_equal 3, (@immob/:script)[0].inner_html.scan(/<LINK/).length
  end

  def test_uswebgen
    # sent by brent beardsley, hpricot 0.3 had problems with all the links.
    assert_equal 67, (@uswebgen/:a).length
  end

  def test_unicode
  end
end
