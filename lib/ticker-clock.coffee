{CompositeDisposable} = require 'atom'
TickerClockView = require './ticker-view'

module.exports = TickerClock =
  config:
    activateOnStart:
      type: 'string'
      default: 'Remember last setting'
      enum: ['Remember last setting', 'Show on start', 'Don\'t show on start']

  active: false

  activate: (state) ->
    @state = state

    @subscriptions = new CompositeDisposable
    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'ticker-clock:toggle': => @toggle()

    @tickerClockView = new TickerClockView()
    @tickerClockView.init()

  deactivate: ->
    console.log 'Clock was deactivated'
    @subscriptions.dispose()
    @tickerClockView.destroy()
    @statusBarTile?.destroy()

  serialize:->
    {
      activateOnStart: atom.config.get('ticker-clock.activateOnStart'),
      active: @active
    }

  toggle: (active = undefined) ->
    active = ! !!@active if !active?

    if active
      console.log 'Clock was toggled on'
      @tickerClockView.activate()
      @statusBarTile = @statusBar.addRightTile
        item: @tickerClockView, priority: -1
    else
      @statusBarTile?.destroy()
      @tickerClockView?.deactivate()

    @active = active

  consumeStatusBar: (statusBar) ->
    @statusBar = statusBar
    # auto activate as soon as status bar activates based on configuration
    @activateOnStart(@state)

  activateOnStart: (state) ->
    switch state.activateOnStart
      when 'Remember last setting' then @toggle state.active
      when 'Show on start' then @toggle true
      else @toggle false
