module IdGenerator
  def self.included(uuid)
    uuid.before_create :generate_uuid
  end

  def generate_uuid
    self.id = loop do
      uuid = SecureRandom.uuid
      break uuid unless self.class.exists?(id: uuid)
    end
  end
end
