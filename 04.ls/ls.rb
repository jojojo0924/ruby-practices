#!/usr/bin/env ruby

require 'io/console/size'

def main
  files = Dir.entries('.').sort
  files.delete_if { |file| file[0] == '.' }
  format(files)
end

def format(files)
  column_length = calculate_column_length(files)
  columns = calculate_columns(column_length)
  rows = (files.size.to_f / columns).ceil
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
  console_width = IO::console_size[1]
  columns = console_width / column_length
  columns > 3 ? 3 : columns # 最大3列
end

main
