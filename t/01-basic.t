use v6;
use BreakDancer;
use Test;
use Shell::Command;

plan 24;

my %modules =
    foo => [1, 'asd'],
    bar => [2, 'fasada']
;

my @sites = <a b c>;

# argumentless form?
gen '/', sub {
    return "lalala";
}

gen '/module', %modules, sub ($mod, $args) {
    return "$mod: " ~ $args[1] x $args[0];
}

gen '/site', @sites, sub ($s) {
    return $s;
}

my $basedir = 'www'; # or maybe 'gen'?

ok "$basedir/index.html".IO.f;
is slurp("$basedir/index.html").chomp, 'lalala';

for %modules.kv -> $k, $v {
    ok "$basedir/module/$k/index.html".IO.f;
    is slurp("$basedir/module/$k/index.html").chomp,
       ("$k: " ~ $v[1] x $v[0]);
}

for @sites -> $s {
    ok "$basedir/site/$s/index.html".IO.f;
    is slurp("$basedir/site/$s/index.html").chomp,
       $s;
}

rm_rf $basedir; # cleanup

# the same for another basedir
$BreakDancer::basedir = 'notwww';

# argumentless form?
gen '/', sub {
    return "lalala";
}

gen '/module', %modules, sub ($mod, $args) {
    return "$mod: " ~ $args[1] x $args[0];
}

gen '/site', @sites, sub ($s) {
    return $s;
}

$basedir = 'notwww'; # or maybe 'gen'?

ok "$basedir/index.html".IO.f;
is slurp("$basedir/index.html").chomp, 'lalala';

for %modules.kv -> $k, $v {
    ok "$basedir/module/$k/index.html".IO.f;
    is slurp("$basedir/module/$k/index.html").chomp,
       ("$k: " ~ $v[1] x $v[0]);
}

for @sites -> $s {
    ok "$basedir/site/$s/index.html".IO.f;
    is slurp("$basedir/site/$s/index.html").chomp,
       $s;
}

rm_rf $basedir; # cleanup

done;
