module Versions::V1::Entities
  class UserEntity < Versions::V1::Entities::PaginatedEntity
		expose :id, :slug, :full_name, :username, :email, :avatar, :provider, :uid
		expose(:token) {|r| r.tokens.last.token rescue nil}
		expose(:token_expired) {|r| r.tokens.last.expiry_date rescue nil}
		expose :created_at
		expose :updated_at
	end
end