express = require 'express'
http    = require 'http'
path    = require 'path'
routes  = require './routes'
config  = require './config'
app = express()
app.configure ->
  app.set 'port', process.env.PORT or config.app_port
  app.set 'views', __dirname + '/views'
  app.set 'view engine', 'jade'
  #app.use(express.logger('dev'))
  app.use express.cookieParser()
  app.use express.session({secret: 'nemlog'})
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use express.static(path.join(__dirname, 'public'))
  return

app.configure 'development', ->
  app.use express.errorHandler({ dumpExceptions: true, showStack: true })

app.configure 'production', ->
  app.use express.errorHandler()

routes app

http.createServer(app).listen app.get('port'), ->
  console.log 'Express server listening on port ' + app.get('port')
