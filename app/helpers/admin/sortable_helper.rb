module Admin::SortableHelper
  def sortable_column(column, title = nil)
    title ||= column.titleize
    direction = (column == params[:sort] && params[:direction] == "asc") ? "desc" : "asc"
    #arrow to show what direction the column is sorted
    arrow = if column == params[:sort]
      params[:direction] == "asc" ? "↑" : "↓"
    end
    link_to "#{title} #{arrow}".html_safe, { sort: column, direction: direction}
  end
end
