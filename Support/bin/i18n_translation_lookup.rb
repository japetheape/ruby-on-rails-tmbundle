#!/usr/bin/env ruby

# Copyright:
#   (c) 2006 syncPEOPLE, LLC.
#   Visit us at http://syncpeople.com/
# Author: Jaap van der Meer (jaapvandermeer@gmail.com)
# Description:
#   Creates a partial from the selected text (asks for the partial name)
#   and replaces the text with a "render :partial => [partial_name]" erb fragment.

require 'rails_bundle_tools'
require 'yaml'

current_file = RailsPath.new
selection = TextMate.selected_text || current_file.buffer.current_line

root = RailsPath.new.rails_root
LOCALES_DIR = File.join([root, "config", "locales"])

locales = Dir["#{LOCALES_DIR}/*.{rb,yml}"].collect do |locale_file|
 	File.basename(File.basename(locale_file, ".rb"), ".yml")
end.uniq

locale = locales[TextMate.choose("some", locales)]

locale_file = nil
['yml', 'rb'].each do |type|
	temp_locale_file =  "#{LOCALES_DIR}/#{locale}.#{type}"
	locale_file = temp_locale_file if File.exists?(temp_locale_file)
end


translations = nil
File.open( locale_file ) { |yf| translations = YAML::load( yf ) }


if res = /I18n\.t\(\:(\w*).*\:scope \=\> \[(.*)\]\)/.match(selection)	
	suffix = res[2].split(/,/).map {|x| 
		res2 = /\:(\w*)/.match(x)
		"[\"#{res2[1]}\"]"
	}.join + "[\"#{res[1]}\"]"
	
	translation = nil
	eval("translation = translations[\"#{locale}\"]" + suffix)
	puts "Translation: " + translation

end

	



#if File.exist?(locale_file)
#	TextMate.open locale_file
#else 

#end
