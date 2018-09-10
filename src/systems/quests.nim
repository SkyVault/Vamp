import
  json,
  strformat,
  tables,
  ../ecs,
  ../systems/ai

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

var QUESTS = {
  "OldLady-Coin" : Quest(
    qtype: QuestType.CheckOnInteraction,
    check: proc(self: Quest, player: Entity)=
      echo "Checking Old lady quest"
  )
}.toTable

EntityWorld.createSystem(
  @["NONE"],

  preUpdate=proc(self: System)=
    for quest in quests:
      case quest.qtype:
      of CheckOnInteraction:
        if quest.npc.has(Ai):
          let ai = quest.npc.get Ai

          if ai.interactingWith != nil:
            quest.check(quest, getFirstThatMatch(@["Player"]))

      of CheckEachFrame:
        quest.check(quest, getFirstThatMatch(@["Player"]))
  ,
)

proc startQuest* (which: string, npc: Entity=nil)=
  #doAssert(QUESTS.hasKey which)
  
  var quest = QUESTS[which]
  if quest.qtype == QuestType.CheckOnInteraction:
    quest.npc = npc
  quests.add(quest)

proc update* ()=
  discard

proc draw* ()=
  discard
