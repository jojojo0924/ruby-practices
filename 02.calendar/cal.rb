require 'date'
require 'optparse'

# 月と年を設定
params = ARGV.getopts("y:m:")
year = params["y"] ? params["y"].to_i : Date.today.year
month = params["m"] ? params["m"].to_i : Date.today.month
