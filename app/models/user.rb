class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :folders, dependent: :destroy
  has_many :sources, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_one_attached :photo


  validates :email, presence: true
  # validates :first_name, presence: true
  # validates :last_name, presence: true
  # validates :username, presence: true, uniqueness: true

  def followers
    relationships = Relationship.where(receiver: self, status: 1)
    users = relationships.map { |relationship| relationship.asker }
  end

  def following
    relationships = Relationship.where(asker: self, status: 1)
    users = relationships.map { |relationship| relationship.receiver }
  end

end
