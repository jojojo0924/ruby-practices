#!/usr/bin/env ruby

def calculate_strike_point(frames, index)
  if frames[index + 1][0] == 10 # 次のフレームもストライクだった時
    10 + frames[index + 1][0] + frames[index + 2][0]
  else
    10 + frames[index + 1][0] + frames[index + 1][1]
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

frames = []
shots.each_slice(2) do |s|
  frames << s
end

partial_frames = frames[...9]
point = frames[9..].flatten.sum # 10フレーム目の合計値を計算
partial_frames.each_with_index do |frame, index|
  if frame[0] == 10 # ストライク
    point += calculate_strike_point(frames, index)
  elsif frame.sum == 10 # スペア
    point += 10 + frames[index + 1][0]
  else
    point += frame.sum
  end
end
puts point
