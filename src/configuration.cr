module ScreenSnapr
  # Holds current ScreenSnapr configuration.
  class Configuration
    @env : String
    @aws_key : String? = ENV["AWS_ACCESS_KEY"]?
    @aws_secret : String? = ENV["AWS_SECRET_ACCESS_KEY"]?
    @aws_endpoint_url : String? = ENV["AWS_ENDPOINT_URL"]?
    @aws_region : String? = ENV["AWS_REGION"]?
    @aws_bucket : String? = ENV["AWS_BUCKET"]?
    @content_type : String? = ENV["SCREENSNAPR_CONTENT_TYPE"]?
    @share_url_base : String? = ENV["SCREENSNAPR_SHARE_URL_BASE"]?

    # The Amazon Access Key.
    property aws_key

    # The Amazon Access Secret.
    property aws_secret

    # The Amazon region.
    property aws_region

    # The Amazon S3 bucket.
    property aws_bucket

    property aws_endpoint_url

    property content_type

    property share_url_base

    # The current ScreenSnapr Environment.
    property! env

    # Errors found during `Configuration` validation.
    getter errors

    def initialize
      @env = ENV["ENV"]
      @errors = [] of String
    end

    # Determines if the `Configuration` is valid. Returns `true` if valid,
    # `false` otherwise.
    #
    # ```
    # config = Configuration.new
    # config.valid? # => false
    # ```
    def valid?
      _errors.empty?
    end

    # :nodoc:
    private def _errors
      @errors.clear
      @errors.push("Missing AWS_ACCESS_KEY") if aws_key.nil?
      @errors.push("Missing AWS_SECRET_ACCESS_KEY") if aws_secret.nil?
      @errors.push("Missing AWS_BUCKET") if aws_bucket.nil?
      @errors.push("Missing AWS_REGION") if aws_region.nil?
      @errors.push("Missing AWS_ENDPOINT_URL") if aws_endpoint_url.nil?
      @errors.push("Missing SCREENSNAPR_CONTENT_TYPE") if content_type.nil?
      @errors.push("Missing SCREENSNAPR_SHARE_URL_BASE") if share_url_base.nil?
      @errors
    end
  end
end
