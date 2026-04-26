#func commands
#!/bin/sh

commands_/start() {
    telegram_send_inlinekeyboard "$1" "$json_start_menu" "$(messages_bot_start)"
}

commands_/alive() {
    telegram_send_message "$1" "$(message_commands_/alive)"
}