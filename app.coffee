express = require 'express'

app = module.exports = express.createServer()

app.configure ->
  app.use express.static(__dirname + "/static")

app.configure "development", ->
  app.use express.errorHandler
    dumpExceptions: true
    showStack: true

app.configure "production", ->
  app.use express.errorHandler()

port = 80
app.listen process.env.PORT || port

