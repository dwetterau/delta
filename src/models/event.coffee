module.exports = (sequelize, DataTypes) ->
  Event = sequelize.define "Event",
    name:
      type: DataTypes.STRING
      allowNull: false
    description:
      type: DataTypes.STRING
    date:
      type: DataTypes.DATE
    shortId:
      type: DataTypes.STRING
      allowNull: false
      unique: true
  , classMethods:
    associate: (models) ->
      Event.hasMany models.Participant

  return Event
