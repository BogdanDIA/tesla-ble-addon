# Changelog 

## v0.0.3
- updated to use v0.4.0 of vehicle-command.

## v0.0.2
- updated to use v0.3.4 of vehicle-command.
- tesla-control has a parameter to setup the HCI num (id)
- keeps same BT LEinterval (10mS) and LEwindow (10mS) as in v0.0.1

## v0.0.1
- uses v0.3.3 of vehicle-command
- patches vehicle-commnd to work for ESP32
- HCI num (id) e.g. hci1 is transmitted with HCINUM env variable
- implements
  - charging_get_presence.sh
  - charging_get_bcontroller.sh
  - charging_get_state.sh
  - charging_start.sh
  - charging_stop.sh
  - charging_set_amps.sh
  - charging_wake.sh

  
  
