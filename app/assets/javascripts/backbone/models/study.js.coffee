class Survey.Models.Study extends Backbone.Model
  paramRoot: 'study'
  urlRoot: '/studies'

  defaults:
    weight: null
    height: null
    likes: null

class Survey.Collections.StudiesCollection extends Backbone.Collection
  model: Survey.Models.Study
  url: '/studies'
