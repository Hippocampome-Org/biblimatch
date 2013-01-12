module Biblimatch

  class Citer

    def initialize(data, target_database=nil, opts={})
      if target_database
        data = Matcher.new(data, target_database, opts).match
      end
      @data = Mapper.new(data, :standard, opts[:source_database]).map
      @opts = opts
    end

    def citation
      strs = []
      strs << author_str
      strs << @data[:title]
      strs << @data[:publication]
      strs << @data[:year]
      strs << @data[:issue]
      strs << @data[:pages]
      strs.join('. ').gsub(/\.\s*\./, '.')
    end

    def author_str
      if @data[:authors].is_a? Array
        @data[:authors].join(', ')
      else
        @data[:authors]
      end
    end

  end

end
