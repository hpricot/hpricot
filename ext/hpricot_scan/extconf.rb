require 'mkmf'

$CFLAGS << " #{ENV["CFLAGS"]}"
CONFIG['optflags'] = '' if $CFLAGS =~ /DEBUG/

dir_config("hpricot_scan")
have_library("c", "main")

create_makefile("hpricot_scan")
