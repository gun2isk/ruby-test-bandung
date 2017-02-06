# config/initializers/recaptcha.rb
Recaptcha.configure do |config|
  config.site_key  = '6LdJUgwTAAAAAK8ubeLG0f_NaEHaXQP4FeC7OVWm'
  config.secret_key = '6LdJUgwTAAAAAPFpGACVJJ4LcCucOjhQKVvgAXIo'
  # Uncomment the following line if you are using a proxy server:
  # config.proxy = 'http://myproxy.com.au:8080'
end