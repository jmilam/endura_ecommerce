class SalesRep < ApplicationRecord
	belongs_to :tsm
	has_many :customers

	def self.get_name(rep_id)
		SalesRep.find_by_id(rep_id).name
	end
end
