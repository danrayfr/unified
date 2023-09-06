# frozen_string_literal: true

module ApplicationHelper
  include Pagy::Frontend

  def image_renderer(image_url, options = {})
    default_image_url = 'https://static.thenounproject.com/png/5034901-200.png'
    image_tag(image_url.presence || default_image_url, options)
  end

  def user_title_or_role(user)
    user.title || user.role
  end

  # rubocop:disable Metrics/MethodLength
  def ticket_detail(ticket)
    content = case ticket.access_level
              when 'inbound'
                <<-HTML
                  <div class="self-start w-3/4 my-2">
                    <div class="p-4 text-sm bg-white rounded-t-lg rounded-r-lg shadow">
                    #{ticket.content}
                    </div>
                  </div>
                HTML
              when 'client'
                <<-HTML
                  <div class="self-end w-3/4 my-2">
                    <div class="p-4 text-sm bg-white rounded-t-lg rounded-l-lg shadow">
                      #{ticket.content}
                    </div>
                  </div>
                HTML
              when 'internal'
                <<-HTML
                  <div class="self-end w-3/4 my-2">
                    <div class="p-4 text-sm bg-yellow-200 rounded-t-lg rounded-l-lg shadow">
                      #{ticket.content}
                    </div>
                  </div>
                HTML
              else
                <<-HTML
                  <div class="self-end w-3/4 my-2">
                    <div class="p-4 text-sm bg-indigo-200 rounded-t-lg rounded-l-lg shadow">
                      #{ticket.content}
                    </div>
                  </div>
                HTML
              end

    content.html_safe
  end
  # rubocop:enable Metrics/MethodLength

  def extract_url(url)
    url.split('/').last
  end

  def greetings(user)
    "Hello, #{user.name}" unless user.name.nil?
  end

  def template_status(template)
    published = template.published ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'
    published_status = template.published ? 'Publish' : 'Not publish'

    content_tag(:div, published_status, class: "inline px-3 py-1 text-sm font-normal rounded-full #{published} gap-x-2")
  end
end
