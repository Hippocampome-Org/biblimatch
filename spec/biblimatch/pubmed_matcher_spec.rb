require 'spec_helper'

module Biblimatch

  describe PubmedMatcher do
    
    context "receiving an input PMID" do

      let(:data) { SAMPLE_PUBMED_DATA }
      let(:match_data) { PubmedMatcher.new(data).match }

      it "should return a record with the correct PMID" do
        match_data[:PMID].should eq(data[:PMID])
      end

    end

    context "receiving input with no PMID that matches only one pubmed record" do

      let(:data) {
        data = SAMPLE_PUBMED_DATA.dup
        data.delete(:PMID)
        data
      }
      let(:match_data) { PubmedMatcher.new(data).match }

      it "should return a record with the correct PMID" do
        match_data[:PMID].should eq(SAMPLE_PUBMED_DATA[:PMID])
      end

    end

    context "receiving input with no PMID that matches multiple records" do

      let(:data) {
        fields_to_remove = [:PMID, :TI, :AU]
        SAMPLE_PUBMED_DATA.reject { |field| fields_to_remove.include?(field) }
      }
      let(:matcher) { PubmedMatcher.new(data) }

      it "should return a pubmed record" do
        match_data = matcher.match
        match_data.should be_a_kind_of(Hash)
      end

    end

  end

end
