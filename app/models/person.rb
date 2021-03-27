class Person < ApplicationRecord
  has_and_belongs_to_many :interests
  has_and_belongs_to_many :meetings
end
