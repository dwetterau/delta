express = require 'express'
router = express.Router()
passport_config  = require('../lib/auth')

event_controller = require '../controllers/event_controller'
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

# Slack auth routes
router.get '/api/auth/slack', slack_controller.get_connect_slack
router.get '/api/auth/slack/callback', slack_controller.get_connect_slack_callback

# Event api routes
router.get '/api/event/:eventId', event_controller.get_event
router.post '/api/event/create', event_controller.post_create_event

router.REGISTERED_ROUTES = {
  '/user/create', '/user/login', '/user/password', '/api/auth/slack', '/api/auth/slack/callback'
}

module.exports = router
