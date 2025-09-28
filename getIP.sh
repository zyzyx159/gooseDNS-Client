# Host address format http://{example.com}:####
#TODO: replace this with read yaml
Host=http://barqu.xyz:8000

#TODO: Do I really still need this? It should throw an error is the setting file is missing.
# If there is no settings.txt file create one
if [ ! -f "settings.txt" ]; then
    touch settings.txt
    echo "empty" > settings.txt
fi

# Current WAN IP address
CurrentIP=$(curl $Host | grep "RemoteAddr:" | grep -oE '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}')
# Look up previous WAN IP address
PreviousIP=$(cat settings.txt) #TODO: This needs to change as well

#compare the two addresses. If they are NOT the same
if [ $CurrentIP != $PreviousIP ]; then
    # Delete the settings file
    rm settings.txt
    # create a new one and record the current WAN IP
    echo $CurrentIP > "settings.txt"
fi