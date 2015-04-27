require 'rails_helper'

describe Forum do
  before(:each) do
    @forum = FactoryGirl.create(:forum)
  end

  it "belongs to an owner" do
    @forum.owner.should be_an_instance_of Member
  end

  it "stringifies nicely" do
    "#{@forum}".should eq @forum.name
  end

  it 'has a slug' do
    @forum.slug.should eq 'permaculture'
  end

  it "has many posts" do
    @post1 = FactoryGirl.create(:forum_post, :forum => @forum)
    @post2 = FactoryGirl.create(:forum_post, :forum => @forum)
    @forum.posts.length.should == 2
  end

  it "orders posts in reverse chron order" do
    @post1 = FactoryGirl.create(:forum_post, :forum => @forum, :created_at => 2.days.ago)
    @post2 = FactoryGirl.create(:forum_post, :forum => @forum, :created_at => 1.day.ago)
    @forum.posts.first.should eq @post2
  end

  context "composite" do
    
    it "single level" do
      @post1 = FactoryGirl.create(:forum_post, :forum => @forum, :updated_at => Time.now - 3.days)
      @post2 = FactoryGirl.create(:forum_post, :forum => @forum, :updated_at => Time.now - 1.day)
      @post3 = FactoryGirl.create(:forum_post, :forum => @forum, :updated_at => Time.now - 2.day)
      expect(@forum.get_count).to eq 4
      expect(@forum.get_latest).to eq @post2

      @comment1 = FactoryGirl.create(:comment, :post => @post1, :updated_at => Time.now - 10.days)
      @comment2 = FactoryGirl.create(:comment, :post => @post1, :updated_at => Time.now - 1.day)
      @comment3 = FactoryGirl.create(:comment, :post => @post2, :updated_at => Time.now)
      @comment4 = FactoryGirl.create(:comment, :post => @post2, :updated_at => Time.now - 5.days)
      @comment5 = FactoryGirl.create(:comment, :post => @post3, :updated_at => Time.now - 2.days)
      @forum.reload

      expect(@forum.get_count).to eq 9
      expect(@forum.get_latest).to eq @comment3
    end
  end
end
