module ApplicationHelper
  def flash_block
    output = ''
    flash.each do |type, message|
      type = :success if type == :notice
      type = :error   if type == :alert
      type = ""       if type == :info
      output += flash_container(type, message)
    end

    raw(output)
  end

  def flash_container(type, message)
    raw(content_tag(:div, class: "alert-box #{type.to_s}") do
      content_tag(:a, raw("&times;"), class: 'close') + message
    end)
  end

  def modal_dialog(options = {}, escape = true, &block)
    default_options = {class: "bootstrap-modal modal"}
    content_tag :div, nil, options.merge(default_options), escape, &block
  end

  def modal_header(options = {}, escape = true, &block)
    default_options = {class: 'modal-header'}
    content_tag :div, nil, options.merge(default_options), escape do
      raw("<button class=\"close\" data-dismiss=\"modal\">&times;</button>" + capture(&block))
    end
  end

  def modal_body(options = {}, escape = true, &block)
    default_options = {class: 'modal-body'}
    content_tag :div, nil, options.merge(default_options), escape, &block
  end

  def modal_footer(options = {}, escape = true, &block)
    default_options = {class: 'modal-footer'}
    content_tag :div, nil, options.merge(default_options), escape, &block
  end

  def modal_toggle(content_or_options = nil, options = {}, &block)
    if block_given?
      options = content_or_options if content_or_options.is_a?(Hash)
      default_options = {class: 'btn', "data-toggle" => "modal", "href" => options[:dialog]}.merge(options)

      content_tag :a, nil, default_options, true, &block
    else
      default_options = {class: 'btn', "data-toggle" => "modal", "href" => options[:dialog]}.merge(options)
      content_tag :a, content_or_options, default_options, true
    end
  end

  def modal_cancel_button content, options = {}
    default_options = {class: "btn bootstrap-modal-cancel-button"}

    content_tag_string "a", content, default_options.merge(options)
  end

  def link_to_add_fields(name, f, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.simple_fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + "_fields", f: builder)
    end
    link_to(name, '#', class: 'add_fields', data: { id: id, fields: fields.gsub("\n", "")})
  end

  def icon_links
    content_tag :link, nil, href: "images/apple-touch-icon-144x144.png", rel: "apple-touch-icon-precomposed", sizes: "144x144"
    content_tag :link, nil, href: "images/apple-touch-icon-72x72.png", rel: "apple-touch-icon-precomposed", sizes: "72x72"
    content_tag :link, nil, href: "images/apple-touch-icon.png", rel: "apple-touch-icon-precomposed"
    content_tag :link, nil, href: "favicon.ico", rel: "shortcut icon"
  end

end
