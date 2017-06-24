# Log Active record sql queries in development
# mode for debugging

ActiveRecord::Base.logger = Logger.new(STDOUT)