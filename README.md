# 🎨 Palette Swapper Plugin (Godot 4.4)

A Godot 4.4 editor plugin that lets you **swap colors in textures** (like palette swapping in classic games).
You can preview swaps in real-time using a shader and then **bake/export** the modified texture as a new file.

---

## ✨ Features

* Pick any **Texture2D** from the editor using a resource picker.
* Select a **target color** and a **replacement color**.
* Adjust a **tolerance** value to control how close colors need to be to match.
* Real-time preview of changes inside a dock panel (shader-based).
* Bake/export the final modified texture as a new `.png` file.
* Editor FileSystem refresh + cache busting, so your new file appears immediately.

---

## 🚀 Installation

1. Download the plugin from the releases and add the folder into your project under the addons folder `res://addons/palette_swapper/`.
2. In the Godot editor, go to **Project > Project Settings > Plugins** and enable **Palette Swapper**.
3. The plugin will add a new dock panel to your editor.

---

## 🖌️ Usage

1. Open the **Palette Swapper Dock**.
2. Select a texture using the resource picker.
3. Choose:

   * **Target Color** → the color you want to replace.
   * **Replace Color** → the color you want to swap in.
   * **Tolerance** → how exact the color match must be.
4. Preview updates in real-time.
5. Click **Bake & Save** to export a new texture file (e.g. `res://swapped_output.png`).
6. The new texture will appear in your **FileSystem dock** immediately and is reloaded from disk.
7. If you feel like editing the colors of the whole image, use the full HSV sliders.


---

## 🤝 Contributing

PRs and feature requests are welcome!
Please test changes in **Godot 4.4** before submitting.

---

## 📜 License

MIT License — free to use, modify, and distribute.
