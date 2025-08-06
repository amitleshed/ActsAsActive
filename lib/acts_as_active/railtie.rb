module ActsAsActive
  class Railtie < Rails::Railtie
    initializer "acts_as_active.configure_rails_initialization" do
      ActiveSupport.on_load(:active_record) do
        require "acts_as_active/concern"
        ActiveRecord::Base.include ActsAsActive
      end
    end
  end
end