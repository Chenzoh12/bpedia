class User < ActiveRecord::Base
  attr_accessor :current_wiki

  has_many :collaborators, dependent: :destroy
  has_many :wikis, through: :collaborators, dependent: :destroy
  
  after_initialize { self.role ||= :standard }
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable;


  enum role: [:standard, :premium, :admin]
end
