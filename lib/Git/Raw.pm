package Git::Raw;

use strict;
use warnings;

require XSLoader;
XSLoader::load('Git::Raw', $Git::Raw::VERSION);

use Git::Raw::Error;
use Git::Raw::Error::Category;
use Git::Raw::Blob;
use Git::Raw::Commit;
use Git::Raw::Reference;
use Git::Raw::Repository;
use Git::Raw::Tree;

=for HTML
<a href="https://travis-ci.org/jacquesg/p5-Git-Raw">
	<img src="https://travis-ci.org/jacquesg/p5-Git-Raw.svg?branch=master" alt="Build Status: Travis" align="right" />
</a>
<a href="https://ci.appveyor.com/project/jacquesg/p5-git-raw">
	<img src="https://ci.appveyor.com/api/projects/status/il9rm9fsf9dj1dcu/branch/master?svg=true" alt="Build Status: AppVeyor" align="right" />
</a>
<a href="https://coveralls.io/r/jacquesg/p5-Git-Raw">
	<img src="https://coveralls.io/repos/jacquesg/p5-Git-Raw/badge.png?branch=master" alt="Coverage Status" align="right" />
</a>
=cut

=head1 NAME

Git::Raw - Perl bindings to the Git linkable library (libgit2)

=head1 DESCRIPTION

L<libgit2|http://libgit2.github.com> is a pure C implementation of the Git core
methods provided as a re-entrant linkable library designed to be fast and
portable with a solid API.  This module provides Perl bindings to the libgit2
API.

B<WARNING>: The API of this module is unstable and may change without warning
(any change will be appropriately documented in the changelog).

=head1 METHODS

=head2 features( )

List of (optional) compiled in features. Git::Raw may be built with support
for threads, HTTPS and SSH.

=head2 message_prettify( $msg, [$strip_comments, $comment_char] )

Clean up C<$msg> from excess whitespace and ensure that the last line ends with
a newline. The default is to strip all comments, starting with a C<#>, unless
otherwise specified.

=head1 AUTHOR

Alessandro Ghedini <alexbio@cpan.org>

Jacques Germishuys <jacquesg@striata.com>

=head1 LICENSE AND COPYRIGHT

Copyright 2012 Alessandro Ghedini.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut

1; # End of Git::Raw
