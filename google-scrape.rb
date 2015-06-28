require 'open-uri'
require 'nokogiri'
require 'metainspector'
require 'csv'

#interface should allow user to feed a list of URLs
#find new sites

doc = Nokogiri::HTML(open("http://www.google.com/search?num=100&q=%22Aimee+Tsao%22+bay+area+dance+-linkedin"))

found_pages = []

doc.css('cite').each do |cite|  
  found_pages << cite.text
end 

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

 #get_descriptions(found_pages)

 #existing sites
 #Go to specified URL, crawl new URLs

def get_links(this_page)
  #output links to csv
  #example uses Nokogiri css selectors to find linkes on this specific page; this will only work with the example link

  doc = Nokogiri::HTML(open(this_page))
  links = doc.css('h2 a').map { |link| link['href'] }
  
  CSV.open("links.csv", "w")do |csv|
    links.each do |link|
      csv << [link]
    end
  end

end

get_links("http://dancetabs.com/category/reviews-of-dance-and-ballet-performances/")
