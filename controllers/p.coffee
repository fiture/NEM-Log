modules = require '../modules'
Post = modules.Post

exports.newPost = (req, res, next)->
  method = req.method.toLowerCase()
  if method is 'get'
    res.render 'blog_new', {title:'New Post'}

  if method is 'post'
    title = req.body.title
    content = req.body.content
    if not title or not content
      res.render 'blog_new', {title:'New Post', error:'标题和内容不能为空！'}

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
    console.log post
    post.save (err)->
      if err
        next(err)
      else
        res.redirect '/'
