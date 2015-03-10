# == Schema Information
#
# Table name: resources
#
#  id            :integer          not null, primary key
#  course_id     :integer
#  title         :string(100)
#  description   :string
#  row           :integer
#  type          :integer
#  url           :string
#  time_estimate :string(50)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Resource < ActiveRecord::Base
  include RankedModel
  ranks :row, with_same: :course_id

  self.inheritance_column = nil

  enum type: [:post, :video, :course, :tutorial, :book]

  belongs_to :course
  has_and_belongs_to_many :users

  validates :course, :title, :description, presence: :true
  validates :url, presence: true, format: { with: URI.regexp }

  default_scope { rank(:row) }
end
