require 'spec_helper'

RSpec.describe OrderItem, type: :model do
  context 'attributes' do
    it {is_expected.to have_db_column(:order_id).of_type(:integer)}
    it {is_expected.to have_db_column(:product_id).of_type(:integer)}
    it {is_expected.to have_db_column(:price).of_type(:float)}
    it {is_expected.to have_db_column(:quantity).of_type(:integer)}
    it {is_expected.to have_db_column(:total_price).of_type(:float)}
  end

  context 'relations' do
    it {is_expected.to belong_to(:order)}
    it {is_expected.to belong_to(:product)}
  end
end