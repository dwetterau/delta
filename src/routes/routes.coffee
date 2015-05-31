express = require 'express'
router = express.Router()
passport_config  = require('../lib/auth')

index_controller = require '../controllers/index_controller'
slack_controller = require '../controllers/slack_controller'
user_controller = require '../controllers/user_controller'

# GET home page
router.get '/', index_controller.get_index

# User routes
router.post '/user/create', user_controller.post_user_create
router.post '/user/login', user_controller.post_user_login
router.get '/user/logout', user_controller.get_user_logout
router.post '/user/password', passport_config.isAuthenticated, user_controller.post_change_password

router.get '/api/auth/slack', slack_controller.get_connect_slack
router.get '/api/auth/slack/callback', slack_controller.get_connect_slack_callback

router.REGISTERED_ROUTES = {
  '/user/create', '/user/login', '/user/password', '/api/auth/slack', '/api/auth/slack/callback'
}

module.exports = router
