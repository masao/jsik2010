#!/usr/bin/env ruby
# $Id$

lines = ARGF.readlines
table = ""
within_tabular = false
while begin_html = lines.find_index{|e| /^%begin:HTML:ignore/ =~ e }
   end_html = lines.find_index{|e| /^%end:HTML:ignore/ =~ e }
   lines[ begin_html .. end_html ] = nil
end
lines[ lines.find_index{|e| /^\\subsection/ =~ e } .. -1 ].each do |line|
   line.sub!(/%.*$/, "")
   line.gsub!(/\\([\w\*]+)(\{.*?\})?(\{.*?\})?(\{.*?\})?/) do |match|
      command = $1
      arg1 = $2
      arg2 = $3
      arg3 = $4
      #p [ command, arg1, within_tabular ]
      if command == "begin" and arg1 =~ /^\{tabular\}/
         within_tabular = true
      elsif command == "end" and arg1 =~ /^\{tabular\}/
         within_tabular = false
      end
#       if within_tabular and command == "multicolumn"
#          #arg3.sub( /\{(.*)\}/ ){ $1 }
#          match
#       elsif within_tabular and /\\(begin|end)\{authors\}/ =~ match
#          match
      if within_tabular
         match
      else
         ""
      end
   end
   if within_tabular
      table << line
   else
      line.sub!(/\\\\$/, "")
      line.gsub!(/\\\\/, "\n")
   end
end

puts "<table class=\"program\">"
rows = table.split(/\\\\/)
rows.delete( "\\hline\n" )
rows.each do |tr|
   if tr =~ /\\htmlth/
      thead = true
   else
      thead = false
   end
   puts "<thead>" if thead
   puts "<tr>"
   tds = tr.split( /([^\\])&/ )
   while tds.size > 0
      td = tds.shift
      td << tds.shift.to_s
      tag = "td"
      attr = {}
      style = []
      tag = "th" if td.sub!( /^\\htmlth\s*/, '' )
      td.gsub!( /\\&/, "&" )
      td.sub!( /\\begin\{tabular\}.*$/, '' )
      td.sub!( /\\begin\{authors\}/, '<div class="authors">' )
      td.sub!(/\\end\{authors\}/, '</div>' )

      td.gsub!( /\\begin\{author2\}/, '<div class="author2">' )
      td.gsub!(/\\end\{author2\}/, '</div>' )
      td.gsub!( /\\begin\{center\}/, '<center>' )
      td.gsub!(/\\end\{center\}/, '</center>' )
      td.gsub!( /\\begin\{itemize\}/, '<ul>' )
      td.gsub!(/\\end\{itemize\}/, '</ul>' )
      td.gsub!( /\\item\s*(.*)$/, '<li><span class="itemhead">\1</span><br>' )

      #p td
      td.sub!( /\\multicolumn\{([0-9]+)\}\{([\|\w\{\}\\]+)\}\{(.*?)\}/m ) do |match|
         attr[:colspan] = $1 if $1.to_i > 1
         style << "center" if $2.include?( "c" )
         $3
      end
      attr[:class] = $1 if td.sub!( /\\htmlclass\{([^\}]*)\}/, "" )
      td.gsub!( /\\(\w+)/ ) do |match|
         case $1
         when "bf", "sf"
            style << "strong"
         when "footnotesize", "small"
            style << "small"
         end
         ""
      end
      td.strip!
      if td.empty?
         attr[:class] = "blank"
      end
      #p td
      if not style.empty?
         style.each do |e|
            td = "<#{e}>#{td}</#{e}>"
         end
      end
      attr_s = ""
      if not attr.empty?
         attr_s = " " << attr.keys.map{|k| %Q[#{k}="#{attr[k]}"] }.join(" ")
      end
      puts "<#{tag}#{attr_s}>#{td}</#{tag}>"
   end
   puts "</tr>"
   puts "</thead>" if thead
end
puts "</table>"
#puts table
