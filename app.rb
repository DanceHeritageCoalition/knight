require 'sinatra'
require 'open-uri'
require 'csv'

require 'bundler'

$keywords = []
$exclude = []
$urls = []
$add_em = []
$found_pages = []

class App < Sinatra::Base
 


# create forms and views
#get scraper: should go to form view.  INput from user populates Nokogiri google URL
#create variable for result set
#download or display file?

  get "/googlescrape" do
    #variable = words
    erb :gs
  end

  post '/' do
   $keywords << params[:words].values.join("+").to_s
  #  $exclude << params[:words][0].values[1]
    @keywords_incl1 = params[:words].values.join("+").to_s
   # @keywords_incl2 = params[:words][0].values[1]
    #@keywords_excl = params[:words][0].values[2]
    #{}"Keywords to search for: #{@keywords_incl1}"
   # "Here are the keywords #{@keywords_incl1}"
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

  get '/urls' do
    erb :getlinks

  end

  post '/getlinks' do
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
            "look at #{@test}"
          end
       # end
      

      get_descriptions($found_pages)
    

  end 

  #get links

  #get text

  #crawler

  end

 
#end

# end