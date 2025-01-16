# Tesla BLE Addon 

This is a HomeAssistant addon for communication with Tesla cars over BLE.
It is based on https://github.com/BogdanDIA/tesla-ble.

The addon is meant to be used with `ssh` by defining shell commands in HA configuration.

## **Install and Run**

#### Prerequisites
The SSH server is configured to use a `public key auth` and for that it needs to have access to such public key.
To generate the private/public keys in HA, use ssh-kegen from ssh HA addon cmd line. Place the keys on an accessible directory inside HA e.g. in the following directory:
```
/share/keys/
```

#### Addon repo and build 
In `HA addon page->Add-on Store->kebab menu on upper right corner->Repositories`, add a new repository:
```
https://github.com/BogdanDIA/tesla-ble-addon.git
```

Build the addon

#### Configure the addon
Once build is finished, the addon needs few options to be filled in Configuration tab:
```
- car_vin 
- car_private_key       # absolute path of car's private key, e.g. /share/storage/private_key.pem
- ble_hci_num           # the BT controller(adapter) you want to use, first one is 0.
- ble_command_timeout   # tesla-control command timeout (has a default value)
- ble_connect_timeout   # tesla-control connect timeout (has a default value)
- ssh_public_key        # absolute path of the ssh publik key, e.g. /share/storage/root_ssh.pub 
```

This assumes private/public keys are previously generated for the car and the public key is enrolled in the car. See: https://github.com/teslamotors/vehicle-command/blob/main/README.md 

Run the addon.

## **HowTo use the addon**
In HA configuration.yaml file add an entries for shell commands:

#### HA config.yaml
```
shell_command:
  charging_get_presence: "ssh -i /config/keys/id_rsa2 -o 'UserKnownHostsFile=/config/keys/known.txt' -o 'StrictHostKeyChecking=no' -p 2222 root@fa8a04ce-tesla-ble /root/go/bin/tesla-ble/charging_get_presence.sh"
  charging_get_state: "ssh -i /config/keys/id_rsa2 -o 'UserKnownHostsFile=/config/keys/known.txt' -o 'StrictHostKeyChecking=no' -p 2222 root@fa8a04ce-tesla-ble /root/go/bin/tesla-ble/charging_get_state.sh | jq -e"
```

#### HA automations.yaml or script.yaml
This shows an example of updating a HA toggle helper with car's presence and BLE RSSI value:
```
...
- service: shell_command.charging_get_presence
  response_variable: v_resp_var
  continue_on_error: true
- service_template: >-
    input_boolean.turn_{{ 'on' if (v_resp_var['returncode'] == 0) else 'off' }}
  target:
    entity_id: input_boolean.teslab_ble_presence
- service_template: input_text.set_value
  target:
    entity_id: input_text.teslab_ble_rssi
  data:
    value: "{{ v_resp_var['stdout'] }}"

```
Another example, getting the state of charging cable and battery level (the get_state command returns a JSON giving a lot of info about charging state):

```
...
- service: shell_command.charging_get_state
  response_variable: v_resp_var
  continue_on_error: true
- variables:
    v_chargeState: >-
      {% if (v_resp_var['returncode'] == 0)  %}
        {{ v_resp_var['stdout']|from_json }}
      {% else %}
        {{ 0 }}
      {% endif %}
    continue_on_error: true
- service_template: >-
    input_boolean.turn_{{ 'off' if ((v_resp_var['returncode'] == 0) and (v_chargeState.chargeState.chargingState.Disconnected is defined)) else 'on' }}
  target:
    entity_id: input_boolean.teslab_ble_charger
  continue_on_error: true
- service_template: input_number.set_value
  data_template:
    entity_id: input_number.teslab_ble_battery_level
    value: "{{ v_chargeState.chargeState.batteryLevel if (v_resp_var['returncode'] == 0) else states('input_number.teslab_ble_battery_level')|int(0) }}"
  continue_on_error: true
```

END
