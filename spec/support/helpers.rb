# frozen_string_literal: true

def body_as_json
  JSON.parse(response.body).with_indifferent_access
end

def google_successful_response(user)
  {
    sub: Array.new(21) { rand(9) }.join,
    name: user.name,
    given_name: user.name.split.first,
    family_name: user.name.split.last,
    picture: FFaker::Image.url,
    email: user.email,
    email_verified: true,
    locale: :ru
  }.to_json
end

def google_unsuccessful_response
  {
    error: :invalid_request,
    error_description: 'Invalid Credentials'
  }.to_json
end

def first_available_scheme
  ENV.fetch('AVAILABLE_APP_SCHEMES').split[0]
end

def transform_to_search_attrs(attributes)
  attributes.each_with_object({}) do |params, result|
    params.each do |key, value|
      result[key] ||= []
      result[key] << value
    end
  end
end
