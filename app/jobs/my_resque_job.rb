# frozen_string_literal: true

class MyResqueJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    # Do something later
    puts 'Job is running!'
  rescue StandardError => e
    # Handle your error here
    puts "An error occurred: #{e.message}"
  end
end
