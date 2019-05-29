require 'spec_helper'

RSpec.describe Token, type: :model do
  context 'attributes' do
    it {is_expected.to have_db_column(:token).of_type(:text)}
    it {is_expected.to have_db_column(:kind).of_type(:string)}
    it {is_expected.to have_db_column(:expiry_date).of_type(:date)}
    it {is_expected.to have_db_column(:user_id).of_type(:integer)}
  end

  context 'relations' do
    it {is_expected.to belong_to(:user)}
  end
end