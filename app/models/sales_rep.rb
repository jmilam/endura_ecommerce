class SalesRep < ApplicationRecord
	belongs_to :tsm
	has_many :customers

	def self.get_name(rep_id)
		rep = SalesRep.find_by_id(rep_id)
		rep.name unless rep.nil?
	end
end
