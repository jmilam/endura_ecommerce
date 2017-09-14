class Tsm < ApplicationRecord
	has_many :sales_reps
	has_many :customers, through: :sales_reps
	validates :name, presence: true, uniqueness: true
	validates :email, presence: true
	validates_format_of :email,:with => Devise::email_regexp

	def self.get_name(tsm_id)
		tsm = Tsm.find_by_id(tsm_id)
		tsm.name unless tsm.nil?
	end
end
