var posta = require('../controllers/post');
var MongoDB = require('../mongodb');
var articleProvider = new MongoDB('posts');
var userProvider = new MongoDB('user');

module.exports = function(app) { 
  // Routes
  app.get('/', function(req, res){
      articleProvider.findAll( function(error,posts){
          res.render('index', { 
            title: 'NEM-Log',
            posts: posts
          });
      })
  });

  app.get('/new-post/', function(req, res) {
      if(!req.session.user) {
        res.redirect('/login');
      }
      res.render('blog_new', {
        title: 'New post'
      });
  });
  
  app.post('/new-post/', function(req, res){
      if ( req.session.user ) {
        res.redirect('/login');
      }
      if ( req.body['title'] && req.body['content']) { 
        var tags = req.body['tags'].split(',');
        var postname = req.body['postname'] ? req.body['postname'] : req.body['title'];
        postname =postname.replace(/\s+|\s/g, '-').toLocaleLowerCase();
        articleProvider.save({
            title: req.body['title'],
            content: req.body['content'],
            tags:tags,
            postname:postname,
            date: new Date()
        }, function( error, docs) {
            res.redirect('/')
        });
      } else {
        res.redirect('/new-post/')
      }
  });
  // Show Post by Id
  app.get('/post/:id', function(req, res) {
    articleProvider.findById(req.params.id, function(error, post) {
      res.render('blog_show',{
        title: post.title,
        post: post
      });
    });
  });

  // Edit Post 
  app.get('/edit-post/:id', function(req, res) {
      if(!req.session.user) {
        res.redirect('/login');
      }
    articleProvider.findById(req.params.id, function(error, post) {
      res.render('blog_edit',{
        title: post.title,
        post: post,
        tags: post.tags.join(',')
      });
    });
  });

  // Edit Post Update
  app.post('/edit-post/:id/save', function(req, res) {
    var tags = req.body['tags'].split(',');
    articleProvider.update(req.params.id,{
      title: req.param('title'),
      content: req.param('content'),
      tags: tags
    },
    function(error, post){
      res.redirect('/')
    });
  });

  // Delete  post
  app.get('/delete-post/:id', function(req, res) {
      if(req.session.user) {
        articleProvider.delete(req.params.id, function(error, docs) {
          res.redirect('/')
        });
      } else { 
        res.redirect('/login');
      } 
  });

  app.get('/logout', function(req, res){
    req.session.user = null;
    res.redirect('/');
  });
  app.get('/login', function(req, res) {
    if ( req.session.user ) {
      res.redirect('/');
    }
    res.render('login', {
      title: 'Log In'
    });
  });
  app.post('/login', function(req, res) {
    if ( req.body['username'] && req.body['password'] ) {
      var md5 = require('crypto').createHash('md5');
      var password = md5.update(req.body['password']).digest('base64');
      userProvider.find({"username":req.body['username']}, function(error, result){
        if( result.password === password ){
          req.session.user = result.username;
          res.redirect('/');
        } else {
          res.redirect('/login');
        }
      });
    } else {
      res.redirect('/login');
    }
  });
  app.get('/signup', function(req, res) {
    res.render('signup', {
      title: 'Sign Up'
    });
  });
  app.post('/signup', function(req, res) {
    if (req.body['username'] && req.body['password'] && req.body['password-repeat'] && req.body['password'] === req.body['password-repeat'])
    { 
      var md5 = require('crypto').createHash('md5');
      var password = md5.update(req.body['password']).digest('base64');
      userProvider.find({"username":req.body['username']}, function(error, username){
        if(username) { 
          res.redirect('/signup');
        } else {
          userProvider.save({
              username: req.body['username'],
              password: password
          }, function( error, docs) {
            res.redirect('/login');
          });
        }
      });
    } else {
      res.redirect('/signup');
    }
  });

  app.get('/test/post/:id', posta.getPostById)
}
