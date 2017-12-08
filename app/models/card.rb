class Card < ActiveRecord::Base
	validates_presence_of :name
	validates_presence_of :tier
end