require 'net/https'

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
