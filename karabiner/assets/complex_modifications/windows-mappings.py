import json

from utils import co, fk, tk, mp, rules

# Each section in the rules is replication of Windows 11 shortcut guide in the link below
# https://support.microsoft.com/en-us/windows/keyboard-shortcuts-in-windows-dcc61a57-8ff0-cffe-9796-cb9706c75eec

rules = rules(
    {
        # --------------------------------------------------------------------------------------------------------------
        "Copy, paste, and other general keyboard shortcutes": [
            # ------------------------------------------------------------------
            # Ctrl + X Cut the selected item.
            mp(
                fk("x", ["control"]),
                [tk("x", ["right_command"])],
                [co("unless_terminals")],
            ),
            # ------------------------------------------------------------------
            # Ctrl + C (or Ctrl + Insert) Copy the selected item.
            mp(
                fk("c", ["control"]),
                [tk("c", ["right_command"])],
                [co("unless_terminals")],
            ),
            mp(
                fk("insert", ["control"]),
                [tk("c", ["right_command"])],
                [co("unless_terminals")],
            ),
            # ------------------------------------------------------------------
            # Ctrl + V (or Shift + Insert) Paste the selected item.
            mp(
                fk("v", ["control"]),
                [tk("v", ["right_command"])],
                [co("unless_terminals")],
            ),
            mp(
                fk("insert", ["shift"]),
                [tk("v", ["right_command"])],
                [co("unless_terminals")],
            ),
            # ------------------------------------------------------------------
            # Ctrl + Z Undo an action.
            mp(
                fk("z", ["control"]),
                [tk("z", ["right_command"])],
                [co("unless_terminals")],
            ),
            # ------------------------------------------------------------------
            # Alt + Tab Switch between open apps.
            mp(fk("tab", ["option"]), [tk("tab", ["right_command"])]),
            # ------------------------------------------------------------------
            # Alt + F4 Close the active item, or exit the active app.
            # Also added Ctrl + Q as it is easier shortcut for closing apps.
            mp(fk("f4", ["option"]), [tk("q", ["right_command"])]),
            mp(fk("q", ["control"]), [tk("q", ["right_command"])]),
            # ------------------------------------------------------------------
            # Win + L Lock your PC.
            # ------------------------------------------------------------------
            # Win + D Display and hide the desktop.
            # ------------------------------------------------------------------
            # F2 Rename the selected item.
            # ------------------------------------------------------------------
            # F3 Search for a file or folder in File Explorer.
            # ------------------------------------------------------------------
            # F4 Display the address bar list in File Explorer.
            # ------------------------------------------------------------------
            # F5 Refresh the active window.
            # ------------------------------------------------------------------
            # F6 Cycle through screen elements in a window or on the desktop.
            # ------------------------------------------------------------------
            # F10 Activate the Menu bar in the active app.
            # ------------------------------------------------------------------
            # Alt + F8 Show your password on the sign-in screen.
            # ------------------------------------------------------------------
            # Alt + Esc Cycle through items in the order in which they were opened.
            # ------------------------------------------------------------------
            # Alt + underlined letter Perform the command for that letter.
            # ------------------------------------------------------------------
            # Alt + Enter Display properties for the selected item.
            # ------------------------------------------------------------------
            # Alt + Spacebar Open the shortcut menu for the active window.
            # ------------------------------------------------------------------
            # Alt + Left arrow Go back.
            # ------------------------------------------------------------------
            # Alt + Right arrow Go forward.
            # ------------------------------------------------------------------
            # Alt + Page Up Move up one screen.
            # ------------------------------------------------------------------
            # Alt + Page Down Move down one screen.
            # ------------------------------------------------------------------
            # Ctrl + F4 Close the active document (in apps that are full-screen and let you have multiple documents open at the same time).
            # ------------------------------------------------------------------
            # Ctrl + A Select all items in a document or window.
            # ------------------------------------------------------------------
            # Ctrl + D (or Delete) Delete the selected item and move it to the Recycle Bin.
            # ------------------------------------------------------------------
            # Ctrl + E Open Search (in most apps).
            # ------------------------------------------------------------------
            # Ctrl + R (or F5) Refresh the active window.
            # ------------------------------------------------------------------
            # Ctrl + Y Redo an action.
            # ------------------------------------------------------------------
            # Ctrl + Right arrow Move the cursor to the beginning of the next word.
            # ------------------------------------------------------------------
            # Ctrl + Left arrow Move the cursor to the beginning of the previous word.
            # ------------------------------------------------------------------
            # Ctrl + Down arrow Move the cursor to the beginning of the next paragraph.
            # ------------------------------------------------------------------
            # Ctrl + Up arrow Move the cursor to the beginning of the previous paragraph.
            # ------------------------------------------------------------------
            # Ctrl + Alt + Tab Use the arrow keys to switch between all open apps.
            # ------------------------------------------------------------------
            # Alt + Shift + arrow keys When a group or tile is in focus on the Start menu, move it in the direction specified.
            # ------------------------------------------------------------------
            # Ctrl + Shift + arrow keys When a tile is in focus on the Start menu, move it into another tile to create a folder.
            # ------------------------------------------------------------------
            # Ctrl + arrow keys Resize the Start menu when it's open.
            # ------------------------------------------------------------------
            # Ctrl + arrow key (to move to an item) + Spacebar Select multiple individual items in a window or on the desktop.
            # ------------------------------------------------------------------
            # Ctrl + Shift with an arrow key Select a block of text.
            # ------------------------------------------------------------------
            # Ctrl + Esc Open Start.
            # ------------------------------------------------------------------
            # Ctrl + Shift + Esc Open Task Manager.
            # ------------------------------------------------------------------
            # Ctrl + Shift Switch the keyboard layout when multiple keyboard layouts are available.
            # ------------------------------------------------------------------
            # Ctrl + Spacebar Turn the Chinese input method editor (IME) on or off.
            # ------------------------------------------------------------------
            # Shift + F10 Display the shortcut menu for the selected item.
            # ------------------------------------------------------------------
            # Shift with any arrow key Select more than one item in a window or on the desktop, or select text in a document.
            # ------------------------------------------------------------------
            # Shift + Delete Delete the selected item without moving it to the Recycle Bin first.
            # ------------------------------------------------------------------
            # Right arrow Open the next menu to the right, or open a submenu.
            # ------------------------------------------------------------------
            # Left arrow Open the next menu to the left, or close a submenu.
            # ------------------------------------------------------------------
            # Esc Stop or leave the current task.
            # ------------------------------------------------------------------
            # PrtScn Take a screenshot of your whole screen and copy it to the clipboard.
        ],
        # --------------------------------------------------------------------------------------------------------------
        "Windows logo keyboard shortcuts": [
            # ------------------------------------------------------------------
            # Win Open or close Start.
            # ------------------------------------------------------------------
            # Win + A Open Quick Settings. Updated in Windows 11.
            # ------------------------------------------------------------------
            # Win + B Set focus to the first icon in the Taskbar corner.
            # ------------------------------------------------------------------
            # Win + C Open Chat from Microsoft Teams. Updated in Windows 11.
            # ------------------------------------------------------------------
            # Win + Shift + C Open the charms menu.
            # ------------------------------------------------------------------
            # Win + Ctrl + C Turn on color filters (enable this shortcut first in Color Filter settings).
            # ------------------------------------------------------------------
            # Win + D Display and hide the desktop.
            mp(fk("d", ["command"]), [tk("f11")]),
            # ------------------------------------------------------------------
            # Win + E Open File Explorer.
            # ------------------------------------------------------------------
            # Win + F Open Feedback Hub and take a screenshot.
            # ------------------------------------------------------------------
            # Win + G Open Xbox Game Bar when a game is open.
            # ------------------------------------------------------------------
            # Win + Alt + B Turn HDR on or off.
            # ------------------------------------------------------------------
            # Win + H Launch voice typing. Updated in Windows 11.
            # ------------------------------------------------------------------
            # Win + I Open Settings.
            # ------------------------------------------------------------------
            # Win + J Set focus to a Windows tip when one is available.
            # ------------------------------------------------------------------
            # Win + K Open Cast from Quick Settings. Updated in Windows 11.
            # ------------------------------------------------------------------
            # Win + L Lock your PC or switch accounts.
            mp(
                fk("l", ["command"]),
                [
                    tk(
                        "q",
                        ["right_command", "right_control"],
                    )
                ],
            ),
            # ------------------------------------------------------------------
            # Win + M Minimize all windows.
            # ------------------------------------------------------------------
            # Win + Shift + M Restore minimized windows on the desktop.
            # ------------------------------------------------------------------
            # Win + N Open notification center and calendar. Updated in Windows 11.
            # ------------------------------------------------------------------
            # Win + O Lock device orientation.
            # ------------------------------------------------------------------
            # Win + P Choose a presentation display mode.
            # ------------------------------------------------------------------
            # Win + Ctrl + Q Open Quick Assist.
            # ------------------------------------------------------------------
            # Win + R Open the Run dialog box.
            # ------------------------------------------------------------------
            # Win + Alt + R Record video of game window in focus (using Xbox Game Bar).
            # ------------------------------------------------------------------
            # Win + S Open search.
            # ------------------------------------------------------------------
            # Win + Shift + S Take a screenshot of part of your screen.
            # ------------------------------------------------------------------
            # Win + T Cycle through apps on the taskbar.
            # ------------------------------------------------------------------
            # Win + U Open Accessibility Settings.
            # ------------------------------------------------------------------
            # Win + V Open the clipboard history.
            # ------------------------------------------------------------------
            # Win + Shift + V Set focus to a notification.
            # ------------------------------------------------------------------
            # Win + W Open Widgets. Updated in Windows 11.
            # ------------------------------------------------------------------
            # Win + X Open the Quick Link menu.
            # ------------------------------------------------------------------
            # Win + Y Switch input between Windows Mixed Reality and your desktop.
            # ------------------------------------------------------------------
            # Win + Z Open the snap layouts. Updated in Windows 11.
            # ------------------------------------------------------------------
            # Win + period (.) or semicolon (;) Open emoji panel.
            # ------------------------------------------------------------------
            # Win + comma (,) Temporarily peek at the desktop.
            # ------------------------------------------------------------------
            # Win + Pause Opens Settings  > System   > About.
            # ------------------------------------------------------------------
            # Win + Ctrl + F Search for PCs (if you're on a network).
            # ------------------------------------------------------------------
            # Win + number Open the desktop and start the app pinned to the taskbar in the position indicated by the number. If the app is already running, switch to that app.
            # ------------------------------------------------------------------
            # Win + Shift + number Open the desktop and start a new instance of the app pinned to the taskbar in the position indicated by the number.
            # ------------------------------------------------------------------
            # Win + Ctrl + number Open the desktop and switch to the last active window of the app pinned to the taskbar in the position indicated by the number.
            # ------------------------------------------------------------------
            # Win + Alt + number Open the desktop and open the Jump List for the app pinned to the taskbar in the position indicated by the number.
            # ------------------------------------------------------------------
            # Win + Ctrl + Shift + number Open the desktop and open a new instance of the app located at the given position on the taskbar as an administrator.
            # ------------------------------------------------------------------
            # Win + Tab Open Task view.
            # ------------------------------------------------------------------
            # Win + Up arrow Maximize the window.
            # ------------------------------------------------------------------
            # Win + Alt + Up arrow Snap window in focus to top half of screen. New with Windows 11.
            # ------------------------------------------------------------------
            # Win + Down arrow Remove current app from screen or minimize the desktop window.
            # ------------------------------------------------------------------
            # Win + Alt + Down arrow Snap window in focus to bottom half of screen. New with Windows 11.
            # ------------------------------------------------------------------
            # Win + Left arrow Maximize the app or desktop window to the left side of the screen.
            # ------------------------------------------------------------------
            # Win + Right arrow Maximize the app or desktop window to the right side of the screen.
            # ------------------------------------------------------------------
            # Win + Home Minimize all except the active desktop window (restores all windows on second stroke).
            # ------------------------------------------------------------------
            # Win + Shift + Up arrow Stretch the desktop window to the top and bottom of the screen.
            # ------------------------------------------------------------------
            # Win + Shift + Down arrow Restore/minimize active desktop windows vertically, maintaining width.
            # ------------------------------------------------------------------
            # Win + Shift + Left arrow or Right arrow Move an app or window in the desktop from one monitor to another.
            # ------------------------------------------------------------------
            # Win + Shift + Spacebar Cycle backwards through language and keyboard layout.
            # ------------------------------------------------------------------
            # Win + Spacebar Switch input language and keyboard layout.
            # ------------------------------------------------------------------
            # Win + Ctrl + Spacebar Change to a previously selected input.
            # ------------------------------------------------------------------
            # Win + Ctrl + Enter Turn on Narrator.
            # ------------------------------------------------------------------
            # Win + Plus (+) Open Magnifier and zoom in.
            # ------------------------------------------------------------------
            # Win + Minus (-) Zoom out in Magnifier.
            # ------------------------------------------------------------------
            # Win + Esc Close Magnifier.
            # ------------------------------------------------------------------
            # Win + forward slash (/) Begin IME reconversion.
            # ------------------------------------------------------------------
            # Win + Ctrl + Shift + B Wake PC from blank or black screen.
            # ------------------------------------------------------------------
            # Win + PrtScn Save full screen screenshot to file.
            # ------------------------------------------------------------------
            # Win + Alt + PrtScn Save screenshot of game window in focus to file (using Xbox Game Bar).
        ],
        # --------------------------------------------------------------------------------------------------------------
        "Command Prompt keyboard shortcuts": [
            # ------------------------------------------------------------------
            # Ctrl + C (or Ctrl + Insert) Copy the selected text.
            mp(
                fk("x", ["control", "shift"]),
                [tk("x", ["right_command"])],
                [co("if_terminals")],
            ),
            mp(
                fk("c", ["control", "shift"]),
                [tk("c", ["right_command"])],
                [co("if_terminals")],
            ),
            mp(
                fk("v", ["control", "shift"]),
                [tk("v", ["right_command"])],
                [co("if_terminals")],
            ),
            # ------------------------------------------------------------------
            # Ctrl + V (or Shift + Insert) Paste the selected text.
            # ------------------------------------------------------------------
            # Ctrl + M Enter Mark mode.
            # ------------------------------------------------------------------
            # Alt + selection key Begin selection in block mode.
            # ------------------------------------------------------------------
            # Arrow keys Move the cursor in the direction specified.
            # ------------------------------------------------------------------
            # Page up Move the cursor by one page up.
            # ------------------------------------------------------------------
            # Page down Move the cursor by one page down.
            # ------------------------------------------------------------------
            # Ctrl + Home (Mark mode) Move the cursor to the beginning of the buffer.
            # ------------------------------------------------------------------
            # Ctrl + End (Mark mode) Move the cursor to the end of the buffer.
            # ------------------------------------------------------------------
            # Ctrl + Up arrow Move up one line in the output history.
            # ------------------------------------------------------------------
            # Ctrl + Down arrow Move down one line in the output history.
            # ------------------------------------------------------------------
            # Ctrl + Home (History navigation) If the command line is empty, move the viewport to the top of the buffer. Otherwise, delete all the characters to the left of the cursor in the command line.
            # ------------------------------------------------------------------
            # Ctrl + End (History navigation)If the command line is empty, move the viewport to the command line. Otherwise, delete all the characters to the right of the cursor in the command line.
        ],
        # --------------------------------------------------------------------------------------------------------------
        "Dialog box keyboard shortcuts": [
            # ------------------------------------------------------------------
            # F4 Display the items in the active list.
            # ------------------------------------------------------------------
            # Ctrl + Tab Move forward through tabs.
            # ------------------------------------------------------------------
            # Ctrl + Shift + Tab Move back through tabs.
            # ------------------------------------------------------------------
            # Ctrl + number (number 1–9) Move to nth tab.
            # ------------------------------------------------------------------
            # Tab Move forward through options.
            # ------------------------------------------------------------------
            # Shift + Tab Move back through options.
            # ------------------------------------------------------------------
            # Alt + underlined letter Perform the command (or select the option) that is used with that letter.
            # ------------------------------------------------------------------
            # Spacebar Select or clear the check box if the active option is a check box.
            # ------------------------------------------------------------------
            # Backspace Open a folder one level up if a folder is selected in the Save As or Open dialog box.
            # ------------------------------------------------------------------
            # Arrow keys Select a button if the active option is a group of option buttons.
        ],
        # --------------------------------------------------------------------------------------------------------------
        "File Explorer keyboard shortcuts": [
            # ------------------------------------------------------------------
            # Alt + D Select the address bar.
            # ------------------------------------------------------------------
            # Ctrl + E Select the search box.
            # ------------------------------------------------------------------
            # Ctrl + F Select the search box.
            # ------------------------------------------------------------------
            # Ctrl + N Open a new window.
            # ------------------------------------------------------------------
            # Ctrl + W Close the active window.
            # ------------------------------------------------------------------
            # Ctrl + mouse scroll wheel Change the size and appearance of file and folder icons.
            # ------------------------------------------------------------------
            # Ctrl + Shift + E Display all folders above the selected folder.
            # ------------------------------------------------------------------
            # Ctrl + Shift + N Create a new folder.
            # ------------------------------------------------------------------
            # Num Lock + asterisk (*) Display all subfolders under the selected folder.
            # ------------------------------------------------------------------
            # Num Lock + plus (+) Display the contents of the selected folder.
            # ------------------------------------------------------------------
            # Num Lock + minus (-) Collapse the selected folder.
            # ------------------------------------------------------------------
            # Alt + P Display the preview panel.
            # ------------------------------------------------------------------
            # Alt + Enter Open the Properties dialog box for the selected item.
            # ------------------------------------------------------------------
            # Alt + Right arrow View the next folder.
            # ------------------------------------------------------------------
            # Alt + Up arrow View the folder that the folder was in.
            # ------------------------------------------------------------------
            # Alt + Left arrow View the previous folder.
            # ------------------------------------------------------------------
            # Backspace View the previous folder.
            # Right arrow Display the current selection (if it's collapsed), or select the first subfolder.
            # ------------------------------------------------------------------
            # Left arrow Collapse the current selection (if it's expanded), or select the folder that the folder was in.
            # ------------------------------------------------------------------
            # End Display the bottom of the active window.
            # ------------------------------------------------------------------
            # Home Display the top of the active window.
            # ------------------------------------------------------------------
            # F11 Maximize or minimize the active window.
        ],
        # --------------------------------------------------------------------------------------------------------------
        "Virtual desktops keyboard shortcuts": [
            # ------------------------------------------------------------------
            # Win + Tab Open Task view.
            # ------------------------------------------------------------------
            # Win + Ctrl + D Add a virtual desktop.
            # ------------------------------------------------------------------
            # Win + Ctrl + Right arrow Switch between virtual desktops you’ve created on the right.
            # ------------------------------------------------------------------
            # Win + Ctrl + Left arrow Switch between virtual desktops you’ve created on the left.
            # ------------------------------------------------------------------
            # Win + Ctrl + F4 Close the virtual desktop you're using.
        ],
        # --------------------------------------------------------------------------------------------------------------
        "Taskbar keyboard shortcuts": [
            # ------------------------------------------------------------------
            # Shift + click a taskbar button Open an app or quickly open another instance of an app.
            # ------------------------------------------------------------------
            # Ctrl + Shift + click a taskbar button Open an app as an administrator.
            # ------------------------------------------------------------------
            # Shift + right-click a taskbar button Show the window menu for the app.
            # ------------------------------------------------------------------
            # Shift + right-click a grouped taskbar button Show the window menu for the group.
            # ------------------------------------------------------------------
            # Ctrl + click a grouped taskbar button Cycle through the windows of the group.
        ],
        # --------------------------------------------------------------------------------------------------------------
        "Settings keyboard shortcuts": [
            # ------------------------------------------------------------------
            # Win + I Open settings.
            # ------------------------------------------------------------------
            # Backspace Go back to the settings home page.
            # ------------------------------------------------------------------
            # Type on any page with search box Search settings.
        ],
        # --------------------------------------------------------------------------------------------------------------
        "Disable corresponding macOS shortcuts": [
            # ------------------------------------------------------------------
            # Command + Control + Q lock screen
            mp(fk("q", ["command"], ["control"]), [tk("vk_none")]),
        ],
    }
)

if __name__ == "__main__":
    print(json.dumps(rules, indent=2))
