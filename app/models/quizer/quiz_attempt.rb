# == Schema Information
#
# Table name: quiz_attempts
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  quiz_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  status     :integer
#  score      :decimal(, )
#
# Indexes
#
#  index_quiz_attempts_on_quiz_id  (quiz_id)
#  index_quiz_attempts_on_user_id  (user_id)
#

class Quizer::QuizAttempt < ActiveRecord::Base
  belongs_to :user
  belongs_to :quiz
  has_many :question_attempts
  has_many :questions, through: :question_attempts

  enum status: [:ongoing,:finished]
  after_create :assign_questions

  def update_quiz_attempt_score!
    self.score = question_attempts.sum(:score)/questions.count.to_f
    save!
  end

  private

    def assign_questions
      possible_questions = quiz.questions
      n = [5,possible_questions.count].min
      possible_questions.order("RANDOM()").limit(n).each do |q|
        q.create_attempt!(quiz_attempt: self)
      end
    end
end
