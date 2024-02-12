class ApplicationMailer < ActionMailer::Base
  default from: 'BeerButton <admin@beerbutton.ch>'
  layout "mailer"
end
