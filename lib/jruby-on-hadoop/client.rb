module JRubyOnHadoop
  JAVA_MAIN_CLASS = 'org.apache.hadoop.ruby.JRubyJobRunner' 

  class Client
    attr_reader :script, :files

    def initialize(args=[])
      @args = args
      parse_args

      # env get / set and check
      hadoop_home and hadoop_cmd and hadoop_classpath
    end

    def hadoop_home
      ENV['HADOOP_HOME']
    end

    def hadoop_cmd
      hadoop = `which hadoop 2>/dev/null`
      hadoop = "#{hadoop_home}/bin/hadoop" if hadoop.empty? and (!hadoop_home.empty?)
      raise 'cannot find hadoop command' if hadoop.empty?
      hadoop.chomp
    end

    def hadoop_classpath
      ENV['HADOOP_CLASSPATH'] =
        ([lib_path, File.dirname(@script_path)] + jruby_jars).join(':')
    end

    def run
      exec cmd
    end

    def cmd
      "#{hadoop_cmd} jar #{main_jar_path} #{JAVA_MAIN_CLASS}" +
      " -libjars #{opt_libjars} -files #{opt_files} #{mapred_args}"
    end

    def parse_args
      raise "Usage: joh script_path input_path output_path" if @args.size < 3
      @script_path = @args[0]
      @script = File.basename(@script_path) 
      @files = [@script_path, JRubyOnHadoop.wrapper_ruby_file]
    end

    def mapred_args
      args = "--script #{@script} "
      (1..@args.size-1).each {|index| args += "#{@args[index]} "}
      args
    end

    def jruby_jars
      [JRubyJars.core_jar_path, JRubyJars.stdlib_jar_path]
    end

    def opt_libjars; jruby_jars.join(',') end
    def opt_files; @files.join(',') end
    def main_jar_path; JRubyOnHadoop.jar_path end
    def lib_path; JRubyOnHadoop.lib_path end
  end
end
