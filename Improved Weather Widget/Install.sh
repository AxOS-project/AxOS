######################################################################################################################################
sudo mv /usr/share/sleex/services/Weather.qml /usr/share/sleex/services/Weather.qml.bak
sudo curl -L "https://raw.githubusercontent.com/Abscissa24/Utilities/main/Assets/Weather.qml" -o /usr/share/sleex/services/Weather.qml
sudo sh -c 'echo "New-York" > /usr/share/sleex/services/Weather.txt'
######################################################################################################################################