require 'rubygems'
# Set up gems listed in the Gemfile.
require "bundler/setup"
require 'gosu'
Dir.glob(File.join(File.dirname(__FILE__), "lib", "**", "*.rb")).each do |file|
  require file
end

class First < Gosu::Window
  def initialize
    super 640, 480, false
    self.caption = "First Game"
    @background_image = Gosu::Image.new(self, "media/space.png", true)

    @player = Player.new(self)
    @player.warp(320, 240)

    @star_anim = Gosu::Image::load_tiles(self, "media/star.png", 25, 25, false)
    # @star_anim = Gosu::Image::load_tiles(self, "media/rockets.png", 15, 15, false)
    @stars = Array.new

    @rocket_anim = Gosu::Image::load_tiles(self, "media/rockets.png", 15, 15, false)

    @font = Gosu::Font.new(self, Gosu::default_font_name, 20)
  end

  def update
    reset
    if button_down? Gosu::KbLeft or button_down? Gosu::GpLeft then
      @player.turn_left
    end
    if button_down? Gosu::KbRight or button_down? Gosu::GpRight then
      @player.turn_right
    end
    if button_down? Gosu::KbUp or button_down? Gosu::GpButton0 then
      @player.accelerate
      @rocket = Rocket.new(@rocket_anim)
    end
    @player.move
    @player.collect_stars(@stars)
    if rand(100) < 4 and @stars.size < 25 then
      @stars.push(Star.new(@star_anim))
    end
  end

  def reset
    @rocket = nil
  end

  def draw
    @player.draw
    @background_image.draw(0, 0, 0)
    @stars.each { |star| star.draw }
    @rocket.draw(@player) unless @rocket.nil?
    @font.draw("Score: #{@player.score}", 10, 10, ZOrder::UI, 1.0, 1.0, 0xffffff00)
  end

  def button_down(id)
    if id == Gosu::KbEscape
      close
    end
  end
end

module ZOrder
  Background, Stars, Player, UI = *0..3
end

window = First.new
window.show