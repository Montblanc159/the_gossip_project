require 'csv'

class Gossip
  attr_accessor :author, :content

  def initialize(author, content)
    @author = author
    @content = content
  end
  def save
    # Création d'un fichier email.csv dans notre data base.
    CSV.open("db/gossip.csv", "ab") do |csv|
      csv << [@author, @content]
    end
  end


  def self.find(asked_index)
    return Gossip.all[asked_index.to_i]
  end

  def self.update(at_index, updated_content)
    all_gossips = Gossip.all
    all_gossips[at_index].content = updated_content
    CSV.open('db/gossip.csv', "w") do |csv|
      all_gossips.each do |gossip|
        csv << [gossip.author, gossip.content]
      end
    end
  end

  def self.all
    all_gossips = []
    csv = CSV.read("db/gossip.csv")
    csv.each do |ligne|
      temp_gossip = Gossip.new(ligne[0], ligne[1])
      all_gossips << temp_gossip
    end
    return all_gossips
  end
end
