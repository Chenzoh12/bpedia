class User < ActiveRecord::Base
  has_many :wikis, dependent: :destroy
  
  after_initialize { self.role ||= :standard }
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable;
         
    validates :email,
        presence: true,
        uniqueness: { case_sensitive: false },
        length: { minimum: 5, maximum: 254 }
=begin        
     validates :password,
        presence: true,
        length: { minimum: 6, maximum: 254 },
        allow_blank: false
=end 
  enum role: [:standard, :premium, :admin]
end
