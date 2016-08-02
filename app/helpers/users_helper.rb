module UsersHelper

  #Returns the Gravatar for the given user.
  def gravatar_for(user, options = {size: 80})
    size = options[:size]
    unless user.email.nil?
      gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
      gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    else
      gravatar_url = "https://secure.gravatar.com/avatar?s=#{size}"
      # image_tag("avatar_default.png", alt: user.f_name, class: "gravatar", style: "height: #{size}px;")
    end
    image_tag(gravatar_url, alt: user.f_name, class: "gravatar")
  end

end
