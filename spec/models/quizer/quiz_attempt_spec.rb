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

require 'rails_helper'

RSpec.describe Quizer::QuizAttempt, type: :model do

  let!(:quiz_attempt) { create(:quiz_attempt, status: Quizer::QuizAttempt.statuses[:ongoing]) }
  let(:question_attempts) { build_list(:question_attempt,10, quiz_attempt: quiz_attempt) }

  context 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:quiz) }
    it { should have_many(:question_attempts) }
    it { should have_many(:questions) }
  end


  it "has a valid factory" do
    quiz_attempt = build(:quiz_attempt)
    expect(quiz_attempt).to be_valid
  end

  it "should not allow create more than one ongoing quiz_attempt for the same quiz and user" do
    invalid_quiz_attempt = build(:quiz_attempt,
      user: quiz_attempt.user,quiz: quiz_attempt.quiz,
      status: Quizer::QuizAttempt.statuses[:ongoing]
    )
    expect(invalid_quiz_attempt).to_not be_valid
    expect(invalid_quiz_attempt.errors).to have_key(:user)
  end

  it "should allow create a quiz_attempt if there are no ongoing quizzes_attempts" do
    quiz_attempt.finished!
    other_quiz_attempt = build(:quiz_attempt,
      user: quiz_attempt.user,quiz: quiz_attempt.quiz,
      status: Quizer::QuizAttempt.statuses[:ongoing]
    )
    expect(other_quiz_attempt).to be_valid
  end

  describe "#score" do

    it "should return 1 if all the questions attempts have score 1" do
      question_attempts.each do |q|
        expect(q).to receive(:calculate_score).and_return(1.0)
        q.save!
      end
      expect(quiz_attempt.score).to eq(1.0)
    end

    it "should return 0 if all the questions attempts have score 0" do
      question_attempts.each do |q|
        expect(q).to receive(:calculate_score).and_return(0.0)
        q.save!
      end
      expect(quiz_attempt.score).to eq(0.0)
    end

    it "should return the average of the scores of the question attempts" do
      scores = (0...10).map { rand }
      scores_avg = scores.sum/scores.length.to_f
      question_attempts.each_with_index do |q,i|
        expect(q).to receive(:calculate_score).and_return(scores[i])
        q.save!
      end
      expect(quiz_attempt.score).to be_within(0.001).of(scores_avg)
    end

  end

end
