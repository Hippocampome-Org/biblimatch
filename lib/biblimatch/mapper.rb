module Biblimatch

  class Mapper

    class << self
      attr_accessor :field_mapping
      attr_accessor :alternate_field_name_hash
    end

    @field_mapping = {
      pubmed: {
        :pmid_isbn => :PMID,
        :authors => :AU,
        :publication => :TA,
        :title => :TI,
        :year => :DP,
        :pages => :PG,
        :volume => :VI,
        :issue => :IP,
        :doi => :DOI,  # this does NOT WORK going in; added in my medline record class
        :abstract => :AB,
      },
      hippocampome: {
        :pmid_isbn => :pmid_isbn,
        :authors => lambda { |authors|
          [:authors, authors.gsub(/\n/, ', ')]
        },
        :publication => :publication,
        :title => :title,
        :year => :year,
        :pages => lambda { |pages|
          first_page, last_page = Biblimatch.parse_pages(pages)
          [:first_page, :last_page].zip([first_page, last_page])
        },
        :first_page => :first_page,
        :last_page => :last_page,
        :volume => :volume,
        :issue => :issue,
        :doi => :doi,
        :page => :page
      },
      nmo: {
        :pmid_isbn => :pmid,
        :title => :article_title,
        :authors => :author,
        :abstract => :article_abstract,
        :url => :article_URL,
        :year => :year
      },
      standard: {
        :pmid_isbn => :pmid_isbn,
        :authors => :authors,
        :publication => :publication,
        :title => :title,
        :year => :year,
        :pages => :pages,
        :volume => :volume,
        :issue => :issue,
        :doi => :doi,  # this does NOT WORK going in; added in my medline record class
        :abstract => :abstract,
      },
    }

    @alternate_field_name_hash = {
      :pmid_isbn => [:pmid, :isbn, :id],
      :authors => [:auth, :author, :au],
      :publication => [:journal],
      :title => [],
      :year => [:date],
      :pages => [],
      :volume => [],
      :doi => [],
    }

    def initialize(data, data_target, data_source=nil)
      @data = data
      @data_target = data_target
      @data_source = data_source
      @unmapped_fields = []
    end

    def map
      set_out_hash
      set_in_hash
      create_field_mapping
      create_pairs
      expand_lambdas
      create_hash
    end

    def set_out_hash
      @out_hash = self.class.field_mapping[@data_target]
    end

    def set_in_hash
      if @data_source
        @in_hash = self.class.field_mapping[@data_source].invert
      else
        build_in_hash_to_standard
      end
      remove_unmapped_fields_from_in_hash
    end

    def build_in_hash_to_standard  # get mapping of field names to standard names
      build_field_name_hash
      get_standard_keys
      @in_hash = Hash[ @data.keys.zip(@standard_keys) ]
    end

    def build_field_name_hash
      hash = self.class.alternate_field_name_hash
      hash.merge!(hash) do |key, value|
        value << key  # add the standard field name
        value += self.class.field_mapping.map do |data_source, mapping|
          mapping[key]  # add the names from all databases
        end
        value.uniq
      end
      @field_name_hash = hash
    end

    def get_standard_keys
      standard_keys = @data.keys.map do |field|
        look_up_key(field)
      end
      @standard_keys = standard_keys
    end

    def remove_unmapped_fields_from_in_hash
      @in_hash.reject! { |field, value| field.nil? or value.nil? }
    end

    def look_up_key(key)
      @field_name_hash.each do |field_name, alternatives|
        return field_name if alternatives.include?(key)
      end
      return nil
    end

    def create_field_mapping
      keys = @in_hash.keys
      values = @out_hash.values_at(*@in_hash.values)
      @field_mapping = Hash[ keys.zip(values) ]
    end

    def create_pairs
      keys = @field_mapping.values_at(*@data.keys)
      values = @data.values
      pairs = keys.zip(values)
      @pairs = pairs.reject { |field, value| field.nil? }
    end

    def expand_lambdas
      @pairs.map! do |key, value|
        if key.is_a? Proc
          key.call(value)  # returns new pairs
        else
          [key, value]
        end
      end
    end

    def create_hash
      @pairs.flatten!
      Hash[ *@pairs ]
    end

  end

end
