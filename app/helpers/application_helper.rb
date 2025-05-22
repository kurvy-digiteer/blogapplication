

module ApplicationHelper
  include Pagy::Frontend


  def truncate_html(html, options = {})
    TruncateHtml::HtmlTruncator.new(html, options).truncate
  end
end
