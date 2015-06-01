passport = require 'passport'

exports.get_connect_slack = (req, res, next) ->
  passport.authenticate('slack')(req, res, next)

exports.get_connect_slack_callback = (req, res) ->
  passport.authenticate('slack', failureRedirect: '/user/login')(req, res, ->
    res.redirect '/'
  )
