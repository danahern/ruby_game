class Rocket
  def initialize(animation)
    @rocket_anim = animation
  end

  def draw(player)
    rocket = @rocket_anim[Gosu::milliseconds / 100 % @rocket_anim.size]
    rocket.draw_rot(player.x, player.y, 1, player.angle-180, 0.5, 2.5)
  end
end