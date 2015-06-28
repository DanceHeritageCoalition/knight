# knight
Materials for Knight Foundation grant

Phase I: building a test scraper to find and evaluate dance criticism on the web
get_descriptions

Currently, the scraper finds the first 100 results from Google and uses the MetaInspect gem to scrape the description meta tags from the links.  The resulting metadata is saved as a csv file.  The demo search is for "Aimee Tsao",bay area, -linkedin.
Results can be refined by adjusting the Google search criteria to exclude things like LinkedIn results.  Google searching is being used to generate test data.  Future development will refine the scraper parameters. The interface will allow users to enter URLs.  
Returns results as CSV

get_links
Finds links on test page (Dance Tab reviews)
Returns results as CSV

get_text
Scrapes text from specified page, searches for presence of keyword in text, and returns a list of keyword matches
Output to console