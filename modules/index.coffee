mongoose = require 'mongoose'
config = require '../config'
db = mongoose.createConnection config.db.server, config.db.database

postSchema = new mongoose.Schema
  title : String
  content : String
  postname : String
  author : String
  category : {type: String, default: 'default'}
  tags : [String]
  date : { type: Date, default: Date.now }
  update : { type: Date, default: Date.now }

userSchema = new mongoose.Schema
  email : String
  password : String
  nikname : String
  date : { type: Date, default: Date.now }

exports.Post = db.model 'posts', postSchema
exports.User = db.model 'user', userSchema
