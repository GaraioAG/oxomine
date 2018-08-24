#!/usr/bin/env bash

trap 'exit' ERR

if rake db:version | grep ": 0$"; then
  rake db:setup
else
  rake db:migrate
fi
rails assets:precompile

rails server -p 80
