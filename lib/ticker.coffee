{CompositeDisposable} = require 'atom'

module.exports = Ticker =
  active: false

  activate: (state) ->
    @subscriptions = new CompositeDisposable
    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'ticker:toggle': => @toggle()

    console.log 'Clock was activated'
  deactivate: ->
    console.log 'Clock was deactivated'

  toggle: ->
    console.log 'Clock was toggled on' if @active
    console.log 'Clock was toggled of' if !@active

    @active = ! !!@active
