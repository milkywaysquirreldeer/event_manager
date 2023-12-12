#!/usr/bin/env ruby
# frozen_string_literal: true

require 'csv'
require 'google-apis-civicinfo_v2'

csv_filename = 'event_attendees.csv'
ZIP_STANDARD = 5
template_letter = File.read('form_letter.html')

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

def get_legislators_by_zip(zip)
  begin
    civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
    civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'
    api_response = civic_info.representative_info_by_address(
      address: zip,
      levels: 'country',
      roles: ['legislatorUpperBody', 'legislatorLowerBody']
    )
    api_response.officials.map(&:name).join(', ')
  rescue
    'www.commoncause.org/take-action/find-elected-officials'
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
    legislators_string = get_legislators_by_zip(zip_code)
    puts "#{first_name} #{last_name}, #{zip_code}: #{legislators_string}"

    personal_letter = template_letter.gsub('FIRST_NAME', first_name)
    personal_letter = personal_letter.gsub!('LEGISLATORS', legislators_string)
    puts personal_letter
  end
else
  puts "#{csv_filename} not found."
end
