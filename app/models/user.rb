# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  user_name  :string           not null
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_users_on_user_name  (user_name)
#

class User < ActiveRecord::Base
  validates :user_name, :presence => true, :uniqueness => true

  has_many :authored_polls, class_name: "Poll", foreign_key: :author_id, primary_key: :id, dependent: :destroy

  has_many :responses, dependent: :destroy

  def completed_polls
    polls = Poll.find_by_sql([<<-SQL, id])
      SELECT
        polls.title, COUNT(questions.id) as q_count
      FROM
        polls
      JOIN
        questions ON questions.poll_id = polls.id
      JOIN
        answer_choices ON answer_choices.question_id = questions.id
      LEFT OUTER JOIN
        (SELECT
          *
         FROM
          responses
        WHERE
          user_id = ?
        ) AS responses ON responses.answer_id = answer_choices.id
      GROUP BY
        polls.id
      HAVING
        COUNT(responses.id) = COUNT(DISTINCT questions.id)
    SQL

    p polls

    polls.each do |poll|
      p poll.title
      p poll.q_count
    end
  end

  def completed_polls
    polls_with_completion_counts
      .having('COUNT(responses.id) = COUNT(DISTINCT questions.id)')
  end

  private
  def polls_with_completion_counts
    joins_sql = <<-SQL
      LEFT OUTER JOIN (
        SELECT
          *
        FROM
          responses
        WHERE
          user_id = #{self.id}
      ) AS responses ON answer_chocies.id = responses.answer_id
    SQL

    Poll.joins(questions: :answer_choices)
      .joins(joins_sql)
      .group('polls.id')
  end
end
