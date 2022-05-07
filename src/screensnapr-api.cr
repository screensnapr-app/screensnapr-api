ENV["ENV"] ||= "development"

require "json"
require "kemal"
require "random"
require "./configuration"
require "./presigned_url"

module ScreenSnapr
  @@configuration : Configuration = Configuration.new

  # Holds the `Configuration` for the current ScreenSnapr process.
  def self.configuration
    @@configuration
  end
end

module ScreenSnapr::Api
  VERSION = "0.1.0"

  get "/url" do |env|
    key = Random.new.hex(15)

    url = PresignedUrl.new(key)
    url = url.request(:put)

    env.response.status_code = 200
    {
      "PresignedUrl": url,
      "ShareUrl":     configuration.share_url_base.not_nil!,
      "Key":          key,
    }.to_json
  end

  def self.configuration
    ScreenSnapr.configuration
  end

  def self.run
    if !configuration.valid?
      STDERR.puts "Invalid config."
      STDERR.puts configuration.errors.join(", ")
      exit 1
    else
      STDOUT.puts "Running."
    end

    Kemal.run
  end
end

ScreenSnapr::Api.run
