class Comment < ActiveRecord::Base
  belongs_to :author, :class_name => 'Member'
  belongs_to :post
  belongs_to :parent, :class_name => :Post,:foreign_key => 'post_id'  # alias for post

  default_scope { order("created_at DESC") }
  scope :post_order, -> { reorder("created_at ASC") } # for display on post page

  after_create do
    recipient = self.post.author.id
    sender    = self.author.id
    # don't send notifications to yourself
    if recipient != sender
      Notification.create(
        :recipient_id => recipient,
        :sender_id => sender,
        :subject => "#{self.author} commented on #{self.post.subject}",
        :body => self.body,
        :post_id => self.post.id
      )
    end
  end

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
