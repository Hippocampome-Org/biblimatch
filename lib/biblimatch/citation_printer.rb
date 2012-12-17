module Biblimatch

  class Citer

    def initialize(data, opts={})
      @data = Mapper.new(data, :standard, opts[:source_database]).map
      @opts = opts
    end

    def citation
      strs = []
      strs << @data[:authors].join(', ')
      strs << @data[:title]
      strs << @data[:publication]
      strs << @data[:year]
      strs << @data[:issue]
      strs << @data[:pages]
      strs.join('. ')
    end

  end

end
