require 'serverspec'

set :backend, :exec

RSpec.configure do |c|
  c.before :all do
    set :path, '$PATH:/sbin:/usr/local/sbin'
  end

  if ENV['ASK_SUDO_PASSWORD']
    require 'highline/import'
    c.sudo_password = ask('Enter sudo password: ') { |q| q.echo = false }
  else
    c.sudo_password = ENV['SUDO_PASSWORD']
  end
end
