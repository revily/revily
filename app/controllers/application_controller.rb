class ApplicationController < ActionController::Base
  respond_to :json
  
  protect_from_forgery
  
  def after_sign_in_path_for(resource_or_scope)
    dashboard_url
  end

  def current_account
    current_user.account
  end
  helper_method :current_account

  protected
  # after_filter :only => [:index] {set_pagination(:books)}
  #
  # def index
  #   @books = Book.page params[:page]
  # end
  def set_pagination(name, options = {})
    scope = instance_variable_get("@#{name}")
    request_params = request.query_parameters
    url_without_params = request.original_url.slice(0..(request.original_url.index("?")-1)) unless request_params.empty?
    url_without_params ||= request.original_url
 
    page = {}
    page[:first] = 1 if scope.total_pages > 1 && !scope.first_page?
    page[:last] = scope.total_pages  if scope.total_pages > 1 && !scope.last_page?
    page[:next] = scope.current_page + 1 unless scope.last_page?
    page[:prev] = scope.current_page - 1 unless scope.first_page?
 
    pagination_links = []
    page.each do |k,v|
      new_request_hash= request_params.merge({:page => v})
      pagination_links << "<#{url_without_params}?#{new_request_hash.to_param}>;rel=\"#{k}\">"
    end
    headers[:Links] = pagination_links.join(",")
  end

end
