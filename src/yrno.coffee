# Description:
#   Rodent Motivation
#
#   Set the environment variable HUBOT_SHIP_EXTRA_SQUIRRELS (to anything)
#   for additional motivation
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_SHIP_EXTRA_SQUIRRELS
#
# Commands:
#   ship it - Display a motivation squirrel
#
# Author:
#   maddox

geocoder = require 'geocoder'
base_url = 'http://www.yr.no/place/' # Norway/Troms/M%C3%A5lselv/Bardufoss/

module.exports = (robot) ->

  robot.hear /clouds (?:in|at)? (.+)/i, (msg) ->
    location = msg.match[1]
    geocoder.geocode location, (err, data) ->
      if err
        console.error err
        msg.send "Can not find location: #{location}"
        return
      place_url = data.results[0].address_components
        .slice(0, 4) # cheat!
        .reverse()
        .map (component) ->
          component.long_name
        .map encodeURIComponent
        .join '/'
      robot.http("#{base_url}#{place_url}/hour_by_hour_detailed.html")
        .get() (err, res, body) ->
          if err
            msg.send "Encountered an error :( #{err}"
            return
          # /low clouds\: \d{1,3} %/g
          msg.send body
