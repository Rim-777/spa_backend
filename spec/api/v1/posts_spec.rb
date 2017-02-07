require_relative '../api_helper'

describe 'posts API' do

  describe 'GET /posts/index' do
    let(:request) { get "/api/posts", format: :json }
    let!(:posts) { create_list(:post, 2) }

    before { request }

    it 'return 200 status' do
      expect(response).to be_success
    end

    it 'return list of posts' do
      expect(response.body).to have_json_size(2).at_path('/')
    end

    (0..1).each do |index|
      %w(id title body username created_at updated_at).each do |field|
        it "every post object contains #{field}" do
          expect(response.body).to be_json_eql((posts[index][field]).to_json.to_sym).at_path("#{index}/#{field}")
        end
      end
    end
  end

  describe 'POST /posts/create' do
    let(:request) { post "/api/posts", post: attributes_for(:post), format: :json }

    it 'return 200 status' do
      request
      expect(response).to be_success
    end

    it 'creates a new post for user' do
      expect { request }.to change(Post, :count).by(1)
    end
  end
end
