ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  error_class = "fieldError"
  if html_tag =~ /<(input|textarea|select)[^>]+class=/
    style_attribute = html_tag =~ /class=['"]/
    html_tag.insert(style_attribute + 7, "#{error_class} ")
  elsif html_tag =~ /<(input|textarea|select)/
    first_whitespace = html_tag =~ /\s/
    html_tag[first_whitespace] = " class='#{error_class}' "
  end
  html_tag
end
