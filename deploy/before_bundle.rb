on_app_servers do
  run "ln -nfs #{config.shared_path}/plugins #{config.release_path}/plugins"
end
