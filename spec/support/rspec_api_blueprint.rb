# require 'rspec_api_blueprint'

unless "".respond_to?(:indent)
  class String
    def indent(count, char = ' ')
      gsub(/([^\n]*)(\n|$)/) do |match|
        last_iteration = ($1 == "" && $2 == "")
        line = ""
        line << (char * count) unless last_iteration
        line << $1
        line << $2
        line
      end
    end
  end
end


RSpec.configure do |config|
  config.before(:suite) do
    if defined? Rails
      api_docs_folder_path = File.join(Rails.root, '/api_docs/')
    else
      api_docs_folder_path = File.join(File.expand_path('.'), '/api_docs/')
    end

    Dir.mkdir(api_docs_folder_path) unless Dir.exists?(api_docs_folder_path)

    Dir.glob(File.join(api_docs_folder_path, '*')).each do |f|
      File.delete(f)
    end
  end

  config.after(:each, type: :request) do
    if response
      example_group = example.metadata[:example_group]
      example_groups = []

      while example_group
        example_groups << example_group
        example_group = example_group[:example_group]
      end

      action = example_groups[-2][:description_args].first if example_groups[-2]
      parameters = action.match(/\w+\s(.+)/)[1]
      example_groups[-1][:description_args].first.match(/(\w+)\sRequests/)
      resource_name = $1
      resource_model_name = resource_name.parameterize.underscore.singularize.classify.constantize
      file_name = $1.underscore

      if defined? Rails
        file = File.join(Rails.root, "/api_docs/#{file_name}.txt")
      else
        file = File.join(File.expand_path('.'), "/api_docs/#{file_name}.txt")
      end

      # File.open(file, 'w+') do |f|
        # f.write "FORMAT: 1A\n\n"
        # f.write "# #{resource_name}\n\n"
      # end
      File.open(file, 'a') do |f|
        # f.write "HOST: https://api.revi.ly"
        # f.write "FORMAT: X-1A\n\n"
        # Resource & Action
        # f.write "# #{resource_model}\n\n"
        f.write "## #{action}\n\n"

        # Request
        request_body = request.request_parameters
        pretty_request_body = JSON.pretty_unparse(JSON.load(JSON.dump(request_body)))
        authorization_header = request.headers['Authorization']

        if request_body.present? || authorization_header.present?
          f.write parameters + "\n\n"
          f.write "+ Request (#{request.content_type})\n\n"

          # Request Headers
          if authorization_header.present?
            f.write "+ Headers\n\n".indent(4)
            # f.write "Authorization: #{authorization_header}\n\n".indent(12)
            f.write "Authorization: token <Authorization Token>\n\n".indent(12)
          end

          # Request Body
          if request_body.present? && request.content_type =~ /application\/json/
            f.write "+ Body\n\n".indent(4)# if authorization_header.present?
            f.write "#{pretty_request_body}\n\n".indent(authorization_header ? 12 : 8)
          end
        end

        # Response
        f.write "+ Response #{response.status} (#{response.content_type})\n\n"

        if response.body.present? && response.content_type =~ /application\/json/
          f.write "#{JSON.pretty_generate(JSON.parse(response.body))}\n\n".indent(8)
        end
      end unless response.status == 401 || response.status == 403 || response.status == 301
    end
  end
end
