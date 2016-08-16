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
  validates :user_id, :answer_id, presence: true

  belongs_to :answer_choice, class_name: "AnswerChoice", foreign_key: :answer_id

  belongs_to :respondent, class_name: "User"

  has_one :question, through: :answer_choice

  def sibling_responses
    self.question.responses.where.not(id: self.id)
  end
end
