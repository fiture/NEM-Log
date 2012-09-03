mongodb = require('./mongodb').db
ObjectId = require('./mongodb').ObjectId

class User
  constructor: (@username, @password, @nikname)->
    @collection = 'user'
  newUser: (callback) ->
    user =
      username: @username
      password: @password
      nikname: @nikname
      date: new Date()
    mongodb.open (err, db) ->
      if err
        return callback err
      db.collection @collection, (err, collection)->
        if err
          mongodb.close()
          return callback err
        collection.insert user, safe:true, (err, user) ->
          mongodb.close()
          callback err,user

  update: (user_id, data, callback) ->
    db.collection @collection, (err, collection) ->
      if err
        mongodb.close()
        return callback err
      collection.update {_id: new ObjectId user_id}, {'$set':data}, (err, user_id)->
        mongodb.close()
        callback(err, post)

module.exports = Post
