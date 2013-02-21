class Person < Struct.new(:height, :weight, :foot_size); end

class Male < Person; end

class Female < Person; end

males = []
males << Male.new(6, 180, 12) << Male.new(5.92, 190, 11) << Male.new(5.58, 170, 12) << Male.new(5.92, 165, 10)

females = []
females << Female.new(5, 100, 6) << Female.new(5.5, 150, 8) << Female.new(5.42, 130, 7) << Female.new(5.75, 150, 9)

module Enumerable
  def sum
    self.inject(0){|accum, i| accum + i }
  end

  def mean
    self.sum/self.length.to_f
  end

  def sample_variance
    m = self.mean
    sum = self.inject(0){|accum, i| accum +(i-m)**2 }
    sum/(self.length - 1).to_f
  end

  def standard_deviation
    return Math.sqrt(self.sample_variance)
  end
end 

def mean(group, attr)
  group.map(&attr).mean
end

def sample_variance(group, attr)
  group.map(&attr).sample_variance
end

def probability(mean, variance, value)
  (1 / Math.sqrt(2 * Math::PI * variance)) * Math.exp((-1 * (value - mean) ** 2)/ (2 * variance)) 
end


male_probabilities = [[:height, 6], [:weight, 130], [:foot_size, 8]].map do |key, value|
  male_attr_mean = mean(males, key)
  male_attr_variance = sample_variance(males, key)

  #puts "male #{key} mean: #{male_attr_mean}"
  #puts "male #{key} variance: #{male_attr_variance}"
  prob = probability(male_attr_mean, male_attr_variance, value)
  puts "prob #{key}: #{prob}"
  prob
end

male_probabilities << 0.5

male_probabilities_product = male_probabilities.inject(1){|accum, i| accum * i }

puts "male_probabilities_product: #{male_probabilities_product}"  
