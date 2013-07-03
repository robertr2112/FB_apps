module ApplicationHelper
<<<<<<< HEAD

  # Return a title on a per-page basis
  def title
    base_title = "Ruby on Rails Tutorial Sample App"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end
  # Return the logo variable
  def logo
    image_tag("logo.png", :alt => "Sample App", :class => "round")
  end
=======
>>>>>>> 616ac7b0183417780c535a52353333211d63cdb3
end
