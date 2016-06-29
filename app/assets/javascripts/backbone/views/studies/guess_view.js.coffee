Survey.Views.Studies ||= {}

class Survey.Views.Studies.GuessView extends Backbone.View

	el: '#guessBody'

	events:
		'change #weight': 'digest'
		'change #height' : 'digest'
		'click #Yes' : 'confirm'
		'click #No' : 'confirm'
		'click #clear' : 'clear'

	messageMap:
		'cats' : "Do you like Cats?"
		'dogs' : "Do you like Dogs?"

	initialize: ->
		@collection.bind('reset', @addAll)
		@clear()
		console.log "Alive"

	digest: ->
		console.log 'Digesting inputs'
		options =
			weight : parseInt @$('#weight').val()
			height : parseInt @$('#height').val()

		return if isNaN(options.weight) or isNaN(options.height)

		# other than that, we're not going to bother validating these values further
		@study = new Survey.Models.Study(options)
		console.log "Saving"
		@study.save {},
			success: =>
				# show the guess
				if @study.get('likes')?
					msg = @messageMap[@study.get('likes')]
					@$('#guess').text msg
					@$('#guess').show 400
					@$('#confirm').show 400

	confirm: (e) ->
		sel = $(e.currentTarget).attr('id')
		if sel is 'Yes'
			@$('#correct').show()
		else
			@$('#incorrect').show()
			# reverse likes
			likes = 'cats'
			likes = 'dogs' if @study.get('likes') is 'cats'
			@study.set 'likes',likes
		@study.save() # now save with the likes intact

	clear: ->
		@$('#guess').hide()
		@$('#confirm').hide()
		@$('#correct').hide()
		@$('#incorrect').hide()
		@$('#weight').val ''
		@$('#height').val ''
