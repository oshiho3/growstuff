module Composite
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

class ActiveRecord::Base

  def self.acts_as_composite(options={})
    unless options.empty?
      has_many :components, class_name: options[:class_name], foreign_key: options[:foreign_key] # alias
    end
  end

  include Composite
end

