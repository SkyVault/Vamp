import
  json,
  strformat,
  ../ecs

const QUEST_JSON="""

"""
discard QUEST_JSON

type
  QuestType* {.pure.} = enum
    CheckOnInteraction,
    CheckEachFrame

  Quest* = ref object
    check*: proc(self: Quest, player: Entity)

    case qtype*: QuestType:
    of  QuestType.CheckOnInteraction:
      npc*: Entity
    of QuestType.CheckEachFrame:
      discard

var quests = newSeq[Quest]()

EntityWorld.createSystem(
  @["NONE"],

  preUpdate=proc(self: System)=
    for quest in quests:
      case quest.qtype:
      of CheckOnInteraction:
        discard
      of CheckEachFrame:
        quest.check(quest, getFirstThatMatch(@["Player"]))
  ,
)

proc startQuest* (which: string)=
  echo &"Starting Quest {which}"

proc update* ()=
  discard

proc draw* ()=
  discard
