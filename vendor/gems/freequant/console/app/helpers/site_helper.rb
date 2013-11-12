module SiteHelper
  def product_short_description
    "Online Trading Strategy Development and Execution Platform"
  end

  def product_logo
    content_tag(:span, content_tag(:strong, 'FreeQ') + 'uant')
  end

  def product_description
    ""
  end

  def product_vendor
    "FreeQuant Inc."
  end

  def product_url
    "http://www.freequant.org"
  end

  def blog_url
    "http://www.freequant.org"
  end
end
