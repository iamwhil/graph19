require 'rails_helper'

::Blog::Post.include Users::Concerns::Post

describe ::Blog::Post do 

  describe "relations" do 
    it { is_expected.to belong_to :user }
  end

end