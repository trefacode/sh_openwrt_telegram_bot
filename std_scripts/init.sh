#func init
#!/bin/sh

init_json_start_menu() {
    json_init
    json_add_array inline_keyboard
    json_start_menu=$(json_dump)
}

_init_json_add_scripts() {
    json_init
    json_load "$json_start_menu"
    json_select "inline_keyboard"
    json_add_array
    json_add_object
    json_add_string text "$1"
    json_add_string callback_data "$2"
    json_add_string style "$3"
    json_start_menu=$(json_dump)
}

_init_check_telegram_val() {
    (
        source "$1"
        if [[ -n "$2" && -n "$3"]]; then
            printf "%s" true
        else
            printf "%s" false
        fi
    )
}

init_telegram_bot () {
    echo "Launching a Telegram bot......"
    echo "Checking the configuration"
}

init_telegram_offset() {
    local first=$(telegram_read_message "$tg_offset")
    if $(telegram_read_message_ok? "$first"); then
            tg_offset=$(telegram_read_message_last_update_id? "$first")
        else
            exit 2
    fi
}

init_search_scripts() {
    echo "Loading scripts."
    find $usr_scripts -type f -name "*.sh" -print0 | while IFS= read -r -d '' file; do
        echo "Find: $file"
        echo "Checking Script Variables"
        if $(_init_check_telegram_val "$file" "") ; then
                source "$file"

            else
                echo "Variables not found. Skipping script."
                continue
        fi
    done
    _init_json_add_scripts "Информация" "get_info_router" "success"
    _init_json_add_scripts "Перезагрузить роутер" "restart_router" "danger"
    echo "Loading complete."
}