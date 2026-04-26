#func buttons
#!/bin/sh


buttons_restart_router() {
    telegram_send_message "$1" "test"
}

buttons_script_not_found() {
    echo "_____"
}

buttons_get_info_router() {
    telegram_send_message "$1" "$(neofetch)"
}