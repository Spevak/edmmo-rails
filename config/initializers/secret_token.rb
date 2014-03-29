# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
secret = Rails.env.production? ? ENV['SECRET_TOKEN'] : '08261e679ff7150e806856b03caa030b463f85792c174a0ee0a3e23fea3b281516c20cd5e5deef891e1fc58f04f321a9f8e89c7a7078f4fec0b12324e7359b72'
EdmmoRails::Application.config.secret_key_base = secret
