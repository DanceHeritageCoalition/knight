require 'sinatra'
require 'open-uri'
require 'csv'
require 'bundler'

$keywords = []
$exclude = []
$urls = []
$found_pages = []
$css_element = []
$text_page = []

class App < Sinatra::Base
 
#download or display file?

get "/" do
  erb :home
end

  get "/scrape" do
    #variable = words
    erb :gs
  end

  post '/' do
   $keywords << params[:words].values.join("+").to_s
  #  $exclude << params[:words][0].values[1]
    @keywords_incl1 = params[:words].values.join("+").to_s

    "https://www.google.com/search?num=10&q=" + "#{$keywords[0]}"
    end

   get '/search' do
      @doc = Nokogiri::HTML(open("https://www.google.com/search?num=10&q=" + "#{$keywords[0]}"))
   #   "here is #{@doc}"

     @doc.css('cite').each do |cite|
      $found_pages << cite.text
     end
    # "Here are the keywords #{$keywords[0]}"
    "Here are found pages #{$found_pages}"
  end #for /search

  get '/getdesc' do
    erb :getdesc

  end

  post '/descript' do
   #  $urls << params[:links].values
   # "here are #{$urls[0]}"
   #  @urls = $urls.to_s
    
        def get_descriptions(urls)
            
            CSV.open("urls-3.csv", "wb")do |csv|
            csv << ["page title", "url", "description"]
            end
          @test = []
           urls.each do |url|
            page = MetaInspector.new(url, :connection_timeout => 1, :read_timeout => 2, :retries => 0, warn_level: :store)
            $add_em =[page.title,page.url,page.description]
           #  CSV.open("urls-3.csv", "a+")do |csv|
            @test << $add_em
              
             end
            "Here are descriptions #{@test}"
          end
       # end
      

      get_descriptions($found_pages)
  end #end post /getdesc

#get links

 get '/getlinks' do
    erb :getlinks
end

post '/links' do
    def get_links(pages)
    #Go to specified URL, scrape links/descriptions for new URLs
   #just use mechanize
   # FIX: links from found pages aren't complete and mechanize won't like them; use attribute from get_desc
      pages.each {|eek| 
       agent = Mechanize.new 

       begin
       page = agent.get(eek)
         rescue Mechanize::ResponseCodeError => exception
          if exception.response_code == '403' || exception.response_code == '404'
            puts exception.to_s
          end
       page.links.each do |link|
        $text_page << link.text
        end
      end
    }

  "Found links: #{$text_page}"
    end
     get_links($urls)  #using links from getdesc
     #mechanize exits on errors
  end #end post /links

get '/gettext' do
    erb :gettext
end

post '/text' do
  #get text

  def get_text(text_page)
#   #go to each link from get_links, scrape text;
#   #open csv, each row, new csv, add columns
  @doc = Nokogiri::HTML(open(text_page))
  @text = @doc.css('p').text
  @keywords = ["pow wow", "Royal", "ballet","hula"  ,"hip hop" ,"two step"  ,"waltz" ,"polka" ,"bharatanatyam" ,"bharata natyam"  ,
"ballerina" , "jazz", "breakdancing"  ,"salsa" ,"meringue"  ,"flamenco"  ,"contradanse" ,"contradanc*" ,"western squares" ,"ballroom"  ,"capoeira"  ,
"danc*","go-go" ,"pirouette" ,"arabesque" ,"kathak"  ,"b-boying"  ,"gangnum" ,"tap" ,"electric slide"  ,"moonwalk"  ,"tango" ,"mambo" ,"twist" ,
"charleston"  ,"quickstep" ,"jive"  ,"bollywood" ,"disco "  ,"rave"  ,"jookin"  ,"locking" ,"popping" ,"pop and lock"  ,
"electric boogaloo" ,"stepping","jig" ,"clogging"  ,"shim sham" ,"foxtrot" ,"butoh" ,"tarantella"  ,"swing" ,"bhangra" ,"kathakali" ,
"kuchipudhi"  ,"Mohiniyattam"  ,"Odissi"  ,"Sattriya"  ,"garba"]

    if @keywords.any? { |w| @text =~ /#{w}/ }
      @matches = []
      @keywords.each do |kywd| @text.match(kywd) != nil ? @matches << kywd : "nothing"
        end
    else
      puts "nope."
    end

    "Keywords found: {#@matches}"

  end #get_text method end
  get_text('http://dancetabs.com/2012/04/chitresh-das-dance-company-darbar-san-francisco/')


end #post '/text end'

#return screenshots
get '/screenshots'
  def screenshots(urls)

    $urls.each do |url|
    f = Screencap::Fetcher.new('#{url}')
    screenshot = f.fetch
  end

end
#   #crawler
#   def crawler()
#   #get links, scrape description, check for keywords, go to site, return new URL, stop
# #get_text("http://dancetabs.com/2015/06/the-royal-ballet-the-dream-song-of-the-earth-new-york/")
# base_dir = "/category/review/page/"
# base_url = "http://www.criticaldance.org"
# #page = Nokogiri::HTML(open(base_url + base_dir + '1'))
# #last_page_number = 66
# all_links = []

# for i in 2...6
#   doc = Nokogiri::HTML(open(base_url + base_dir + (i+=1).to_s))
#   links = doc.css('h1 a').map { |link| link['href'] }
#   all_links << links
# end

# all_links.flatten!

#   CSV.open("crawled-links.csv", "w")do |csv|
#     all_links.each do |link|
#       csv << [link]
#     end
#   end

#archive pages
  get '/archive' do
    erb :archive
  end
end

