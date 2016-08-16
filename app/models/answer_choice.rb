# == Schema Information
#
# Table name: answer_choices
#
#  id          :integer          not null, primary key
#  text        :string           not null
#  question_id :integer          not null
#  created_at  :datetime
#  updated_at  :datetime
#
# Indexes
#
#  index_answer_choices_on_question_id  (question_id)
#

class AnswerChoice < ActiveRecord::Base
  validates :text, :question_id, :presence => true
end
