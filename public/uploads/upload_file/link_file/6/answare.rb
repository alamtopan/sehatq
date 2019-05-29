require 'nokogiri'
require 'open-uri'

source = 'https://gist.githubusercontent.com/tymat/03c0944ea1a280948c2e8fc9e41ffc10/raw/d396e6ee86f8dc8ab6b2855261938f3343445c43/LoremIpsum.md'
@document = Nokogiri::HTML.parse(open(source))

# ----------- ANSWARE NO 2 -------------
def get_most_text
	text = @document.css('p')[0].text.delete(' ')
														 .split('')
												     .group_by {|w| w}
												     .map {|k,v| [k,v.size]}
												     .sort_by(&:last)
												     .reverse
												     .to_h.first
	puts "2. The most common letters appear are? #{text[0]} => #{text[1]}"

end

# ----------- ANSWARE NO 3 -------------
def get_top_3_most
	text = @document.css('p')[0].text.gsub(/./) do |c|
    case c
    when /\w/ then c.downcase
    when /\s/ then c
    else ''
    end
  end.split
     .group_by {|w| w}
     .map {|k,v| [k,v.size]}
     .sort_by(&:last)
     .reverse
     .to_h.first(3).to_h

  puts "3. Show 3 most commonly occuring word? "
  text.each_with_index do |t, index|
  	puts "   (#{index+1}) #{t[0]} = #{t[1]}   "
  end
end


# ----------- ANSWARE NO 4 -------------
def answare_catch_wolves
  puts '4. Six wolves catch six lambs in six minutes?'
  puts 'if in 6 minutes 6 wolves got 6 lambs it means that each of them caught one lamb so it takes one wolf 6 minutes to catch a lamb 60 minutes has 60/6 = 10 six minute intervals so in 60 minutes one wolf can catch 10 lambs. If you want to catch 60 lambs in that time you will need 60/10 = 6 wolves.'
end


get_most_text
get_top_3_most
answare_catch_wolves



