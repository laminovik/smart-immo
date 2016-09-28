# changed 'blog' into 'smart-immo'
root = "/home/deployer/apps/smart-immo/current"
working_directory root
pid "#{root}/tmp/pids/unicorn.pid"
stderr_path "#{root}/log/unicorn.log"
stdout_path "#{root}/log/unicorn.log"

# changed 'blog' into 'smart-immo'
listen "/tmp/unicorn.smart-immo.sock"
worker_processes 2
timeout 30