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

  validate :respondent_has_not_already_answered_question
  validate :respondent_is_not_poll_author

  def sibling_responses
    self.question.responses.where.not(id: self.id)
  end

  # private

  def respondent_already_answered?
    sibling_responses.exists?(user_id: self.user_id)
  end

  def respondent_has_not_already_answered_question
    if respondent_already_answered?
      errors[:respondent_id] << "cannot vote twice for question"
    end
  end

  def respondent_is_not_poll_author
    users = User.find_by_sql(<<-SQL)
      SELECT
        *
      FROM
        answer_choices
      JOIN
        questions
      ON
        answer_choices.question_id = questions.id
      JOIN
        polls
      ON
        questions.poll_id = polls.id
      WHERE
        polls.author_id = #{self.user_id}
      AND
        answer_choices.id = #{self.answer_id}
    SQL

    if users.length > 0
      errors[:respondent_id] << "cannot respond to your own poll"
    end
  end
end
