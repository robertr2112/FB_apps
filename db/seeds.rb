# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
print "Adding Admin user...\n"
admin = User.new do |u|
  u.name = "Admin"
  u.admin = true
  u.confirmed = true
  u.email = "admin@example.com"
  u.password = "password"
  u.password_confirmation = "password"
end

admin.save!

print "Adding NFL teams...\n"
    NflTeam.create name: "Arizona Cardinals", 
                                      imagePath: "nfl_teams/nfcw/ari.jpeg"
    NflTeam.create name: "Atlanta Falcons", 
                                      imagePath: "nfl_teams/nfcs/atl.jpeg"
    NflTeam.create name: "Baltimore Ravens", 
                                      imagePath: "nfl_teams/afcn/bal.jpeg"
    NflTeam.create name: "Buffalo Bills", 
                                      imagePath: "nfl_teams/afce/buf.jpeg"
    NflTeam.create name: "Carolina Panthers", 
                                      imagePath: "nfl_teams/nfcs/car.jpeg"
    NflTeam.create name: "Chicago Bears", 
                                      imagePath: "nfl_teams/nfcn/chi.jpeg"
    NflTeam.create name: "Cinncinatti Bengals", 
                                      imagePath: "nfl_teams/afcn/cin.jpeg"
    NflTeam.create name: "Cleveland Browns", 
                                      imagePath: "nfl_teams/afcn/cle.jpeg"
    NflTeam.create name: "Dallas Cowboys", 
                                      imagePath: "nfl_teams/nfce/dal.jpeg"
    NflTeam.create name: "Denver Broncos", 
                                      imagePath: "nfl_teams/afcw/den.jpeg"
    NflTeam.create name: "Detroit Lions", 
                                      imagePath: "nfl_teams/nfcn/det.jpeg"
    NflTeam.create name: "Green Bay Packers", 
                                      imagePath: "nfl_teams/nfcn/gb.jpeg"
    NflTeam.create name: "Houston Texans", 
                                      imagePath: "nfl_teams/afcs/hou.jpeg"
    NflTeam.create name: "Indianapolis Colts", 
                                      imagePath: "nfl_teams/afcs/ind.jpeg"
    NflTeam.create name: "Jacksonville Jaguars", 
                                      imagePath: "nfl_teams/afcs/jac.jpeg"
    NflTeam.create name: "Kansas City Chiefs", 
                                      imagePath: "nfl_teams/afcw/kc.jpeg"
    NflTeam.create name: "Minnesota Vikings", 
                                       imagePath: "nfl_teams/nfcn/min.jpeg"
    NflTeam.create name: "Miami Dolphins", 
                                      imagePath: "nfl_teams/afce/mia.jpeg"
    NflTeam.create name: "New England Patriots", 
                                      imagePath: "nfl_teams/afce/ne.jpeg"
    NflTeam.create name: "New Orleans Saints", 
                                      imagePath: "nfl_teams/nfcs/no.jpeg"
    NflTeam.create name: "New York Giants", 
                                      imagePath: "nfl_teams/nfce/nyg.jpeg"
    NflTeam.create name: "New York Jets", 
                                      imagePath: "nfl_teams/afce/nyj.jpeg"
    NflTeam.create name: "Oakland Raiders", 
                                      imagePath: "nfl_teams/afcw/oak.jpeg"
    NflTeam.create name: "Philadelphia Eagles", 
                                      imagePath: "nfl_teams/nfce/phi.jpeg"
    NflTeam.create name: "Pittsburgh Steelers", 
                                      imagePath: "nfl_teams/afcn/pit.jpeg"
    NflTeam.create name: "San Francisco 49ers", 
                                      imagePath: "nfl_teams/nfcw/sf.jpeg"
    NflTeam.create name: "San Diego Chargers", 
                                      imagePath: "nfl_teams/afcw/sd.jpeg"
    NflTeam.create name: "Seattle Seahawks", 
                                      imagePath: "nfl_teams/nfcw/sea.jpeg"
    NflTeam.create name: "St Louis Cardinals", 
                                      imagePath: "nfl_teams/nfcw/stl.jpeg"
    NflTeam.create name: "Tampa Bay", 
                                      imagePath: "nfl_teams/nfcs/tb.jpeg"
    NflTeam.create name: "Tennessee Titans", 
                                      imagePath: "nfl_teams/afcs/ten.jpeg"
    NflTeam.create name: "Washington Redskins", 
                                      imagePath: "nfl_teams/nfce/was.jpeg"
