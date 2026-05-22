# MegaManEffect for macOS

## Modern Universal Build

This updated build restores MegaManEffect for modern macOS systems.

- **Supported Macs:** Intel and Apple Silicon
- **Architectures:** `x86_64` and `arm64`
- **Minimum macOS version:** macOS 11 Big Sur
- **Signing:** Ad hoc signed; not notarized

Because this open-source build is not notarized by Apple, macOS may block it on first launch. Attempt to open the app once, then open **System Settings > Privacy & Security** and choose **Open Anyway**.

- [Download the Universal macOS Build]:  See Releases link, v1.1 is current

This modernization branch is based on the original source by Michael Zornek and Rob Smith:

- Original repository: [zorn/MegaManEffect](https://github.com/zorn/MegaManEffect)
- Modernization work: [hexbus](https://github.com/hexbus), May 22, 2026

---

## Original README

The MegaManEffect is an application that emulates an effect seen in the classic NES game *Mega Man 2*. When you launch a Mac OS X application, the screen goes dark, stars sweep the night sky, and your application's icon is presented in a blue letterbox bar with a cheesy 8-bit music introduction.

![MegaManEffect](images/sample_screen.jpg)

MegaManEffect was written while I attended the ADHOC/MacHack conference in 2004 and took second place in the ADHOC Labs Showcase! In the summer of 2005, the application hit a nerve in the community, generating tons of interest and downloads. It is, to this day, one of the most distributed pieces of code I've ever written.

For a while, after various personal site redesigns, the MegaManEffect download page had disappeared. After many, many emails in 2007, I finally put it back online and even upgraded it to a Universal Binary so it runs great on Intel Macs.

- [Download the original MegaManEffect Application](https://github.com/zorn/MegaManEffect/releases/download/1.1/MegaManEffect.app.zip)
- [See MegaManEffect demoed on Attack of the Show](https://www.youtube.com/watch?v=U6q3vfQKTJI)
- [See the original Mega Man 2 game in action](https://www.youtube.com/watch?v=eGDBXnWpvmE)

The source for MegaManEffect is available under a BSD license.

While the app binary still works, the code itself isn't terribly "good." It was written as I was still learning Cocoa in 2004.
