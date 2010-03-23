#!/usr/bin/env ruby
# $Id$

require "erb"
require "fileutils"

$KCODE = "euc"

erb = open("form/mformcgi.conf.erb"){|io| io.read }
ARGF.each do |line|
   pid, title, author = line.chomp.split(/\t/)
   title.strip!
   author = author.gsub(/^\"(.*)\"$/, '\1').strip
   p [ pid, title, author ]
   dirname = File.join( "form/submit", pid.gsub(/-/, "") )
   FileUtils.rm_rf( dirname + ".bak" )
   FileUtils.mv( dirname, dirname + ".bak", :force => true )
   STDERR.puts dirname
   FileUtils.cp_r( "skel", dirname, :preserve => true )
   open( File.join( dirname, "mformcgi.conf" ), "w" ) do |io|
      io.puts ERB.new( erb ).result( binding )
   end
   open( "form/submit/mformcgi.conf", "w" ) do |io|
      io.puts ERB.new( erb ).result( binding ).gsub( /\.\.\/data\//, "./data/" )
   end
end
