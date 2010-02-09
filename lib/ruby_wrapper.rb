require 'java'

import 'org.apache.hadoop.io.IntWritable'
import 'org.apache.hadoop.io.LongWritable'
import 'org.apache.hadoop.io.Text'

def wrap_setup(conf, script, dslfile)
  require script
  paths = dslfile ? setup(conf, dslfile) : setup(conf)
  paths.to_java if paths
end

def wrap_map(key, value, context, script, dslfile)
  require script
  context_wrapper = ContextWrapper.new(context)
  dslfile ? 
    map(to_ruby(key), to_ruby(value), context_wrapper, dslfile) :
    map(to_ruby(key), to_ruby(value), context_wrapper)
end

def wrap_reduce(key, values, context, script, dslfile)
  require script
  context_wrapper = ContextWrapper.new(context)
  dslfile ?
    reduce(to_ruby(key), to_ruby(values), context_wrapper, dslfile) :
    reduce(to_ruby(key), to_ruby(values), context_wrapper)
end

class ContextWrapper
  def initialize(context)
    @context = context
  end

  def collect(key, value)
    @context.write(to_java(key), to_java(value))
  end
  
  def get_conf
    @context.getConfiguration
  end
end

def to_ruby(value)
  case value
  when IntWritable, FloatWritable, LongWritable then value.get
  when Text then value.to_string
  else 
    # for Java array
    if value.respond_to? :map
      value.map {|v| to_ruby(v)}
    else value # as is
    end
  end
end

def to_java(value)
  case value
  when Integer then IntWritable.new(value)
  when Float then FloatWritable.new(value)
  when String then t = Text.new; t.set(value); t
  when Array then value.to_java
  else raise "no match class: #{value.class}"
  end
end
