#!/usr/bin/env ruby

require 'test/unit'

require './cli-ttt'
include TTT

# - test class should inherit Test::Unit::TestCase
# - test methods are named as test_xxx
# - tests are done in alphabetical order
# - assert_equal EXPECTED, ACTUAL
class TestTTT < Test::Unit::TestCase
  # do tests in defined order (rather than in alphabetical order)
  # (test_order member unavailable in Ruby 2.0.0 ???)
  # self.test_order = :defined

  # (data method unavailable in Ruby 2.0.0 ???)
  # data(
  #   'test1' => ["kd;s", "のが"],
  #   'test2' => ["lgkg", "lgkg"])
  @@tests1 = [
    ["kdjd;sjdkd;s", "の、が、のが"],
    ["ABCDyfhdyd", "ABCDあいう"],
    ["ysksjsks/ajgjfkdt8p3;gpzjshdjtighd", "わたしたちは氷砂糖をほしいくらい"],
  ]
  def test_decode_string()
    @@tests1.each do |src, dst|
      assert_equal dst, decode_string(src)
    end
  end

  @@tests2 = [
    ["abcd yfhdyd", "abcd あいう"],
    ["abcd:yfhdyd", "abcdあいう"],
    ["ysksjsks/ajgjfkdt8p3;gpzjshdjtighd", "わたしたちは氷砂糖をほしいくらい"],
    ["あの Iha-Tovo kd,fhrjaoajrks風", "あの Iha-Tovo のすきとおった風"],
    ["(またAladdin　lyfjlk[ラムプ]とり)", "(またAladdin　洋燈[ラムプ]とり)"],
  ]
  def test_decode_substring
    @@tests2.each do |src, dst|
      assert_equal dst, decode_substring(src)
    end
  end

  @@tests3 = [
    ["%", "kdjd;sjdkd;s%s", "の、が、のが"],
    ["%", "ABCDyfhdyd%s", "ABCDあいう"],
    ["%", "abcd yfhdyd%s", "abcd あいう"],
    ["%", "abcd:yfhdyd%s", "abcdあいう"],
    ["%", "ysksjsks/ajgjfkdt8p3;gpzjshdjtighd%s", "わたしたちは氷砂糖をほしいくらい"],
    ["\x1bj", "yfkd%s Iha-Tovo kd,fhrjaoajrks風%s", "あの Iha-Tovo のすきとおった風"],
    ["\x1bj", "うつくしい森で飾られた Morio:/v%s", "うつくしい森で飾られた Morio市"],
    ["\x1bj", "(またAladdin　lyfjlk[usubmw]jajc)%s%s%s", "(またAladdin　洋燈[ラムプ]とり)"],
    ["\x1bj", ";d%s;f%sha", "岳ha"],
  ]
  def test_decode_at_marker
    @@tests3.each do |marker, src, dst|
      src.gsub!(/%s/, marker)
      assert_equal dst, decode_at_marker(src, marker)
    end
  end
end
