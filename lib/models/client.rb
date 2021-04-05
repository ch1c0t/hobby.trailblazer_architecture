class Client
  def self.create input
    id = "client.#{SecureRandom.uuid}"

    STORE.sadd 'clients.ids', id
    STORE.set "#{id}.name", input[:name]

    new id
  end

  def self.find_by_id id
    if STORE.sismember 'clients.ids', id
      new id
    end
  end

  def update input
    self.name = input[:name]
  end

  def delete
    STORE.del "#{@id}.name"
    STORE.srem 'clients.ids', @id
  end

  attr_reader :id

  def name
    STORE.get "#{id}.name"
  end

  def name= new_name
    STORE.set "#{@id}.name", new_name
  end

  def to_h
    {
      id: id,
      name: name,
    }
  end
end
