def setup(conf)
  #configure org.apache.hadoop.conf.Configuration object
end

def map(key, value, context)
  value.split.each do |word|
    context.collect(word, 1)
  end
end

def reduce(key, values, context)
  sum = 0
  values.each {|v| sum += v }
  context.collect(key, sum)
end
