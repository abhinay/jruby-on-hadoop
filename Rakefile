begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "jruby-on-hadoop"
    gemspec.summary = "JRuby on Hadoop"
    gemspec.description = "JRuby on Hadoop"
    gemspec.email = "fujibee@gmail.com"
    gemspec.homepage = "http://github.com/fujibee/jruby-on-hadoop"
    gemspec.authors = ["Koichi Fujikawa", "Abhinay Mehta"]

    gemspec.add_dependency 'jruby-jars'
    gemspec.files.exclude "src/**/*"
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: gem install jeweler"
end
