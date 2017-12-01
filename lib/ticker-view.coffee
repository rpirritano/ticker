class TickerClockView extends HTMLElement
  init: ->
    @classList.add('ticker-clock', 'inline-block', 'icon-clock')
    @activate()

  activate: ->
    @intervalId = setInterval @updateClock.bind(@), 100

  deactivate: ->
    clearInterval @intervalId

  getTime: ->
    date = new Date

    seconds = date.getSeconds()
    minutes = date.getMinutes()
    hour = date.getHours()

    minutes = '0' + minutes if minutes < 10
    seconds = '0' + seconds if seconds < 10

    "#{hour}:#{minutes}:#{seconds}"

  updateClock: ->
    @textContent = @getTime()

module.exports = document.registerElement('ticker-clock', prototype: TickerClockView.prototype, extends: 'div')
