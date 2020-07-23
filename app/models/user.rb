class User < ApplicationRecord
  has_many :user_stocks
  has_many :stocks,through: :user_stocks

  has_many :friendships
  has_many :friends,through: :friendships

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def stock_already_tracked?(ticker_symbol)
    stock = Stock.check_db(ticker_symbol)
    return false unless stock
    stocks.where(id: stock.id).exists?    
  end
  
 

  def can_track_stock?(ticker_symbol)
     !stock_already_tracked?(ticker_symbol)
  end


  def full_name
    return "#{first_name} #{last_name}" if first_name || last_name
    return "Anonymous"
  end

  def self.search(param)
    param.strip!
    to_send_back=( matches('email',param)+matches('first_name',param)+matches('last_name',param) ).uniq
    return to_send_back if to_send_back.present?
    return nil
  end

  def self.matches(field_name,param)
    return User.where("#{field_name} like ?","%#{param}%")
  end

  def except_current_user(users)
    users.reject{|user| user.id==self.id}
  end

  def not_friends_with?(id_of_friend)
    !self.friends.where(id: id_of_friend).exists?
  end

end
