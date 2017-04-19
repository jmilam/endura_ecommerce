class Tsm < ApplicationRecord
	has_many :sales_reps
	has_many :customers, through: :sales_reps
	validates :name, presence: true, uniqueness: true

	def self.get_name(tsm_id)
		tsm = Tsm.find_by_id(tsm_id)
		tsm.name unless tsm.nil?
	end
end
