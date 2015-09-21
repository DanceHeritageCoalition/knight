#add text to homepage
#add header image
#add button labels
#add buttons to home
#make results hyperlinks
#redirect from search to getdesc
#
#add results page for each query via redirect
#clear sample URLs in posts



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
$add_em = []
$links = []
$matches = []

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
   $keywords << params[:words].values.join("+").to_s + 'bay' + 'area'
  #  $exclude << params[:words][0].values[1]
    #@keywords_incl1 = params[:words].values.join("+").to_s

    "https://www.google.com/search?num=10&q=" + "#{$keywords[0]}"
    redirect "/search"
    end

   get '/search' do
      @doc = Nokogiri::HTML(open("https://www.google.com/search?num=10&q=" + "#{$keywords[0]}"))
   #   "here is #{@doc}"

     @doc.css('cite').each do |cite|
      $found_pages << cite.text
     end

     @exclude = ['yelp', 'linkedin', 'facebook']
    $found_pages.delete_if {|pg| pg.include?('yelp' || 'linkedin' || 'facebook')
    #"Here are found pages #{$found_pages}"
    redirect '/scrape_results'
  end #for /search

  get '/scrape_results' do
    erb :scrape_results
  end

  get '/getdesc' do
    erb :getdesc
    #redirect "/desc_results"

  end

  post '/descript' do
   #  $urls << params[:links].values
   # "here are #{$urls[0]}"
   #  @urls = $urls.to_s
    
        def get_descriptions(urls)
            
            # CSV.open("urls-3.csv", "wb")do |csv|
            # csv << ["page title", "url", "description"]
            # end
          @test = []

           urls.each do |url|
            page = MetaInspector.new(url, :connection_timeout => 1, :read_timeout => 2, :retries => 0, warn_level: :store)
            @test =[page.title,page.url,page.description]

           $add_em << @test
            # if page.url.include?('facebook')
            #   puts "garbage"
            # else
              $urls << page.url
             # end
           end
            #"Here are descriptions #{@test}"
            #"Here are page urls #{$urls}"
          end
       # end
      get_descriptions($found_pages)
      redirect "/desc_results"
  end #end post /getdesc

  get '/desc_results' do
    erb :desc_results
  end

#get links

 get '/getlinks' do
    erb :getlinks
end

post '/links' do
    @url = params[:links].values[0]
    def get_links(pages)
    #Go to specified URL, scrape links/descriptions for new URLs
   #just use mechanize
      #exclude facebook pages

      # pages.each do |pg| 
      #  begin
       mech = Mechanize.new 
       page = mech.get(@url)
        # # rescue Mechanize::ResponseCodeError => exception
        # #   if exception.response_code == '404'
        # rescue Mechanize::ResponseCodeError => e
        # #page = e.force_parse
        # puts e.to_s
        # #    #mechanize exits on errors
        # else 
          # page.links.each do |link|
          # $text_page << [link, link.text]
          # end #end page links
        #@links = page.links
        #end #end rescue
        page.links.each {|link| $links << "#{link.text}, #{link.href}"}
        #end #end pages each
        # end
    end #end get_links
    #end
     get_links(@url)  #using links from getdesc
    
      redirect :link_results
  end #end post /links

  #redirect '/link_results'
# end

  get '/link_results' do
    erb :link_results
  end

get '/gettext' do
    erb :gettext
end

$text = []
post '/text' do
  #get text

  def get_text(text_page)
#   #go to each link from get_links, scrape text;
#   #open csv, each row, new csv, add columns
  @doc = Nokogiri::HTML(open(text_page))
  $text = @doc.css('p').text
  $img = @doc.css('img')
  @keywords = ["pow wow", "Royal", "ballet","hula"  ,"hip hop" ,"two step"  ,"waltz" ,"polka" ,"bharatanatyam" ,"bharata natyam"  ,
"ballerina" , "jazz", "breakdancing"  ,"salsa" ,"meringue"  ,"flamenco"  ,"contradanse" ,"contradanc*" ,"western squares" ,"ballroom"  ,"capoeira"  ,
"danc*","go-go" ,"pirouette" ,"arabesque" ,"kathak"  ,"b-boying"  ,"gangnum" ,"tap" ,"electric slide"  ,"moonwalk"  ,"tango" ,"mambo" ,"twist" ,
"charleston"  ,"quickstep" ,"jive"  ,"bollywood" ,"disco "  ,"rave"  ,"jookin"  ,"locking" ,"popping" ,"pop and lock"  ,
"electric boogaloo" ,"stepping","jig" ,"clogging"  ,"shim sham" ,"foxtrot" ,"butoh" ,"tarantella"  ,"swing" ,"bhangra" ,"kathakali" ,
"kuchipudhi"  ,"Mohiniyattam"  ,"Odissi"  ,"Sattriya"  ,"garba"]

    if @keywords.any? { |w| $text =~ /#{w}/ }
      
      @keywords.each do |kywd| $text.match(kywd) != nil ? $matches << kywd : "nothing"
        end
    else
      puts "nope."
    end

   # "Keywords found: {#@matches}"

  end #get_text method end
  get_text('http://dancetabs.com/2012/04/chitresh-das-dance-company-darbar-san-francisco/')

  redirect '/text_results'
end #post '/text end'

get '/text_results' do
  erb :text_results
end


get '/show_text' do
  erb :show_text
end

#return screenshots
get '/screenshots' do
  def screenshots()

    f = Screencap::Fetcher.new('http://dancetabs.com/2015/06/the-royal-ballet-the-dream-song-of-the-earth-new-york/')
  screenshots()
  erb :screenshot
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

