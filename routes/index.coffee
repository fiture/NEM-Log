p = require('../controllers/post')

module.exports = (app) ->
  app.get '/', p.getIndex
  #app.get '/post/id/:id', p.getPostById
  app.get '/post/:name', p.getPost
  app.get '/new-post', p.newPost
  app.post '/new-post', p.newPost
  app.get '/edit-post/:id', p.editPost
  app.post '/edit-post/:id', p.editPost
  app.get '/delete-post/:id', p.deletePost
