require 'spec_helper'

describe Comment do
  describe 'it uses Wilsons confidence' do
    it 'more votes means more confidence (if the ratio is the same)' do
      comment1 = Comment.new
      comment1.ups = 10; comment1.downs = 1
      comment2 = Comment.new
      comment2.ups = 100; comment2.downs = 10
      (comment1.rank < comment2.rank).should be_true
    end

    it 'values down votes' do
      comment1 = Comment.new
      comment1.ups = 100; comment1.downs = 20
      comment2 = Comment.new
      comment2.ups = 100; comment2.downs = 10
      (comment1.rank < comment2.rank).should be_true
    end

    it 'should be the same as reddit' do
      comment1 = Comment.new
      comment1.ups = 447; comment1.downs = 32
      comment3 = Comment.new
      comment3.ups = 2209; comment3.downs = 571
      comment2 = Comment.new
      comment2.ups = 3485; comment2.downs = 1161

      Comment.stub(:all).and_return([comment1, comment2, comment3])
      Comment.sort_by_rank.should == [comment1, comment3, comment2]
    end

  end


end
