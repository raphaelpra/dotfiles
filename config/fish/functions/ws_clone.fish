function ws_clone -d "Clone workspace folders" --argument git_name
  if test (count $argv) -eq 0
    echo "Nothing to clone"
  else
    cd $ws_folder

    git clone git@github.com:$git_name.git
  end
end