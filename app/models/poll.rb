# == Schema Information
#
# Table name: polls
#
#  id         :integer          not null, primary key
#  title      :string           not null
#  author_id  :integer          not null
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_polls_on_author_id  (author_id)
#  index_polls_on_title      (title)
#

class Poll < ActiveRecord::Base
  validates :title, :author_id, :presence => true

  belongs_to :author, class_name: "User", foreign_key: :author_id, primary_key: :id

  has_many :questions
end
