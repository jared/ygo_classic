ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS.merge!(
  :date_only    => "%B %d, %Y",
  :time_only    => "%H:%M",
  :short_date   => "%b %e, %Y"
)

ActiveSupport::CoreExtensions::Date::Conversions::DATE_FORMATS.merge!(
  :short_date   => "%e %b %Y"
)