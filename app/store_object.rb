class StoreObject 
  attr_reader :value, :px, :created_at
  def initialize(value, px = nil)
    @value = value
    @px = px.to_i
    @created_at = current_time
  end

  def is_expired?
    (Time.now.to_f * 1000).to_i >= expiration
  end

  private

  def expiration
    @created_at + @px
  end

  def current_time
    (Time.now.to_f * 1000).to_i
  end
end
