# require 'extensions/rb-readline'
require 'highline'
require 'bio'

Bio::NCBI.default_email = "s.mackesey@gmail.com"

module Biblimatch

  class PubmedMatcher

    # Can take a hash of data about a pubmed article or a query string and search pubmed for that information
    # Returns a MedlineRecord object (modifification of the Bio::MEDLINE class)
    # Uses the BioRuby PubMed module (Bio::PubMed)

    def initialize(data, opts={})
      @data = data
      @excluded_fields = []
      @excluded_fields << :TI unless opts[:use_title]
      @excluded_fields << :AU  # added to query separately
    end

    def match
      if @data[:PMID]
        string = Bio::PubMed.efetch(@data[:PMID]).first
        record = MedlineRecord.new(string)
      else
        record = fetch_by_query
      end
      record.to_hash
    end    

    def fetch_by_query
      build_query
      while true
        retrieve_pmids
        retrieve_records_from_pmids
        if @records.length == 1
          return @records.first
        else
          selection = select_result
          return selection if selection
          refine_query
        end
      end
    end

    def build_query
      @query_terms = []
      add_authors_to_query if @data[:AU]
      add_remaining_data_to_query
      @query = @query_terms.join(' ')
    end

    def add_authors_to_query
      authors = @data[:AU].split(', ')
      authors.each { |au| @query_terms << "#{au}[AU]" }
    end

    def add_remaining_data_to_query
      @data.each do |field, value|
        if not @excluded_fields.include?(field)
          @query_terms << "#{value}[#{field}]"
        end
      end
    end

    def retrieve_pmids
      @pmids = Bio::PubMed.esearch(@query)
    end

    def retrieve_records_from_pmids
      records = Bio::PubMed.efetch(@pmids)
      @records = records.map { |record| MedlineRecord.new(record) }
    end

    def select_result
      @highline = HighLine.new
      @highline.choose do |menu|
        menu.header = "Results: "
        menu.choices(*@records)
        menu.prompt = "Choose a result (return to refine query): "
      end
    end

    def refine_query(query)
      puts "\nEnter an extension to the query or return to exit: "
      # RbReadline.prefill_prompt(query)
      # @query = Readline.readline("Query: ", true)
      @query = HighLine.new.ask("Query: ")
    end      

  end

end
