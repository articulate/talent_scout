if RUBY_PLATFORM.downcase.include?("linux") then
  require "headless"
  headless = Headless.new
  headless.start
  at_exit do
    headless.destroy
  end
end
