module ApplicationHelper

  # Returns the full title on a per-page basis.
  def full_title(page_title = '')
    base_title = "Fahsai Rich 168"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end

  # def generate_breadcrumb(link = {})
  #   output = "<ol class='breadcrumb'>"
  #   link.each do |title, href|
  #     if href != "active"
  #       output << "<li><a href='#{href}'>#{title}</a></li>"
  #     else
  #       output << "<li class='active'>#{title}</li>"
  #     end
  #   end
  #   output << "</ol>"
  #   return(output.html_safe)
  # end

  def gen_breadcrumb(item = {})
    content_tag(:ol, class: "breadcrumb") do
      item.each do |title, href|
        if href != "active"
          concat(content_tag(:li) do
            link_to title, href
          end)
        else
          concat(content_tag(:li, title, class: "active"))
        end
      end
    end
  end

  def no_precision(num)
    return number_with_precision(num, precision: 0)
  end

  def precision(num, digit)
    return number_with_precision(num, precision: digit)
  end

  def delimiter(num)
    return number_with_delimiter(num, delimiter: ",")
  end

end
