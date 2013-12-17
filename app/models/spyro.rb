class Spyro < ActiveRecord::Base
  after_save :notify_spyro_change

  def notify_spyro_change
    connection.execute "NOTIFY #{channel}," + "'{" + '"spyro":' + self.id.to_json + "}'"
  end


  def generate(xOffset, yOffset, bigRadius, smallRadius, point)
    # puts xOffset + "," + yOffset + "," + bigRadius + "," +smallRadius + "," + point
    path = ""
    r1 = bigRadius
    r2 = smallRadius
    t = 0.0
    firstRun = true
    while t < 2*Math::PI do
      x = ((r1 - r2)*Math.cos(t) + point*Math.cos((r1 - r2)*t/r2)) + xOffset
      y = ((r1 - r2)*Math.sin(t) - point*Math.sin((r1 - r2)*t/r2)) + yOffset
      if firstRun
        path += "M#{x.round(5)} #{y.round(5)}"
        firstRun = false
      else
        path += "L#{x.round(5)} #{y.round(5)}"
      end
      t += 0.001
    end
    self.path = path
  end

  private

  def channel
    "layer#{self.layer_id}"
  end

end
