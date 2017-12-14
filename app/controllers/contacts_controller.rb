class ContactsController < ApplicationController
	#GET request to /contact-us
	#show new cintact form
	def new
		@contact = Contact.new
	end

	#POST request /contacts
	def create
		# Mass assignment to form fields int Contact Object
		@contact = Contact.new(contact_params)
		# Save the contactobject to the db
		if @contact.save
			# Store form fields via parameters, into variables
			name = params[:contact][:name]
			email = params[:contact][:email]
			body = params[:contact][:comments]
			# Plug variables into COntact Mailer
			# email method and send email
			ContactMailer.contact_email(name, email, body).deliver
			# Store success message in flash hash
			# and redirect to the new action
			flash[:success] = "Message sent."
			redirect_to new_contact_path
		else
			# If contact object doesn't save,
			# stre errors in flash hash,
			# and redirect to the new action
			flash[:danger] = @contact.errors.full_messages.join(", ")
			redirect_to new_contact_path
		end
	end

	private
		# To collect data from form we need to use 
		#strong parameters and whitelist the form fields (security feature)
		def contact_params
			params.require(:contact).permit(:name, :email, :comments)
		end
end	
