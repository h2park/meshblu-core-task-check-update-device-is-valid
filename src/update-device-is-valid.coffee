_ = require 'lodash'

ERROR_NON_DOLLARED_KEYS = "Update query may not contain keys that do not start with '$'."
ERROR_NO_MODIFY_TOKEN   = "Update query may not modify the token key."
ERROR_NO_MODIFY_UUID    = "Update query may not modify the uuid key."

class UpdateDeviceIsValid
  do: (request, callback) =>
    data = JSON.parse(request.rawData)
    return @respondWithError ERROR_NO_MODIFY_TOKEN, callback if @containsKey data, 'token'
    return @respondWithError ERROR_NO_MODIFY_UUID, callback if @containsKey data, 'uuid'
    return @respondWithError ERROR_NON_DOLLARED_KEYS, callback unless @allKeysStartWithADollarSign data
    callback(null, metadata: code: 204)

  allKeysStartWithADollarSign: (data) =>
    _.all _.keys(data), @startsWithDollarSign

  containsKey: (data, key) =>
    values = _.values data
    _.any values, (value) => value[key]?

  respondWithError: (message, callback) =>
    callback null,
      metadata:
        code: 422
      data:
        error: message

  startsWithDollarSign: (key) =>
    _.startsWith key, '$'

module.exports = UpdateDeviceIsValid
