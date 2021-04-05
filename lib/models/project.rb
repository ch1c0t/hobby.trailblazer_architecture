class Project
  def self.create input
    id = "project.#{SecureRandom.uuid}"

    STORE.sadd 'projects.ids', id
    STORE.set "#{id}.name", input[:name]
    STORE.set "#{id}.status", input[:status]
    STORE.set "#{id}.client_id", input[:client].id

    new id
  end

  def self.find_by_id id
    if STORE.sismember 'projects.ids', id
      new id
    end
  end

  attr_reader :id
  attr_accessor :client

  def initialize id
    @id = id
    @client = Client.new STORE.get "#{id}.client_id"
  end

  def update input
    if name = input[:name]
      self.name = name
    end

    if status = input[:status]
      self.status = status
    end

    if client = (Client.find_by_id input[:client_id])
      self.client = client
    end
  end

  def delete
    STORE.del "#{@id}.name"
    STORE.del "#{@id}.status"
    STORE.del "#{@id}.client_id"
    STORE.srem 'projects.ids', @id
  end

  def name
    STORE.get "#{@id}.name"
  end
  def name= new_name
    STORE.set "#{@id}.name", new_name
  end

  def status
    STORE.get "#{@id}.status"
  end
  def status= new_status
    STORE.set "#{@id}.status", new_status
  end

  def to_h
    {
      id: id,
      name: name,
      status: status,
      client: client.to_h
    }
  end
end
