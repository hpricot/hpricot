Gem::Specification.new do |s|
  s.name = %q{hpricot}
  s.version = "0.8.4"
 
  s.authors = ["why the lucky stiff"]
  s.date = %q{2011-02-28}
  s.description = %q{a swift, liberal HTML parser with a fantastic library}
  s.email = %q{why@ruby-lang.org}
  s.extensions = ["ext/fast_xs/extconf.rb", "ext/hpricot_scan/extconf.rb"]
  s.extra_rdoc_files = ["README.md", "CHANGELOG", "COPYING"]
  s.files = %w(.gitignore CHANGELOG COPYING README.md Rakefile ext/fast_xs/FastXsService.java ext/fast_xs/extconf.rb ext/fast_xs/fast_xs.c ext/hpricot_scan/HpricotCss.java ext/hpricot_scan/HpricotScanService.java ext/hpricot_scan/MANIFEST ext/hpricot_scan/extconf.rb ext/hpricot_scan/hpricot_common.rl ext/hpricot_scan/hpricot_css.c ext/hpricot_scan/hpricot_css.java.rl ext/hpricot_scan/hpricot_css.rl ext/hpricot_scan/hpricot_scan.c ext/hpricot_scan/hpricot_scan.h ext/hpricot_scan/hpricot_scan.java.rl ext/hpricot_scan/hpricot_scan.rl extras/hpricot.png hpricot.gemspec lib/hpricot.rb lib/hpricot/blankslate.rb lib/hpricot/builder.rb lib/hpricot/elements.rb lib/hpricot/htmlinfo.rb lib/hpricot/inspect.rb lib/hpricot/modules.rb lib/hpricot/parse.rb lib/hpricot/tag.rb lib/hpricot/tags.rb lib/hpricot/traverse.rb lib/hpricot/xchar.rb setup.rb test/files/basic.xhtml test/files/boingboing.html test/files/cy0.html test/files/immob.html test/files/pace_application.html test/files/tenderlove.html test/files/uswebgen.html test/files/utf8.html test/files/week9.html test/files/why.xml test/load_files.rb test/nokogiri-bench.rb test/test_alter.rb test/test_builder.rb test/test_parser.rb test/test_paths.rb test/test_preserved.rb test/test_xml.rb)
  s.has_rdoc = true
  s.homepage = %q{http://wiki.github.com/hpricot/hpricot}
  s.rdoc_options = ["--quiet", "--title", "The Hpricot Reference", "--main", "README", "--inline-source"]
  s.require_paths = ["lib"]
  s.summary = %q{a swift, liberal HTML parser with a fantastic library}
end
