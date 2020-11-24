module MenuHelper
	def main_dropdown_menu(title)
		html = <<-HTML
		<li class = "nav-item dropdown">
			<a href = "#"
			 class="dropdown-toggle nav-link" 
       data-toggle="dropdown" 
       role="button" 
       aria-haspopup = "true" 
       aria-expanded = "false">
       #{title}

     </a>
    <ul class = "dropdown-menu multi-level" 
        aria-labelledby="navbarDropdownAccountLink">
		HTML

		html.html_safe
	end

	def close_main_dropdown
		html = <<-HTML
		 </ul>
		</li>
		HTML
		html.html_safe
	end

	def dropdown_item(title, link)
		html = <<-HTML 
		<li>
			<a class="dropdown-item" data-turbolinks="false" href="#{link}">
				#{title}
      </a>
    </li>

		HTML

		html.html_safe
	end

	def dropdown_submenu(title)
		html = <<-HTML
		<li class = "dropdown-submenu">
			<a class = "dropdown-item dropdown-toggle" 
        tabindex="-1" 
        href="#">
          #{title}
      </a>
      <ul class = "dropdown-menu">
		HTML
		html.html_safe
	end

	def close_dropdown_submenu
		html = <<-HTML
		  </ul>
		</li>
		HTML
		html.html_safe
	end

end