{CompositeDisposable} = require 'atom'
TickerView = require './ticker-view'

module.exports = Ticker =
  active: false

  activate: (state) ->
    console.log 'Clock was activated'

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

  toggle: ->
    if @activate
      @statusBarTile.destroy()
      @tickerView.deactivate()
    else
      console.log 'Clock as toggled on'
      @tickerView.active()
      @statusBarTile = @statusBar.addRightTile
        item: @tickerView, priority: -1

    @active = ! !!@active

  consumeStatusBar: (statusBar) ->
    @statusBar = statusBar
    #auto activate as soon as status bar activates
    @toggle()
