Rails.application.routes.draw do
	root 'public#home'
	mount Versions::Base => '/'
end
