module ApplicationHelper
	def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, {:sort => column, :direction => direction}, {:class => css_class}
  end    


  def wickedpdf_stylesheet_pack_tag(source)
    css_text = wicked_pdf_stylesheet_link_tag(webpacker_source_url("#{source}.css"), media: :print)
    css_text.respond_to?(:html_safe) ? css_text.html_safe : css_text
  end
end
