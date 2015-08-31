chai = require 'chai'
sinon = require 'sinon'
chai.use require 'sinon-chai'

expect = chai.expect

describe 'yrno', ->
  beforeEach ->
    @robot =
      respond: sinon.spy()

    require('../src/yrno')(@robot)

  it 'registers a respond listener', ->
    expect(@robot.respond).to.have.been.calledWith(/clouds (?:in|at)? (.+)/i)
