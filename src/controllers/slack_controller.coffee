passport = require 'passport'

exports.get_connect_slack = (req, res, next) ->
  passport.authorize('slack')(req, res, next)

exports.get_connect_slack_callback = (req, res) ->
  passport.authorize('slack', failureRedirect: '/user/login')(req, res, ->
    # Successfully logged in with slack
    console.log "end of authorize...", req.user
    res.redirect '/'
  )
