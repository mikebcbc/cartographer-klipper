#!/bin/sh
git config --global http.sslVerify false
git clone https://github.com/K1-Klipper/cartographer-klipper.git /usr/data/
chmod +x /usr/cartographer-klipper/install.sh
sh /usr/cartographer-klipper/install.sh
sed -i '/\[gcode_macro START_PRINT\]/,/\[/gcode_macro START_PRINT\]/d' /usr/data/printer_data/config/gcode_macro.cfg
wget --no-check-certificate -P  /usr/data/printer_data/config/ https://github.com/K1-Klipper/cartographer-klipper/raw/master/start_end.cfg
sed -i '/\[include printer_params.cfg\]/a\[include cartographer_macro.cfg]\' /usr/data/printer_config/printer.cfg
if grep -q "include start_macro_KAMP.cfg" /usr/data/printer_config/printer.cfg || grep -q "include start_macro.cfg" /usr/data/printer_config/printer.cfg; then
    sed -i 's/\[include start_(macro|macro_KAMP)\.cfg\]/[include start_stop.cfg]/g' /usr/data/printer_config/printer.cfg
else
    sed -i '/\[include printer_params.cfg\]/a\[start_end.cfg]\' /usr/data/printer_data/config/printer.cfg
fi
mkdir /usr/data/backups/
mv /usr/data/printer_data/config/sensorless.cfg /usr/data/backups/
wget --no-check-certificate -P  /usr/data/printer_data/config/ https://github.com/K1-Klipper/cartographer-klipper/raw/master/sensorless.cfg 
wget --no-check-certificate -P  /usr/data/printer_data/config/ https://raw.githubusercontent.com/K1-Klipper/cartographer-klipper/master/cartographer_macro.cfg
sed '/\[mcu\]/i\[include cartographer_macro.cfg]' /usr/data/printer_data/config/printer.cfg