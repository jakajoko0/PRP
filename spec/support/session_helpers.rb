module Features
  module SessionHelpers
    def sign_up_with(email, password)
      visit new_user_registration_path
      fill_in 'Email', with: email
      fill_in 'Password', with: password
      click_button 'Sign Up'
    end

    def sign_in_user
      user = create(:user)
      visit new_user_session_path
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_button 'Log In'
    end

    def simulate_user_sign_in(user)
      visit new_user_session_path
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_button 'Log In'
    end

    def simulate_admin_sign_in(admin)
      visit new_admin_session_path 
      fill_in 'Email', with: admin.email
      fill_in 'Password', with: admin.password
      click_button 'Log In'
    end

    def get_table_cell_text(table_id,row,col)
      css = "##{table_id} tbody tr:nth-child(#{row}) td:nth-child(#{col})"
      page.find(css).text
    end
  end
end