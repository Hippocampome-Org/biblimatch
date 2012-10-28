require "biblimatch/version"
require "biblimatch/exceptions"
require "biblimatch/matcher"
require "biblimatch/mapper"
require "biblimatch/pubmed_matcher"
require "biblimatch/hippocampome_matcher"
require "biblimatch/medline_record"

require "extensions/rb-readline"
require "extensions/string"

module Biblimatch

  def self.build_pubmed_query(data)
    pubmed_data = Mapper.new(data).create_data_hash(:pubmed)
    PubmedSearcher.new(pubmed_data).build_pubmed_query
  end

  def self.match(data, database)
    mapped_data = Mapper.map(data, database)
    Matcher.match(mapped_data, database)
  end

  def self.parse_pages(page_range)
    page_range =~ /(\d+)\s*-\s*(\d+)/ 
    if $1 and $2
      diff = $1.size - $2.size
      first_page, last_page = $1, $2
      last_page = first_page[0...diff] + last_page if diff > 0  # get full end page
      return first_page, last_page
    else
      return page_range
    end
  end

end
