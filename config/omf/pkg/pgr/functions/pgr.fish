function pgr -d "pg_restore local"
  echo "*** BEGIN ***"
  set -l backup_file latest.dump
  set -l db_name $argv[1]
  set -l cmd "pg_restore --verbose --clean --no-acl --no-owner -h localhost -U (whoami) -d $db_name $backup_file"

  echo "*** Executing cmd: '$cmd' ***"
  eval $cmd
  set -l backup_dest_file "tmp/backup/"$db_name"_"(date +%Y%m%d)".dump"
  echo "*** Backing db dump to: $backup_dest_file***"
  mkdir -p tmp/backup
  mv $backup_file $backup_dest_file
  echo "*** END ***"
end
