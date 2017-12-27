require 'nokogiri'

puts "\nI'll try to load in the XML file at \"#{ARGV[0]}\""
doc = File.open(ARGV[0]) { |f| Nokogiri::XML(f) }

OUTPUT_FILE = 'index.html'.freeze
puts "\nI'll render to \"#{OUTPUT_FILE}\""
output = File.open(OUTPUT_FILE, "w")

require 'date'
date_now = DateTime.now.strftime("%Y-%m-%d %H:%M")
output.write('<html><head>' +
             "<title>WordPress XML Render #{date_now}</title>" +
             '<link rel="stylesheet" type="text/css" href="xml_render.css">' +
             '</head><body>')

all_items = doc.xpath('//item')
puts "There are #{all_items.size} blog entries here"

BLOG_POST_FOOTER = "</div>\n".freeze
TITLE_HEADER = '<span class="title">'.freeze
TITLE_FOOTER = '</span>'.freeze
DATE_HEADER = '<span class="date">'.freeze
DATE_FOOTER = '</span>'.freeze
CONTENT_HEADER = '<div class="content">'.freeze
CONTENT_FOOTER = '</div>'.freeze

all_items.each do |item|
  # looks like: <title>Les Miserables</title>
  title = item.xpath('.//title').children.to_s

  # looks like: <pubDate>Thu, 15 Jun 2017 23:41:40 +0000</pubDate>
  pub_date = item.xpath('.//pubDate').children.to_s

  # looks like: <content:encoded><![CDATA[Some text is here]]></content:encoded>
  content = item.xpath('.//content:encoded').children.text

  # may not be present
  # looks like: <category domain="category" nicename="foo"><![CDATA[foo]]></category>
  category = item.xpath('.//category')
  category_nicename = category.empty? ? '' : category.first.attributes['nicename'].to_s

  output.write("<div class='#{category_nicename}'>")
  output.write("#{TITLE_HEADER}#{title}#{TITLE_FOOTER}")
  output.write("#{DATE_HEADER}#{pub_date}#{DATE_FOOTER}")
  output.write("#{CONTENT_HEADER}#{content}#{CONTENT_FOOTER}")

  output.write(BLOG_POST_FOOTER)
end

output.write('</body></html>')
output.close
puts "I did it!\n"
