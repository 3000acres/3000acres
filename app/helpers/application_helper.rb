module ApplicationHelper

  def display_base_errors resource
    return '' if (resource.errors.empty?) or (resource.errors[:base].empty?)
    messages = resource.errors[:base].map { |msg| content_tag(:p, msg) }.join
    html = <<-HTML
    <div class="alert alert-error alert-block">
      <button type="button" class="close" data-dismiss="alert">&#215;</button>
      #{messages}
    </div>
    HTML
    html.html_safe
  end

  def cms_editable_snippet(identifier, cms_site = @cms_site, &block)

    content = cms_snippet_content(identifier, cms_site = @cms_site, &block)

    unless cms_site
      host, path = request.host_with_port.downcase, request.fullpath if respond_to?(:request) && request
      cms_site = Comfy::Cms::Site.find_site(host, path)
    end
    snippet = cms_site.snippets.find_by_identifier(identifier)

    if user_signed_in? && current_user.has_role?(:admin)
      html = <<-HTML
      <div class="snippet-wrapper">
        <a href='#{request.base_url}/cms-admin/sites/#{cms_site.id}/snippets/#{snippet.id}/edit' class='cms-edit'>
          <span class="glyphicon glyphicon-cog"></span>
        </a>
        #{content}
        
      </div>
      HTML
      html
    else
      content
    end
  end

  #   haml = <<-HTML
# .snippet-wrapper 
  # %a{href: '#{request.base_url}/cms-admin/sites/#{cms_site.id}/snippets/#{snippet.id}/edit', class: 'cms-edit'}
  #   %span.glyphicon.glyphicon-cog
  # != "#{content}"
# HTML
  #   engine = Haml::Engine.new(haml)
  #   engine.render
  # end
  def cms_snippet_edit_link(identifier, cms_site = @cms_site, &block)
    if !user_signed_in? || !current_user.has_role?(:admin)
      return
    end

    unless cms_site
      host, path = request.host_with_port.downcase, request.fullpath if respond_to?(:request) && request
      cms_site = Comfy::Cms::Site.find_site(host, path)
    end
    snippet = cms_site.snippets.find_by_identifier(identifier)

    html = <<-HTML
    <a href='#{request.base_url}/cms-admin/sites/#{cms_site.id}/snippets/#{snippet.id}/edit' class='cms-edit'>
      <span class="glyphicon glyphicon-cog"></span>
    </a>
    HTML
    html
  end

end
