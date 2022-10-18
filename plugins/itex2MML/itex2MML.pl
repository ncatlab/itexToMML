# itex2MML
# version 2.0
# copyright 2003-2019, Jacques Distler
#

package MT::Plugin::itex2MML;

use MT;
use MathML::itex2MML qw( itex_html_filter );

use vars qw( $VERSION );
$VERSION = '2.0';

eval{ require MT::Plugin;};
unless ($@) {
   my $plugin = {
      name => "itex2MML",
      version => $VERSION,
      description => "A Text-Filter, translating embedded itex equations into MathML",
      doc_link => 'http://golem.ph.utexas.edu/~distler/blog/itex2MML.html',
   };
   MT->add_plugin(new MT::Plugin($plugin));
}

MT->add_text_filter(itexToMML => {
	label => 'itex to MathML',
	on_format => sub { &itexToMML; },
});
MT->add_text_filter(itexToMMLpara => {
        label => 'itex to MathML with parbreaks',
        on_format => sub { &itexToMMLpara; },
});

my $itex2mml_number_equations = 1;

sub itexToMML {
    $_=shift;
    $ctx = shift;
    $_=~ s/\r//g;
    $_ = number_equations($_, $itex2mml_number_equations, $ctx);
    itex_html_filter($_);
}

sub itexToMMLpara {
    $_ = shift;
    $ctx = shift;
    $_=~ s/\r//g;
    $_ = number_equations($_, $itex2mml_number_equations, $ctx);
    $_ = splitparas($_);
    itex_html_filter($_);
}

sub splitparas {
    my $str = shift;
    $str ||= '';
    my @paras = split /\n{2,}/, $str;
    for my $p (@paras) {
        if ($p !~ m@^</?(?:h1|h2|h3|h4|h5|h6|table|ol|dl|ul|menu|dir|p|pre|center|form|fieldset|select|blockquote|address|div|hr)@) {
#        if ($p !~ m@^\s*</?(?:h1|h2|h3|h4|h5|h6|table|ol|dl|ul|menu|dir|p|pre|center|form|fieldset|select|blockquote|address|div|hr)@) {
            $p = "<p>$p</p>";
        }
    }
    join "\n\n", @paras;
}

sub number_equations {
  $_ = shift;
  my $arg_value = shift;
  my $ctx = shift;

  if ($arg_value == 0) {return $_;}
  
  my $prefix = "eq";
  if ((defined $ctx)  && (ref($ctx) eq 'MT::Template::Context')) {
    if ($ctx->stash('comment') ) {
       $prefix = "c" . $ctx->stash('comment')->id;
    } elsif ($ctx->stash('entry') ) {
       $prefix = "e" . $ctx->stash('entry')->id;
    }
  }
  my $cls = "numberedEq";

  my %eqnumber;
  my $eqno=1;

  # add equation numbers to \[...\]
  #  - introduce a wrapper-<div> and a <span> with the equation number
#  while (s/(^\s*)?\\\[(.*?)\\\]/\n\n$1<div class=\"$cls\"><span>\($eqno\)<\/span>\$\$$2\$\$<\/div>\n\n/s) {
  while (s/\\\[(.*?)\\\]/\n\n<div class=\"$cls\"><span>\($eqno\)<\/span>\$\$$1\$\$<\/div>\n\n/s) {
    $eqno++;
  }

  # assemble equation labels into a hash
  # - remove the \label{} command, collapse surrounding whitespace
  # - add an ID to the wrapper-<div>. prefix it to give a fighting chance
  #   for the ID to be unique
  # - hash key is the equation label, value is the equation number
  while (s/<div class=\"$cls\"><span>\((\d+)\)<\/span>\$\$((?:[^\$]|\\\$)*)\s*\\label{(\w*)}\s*((?:[^\$]|\\\$)*)\$\$<\/div>/<div class=\"$cls\" id=\"$prefix:$3\"><span>\($1\)<\/span>\$\$$2$4\$\$<\/div>/s) {
    $eqnumber{"$3"} = $1;
  }

  # add cross-references
  # - they can be either (eq:foo) or \eqref{foo}
  s/\(eq:(\w+)\)/\(<a href=\"#$prefix:$1\">$eqnumber{"$1"}<\/a>\)/g;
  s/\\eqref\{(\w+)\}/\(<a href=\'#$prefix:$1\'>$eqnumber{"$1"}<\/a>\)/g;
  
  return $_;
}

1;
