require 'bundler/setup'
ENV.delete('RUBYOPT')           # Don't propagate RUBYOPT/Bundler to subprocesses
require 'rake/clean'
require 'rubygems/package_task'
require 'rdoc/task'
require 'rake/testtask'
begin
  require 'rake/extensiontask'
rescue LoadError
  abort "To build, please first gem install rake-compiler"
end

RbConfig = Config unless defined?(RbConfig)

NAME = "hpricot"
REV = (`#{ENV['GIT'] || "git"} rev-list HEAD`.split.length + 1).to_s
VERS = ENV['VERSION'] || "0.8" + (REV ? ".#{REV}" : "")
PKG = "#{NAME}-#{VERS}"
BIN = "*.{bundle,jar,so,o,obj,pdb,lib,def,exp,class,rbc}"
CLEAN.include ["#{BIN}", "ext/**/#{BIN}", "lib/**/#{BIN}", "test/**/#{BIN}",
               'ext/fast_xs/Makefile', 'ext/hpricot_scan/Makefile',
               '**/.*.sw?', '*.gem', '.config', 'pkg', 'lib/hpricot_scan.rb', 'lib/fast_xs.rb']
RDOC_OPTS = ['--quiet', '--title', 'The Hpricot Reference', '--main', 'README.md', '--inline-source']
PKG_FILES = %w(CHANGELOG COPYING README.md Rakefile) +
      Dir.glob("{bin,doc,test,extras}/**/*") +
      (Dir.glob("lib/**/*.rb") - %w(lib/hpricot_scan.rb lib/fast_xs.rb)) +
      Dir.glob("ext/**/*.{h,java,c,rb,rl}") +
      %w[ext/hpricot_scan/hpricot_scan.c ext/hpricot_scan/hpricot_css.c ext/hpricot_scan/HpricotScanService.java] # needed because they are generated later
RAGEL_C_CODE_GENERATION_STYLES = {
  "table_driven" => 'T0',
  "faster_table_driven" => 'T1',
  "flat_table_driven" => 'F0',
  "faster_flat_table_driven" => 'F1',
  "goto_driven" => 'G0',
  "faster_goto_driven" => 'G1',
  "really_fast goto_driven" => 'G2'
  # "n_way_split_really_fast_goto_driven" => 'P<N>'
}
DEFAULT_RAGEL_C_CODE_GENERATION = "really_fast goto_driven"
SPEC =
  Gem::Specification.new do |s|
    s.name = NAME
    s.version = VERS
    s.platform = Gem::Platform::RUBY
    s.has_rdoc = true
    s.rdoc_options += RDOC_OPTS
    s.extra_rdoc_files = ["README.md", "CHANGELOG", "COPYING"]
    s.summary = "a swift, liberal HTML parser with a fantastic library"
    s.description = s.summary
    s.author = "why the lucky stiff"
    s.email = 'why@ruby-lang.org'
    s.homepage = 'http://code.whytheluckystiff.net/hpricot/'
    s.rubyforge_project = 'hobix'
    s.files = PKG_FILES
    s.require_paths = ["lib"]
    s.extensions = FileList["ext/**/extconf.rb"].to_a
    s.bindir = "bin"
  end
# Dup the spec before any of its calculated ivars are set (e.g., #cache_file)
Win32Spec = SPEC.dup
JRubySpec = SPEC.dup

# FAT cross-compile
# Pass RUBY_CC_VERSION=1.8.7:1.9.2 when packaging for 1.8+1.9 mswin32 binaries
%w(hpricot_scan fast_xs).each do |target|
  Rake::ExtensionTask.new(target, SPEC) do |ext|
    ext.lib_dir = File.join('lib', target) if ENV['RUBY_CC_VERSION']
    ext.cross_compile = true                # enable cross compilation (requires cross compile toolchain)
    ext.cross_platform = 'i386-mswin32'     # forces the Windows platform instead of the default one
  end

  # HACK around 1.9.2 cross .def file creation
  def_file = "tmp/i386-mswin32/#{target}/1.9.2/#{target}-i386-mingw32.def"
  directory File.dirname(def_file)
  file def_file => File.dirname(def_file) do |t|
    File.open(t.name, "w") do |f|
      f << "EXPORTS\nInit_#{target}\n"
    end
  end

  task File.join(File.dirname(def_file), "Makefile") => def_file
  # END HACK
  file "lib/#{target}.rb" do |t|
    File.open(t.name, "w") do |f|
      f.puts %{require "#{target}/\#{RUBY_VERSION.sub(/\\.\\d+$/, '')}/#{target}"}
    end
  end
end
file 'ext/hpricot_scan/extconf.rb' => :ragel

desc "set environment variables to build and/or test with debug options"
task :debug do
  ENV['CFLAGS'] ||= ""
  ENV['CFLAGS'] += " -g -DDEBUG"
end

desc "Does a full compile, test run"
if defined?(JRUBY_VERSION)
task :default => [:compile_java, :clean_fat_rb, :test]
else
task :default => [:compile, :clean_fat_rb, :test]
end

task :clean_fat_rb do
  rm_f "lib/hpricot_scan.rb"
  rm_f "lib/fast_xs.rb"
end

desc "Packages up Hpricot for all platforms."
task :package => [:clean]

desc "Run all the tests"
Rake::TestTask.new do |t|
    t.libs << "test"
    t.test_files = FileList['test/test_*.rb']
    t.verbose = true
end

Rake::RDocTask.new do |rdoc|
    rdoc.rdoc_dir = 'doc/rdoc'
    rdoc.options += RDOC_OPTS
    rdoc.main = "README.md"
    rdoc.rdoc_files.add ['README.md', 'CHANGELOG', 'COPYING', 'lib/**/*.rb']
end

Gem::PackageTask.new(SPEC) do |p|
    p.need_tar = true
    p.gem_spec = SPEC
end

### Win32 Packages ###
Win32Spec.platform = 'i386-mswin32'
Win32Spec.files = PKG_FILES + %w(hpricot_scan fast_xs).map do |t|
  unless ENV['RUBY_CC_VERSION']
    file "lib/#{t}/1.8/#{t}.so" do
      abort "ERROR while packaging: re-run for fat win32 gems:\nrake #{ARGV.join(' ')} RUBY_CC_VERSION=1.8.7:1.9.2"
    end
  end
  ["lib/#{t}.rb", "lib/#{t}/1.8/#{t}.so", "lib/#{t}/1.9/#{t}.so"]
end.flatten
Win32Spec.extensions = []

Gem::PackageTask.new(Win32Spec) do |p|
  p.need_tar = false
  p.gem_spec = Win32Spec
end

JRubySpec.platform = 'java'
JRubySpec.files = PKG_FILES + ["lib/hpricot_scan.jar", "lib/fast_xs.jar"]
JRubySpec.extensions = []

Gem::PackageTask.new(JRubySpec) do |p|
  p.need_tar = false
  p.gem_spec = JRubySpec
end

desc "Determines the Ragel version and displays it on the console along with the location of the Ragel binary."
task :ragel_version do
  @ragel_v = `ragel -v`[/(version )(\S*)/,2].to_f
  puts "Using ragel version: #{@ragel_v}, location: #{`which ragel`}"
  @ragel_v
end

desc "Generates the C scanner code with Ragel."
task :ragel => [:ragel_version] do
  if @ragel_v >= 6.1
    @ragel_c_code_generation_style = RAGEL_C_CODE_GENERATION_STYLES[DEFAULT_RAGEL_C_CODE_GENERATION]
    Dir.chdir("ext/hpricot_scan") do
      sh %{ragel hpricot_scan.rl -#{@ragel_c_code_generation_style} -o hpricot_scan.c}
      sh %{ragel hpricot_css.rl -#{@ragel_c_code_generation_style} -o hpricot_css.c}
    end
  else
    STDERR.puts "Ragel 6.1 or greater is required."
    exit(1)
  end
end

# Java only supports the table-driven code
# generation style at this point.
desc "Generates the Java scanner code using the Ragel table-driven code generation style."
task :ragel_java => [:ragel_version] do
  if @ragel_v >= 6.1
    puts "compiling with ragel version #{@ragel_v}"
    Dir.chdir("ext/hpricot_scan") do
      sh %{ragel -J -o HpricotCss.java hpricot_css.java.rl}
      sh %{ragel -J -o HpricotScanService.java hpricot_scan.java.rl}
    end
  else
    STDERR.puts "Ragel 6.1 or greater is required."
    exit(1)
  end
end

### JRuby Compile ###

def java_classpath_arg # myriad of ways to discover JRuby classpath
  begin
    cpath  = Java::java.lang.System.getProperty('java.class.path').split(File::PATH_SEPARATOR)
    cpath += Java::java.lang.System.getProperty('sun.boot.class.path').split(File::PATH_SEPARATOR)
    jruby_cpath = cpath.compact.join(File::PATH_SEPARATOR)
  rescue => e
  end
  unless jruby_cpath
    jruby_cpath = ENV['JRUBY_PARENT_CLASSPATH'] || ENV['JRUBY_HOME'] &&
      FileList["#{ENV['JRUBY_HOME']}/lib/*.jar"].join(File::PATH_SEPARATOR)
  end
  unless jruby_cpath || ENV['CLASSPATH'] =~ /jruby/
    abort %{WARNING: No JRuby classpath has been set up.
Define JRUBY_HOME=/path/to/jruby on the command line or in the environment}
  end
  "-cp \"#{jruby_cpath}\""
end

def compile_java(filenames, jarname)
  sh %{javac -source 1.5 -target 1.5 #{java_classpath_arg} #{filenames.join(" ")}}
  sh %{jar cf #{jarname} *.class}
end

task :hpricot_scan_java => [:ragel_java] do
  Dir.chdir "ext/hpricot_scan" do
    compile_java(["HpricotScanService.java", "HpricotCss.java"], "hpricot_scan.jar")
  end
end

task :fast_xs_java do
  Dir.chdir "ext/fast_xs" do
    compile_java(["FastXsService.java"], "fast_xs.jar")
  end
end

%w(hpricot_scan fast_xs).each do |ext|
  file "lib/#{ext}.jar" => "#{ext}_java" do |t|
    mv "ext/#{ext}/#{ext}.jar", "lib"
  end
  task :compile_java => "lib/#{ext}.jar"
end

