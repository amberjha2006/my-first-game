extends Node

signal dialogue_response(success: bool, reply: String, npc_id: String)

@export var server_url: String = "http://127.0.0.1:8000"

func request_npc_dialogue(
    npc_id: String,
    player_message: String,
    npc_state: Dictionary,
    case_context: Dictionary,
    discovered_clues: Array
) -> void:
    var http_request = HTTPRequest.new()
    add_child(http_request)

    http_request.request_completed.connect(
        _on_request_completed.bind(npc_id)
    )

    var headers = [
        "Content-Type: application/json"
    ]

    var payload = {
        "npc_id": npc_id,
        "player_message": player_message,
        "npc_state": npc_state,
        "case_context": case_context,
        "discovered_clues": discovered_clues
    }

    var body = JSON.stringify(payload)

    var error = http_request.request(
        server_url + "/npc/dialogue",
        headers,
        HTTPClient.METHOD_POST,
        body
    )

    if error != OK:
        emit_signal("dialogue_response", false, "Request failed", npc_id)
        http_request.queue_free()


func _on_request_completed(
    result: int,
    response_code: int,
    headers: PackedStringArray,
    body: PackedByteArray,
    npc_id: String
) -> void:
    if result != HTTPRequest.RESULT_SUCCESS:
        emit_signal("dialogue_response", false, "Request failed", npc_id)
        return

    if response_code != 200:
        print("Server error: " + str(response_code))
        emit_signal("dialogue_response", false, "Server error", npc_id)
        return

    var parsed = JSON.parse_string(body.get_string_from_utf8())

    if parsed is Dictionary:
        emit_signal(
            "dialogue_response",
            true,
            str(parsed.get("reply", "")),
            str(parsed.get("npc_id", npc_id))
        )
    else:
        print("Failed to parse response")
        emit_signal("dialogue_response", false, "Invalid response", npc_id)
