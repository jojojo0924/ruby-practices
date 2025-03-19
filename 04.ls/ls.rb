#!/usr/bin/env ruby
# frozen_string_literal: true

require 'io/console/size'
require 'etc'
require 'optparse'

MAX_COLUMNS = 3

FTYPES = {
  'fifo' => 'p',
  'characterSpecial' => 'c',
  'directory' => 'd',
  'blockSpecial' => 'b',
  'file' => '-',
  'link' => 'l',
  'socket' => 's'
}.freeze

PERMISSION = {
  '0' => '---',
  '1' => '--x',
  '2' => '-w-',
  '3' => '-wx',
  '4' => 'r--',
  '5' => 'r-x',
  '6' => 'rw-',
  '7' => 'rwx'
}.freeze

def main
  files = Dir.entries('.').sort
  options = ARGV.getopts('r')
  files = options['r'] ? files.reverse : files
  options = ARGV.getopts('a')
  files = options['a'] ? files : files.delete_if { |file| file[0] == '.' }
  options = ARGV.getopts('l')
  options['l'] ? long_format(files) : short_format(files)
end

def long_format(files)
  total_blocks = files.map { |file| File.stat(file).blocks }.sum
  puts "total #{total_blocks}"
  file_stats = create_file_stats(files)
  file_stats = adjust_length(file_stats)
  file_stats.each { |file_data| puts file_data.join }
end

def create_file_stats(files)
  files.map do |file|
    ftype = FTYPES[File.lstat(file).ftype]
    stat = File.lstat(file)
    permissions = stat.mode.to_s(8).rjust(6, '0')[3..]
    owner = PERMISSION[permissions[0]]
    group = PERMISSION[permissions[1]]
    other = PERMISSION[permissions[2]]
    [
      "#{ftype + owner + group + other}  ",
      "#{stat.nlink} ",
      "#{Etc.getpwuid(stat.uid).name}  ",
      "#{Etc.getgrgid(stat.gid).name}  ",
      "#{stat.size}  ",
      "#{stat.mtime.strftime('%-m %e %H:%M')} ",
      file
    ]
  end
end

def adjust_length(file_stats)
  # 最初と最後以外を右端に揃える
  columns = file_stats.transpose
  adjusted_columns = columns[...-1].map do |column|
    max_length = column.map(&:size).max
    column.map do |data|
      data.rjust(max_length)
    end
  end
  adjusted_columns << columns[-1]
  adjusted_columns.transpose
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
