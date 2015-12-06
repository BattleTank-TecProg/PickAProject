class User < ActiveRecord::Base
	# Devise is a flexible authentication solution for Rails based on Warden
	# Include its default modules
	devise :database_authenticatable, :registerable,
				 :rememberable, :trackable, :validatable  

	# Associate users to projects that they own
	has_many :own_projects, foreign_key: 'owner_id', class_name: "Project"
	
	# Associate users to projects that they contribute (make tasks)
	has_many :tasks
	has_many :projects, through: :tasks

	# Give it roles
	rolify

	# Callbacks
	# Include default role to an user after their registration
	after_create :default_role
	# User default parameters
	before_save :default_parameters

	# Attach a profile picture to an user
	# Paperclip gem sintax for upload image files.
	has_attached_file :profile_picture, :styles => {}, :default_url => "/images/:style/missing_profile_picture.png"
	validates_attachment_content_type :profile_picture, :content_type => /\Aimage\/.*\Z/

	# Validations
	# Personal information
	validates(:username, presence: true)
	validates(:username, uniqueness: true)
	validates(:name, format: { with: /\a[a-za-z]+\z/, message: "this field only allows letters" }, allow_blank: true)
	validates(:phone, numericality: { only_integer: true }, allow_blank: true)
	validates(:sex, inclusion: { in: %w(Male Female), message: "\"%{value}\" is not a valid sex" }, allow_blank: true)
	validates(:country, format: { with: /\a[a-za-z]+\z/, message: "this field only allows letters" }, allow_blank: true)
	validates(:state, format: { with: /\a[a-za-z]+\z/, message: "this field only allows letters" }, allow_blank: true)
	validates(:city, format: { with: /\a[a-za-z]+\z/, message: "this field only allows letters" }, allow_blank: true)
	# Professional information
	validates(:work, format: { with: /\a[a-za-z]+\z/, message: "this field only allows letters" }, allow_blank: true)
	validates(:education, format: { with: /\a[a-za-z]+\z/, message: "this field only allows letters" }, allow_blank: true)	

	# Add a default role to an user at its creation
	private 
		def default_role
			self.roles << Role.find_by_name("user")
			self.save
		end
		# Pick a Project starting pontuation
		def default_parameters
			self.points = 0
			self.username.capitalize
			self.name.capitalize unless name.blank?
			self.country.capitalize unless country.blank?
			self.state.capitalize unless state.blank?
			self.city.capitalize unless city.blank?
			self.work.capitalize unless work.blank?
			self.education.capitalize unless education.blank?
		end
end
