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
    polls_with_completion_counts
      .having("COUNT(responses.id) = COUNT(DISTINCT questions.id)")
  end

  def incomplete_polls
    polls_with_completion_counts
      .having("COUNT(responses.id) < COUNT(DISTINCT questions.id)")
      .having("COUNT(responses.id) > 0")
  end

  def uninitialized_polls
    polls_with_completion_counts
      .having("COUNT(DISTINCT questions.id) > 0")
      .having("COUNT(responses.id) = 0")
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
      .group("polls.id")
  end
end
