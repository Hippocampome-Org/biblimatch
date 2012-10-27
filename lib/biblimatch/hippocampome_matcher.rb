module Biblimatch

  class HippocampomeMatcher

    def initialize(values, opts={})
      require_files
      check_db_connection_defined
      check_article_model_defined
      @values = values
      @page = @data.delete(:page)
    end

    def require_files
      require 'sequel'
      require '/Users/seanmackesey/Desktop/hippocampome/config'
      require '/Users/seanmackesey/Desktop/hippocampome/db/db_connection'
      require '/Users/seanmackesey/Desktop/hippocampome/db/models'
    end

    def match
      if @values[:pmid_isbn].to_s.length >= 13  # is an ISBN
        article = match_book(@values)
      else
        article = match_article(@values)
      end
      article.values
    end

    def match_book(values)
      article = match_chapter
      # if the article could not be matched to a chapter, match it to the whole book (this is the entry with nil for first_page)
      article = Article.filter(values.merge({first_page: nil})).first if not article
    end

    def match_chapter
      chapters = Article.filter(@article.values).all.reject{ |article| article.first_page == nil }  # ignore the whole book entry
      chapters.sort!{|c| c[:first_page]}
      chapters.each do |c|
        return c if @page > c[:first_page]  # correct chapter will be the first one with a lower start page
      end
      return nil
    end

    def match_article(values)
      Article[values]
    end

    def check_db_connection_defined
      raise "Database constant (DB) not defined" if not DB
    end

    def check_article_model_defined
      raise "Article model not defined" if not Article
    end

  end

end
