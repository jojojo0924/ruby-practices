#!/usr/bin/env ruby
require 'date'
require 'optparse'

# 月と年を設定
params = ARGV.getopts("y:m:")
year = params["y"] ? params["y"].to_i : Date.today.year
month = params["m"] ? params["m"].to_i : Date.today.month

# カレンダー表示
puts "      #{month}月 #{year}"
puts "日 月 火 水 木 金 土"
print "   " * Date.new(year, month, 1).wday
start_date = Date.new(year, month, 1)
last_date = Date.new(year, month, -1)
(start_date..last_date).each do |date|
  print date.mday.to_s.rjust(2) + " "
  puts "\n" if date.saturday?
end
