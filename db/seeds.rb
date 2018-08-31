# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.destroy_all
Trigger.destroy_all
Response.destroy_all

lisa = User.create(username: "lisa", password: "password", bot_name: "lisabot", bot_url_id: "12345")
hello = Trigger.create(user: lisa, text: "Hello")
bye = Trigger.create(user: lisa, text: "Bye")
bot_hello = Response.create(trigger: hello, text: "Hello to you, Human")
bot_bye = Response.create(trigger: bye, text: "So long")

homer = User.create(username: "homer", password: "password", bot_name: "homerbot", bot_url_id: "1122")
hello2 = Trigger.create(user: homer, text: "Oh hi")
bye2 = Trigger.create(user: homer, text: "See ya later")
bot_hello2 = Response.create(trigger: hello2, text: "Well hello there")
bot_bye2 = Response.create(trigger: bye2, text: "D'oh!")