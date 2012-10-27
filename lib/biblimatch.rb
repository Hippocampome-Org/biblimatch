require "biblimatch/version"
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
    record = Matcher.match(mapped_data, database)
  end

end
