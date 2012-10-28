require 'spec_helper'

module Biblimatch

  describe Mapper do

    describe "#map" do

      context "with hippocampome input" do

        let(:data) { SAMPLE_HIPPOCAMPOME_DATA }

        context "sourced" do

          let(:mapper) { Mapper.new(data, :pubmed, :hippocampome) }
          let(:output) { mapper.map }

          it "maps pmid_isbn to pubmed correctly" do 
            output[:PMID].should eql(data[:pmid_isbn])
          end

          it "maps authors to pubmed correctly" do 
            output[:AU].should eql(data[:authors])
          end

          it "maps publication to pubmed correctly" do 
            output[:TA].should eql(data[:publication])
          end

          it "maps title to pubmed correctly" do 
            output[:TI].should eql(data[:title])
          end

          it "maps year to pubmed correctly" do 
            output[:DP].should eql(data[:year])
          end

        end

        context "unsourced" do

          let(:mapper) { Mapper.new(data, :pubmed) }
          let(:output) { mapper.map }

          it "maps pmid_isbn correctly" do 
            output[:PMID].should eq(data[:pmid_isbn])
          end

          it "maps authors correctly" do 
            output[:AU].should eq(data[:authors])
          end

          it "maps publication correctly" do 
            output[:TA].should eq(data[:publication])
          end

          it "maps title correctly" do 
            output[:TI].should eq(data[:title])
          end

          it "maps year correctly" do 
            output[:DP].should eq(data[:year])
          end

        end

      end

      context "with pubmed input" do

        let(:data) { SAMPLE_PUBMED_DATA }

        context "sourced" do

          let(:mapper) { Mapper.new(data, :hippocampome, :pubmed) }
          let(:output) { mapper.map }

          it "maps PMID to hippocampome correctly" do 
            output[:pmid_isbn].should eq(data[:PMID])
          end

          it "maps AU to hippocampome correctly" do 
            output[:authors].should eq(data[:AU])
          end

          it "maps TA to hippocampome correctly" do 
            output[:publication].should eq(data[:TA])
          end

          it "maps TI to hippocampome correctly" do 
            output[:title].should eq(data[:TI])
          end

          it "maps DP to hippocampome correctly" do 
            output[:year].should eq(data[:DP])
          end

          it "maps PG to hippocampome first_page correctly" do
            output[:first_page].should eql("14670")
          end

          it "maps PG to hippocampome last_page correctly" do
            output[:last_page].should eql("14684")
          end

        end

      end

    end

  end

end

