# Chatbot Builder

A web platform for chatbot creation. Users can script dialogues and train their chatbots to have conversations. Try it out: https://chatbot-builder.herokuapp.com/ (it takes time for the heroku deployed backend to wake up after awhile, so your first login/message may take unnervingly long.)

Ruby on Rails backend API implements recognition logic and basic machine learning classification to help bot “understand”. Utilizes machine learning and fuzzy string matching libraries for Ruby. 

Frontend sends user's scripts and choices to Rails Backend. After chatbot is created and lives on the site, each message sent to it is a post request to the backend. Backend is responsible for trying to find the right response and sending it back to the frontend/user. Frontend repo here: https://github.com/sxkosone/bot-maker-frontend

After signing up, users’ bots are hosted on the site and they receive a shareable link to their bot. Here are some sample bots:

* [Catbot](https://chatbot-builder.herokuapp.com/bots/cjly1fhsk00003h5mwkbaq6i2)
* [Weather Heather] (https://chatbot-builder.herokuapp.com/bots/cjlz6x4x200003h5mslk7jawf)

## Read more about the process
* [Coding a chatbot builder platform part 1 - how to make a dumb chatbot](https://medium.com/@susannakosonen/coding-a-chatbot-builder-platform-part-1-how-to-make-a-dumb-chatbot-605be5e84dca)

