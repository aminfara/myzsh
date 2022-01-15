terminals = ["^com\\.apple\\.Terminal$", "^com\\.googlecode\\.iterm2$"]
finder = ["^com\\.apple\\.finder$"]


def co(condition):
    return {
        "if_terminals": {
            "type": "frontmost_application_if",
            "bundle_identifiers": terminals,
        },
        "unless_terminals": {
            "type": "frontmost_application_unless",
            "bundle_identifiers": terminals,
        },
        "if_finder": {
            "type": "frontmost_application_if",
            "bundle_identifiers": finder,
        },
    }.get(condition)


def fk(key, mandatory=None, optional=None):
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


def tk(key, modifiers=None):
    key_to_return = {"key_code": key}

    if modifiers:
        key_to_return["modifiers"] = modifiers

    return {"to": [key_to_return]}


def mp(fk, tks, conditions=None):
    to_statements = {}

    for tk in tks:
        for k, v in tk.items():
            to_statements[k] = to_statements.get(k, []) + v

    mapping_to_return = {
        "type": "basic",
        **fk,
        **to_statements,
    }

    if conditions:
        mapping_to_return["conditions"] = conditions

    return mapping_to_return


def rules(mappings):
    rules_to_return = []
    for k, v in mappings.items():
        rules_to_return.append({"description": k, "manipulators": [m for m in v]})

    return {"rules": rules_to_return}
