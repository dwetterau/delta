React = require 'react'
Router = require 'react-router'
FormPage = require './form_page'
{userCreateRequest} = require '../../actions'
Notifier = require '../../utils/notifier'

CreateUser = React.createClass

  mixins: [Router.Navigation]

  _onSubmit: (fields) ->
    userCreateRequest(fields).then (response) =>
      @transitionTo response.redirect_url
      Notifier.info 'Account created!'

    .catch Notifier.error

  render: () ->
    React.createElement FormPage,
      pageHeader: 'Create an account'
      action: '/user/create'
      inputs: [
        {
          type: "email"
          id: "email"
          floatingLabelText: "Email"
        }, {
          type: "password"
          id: "password"
          floatingLabelText: "Password"
        }, {
          type: "password"
          id: "confirm_password"
          floatingLabelText: "Confirm Password"
        }
      ]
      submitLabel: 'Create account'
      onSubmit: @_onSubmit
      signInWithSlack: true

module.exports = CreateUser
