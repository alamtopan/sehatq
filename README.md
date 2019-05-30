# SETUP
git clone git@github.com:alamtopan/sehatq.git

open console terminal cd sehatq

bundle install 

bundle exec rake db:create

bundle exec rake db:migrate

RACK_ENV=test bundle exec rake db:create

RACK_ENV=test bundle exec rake db:migrate

rails s


# AVAILABLE API

POST  |  /api/:version/orders(.json)                         |  v1  |  ------------ Add Order Items ---------------                                       
PUT  |  /api/:version/orders/order_items/:id(.json)          |  v1  |  ------------ Update Order Item ---------------                                     
DELETE  |  /api/:version/orders/order_items/:id(.json)         |  v1  |  ------------ Delete Order item ---------------                                     
POST  |  /api/:version/orders/checkout(.json)                |  v1  |  ------------ Checkout Order ---------------                                        
GET  |  /api/:version/orders/:id(.json)                     |  v1  |  ------------ Show Order ---------------                                            
GET  |  /api/:version/orders(.json)                         |  v1  |  ------------ History Order User ---------------                                    
POST  |  /api/:version/products(.json)                       |  v1  |  ------------ Add Product ---------------                                           
PUT  |  /api/:version/products/:id(.json)                   |  v1  |  ------------ Update Product ---------------                                        
DELETE  |  /api/:version/products/:id(.json)                   |  v1  |  ------------ Delete Product ---------------                                        
GET  |  /api/:version/products/:id(.json)                   |  v1  |  ------------ Show Product ---------------                                          
GET  |  /api/:version/products(.json)                       |  v1  |  ------------ List Product ---------------                                          
GET  |  /api/:version/users/auth/:provider/callback(.json)  |  v1  |  ------------ Login or Register with omniouth facebook/google_oauth2 ---------------

GET  |  /api/:version/users/check-token(.json)              |  v1  |  ------------ Check token ---------------                                           
DELETE  |  /api/:version/users/logout(.json)                   |  v1  |  ------------ Logout User ---------------                                           
POST  |  /api/:version/users/login(.json)                    |  v1  |  ------------ Login user ---------------                                            
POST  |  /api/:version/users/register(.json)                 |  v1  |  ------------ Register user ---------------    


# FRONT LOGIN FB & GOOGLE

for login fb or google after rails server in console, you can try open url http://localhost:3000 (after opening, you will see a button to be able to try to login Facebook and Google)
