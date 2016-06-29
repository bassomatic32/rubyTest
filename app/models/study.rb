class Study < ActiveRecord::Base
	validates :weight, presence: true
	validates :height, presence: true
	validates :likes, inclusion: { in: %w(cats dogs) }, allow_nil: true

	# Guess is based on a height / weight ratio.  Threshold for choice is determined as the midpoint between the mean ratios
	# of both categories 'Cats' 'Dogs'

	# adjust the threshold based on new or updated records
	# Note that this is not really scalable for a large amount of data.  Would be better implemented with a record
	# containing the derivative data that could be updated on the fly.
	# The wrong way would be to keep the derivative data in resident memory, as this would not scale on multiple instances of server

	@@THRESHOLD = 0.5

	def self.adjustThreshold
		studies = Study.all
		# calc average of each 'likes' as a group
		groups = studies.group_by { |study| study.likes }
		groups.each do |k,v|
			groups[k] = v.inject(0.0) { |tot, study| tot+( study.height.to_f / study.weight.to_f ) } / v.length.to_f
		end
		# puts groups
		if groups['cats'] != nil and groups['dogs'] != nil
			@@THRESHOLD = ( groups['cats'] - groups['dogs']) / 2 + groups['dogs'] # get midpoint
		else
			@@THRESHOLD = 0.5 # default
		end
		puts "--- New Threshold #{@@THRESHOLD}"
	end

	# set the likes based on a guess, only if value isn't present, return true if auto-set
	def autoSetLikes
		if self.likes.nil? || self.likes.empty?
			self.likes = guess
			return true
		end
		return false
	end



	# Guess the 'like' for the current study
	def guess
		ratio = ( self.height.to_f / self.weight.to_f )
		puts "Ratio #{ratio}"
		if ratio > @@THRESHOLD
			return 'cats'
		end
		return 'dogs'
	end

end
