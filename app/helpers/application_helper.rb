module ApplicationHelper

  def flash_class(level)
    case level.to_sym
      when :notice then "alert-info"
      when :success then "alert-success"
      when :error then "alert-danger"
      when :alert then "alert-warning"
    end
  end

  def default_meta_tags
    {
      reverse: true,
      separator: '|',
      description: 'BeerButton project using IoT buttons for order or service calls',
      keywords: ['beer button', 'iot', 'ordering', 'service call', 'bestellknopf'],
      canonical: request.original_url,
      noindex: !Rails.env.production?,
      icon: [
        { href: image_url('favicon.png') },
        { href: image_url('favicon.png'), rel: 'apple-touch-icon', sizes: '180x180', type: 'image/png' },
      ],
      og: {
        site_name: 'beerbutton.ch',
        title: 'BeerButton',
        description: 'BeerButton project using IoT buttons for order or service calls',
        type: 'website',
        url: request.original_url,
        image: image_url('favicon.png')
      }
    }
  end

end
