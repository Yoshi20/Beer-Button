class ContactMailer < ApplicationMailer

  def contact_email
    @email = params[:email]
    @name = params[:name]
    @text = params[:text]
    mail(to: 'admin@beerbutton.ch', subject: "Nachricht von #{@name}")
  end

end
