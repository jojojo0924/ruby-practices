#!/usr/bin/env ruby
# frozen_string_literal: true

def calculate_extra_strike_points(frames, index)
  next_frame_first = frames[index + 1][0]
  if next_frame_first == 10 # 次のフレームもストライクだった時
    next_frame_first + frames[index + 2][0]
  else
    next_frame_first + frames[index + 1][1]
  end
end

score = ARGV[0]
scores = score.split(',')
shots = []
scores.each do |s|
  if s == 'X'
    shots << 10
    shots << 0
  else
    shots << s.to_i
  end
end

frames = shots.each_slice(2).to_a

partial_frames = frames[...9]
total = partial_frames.each_with_index.sum(frames[9..].flatten.sum) do |frame, index|
  frame_sum = frame.sum
  if frame[0] == 10 # ストライク
    frame_sum + calculate_extra_strike_points(frames, index)
  elsif frame_sum == 10 # スペア
    frame_sum + frames[index + 1][0]
  else
    frame_sum
  end
end
puts total
