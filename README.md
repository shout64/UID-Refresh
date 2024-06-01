TLDR: UID Refresh will fix your "invalid UID" errors in [Godot](https://github.com/godotengine/godot)!

### The Problem
If you use git in your Godot projects and work with others, you may be all too familiar with seeing UID errors in your debug log.
Ultimately this is not a big deal, as Godot will use the text path for your assets instead. However, you don't want to ship with these errors, and manually fixing them will be an annoying pain.
![Example Invalid UID Error](https://github.com/shout64/UID-Refresh/assets/135728867/f9ce7de6-86c4-4ba9-99c0-dec9ddaef499)

### The Solution
**UID Refresh** will look through your error log, find invalid UID errors, then get the correct UID and replace them into your affected TSCN files.

### How to Install and Use

1. Download the addons folder from this repository onto your computer. If your Godot project doesn't have an **addons** folder already, copy the entire **addons** folder into the root of your project. If it does, extract the **UID Refresh** folder and place it into your **addons** folder.

![Project Folder](https://github.com/shout64/UID-Refresh/assets/135728867/bd04f095-cee8-409d-885d-553896b2b119)

2. In Godot, navigate to Project > Project Settings... > Plugins. Enable UID Refresh. *When the plugin is enabled it will turn on logging if it's not already enabled.
![Plugin Enabled](https://github.com/shout64/UID-Refresh/assets/135728867/7c03cd26-9784-4440-99f2-f127459ed5d9)
3. Run UID Refresh by navigating to Project > Tools and clicking UID Refresh. Check your **Output** tab to see which UIDs were updated. *If logging was not previously enabled you will need to run your game at least one time to generate a new log file.
![UID Refresh Tool](https://github.com/shout64/UID-Refresh/assets/135728867/fa6dc109-1c17-44b1-bdc3-a0f7d23a1445)
