#!/usr/bin/env puma

environment 'production'
daemonize true

workers 3

pidfile '.pids/pte.pid'
state_path '.pids/pte.state'
stdout_redirect '.pids/stdout', '.pids/stderr', true

bind 'tcp://127.0.0.1:3000'
preload_app!
