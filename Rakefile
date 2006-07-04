require 'rake'
require 'rake/clean'
require 'rake/gempackagetask'
require 'rake/rdoctask'
require 'fileutils'
include FileUtils

NAME = "hpricot"
VERS = "0.1"
CLEAN.include ['**/.*.sw?', '*.gem', '.config']

desc "Packages up Hpricot."
task :default => [:package]
task :package => [:clean]

spec =
    Gem::Specification.new do |s|
        s.name = NAME
        s.version = VERS
        s.platform = Gem::Platform::RUBY
        s.has_rdoc = true
        s.extra_rdoc_files = ["README", "CHANGELOG", "COPYING"]
        s.summary = "a swift, liberal HTML parser with a fantastic library"
        s.description = s.summary
        s.author = "why the lucky stiff"
        s.email = 'why@ruby-lang.org'
        s.homepage = 'http://code.whytheluckystiff.net/hpricot/'
        s.executables = ['camping']

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
