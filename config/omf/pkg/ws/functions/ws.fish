function ws -d "Move to workspace"
  set -l folder ~/workspace/$argv[1]

  echo "*** Moving to $folder ***"
  if test -d $folder
    cd $folder
    echo "*** Moved ***"
    git status
  else
    echo "*** Fail to move ***"
    false
  end
end
