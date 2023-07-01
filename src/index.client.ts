import { Players, TweenService } from "@rbxts/services";
import Roact, { mount, unmount } from "@rbxts/roact";
import { refresh } from "shared/stuff";
import mainUI from "shared/GUI/main";

const UI_Name = 'Files-Viewer'
getgenv()['Files-Viewer'] = {}
const Files_Viewer_Table = getgenv()['Files-Viewer'] as Map<any, any>

Files_Viewer_Table.set('_ Selected', undefined)

const LocalPlayer = Players.LocalPlayer as Player
const PlayerGui = LocalPlayer.FindFirstChildOfClass('PlayerGui') as PlayerGui

const RoactTree = mount(mainUI, PlayerGui, UI_Name);
const RoactInstance = PlayerGui.WaitForChild(UI_Name) as ScreenGui;

const Main = RoactInstance.WaitForChild('Main') as Frame
const List = Main.WaitForChild('Files') as ScrollingFrame

TweenService.Create(Main, new TweenInfo(1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
    Position: UDim2.fromScale(0.5, 0.5)
}).Play()

LocalPlayer.CharacterRemoving.Connect(() => {
    unmount(RoactTree)
})

while (List !== undefined) {
    refresh(List)
    task.wait(30)
}