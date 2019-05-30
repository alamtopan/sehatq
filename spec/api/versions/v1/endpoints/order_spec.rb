require 'spec_helper'

describe Versions::V1::Endpoints::OrderEndpoint do
  let(:login_url) {'/api/v1/users/login'}
  let(:orders_url) {'/api/v1/orders'}
  let(:order_item_url) {'/api/v1/orders/order_items'}
  let(:checkout_url) {'/api/v1/orders/checkout'}

  let!(:product1) {create :product, title: 'Tas Pria 1', stock: 10, price: 10000}
  let!(:product2) {create :product, title: 'Celana Wanita', stock: 10, price: 20000}
  let!(:user1) {create :user, full_name: 'userA', username: 'userA', email: 'userA@example.com', password: '123123'}

  context "POST /api/v1/orders" do
    describe 'For add cart product' do
      before(:each) do
        post login_url, {identifier: 'userA', password: '123123'}
        header 'Authorization', "Bearer #{user1.tokens.last.token}"
      end

      let(:order_item_params) do 
        {
          product_id: product1.id,
          quantity: 1
        }
      end

      context 'When success add product' do
        it 'Should success add to cart product' do
          post orders_url, order_item_params
          response = JSON.parse(last_response.body)
          
          expect(response['status']['success']).to eq(true)
          expect(response['data']['order_items'].size).to eq(1)
          expect(last_response.status).to eq(201)
        end
      end

      context 'Errors validations' do 
        it 'Should error when product already to cart' do
          post orders_url, order_item_params
          post orders_url, order_item_params
          response = JSON.parse(last_response.body)
          
          expect(response['status']['message']).to eq('Product already in cart')
          expect(response['status']['success']).to eq(false)
          expect(last_response.status).to eq(400)
        end

        it 'Should error when product not exists' do
          order_item_params[:product_id] = 100
          post orders_url, order_item_params
          response = JSON.parse(last_response.body)

          expect(response['status']['success']).to eq(false)
          expect(last_response.status).to eq(422)
        end
      end

    end
  end

  context "PUT /api/v1/orders/order_items/:id" do
    describe 'Update/Change quantity cart product' do
      before(:each) do
        post login_url, {identifier: 'userA', password: '123123'}
        header 'Authorization', "Bearer #{user1.tokens.last.token}"
      end

      let(:order_item_params) do 
        {
          quantity: 1
        }
      end

      context 'Errors validations' do
        it 'Should error change quantity cart product if order item not exists' do
          item = post orders_url, { product_id: product1.id, quantity: 1}
          put order_item_url+"/100", {quantity: 10}
          response = JSON.parse(last_response.body)
          expect(response['status']['success']).to eq(false)
          expect(last_response.status).to eq(404)
        end
      end

      context 'When success change quantity order' do
        it 'Should success change quantity cart product' do
          item = post orders_url, { product_id: product1.id, quantity: 1}
          put order_item_url+"/#{OrderItem.last.id}", {quantity: 10}
          response = JSON.parse(last_response.body)
          expect(response['status']['success']).to eq(true)
          expect(response['data']['price'].to_i).to eq(100000)
          expect(last_response.status).to eq(200)
        end
      end
    end
  end

  context "DELETE /api/v1/orders/order_items/:id" do
    describe 'Update/Change quantity cart product' do
      before(:each) do
        post login_url, {identifier: 'userA', password: '123123'}
        header 'Authorization', "Bearer #{user1.tokens.last.token}"
      end

      context 'Errors validations' do
        it 'Should error change quantity cart product if order item not exists' do
          item = post orders_url, { product_id: product1.id, quantity: 1}
          delete order_item_url+"/100"
          response = JSON.parse(last_response.body)
          expect(response['status']['success']).to eq(false)
          expect(last_response.status).to eq(404)
        end
      end

      context 'When success change quantity order' do
        it 'Should success change quantity cart product' do
          item = post orders_url, { product_id: product1.id, quantity: 1}
          delete order_item_url+"/#{OrderItem.last.id}"
          response = JSON.parse(last_response.body)
          expect(response['status']['success']).to eq(true)
          expect(response['data']['price'].to_i).to eq(0)
          expect(last_response.status).to eq(200)
        end
      end
    end
  end

  context "SHOW /api/v1/orders/:id" do
    describe 'Show detail order invoice' do
      before(:each) do
        post login_url, {identifier: 'userA', password: '123123'}
        header 'Authorization', "Bearer #{user1.tokens.last.token}"
      end

      context 'Errors validations' do
        it 'Should error when order not exists' do
          item = post orders_url, { product_id: product1.id, quantity: 1}
          get orders_url+"/100"
          response = JSON.parse(last_response.body)
          expect(response['status']['success']).to eq(false)
          expect(last_response.status).to eq(404)
        end
      end

      context 'When success change quantity order' do
        it 'Should success change quantity cart product' do
          item = post orders_url, { product_id: product1.id, quantity: 1}
          get orders_url+"/#{Order.last.id}"
          response = JSON.parse(last_response.body)
          expect(response['status']['success']).to eq(true)
          expect(response['data']['price'].to_i).to eq(10000)
          expect(last_response.status).to eq(200)
        end
      end
    end
  end

  context "GET /api/v1/orders" do
    describe 'List order history & search' do
      before(:each) do
        post login_url, {identifier: 'userA', password: '123123'}
        header 'Authorization', "Bearer #{user1.tokens.last.token}"

        item = post orders_url, { product_id: product1.id, quantity: 1}
        item = post orders_url, { product_id: product2.id, quantity: 1}
      end

      let(:search_params) do 
        {
          keywords: ''
        }
      end

      it 'Should show list all products exsists' do
        get orders_url, search_params
        response = JSON.parse(last_response.body)
        
        expect(response['data'].size).to eq(1)
        expect(response['status']['success']).to eq(true)
        expect(last_response.status).to eq(200)
      end

      it 'Should show product by keywords' do
        search_params[:keywords] = Order.last.invoice
        get orders_url, search_params
        response = JSON.parse(last_response.body)
        
        expect(response['data'].size).to eq(1)
        expect(response['status']['success']).to eq(true)
        expect(last_response.status).to eq(200)
      end

      it 'Should show product by keywords and product not exists' do
        search_params[:keywords] = '123123'
        get orders_url, search_params
        response = JSON.parse(last_response.body)
        
        expect(response['data'].size).to eq(0)
        expect(response['status']['success']).to eq(true)
        expect(last_response.status).to eq(200)
      end

    end
  end

  context "POST /api/v1/orders/checkout" do
    describe 'Checkout shopping cart' do
      before(:each) do
        post login_url, {identifier: 'userA', password: '123123'}
        header 'Authorization', "Bearer #{user1.tokens.last.token}"

        item = post orders_url, { product_id: product1.id, quantity: 1}
        item = post orders_url, { product_id: product2.id, quantity: 1}
      end

      let(:order_params) do 
        {
          receiver: 'Alam',
          phone: '234243244',
          payment_method: 'ATM Transfer',
          shipping_type: 'JNE',
          shipping_address: 'Jl.pelabuan'
        }
      end

      context 'Errors validations' do 
        it 'Should error when receiver blank' do
          order_params[:receiver] = nil
          post checkout_url, order_params
          response = JSON.parse(last_response.body)
          
          expect(response['status']['success']).to eq(false)
          expect(last_response.status).to eq(400)
        end

        it 'Should error when phone blank' do
          order_params[:phone] = nil
          post checkout_url, order_params
          response = JSON.parse(last_response.body)
          
          expect(response['status']['success']).to eq(false)
          expect(last_response.status).to eq(400)
        end

        it 'Should error when payment_method blank' do
          order_params[:payment_method] = nil
          post checkout_url, order_params
          response = JSON.parse(last_response.body)
          
          expect(response['status']['success']).to eq(false)
          expect(last_response.status).to eq(400)
        end

        it 'Should error when payment_method not ATM Transfer, Credit Card' do
          order_params[:payment_method] = 'Htest'
          post checkout_url, order_params
          response = JSON.parse(last_response.body)
          
          expect(response['status']['success']).to eq(false)
          expect(last_response.status).to eq(400)
        end

        it 'Should error when shipping_type blank' do
          order_params[:shipping_type] = nil
          post checkout_url, order_params
          response = JSON.parse(last_response.body)
          
          expect(response['status']['success']).to eq(false)
          expect(last_response.status).to eq(400)
        end

        it 'Should error when shipping_type blank JNE, TIKI, JNT, POS' do
          order_params[:shipping_type] = 'test'
          post checkout_url, order_params
          response = JSON.parse(last_response.body)
          
          expect(response['status']['success']).to eq(false)
          expect(last_response.status).to eq(400)
        end

        it 'Should error when shipping_address blank' do
          order_params[:shipping_address] = nil
          post checkout_url, order_params
          response = JSON.parse(last_response.body)
          
          expect(response['status']['success']).to eq(false)
          expect(last_response.status).to eq(400)
        end

      end

      context 'When success checkout order' do
        it 'Should success checkout' do
          post checkout_url, order_params
          response = JSON.parse(last_response.body)
          
          expect(response['status']['success']).to eq(true)
          expect(response['data']['order_items'].size).to eq(2)
          expect(last_response.status).to eq(201)
        end
      end

    end
  end

end