_ = require 'lodash'

ERROR_NON_AUTHORIZED_KEYS = "Update query may only contain key authorized keys."
ERROR_NO_MODIFY_TOKEN     = "Update query may not modify the token key."
ERROR_NO_MODIFY_UUID      = "Update query may not modify the uuid key."
ERROR_NO_NULL_VALUES      = "Update query may contain null value for a key that starts with '$'."
AUTHORIZED_KEYS           = [
  '$inc'
  '$mult'
  '$set'
  '$unset'
  '$min'
  '$max'
  '$currentDate'
  '$addToSet'
  '$pop'
  '$pullAll'
  '$pull'
  '$pushAll'
  '$push'
  '$bit'
]

class UpdateDeviceIsValid
  do: (request, callback) =>
    data = JSON.parse(request.rawData)
    return @respondWithError ERROR_NO_NULL_VALUES, callback if @containsNull data
    return @respondWithError ERROR_NO_MODIFY_TOKEN, callback if @containsKey data, 'token'
    return @respondWithError ERROR_NO_MODIFY_UUID, callback if @containsKey data, 'uuid'
    return @respondWithError ERROR_NON_AUTHORIZED_KEYS, callback unless @allKeysAuthorized data
    callback(null, metadata: code: 204)

  allKeysAuthorized: (data) =>
    _.all _.keys(data), @authorizeKey

  containsKey: (data, key) =>
    values = _.values data
    _.any values, (value) => _.get(value, key)?

  containsNull: (data) =>
    _.any data, (value, key) => !value?

  respondWithError: (message, callback) =>
    callback null,
      metadata:
        code: 422
      data:
        error: message

  authorizeKey: (key) =>
    _.includes AUTHORIZED_KEYS, key

module.exports = UpdateDeviceIsValid
