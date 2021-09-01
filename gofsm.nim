import std/[tables]

type
  State* = ref object
    Enter*: proc()
    Update*: proc()
    Exit*: proc()

type
  FSM* = ref object
    state*: string
    stateDir*: TableRef[string,State]

proc newFsm*(): FSM =
   var fsm = FSM()
   fsm.stateDir = newTable[string,State]()
   return fsm

proc update*(f: FSM) =
   if f.state != "" and f.stateDir[f.state].Update != nil:
        f.stateDir[f.state].Update()
   else:
      echo "update() called on FSM without active state"

proc register*(f: FSM,name: string, state: State) =
    f.stateDir[name] = state

proc unregister*(f: FSM,name: string) =
    f.stateDir.del(name)

proc hasState*(f: FSM,name: string): bool =
    return f.stateDir.hasKey(name)
    
proc change*(f: FSM,stateName: string) =
    if f.state != "" and f.stateDir[stateName].Exit != nil:
           f.stateDir[stateName].Exit()
    if not f.stateDir.hasKey(stateName):
       echo "FSM Object " & $f.typedesc() & " has no state " & stateName
       raise newException(ValueError,"Error!")
    f.state = stateName
    if f.state != "" and f.stateDir[stateName].Enter != nil:
           f.stateDir[stateName].Enter()
