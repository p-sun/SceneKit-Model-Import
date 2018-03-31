# SceneKit-Model-Import
A small demo showing how to add 3D models (.dae &amp; .scn) in SceneKit for games or AR.

## Where to find 3D models
You can find free VR/Low-poly models at
[cgtrader](https://www.cgtrader.com/free-3d-models?polygons=lt_5k&low_poly=1)
[Google Poly](https://poly.google.com/)
[TurboSquid](https://www.turbosquid.com/Search/3D-Models/free)

## How to Import

### .dae
- Xcode an read this. Just drag it into your `art.scnassets` folder.

### .blend
- If the model in .blend format, open it in [Blender](https://www.blender.org/), and export it as a .dae.
- Create a folder in `art.scnassets`  for your model(s) and texture(s)
- Drag the .dae and the textures (.jpg or .png) into your folder
- If there are textures, click the .dae scene, find the model you want, and select the texture image in the diffuse section of the model.
- Add a the model as an SCNNode to your scene.

```swift
let potionsRoot = rootNodeFromResource(assetName: "potions/vzor", extensionName: "dae")
let potionNode = potionsRoot.childNode(withName: "small_health_poti_blue", recursively: true)!
scene.rootNode.addChildNode(potionNode)


func rootNodeFromResource(assetName: String, extensionName: String) -> SCNNode {
let url = Bundle.main.url(forResource: "art.scnassets/\(assetName)", withExtension: extensionName)!
let node = SCNReferenceNode(url: url)!

node.name = assetName
node.load()
return node
}
```
![textureFix]

[textureFix]: https://github.com/p-sun/SceneKit-Model-Import/blob/master/Images/fix_dae_textures.png
