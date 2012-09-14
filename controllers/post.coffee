modules = require '../modules'
Post = modules.Post

#New post
exports.newPost = (req, res, next) ->
  method = req.method.toLowerCase()
  if method is 'get'
    res.render 'blog_new', {title:'New Post'}

  if method is 'post'
    title = req.body.title
    content = req.body.content
    if not title or not content
      res.render 'blog_new', {title:'New Post', error:'标题和内容不能为空！'}
      return

    tags = if req.body.tags then req.body.tags.split(',') else []
    category = if req.body.category then req.body.category else 'default'
    postname = if req.body.postname then req.body.postname else title
    postname = postname.replace(/\s+|\s/g, '-').toLocaleLowerCase()

    post = new Post({
      title: title
      content: content
      postname: postname
      category: category
      tags: tags
      date: new Date()
      update: new Date()
    })
    post.save (err)->
      if err
        next(err)
      else
        res.redirect '/'

#Get post by id
exports.getPostById = (req, res) ->
  query = Post.findById(req.params.id)
  query.exec (err, post) ->
    if err
      handleError err
    res.render 'blog_show',
    {
      title: post.title
      post: post
    }
#Get post by postname
exports.getPost = (req, res) ->
  query = Post.findOne({'postname':req.params.name})
  query.exec (err, post) ->
    if err
      handleError err
    res.render 'blog_show',
    {
      title: post.title
      post: post
    }
exports.getIndex = (req, res) ->
  query = Post.find().limit(10).sort('-date').exec (err, posts) -> 
    res.render 'index',
    {
      title: 'NEM-Log'
      posts: posts
    }
exports.editPost = (req, res) ->
  method = req.method.toLowerCase()
  if method is 'get'
    Post.findById(req.params.id).exec (err, post)->
      if err
        return res.send err
      res.render 'blog_edit',
      {
        title: post.title,
        post: post,
        tags: post.tags.join(',')
      }
  if method is 'post'
    title = req.body.title
    content = req.body.content
    tags = if req.body.tags then req.body.tags.split(',') else []
    category = if req.body.category then req.body.category else 'default'
    postname = if req.body.postname then req.body.postname else title
    postname = postname.replace(/\s+|\s/g, '-').toLocaleLowerCase()

    Post.findById req.params.id, (err, post)->
      post.title = title
      post.content = content
      post.tags = tags
      post.category = category
      post.postname = postname
      post.update = new Date()

      post.save (err)->
        if err
          next(err)
        else
          res.redirect '/'

exports.deletePost = (req, res) ->
  Post.findById(req.params.id).remove (err) ->
    res.redirect '/'
