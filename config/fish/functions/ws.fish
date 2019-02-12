function ws -d "Switch between folders" --argument folder
  if test (count $argv) -eq 0
    cd $ws_folder
  else
    cd $ws_folder/$folder
  end
end