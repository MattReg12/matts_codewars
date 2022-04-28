=begin

Write an algorithm that will identify valid IPv4 addresses in dot-decimal format. IPs should be considered valid if they consist of four octets, with values between 0 and 255, inclusive.

Valid inputs examples:
Examples of valid inputs:
1.2.3.4
123.45.67.89
Invalid input examples:
1.2.3
1.2.3.4.5
123.456.78.90
123.045.067.089

input: string

output: boolean

explicit: return true if the string has 4 numbers delimited by commas that are between 0 and 255

implicit: Leading zeros are not acceptable

data struc:
string
convert to array

algo:
conver the string into an array by delimiting the string by commas
check to see if they are four elements in the array
check to see if all are valid integers i.e. they are dont have a leading 0
check to see if they are all between 0 and 255

=end

def is_valid_ip(str)
  octets = str.split('.')
  case
  when octets.size != 4 then false
  when octets.any? { |octet| octet.to_i.to_s != octet } then false
  when octets.any? { |octet| !octet.to_i.between?(0,255) } then false
  else true
  end
end


p is_valid_ip('1.1.1.1')
p is_valid_ip('123,45,67,89')
p is_valid_ip(' 1.2.3.4')
p is_valid_ip('1.2.3.4')
p is_valid_ip('1.2.3.4 ')
p is_valid_ip('023.45.67.89')
p is_valid_ip('01.2.3.4')
p is_valid_ip('11.254.13.24')
p is_valid_ip('11.256.103.04 ')
p is_valid_ip('-1.2.3.4')
p is_valid_ip('1.2.3.4.5')
