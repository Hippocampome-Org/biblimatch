module Biblimatch

  class HippocampomeMatcher

    def initialize(data, opts={})
      require_files
      check_db_connection_defined
      check_article_model_defined
      @data = data
      @page = @data.delete(:page)
    end

    def require_files
      require 'sequel'
      require '/Users/seanmackesey/Desktop/hippocampome/config'
      require '/Users/seanmackesey/Desktop/hippocampome/db/db_connection'
      require '/Users/seanmackesey/Desktop/hippocampome/db/models'
    end

    def match
      if @data[:pmid_isbn].to_s.length >= 13  # is an ISBN
        @article = match_book
      else
        @article = match_article
      end
      check_for_match
      @article.values
    end

    def match_book
      match_chapter or Article.filter(@data.merge({first_page: nil})).first
      # if the article could not be matched to a chapter, match it to the whole book (this is the entry with nil for first_page)
    end

    def match_chapter
      chapters = Article.filter(@data).all.reject{ |article| article.first_page == nil }  # ignore the whole book entry
      chapters.sort!{|c| c[:first_page]}
      chapters.each do |c|
        return c if @page.to_i > c[:first_page].to_i  # correct chapter will be the first one with a lower start page
      end
      return nil
    end

    def match_article
      Article[@data]
    end

    def check_db_connection_defined
      raise "Database constant (DB) not defined" if not DB
    end

    def check_article_model_defined
      raise "Article model not defined" if not Article
    end

    def check_for_match
      raise NoHippocampomeMatchError.new if not @article
    end

  end

end
