require 'spec_helper'

describe Versions::V1::Endpoints::UserEndpoint do
  let(:register_url) {'/api/v1/users/register'}
  let(:login_url) {'/api/v1/users/login'}
  let(:logout_url) {'/api/v1/users/logout'}
  let(:check_token_url) {'/api/v1/users/check-token'}

  let!(:user1) {create :user, full_name: 'userA', username: 'userA', email: 'userA@example.com', password: '123123'}
  let!(:user2) {create :user, full_name: 'userB', username: 'userB', email: 'userB@example.com', password: '123123'}

  context "POST /api/v1/users/login" do 
    describe 'For login user' do       
      context 'Errors validations' do
        it 'Should error when username' do
          post login_url, { identifier: 'usertest', password: '123123'}
          response = JSON.parse(last_response.body)
    
          expect(last_response.status).to eq(400)
          expect(response['status']['success']).to eq(false)
          expect(response['status']['message']).to eq('Email or Username Not Found')
        end

        it 'Should error when email not found' do
          post login_url, { identifier: 'usertest@yahoo.com', password: '123123'}
          response = JSON.parse(last_response.body)
    
          expect(last_response.status).to eq(400)
          expect(response['status']['success']).to eq(false)
          expect(response['status']['message']).to eq('Email or Username Not Found')
        end

        it 'Should error when password invalid' do
          post login_url, { identifier: 'user1', password: '111111'}
          response = JSON.parse(last_response.body)

          expect(last_response.status).to eq(400)
          expect(response['status']['success']).to eq(false)
          expect(response['status']['message']).to eq('Wrong Password')
        end
      end

      context 'When success login' do
        it 'should success when username/email found, password correct' do
          post login_url, { identifier: 'user1', password: '123123'}
          response  = JSON.parse(last_response.body)

          expect(response['data']['token'].present?).to eq(true)
          expect(response['status']['success']).to eq(true)
          expect(last_response.status).to eq(201)
        end
      end
    
    end
  end

  context "POST /api/v1/users/register" do
    describe 'For register user' do
      let(:user_params) do 
        {
          email: 'jhon@yahoo.com',
          username: "jhone",
          full_name: "Jhone",
          password: '123123'
        }
      end

      context 'Errors validations' do 
        it 'Should error when password less than 6 digits' do 
          user_params[:password] = '1111'
          post register_url, user_params
          response = JSON.parse(last_response.body)
          expect(response['status']['message']).to eq('Password must be at least 6 digits')
          expect(response['status']['success']).to eq(false)
          expect(last_response.status).to eq(400)
        end

        it 'Should error when password blank' do 
          user_params[:password] = ''
          post register_url, user_params
          response = JSON.parse(last_response.body)
          expect(response['status']['success']).to eq(false)
          expect(last_response.status).to eq(400)
        end

        it 'Should error when username already exist' do 
          user_params[:username] = 'userA'
          post register_url, user_params
          response = JSON.parse(last_response.body)
          expect(response['status']['success']).to eq(false)
          expect(last_response.status).to eq(422)
        end

        it 'Should error when username blank' do 
          user_params[:username] = ''
          post register_url, user_params
          response = JSON.parse(last_response.body)
          expect(response['status']['success']).to eq(false)
          expect(last_response.status).to eq(400)
        end

        it 'Should error when email already exist' do 
          user_params[:email] = 'userA@example.com'
          post register_url, user_params
          response = JSON.parse(last_response.body)
          expect(response['status']['success']).to eq(false)
          expect(last_response.status).to eq(422)
        end

        it 'Should error when email not valid' do 
          user_params[:email] = 'userA'
          post register_url, user_params
          response = JSON.parse(last_response.body)
          expect(response['status']['success']).to eq(false)
          expect(last_response.status).to eq(422)
        end

        it 'Should error when email blank' do 
          user_params[:email] = ''
          post register_url, user_params
          response = JSON.parse(last_response.body)
          expect(response['status']['success']).to eq(false)
          expect(last_response.status).to eq(400)
        end

        it 'Should error when fullname blank' do 
          user_params[:full_name] = ''
          post register_url, user_params
          response = JSON.parse(last_response.body)
          expect(response['status']['success']).to eq(false)
          expect(last_response.status).to eq(400)
        end

      end

      context 'When success register' do
        it 'Should success when all validation valid' do
          post register_url, user_params
          response = JSON.parse(last_response.body)
          
          expect(response['status']['success']).to eq(true)
          expect(last_response.status).to eq(201)
        end
      end

    end
  end

  context "POST /api/v1/users/logout" do
    describe 'For logout user' do 
      before(:each) do
        post login_url, {identifier: 'userA', password: '123123'}
        header 'Authorization', "Bearer #{user1.tokens.last.token}"
      end

      context 'when fail to logout' do
        it 'Should error when token nil' do
          header 'Authorization', ""
          delete logout_url
          response = JSON.parse(last_response.body)

          expect(response['status']['message']).to eq('Not Authorize')
          expect(response['status']['success']).to eq(false)
          expect(last_response.status).to eq(400)
        end
      end

      context 'when success logout' do
        it 'Should success when token exists' do
          delete logout_url
          response = JSON.parse(last_response.body)
    
          expect(response['data']['token'].blank?).to eq(true)
          expect(response['status']['success']).to eq(true)
          expect(last_response.status).to eq(200)
        end
      end
    end
  end

  context "POST /api/v1/users/check-token" do
    before(:each) do
      post login_url, {identifier: 'userA', password: '123123'}
      header 'Authorization', "Bearer #{user1.tokens.last.token}"
    end

    describe 'check token current user' do
      it 'Should error when token blank' do
        header 'Authorization', ""
        get check_token_url
        response = JSON.parse(last_response.body)        
        expect(response['status']['message']).to eq('Not Authorize')
        expect(response['status']['success']).to eq(false)
        expect(last_response.status).to eq(400)
      end

      it 'Should success when token exists' do
        get check_token_url
        response = JSON.parse(last_response.body)  
        expect(response['status']['success']).to eq(true)      
        expect(last_response.status).to eq(200)
      end
    end
  end
end