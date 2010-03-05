#!/usr/bin/env ruby
# $Id$

# Usage:
#  ./mailer.rb jsik2010-app.txt < mail-accept.txt

require "erb"
require "kconv"

NKF_command = '/usr/local/bin/nkf'
SENDMAIL_command = '/usr/sbin/sendmail'
FROM_address = 'TAKAKU.Masao@nims.go.jp'

message = STDIN.read
#puts message

ARGF.each do |line|
   data = line.chomp.split(/\t/)
   next if data.empty?
   if not data[15].include?( "@" )
      puts "skip no email: #{ data[15] }"
      next
   end
   data = data.map{|e| p e;e.to_s.sub( /\A"(.*)"\Z/, '\1' ) }
   result = ERB::new( message ).result( binding )
   puts data[15]
   open("|#{NKF_command} -j -m0 | #{SENDMAIL_command} -oi -t -f #{FROM_address}", "w") do |io|
      io.puts result
   end
end
