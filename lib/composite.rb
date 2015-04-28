module Composite
  # Returns the number of all decendents
  def get_count
    count = self.countable_component ? 1 : 0

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
    latest = nil
    components_array.each do |component|
      if latest == nil
        latest = component.get_latest
      else
        latest = latest.created_at > component.get_latest.created_at ? latest : component.get_latest
      end
    end
    return latest
  end

end

class ActiveRecord::Base

  def self.has_many_components(options={})
    has_many :components, options
  end

  def self.acts_as_composite(options={})
    include Composite
    class_attribute :countable_component
    self.countable_component = (options[:countable_component] == false) ? false : true
  end

end

