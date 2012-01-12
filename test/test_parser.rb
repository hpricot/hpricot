# -*- coding: utf-8 -*-
#!/usr/bin/env ruby

require 'test/unit'
require 'hpricot'
require 'load_files'

class TestParser < Test::Unit::TestCase
  def test_set_attr
    @basic = Hpricot.parse(TestFiles::BASIC)
    @basic.search('//p').set('class', 'para')
    assert_equal 4, @basic.search('//p').length
    assert_equal 4, @basic.search('//p').find_all { |x| x['class'] == 'para' }.length
  end

  # Test creating a new element
  def test_new_element
    elem = Hpricot::Elem.new('form')
    assert_not_nil(elem)
    assert_not_nil(elem.attributes)
  end

  def test_scan_text
    assert_equal 'FOO', Hpricot.make("FOO").children.first.content
  end

  def test_filter_by_attr
    @boingboing = Hpricot.parse(TestFiles::BOINGBOING)

    # this link is escaped in the doc
    link = 'http://www.youtube.com/watch?v=TvSNXyNw26g&search=chris%20ware'
    assert_equal link, @boingboing.at("a[@href='#{link}']")['href']
  end

  def test_filter_contains
    @basic = Hpricot.parse(TestFiles::BASIC)
    assert_equal '<title>Sample XHTML</title>', @basic.search("title:contains('Sample')").to_s
  end

  def test_get_element_by_id
    @basic = Hpricot.parse(TestFiles::BASIC)
    assert_equal 'link1', @basic.get_element_by_id('link1')['id']
    assert_equal 'link1', @basic.get_element_by_id('body1').get_element_by_id('link1').get_attribute('id')
  end

  def test_get_element_by_tag_name
    @basic = Hpricot.parse(TestFiles::BASIC)
    assert_equal 'link1', @basic.get_elements_by_tag_name('a')[0].get_attribute('id')
    assert_equal 'link1', @basic.get_elements_by_tag_name('body')[0].get_element_by_id('link1').get_attribute('id')
  end

  def test_get_elements_by_tag_name_star
    simple = Hpricot.parse("<div><p id='first'>First</p><p id='second'>Second</p></div>")
    assert_equal 3, simple.get_elements_by_tag_name("*").size
    assert_equal 1, simple.get_elements_by_tag_name("div").size
    assert_equal 2, simple.get_elements_by_tag_name("p").size
  end

  def test_output_basic
    @basic = Hpricot.parse(TestFiles::BASIC)
    @basic2 = Hpricot.parse(@basic.inner_html)
    scan_basic @basic2
  end

  def test_scan_basic
    @basic = Hpricot.parse(TestFiles::BASIC)
    scan_basic @basic
  end

  def scan_basic doc
    assert_kind_of Hpricot::XMLDecl, doc.children.first
    assert_not_equal doc.children.first.to_s, doc.children[1].to_s
    assert_equal 'link1', doc.at('#link1')['id']
    assert_equal 'link1', doc.at("p a")['id']
    assert_equal 'link1', (doc/:p/:a).first['id']
    assert_equal 'link1', doc.search('p').at('a').get_attribute('id')
    assert_equal 'link2', (doc/'p').filter('.ohmy').search('a').first.get_attribute('id')
    assert_equal (doc/'p')[2], (doc/'p').filter(':nth(2)')[0]
    assert_equal (doc/'p')[2], (doc/'p').filter('[3]')[0]
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
    assert_equal 5, (doc/"//p/text()").length
    assert_equal 6, (doc/"//p[a]//text()").length
    assert_equal 2, (doc/"//p/a/text()").length
  end

  def test_positional
    h = Hpricot( "<div><br/><p>one</p><p>two</p></div>" )
    assert_equal "<p>one</p>", h.search("//div/p:eq(0)").to_s
    assert_equal "<p>one</p>", h.search("//div/p:first").to_s
    assert_equal "<p>one</p>", h.search("//div/p:first()").to_s
  end

  def test_pace
    doc = Hpricot(TestFiles::PACE_APPLICATION)
    assert_equal 'get', doc.at('form[@name=frmSect11]')['method']
    # assert_equal '2', doc.at('#hdnSpouse')['value']
  end

  def test_scan_boingboing
    @boingboing = Hpricot.parse(TestFiles::BOINGBOING)
    assert_equal 60, (@boingboing/'p.posted').length
    assert_equal 1, @boingboing.search("//a[@name='027906']").length
    assert_equal 10, @boingboing.search("script comment()").length
    assert_equal 3, @boingboing.search("a[text()*='Boing']").length
    assert_equal 1, @boingboing.search("h3[text()='College kids reportedly taking more smart drugs']").length
    assert_equal 0, @boingboing.search("h3[text()='College']").length
    assert_equal 60, @boingboing.search("h3").length
    assert_equal 59, @boingboing.search("h3[text()!='College kids reportedly taking more smart drugs']").length
    assert_equal 17, @boingboing.search("h3[text()$='s']").length
    assert_equal 116, @boingboing.search("p[text()]").length
    assert_equal 211, @boingboing.search("p").length
  end

  def test_reparent
    doc = Hpricot(%{<div id="blurb_1"></div>})
    div1 = doc.search('#blurb_1')
    div1.before('<div id="blurb_0"></div>')

    div0 = doc.search('#blurb_0')
    div0.before('<div id="blurb_a"></div>')

    assert_equal 'div', doc.at('#blurb_1').name
  end

  def test_siblings
    @basic = Hpricot.parse(TestFiles::BASIC)
    t = @basic.at(:title)
    e = t.next_sibling
    assert_equal 'test1.css', e['href']
    assert_equal 'title', e.previous_sibling.name
  end

  def test_css_negation
    @basic = Hpricot.parse(TestFiles::BASIC)
    assert_equal 3, (@basic/'p:not(.final)').length
  end

  def test_remove_attribute
    @basic = Hpricot.parse(TestFiles::BASIC)
    (@basic/:p).each { |ele| ele.remove_attribute('class') }
    assert_equal 0, (@basic/'p[@class]').length
  end

  def test_abs_xpath
    @boingboing = Hpricot.parse(TestFiles::BOINGBOING)
    assert_equal 60, @boingboing.search("/html/body//p[@class='posted']").length
    assert_equal 60, @boingboing.search("/*/body//p[@class='posted']").length
    assert_equal 18, @boingboing.search("//script").length
    divs = @boingboing.search("//script/../div")
    assert_equal 2,  divs.length
    imgs = @boingboing.search('//div/p/a/img')
    assert_equal 16, imgs.length
    assert_equal 16, @boingboing.search('//div').search('p/a/img').length
    assert imgs.all? { |x| x.name == 'img' }
  end

  def test_predicates
    @boingboing = Hpricot.parse(TestFiles::BOINGBOING)
    assert_equal 2, @boingboing.search('//link[@rel="alternate"]').length
    p_imgs = @boingboing.search('//div/p[/a/img]')
    assert_equal 16, p_imgs.length
    assert p_imgs.all? { |x| x.name == 'p' }
    p_imgs = @boingboing.search('//div/p[a/img]')
    assert_equal 16, p_imgs.length
    assert p_imgs.all? { |x| x.name == 'p' }
    assert_equal 1, @boingboing.search('//input[@checked]').length
  end

  def test_tag_case
    @tenderlove = Hpricot.parse(TestFiles::TENDERLOVE)
    assert_equal 2, @tenderlove.search('//a').length
    assert_equal 3, @tenderlove.search('//area').length
    assert_equal 2, @tenderlove.search('//meta').length
  end

  def test_alt_predicates
    @boingboing = Hpricot.parse(TestFiles::BOINGBOING)
    assert_equal 1, @boingboing.search('//table/tr:last').length

    @basic = Hpricot.parse(TestFiles::BASIC)
    assert_equal "<p>The third paragraph</p>",
        @basic.search('p:eq(2)').to_html
    assert_equal '<p class="last final"><b>THE FINAL PARAGRAPH</b></p>',
        @basic.search('p:last').to_html
    assert_equal 'last final', @basic.search('//p:last-of-type').first.get_attribute('class')
  end

  def test_insert_after # ticket #63
    doc = Hpricot('<html><body><div id="a-div"></div></body></html>')
    (doc/'div').each do |element|
      element.after('<p>Paragraph 1</p><p>Paragraph 2</p>')
    end
    assert_equal doc.to_html, '<html><body><div id="a-div"></div><p>Paragraph 1</p><p>Paragraph 2</p></body></html>'
  end

  def test_insert_before # ticket #61
    doc = Hpricot('<html><body><div id="a-div"></div></body></html>')
    (doc/'div').each do |element|
      element.before('<p>Paragraph 1</p><p>Paragraph 2</p>')
    end
    assert_equal doc.to_html, '<html><body><p>Paragraph 1</p><p>Paragraph 2</p><div id="a-div"></div></body></html>'
  end

  def test_many_paths
    @boingboing = Hpricot.parse(TestFiles::BOINGBOING)
    assert_equal 62, @boingboing.search('p.posted, link[@rel="alternate"]').length
    assert_equal 18, @boingboing.search('//div/p[a/img]|//link[@rel="alternate"]').length
  end

  def test_stacked_search
    @boingboing = Hpricot.parse(TestFiles::BOINGBOING)
    assert_kind_of Hpricot::Elements, @boingboing.search('//div/p').search('a img')
  end

  def test_attr_casing
    doc = Hpricot("<a HREF='a'>A simple <b>test</b> string.</a>")
    assert_equal (doc % :a)[:href], "a"
    assert_equal (doc % :a)[:HREF], nil
    assert_equal (doc % :a)['href'], "a"
    assert_equal (doc % :a)['HREF'], nil
  end

  def test_class_search
    # test case sent by Chih-Chao Lam
    doc = Hpricot("<div class=xyz'>abc</div>")
    assert_equal 1, doc.search(".xyz").length
    doc = Hpricot("<div class=xyz>abc</div><div class=abc>xyz</div>")
    assert_equal 1, doc.search(".xyz").length
    assert_equal 4, doc.search("*").length
  end

  def test_kleene_star
    # bug noticed by raja bhatia
    doc = Hpricot("<span class='small'>1</span><div class='large'>2</div><div class='small'>3</div><span class='blue large'>4</span>")
    assert_equal 2, doc.search("*[@class*='small']").length
    assert_equal 2, doc.search("*.small").length
    assert_equal 2, doc.search(".small").length
    assert_equal 2, doc.search(".large").length
  end

  def test_empty_comment
    doc = Hpricot("<p><!----></p>")
    assert doc.children[0].children[0].comment?
    doc = Hpricot("<p><!-- --></p>")
    assert doc.children[0].children[0].comment?
  end

  def test_body_newlines
    @immob = Hpricot.parse(TestFiles::IMMOB)
    body = @immob.at(:body)
    {'background' => '', 'bgcolor' => '#ffffff', 'text' => '#000000', 'marginheight' => '10',
     'marginwidth' => '10', 'leftmargin' => '10', 'topmargin' => '10', 'link' => '#000066',
     'alink' => '#ff6600', 'hlink' => "#ff6600", 'vlink' => "#000000"}.each do |k, v|
        assert_equal v, body[k]
    end
  end

  def test_nested_twins
    @doc = Hpricot("<div>Hi<div>there</div></div>")
    assert_equal 1, (@doc/"div div").length
  end

  def test_wildcard
    @basic = Hpricot.parse(TestFiles::BASIC)
    assert_equal 3, (@basic/"*[@id]").length
    assert_equal 3, (@basic/"//*[@id]").length
  end

  def test_javascripts
    @immob = Hpricot.parse(TestFiles::IMMOB)
    assert_equal 3, (@immob/:script)[0].inner_html.scan(/<LINK/).length
  end

  def test_nested_scripts
    @week9 = Hpricot.parse(TestFiles::WEEK9)
    assert_equal 14, (@week9/"a").find_all { |x| x.inner_html.include? "GameCenter" }.length
  end

  def test_uswebgen
    @uswebgen = Hpricot.parse(TestFiles::USWEBGEN)
    # sent by brent beardsley, hpricot 0.3 had problems with all the links.
    assert_equal 67, (@uswebgen/:a).length
  end

  def test_mangled_tags
    [%{<html><form name='loginForm' method='post' action='/units/a/login/1,13088,779-1,00.html'?URL=></form></html>},
     %{<html><form name='loginForm' ?URL= method='post' action='/units/a/login/1,13088,779-1,00.html'></form></html>},
     %{<html><form name='loginForm'?URL= ?URL= method='post' action='/units/a/login/1,13088,779-1,00.html'?URL=></form></html>},
     %{<html><form name='loginForm' method='post' action='/units/a/login/1,13088,779-1,00.html' ?URL=></form></html>}].
    each do |str|
      doc = Hpricot(str)
      assert_equal 1, (doc/:form).length
      assert_equal '/units/a/login/1,13088,779-1,00.html', doc.at("form")['action']
    end
  end

  def test_procins
    doc = Hpricot("<?php print('hello') ?>\n<?xml blah='blah'?>")
    assert_equal "php", doc.children[0].target
    assert_equal "blah='blah'", doc.children[2].content
  end

  def test_no_buffer_error
    Hpricot(%{<p>\n\n<input type="hidden" name="__VIEWSTATE"  value="#{(("X" * 2000) + "\n") * 44}" />\n\n</p>})
  end

  def test_youtube_attr
    str = <<-edoc
    <html><body>
    Lorem ipsum. Jolly roger, ding-dong sing-a-long
    <object width="425" height="350">
      <param name="movie" value="http://www.youtube.com/v/NbDQ4M_cuwA"></param>
      <param name="wmode" value="transparent"></param>
        <embed src="http://www.youtube.com/v/NbDQ4M_cuwA"
          type="application/x-shockwave-flash" wmode="transparent" width="425" height="350">
        </embed>
    </object>
    Check out my posting, I have bright mice in large clown cars.
    <object width="425" height="350">
      <param name="movie" value="http://www.youtube.com/v/foobar"></param>
      <param name="wmode" value="transparent"></param>
        <embed src="http://www.youtube.com/v/foobar"
          type="application/x-shockwave-flash" wmode="transparent" width="425" height="350">
        </embed>
    </object>
    </body></html?
    edoc
    doc = Hpricot(str)
    assert_equal "http://www.youtube.com/v/NbDQ4M_cuwA",
      doc.at("//object/param[@value='http://www.youtube.com/v/NbDQ4M_cuwA']")['value']
  end

  # ticket #84 by jamezilla
  def test_screwed_xmlns
    doc = Hpricot(<<-edoc)
      <?xml:namespace prefix = cwi />
      <html><body>HAI</body></html>
    edoc
    assert_equal "HAI", doc.at("body").inner_text
  end

  # http://github.com/hpricot/hpricot/issues#issue/28
  def test_invalid_inner_text
    assert_equal "A", Hpricot('A&B;').inner_text[0...1]
  end

  # http://github.com/hpricot/hpricot/issues#issue/25
  def test_encoding_compatibility_error
    Hpricot("<p>\xC3\x9Cber</p><p>M&sup3;</p>").inner_text
  end

  # Reported by Jonathan Nichols on the Hpricot list (24 May 2007)
  def test_self_closed_form
    doc = Hpricot(<<-edoc)
      <body>
      <form action="/loginRegForm" name="regForm" method="POST" />
      <input type="button">
      </form>
      </body>
    edoc
    assert_equal "button", doc.at("//form/input")['type']
  end

  def test_escaped_quote
    # Backslash '\' is not an escape character in HTML.
    doc = Hpricot("<div><input type='text' value='C:\\dir\\' /><p id='test_id'>test</p></div>")
    assert_equal "C:\\dir\\", doc.at("input")["value"]
    doc = Hpricot('<div><input type="text" value="C:\\dir\\" /><p id="test_id">test</p></div>')
    assert_equal "C:\\dir\\", doc.at("input")["value"]
  end

  def test_filters
    @basic = Hpricot.parse(TestFiles::BASIC)
    assert_equal 0, (@basic/"title:parent").size
    assert_equal 3, (@basic/"p:parent").size
    assert_equal 3, (@basic/"link:empty").size
    assert_equal 1, (@basic/"span:empty").size
  end

  def test_keep_cdata
    str = %{<script> /*<![CDATA[*/
    /*]]>*/ </script>}
    assert_equal str, Hpricot(str).to_html
  end

  def test_namespace
    chunk = <<-END
    <a xmlns:t="http://www.nexopia.com/dev/template">
      <t:sam>hi </t:sam>
    </a>
    END
    doc = Hpricot::XML(chunk)
    assert (doc/"//t:sam").size > 0 # at least this should probably work
    # assert (doc/"//sam").size > 0  # this would be nice
  end

  def test_uxs_ignores_non_entities
    assert_equal 'abc', Hpricot.uxs('abc')
  end

  def test_uxs_handles_gt_lt_amp_quot
    assert_equal '"&<>', Hpricot.uxs('&quot;&amp;&lt;&gt;')
  end

  def test_uxs_handles_numeric_values
    if String.method_defined? :encoding
      assert_equal "é", Hpricot.uxs('&#233;')
    else
      assert_equal "\303\251", Hpricot.uxs('&#233;')
    end
  end

  def test_uxs_handles_hexadecimal_values
    if String.method_defined? :encoding
      assert_equal "é", Hpricot.uxs('&#xe9;')
    else
      assert_equal "\303\251", Hpricot.uxs('&#xe9;')
    end
  end

  def test_uxs_handles_entities
    if String.method_defined? :encoding
      assert_equal "é", Hpricot.uxs('&eacute;')
    else
      assert_equal "\303\251", Hpricot.uxs('&eacute;')
    end
  end

  def test_cdata_inner_text
    xml = Hpricot.XML(%{
      <peon>
        <id>96586</id>
        <stdout><![CDATA[This is STDOUT]]></stdout>
        <stderr><!-- IGNORE --><![CDATA[This is]]> STDERR</stderr>
      </peon>})
      assert_equal "This is STDOUT", (xml/:peon/:stdout).inner_text
      assert_equal "This is STDERR", (xml/:peon/:stderr).inner_text
  end

  def test_parsing_html_with_noscript
   doc = Hpricot(<<-edoc)
    <html>
    <head>
    <noscript>
    <meta http-equiv="refresh" content="0; url=http://www.yoursite.com/noscripts.html"/>
    </noscript>
    <meta name="verification" content="7ff5e90iormq5niy6x98j75" />
    </head>
    <body>
    <h1>Testing</h1>
    </body>
    </html>

   edoc
    assert_equal "7ff5e90iormq5niy6x98j75", doc.at("/html/head/meta[@name='verification']")['content']
 end
 
 def test_nil_attr
   # parsing this file was failing on JRuby
   assert_nothing_raised {Hpricot.parse(TestFiles::BNQT)}
 end

 def test_unknown_tag
   header = <<-edoc
<header id="htest">
  <div id="dtest">blah</div>
</header>
   edoc
   doc = Hpricot(<<-edoc)
      <div>#{header}</div>
    edoc
   assert_equal header.chomp, (doc/"#htest").to_html
 end

 def test_nested_unknown_tags
   header =
     %(<header id="htest"><div id="dtest"><nav>blah</nav></div></header>)
   doc = Hpricot(%(<div>#{header}</div>))
   assert_equal header.chomp, (doc/"#htest").to_html
 end
end
