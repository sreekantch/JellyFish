# == Schema Information
#
# Table name: authentications
#
#  id         :integer          not null, primary key
#  created_at :datetime
#  updated_at :datetime
#  staff_id   :integer
#  provider   :string
#  uid        :string
#
# Indexes
#
#  index_authentications_on_provider_and_uid  (provider,uid)
#  index_authentications_on_staff_id          (staff_id)
#

FactoryGirl.define do
  factory :authentications do
    provider 'facebook'
    uid '1234567'
  end
end
