#!/usr/bin/env ruby
# frozen_string_literal: true

puts 'Event Manager Initialized!'
csv_filename = 'event_attendees.csv'

if File.exist?(csv_filename)
  attendees = File.readlines(csv_filename)
  attendees.each_with_index do |line, index|
    next if index == 0 # ignores the csv header line

    attendee_info = line.split(',')
    first_name = attendee_info[2]
    puts first_name
  end
else
  puts "#{csv_filename} not found."
end
