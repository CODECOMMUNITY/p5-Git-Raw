#!perl

use Test::More;

use Git::Raw;
use File::Slurp;
use Cwd qw(abs_path);

my $path = abs_path('t/test_repo');
my $repo = Git::Raw::Repository -> open($path);

my $file  = $repo -> workdir . 'test';
write_file($file, 'this is a test');

my $index = $repo -> index;
$index -> add('test');
$index -> write;

my $tree_id = $index -> write_tree;
my $tree    = $repo -> lookup($tree_id);

isa_ok($tree, "Git::Raw::Tree");

my $config = $repo -> config;
my $name   = $config -> get_str('user.name');
my $email  = $config -> get_str('user.email');

my $time = time();
my $off  = 120;
my $me   = Git::Raw::Signature -> new($name, $email, $time, $off);

my $commit = $repo -> commit('initial commit', $me, $me, [], $tree);

my $author = $commit -> author;

is($commit -> message, "initial commit\n");

is($commit -> author -> name, $name);
is($commit -> author -> email, $email);
is($commit -> author -> time, $time);
is($commit -> author -> offset, $off);

is($commit -> committer -> name, $name);
is($commit -> committer -> email, $email);
is($commit -> committer -> time, $time);
is($commit -> committer -> offset, $off);

is($commit -> time, $time);
is($commit -> offset, $off);

my $commit2 = $repo -> lookup($commit -> id);

isa_ok($commit2, "Git::Raw::Commit");

is($commit2 -> message, "initial commit\n");

is($commit2 -> author -> name, $name);
is($commit2 -> author -> email, $email);
is($commit2 -> author -> time, $time);
is($commit2 -> author -> offset, $off);

is($commit2 -> committer -> name, $name);
is($commit2 -> committer -> email, $email);
is($commit2 -> committer -> time, $time);
is($commit2 -> committer -> offset, $off);

is($commit2 -> time, $time);
is($commit2 -> offset, $off);

done_testing;
