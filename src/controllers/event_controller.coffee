shortid = require 'shortid'

{Event, Participant, SlackUser} = require '../models'

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

exports.post_create_event = (req, res) ->
  fail = (error) ->
    console.log "post_create_event error", error
    return res.send {ok: false, error: errors}

  req.assert('name', 'Must provide event name.').notEmpty()
  errors = req.validationErrors()
  if errors?
    fail errors

  event = {
    name: req.param 'name'
    description: req.param 'description' || null
    date: req.param 'date' || null
    shortId: shortid.generate()
  }
  Event.create(event).then (event) ->
    res.send {ok: true, body: event}
  .catch fail

exports.put_add_participant = (req, res) ->

