require 'csv'

CSV::HeaderConverters[:to_attribute] = lambda do |header|
  header.strip.to_sym
end

CSV::Converters[:strip] = lambda do |field|
  field.blank? ? nil : field.strip
end
