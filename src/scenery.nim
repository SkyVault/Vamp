import
  sequtils

type
  SceneState* = enum
    UpdateScene,
    RenderScene,
    LoadScene,
    DeleteScene

  Scene* = ref object of RootObj
    event: proc(ev: SceneState)

  SceneManager = ref object
    scene_stack: seq[Scene]

var sce = SceneManager(scene_stack: newSeq[Scene]())
template Scenery* (): auto = sce

proc newScene* (ev: proc(ev: SceneState)): Scene=
  result = Scene(event: ev)

proc push* (sc: SceneManager, scene: Scene): Scene {.discardable.}=
  result = scene
  
  scene.event(LoadScene)
  sc.scene_stack.add(scene)

proc pop* (sc: SceneManager): Scene {.discardable.}=
  if len(sc.scene_stack) == 0: return nil

  result = sc.scene_stack[len(sc.scene_stack)-1]
  result.event(DeleteScene)
  sc.scene_stack.delete len(sc.scene_stack) - 1, len(sc.scene_stack) - 1

proc goto* (sc: SceneManager, scene: Scene): Scene {.discardable.}=
  sc.pop()
  result = sc.push(scene)

proc update* (sc: SceneManager)=
  if len(sc.scene_stack) == 0: return
  sc.scene_stack[len(sc.scene_stack)-1].event(UpdateScene)
  
proc draw* (sc: SceneManager)=
  if len(sc.scene_stack) == 0: return
  sc.scene_stack[len(sc.scene_stack)-1].event(RenderScene)
