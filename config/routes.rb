Rails.application.routes.draw do
  api vendor_string: "spa_backend", default_version: 1 do
    version 1 do
      cache as: 'v1' do
        resources :posts
      end
    end


  end
end
