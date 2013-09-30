module ApplicationHelper
  def set_title(value)
    content_for(:title, value)
  end
end
