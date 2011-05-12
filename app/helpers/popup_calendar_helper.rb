module PopupCalendarHelper 

  ##
  # Wrapper to create a link with no target and a javascript popup calendar
  # using Dynarch's free DHTML calendar code.  For this to work, the following files MUST
  # be included in your template:
  # +calendar.js+:: Main Calendar file
  # +calendar-en.js+:: English-languange calendar support
  # +calendar-setup.js+:: Popup and flat calendar functions.
  #
  # The input field is the HTML ID of the field in which the calendar will fill
  # the results.  Using form_for and f.text_field, the syntax will be "object"_"method"
  # or "event_start_time"
  #
  # The 'format' field takes either a string with percent codes for formatting, or one of two
  # convenience strings, +date+ and +datetime+
  
  def popup_calendar_tag(input_field, options = {})

    format = case options[:format]
    when "date"     then "%Y-%m-%d"
    when "datetime" then "%Y-%m-%d %I:%M %p"
    else                 "#{options[:format]}"
    end

    function = "Calendar.setup("
  
    js_options = {}
    js_options['inputField']  = "'#{input_field}'"
    js_options['ifFormat']    = "'#{format}'" unless format.blank?
    js_options['button']      = "'#{input_field}'"
    js_options['showsTime']   = "'#{options[:shows_time]}'" if options[:shows_time]
    js_options['timeFormat']  = "'#{options[:time_format]}'" if options[:time_format]
    js_options['step']        = 1
    js_options['singleClick'] = "'#{options[:single_click]}" if options[:single_click]
    js_options['weekNumbers'] = false
    js_options['align']       = "'BC'"
    function << (" " + options_for_javascript(js_options)) unless js_options.empty?
    function << ')'
  
    javascript_tag(function)
  end
  
end