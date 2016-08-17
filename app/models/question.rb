# == Schema Information
#
# Table name: questions
#
#  id         :integer          not null, primary key
#  text       :string           not null
#  poll_id    :integer          not null
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_questions_on_poll_id  (poll_id)
#

class Question < ActiveRecord::Base
  validates :text, :poll_id, :presence => true

  has_many :answer_choices

  belongs_to :poll

  has_many :responses, through: :answer_choices, source: :responses

  def results
    results = {}
    answer_choices.includes(:responses).each do |ac|
      results[ac.text] = ac.responses.length
    end
    results
  end
end
