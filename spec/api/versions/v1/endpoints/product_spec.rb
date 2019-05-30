require 'spec_helper'

describe Versions::V1::Endpoints::ProductEndpoint do
  let(:products_url) {'/api/v1/products'}
  let(:login_url) {'/api/v1/users/login'}

  let!(:product1) {create :product, title: 'Tas Pria 1'}
  let!(:product2) {create :product, title: 'Celana Wanita'}
  let!(:user1) {create :user, full_name: 'userA', username: 'userA', email: 'userA@example.com', password: '123123'}

  context "POST /api/v1/products" do
    describe 'For add product' do
      before(:each) do
        post login_url, {identifier: 'userA', password: '123123'}
        header 'Authorization', "Bearer #{user1.tokens.last.token}"
      end

      let(:product_params) do 
        {
          category: 'T-shirt',
          title: "Kaos Pria 1",
          price: 10000,
          cover_image: '',
          description: '',
          stock: 100
        }
      end

      context 'Errors validations' do 
        it 'Should error when category blank' do 
          product_params[:category] = ''
          post products_url, product_params
          response = JSON.parse(last_response.body)
          expect(response['status']['success']).to eq(false)
          expect(last_response.status).to eq(400)
        end

        it 'Should error when title blank' do 
          product_params[:title] = ''
          post products_url, product_params
          response = JSON.parse(last_response.body)
          expect(response['status']['success']).to eq(false)
          expect(last_response.status).to eq(400)
        end

        it 'Should error when price blank' do 
          product_params[:price] = ''
          post products_url, product_params
          response = JSON.parse(last_response.body)
          expect(response['status']['success']).to eq(false)
          expect(last_response.status).to eq(400)
        end

        it 'Should error when stock blank' do 
          product_params[:stock] = ''
          post products_url, product_params
          response = JSON.parse(last_response.body)
          expect(response['status']['success']).to eq(false)
          expect(last_response.status).to eq(400)
        end

      end

      context 'When success add product' do
        it 'Should success when all validation valid' do
          post products_url, product_params
          response = JSON.parse(last_response.body)
          
          expect(response['status']['success']).to eq(true)
          expect(last_response.status).to eq(201)
        end
      end

    end
  end

  context "PUT /api/v1/product/:id" do
    describe 'Update product' do
      before(:each) do
        post login_url, {identifier: 'userA', password: '123123'}
        header 'Authorization', "Bearer #{user1.tokens.last.token}"
      end

      let(:product_params) do 
        {
          category: 'T-shirt',
          title: "Kaos Pria 1",
          price: 10000,
          cover_image: '',
          description: '',
          stock: 100
        }
      end

      context 'Errors validations' do 
        it 'Should error when category blank' do 
          product_params[:category] = ''
          put products_url+"/#{product1.id}", product_params
          response = JSON.parse(last_response.body)
          expect(response['status']['success']).to eq(false)
          expect(last_response.status).to eq(400)
        end

        it 'Should error when title blank' do 
          product_params[:title] = ''
          put products_url+"/#{product1.id}", product_params
          response = JSON.parse(last_response.body)
          expect(response['status']['success']).to eq(false)
          expect(last_response.status).to eq(400)
        end

        it 'Should error when price blank' do 
          product_params[:price] = ''
          put products_url+"/#{product1.id}", product_params
          response = JSON.parse(last_response.body)
          expect(response['status']['success']).to eq(false)
          expect(last_response.status).to eq(400)
        end

        it 'Should error when stock blank' do 
          product_params[:stock] = ''
          put products_url+"/#{product1.id}", product_params
          response = JSON.parse(last_response.body)
          expect(response['status']['success']).to eq(false)
          expect(last_response.status).to eq(400)
        end

      end

      context 'When success update product' do
        it 'Should success when all validation valid' do
          put products_url+"/#{product1.id}", product_params
          response = JSON.parse(last_response.body)
          
          expect(response['data']['title']).to eq('Kaos Pria 1')
          expect(response['status']['success']).to eq(true)
          expect(last_response.status).to eq(200)
        end
      end

    end
  end

  context "DELETE /api/v1/product/:id" do
    describe 'Delete product' do
      before(:each) do
        post login_url, {identifier: 'userA', password: '123123'}
        header 'Authorization', "Bearer #{user1.tokens.last.token}"
      end

      context 'Errors validations' do 
        it 'Should error when product not exists' do 
          delete products_url+"/100"
          response = JSON.parse(last_response.body)
          expect(response['status']['success']).to eq(false)
          expect(last_response.status).to eq(404)
        end
      end

      context 'When success update product' do
        it 'Should success when all validation valid' do
          delete products_url+"/#{product1.id}"
          response = JSON.parse(last_response.body)
          
          expect(response['status']['success']).to eq(true)
          expect(last_response.status).to eq(200)
        end
      end

    end
  end

  context "GET /api/v1/products" do
    describe 'List products & search' do
      before(:each) do
        post login_url, {identifier: 'userA', password: '123123'}
        header 'Authorization', "Bearer #{user1.tokens.last.token}"
      end

      let(:search_params) do 
        {
          keywords: ''
        }
      end

      it 'Should show list all products exsists' do
        get products_url, search_params
        response = JSON.parse(last_response.body)
        
        expect(response['data'].size).to eq(2)
        expect(response['status']['success']).to eq(true)
        expect(last_response.status).to eq(200)
      end

      it 'Should show product by keywords' do
        search_params[:keywords] = 'tas pria'
        get products_url, search_params
        response = JSON.parse(last_response.body)
        
        expect(response['data'].size).to eq(1)
        expect(response['status']['success']).to eq(true)
        expect(last_response.status).to eq(200)
      end

      it 'Should show product by keywords and product not exists' do
        search_params[:keywords] = 'jam'
        get products_url, search_params
        response = JSON.parse(last_response.body)
        
        expect(response['data'].size).to eq(0)
        expect(response['status']['success']).to eq(true)
        expect(last_response.status).to eq(200)
      end

    end
  end

  context "GET /api/v1/product/:id" do
    describe 'Show product' do
      before(:each) do
        post login_url, {identifier: 'userA', password: '123123'}
        header 'Authorization', "Bearer #{user1.tokens.last.token}"
      end

      context 'Errors validations' do 
        it 'Should error when product not exists' do 
          get products_url+"/100"
          response = JSON.parse(last_response.body)
          expect(response['status']['success']).to eq(false)
          expect(last_response.status).to eq(404)
        end
      end

      context 'When success update product' do
        it 'Should success when all validation valid' do
          get products_url+"/#{product1.id}"
          response = JSON.parse(last_response.body)
          
          expect(response['status']['success']).to eq(true)
          expect(last_response.status).to eq(200)
        end
      end

    end
  end

end