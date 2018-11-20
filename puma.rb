#!/usr/bin/env puma

environment 'production'

workers 4

pidfile '.pids/pte.pid'
state_path '.pids/pte.state'
stdout_redirect '.pids/stdout', '.pids/stderr', true

bind 'tcp://0.0.0.0:3000'
preload_app!
