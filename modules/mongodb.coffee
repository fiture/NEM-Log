mongo = require 'mongodb'
Db = mongo.Db
Server = mongo.Server
ObjectID = mongo.ObjectID
config = require('../config')

exports.db = new Db config.db.database, new Server(config.db.server,config.db.port),{}
exports.ObjectID = ObjectID
