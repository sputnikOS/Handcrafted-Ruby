def ssh
  puts 'SSHing into server'
  system('ssh -p 4444 prometheus@192.81.213.48')
  system('cd /var/www/digitalcosmos.io')
end

ssh
