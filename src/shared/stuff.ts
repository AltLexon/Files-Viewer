import Roact, { mount } from "@rbxts/roact"
import templateButton from "./GUI/button"

export function getClass(file_name: string) : string {
    let Type = 'Unknown'
    if (isfolder(file_name)) {
        Type = 'Folder'
    } else if (isfile(file_name)) {
        Type = 'File'
    }

    return Type
}

function getFiles(WorkspaceFiles: string[]) : [string[], string[], string[]] {
    const Folders: string[] = []
    const Files: string[] = []
    const Unknown: string[] = []

    for (const [_, v] of pairs(WorkspaceFiles)) {
        const FileName: string = string.gsub(v, '\\', '') as any
        const FileType = getClass(FileName)

        if (FileType === 'Folder') {
            Folders.insert(Folders.push(), FileName)
        } else if (FileType === 'File') {
            Files.insert(Files.push(), FileName)
        } else if (FileType === 'Unknown') {
            Unknown.insert(Unknown.push(), FileName)
        }
    }

    return [Folders, Files, Unknown]
}

function setUpButton(_button: TextButton, _type: string, _filename: string) {
    const StartByType = {
        "Folder": [Color3.fromRGB(255, 139, 48), '📂 '],
        "File": [Color3.fromRGB(255, 255, 255), '📜 '],
        "Unknown": [Color3.fromRGB(230, 230, 230), '❓ ']
    }

    const Label = _button.FindFirstChildOfClass('TextLabel') as TextLabel
    if (_type === 'Folder') {
        Label.Text = (StartByType.Folder as [Color3, string])[1]
        Label.TextColor3 = (StartByType.Folder as [Color3, string])[0]
    } else if (_type === 'File') {
        Label.Text = (StartByType.File as [Color3, string])[1]
        Label.TextColor3 = (StartByType.File as [Color3, string])[0]
    } else if (_type === 'Unknown') {
        Label.Text = (StartByType.Unknown as [Color3, string])[1]
        Label.TextColor3 = (StartByType.Unknown as [Color3, string])[0]
    }

    Label.Text += _filename
}

function convertData(list: ScrollingFrame, _table: [], _type: string) {
    let ButtonName: string;
    for (const [_, v] of pairs(_table)) {
        ButtonName = v

        if (list.FindFirstChild(ButtonName)) {
            for (let i = 1; i < 5; i++) {
                if ( !list.FindFirstChild(ButtonName + tostring(i)) ) {
                    ButtonName = ButtonName + tostring(i)
                    break
                }
            }
        }

        list.CanvasSize = new UDim2(0, 0, 0, list.CanvasSize.Y.Offset + 45)
        mount(templateButton, list, ButtonName)
        setUpButton(list.WaitForChild(ButtonName) as TextButton, _type, v)
    }
}

export function refresh(List: ScrollingFrame) {

    for (const [_, v] of pairs(List.GetChildren())) {
        if (v.IsA('UIListLayout')) {
            continue
        }

        v.Destroy()
    }

    List.CanvasSize = new UDim2(0, 0, 0, 0)

    const WorkspaceFiles = listfiles('') as []

    const [Folders, Files, Unknown] = getFiles(WorkspaceFiles)

    convertData(List, Folders as [], 'Folder')
    convertData(List, Files as [], 'File')
    convertData(List, Unknown as [], 'Unknown')
}