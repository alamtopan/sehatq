require 'spec_helper'

RSpec.describe Product, type: :model do
  context 'attributes' do
    it {is_expected.to have_db_column(:slug).of_type(:string)}
    it {is_expected.to have_db_column(:title).of_type(:string)}
    it {is_expected.to have_db_column(:category).of_type(:string)}
    it {is_expected.to have_db_column(:price).of_type(:float)}
    it {is_expected.to have_db_column(:cover_image).of_type(:string)}
    it {is_expected.to have_db_column(:description).of_type(:text)}
    it {is_expected.to have_db_column(:stock).of_type(:integer)}
  end

  context 'relations' do
    it {is_expected.to have_many(:order_items)}
  end
    
  context 'validations' do
    it {should validate_presence_of(:title)}
    it {should validate_presence_of(:price)}
  end
end