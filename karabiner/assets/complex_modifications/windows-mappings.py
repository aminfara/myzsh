# https://support.microsoft.com/en-us/windows/keyboard-shortcuts-in-windows-dcc61a57-8ff0-cffe-9796-cb9706c75eec

import json

from utils import co, fk, tk, mp, rules

rules = rules(
    {
        "Copy, paste, and other general keyboard shortcutes": [
            # ------------------------------------------------------------------
            # cut
            mp(
                fk("x", ["control"]),
                [tk("x", ["right_command"])],
                [co("unless_terminals")],
            ),
            mp(
                fk("x", ["control", "shift"]),
                [tk("x", ["right_command"])],
                [co("if_terminals")],
            ),
            mp(fk("x", ["command"]), [tk("vk_none")]),
            # ------------------------------------------------------------------
            # copy
            mp(
                fk("c", ["control"]),
                [tk("c", ["right_command"])],
                [co("unless_terminals")],
            ),
            mp(
                fk("c", ["control", "shift"]),
                [tk("c", ["right_command"])],
                [co("if_terminals")],
            ),
            mp(fk("c", ["command"]), [tk("vk_none")]),
            # ------------------------------------------------------------------
            # paste
            mp(
                fk("v", ["control"]),
                [tk("v", ["right_command"])],
                [co("unless_terminals")],
            ),
            mp(
                fk("v", ["control", "shift"]),
                [tk("v", ["right_command"])],
                [co("if_terminals")],
            ),
            mp(fk("v", ["command"]), [tk("vk_none")]),
            # ------------------------------------------------------------------
            # undo
            mp(
                fk("z", ["control"]),
                [tk("z", ["right_command"])],
                [co("unless_terminals")],
            ),
            mp(fk("z", ["command"]), [tk("vk_none")]),
            # ------------------------------------------------------------------
            # switch apps
            mp(fk("tab", ["option"]), [tk("tab", ["right_command"])]),
            mp(fk("tab", ["command"]), [tk("vk_none")]),
            # ------------------------------------------------------------------
            # close active app
            mp(fk("f4", ["option"]), [tk("q", ["right_command"])]),
            mp(fk("q", ["control"]), [tk("q", ["right_command"])]),
            # ------------------------------------------------------------------
            # lock
            mp(
                fk("l", ["command"]),
                [
                    tk(
                        "q",
                        ["right_command", "right_control"],
                    )
                ],
            ),
            mp(fk("q", ["command"], ["control"]), [tk("vk_none")]),
            # ------------------------------------------------------------------
            # show desktop
            mp(fk("d", ["command"]), [tk("f11")]),
        ]
    }
)

if __name__ == "__main__":
    print(json.dumps(rules, indent=2))
