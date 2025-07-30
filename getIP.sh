if [ ! -f "settings.txt" ]; then
    touch settings.txt
    echo "empty" > settings.txt
fi

CurrentIP=$(curl http://barqu.xyz:8000 | grep "RemoteAddr:" | grep -oE '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}')
PreviousIP=$(cat settings.txt)

# echo $CurrentIP
# echo $PreviousIP

if [ $CurrentIP != $PreviousIP ]; then
    rm settings.txt
    echo $CurrentIP > "settings.txt"
fi