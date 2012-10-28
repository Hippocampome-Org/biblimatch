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
        :year => :YR,
      },
      hippocampome: {
        :pmid_isbn => :pmid_isbn,
        :authors => :authors,
        :publication => :publication,
        :title => :title,
        :year => :year,
        :page => :page,
        :first_page => :first_page,
        :last_page => :last_page,
      }
    }

    @alternate_field_name_hash = {
      :pmid_isbn => [:pmid, :isbn, :id],
      :authors => [:auth, :author, :au],
      :publication => [:journal],
      :title => [],
      :year => [:date],
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
      execute_mapping
    end

    def set_out_hash
      @out_hash = self.class.field_mapping[@data_target]
    end

    def set_in_hash
      if @data_source
        @in_hash = self.class.field_mapping[@data_source].invert
      else
        @data_source = :standard
        build_in_hash_to_standard
      end
    end

    def build_in_hash_to_standard  # get mapping of field names to standard names
      build_field_name_hash
      get_standard_keys
      remove_unmapped_fields_from_data
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
        standard_key = look_up_key(field)
        @unmapped_fields << field if not standard_key
        standard_key
      end
      @standard_keys = standard_keys.compact
    rescue StandardError => e
      binding.pry
    end

    def remove_unmapped_fields_from_data
      @unmapped_fields.each { |field| @data.delete(field) }
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

    def execute_mapping
      keys = @field_mapping.values_at(*@data.keys)
      values = @data.values
      Hash[ keys.zip(values) ]
    end

  end

end
