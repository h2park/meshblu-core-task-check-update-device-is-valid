UpdateDeviceIsValid = require '../'

describe 'UpdateDeviceIsValid', ->
  describe '->do', ->
    describe 'when called with a valid request', ->
      beforeEach (done) ->

        request =
          rawData: '{"$set": {"pigeonCount": 0}}'

        @sut = new UpdateDeviceIsValid
        @sut.do request, (error, @response) => done error

      it 'should respond with a 204', ->
        expect(@response).to.containSubset
          metadata:
            code: 204

    describe 'when called with another valid request', ->
      beforeEach (done) ->

        request =
          rawData: '{"$inc": {"upset": 0}}'

        @sut = new UpdateDeviceIsValid
        @sut.do request, (error, @response) => done error

      it 'should respond with a 204', ->
        expect(@response).to.containSubset
          metadata:
            code: 204

    describe 'when called with an invalid request with non dollared keys', ->
      beforeEach (done) ->

        request =
          rawData: '{"upset": {"pigeons": 0}}'

        @sut = new UpdateDeviceIsValid
        @sut.do request, (error, @response) => done error

      it 'should respond with a 422', ->
        expect(@response).to.containSubset
          metadata:
            code: 422
          data:
            error: "Update query may only contain authorized keys."

    describe 'when called with an invalid request with some non dollared keys', ->
      beforeEach (done) ->

        request =
          rawData: '{"upset": {"pigeons": 0}, "$set": {"neurochemical": "imbalance"}}'

        @sut = new UpdateDeviceIsValid
        @sut.do request, (error, @response) => done error

      it 'should respond with a 422', ->
        expect(@response).to.containSubset
          metadata:
            code: 422
          data:
            error: "Update query may only contain authorized keys."

    describe 'when called with an invalid request that tries to $set uuid', ->
      beforeEach (done) ->

        request =
          rawData: '{"$set": {"uuid": "popped"}}'

        @sut = new UpdateDeviceIsValid
        @sut.do request, (error, @response) => done error

      it 'should respond with a 422', ->
        expect(@response).to.containSubset
          metadata:
            code: 422
          data:
            error: "Update query may not modify the uuid key."

    describe 'when called with an invalid request that tries to $rename uuid', ->
      beforeEach (done) ->

        request =
          rawData: '{"$rename": {"uuid":"angry"}}'

        @sut = new UpdateDeviceIsValid
        @sut.do request, (error, @response) => done error

      it 'should respond with a 422', ->
        expect(@response).to.containSubset
          metadata:
            code: 422
          data:
            error: "Update query may not modify the uuid key."

    describe 'when called with an invalid request that tries to $set token', ->
      beforeEach (done) ->

        request =
          rawData: '{"$set": {"token":"angry"}}'

        @sut = new UpdateDeviceIsValid
        @sut.do request, (error, @response) => done error

      it 'should respond with a 422', ->
        expect(@response).to.containSubset
          metadata:
            code: 422

    describe 'when called with an invalid request that tries to $rename something to uuid', ->
      beforeEach (done) ->

        request =
          rawData: '{"$rename": {"master-of-the-universe":"uuid"}}'

        @sut = new UpdateDeviceIsValid
        @sut.do request, (error, @response) => done error

      it 'should respond with a 422', ->
        expect(@response).to.containSubset
          metadata:
            code: 422

    describe 'when called with request containing null', ->
      beforeEach (done) ->

        request =
          rawData: '{"$set": null}'

        @sut = new UpdateDeviceIsValid
        @sut.do request, (error, @response) => done error

      it 'should respond with a 422', ->
        expect(@response).to.containSubset
          metadata:
            code: 422
