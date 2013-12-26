for i in $(ls); do mv $i "$(echo $i | cut -d '@' -f1).svg"; done;
