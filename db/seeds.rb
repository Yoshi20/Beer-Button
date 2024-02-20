# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# Static tables:
DeviceType.create([
  { name: 'Buttonboard',    number_of_buttons: 6 },
  # { name: 'LoRa-EPD-4Btns', number_of_buttons: 4 },
  { name: 'LoRa-EPD-2Btns', number_of_buttons: 2 },
  # { name: 'LoRa-Wristband', number_of_buttons: 1 },
  { name: 'Dragino-LDS02',  number_of_buttons: 0 }, # door sensor
  { name: 'Dragino-LWL02',  number_of_buttons: 0 }, # water leak sensor
])

# Admins:
jh = User.find_by_email('jascha_haldemann@hotmail.com')
if jh.present?
  jh.update(is_admin: true)
else
  User.create(email: 'jascha_haldemann@hotmail.com', password: '123456', is_admin: true)
end
