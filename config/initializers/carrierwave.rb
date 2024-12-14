require "carrierwave/storage/abstract"
require "carrierwave/storage/file"
require "carrierwave/storage/fog"

CarrierWave.configure do |config|
  if Rails.env.production?
    config.storage :fog
    # config.fog_provider = "fog/aws"
    config.fog_directory  = ENV["S3_BUCKET_NAME"]
    config.fog_public = false
    config.fog_credentials = {
      provider: "AWS",
      aws_access_key_id: ENV["S3_ACCESS_KEY_ID"],
      aws_secret_access_key: ENV["S3_SECRET_ACCESS_KEY"],
      region: ENV["S3_REGION"]
      # path_style: true
    }
  else
    config.storage :file
    config.enable_processing = false if Rails.env.test?
  end
end

# CarrierWave.configure do |config|
#   config.fog_credentials = {
#     provider:              'AWS',                        # required
#     aws_access_key_id:     'xxx',                        # required unless using use_iam_board
#     aws_secret_access_key: 'yyy',                        # required unless using use_iam_board
#     use_iam_board:       true,                         # optional, defaults to false
#     region:                'eu-west-1',                  # optional, defaults to 'us-east-1'
#     host:                  's3.example.com',             # optional, defaults to nil
#     endpoint:              'https://s3.example.com:8080' # optional, defaults to nil
#   }
#   config.fog_directory  = 'name_of_bucket'                                      # required
#   config.fog_public     = false                                                 # optional, defaults to true
#   config.fog_attributes = { cache_control: "public, max-age=#{365.days.to_i}" } # optional, defaults to {}
#   # Use this if you have AWS S3 ACLs disabled.
#   # config.fog_attributes = { 'x-amz-acl' => 'bucket-owner-full-control' }
#   # Use this if you have Google Cloud Storage uniform bucket-level access enabled.
#   # config.fog_attributes = { uniform: true }
#   # For an application which utilizes multiple servers but does not need caches persisted across requests,
#   # uncomment the line :file instead of the default :storage.  Otherwise, it will use AWS as the temp cache store.
#   # config.cache_storage = :file
# end
