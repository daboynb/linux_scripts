# Disabling telemetry
echo "Disabling telemetry"
sudo apt remove ubuntu-report whoopsie apport -y

# Prevent telemetry from being reinstalled 

    printf "Package: ubuntu-report\nPin: release a=*\nPin-Priority: -10" >> no-ubuntu-report.pref 
    sudo mv no-ubuntu-report.pref /etc/apt/preferences.d/
    sudo chown root:root /etc/apt/preferences.d/no-ubuntu-report.pref

    printf "Package: whoopsie\nPin: release a=*\nPin-Priority: -10" >> no-whoopsie.pref 
    sudo mv no-whoopsie.pref /etc/apt/preferences.d/
    sudo chown root:root /etc/apt/preferences.d/no-whoopsie.pref

    printf "Package: apport\nPin: release a=*\nPin-Priority: -10" >> no-apport.pref 
    sudo mv no-apport.pref /etc/apt/preferences.d/
    sudo chown root:root /etc/apt/preferences.d/no-apport.pref