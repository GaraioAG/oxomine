# Symlink shared dirs
on_app_servers do
  run "ln -nfs #{shared_path}/plugins #{release_path}/plugins"
  run "ln -nfs #{shared_path}/files #{release_path}/files"
  run "ln -nfs #{shared_path}/plugin_assets #{release_path}/public/plugin_assets"
  run "ln -nfs #{shared_path}/configuration.yml #{release_path}/config/configuration.yml"
  run "ln -nfs #{shared_path}/secret_token.rb #{release_path}/config/initializers/secret_token.rb"
end
