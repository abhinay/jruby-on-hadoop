# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{jruby-on-hadoop}
  s.version = "0.0.7"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Koichi Fujikawa", "Abhinay Mehta"]
  s.date = %q{2010-02-06}
  s.default_executable = %q{joh}
  s.description = %q{JRuby on Hadoop}
  s.email = %q{fujibee@gmail.com}
  s.executables = ["joh"]
  s.extra_rdoc_files = [
    "README.rdoc"
  ]
  s.files = [
    "README.rdoc",
     "Rakefile",
     "VERSION",
     "bin/joh",
     "build.xml",
     "examples/wordcount.rb",
     "jruby-on-hadoop.gemspec",
     "lib/hadoop-ruby.jar",
     "lib/jruby-on-hadoop.rb",
     "lib/jruby-on-hadoop/client.rb",
     "lib/ruby_wrapper.rb"
  ]
  s.homepage = %q{http://github.com/fujibee/jruby-on-hadoop}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{JRuby on Hadoop}
  s.test_files = [
     "examples/wordcount.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<jruby-jars>, [">= 0"])
    else
      s.add_dependency(%q<jruby-jars>, [">= 0"])
    end
  else
    s.add_dependency(%q<jruby-jars>, [">= 0"])
  end
end

