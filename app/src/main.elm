import Html exposing (beginnerProgram, div, text, Html, button, input, i, span)
import Html.Events exposing (onClick, onInput)
import Html.Attributes exposing (value, class)
import String exposing (concat)
import List exposing (length, append, map, filter)
import Random exposing (generate, int, initialSeed, step, Seed, maxInt)

-- bootstrap app
main =
    Html.beginnerProgram{model = model, update = update, view = view}

-- common
type alias ToDoAppTaskUuid = Int
type alias ToDoAppTask = { text: String, uuid: ToDoAppTaskUuid }
type alias ToDoAppModel = { tasks: List ToDoAppTask, newTask: String, tasksGeneratorSeed: Seed }

generator = int 0 maxInt

taskFactory: String -> Seed -> (ToDoAppTask, Seed)
taskFactory taskContent seed =
    let
        (nextInt, nextSeed) = step generator seed
    in
        ({ text = taskContent, uuid = nextInt}, nextSeed)

type ToDoAppModelFactoryOptions = Empty | PredefinedTasks ( List ToDoAppTask )
toDoAppModelFactory: ToDoAppModelFactoryOptions -> ToDoAppModel
toDoAppModelFactory options =
    case options of
        Empty ->
            { tasks = [], newTask = "", tasksGeneratorSeed = initialSeed 37 }
        PredefinedTasks taskList ->
            { tasks = taskList, newTask = "", tasksGeneratorSeed = initialSeed 37 }

-- define model

model: ToDoAppModel
model = toDoAppModelFactory ( PredefinedTasks [{ text = "Elm is AWESOME!", uuid = 0 }, { text = "John Snow didn`t knows this =(", uuid = 1 }] )

-- define update

type ToDoAppCommands = Add | Remove ToDoAppTaskUuid | UpdateNewTask String

update: ToDoAppCommands -> ToDoAppModel -> ToDoAppModel
update command model =
    case command of
        Add ->
            let
                (newTask, nextSeed) = taskFactory model.newTask model.tasksGeneratorSeed
            in
                { model |
                    tasks = append model.tasks [ newTask ],
                    newTask = "",
                    tasksGeneratorSeed = nextSeed
                }
        Remove taskUuid ->
            { model |
                tasks = filter (\el -> el.uuid /= taskUuid) model.tasks
            }
        UpdateNewTask newTaskText ->
            { model |
                newTask = newTaskText
            }


-- define view

----------------- WARNING! toilet paper!---------------------
-------------------------------------------------------------
presentCreateButton: Html ToDoAppCommands
presentCreateButton =
    button[onClick Add][text "create"]

presentCreateTaskForm: String -> Html ToDoAppCommands
presentCreateTaskForm newTaskField =
    div[][
        input[onInput UpdateNewTask, value newTaskField ][],
        presentCreateButton
    ]
-------------------------------------------------------------
-------------------------------------------------------------
presentSeparateLine: Html ToDoAppCommands
presentSeparateLine =
    span[][ text " | " ]

presentRemoveTaskButton: ToDoAppTaskUuid -> Html ToDoAppCommands
presentRemoveTaskButton taskUuid =
    span[][
        i[ class "fa fa-trash-o", onClick (Remove taskUuid) ][]
    ]

presentTask: ToDoAppTask -> Html ToDoAppCommands
presentTask taskContent =
    div[][
        presentRemoveTaskButton taskContent.uuid,
        presentSeparateLine,
        taskContent.text
            |> text
    ]

presentTasks: List ToDoAppTask -> List ( Html ToDoAppCommands )
presentTasks taskList =
    map ( \element -> presentTask element ) taskList
------------------------------------------------------------
------------------------------------------------------------
presentCount: Int -> Html ToDoAppCommands
presentCount count =
    concat ["count: ", toString count]
        |> text
------------------------------------------------------------
------------------------------------------------------------
view: ToDoAppModel -> Html ToDoAppCommands
view model =
    div[][
        div[][
            presentCreateTaskForm model.newTask
        ],
        div []
            (model.tasks
                |> presentTasks),
        model.tasks
            |> length
            |> presentCount
    ]