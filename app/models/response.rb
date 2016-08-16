# == Schema Information
#
# Table name: responses
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  answer_id  :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Response < ActiveRecord::Base
  validates :user_id, :answer_id, :presence => true

  belongs_to :answer_choice

  belongs_to :respondent, class_name: "User", foreign_key: :user_id, primary_key: :id
end
