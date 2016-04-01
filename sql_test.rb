#!/usr/bin/ruby

require 'sqlite3'
require 'csv'

begin

  puts "Started"
  db = SQLite3::Database.open "California.db"
  # puts db.get_first_value 'SELECT SQLITE_VERSION()'

  db.execute "CREATE TABLE IF NOT EXISTS Station (Id String PRIMARY KEY,
         Name TEXT, Latitude DOUBLE, Longitude DOUBLE, Elevation DOUBLE)"
  CSV.foreach('data/california.csv', headers:true) do |row|
    id   = row[0].to_s
    name = row[1].to_s
    elev = row[2].to_f
    lat  = row[3].to_f
    long = row[4].to_f

    params = id, name, lat, long, elev

    stm = db.execute "SELECT COUNT(Id) AS STATIONEXISTS FROM Station WHERE Id=?",id
    # puts stm[0][0]

    if stm[0][0] == 0
      db.execute "INSERT INTO Station VALUES(?,?,?,?,?)", params
      puts id.to_s + " " + name.to_s + " " + long.to_s + " " + lat.to_s + " " + elev.to_s
    end
  end


  puts "Done"

rescue SQLite3::Exception => e

  puts "Exception occurred"
  puts e

ensure
  # stm.close if stm
  db.close if db
end
