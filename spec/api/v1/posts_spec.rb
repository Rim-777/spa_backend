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

  describe 'GET /posts/show' do
    let!(:post){create(:post)}
    let(:request) { get "/api/posts/#{post.id}" , format: :json }

    it 'return 200 status' do
      request
      expect(response).to be_success
    end

    it 'does not create a new post' do
      expect { request }.to_not change(Post, :count)
    end

    %w(id title body username created_at updated_at).each do |attr|
      it "updated post contains #{attr}" do
        request
        expect(response.body).to be_json_eql(post.send(attr.to_sym).to_json).at_path("#{attr}")
      end
    end

    it "showed post contains correct attributes" do
      request
      post.as_json.each do |key, value|
        expect(response.body).to be_json_eql(value.to_json).at_path(key.to_s)
      end
    end
  end

  describe 'POST /posts/create' do
    let(:request) { post "/api/posts", post: attributes_for(:post), format: :json }

    it 'return 200 status' do
      request
      expect(response).to be_success
    end

    it 'creates a new post' do
      expect { request }.to change(Post, :count).by(1)
    end

    it "created post contains correct attributes" do
      request
      attributes_for(:post).each do |key, value|
        expect(response.body).to be_json_eql(value.to_json).at_path(key.to_s)
      end
    end

    %w(id title body username created_at updated_at).each do |attr|
      it "created posr contains #{attr}" do
        request
        expect(response.body).to be_json_eql(Post.first.send(attr.to_sym).to_json).at_path("#{attr}")
      end
    end
  end

  describe 'PATCH /posts/update' do
    let(:new_attributes){{title: 'New Title', body: 'New Body'}}
    let!(:post){create(:post)}
    let(:request) { patch "/api/posts/#{post.id}", post:new_attributes , format: :json }

    it 'return 200 status' do
      request
      expect(response).to be_success
    end

    it 'does not create a new post' do
      expect { request }.to_not change(Post, :count)
    end

    it "created post contains correct attributes" do
      request
      new_attributes.each do |key, value|
        expect(response.body).to be_json_eql(value.to_json).at_path(key.to_s)
      end
    end

    %w(id title body username created_at updated_at).each do |attr|
      it "updated post contains #{attr}" do
        request
        post.reload
        expect(response.body).to be_json_eql(post.send(attr.to_sym).to_json).at_path("#{attr}")
      end
    end
  end

  describe 'DELETE /posts/update' do
    let!(:post){create(:post)}
    let(:request) { delete "/api/posts/#{post.id}", format: :json }

    it 'return 200 status' do
      request
      expect(response).to be_success
    end

    it 'does not create a new post' do
      expect { request }.to change(Post, :count).by(-1)
    end

    it 'does not create a new post' do
      request
      expect(JSON.parse(response.body)).to eq({})
    end
  end
end
