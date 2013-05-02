class V1::ApplicationController < ApplicationController
  def sanitized_params
    resource = self.class.name.demodulize.gsub("Controller", "").downcase.singularize.to_sym
    @sanitized_params ||= (params[resource] ? params.require(resource) : params).permit(*permitted_params)
  end
end
