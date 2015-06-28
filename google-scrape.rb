require 'open-uri'
require 'nokogiri'
require 'metainspector'
require 'csv'

doc = Nokogiri::HTML(open("http://www.google.com/search?num=10&q=%22Aimee+Tsao%22+bay+area+dance+-linkedin"))

found_pages = []
doc.css('cite').each do |cite|  
  found_pages << cite.text
end 
 #print found_pages

 def get_descriptions(urls)
    CSV.open("urls.csv", "wb")do |csv|
    csv << ["page title", "url", "description"]
    end

add_em = []

   urls.each do |url|
   page = MetaInspector.new(url)
   add_em =[page.title,page.url,page.description]
    CSV.open("urls.csv", "a+")do |csv|
    csv << add_em
    end
  end
end

 get_descriptions(found_pages)