require 'digest/sha1'
class User < ActiveRecord::Base
  # Virtual attribute for the unencrypted password
  has_many :cars
  has_many :work_orders, :through => :cars

  attr_accessor :password, :accept_terms

  validates_presence_of     :login, :email,               :if => :not_openid?
  validates_presence_of     :password,                    :if => :password_required?
  validates_presence_of     :password_confirmation,       :if => :password_required?
  validates_length_of       :password, :within => 4..40,  :if => :password_required?
  validates_confirmation_of :password,                    :if => :password_required?
  validates_length_of       :login,    :within => 3..40,  :if => :not_openid?
  validates_length_of       :email,    :within => 3..100, :if => :not_openid?
  validates_uniqueness_of   :login, :email, :allow_nil => true
  validates_acceptance_of   :accept_terms,                :if => :not_openid?
  before_save :encrypt_password
  
  def display_name
    self[:display_name] || self[:login]
  end
  
  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(login, password)
    u = find_by_login(login) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at 
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    remember_me_for 2.weeks
  end

  def remember_me_for(time)
    remember_me_until time.from_now.utc
  end

  def remember_me_until(time)
    self.remember_token_expires_at = time
    self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}")
    save(false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end

protected
  # before filter 
  def encrypt_password
    return if password.blank?
    self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
    self.crypted_password = encrypt(password)
  end
  
  def password_required?
    not_openid? && (crypted_password.blank? or not password.blank?)
  end

  def not_openid?
    identity_url.blank?
  end
  
end
