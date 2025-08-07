#!/bin/bash

while IFS= read -rd ''; do
   targets+=("$REPLY")
done < <(grep -iRlw --null "spi_engine_create" .)

# check content of array
declare -p targets

for file in "${targets[@]}"; do
	folders+=$(dirname "$file" | cut -d/ -f2)
done

echo $folders[0]
echo $folders[1]

for index in "${!folders[@]}"; do
	echo "$index ${fds[index]}"
done
