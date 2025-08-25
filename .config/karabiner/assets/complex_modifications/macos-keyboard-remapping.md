## Remapping Home/End and Option+Home/End Globally on macOS

To make your Mac behave like Windows everywhere—not just in Slack—so that pressing **Option + Home** takes you to the start of the current line (and similar navigation shortcuts), you can use Karabiner-Elements for global shortcut remapping.

### Steps to Set Up Global Home/End/Option+Home/End Behavior

#### 1. **Install Karabiner-Elements**
- Download and install Karabiner-Elements from its official website.

#### 2. **Create a Global Remapping Rule**
You'll need to define custom rules in JSON format to achieve global remapping. By omitting application-specific conditions, your new shortcuts work across all applications.

Example (remap Option+Home/End and Shift+Option+Home/End globally):

```json
{
  "title": "Global Windows-style Home/End keys",
  "rules": [
    {
      "description": "Option+Home/End and Shift+Option+Home/End to Command+Left/Right Arrow globally",
      "manipulators": [
        {
          "type": "basic",
          "from": {
            "key_code": "home",
            "modifiers": {"mandatory": ["option"]}
          },
          "to": [
            {
              "key_code": "left_arrow",
              "modifiers": ["command"]
            }
          ]
        },
        {
          "type": "basic",
          "from": {
            "key_code": "end",
            "modifiers": {"mandatory": ["option"]}
          },
          "to": [
            {
              "key_code": "right_arrow",
              "modifiers": ["command"]
            }
          ]
        },
        {
          "type": "basic",
          "from": {
            "key_code": "home",
            "modifiers": {"mandatory": ["shift", "option"]}
          },
          "to": [
            {
              "key_code": "left_arrow",
              "modifiers": ["shift", "command"]
            }
          ]
        },
        {
          "type": "basic",
          "from": {
            "key_code": "end",
            "modifiers": {"mandatory": ["shift", "option"]}
          },
          "to": [
            {
              "key_code": "right_arrow",
              "modifiers": ["shift", "command"]
            }
          ]
        }
      ]
    }
  ]
}
```
- You can also remap plain Home/End keys or any combination you prefer[1][2].

#### 3. **Add the Rule to Karabiner-Elements**
- Save the JSON above as a file, e.g., `windows-home-end.json`, in `~/.config/karabiner/assets/complex_modifications/`.
- Open Karabiner-Elements.
- Go to the **Complex Modifications** tab.
- Click **"Add Rule"**, then **"Import"** your new file.
- Click **"Enable"** on your custom rule.

#### 4. **Test Globally**
- Press **Option + Home** or **Option + End** anywhere on your Mac—these shortcuts should now move the cursor to the start/end of the current line, just like on Windows.
- Press **Shift + Option + Home** or **Shift + Option + End** to select text from the cursor to the start/end of the current line.

### Notes and Alternatives

- You can create additional rules for plain Home/End or Shift+Home/End if you want those to match Windows-style selection shortcuts everywhere[3].
- If you want to remap Home/End keys themselves without Option or with other modifiers, add similar blocks for those combinations.
- Advanced users can script larger remapping setups or use tools like Goku for easier config generation[4].

### Key Mapping Table

| Desired Windows Action         | Default macOS Shortcut           | With Karabiner-Elements Rule      |
|-------------------------------|-----------------------------------|-----------------------------------|
| Start of line                 | Command + Left Arrow              | Option + Home (remapped)          |
| End of line                   | Command + Right Arrow             | Option + End (remapped)           |
| Select to start of line       | Shift + Command + Left Arrow      | Shift + Option + Home (remapped)  |
| Select to end of line         | Shift + Command + Right Arrow     | Shift + Option + End (remapped)   |
| Start of document             | Home (varies by app)              | Home (unchanged or remapped)      |
| End of document               | End (varies by app)               | End (unchanged or remapped)       |

Using this approach, you can achieve Windows-style navigation shortcuts throughout your entire macOS experience—not just in Slack or a single app[1][2][3].

[1] https://apple.stackexchange.com/questions/426400/remap-1-key-to-3-keys-in-karabiner-elements
[2] https://apple.stackexchange.com/questions/91949/remap-arrow-key-to-different-shortcut
[3] https://community.folivora.ai/t/make-your-home-and-end-keys-work-like-windows/5046
[4] https://blog.rtwilson.com/karabiner-elements-and-goku-for-custom-keyboard-shortcuts-in-macos/
[5] https://karabiner-elements.pqrs.org/docs/manual/configuration/configure-simple-modifications/
[6] https://github.com/pqrs-org/Karabiner-Elements/issues/808
[7] https://www.reddit.com/r/hackintosh/comments/imudm3/use_karabinerelements_if_you_need_to_remap_your/
[8] https://ke-complex-modifications.pqrs.org
[9] https://stackoverflow.com/questions/63194740/karabiner-elements-map-a-key-to-a-combination-keys
[10] https://discussions.apple.com/thread/251108215
[11] https://www.summarize.tech/www.youtube.com/watch?v=vysHEYTp0H4
[12] https://github.com/pqrs-org/Karabiner-Elements/issues/3940
[13] https://stackoverflow.com/questions/40544704/karabiner-elements-how-to-map-pc-style-home-end-keys
[14] https://www.youtube.com/watch?v=vysHEYTp0H4
[15] https://www.reddit.com/r/Karabiner/comments/13ax4s6/new_to_macos_due_to_a_client_requirement_could/
[16] https://www.reddit.com/r/MacOS/comments/pz9vnu/behavior_of_the_home_and_end_keys/
[17] https://kau.sh/blog/karabiner-kt/
[18] https://apple.stackexchange.com/questions/434991/how-to-remap-left-arrow-%E2%86%90-key-to-ctrl-in-macos-or-iterm2
[19] https://github.com/pqrs-org/Karabiner-Elements/issues/2284
[20] https://stackoverflow.com/questions/69582660/how-to-remap-key-combinations-in-karabiner-elements 