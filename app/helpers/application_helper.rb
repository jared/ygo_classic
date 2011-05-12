# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def odometer(mileage = 0) 
    returning Array.new do |output|
      mileage.to_s.split(%r{\s*}).each { |digit| output << image_tag("odometer/#{digit}.png") }
    end
  end
  
  def error_message_on(object, method, prepend_text = "", append_text = "", css_class = "formError")
    if (obj = instance_variable_get("@#{object}")) && (errors = obj.errors.on(method))
      content_tag("span", "#{prepend_text}#{errors.is_a?(Array) ? errors.first : errors}#{append_text}", :class => css_class)
    else 
      ''
    end
  end
  
  def title(title)
    content_for(:title) { title }
  end
  
end
