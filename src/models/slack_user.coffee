module.exports = (sequelize, DataTypes) ->
  SlackUser = sequelize.define "SlackUser",
    username:
      type: DataTypes.STRING
      allowNull: false
    firstName:
      type: DataTypes.STRING
    lastName:
      type: DataTypes.STRING
    realName:
      type: DataTypes.STRING
    image24:
      type: DataTypes.STRING
      allowNull: false
    image32:
      type: DataTypes.STRING
      allowNull: false
    image48:
      type: DataTypes.STRING
      allowNull: false
    image72:
      type: DataTypes.STRING
      allowNull: false
    image192:
      type: DataTypes.STRING
      allowNull: false
    teamId:
      type: DataTypes.STRING
      allowNull: false
    slackUserId:
      type: DataTypes.STRING
      unique: true
      allowNull: false
    token:
      type: DataTypes.STRING
      allowNull: false
  , classMethods:
    associate: (models) ->
      SlackUser.belongsTo(models.User)
      SlackUser.hasMany(models.Participant)

  return SlackUser
