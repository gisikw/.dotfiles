id=$(xinput --list --id-only 'Elan Touchpad')
devEnabled=$(xinput --list-props $id | awk '/Device Enabled/{print !$NF}')
xinput --set-prop $id 'Device Enabled' $devEnabled
