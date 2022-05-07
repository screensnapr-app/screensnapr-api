require "awscr-s3"

module ScreenSnapr
  class PresignedUrl
    def initialize(@object : String)
      @object = "/#{@object}" unless @object.starts_with?("/")
    end

    def request(method : Symbol)
      opts = Awscr::S3::Presigned::Url::Options.new(
        aws_access_key: key,
        aws_secret_key: secret,
        region: region,
        object: @object,
        bucket: bucket,
        additional_options: {
          "x-amz-acl"    => "public-read",
          "Content-Type" => ScreenSnapr.configuration.content_type.not_nil!,
        },
        host_name: ScreenSnapr.configuration.aws_endpoint_url.not_nil!,
        include_port: true
      )
      url = Awscr::S3::Presigned::Url.new(opts)
      url.for(method)
    end

    # :nodoc:
    private def key
      ScreenSnapr.configuration.aws_key.not_nil!
    end

    # :nodoc:
    private def secret
      ScreenSnapr.configuration.aws_secret.not_nil!
    end

    # :nodoc:
    private def region
      ScreenSnapr.configuration.aws_region.not_nil!
    end

    # :nodoc:
    private def bucket
      ScreenSnapr.configuration.aws_bucket.not_nil!
    end
  end
end
