class SubFinish < ApplicationRecord
	belongs_to :product_finish, dependent: :delete

	validates :name, presence: true
end
