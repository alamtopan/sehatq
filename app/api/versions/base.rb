module Versions
  class Base < Grape::API
    use Rack::Session::Cookie
		include Versions::Kernel
		
		mount Versions::V1::Endpoints::UserEndpoint
		mount Versions::V1::Endpoints::ProductEndpoint
		mount Versions::V1::Endpoints::OrderEndpoint
	end
end
