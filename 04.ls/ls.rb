#!/usr/bin/env ruby
# frozen_string_literal: true

require 'io/console/size'
require 'optparse'

MAX_COLUMNS = 3

def main
  files = Dir.entries('.').sort
  files.delete_if { |file| file[0] == '.' }
  options = ARGV.getopts('r')
  files = options['r'] ? files.reverse : files
  short_format(files)
end

def short_format(files)
  column_length = calculate_column_length(files)
  columns = calculate_columns(column_length)
  rows = files.size.ceildiv(columns)
  rows.times do |i|
    index = i
    while files.size > index
      print files[index].ljust(column_length)
      index += rows
    end
    puts
  end
end

def calculate_column_length(files)
  max_filename_length = files.map(&:length).max
  (max_filename_length / 8 + 1) * 8
end

def calculate_columns(column_length)
  console_width = IO.console_size[1]
  columns = console_width / column_length
  columns > MAX_COLUMNS ? MAX_COLUMNS : columns # 最大3列
end

main
