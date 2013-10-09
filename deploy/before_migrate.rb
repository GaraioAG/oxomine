# Symlink shared dirs
on_app_servers do
  run "ln -nfs #{config.shared_path}/plugins #{config.release_path}/plugins"
  run "ln -nfs #{config.shared_path}/files #{config.release_path}/files"
  run "ln -nfs #{config.shared_path}/plugin_assets #{config.release_path}/public/plugin_assets"
  run "ln -nfs #{config.shared_path}/configuration.yml #{config.release_path}/config/configuration.yml"
  run "ln -nfs #{config.shared_path}/secret_token.rb #{config.release_path}/config/initializers/secret_token.rb"
  run "ln -nfs #{config.shared_path}/openid.rb #{config.release_path}/config/initializers/openid.rb"
end
