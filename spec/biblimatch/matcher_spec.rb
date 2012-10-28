require 'spec_helper'

module Biblimatch

  describe Matcher do

    let(:data) { SAMPLE_HIPPOCAMPOME_DATA }
    let(:matcher) { Matcher.new(data, :pubmed) }

    it "maps unsourced input data to target database of pubmed" do
      matcher.data.keys.should include(:PMID)
    end

    it "matches input data to pubmed" do
      output = matcher.match
      output[:PMID].should eq(SAMPLE_HIPPOCAMPOME_DATA[:pmid_isbn])
    end

  end

end
