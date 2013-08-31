class CreateNflTeams < ActiveRecord::Migration
  def change
    create_table :nfl_teams do |t|
      t.string :name
      t.string :imagePath

      t.timestamps
    end
    NflTeam.create name: "Arizona Cardinals", 
                                      imagePath: "images/nfl_teams/nfcw/ari.jpeg"
    NflTeam.create name: "Atlanta Falcons", 
                                      imagePath: "images/nfl_teams/nfcs/atl.jpeg"
    NflTeam.create name: "Baltimore Ravens", 
                                      imagePath: "images/nfl_teams/afcn/atl.jpeg"
    NflTeam.create name: "Buffalo Bills", 
                                      imagePath: "images/nfl_teams/afce/buf.jpeg"
    NflTeam.create name: "Carolina Panthers", 
                                      imagePath: "images/nfl_teams/nfcs/car.jpeg"
    NflTeam.create name: "Chicago Bears", 
                                      imagePath: "images/nfl_teams/nfcn/chi.jpeg"
    NflTeam.create name: "Cinncinatti Bengals", 
                                      imagePath: "images/nfl_teams/afcn/cin.jpeg"
    NflTeam.create name: "Cleveland Browns", 
                                      imagePath: "images/nfl_teams/afcn/cle.jpeg"
    NflTeam.create name: "Dallas Cowboys", 
                                      imagePath: "images/nfl_teams/nfce/dal.jpeg"
    NflTeam.create name: "Denver Broncos", 
                                      imagePath: "images/nfl_teams/afcw/dev.jpeg"
    NflTeam.create name: "Detroit Lions", 
                                      imagePath: "images/nfl_teams/nfcn/det.jpeg"
    NflTeam.create name: "Green Bay Packers", 
                                      imagePath: "images/nfl_teams/nfcn/gb.jpeg"
    NflTeam.create name: "Houston Texans", 
                                      imagePath: "images/nfl_teams/afcs/hou.jpeg"
    NflTeam.create name: "Indianapolis Colts", 
                                      imagePath: "images/nfl_teams/afcs/ind.jpeg"
    NflTeam.create name: "Jacksonville Jaguars", 
                                      imagePath: "images/nfl_teams/afcs/jac.jpeg"
    NflTeam.create name: "Kansas City Chiefs", 
                                      imagePath: "images/nfl_teams/afcw/kc.jpeg"
    NflTeam.create name: "Minnesota Vikings", 
                                       imagePath: "images/nfl_teams/nfcn/min.jpeg"
    NflTeam.create name: "Miami Dolphins", 
                                      imagePath: "images/nfl_teams/afce/mia.jpeg"
    NflTeam.create name: "New England Patriots", 
                                      imagePath: "images/nfl_teams/afce/ne.jpeg"
    NflTeam.create name: "New Orleans Saints", 
                                      imagePath: "images/nfl_teams/nfcs/no.jpeg"
    NflTeam.create name: "New York Giants", 
                                      imagePath: "images/nfl_teams/nfce/nyg.jpeg"
    NflTeam.create name: "New York Jets", 
                                      imagePath: "images/nfl_teams/afce/nyj.jpeg"
    NflTeam.create name: "Oakland Raiders", 
                                      imagePath: "images/nfl_teams/afcw/oak.jpeg"
    NflTeam.create name: "Philadelphia Eagles", 
                                      imagePath: "images/nfl_teams/nfce/phi.jpeg"
    NflTeam.create name: "Pittsburgh Steelers", 
                                      imagePath: "images/nfl_teams/afcn/pit.jpeg"
    NflTeam.create name: "San Francisco 49ers", 
                                      imagePath: "images/nfl_teams/nfcw/sf.jpeg"
    NflTeam.create name: "San Diego Chargers", 
                                      imagePath: "images/nfl_teams/afcw/sd.jpeg"
    NflTeam.create name: "Seattle Seahawks", 
                                      imagePath: "images/nfl_teams/nfcw/sea.jpeg"
    NflTeam.create name: "St Louis Cardinals", 
                                      imagePath: "images/nfl_teams/nfcw/sd.jpeg"
    NflTeam.create name: "Tampa Bay", 
                                      imagePath: "images/nfl_teams/nfcs/tb.jpeg"
    NflTeam.create name: "Tennessee Titans", 
                                      imagePath: "images/nfl_teams/afcs/ten.jpeg"
    NflTeam.create name: "Washington Redskins", 
                                      imagePath: "images/nfl_teams/nfce/was.jpeg"
  end
end
