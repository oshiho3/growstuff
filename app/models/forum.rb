require 'composite'

class Forum < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]

  has_many :posts
  belongs_to :owner, :class_name => "Member"

  acts_as_composite :countable_component => false
  has_many_components :class_name => Post, :foreign_key => 'forum_id'

  def to_s
    return name
  end

end
