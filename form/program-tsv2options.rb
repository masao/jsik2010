#!/usr/bin/env ruby
# -*- coding: euc-jp -*-
# $Id$

require "kconv"

$KCODE = "euc"

def shorten( str, len = 120 )
   matched = str.gsub( /\n/, ' ' ).scan( /^.{0,#{len - 2}}/ )[0]
   if $'.nil? || $'.empty?
      matched
   else
      matched + '...'
   end
end

ARGF.each do |line|
   session_id, idx, title, author, = line.toeuc.chomp.split(/\t/)
   program_id = [ session_id, idx ].join( "-" )
   title = title.gsub(/^\"(.*)\"$/, '\1').gsub( /\"\"/, '"' ).strip
   author = author.gsub(/^\"(.*)\"$/, '\1').strip
   #p [ pid, title, author ]
   authors = author.split(/, /)
   authors_str  =authors[0].split[0]
   # authors_str << "ほか" if authors.size > 1
   puts %Q[<option value="#{ program_id.gsub(/-/,"") }">[#{ program_id }] #{ authors_str }: #{ shorten(title,20) }</option>]
end
