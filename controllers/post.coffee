Post = require '../modules/post'
post = new Post()

getPostById = (req,res)->
    post.getById req.params.id, (err, post)->
      if err
        return res.send err
      res.render 'blog_show',
      {
        title: post.title
        post: post
      }

getPost = (req,res)->
    post.getPost {'postname': req.params.name}, (err, post)->
      if err
        return res.send err
      res.render 'blog_show',
      {
        title: post.title
        post: post
      }

getPosts = (req,res)->
    post.getPosts (err, result)->
      res.render 'index',
      {
        title: 'NEM-Log'
        posts: result
      }
showNewPost = (req,res)->
    res.render 'blog_new',
    {
      title: 'New Post'
    }

newPost = (req,res)->
    tags = req.body['tags'].split(',')
    if req.body['postname']
      postname = req.body['postname']
    else
      postname = req.body['title']
    postname =postname.replace(/\s+|\s/g, '-').toLocaleLowerCase()

    newpost =
      title: req.body['title']
      content: req.body['content']
      postname: postname
      tags: tags
      date: new Date()
    post.newPost newpost ,(err, result)->
      res.redirect('/')

showEditPost = (req,res)->
  post.getById req.params.id, (err, post)->
    if err
      return res.send err
    res.render 'blog_edit',
    {
      title: post.title,
      post: post,
      tags: post.tags.join(',')
    }

editPost = (req,res)->
  tags = req.body['tags'].split(',')
  if req.body['postname']
    postname = req.body['postname']
  else
    postname = req.body['title']
  postname =postname.replace(/\s+|\s/g, '-').toLocaleLowerCase()

  data =
    title: req.body['title']
    content: req.body['content']
    postname: postname
    tags: tags
  post.update req.params.id, data, (err, post)->
   res.redirect('/')



exports.getPosts = getPosts
exports.getPost = getPost
exports.showNewPost = showNewPost
exports.newPost = newPost
exports.showEditPost = showEditPost
exports.editPost = editPost
