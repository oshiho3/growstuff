require 'pry'
class Forum < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]

  has_many :posts
  has_many :components, :class_name => :Post,:foreign_key => 'forum_id' # alias for posts
  belongs_to :owner, :class_name => "Member"

  def to_s
    return name
  end

  # Returns the number of all decendents
  def get_count
    count = 1
    if defined?(components)
      components.each { |component| count += component.get_count }
    end
    return count
  end

  def get_latest
    # When thre is no child component
    return self if !defined?(components) || components.size == 0

    # When there are child components
    components_array = components.all
    latest = components_array.inject do |latest, component|
      latest.updated_at > component.get_latest.updated_at ? latest : component.get_latest
    end
    return latest
  end
end
