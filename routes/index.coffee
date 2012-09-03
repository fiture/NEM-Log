post = require('../controllers/post')

module.exports = (app) ->
  app.get '/', post.getPosts
  #app.get '/post/id/:id', post.getPostById
  app.get '/post/:name', post.getPost
  app.get '/new-post', post.showNewPost
  app.post '/new-post', post.newPost
  app.get '/edit-post/:id', post.showEditPost
  app.post '/edit-post/:id/save', post.editPost
