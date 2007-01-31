require 'rake'
require 'rake/clean'
require 'rake/gempackagetask'
require 'rake/rdoctask'
require 'rake/testtask'
require 'fileutils'
include FileUtils

NAME = "hpricot"
REV = `svn info`[/Revision: (\d+)/, 1] rescue nil
VERS = ENV['VERSION'] || "0.4" + (REV ? ".#{REV}" : "")
CLEAN.include ['ext/hpricot_scan/*.{bundle,so,obj,pdb,lib,def,exp}', 'ext/hpricot_scan/Makefile', 
               '**/.*.sw?', '*.gem', '.config']
RDOC_OPTS = ['--quiet', '--title', 'The Hpricot Reference', '--main', 'README', '--inline-source']

desc "Does a full compile, test run"
task :default => [:compile, :test]

desc "Compiles all extensions"
task :compile => [:hpricot_scan] do
  if Dir.glob(File.join("lib","hpricot_scan.*")).length == 0
    STDERR.puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    STDERR.puts "Gem actually failed to build.  Your system is"
    STDERR.puts "NOT configured properly to build hpricot."
    STDERR.puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    exit(1)
  end
end
task :hpricot_scan => [:ragel]

desc "Packages up Hpricot."
task :package => [:clean, :ragel]

desc "Releases packages for all Hpricot packages and platforms."
task :release => [:package, :rubygems_win32]

desc "Run all the tests"
Rake::TestTask.new do |t|
    t.libs << "test"
    t.test_files = FileList['test/test_*.rb']
    t.verbose = true
end

Rake::RDocTask.new do |rdoc|
    rdoc.rdoc_dir = 'doc/rdoc'
    rdoc.options += RDOC_OPTS
    rdoc.main = "README"
    rdoc.rdoc_files.add ['README', 'CHANGELOG', 'COPYING', 'lib/**/*.rb']
end

spec =
    Gem::Specification.new do |s|
        s.name = NAME
        s.version = VERS
        s.platform = Gem::Platform::RUBY
        s.has_rdoc = true
        s.rdoc_options += RDOC_OPTS
        s.extra_rdoc_files = ["README", "CHANGELOG", "COPYING"]
        s.summary = "a swift, liberal HTML parser with a fantastic library"
        s.description = s.summary
        s.author = "why the lucky stiff"
        s.email = 'why@ruby-lang.org'
        s.homepage = 'http://code.whytheluckystiff.net/hpricot/'

        s.files = %w(COPYING README Rakefile) +
          Dir.glob("{bin,doc,test,lib,extras}/**/*") + 
          Dir.glob("ext/**/*.{h,c,rb,rl}") + 
          %w[ext/hpricot_scan/hpricot_scan.c] # needed because it's generated later
        
        s.require_path = "lib"
        #s.autorequire = "hpricot"  # no no no this is tHe 3v1l
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
  "#{ext}/*.rl",
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
  sh %{ragel ext/hpricot_scan/hpricot_scan.rl | rlcodegen -G2 -o ext/hpricot_scan/hpricot_scan.c}
end

PKG_FILES = FileList[
  "test/**/*.{rb,html,xhtml}",
  "lib/**/*.rb",
  "ext/**/*.{c,rb,h,rl}",
  "CHANGELOG", "README", "Rakefile", "COPYING",
  "extras/**/*", "lib/hpricot_scan.so"]

Win32Spec = Gem::Specification.new do |s|
  s.name = NAME
  s.version = VERS
  s.platform = Gem::Platform::WIN32
  s.has_rdoc = false
  s.extra_rdoc_files = ["README", "CHANGELOG", "COPYING"]
  s.summary = "a swift, liberal HTML parser with a fantastic library"
  s.description = s.summary
  s.author = "why the lucky stiff"
  s.email = 'why@ruby-lang.org'
  s.homepage = 'http://code.whytheluckystiff.net/hpricot/'

  s.files = PKG_FILES

  s.require_path = "lib"
  #s.autorequire = "hpricot"  # no no no this is tHe 3v1l
  s.extensions = []
  s.bindir = "bin"
end
  
WIN32_PKG_DIR = "hpricot-" + VERS

file WIN32_PKG_DIR => [:package] do
  sh "tar zxf pkg/#{WIN32_PKG_DIR}.tgz"
end

desc "Cross-compile the hpricot_scan extension for win32"
file "hpricot_scan_win32" => [WIN32_PKG_DIR] do
  cp "extras/mingw-rbconfig.rb", "#{WIN32_PKG_DIR}/ext/hpricot_scan/rbconfig.rb"
  sh "cd #{WIN32_PKG_DIR}/ext/hpricot_scan/ && ruby -I. extconf.rb && make"
  mv "#{WIN32_PKG_DIR}/ext/hpricot_scan/hpricot_scan.so", "#{WIN32_PKG_DIR}/lib"
end

desc "Build the binary RubyGems package for win32"
task :rubygems_win32 => ["hpricot_scan_win32"] do
  Dir.chdir("#{WIN32_PKG_DIR}") do
    Gem::Builder.new(Win32Spec).build
    verbose(true) {
      mv Dir["*.gem"].first, "../pkg/hpricot-#{VERS}-mswin32.gem"
    }
  end
end

CLEAN.include WIN32_PKG_DIR

task :install do
  sh %{rake package}
  sh %{sudo gem install pkg/#{NAME}-#{VERS}}
end

task :uninstall => [:clean] do
  sh %{sudo gem uninstall #{NAME}}
end
