require 'spec_helper'

RSpec.describe User, type: :model do
  context 'attributes' do
    it {is_expected.to have_db_column(:slug).of_type(:string)}
    it {is_expected.to have_db_column(:full_name).of_type(:string)}
    it {is_expected.to have_db_column(:username).of_type(:string)}
    it {is_expected.to have_db_column(:email).of_type(:string)}
    it {is_expected.to have_db_column(:crypted_password).of_type(:string)}
    it {is_expected.to have_db_column(:avatar).of_type(:string)}
    it {is_expected.to have_db_column(:provider).of_type(:string)}
    it {is_expected.to have_db_column(:uid).of_type(:string)}
  end

  context 'relations' do
    it {is_expected.to have_many(:tokens)}
    it {is_expected.to have_many(:orders)}
    it {is_expected.to have_many(:order_items).through(:orders)}
  end
    
  context 'validations' do
    it {should validate_presence_of(:username)}
    it {should validate_presence_of(:full_name)}
    it {should validate_uniqueness_of(:username)}
    it {should validate_uniqueness_of(:email)}
  end
end