package org.apache.hadoop.ruby.mapred;

import java.io.IOException;
import java.lang.InterruptedException;
import java.util.Iterator;

import javax.script.ScriptException;

import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.ruby.JRubyEvaluator;

public class JRubyReducer extends Reducer<Text, IntWritable, Text, IntWritable> {

	private JRubyEvaluator evaluator;

	public void setup(Context context) throws IOException, InterruptedException {
	  evaluator = new JRubyEvaluator(context.getConfiguration());
  }

	public void reduce(Text key, Iterable<IntWritable> values, Context context)
			throws IOException {
		// invoke "reduce" method in ruby
		try {
			evaluator.invoke("wrap_reduce", key, values, context);
		} catch (ScriptException e) {
			context.setStatus(e.getMessage());
		} finally {
			evaluator.checkResource();
		}
	}
}
