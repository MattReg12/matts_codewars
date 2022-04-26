=begin


An n-parasitic number (in base 10) is a positive natural number which can be multiplied
by n by moving the rightmost digit of its decimal representation to the front. Here n is
itself a single-digit positive natural number. In other words, the decimal representation
undergoes a right circular shift by one place. For example, 4 • 128205 = 512820, so 128205
is 4-parasitic


input

output


implicit

explicit


data struc

algo




=end

def brute(num)
  num.step(1000000, 16) do |sec_num|
    #binding.pry
    return sec_num if (num * sec_num).to_s == (num.to_s + sec_num.to_s[0..-2])
  end
end

p brute(4)