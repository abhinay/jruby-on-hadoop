package org.apache.hadoop.ruby;

import javax.script.ScriptException;

import org.apache.commons.cli.CommandLine;
import org.apache.commons.cli.CommandLineParser;
import org.apache.commons.cli.GnuParser;
import org.apache.commons.cli.Option;
import org.apache.commons.cli.Options;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.conf.Configured;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.io.LongWritable;

import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;

import org.apache.hadoop.ruby.mapred.JRubyMapper;
import org.apache.hadoop.ruby.mapred.JRubyReducer;
import org.apache.hadoop.util.Tool;
import org.apache.hadoop.util.ToolRunner;

public class JRubyJobRunner extends Configured implements Tool {

	public int run(String[] args) throws Exception {
		CommandLineParser parser = new GnuParser();
		Options options = new Options();
		options.addOption(new Option("script", true, "ruby script"));
		options.addOption(new Option("dslfile", true, "hadoop ruby DSL script"));

		CommandLine commandLine = parser.parse(options, args);
		Configuration conf = getConf();
		
		if (commandLine.hasOption("script")) {
			conf.set("mapred.ruby.script", commandLine.getOptionValue("script",
					"mapred.rb"));
		}
		if (commandLine.hasOption("dslfile")) {
			conf.set("mapred.ruby.dslfile", commandLine
					.getOptionValue("dslfile"));
		}
		String[] otherArgs = commandLine.getArgs();
		conf.setStrings("mapred.args", otherArgs);
		
    Job job = new Job(conf);
    job.setJobName("ruby.runner");
	  job.setOutputKeyClass(Text.class);
		job.setOutputValueClass(IntWritable.class);

		job.setMapperClass(JRubyMapper.class);
		job.setReducerClass(JRubyReducer.class);

		if (otherArgs.length >= 2) {
			FileInputFormat.setInputPaths(job, otherArgs[0]);
			FileOutputFormat.setOutputPath(job, new Path(otherArgs[1]));
		}
		
		JRubyEvaluator evaluator = new JRubyEvaluator(job.getConfiguration());
		try {
			Object[] paths = (Object[]) evaluator.invoke("wrap_setup", job);
			if (paths != null && paths.length == 2) {
  			FileInputFormat.setInputPaths(job, (String) paths[0]);
  			FileOutputFormat.setOutputPath(job, new Path((String) paths[1]));
  		}
		} catch (ScriptException e) {
			// do nothing. maybe user script has no "setup" method
		}
		
		job.waitForCompletion(true);
		return 0;
	}

	public static void main(String[] args) throws Exception {
		int res = ToolRunner.run(new Configuration(), new JRubyJobRunner(),
				args);
		System.exit(res);
	}
}
