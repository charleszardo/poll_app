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
end
