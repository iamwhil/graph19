require 'rails_helper'

module Blog
  describe Post do 
    describe 'validations' do 
      # Rails 6 needs new shoulda matchers, bug here.
      # it { is_expected.to validate_presence_of :title } 
    end

    describe '#title' do 
      let(:post) { Post.create(title: "What a great title.", user_id: 1) }
      it "should have a title." do 
        expect(post.title).to eq("What a great title.")
      end
    end

  end


end