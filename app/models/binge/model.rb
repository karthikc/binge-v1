module Binge
  class Model
    include ActiveModel::Model

    attr_accessor :class_name

    def parameterized_class_name
      class_name.underscore
    end

    def humanized_name
      parameterized_class_name.humanize.downcase
    end

    def klass
      @klass ||= class_name.constantize
    end

    def columns
      klass.columns.reject {|column| ["id", "created_at", "updated_at"].include?(column.name)}
    end

    def column_names
      @column_names ||= columns.map(&:name)
    end

    def ==(other)
      self.class_name == other.class_name
    end

    def create(attributes)
      instance = klass.new(attributes)
      instance.save if instance.valid?
      instance
    end

    def validate(attributes)
      instance = klass.new(attributes)
      instance.valid?
      instance
    end

    def self.all
      Binge.import_classes.collect {|class_name| Model.new(class_name: class_name)}
    end

    def self.first
      all.first
    end

    def self.find(class_name)
      all.find {|model| model.class_name == class_name || model.parameterized_class_name == class_name}
    end
  end
end
