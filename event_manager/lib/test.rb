require 'csv'

@arr = Array.new(24, 0)

def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5, '0')[0..4]
end

def clean_phones(num)
  bad_num = "----------"
  one = num.delete('-()[]. ')
  if one == nil
    one = bad_num
  elsif one.length == 10
  elsif one.length == 11 && one[0] == "1"
    one.delete!(one[0, 1])
  else one = bad_num
  end
  one = one.insert(6, ' ').insert(3, ' ')
  return one
end

def time_count
  @arr[@hour] += 1
end

puts 'EventManager initialized.'

contents = CSV.open(
  'event_attendees_full.csv',
  headers: true,
  header_converters: :symbol
)

contents.each do |row|
  name = row[:first_name]
  phone = clean_phones(row[:homephone])
  # time = (row[:regdate])
  # dat = (row[:regdate].split())
  # one = dat[0].split("/")
  # dato = time.strftime("%d/%m/%Y")
  # one[2] = "20" + one[2]
  # one = one.join("/")
  # dato = one += " #{dat[1]}"
  # p time = Time.new(dato).strftime("%m/%d/%Y %H:%M")
  # @hour = time[0].to_i
  # time_count
  # #{@hour}
  puts "#{phone}   #{name}"
end
puts "The hour with the most registrations is: #{@arr.each_with_index.max[1]}:00"
