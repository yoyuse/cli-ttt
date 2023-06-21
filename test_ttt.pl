#!/usr/bin/env perl

use strict;
use warnings;
use utf8;
# use Encode qw(decode encode);
use Test::More;

require './cli-ttt';

subtest 'decode_string' => sub {
    my $tests1 = [
        ["kdjd;sjdkd;s", "の、が、のが"],
        ["ABCDyfhdyd", "ABCDあいう"],
        ["ysksjsks/ajgjdjfkdt8p3;gpzjshdjtighdiakslghdhgiajd", "わたしたちは、氷砂糖をほしいくらいもたないでも、"],
       ];
    for my $a (@$tests1) {
        is($a->[1], TTT::decode_string($a->[0]));
    }
};

subtest 'decode_substring' => sub {
    my $tests2 = [
        ["abcd yfhdyd", "abcd あいう"],
        ["abcd:yfhdyd", "abcdあいう"],
        ["ysksjsks/ajgjdjfkdt8p3;gpzjshdjtighdiakslghdhgiajd", "わたしたちは、氷砂糖をほしいくらいもたないでも、"],
        ["あの Iha-Tovo kd,fhrjaoajrks風、", "あの Iha-Tovo のすきとおった風、"],
        ["(またAladdin  lyfjlk[ラムプ]とり)", "(またAladdin  洋燈[ラムプ]とり)"],
       ];
    for my $a (@$tests2) {
        is($a->[1], TTT::decode_substring($a->[0]));
    }
};

subtest 'decode_at_marker' => sub {
    my $tests3 = [
        ["%", "kdjd;sjdkd;s%s", "の、が、のが"],
        ["%", "ABCDyfhdyd%s", "ABCDあいう"],
        ["%", "abcd yfhdyd%s", "abcd あいう"],
        ["%", "abcd:yfhdyd%s", "abcdあいう"],
        ["%", "ysksjsks/ajgjdjfkdt8p3;gpzjshdjtighdiakslghdhgiajd%s", "わたしたちは、氷砂糖をほしいくらいもたないでも、"],
        ["\x1bj", "yfkd%s Iha-Tovo kd,fhrjaoajrks風、%s", "あの Iha-Tovo のすきとおった風、"],
        ["\x1bj", "うつくしい森で飾られた Morio:/vjd%s", "うつくしい森で飾られた Morio市、"],
        ["\x1bj", "(またAladdin  lyfjlk[usubmw]jajc)%s%s%s", "(またAladdin  洋燈[ラムプ]とり)"],
        ["\x1bj", ";d%s;f%sha", "岳ha"],
       ];
    for my $a (@$tests3) {
        my ($marker, $src, $dst) = @$a;
        $src =~ s/%s/$marker/g;
        is($dst, TTT::decode_at_marker($src, $marker));
    }
};

done_testing;
