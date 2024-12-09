module ApplicationHelper
  def page_title(title = '')
    base_title = 'AMUCOMMU'
    title.present? ? "#{title} | #{base_title}" : base_title
  end

  def flash_background_color(type)
    case type.to_sym
    when :notice then "bg-green-400"
    when :alert  then "bg-red-400"
    when :error  then "bg-yellow-500"
    else "bg-gray-500"
    end
  end
end
