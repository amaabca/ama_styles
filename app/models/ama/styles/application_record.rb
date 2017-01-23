module AMA
  module Styles
    class ApplicationRecord < ActiveRecord::Base
      self.abstract_class = true
    end
  end
end
