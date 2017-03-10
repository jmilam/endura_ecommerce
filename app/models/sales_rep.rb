class SalesRep < ApplicationRecord
	belongs_to :tsm
	has_many :customers
end
