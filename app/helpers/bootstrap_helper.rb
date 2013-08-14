module BootstrapHelper

  # def page_header(title)
  #   content_for(:page_header) do
  #     content_tag :div, class: 'page-header' do
  #       content_tag :h1, title
  #     end
  #   end
  # end

  def page_header(&block)
    content_for(:page_header) do
      content_tag :div, class: 'page-header' do
        content_tag :div, nil, class: 'row-fluid', &block
      end
    end
  end

  def controller?(controller, version='v1')
    params[:controller] == "#{version}/#{controller}"
  end

  def is_active?(controller)
    "active" if controller?(controller)
  end

  def link_to_nav(content, path, controller=nil, options={})
    controller = controller || content.downcase

    content_tag :li, class: is_active?(controller) do
      link_to content, path, options
    end
  end

  def brand_link
    link_to "Revily", root_path, class: 'brand'
  end

  def collapse_button(target)
    content_tag :button, nil, class: 'btn btn-navbar', data: { toggle: 'collapse', target: target }
  end
end
