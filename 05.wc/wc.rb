#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

OPTIONS = 'lwc'

def main
  options = ARGV.getopts(OPTIONS)
  if ARGV.empty?
    display($stdin.read, options)
  elsif ARGV.size == 1
    file = ARGV.first
    display(File.open(file).read, options, " #{file}")
  else
    display_all(options)
  end
end

def display_all(options)
  all_content = ''
  ARGV.each do |file|
    content = File.open(file).read
    all_content += content
    display(content, options, " #{file}")
  end
  display(all_content, options, ' total')
end

def display(content, options, target = '')
  lines = content.lines.count
  lines_to_display = lines.to_s.rjust(calc_width(lines))
  words = content.split(/[ \t\n]+/).size
  words_to_display = words.to_s.rjust(calc_width(words))
  bytes = content.bytesize
  bytes_to_display = bytes.to_s.rjust(calc_width(bytes))
  if options.values.all?(false)
    print lines_to_display
    print words_to_display
    print bytes_to_display
  else
    print options['l'] ? lines_to_display : ''
    print options['w'] ? words_to_display : ''
    print options['c'] ? bytes_to_display : ''
  end
  puts target
end

def calc_width(number)
  number.to_s.size < 8 ? 8 : number.to_s.size + 1
end

main
