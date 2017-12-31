require 'nokogiri'
require 'date'

puts "\nI'll try to load in the XML file at \"#{ARGV[0]}\""
doc = File.open(ARGV[0]) { |f| Nokogiri::XML(f) }
all_items = doc.xpath('//item')
puts "There are #{all_items.size} blog entries here"

# Extract only the relevant fields from the XML
# make a new sortable array
printable_blogs = []

all_items.each do |item|
  # looks like: <title>Les Miserables</title>
  title = item.xpath('.//title').children.to_s

  # looks like: <pubDate>Thu, 15 Jun 2017 23:41:40 +0000</pubDate>
  pub_date = item.xpath('.//pubDate').children.to_s
  unix_date = DateTime.parse(pub_date,'%a, %d %b %Y %H:%M:%S %z')

  # looks like: <content:encoded><![CDATA[Some text is here]]></content:encoded>
  content = item.xpath('.//content:encoded').children.text.gsub("\n","<br />\n")

  # may not be present
  # looks like: <category domain="category" nicename="foo"><![CDATA[foo]]></category>
  category = item.xpath('.//category')
  category_nicename = category.empty? ? '' : category.first.attributes['nicename'].to_s

  printable_blogs << { title: title,
                       pub_date: pub_date,
                       unix_date: unix_date,
                       content: content,
                       category: category_nicename }
end

BLOG_POST_FOOTER = "</div>\n".freeze
TITLE_HEADER = '<h1 class="title">'.freeze
TITLE_FOOTER = '</h1>'.freeze
DATE_HEADER = '<i class="date">'.freeze
DATE_FOOTER = '</i><br />'.freeze
CONTENT_HEADER = '<div class="content">'.freeze
CONTENT_FOOTER = '</div>'.freeze

OUTPUT_FILE = 'index.html'.freeze
output = File.open(OUTPUT_FILE, "w")
puts "\nI'll render to \"#{OUTPUT_FILE}\""

date_now = DateTime.now.strftime("%Y-%m-%d %H:%M")
output.write('<html><head>' +
             "<title>WordPress XML Render #{date_now}</title>" +
             '<link rel="stylesheet" type="text/css" href="xml_render.css">' +
             '</head><body>')

# iterate through the array and output
printable_blogs.sort { |x,y| x[:unix_date] <=> y[:unix_date] }.each do |item|
  output.write("<div class='#{item[:category]}'>")
  output.write("#{TITLE_HEADER}#{item[:title]}#{TITLE_FOOTER}")
  output.write("#{DATE_HEADER}#{item[:pub_date]}#{DATE_FOOTER}")
  output.write("#{CONTENT_HEADER}#{item[:content]}#{CONTENT_FOOTER}")

  output.write(BLOG_POST_FOOTER)
end

output.write('</body></html>')
output.close
puts "I did it!\n"
