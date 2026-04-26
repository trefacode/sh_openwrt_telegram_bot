#func messages
#!/bin/sh

messages_bot_command_error() {
    printf "%s" "Команда не найдена. Попробуй другую команду."
}

messages_bot_button_error() {
    printf "%s" "Такой кнопки нет."
}

messages_bot_start() {
    local text="Бот для управления роутером
Выбери действие для роутера"
    printf "%s" "$text"
}

message_bot_no_user_chat_id() {
    printf "%s" "Вас нет в списке для работы этого бота."
}

message_commands_/alive() {
    printf "%s" "Я работаю"
}
