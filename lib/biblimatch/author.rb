module Biblimatch

  module Author

    def self.remove_initials(authors)
      case authors
      when String then remove_initials_string(authors)
      when Array then remove_initials_array(authors)
      end
    end

    def self.remove_initials_array(authors)
      authors.map { |au| remove_initials_string(au) }
    end

    def self.remove_initials_string(authors)
      authors.gsub(/ [A-Z]+,?\b/, '')
    end

  end

end
