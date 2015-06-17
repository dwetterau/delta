shortid = require 'shortid'

{Event, Participant, SlackUser} = require '../models'
{constants} = require '../lib/common'

exports.get_event = (req, res) ->
  fail = (error) ->
    console.log "get_event error", error
    return res.send {ok: false, error: error}

  req.assert('eventId', 'Must provide event id.').notEmpty()
  errors = req.validationErrors()
  if errors?
    fail errors

  Event.find({where: {shortId: req.param('eventId')}, include: [Participant]}).then (event) ->
    if not event
      return fail 'Event not found.'

    res.send {ok: true, body: event}
  .catch fail

_add_participants_bulk = (eventId, slackUserIds, status) ->
  participants = []
  for userId in slackUserIds
    participants.push {
      SlackUserId: userId
      EventId: eventId
      status
    }
  Participant.bulkCreate participants

exports.post_create_event = (req, res) ->
  fail = (error) ->
    console.log "post_create_event error", error
    return res.send {ok: false, error: errors}

  req.assert('name', 'Must provide event name.').notEmpty()
  req.assert('creatorSlackId', 'Must provide creator slack id.').notEmpty()
  errors = req.validationErrors()
  if errors?
    fail errors

  event = {
    name: req.param 'name'
    description: req.param 'description' || null
    date: req.param 'date' || null
    shortId: shortid.generate()
  }
  user = null
  event = null
  SlackUser.find({where: {SlackUserId: req.param 'creatorSlackId'}}).then (slackUser) ->
    if not slackUser?
      return fail 'Could not find slack user.'
    user = slackUser
    return Event.create(event)
  .then (newEvent) ->
    event = newEvent
    return _add_participants_bulk event.id, [slackUser.id], constants.EVENT_STATUS_ATTENDING
  .then (newParticipants)
    res.send {ok: true, body: event}
  .catch fail

exports.put_add_participant = (req, res) ->

