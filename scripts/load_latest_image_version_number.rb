# frozen_string_literal: true

require "aws-sdk-ecr"

# (1) Fetch all docker images pushed to ECR ever (that's why there's a loop)
# so we can pull the old old ones as well

major_version = "v1"
repository_name = "sample-docker-rails-app"

client = Aws::ECR::Client.new

image_fetcher = client.list_images(repository_name: repository_name)
images = image_fetcher.image_ids
counter = 1

until image_fetcher.next_token.nil?
  counter += 1

  image_fetcher = client.list_images(repository_name: repository_name,
                                     next_token: image_fetcher.next_token)
  images += image_fetcher.image_ids
end

# (2) We only want to look at images with tag "v1.0.x" in this example

image_tags = images.map(&:image_tag)

relevant_images = image_tags.compact.select do |t|
  c = t.split(".")

  c[-2] == "0" && c[-3] == major_version
end

# (3) Get the max, add 1 and that's the version we use!

latest_series_zero_image = relevant_images.map { |t| t.split(".")[-1].to_i }.max

puts "#{major_version}.0.#{latest_series_zero_image + 1}"
