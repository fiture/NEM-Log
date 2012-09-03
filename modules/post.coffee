mongodb = require('./mongodb').db
ObjectID = require('./mongodb').ObjectID

class Post
  constructor: ()->
    @coll = 'posts'
  newPost: (post, callback) ->
    mongodb.open (err, db) =>
      if err
        return callback err
      db.collection @coll, (err, collection)->
        if err
          mongodb.close()
          return callback err
        collection.insert post, safe:true, (err, post) ->
          mongodb.close()
          callback err,post

  update: (post_id, data, callback) ->
    mongodb.open (err, db) =>
      if err
        return callback err
      db.collection @coll, (err, collection) ->
        if err
          mongodb.close()
          return callback err
        collection.update {'_id': new ObjectID post_id}, {'$set':data}, (err, post)->
          mongodb.close()
          callback(err, post)

  getById: (post_id, callback) ->
    mongodb.open (err, db) =>
      if err
        return callback err
      db.collection @coll, (err, collection) ->
        if err
          mongodb.close()
          return callback err
        collection.findOne {'_id': new ObjectID post_id}, (err, post)->
          mongodb.close()
          callback(err, post)

  getPost: (obj, callback) ->
    mongodb.open (err, db) =>
      if err
        return callback err
      db.collection @coll, (err, collection) ->
        if err
          mongodb.close()
          return callback err
        collection.findOne obj, (err, post)->
          mongodb.close()
          callback(err, post)

  getPosts: (callback) ->
    mongodb.open (err, db) =>
      if err
        return callback err
      db.collection @coll, (err, collection) ->
        if err
          mongodb.close()
          return callback err
        collection.find().toArray (err, post)->
          mongodb.close()
          callback(err, post)

module.exports = Post
