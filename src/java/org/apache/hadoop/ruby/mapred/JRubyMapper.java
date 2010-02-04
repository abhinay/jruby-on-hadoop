package org.apache.hadoop.ruby.mapred;

import java.io.IOException;
import java.lang.InterruptedException;

import javax.script.ScriptException;

import org.apache.hadoop.io.Text;
import org.apache.hadoop.io.IntWritable;

import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.ruby.JRubyEvaluator;

public class JRubyMapper extends Mapper<Object, Text, Text, IntWritable> {
	
	private JRubyEvaluator evaluator;

	public JRubyMapper() {
		evaluator = new JRubyEvaluator();
	}

	public JRubyEvaluator getJRubyEvaluator() {
		return this.evaluator;
	}
	
	public void map(Object key, Text value, Context context) throws IOException {
		// invoke "map" method in ruby
		JRubyEvaluator evaluator = getJRubyEvaluator();
		try {
			evaluator.invoke("wrap_map", key, value, context);
		} catch (ScriptException e) {
			context.setStatus(e.getMessage());
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			evaluator.checkResource();
		}
	}
}
