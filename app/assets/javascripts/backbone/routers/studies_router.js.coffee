class Survey.Routers.StudiesRouter extends Backbone.Router

  initialize: (options) ->
    @studies = new Survey.Collections.StudiesCollection()
    @studies.reset options?.studies

  routes:
    ".*"        : "guess"


  guess: ->
    @view = new Survey.Views.Studies.GuessView(collection: @studies)
