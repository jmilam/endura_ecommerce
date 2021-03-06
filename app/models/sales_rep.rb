class SalesRep < ApplicationRecord
	belongs_to :tsm
	has_many :customers
	validates :name, presence: true, uniqueness: true

	def self.get_name(rep_id)
		rep = SalesRep.find_by_id(rep_id)
		rep.name unless rep.nil?
	end
end
