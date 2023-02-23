#!/usr/bin/env ruby

# titeto --- isearch a la migemo

# Copyright (C) 2021, 2023  YUSE Yosihiro

# This software is released under the MIT License.
# http://opensource.org/licenses/mit-license.php

# --------------------------------------------------------------------
# code

require_relative 'cli-ttt'

module Titeto
  include TTT

  @op_or = "|"
  @op_nest_in = "("
  @op_nest_out = ")"
  @op_newline = ""

  class << self
    attr_accessor :op_or, :op_nest_in, :op_nest_out, :op_newline
  end

  def regexp_escape(str)
    str.gsub(/[\[\]\\.*^$~\/]/) {'\\' + $&} # XXX: これで必要十分?
  end

  def generate_regexp_str(pattern, with_paren = false)
    dst, state = decode_string(pattern, true)
    state = [] if state == TTT.table
    # XXX: TTT.table の末端の要素は空文字列か長さ 1 の文字列で、
    # ^ や - や [ ] といった文字はないと仮定している
    char_class = state.flatten().join()
    char_class = "[#{char_class}]" unless char_class.empty?
    re = regexp_escape(dst) + char_class            # XXX: escape
    re = regexp_escape(pattern) + Titeto.op_or + re # XXX: escape
    re = Titeto.op_nest_in + re + Titeto.op_nest_out if with_paren
    re
  end

  def get_pattern(pattern)
    segments = pattern.split(/\s+/) # XXX: /\s+/
    return generate_regexp_str(pattern) if segments.length <= 1
    re_str1 = generate_regexp_str(pattern, true)
    re_str2 = segments.map {
      |p| generate_regexp_str(p, true)
    }.join(Titeto.op_newline)
    re_str1 + Titeto.op_or + re_str2
  end
end

# --------------------------------------------------------------------
# main

if __FILE__ == $0
  include Titeto

  require 'getoptlong'

  $titeto_usage = <<EOF
Usage: #{$0} [options]

Options:
  -d --dict <dict>      [IGNORED] Use a file <dict> for dictionary.
  -s --subdict <dict>   [IGNORED] Sub dictionary files. (MAX 8 times)
  -q --quiet            Show no message except results.
  -v --vim              Use vim style regexp.
  -e --emacs            Use emacs style regexp.
  -n --nonewline        Don't use newline match.
  -w --word <word>      Expand a <word> and soon exit.
  -h --help             Show this message.
EOF

  $OPT = Hash.new
  parser = GetoptLong.new
  parser.set_options(['-d', '--dict',      GetoptLong::REQUIRED_ARGUMENT],
                     ['-s', '--subdict',   GetoptLong::REQUIRED_ARGUMENT],
                     ['-q', '--quiet',     GetoptLong::NO_ARGUMENT],
                     ['-v', '--vim',       GetoptLong::NO_ARGUMENT],
                     ['-e', '--emacs',     GetoptLong::NO_ARGUMENT],
                     ['-n', '--nonewline', GetoptLong::NO_ARGUMENT],
                     ['-w', '--word',      GetoptLong::REQUIRED_ARGUMENT],
                     ['-h', '--help',      GetoptLong::NO_ARGUMENT])

  begin
    parser.each_option do |name, arg|
      $OPT[name.sub(/^-/, "")] = arg
    end
  rescue
    exit 1
  end

  if $OPT["h"]
    $stderr.puts $titeto_usage
    exit
  end

  if $OPT["v"]
    Titeto.op_or = "\\|"
    Titeto.op_nest_in = "\\%("
    Titeto.op_nest_out = "\\)"
    Titeto.op_newline = "\\_s*" unless $OPT["n"]
  elsif $OPT["e"]
    Titeto.op_or = "\\|"
    Titeto.op_nest_in = "\\("
    Titeto.op_nest_out = "\\)"
    Titeto.op_newline = "\\s-*" unless $OPT["n"]
  end

  if $OPT["w"]
    print get_pattern($OPT["w"])
    exit
  end

  print "QUERY: " unless $OPT["q"]
  while str = gets do
    print("PATTERN: ") unless $OPT["q"]
    puts get_pattern(str.chomp)
    $stdout.flush
    print "QUERY: " unless $OPT["q"]
  end

  exit
end

# --------------------------------------------------------------------
# end of rtiteto.rb
