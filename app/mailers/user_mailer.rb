class UserMailer < ApplicationMailer

  def registraion_email
    @email = params[:email]
    @phone = params[:phone]
    @url = users_url
    mail(
      to: "admin@beerbutton.ch",
      subject: "New user registered on beerbutton.ch!"
    )
  end

  def welcome_email
    @user = params[:user]
    @greeting = "Guten #{Time.now.hour <= 11 ? 'Morgen' : (Time.now.hour < 18 ? 'Tag' : 'Abend')}"
    # I18n.with_locale(params[:locale]) do
    mail(
      to: @user.email,
      bcc: "admin@beerbutton.ch",
      subject: "BeerButton"
    )
    # end
  end

end
