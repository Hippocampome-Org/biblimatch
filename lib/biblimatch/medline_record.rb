require 'csv'

module Biblimatch

  class MedlineRecord < Bio::MEDLINE

    ### Providing the data in the form and with method names I like

    def initialize(str)
      super
      set_doi
    end

    def set_doi
      if @pubmed["AID"]
        if @pubmed["AID"].match(/(\S*)\s*\[doi\]/)
          @pubmed["DOI"] = $1
        end
      end
    end

    def authors
      au.gsub("\n", ", ")
    end

    def pmid_isbn
      pmid
    end

    def publication
      ta
    end

    def volume
      vi
    end

    #def first_page
    #Biblimatch.parse_pages.first
    #end

    #def last_page
    #parse_pages.last
    #end

    def to_s
      "PMID: #{pmid}" + "\n  " + "AUTHORS: #{authors}" + "\n  " + "TITLE: #{title}"
    end

    def export_for_article_csv
      csv_fields = [:authors, :pmid_isbn, :first_page, :last_page, :title, :year, :publication, :volume]
      @fields.select { |field| csv_fields.include?(field) }
    end

    def to_hash
      pairs = @pubmed.map do |field, value|
        field = field.to_sym
        value = value.strip if value.is_a? String
        [field, value]
      end
      Hash[ pairs ]
    end

  end

end
