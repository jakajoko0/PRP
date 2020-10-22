require 'rails_helper'

shared_examples_for 'admin_not_signed_in' do 
  
  it "should return an unsuccessful response" do 
    subject
    expect(response).to_not be_successful
  end

  it "should redirect to admin sign in page" do 
    subject
     expect(response).to redirect_to (new_admin_session_path)
  end
end


shared_examples_for 'franchise_not_signed_in' do 
	
	it "should return an unsuccessful response" do 
		subject
		expect(response).to_not be_successful
	end

	it "should redirect to franchise sign in page" do
	  subject
	  expect(response).to redirect_to (new_user_session_path) 
	end
end



