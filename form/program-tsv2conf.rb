#!/usr/bin/env ruby
# -*- coding: euc-jp -*-
# $Id$

require "erb"
require "fileutils"
require "kconv"

$KCODE = "euc"

# フォームを展開するフォルダ:
BASEDIR = "."

erb = open("mformcgi.conf.erb"){|io| io.read }

ARGF.each do |line|
   session_id, idx, title, author_short, authors = line.toeuc.chomp.split(/\t/)
   program_id = [ session_id, idx ].join( "-" )
   title = title.gsub(/^\"(.*)\"$/, '\1').gsub( /\"\"/, '"' ).strip
   author_short = author_short.gsub(/^\"(.*)\"$/, '\1').strip
   authors = authors.gsub(/^\"(.*)\"$/, '\1').strip
   p [ program_id, title, authors ]
   dirname = File.join( BASEDIR, program_id.gsub(/-/, "") )
   FileUtils.rm_rf( dirname + ".bak" )
   FileUtils.mv( dirname, dirname + ".bak", :force => true )
   STDERR.puts dirname
   FileUtils.cp_r( "skel", dirname, :preserve => true )
   open( File.join( dirname, "mformcgi.conf" ), "w" ) do |io|
      io.puts ERB.new( erb ).result( binding )
   end
   open( "mformcgi.conf", "w" ) do |io|
      io.puts ERB.new( erb ).result( binding ).gsub( /\.\.\/data\//, "./data/" )
   end
end
