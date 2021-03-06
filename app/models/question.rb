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

  has_many :answer_choices, dependent: :destroy

  belongs_to :poll

  has_many :responses, through: :answer_choices, source: :responses

  def results
    acs = answer_choices
      .select("answer_choices.text, COUNT(responses.id) AS num_responses")
      .joins(<<-SQL).group("answer_choices.id")
        LEFT OUTER JOIN responses
          ON responses.answer_id = answer_choices.id
      SQL

    acs.inject({}) do |results, ac|
      results[ac.text] = ac.num_responses;
      results
    end
  end
end
