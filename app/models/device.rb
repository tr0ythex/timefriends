class Device < ActiveRecord::Base
  scope :ios, -> { where(device_type: 'ios') }
  
  
end