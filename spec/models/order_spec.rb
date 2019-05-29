require 'spec_helper'

RSpec.describe Order, type: :model do
  context 'attributes' do
    it {is_expected.to have_db_column(:invoice).of_type(:string)}
    it {is_expected.to have_db_column(:price).of_type(:float)}
    it {is_expected.to have_db_column(:shipping_price).of_type(:float)}
    it {is_expected.to have_db_column(:total_price).of_type(:float)}
    it {is_expected.to have_db_column(:status).of_type(:string)}
    it {is_expected.to have_db_column(:user_id).of_type(:integer)}
    it {is_expected.to have_db_column(:shipping_address).of_type(:string)}
    it {is_expected.to have_db_column(:shipping_type).of_type(:string)}
    it {is_expected.to have_db_column(:phone).of_type(:string)}
    it {is_expected.to have_db_column(:receiver).of_type(:string)}
    it {is_expected.to have_db_column(:payment_method).of_type(:string)}
  end

  context 'relations' do
    it {is_expected.to belong_to(:user)}
    it {is_expected.to have_many(:order_items)}
  end
end