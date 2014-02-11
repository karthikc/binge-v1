module Gulp
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

  end
end
