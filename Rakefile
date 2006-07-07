require 'rake'
require 'rake/clean'
require 'rake/gempackagetask'
require 'rake/rdoctask'
require 'rake/testtask'
require 'fileutils'
include FileUtils

NAME = "hpricot"
VERS = "0.3"
CLEAN.include ['ext/hpricot_scan/*.{bundle,so,obj,pdb,lib,def,exp}', 'ext/hpricot_scan/Makefile', 
               '**/.*.sw?', '*.gem', '.config']

desc "Does a full compile, test run"
task :default => [:compile, :test]

desc "Compiles all extensions"
task :compile => [:hpricot_scan] do
  if Dir.glob(File.join("lib","hpricot_scan.*")).length == 0
    STDERR.puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    STDERR.puts "Gem actually failed to build.  Your system is"
    STDERR.puts "NOT configured properly to build Mongrel."
    STDERR.puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    exit(1)
  end
end
task :hpricot_scan => [:ragel]

desc "Packages up Hpricot."
task :package => [:clean]

desc "Run all the tests"
Rake::TestTask.new do |t|
    t.libs << "test"
    t.test_files = FileList['test/test_*.rb']
    t.verbose = true
end

spec =
    Gem::Specification.new do |s|
        s.name = NAME
        s.version = VERS
        s.platform = Gem::Platform::RUBY
        s.has_rdoc = false
        s.extra_rdoc_files = ["README", "CHANGELOG", "COPYING"]
        s.summary = "a swift, liberal HTML parser with a fantastic library"
        s.description = s.summary
        s.author = "why the lucky stiff"
        s.email = 'why@ruby-lang.org'
        s.homepage = 'http://code.whytheluckystiff.net/hpricot/'

        s.files = %w(COPYING README Rakefile) +
          Dir.glob("{bin,doc,test,lib,extras}/**/*") + 
          Dir.glob("ext/**/*.{h,c,rb}")
        
        s.require_path = "lib"
        s.autorequire = "hpricot"
        s.extensions = FileList["ext/**/extconf.rb"].to_a
        s.bindir = "bin"
    end

Rake::GemPackageTask.new(spec) do |p|
    p.need_tar = true
    p.gem_spec = spec
end

extension = "hpricot_scan"
ext = "ext/hpricot_scan"
ext_so = "#{ext}/#{extension}.#{Config::CONFIG['DLEXT']}"
ext_files = FileList[
  "#{ext}/*.c",
  "#{ext}/*.h",
  "#{ext}/extconf.rb",
  "#{ext}/Makefile",
  "lib"
] 

task "lib" do
  directory "lib"
end

desc "Builds just the #{extension} extension"
task extension.to_sym => ["#{ext}/Makefile", ext_so ]

file "#{ext}/Makefile" => ["#{ext}/extconf.rb"] do
  Dir.chdir(ext) do ruby "extconf.rb" end
end

file ext_so => ext_files do
  Dir.chdir(ext) do
    sh(PLATFORM =~ /win32/ ? 'nmake' : 'make')
  end
  cp ext_so, "lib"
end

desc "Generates the scanner code with Ragel."
task :ragel do
  sh %{/usr/local/bin/ragel ext/hpricot_scan/hpricot_scan.rl | /usr/local/bin/rlcodegen -G2 -o ext/hpricot_scan/hpricot_scan.c}
end

task :install do
  sh %{rake package}
  sh %{sudo gem install pkg/#{NAME}-#{VERS}}
end

task :uninstall => [:clean] do
  sh %{sudo gem uninstall #{NAME}}
end
