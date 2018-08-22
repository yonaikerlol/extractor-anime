#!/bin/bash

###### Information #######
# Script for Bash, for extrancting links of anime from jkanime.net
# By @yonaikerlol



####### CONFIG #########

# Episodes
episodes=$2

# Name of anime (http://jkanime.net/{anime})
anime="${1}"


####### END CONFIG ##########


green="\e[32m"
normal="\e[0m"
underlined="\e[4m"
red="\e[31m"

clear
echo "
 _______  __   __  _______  ______    _______  _______  _______  _______  ______
|       ||  |_|  ||       ||    _ |  |   _   ||       ||       ||       ||    _ |
|    ___||       ||_     _||   | ||  |  |_|  ||       ||_     _||   _   ||   | ||
|   |___ |       |  |   |  |   |_||_ |       ||       |  |   |  |  | |  ||   |_||_
|    ___| |     |   |   |  |    __  ||       ||      _|  |   |  |  |_|  ||    __  |
|   |___ |   _   |  |   |  |   |  | ||   _   ||     |_   |   |  |       ||   |  | |
|_______||__| |__|  |___|  |___|  |_||__| |__||_______|  |___|  |_______||___|  |_|
"

animeName=$(echo "${anime}" | sed 's/-/ /g' | sed -e "s/\b\(.\)/\u\1/g")

if [ -z "${1}" ] || [ -z "${2}" ]; then
	echo -e "Usage: ${0} {anime} {episodes}\nExample: ${0} black-clover-tv 45\n(http://jkanime.net/{anime})"
	exit 0
fi

echo -e "\nExtracting ${underlined}${animeName}:${normal} ( http://jkanime.net/${anime} )\n"

echo "${animeName}:" > .linux-$anime.txt
echo "# ${animeName}:" > .linux-$anime.min.txt

for (( f=1; f <= $episodes; f++ )); do
	echo -n "${f}... "
	html=$(curl -Ls "http://jkanime.net/${anime}/${f}")

	if echo "${html}" | grep 'https://jkanime.net/jkopen.php?u=...........' &> /dev/null; then
		link=$(echo "${html}" | grep 'https://jkanime.net/jkopen.php?u=...........' | sed 's/.*src="//g' | sed 's/".*//g' | sed 's/jkanime.net\/jkopen.php?u=/openload.co\/embed\//g')
	elif echo "${html}" | grep 'https://www.yourupload.com/embed/............' &> /dev/null; then
		link=$(echo "${html}" | grep 'https://yourupload.com/embed/............' | sed 's/.*src="//g' | sed 's/".*//g')
	else
		echo "${f}: " > .linux-$anime.txt
		echo "#" > .linux-$anime.min.txt
		echo -e "${red}NOK!${normal}"
		continue
	fi
	
	echo "${f}: ${link}" >> .linux-$anime.txt
	echo "${link}" >> .linux-$anime.min.txt
	echo -e "${green}OK!${normal} ( ${link} )"
done

sed 's/$'"/`echo \\\r`/" .linux-$anime.txt > windows-$anime.txt
sed 's/$'"/`echo \\\r`/" .linux-$anime.min.txt > windows-$anime.min.txt

mv .linux-$anime.txt linux-$anime.txt &> /dev/null
mv .linux-$anime.min.txt linux-$anime.min.txt &> /dev/null

zip $anime.zip linux-$anime.txt linux-$anime.min.txt windows-$anime.txt windows-$anime.min.txt &> /dev/null

rm linux-$anime.txt &> /dev/null
rm linux-$anime.min.txt &> /dev/null
rm windows-$anime.txt &> /dev/null
rm windows-$anime.min.txt &> /dev/null
