#func process
#!/bin/sh

process_check_update () {
    while true; do
        local message=$(telegram_read_message $tg_offset)
        if $(telegram_read_message_ok? "$message"); then
            if $(telegram_check_message_update? "$message"); then
                if $(telegram_check_callback "$message"); then
                        local update_id=$(telegram_get_object_callback "$message" "update_id")
                        if [[ $tg_offset != $update_id ]]; then
                            tg_offset=$update_id
                        fi
                        tg_offset=$((tg_offset + 1))
                        local user_id=$(telegram_get_object_callback "$message" "chat_id")
                        local data=$(telegram_get_object_callback "$message" "data")
                        if $(_process_check_user_id "$user_id"); then
                            if [[ $(type -t "buttons_$data") == "function" ]]; then
                                    "buttons_$data" "$user_id"
                                else
                                    telegram_send_message "$user_id" "$(messages_bot_button_error)"
                            fi
                        fi
                    else
                        local update_id=$(telegram_get_object_message "$message" "update_id")
                        if [[ $tg_offset != $update_id ]]; then
                            tg_offset=$update_id
                        fi
                        tg_offset=$((tg_offset + 1))
                        local user_id=$(telegram_get_object_message "$message" "chat_id")
                        local text=$(telegram_get_object_message "$message" "text")
                        if $(_process_check_user_id "$user_id"); then
                            if [[ $(type -t "commands_$text") == "function" ]]; then
                                    "commands_$text" "$user_id"
                                else
                                    telegram_send_message "$user_id" "$(messages_bot_command_error)"
                            fi
                        else
                            telegram_send_message "$user_id" "$(message_bot_no_user_chat_id)"
                        fi
                fi
            fi
        fi
        sleep 1
    done
}

_process_check_user_id () {
    local result=false
    for item in "${tg_chat_id[@]}"; do
        if [[ $1 = $item ]]; then
            result=true
        fi
    done
    printf "%s" "$result"
}

