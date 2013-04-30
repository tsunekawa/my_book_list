class Account < ActiveRecord::Base
  attr_accessor :password, :password_confirmation

  # Validations
  validates_presence_of     :email, :role
  validates_presence_of     :password,                   :if => :password_required
  validates_presence_of     :password_confirmation,      :if => :password_required
  validates_length_of       :password, :within => 4..40, :if => :password_required
  validates_confirmation_of :password,                   :if => :password_required
  validates_length_of       :email,    :within => 3..100
  validates_uniqueness_of   :email,    :case_sensitive => false
  validates_format_of       :email,    :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  validates_format_of       :role,     :with => /[A-Za-z]/

  # Callbacks
  before_save :encrypt_password, :if => :password_required

  has_many :having_books
  has_many :amazon_items, :through=>:having_books
  has_many :books, :through=>:having_books, :foreign_key=>:amazon_item_id

  has_many :rateds,  :class_name=>"Rating", :as=>:ratable
  has_many :ratings, :class_name=>"Rating", :foreign_key=>:account_id

  ##
  # This method is for authentication purpose
  #
  def self.authenticate(email, password)
    account = first(:conditions => { :email => email }) if email.present?
    account && account.has_password?(password) ? account : nil
  end

  def has_password?(password)
    ::BCrypt::Password.new(crypted_password) == password
  end

  def is_admin?
    role.to_sym == :admin
  end

  def rating_of(ratable)
    params = {
      :account_id   => self.id,
      :ratable_id   => ratable.id,
      :ratable_type => ratable.class.name
    }
    rating = Rating.where(params).first
    rating = Rating.new(params) if rating.blank?
    rating
  end

  private
  def encrypt_password
    self.crypted_password = ::BCrypt::Password.create(password)
  end

  def password_required
    crypted_password.blank? || password.present?
  end
end
