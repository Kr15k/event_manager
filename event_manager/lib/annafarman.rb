require 'csv' # for RUBY CSV
require 'google/apis/civicinfo_v2'
require 'erb'
require 'date'

puts 'Event Manager Initialized!'

def clean_zipcode(zipcode); end

def clean_phone_number(phone); end

def legislators_by_zipcode(zip); end

def save_thankyou_letter(id, form_letter); end

@registration_hour = []
@registration_day = []

def peak_reg_time
  registration_counts = Hash.new(0) # p registration_counts {}
  @registration_hour.each do |time|
    registration_counts[time] += 1
  end
  # p registration_counts {"10"=>1, "13"=>3, "19"=>2, "11"=>2, "15"=>1, "16"=>3, "17"=>1, "1"=>1, "18"=>1, "21"=>2, "20"=>2}
  peak_hour = registration_counts.select do |_time, count|
    count == registration_counts.values.max
  end.keys
  # p peak_hour ["13", "16"]
  puts 'Peak registration time(s) are between:  '
  peak_hour.each do |time|
    time = time.to_i
    puts "- #{time}:00 - #{time + 1}:00 "
  end
end

def peak_reg_day
  registration_counts = Hash.new(0)
  # p @registration_day
  @registration_day.each do |day|
    registration_counts[day] += 1
  end

  peak_day = registration_counts.select do |_day, count|
    count == registration_counts.values.max
  end.keys

  # p registration_counts
  puts "Most people registered on #{peak_day.join(', ')}."
end

contents = CSV.open(
  'event_attendees.csv',
  headers: true,
  header_converters: :symbol
)

template_letter = File.read('form_letter.html')
erb_template = ERB.new template_letter

contents.each do |row|
  id = row[0]
  name = row[:first_name]
  zipcode = clean_zipcode(row[:zipcode])
  phone_num = clean_phone_number(row[:homephone])
  reg_time = row[:regdate].split(' ')

  @registration_hour << reg_time[1].split(':')[0]
  # obtaining the hour only. result: ["10", "13", "13", "19", "11", "15", "16", "17", "1", "16", "18", "21", "11", "13", "20", "19", "21", "16", "20"]

  date = Date.strptime(reg_time[0], '%m/%d/%y')
  @registration_day << date.strftime('%A')

  legislators = legislators_by_zipcode(zipcode)
  form_letter = erb_template.result(binding)

  save_thankyou_letter(id, form_letter)
end

peak_reg_time
peak_reg_day
