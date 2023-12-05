#!/usr/bin/env ruby
# frozen_string_literal: true

require 'csv'
csv_filename = 'event_attendees.csv'
ZIP_STANDARD = 5

def fix_zip_length(zip)
  if zip.nil?
    '00000'
  elsif zip.length < ZIP_STANDARD
    zip.rjust(5, '0')
  elsif zip.length > ZIP_STANDARD
    zip[0..4]
  else
    zip
  end
end

puts 'Event Manager Initialized!'

if File.exist?(csv_filename)
  attendees = CSV.open(csv_filename, headers: true, header_converters: :symbol)

  attendees.each do |record|
    first_name  = record[:first_name]
    last_name   = record[:last_name]
    zip_code    = record[:zipcode]

    zip_code = fix_zip_length(zip_code)
    puts "#{first_name} #{last_name}, #{zip_code}"
  end
else
  puts "#{csv_filename} not found."
end
