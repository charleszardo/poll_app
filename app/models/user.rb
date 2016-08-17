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

  has_many :authored_polls, class_name: "Poll", foreign_key: :author_id, primary_key: :id

  has_many :responses

  def completed_polls
    polls = Poll.find_by_sql([<<-SQL, id])
      SELECT
        polls.title, COUNT(questions.id) as q_count
      FROM
        polls
      JOIN
        questions ON questions.poll_id = polls.id
      GROUP BY
        polls.id
    SQL

    polls.each do |poll|
      p poll.title
      p poll.q_count
    end
  end
end
