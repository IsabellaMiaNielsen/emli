connected() {
    nmcli connection show --active | grep -q "EMLI-TEAM-7" # Returns true if connected, otherwise false
}

while true; do
    if connected; then
        echo "We're still connected, downloading photos"
        ssh -i .ssh/id_ed25519_rpi group7@192.168.10.1 -A
        sleep 10
    else
        echo "We lost connection to the cam. Flying on"
        break
    fi
done

./drone_flight.sh