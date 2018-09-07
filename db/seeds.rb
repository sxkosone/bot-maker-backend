# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.destroy_all
Bot.destroy_all
Trigger.destroy_all
Response.destroy_all

lisa = User.create(username: "lisa", password: "password")
lisabot = Bot.create(name: "lisabot", user: lisa, url_id: "12345", description: "A nice chatbot", include_default_scripts: true)
hello = Trigger.create(bot: lisabot, text: "Hello")
bye = Trigger.create(bot: lisabot, text: "Bye")
bot_hello = Response.create(trigger: hello, text: "Hello to you, Human, I'm lisabot!")
bot_bye = Response.create(trigger: bye, text: "So long")

homer = User.create(username: "homer", password: "password")
homerbot = Bot.create(name: "homerbot", user: homer, url_id: "1122", description: "An okay bot", include_default_scripts: true)
hello2 = Trigger.create(bot: homerbot, text: "Oh hi")
bye2 = Trigger.create(bot: homerbot, text: "See ya later")
bot_hello2 = Response.create(trigger: hello2, text: "Well hello there")
bot_bye2 = Response.create(trigger: bye2, text: "D'oh!")