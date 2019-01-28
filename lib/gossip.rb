class Gossip
  attr_accessor :author, :content, :id

  def initialize(author, content)
    @author = author
    @content = content
  end

  def set_id
    @id = Time.now.to_s.delete ": +-"
  end

  def save
    # Création d'un fichier email.csv dans notre data base.
    set_id
    CSV.open("db/gossip.csv", "ab") do |csv|
      csv << [@author, @content, @id]
    end
  end

  def create_comment(com_author, com_content)
    comment = Comment.new(com_author, com_content)
    CSV.open("db/comments/com_#{@author.downcase + @id}.csv", "a") do |csv|
      csv << [comment.author, comment.content]
    end
  end

  def has_comments?
    File.file?("db/comments/com_#{@author.downcase + @id}.csv")
  end

  def read_comment
    all_comments = []
    csv = CSV.read("db/comments/com_#{@author.downcase + @id}.csv")
    csv.each do |ligne|
      temp_comment = Comment.new(ligne[0], ligne[1])
      all_comments << temp_comment
    end
    return all_comments
  end


  def self.find(asked_index)
    return Gossip.all[asked_index.to_i]
  end

  def self.update(at_index, updated_content)
    all_gossips = Gossip.all
    all_gossips[at_index].content = updated_content
    CSV.open('db/gossip.csv', "w") do |csv|
      all_gossips.each do |gossip|
        csv << [gossip.author, gossip.content, gossip.id]
      end
    end
  end

  def self.delete(params)
    all_gossips = Gossip.all
    if File.file?("db/comments/com_#{all_gossips[params].author.downcase}#{all_gossips[params].id}.csv")
      File.delete("db/comments/com_#{all_gossips[params].author.downcase}#{all_gossips[params].id}.csv")
    end
    all_gossips.delete_at(params)
    CSV.open("db/gossip.csv", "w") do |csv|
      all_gossips.each do |gossip|
        csv << [gossip.author, gossip.content, gossip.id]
      end
    end
  end

  def self.all
    all_gossips = []
    csv = CSV.read("db/gossip.csv")
    csv.each do |ligne|
      temp_gossip = Gossip.new(ligne[0], ligne[1])
      temp_gossip.id = ligne[2]
      all_gossips << temp_gossip
    end
    return all_gossips
  end
end
