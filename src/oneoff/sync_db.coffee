models = require '../models'
models.sequelize
  .sync()
  .then (err) ->
    if err?
      console.log "An error occurred while creating the table", err
    else
      console.log "Initialized tables."