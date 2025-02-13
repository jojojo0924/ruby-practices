#!/usr/bin/env ruby

require 'io/console/size'

files = Dir.children('.').sort
files = files.delete_if {|file| file[0] == '.'}

max_filename_length = files.map(&:length).max
column_length = (max_filename_length / 8 + 1) * 8

console_width = IO::console_size[1]
columns = console_width / column_length

rows = (files.size.to_f / columns).ceil
rows.times do |i|
  index = i
  while files.size > index
    print files[index].ljust(column_length)
    index += rows
  end
  puts
end
