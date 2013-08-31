module ApplicationHelper

  # Return a title on a per-page basis
  def full_title(page_title)
    base_title = "Football Pool Mania"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  # Return the logo variable
  def logo
    image_tag("logo.png", :alt => "Sample App", :class => "round")
  end

  # Used to create dynamic complex forms (i.e. games within weeks)
  def link_to_add_fields(name, f, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + "_fields", f: builder)
    end
    link_to(name, '#', class: "add_fields", data: {id: id, fields: fields.gsub("\n", "")})
  end
end
