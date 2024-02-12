class ContactMailer < ApplicationMailer

  def contact_email
    @email = params[:email]
    @name = params[:name]
    @text = params[:text]
    mail(to: 'admin@beer-button.com', subject: "Nachricht von #{@name}") #blup
  end

end
