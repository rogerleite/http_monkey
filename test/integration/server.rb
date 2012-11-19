require "test_helper"

# Inspiration from https://github.com/djanowski/mock-server
class IntegrationServer

  def initialize(app)
    @app = app
  end

  def start(host = "localhost", port = 4000)
    puts "== Starting #{@app.inspect}"
    @pid_server = fork do
      silence_output do  # comment this if you want information
        Rack::Server.start(
          :app => @app,
          :server => 'webrick',
          :environment => :none,
          :daemonize => false,
          :Host => host,
          :Port => port
        )
      end
    end
    wait_for_service(host, port)
    self
  end

  def shutdown
    puts "== Stopping #{@app.inspect}\n\n"
    Process.kill(:INT, @pid_server) # send ctrl+c to webrick
    Process.waitpid(@pid_server) # waiting his life go to void ...
  end

  protected

  # quick and dirty
  def silence_output
    $stdout = File.new('/dev/null', 'w')
    $stderr = File.new('/dev/null', 'w')
    yield
  ensure
    $stdout = STDOUT
    $stderr = STDERR
  end

  def listening?(host, port)
    begin
      socket = TCPSocket.new(host, port)
      socket.close unless socket.nil?
      true
    rescue Errno::ECONNREFUSED,
      Errno::EBADF,           # Windows
      Errno::EADDRNOTAVAIL    # Windows
      false
    end
  end

  def wait_for_service(host, port, timeout = 5)
    start_time = Time.now

    until listening?(host, port)
      if timeout && (Time.now > (start_time + timeout))
        raise SocketError.new("Socket did not open within #{timeout} seconds")
      end
    end

    true
  end

end

class IntegrationServer::InspectEnv
  def initialize(app)
    @app = app
  end
  def call(env)
    puts "-> #{env.inspect}"
    @app.call(env)
  end
end
