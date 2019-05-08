module ApplicationHelper

  def full_title(title)
    if !title.empty?
      return "#{title} | Body Weight App"
    else
      return "Body Weight App"
    end
  end
end
