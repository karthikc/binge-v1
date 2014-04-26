module Binge
  module ApplicationHelper

    def show_error_message(object, field_name)
      if has_errors?(object, field_name)
        full_error_message = object.errors[field_name].join(", ")
        content_tag(:p, full_error_message, class: "text-danger")
      end
    end

    def has_errors?(object, field_name)
      object.errors[field_name].present?
    end

    def cell_value(model, column_name)
      column_errors = model.errors[column_name]
      column_value  = model.public_send(column_name)

      return content_tag(:td, column_value) if column_errors.empty?

      content_tag :td, id: "error-cell" do
        error_title = "#{column_errors.join(', ')} "
        content_tag :div, class: "error-text", :'data-toggle' => "tooltip", title: error_title do
          column_value || 'NULL'
        end
      end
    end
  end
end
