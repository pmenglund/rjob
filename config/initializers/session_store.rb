# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_rjob_session',
  :secret      => '5d89fdd563a309f2947e01c4c2191cbfad17e3078539e07db3849ecbf86edb291ebfb0091918202d3c314ceb6649da7e11ba86419b6a3a2afdb1f2b65ac83276'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
