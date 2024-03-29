module Admin::CustomFieldsHelper
    
  def options_for_field_kind(selected = nil)
    options = %w{String Text Category Boolean Date File}.map do |kind|
      [t("admin.custom_fields.kind.#{kind.downcase}"), kind]
    end    
  end
  
  def options_for_order_by(content_type, collection_name)
    options = %w{updated_at _position_in_list}.map do |type|
      [t("admin.content_types.form.order_by.#{type.gsub(/^_/, '')}"), type]
    end
    options + options_for_highlighted_field(content_type, collection_name)
  end
  
  def options_for_highlighted_field(content_type, collection_name)
    custom_fields_collection_name = "ordered_#{collection_name.singularize}_custom_fields".to_sym
    collection = content_type.send(custom_fields_collection_name)
    collection.delete_if { |f| f.label == 'field name' }
    collection.map { |field| [field.label, field._name] }
  end
  
  def options_for_group_by_field(content_type, collection_name)
    custom_fields_collection_name = "ordered_#{collection_name.singularize}_custom_fields".to_sym
    collection = content_type.send(custom_fields_collection_name)
    collection.delete_if { |f| not f.category? }
    collection.map { |field| [field.label, field._name] }
  end
  
  def options_for_text_formatting
    options = %w{none html}.map do |option|
      [t("admin.custom_fields.text_formatting.#{option}"), option]
    end
  end
  
end