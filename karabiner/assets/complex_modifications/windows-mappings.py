import json

mappings = {
    "Copy, paste, and other general keyboard shortcutes": [
        # cut
        (("x", ["control"]), ("x", ["right_command"]), ["unless_terminals"]),
        (("x", ["control", "shift"]), ("x", ["right_command"]), ["if_terminals"]),
        (("x", ["command"]), ("vk_none",)),
        # copy
        (("c", ["control"]), ("c", ["right_command"]), ["unless_terminals"]),
        (("c", ["control", "shift"]), ("c", ["right_command"]), ["if_terminals"]),
        (("c", ["command"]), ("vk_none",)),
        # paste
        (("v", ["control"]), ("v", ["right_command"]), ["unless_terminals"]),
        (("v", ["control", "shift"]), ("v", ["right_command"]), ["if_terminals"]),
        (("v", ["command"]), ("vk_none",)),
        # undo
        (("z", ["control"]), ("z", ["right_command"]), ["unless_terminals"]),
        (("z", ["command"]), ("vk_none",)),
        # switch apps
        (("tab", ["option"]), ("tab", ["right_command"])),
        (("tab", ["command"]), ("vk_none",)),
        # close active app
        (("f4", ["option"]), ("q", ["right_command"])),
        (("q", ["control"]), ("q", ["right_command"])),
        # lock
        (
            ("l", ["command"]),
            (
                "q",
                ["right_command", "right_control"],
            ),
        ),
        (("q", ["command"], ["control"]), ("vk_none",)),
        # show desktop
        (("d", ["command"]), ("f11",)),
    ]
}


def get_terminals():
    return ["^com\\.apple\\.Terminal$", "^com\\.googlecode\\.iterm2$"]


def if_terminals():
    return {"type": "frontmost_application_if", "bundle_identifiers": get_terminals()}


def unless_terminals():
    return {
        "type": "frontmost_application_unless",
        "bundle_identifiers": get_terminals(),
    }


def from_key(key, mandatory=None, optional=None):
    key_to_return = {"key_code": key}
    if mandatory:
        key_to_return["modifiers"] = {
            **key_to_return.get("modifiers", {}),
            "mandatory": mandatory,
        }
    if optional:
        key_to_return["modifiers"] = {
            **key_to_return.get("modifiers", {}),
            "optional": optional,
        }
    return {"from": key_to_return}


def to_key(key, modifiers=None):
    key_to_return = {"key_code": key}
    if modifiers:
        key_to_return["modifiers"] = modifiers
    return {"to": [key_to_return]}


def mapping(fk, tk, conditions=None):
    mapping_to_return = {
        "type": "basic",
        **from_key(*fk),
        **to_key(*tk),
    }
    if conditions:
        mapping_to_return["conditions"] = [globals()[c]() for c in conditions]
    return mapping_to_return


def rules():
    rules_to_return = []
    for k, v in mappings.items():
        rules_to_return.append(
            {"description": k, "manipulators": [mapping(*m) for m in v]}
        )

    return {"rules": rules_to_return}


if __name__ == "__main__":
    print(json.dumps(rules(), indent=2))
