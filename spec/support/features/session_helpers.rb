module Features
    module SessionHelpers
        def login_with(email, password = "Password123")
            visit session_login_path
            fill_in "login_form[email]", with: email
            fill_in "login_form[password]", with: password
            click_button "Sign In"
        end
    end
end
