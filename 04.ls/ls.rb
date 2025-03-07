#!/usr/bin/env ruby
# frozen_string_literal: true

require 'io/console/size'
require 'etc'
require 'time'
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
  files.delete_if { |file| file[0] == '.' }
  options = ARGV.getopts('l')
  options['l'] ? long_format(files) : short_format(files)
end

def long_format(files)
  file_stats = create_file_stats(files)
  total_blocks = files.map { |file| File.stat(file).blocks }.sum
  puts "total #{total_blocks}"
  file_stats = adjust_length(file_stats)
  file_stats.each do |file_stat|
    print "#{file_stat[0]}  #{file_stat[1]} #{file_stat[2]}  #{file_stat[3]}  #{file_stat[4]}  #{file_stat[5]} #{file_stat[6]}"
    puts
  end
end

def create_file_stats(files)
  file_stats = []
  files.each do |file|
    ftype = FTYPES[File.lstat(file).ftype]
    stat = File.lstat(file)
    permissions = stat.mode.to_s(8).rjust(6, '0')[3..]
    owner = PERMISSION[permissions[0]]
    group = PERMISSION[permissions[1]]
    other = PERMISSION[permissions[2]]
    file_stats << [
      ftype + owner + group + other,
      stat.nlink.to_s,
      Etc.getpwuid(stat.uid).name,
      Etc.getgrgid(stat.gid).name,
      stat.size.to_s,
      stat.mtime.strftime('%-m %e %H:%M'),
      file
    ]
  end
  file_stats
end

def adjust_length(file_stats)
  # 最初と最後以外を右端に揃える
  temp_stats = file_stats.transpose[1...-1].map do |file_stat|
    max_length = file_stat.map(&:size).max
    file_stat.map do |item|
      item.rjust(max_length)
    end
  end
  temp_stats.unshift(file_stats.transpose[0])
  temp_stats << file_stats.transpose[-1]
  temp_stats.transpose
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
