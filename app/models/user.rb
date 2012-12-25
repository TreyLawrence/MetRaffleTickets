class User < ActiveRecord::Base
  attr_accessible :username, :email, :password, :registered

  before_save { self.email.downcase! }
  before_save { self.registered = false }

  validates :username, presence: true
  validates :password, presence: true

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence:   true,
                    format:     { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  def registered?
  	registered
  end

  def enter_raffle
  	browser = Mechanize.new
  	enter_drawing = browser.get(
  		'http://www.metoperafamily.org/metopera/contests/drawing/index.aspx')
  	form = enter_drawing.forms.first
  	form.checkboxes.each { |checkbox| checkbox.check }
  	register_or_signin = form.submit(form.buttons[1])

  	if !registered
  		register_now = register_or_signin.links.select { |link| link.text =~ /Register Now/ }.first.click
  		register_form = register_now.forms.first
  		register_fields = register_form.fields.select do |field|
  			field.type == "text" || field.type == "password" || field.class == Mechanize::Form::SelectList
  		end

  		register_fields.select {|field| field.name =~ /username/}.first.value = this.username
  		register_fields.select {|field| field.name =~ /firstname/}.first.value = this.first_name
  		register_fields.select {|field| field.name =~ /lastname/}.first.value = this.last_name
  		register_fields.select {|field| field.name =~ /salutation/}.first.value = this.salutation
  		register_fields.select {|field| field.name =~ /address/}.first.value = this.address
  		register_fields.select {|field| field.name =~ /address2/}.first.value = this.address2
  		register_fields.select {|field| field.name =~ /city/}.first.value = this.city
  		register_fields.select {|field| field.name =~ /zip/}.first.value = this.zip_code
  		
  		register_fields.select {|field| field.name =~ /email/}.each { |email_field| email_field.value = this.email }
  		register_fields.select {|field| field.name =~ /password/}.each { |password_field| password_field.value = this.password }
  		register_fields.select {|field| field.name =~ /phone/}.first.value = this.daytime_phone
  		register_fields.select {|field| field.name =~ /state/}.first.value = this.state
  		register_fields.select {|field| field.name =~ /country/}.first.value = this.country

  		submit_button = register_form.buttons.select {|button| button.name =~ /CompleteRegistration/}.first
  		submit_button.x = 26
  		submit_button.y = 16
  		success_page = register_form.submit(submit_button)

  		registered = true
  		self.save
  	end
  end
end
