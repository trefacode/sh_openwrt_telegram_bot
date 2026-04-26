#func telegram
#!/bin/sh

#function send_message / arg 1) chat_id 2) text
telegram_send_message() {
    curl -k -s -X POST -H "Charset: UTF-8" $tg_api/bot$tg_token/sendMessage -d chat_id=$1 -d parse_mode=Markdown --data-urlencode text="$2"
}
#function send_replykeyboard / arg 1) chat_id 2) keyboard 3) text
telegram_send_replykeyboard() {
    curl -k -s -X POST -H "Charset: UTF-8" $tg_api/bot$tg_token/sendMessage -d chat_id=$1 -d reply_markup="$2" -d parse_mode=Markdown --data-urlencode text="$3"
}
#function send_inlinekeyboard / arg 1) chat_id 2) keyboard 3) text
telegram_send_inlinekeyboard() {
    curl -k -s -X POST -H "Charset: UTF-8" $tg_api/bot$tg_token/sendMessage -d chat_id=$1 -d reply_markup="$2" -d parse_mode=Markdown --data-urlencode text="$3"
}
#function send_photo / arg 1) chat_id 2) URL photo
telegram_send_photo() {
    curl -k -s -X POST -H "Charset: UTF-8" $tg_api/bot$tg_token/sendPhoto -d chat_id=$1 -d photo="$2" 
}
#function delete_message / arg 1) chat_id 2) id_message
telegram_delete_message() {
    curl -k -s -X POST -H "Charset: UTF-8" $tg_api/bot$tg_token/deleteMessage -d chat_id=$1 -d message_id="$2" 
}
#function delete_messages / arg 1) chat_id 2) id_messages (array)
telegram_delete_messages() {
    curl -k -s -X POST -H "Charset: UTF-8" $tg_api/bot$tg_token/deleteMessages -d chat_id=$1 -d message_ids="$2" 
}
#function read_message / arg 1) offset
telegram_read_message() {
    printf "%s" "$(curl -s -k -X GET $tg_api/bot$tg_token/getUpdates -d offset=$1)"
}
#function read_message_ok? / arg 1) jsonObject
telegram_read_message_ok?() {
    json_init
    json_load "$1"
    json_get_var ok "ok"
    if [[ $ok = 1 ]]; then
            printf "%s" true
        else
            printf "%s" false
    fi
}

telegram_read_message_last_update_id?() {
    json_init
    json_load "$1"
    json_select result
    local id=1
    while json_is_a $id object; do
        json_select $id
        id=$((id + 1))
        json_select ..
    done
    json_select $((id - 1))
    json_get_var upd "update_id"
    printf "%s" $(($upd + 1)) #jsonfilter
}
# telegram object
telegram_check_message_update?() {
    json_init
    json_load $1
    json_get_var result "result"
    if [[ $result != J_A1 ]]; then
            printf "%s" true
        else
            printf "%s" false
    fi
}

telegram_check_callback() {
    json_init
    json_load "$1"
    json_select result
    json_select 1
    json_get_var callback_query "callback_query"
    if [[ -z $callback_query ]]; then
            printf "%s" false
        else
            printf "%s" true
    fi
}

telegram_get_object_callback() {
    json_init
    json_load "$1"
    json_select result
    json_select 1
    json_get_var update_id "update_id"
    json_select callback_query
    json_get_var data "data"
    json_select message
    json_get_var message_id "message_id"
    json_select chat
    json_get_var chat_id "id"
    local var="$2"
    printf "%s" "${!var}"
}

telegram_get_object_message() {
    json_init
    json_load "$1"
    json_select result
    json_select 1
    json_get_var update_id "update_id"
    json_select message
    json_get_var message_id "message_id"
    json_select chat
    json_get_var chat_id "id"
    json_select ..
    json_get_var text "text"
    local var="$2"
    printf "%s" "${!var}"
}

