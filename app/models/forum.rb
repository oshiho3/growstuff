require 'composite'

class Forum < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]

  has_many :posts
  acts_as_composite(class_name: :Post, foreign_key: 'forum_id')
  belongs_to :owner, :class_name => "Member"

  def to_s
    return name
  end
end
