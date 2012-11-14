require 'readline'
require 'pry'

module Biblimatch

  class Matcher

    attr_accessor :data

    ### Initialization

    def initialize(data, target_database, opts={})
      @data = Mapper.new(data, target_database, opts[:source_database]).map
      @target_database = target_database
      @opts = opts
    end

    def match
      klass = get_matcher_class
      @output_data = klass.new(@data).match
      @output_data = Mapper.new(@output_data, @opts[:output_database], @target_database).map if @opts[:output_database]
      convert_keys_to_string if @opts[:string_keys]
      @output_data
    end

    def get_matcher_class
      eval(@target_database.to_s.camelcase + "Matcher")
    end

    def convert_keys_to_string
      keys = @output_data.keys.map { |key| key.to_s }
      @output_data = Hash[ keys.zip(@output_data.values) ]
    end

    ### DEPRECATED

  end

end
