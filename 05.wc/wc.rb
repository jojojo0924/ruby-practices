#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

OPTIONS = 'lwc'

def main
  options = ARGV.getopts(OPTIONS)
  if ARGV.empty?
    file_stat = get_file_stat($stdin.read)
    display(file_stat, options)
  elsif ARGV.size == 1
    file = ARGV.first
    file_stat = get_file_stat(File.open(file).read)
    display(file_stat, options, file)
  else
    display_all(options)
  end
end

def display_all(options)
  total_file_stat = {
    lines: 0,
    words: 0,
    bytes: 0
  }
  ARGV.each do |file|
    content = File.open(file).read
    file_stat = get_file_stat(content)
    display(file_stat, options, file)
    total_file_stat[:lines] += file_stat[:lines]
    total_file_stat[:words] += file_stat[:words]
    total_file_stat[:bytes] += file_stat[:bytes]
  end
  display(total_file_stat, options, 'total')
end

def display(file_stat, options, target = '')
  lines = file_stat[:lines]
  lines_to_display = lines.to_s.rjust(calc_width(lines))
  words = file_stat[:words]
  words_to_display = words.to_s.rjust(calc_width(words))
  bytes = file_stat[:bytes]
  bytes_to_display = bytes.to_s.rjust(calc_width(bytes))
  options.transform_values!(&:!) if options.values.all?(false)
  print lines_to_display if options['l']
  print words_to_display if options['w']
  print bytes_to_display if options['c']
  puts " #{target}"
end

def get_file_stat(content)
  {
    lines: content.lines.count,
    words: content.split(/[ \t\n]+/).size,
    bytes: content.bytesize
  }
end

def calc_width(number)
  number.to_s.size < 8 ? 8 : number.to_s.size + 1
end

main
