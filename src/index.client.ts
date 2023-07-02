import { Players, TweenService, UserInputService } from "@rbxts/services";
import Roact, { mount, unmount } from "@rbxts/roact";
import {SingleMotor, Spring} from "@rbxts/flipper"
import { refresh } from "shared/stuff";
import mainUI from "shared/GUI/main";

const UI_Name = 'Files-Viewer'
getgenv()['Files-Viewer'] = {}
const Files_Viewer_Table = getgenv()['Files-Viewer'] as Map<any, any>

const Keybind: Enum.KeyCode = getgenv().ToggleKey as Enum.KeyCode

Files_Viewer_Table.set('_ Selected', undefined)

const LocalPlayer = Players.LocalPlayer as Player
const PlayerGui = LocalPlayer.FindFirstChildOfClass('PlayerGui') as PlayerGui

const RoactTree = mount(mainUI, PlayerGui, UI_Name);
const RoactInstance = PlayerGui.WaitForChild(UI_Name) as ScreenGui;

const Main = RoactInstance.WaitForChild('Main') as Frame
const List = Main.WaitForChild('Files') as ScrollingFrame

const motor = new SingleMotor(0)
motor.onStep(x => Main.Position = new UDim2(0.5, 0, x, 0))

let isMoving: boolean = false
let isOpen: boolean = false

UserInputService.InputBegan.Connect((int: InputObject, gameProcessedEvent: boolean) => {
    if (gameProcessedEvent) {
        return
    }

    if (int.KeyCode === Keybind && !isMoving) {
        if (isOpen) {
            motor.setGoal(new Spring(1.5, {frequency: 2.5, dampingRatio: 0.5}))
        } else {
            motor.setGoal(new Spring(0.5, {frequency: 2.5, dampingRatio: 0.5}))
        }
        isOpen = !isOpen
    }
})

LocalPlayer.CharacterRemoving.Connect(() => {
    unmount(RoactTree)
})

while (List !== undefined) {
    refresh(List)
    task.wait(30)
}