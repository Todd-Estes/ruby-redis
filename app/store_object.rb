class StoreObject 
  attr_reader :value, :px, :created_at
  def initialize(value, px = nil)
    @value = value
    @px = px
    @created_at = current_time
  end

  def current?
    if @px
      current_time <= (@created_at + @px.to_i)
    else
      true
    end
  end

  private

  def current_time
    (Time.now.to_f * 1000).to_i
  end
end
