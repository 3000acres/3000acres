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

  def cms_editable_snippet(identifier)

    content = cms_snippet_content(identifier)

    host, path = request.host_with_port.downcase, request.fullpath if respond_to?(:request) && request
    cms_site = Comfy::Cms::Site.find_site(host, path)

    if user_signed_in? && current_user.has_role?(:admin)
      if !cms_site.nil? 
        snippet = cms_site.snippets.find_by_identifier(identifier)
        if !snippet.nil?
          content = <<-HTML
          <div class="snippet-wrapper">
            <a href='#{request.base_url}/cms-admin/sites/#{cms_site.id}/snippets/#{snippet.id}/edit' class='snippet-edit'>
              <span class="glyphicon glyphicon-cog"></span>
            </a>
            #{content}
          </div>
          HTML
        end
      else
        content = "<div class='snippet-edit'>No CMS</div>"
      end
    end
    content
  end

  def cms_snippet_edit_link(identifier)
    html=""
    # links are only for admin
    if !user_signed_in? || !current_user.has_role?(:admin)
      return
    end

    host, path = request.host_with_port.downcase, request.fullpath if respond_to?(:request) && request
    cms_site = Comfy::Cms::Site.find_site(host, path)
    if !cms_site.nil?
      snippet = cms_site.snippets.find_by_identifier(identifier)
      if !snippet.nil?
        html = <<-HTML
          <a href='#{request.base_url}/cms-admin/sites/#{cms_site.id}/snippets/#{snippet.id}/edit' class='snippet-edit'>
            <span class="glyphicon glyphicon-cog"></span>
          </a>
        HTML
      end
    else
      content = "<div class='snippet-edit'>No CMS</div>"
    end
    html
  end
end
