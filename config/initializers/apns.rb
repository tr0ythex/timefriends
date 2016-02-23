# APNS.host = "gateway.sandbox.push.apple.com"  
APNS.pem = File.join(Rails.root, "development.pem")

# Set the environment variable `APPLE_SANDBOX` to use the development certificate in production
if Rails.env.production? 
  # && !ENV["APPLE_SANDBOX"]  
  # APNS.host = "gateway.push.apple.com"
  APNS.pem = File.join(Rails.root, "production.pem")
end