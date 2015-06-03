models = require '../models'
models.sequelize
  .sync {force: true}
  .then (err) ->
    if err?
      console.log "An error occurred while creating the table", err
    else
      console.log "Initialized tables."