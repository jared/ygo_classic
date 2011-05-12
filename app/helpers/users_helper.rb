module UsersHelper
  
  # CHANGED: implemented semantic forms without form builder... for now.
  # class UserFormBuilder < ActionView::Helpers::FormBuilder
  #   
  #   helpers = field_helpers + 
  #             %w(select date_select datetime_select time_select) -
  #             %w(hidden_field)
  #   helpers.each do |selector|
  #     define_method(selector) do |field, *args|
  #       options = args.last.is_a?(Hash) ? args.pop : {}
  #       @template.content_tag(:li, 
  #         @template.content_tag(:label, field.to_s.humanize, :for => field) +
  #         super +
  #         @template.content_tag(:span, options[:hint], :class => "hint")
  #       )
  #     end
  #   end
  # 
  #   def fieldset(legend=nil, options = {}, &block)
  #     @template.concat(
  #       @template.content_tag(:fieldset,
  #         @template.content_tag(:legend, legend) +
  #         @template.content_tag(:ol,
  #           @template.capture(&block)
  #         ), :class => options[:class]), block.binding)
  #   end
  #   
  # end
  # 
  # 
  # def user_form_for(name, object = nil, options = nil, &proc)
  #   form_for(name,
  #            object,
  #            (options || {}).merge(:builder => UserFormBuilder),
  #            &proc)
  # end
  # 
end