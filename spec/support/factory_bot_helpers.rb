# frozen_string_literal: true

module FactoryHelpers
  def self.upload_file(src, content_type = 'image/png', binary: true)
    path = Rails.root.join(src)
    original_filename = ::File.basename(path)

    content = File.read(path)
    tempfile = Tempfile.open(original_filename)
    tempfile.write content
    tempfile.rewind

    Rack::Test::UploadedFile.new(tempfile, content_type, binary, original_filename:)
  end
end

def common_user_id(*user_id_by_relation_methods)
  user_id = instance_values['overrides'][:user_id] || instance_values['overrides'][:user]&.id
  return user_id if user_id

  user_id_by_relation_methods.each do |method_name|
    client_id = send(method_name)
    return client_id if client_id
  end

  create(:user).id
end

def user_id_by(relation_name, class_names = relation_name)
  object = instance_values['overrides'][relation_name] ||
           find_instance_by_provided_id(relation_name, class_names)

  object&.user_id
end

def find_instance_by_provided_id(relation_name, class_names)
  [class_names].flatten.each do |class_name|
    instance = class_name.to_s.classify.constantize.find_by(
      id: instance_values['overrides'][:"#{relation_name}_id"]
    )

    return instance if instance
  end

  nil
end

def user_id_by_shopping_lists_ingredient
  user_id_by(:shopping_lists_ingredient)
end

def user_id_by_food_intakes_meal
  user_id_by(:food_intakes_meal)
end
