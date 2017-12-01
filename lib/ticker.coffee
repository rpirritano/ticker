{CompositeDisposable} = require 'atom'
TickerView = require './ticker-view'

#activateOnStart default value is "Remember last setting"
#if it is set to "Show on start" clock will always be displayed on start
#if it is set to "Don't show on start" clock will never be displayed on start

module.exports = Ticker =
  config:
    activeOnStart:
      type: 'string'
      default: 'Remember last setting'
      enum: ['Remember last setting', 'Show on start', 'Dont\'t show on start']

  active: false

  activate: (state) ->
    #console.log 'Clock was activated'
    @state = state

    @subscriptions = new CompositeDisposable
    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'ticker:toggle': => @toggle()

    @tickerview = new TickerView()
    @tickerview.init()

  deactivate: ->
    console.log 'Clock was deactivated'
    @subscriptions.dispose()
    @tickerview.destroy()
    @statusBarTile?.destroy()

  serialize: ->
    {
      activeOnStart: atom.config.get('ticker.activateOnStart'),
      active = @active
    }

  toggle: (active = undefined) ->
    active = ! !!@active if !active?

    if active
      console.log 'Clock as toggled on'
      @tickerView.active()
      @statusBarTile = @statusBar.addRightTile
        item: @tickerView, priority: -1
      else
        @statusBarTile?.destroy()
        @tickerView?.deactivate()

    @active = active

  consumeStatusBar: (statusBar) ->
    @statusBar = statusBar
    #auto activate as soon as status bar activates based on config
    @activeOnStart(@state)

  activeOnStart: (state) ->
      switch state.activateOnStart
        when 'Remember last setting' then @toggle state.active
        when 'Show on start' then @toggle true
      else @toggle false
