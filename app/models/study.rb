class Study < ActiveRecord::Base
	validates :weight, presence: true
	validates :height, presence: true
	validates :likes, inclusion: { in: %w(cats dogs) }, allow_nil: true
end
