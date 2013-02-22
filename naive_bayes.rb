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

def total_probability(unknown_sample, group)
  probabilities = Sample.members.map do |attr|
    attr_mean = mean(group, attr)
    attr_variance = sample_variance(group, attr)

    prob = probability(attr_mean, attr_variance, unknown_sample[attr])
    # puts "prob #{attr}: #{prob}"
    prob
  end
  
  probabilities << 0.5

  probabilities_product = probabilities.inject(1){|accum, i| accum * i }
end

class Sample < Struct.new(:height, :weight, :foot_size); end

males = []
males << Sample.new(6, 180, 12) << Sample.new(5.92, 190, 11) << Sample.new(5.58, 170, 12) << Sample.new(5.92, 165, 10)

females = []
females << Sample.new(5, 100, 6) << Sample.new(5.5, 150, 8) << Sample.new(5.42, 130, 7) << Sample.new(5.75, 150, 9)

unknown = Sample.new(6, 130, 8)

male_probabilities_product = total_probability(unknown, males)
female_probabilities_product = total_probability(unknown, females)

puts "male_probabilities_product: #{male_probabilities_product}"  
puts "female_probabilities_product: #{female_probabilities_product}"  

puts male_probabilities_product > female_probabilities_product ? "This person is likely male" : "This person is likely female" 
