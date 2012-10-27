require 'readline'
require 'pry'

module Biblimatch

  class Matcher

    attr_accessor :data

    ### Initialization

    def initialize(data, target_database, opts={})
      @data = Mapper.new(data, target_database, opts[:source_database]).map
      @target_database = target_database
      @output_database = opts[:output_database]
    end

    def match
      klass = get_matcher_class
      @output_data = klass.new(@data).match
      Mapper.new(@output_data, @target_database).map if @target_database
    end

    def get_matcher_class
      eval(@target_database.to_s.camelcase + "Matcher")
    end

    #def extract_options
      #options = [:return_model]
      #options.each do |opt|
        #ivar = "@" + opt.to_s
        #value = @data.delete(opt)
        #instance_variable_set(ivar, value)
      #end
    #end

    ### DEPRECATED

  end

end
