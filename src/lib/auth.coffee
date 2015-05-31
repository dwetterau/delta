passport = require 'passport'
LocalStrategy = require 'passport-local'
SlackStrategy = require('passport-slack').Strategy
Slack = require 'slack-node'

{config} = require('./common')
{User, SlackUser} = require '../models'

passport.serializeUser (user, done) ->
  done null, user.id

passport.deserializeUser (id, done) ->
  User.find(id).then (user) ->
    done null, user
  .catch (err) ->
    done err

passport.use new LocalStrategy {usernameField: 'email'}, (email, password, done) ->
  User.find({where: {email}}).then (user) ->
    if not user
      return done null, false, {message: 'Invalid username or password.'}
    user.compare_password password, (err, is_match) ->
      if is_match
        return done null, user
      else
        return done null, false, {message: 'Invalid username or password.'}

passport.use new SlackStrategy({
  clientID: config.get('slack-api-id')
  clientSecret: config.get('slack-api-secret')
}, (accessToken, _, profile, done) ->
  userId = profile._json.user_id
  slack = new Slack accessToken
  slack.api 'users.info', {user: userId}, (response) ->
    console.log response
    if not response.ok
      done new Error('Unable to retrieve user info.')

    email = response.user.email
    userToReturn = null
    User.find({where: {email}}).then (user) ->
      if user
        # This must be an existing user, be sure to update their slack user info
        # TODO: update slack user info
        done null, user
      else
        return User.create({email})
    .then (user) ->
      userToReturn = user
      return SlackUser.create
        url: profile._json.url
        team: profile._json.team
        username: profile._json.user
        firstName: response.user.profile.first_name
        lastName: response.user.profile.last_name
        realName: response.user.profile.real_name_normalized
        image24: response.user.profile.image_24
        image32: response.user.profile.image_32
        image48: response.user.profile.image_48
        image72: response.user.profile.image_72
        image192: response.user.profile.image_192
        teamId: profile._json.team_id
        slackUserId: profile._json.user_id
        token: accessToken
        UserId: userToReturn
    .then ->
      done null, userToReturn
    .catch (error) ->
      done error
)

exports.isAuthenticated = (req, res, next) ->
  if req.isAuthenticated()
    return next()
  res.redirect '/user/login?r=' + encodeURIComponent(req.url)
