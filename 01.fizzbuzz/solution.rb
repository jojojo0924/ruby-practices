(1..20).each do |n|
  output = ""
  output += "Fizz" if n % 3 == 0
  output += "Buzz" if n % 5 == 0
  puts output.empty? ? n : output
end
