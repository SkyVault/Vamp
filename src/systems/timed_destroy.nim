import 
  ../ecs,
  ../platform

type
  TimedDestroy = ref object of Component
    life*: float

proc newTimedDestroy* (life: float): auto=
  result = TimedDestroy(life: life)

EntityWorld.createSystem(
  @["TimedDestroy"],

  update = proc(sys: System, self: Entity)=
    var td = self.get TimedDestroy
    
    if td.life <= 0:
      self.kill()

    td.life -= GameClock.dt
)
