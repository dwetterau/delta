module.exports = (sequelize, DataTypes) ->
  Participant = sequelize.define "Participant",
    status:
      type: DataTypes.STRING
    arrivalTime:
      type: DataTypes.STRING
    location:
      type: DataTypes.STRING
  , classMethods:
    associate: (models) ->
      Participant.belongsTo(models.SlackUser)
      Participant.belongsTo(models.Event)

  return Participant
