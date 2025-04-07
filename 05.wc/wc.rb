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
    file_stat.each do |k, v|
      total_file_stat[k] += v
    end
  end
  display(total_file_stat, options, 'total')
end

def display(file_stat, options, target = '')
  stat_to_display = {}
  file_stat.each do |k, v|
    stat_to_display[k] = v.to_s.rjust(calc_width(v))
  end
  options.transform_values!(&:!) if options.values.all?(false)
  print stat_to_display[:lines] if options['l']
  print stat_to_display[:words] if options['w']
  print stat_to_display[:bytes] if options['c']
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
  [8, number.to_s.size + 1].max
end

main
