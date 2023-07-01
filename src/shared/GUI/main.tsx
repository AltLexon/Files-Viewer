import Roact from "@rbxts/roact";
import { getClass, refresh } from "shared/stuff";

const mainUI = <screengui>
    <frame
        Key={'Main'}
        BackgroundColor3={Color3.fromRGB(24, 24, 24)}
        Size={UDim2.fromScale(0.3, 0.5)}
        Position={UDim2.fromScale(0.5, 1.5)}
        AnchorPoint={new Vector2(0.5, 0.5)}
    >
        <uicorner CornerRadius={new UDim(0, 10)}/>

        <scrollingframe
            Key={'Files'}
            Size={UDim2.fromScale(1, 0.87)}
            Position={UDim2.fromScale(0, 0.105)}
            BackgroundTransparency={1}
            ScrollBarThickness={1}
            BorderSizePixel={0}
            CanvasSize={new UDim2()}
        >
            <uilistlayout Padding={new UDim(0, 5)} HorizontalAlignment={Enum.HorizontalAlignment.Center} SortOrder={"Custom"}/>
        </scrollingframe>

        <frame Key={'Top'}
            BackgroundTransparency={1}
            Size={new UDim2(1, 0, 0.1, 0)}
        >
            <textbutton Key={'Delete'}
            BackgroundColor3={Color3.fromRGB(150, 0, 0)}
            Size={UDim2.fromScale(0.25, 0.75)}
            Position={UDim2.fromScale(0.15, 0.5)}
            AnchorPoint={new Vector2(0.5, 0.5)}
            Text={''}

            Event={{
                Activated: (rbx) => {
                    const Files_Viewer_Table = (getgenv()['Files-Viewer'] as Map<any, any>)

                    const Button = Files_Viewer_Table.get('_ Selected') as TextButton
                    const FileName = Button.Name

                    const Type = getClass(FileName)

                    if (Type === 'Folder') {
                        delfolder(FileName)
                    } else if (Type === 'File') {
                        delfile(FileName)
                    }

                    refresh(Button.Parent as ScrollingFrame)
                }
            }}
            >
                <uicorner CornerRadius={new UDim(0, 13)}/>

                <textlabel Key={''}
                    Text={'✖ Delete'}
                    AnchorPoint={new Vector2(0.5, 0.5)}
                    Size={UDim2.fromScale(0.8, 0.8)}
                    Position={UDim2.fromScale(0.5, 0.5)}
                    BackgroundTransparency={1}
                    TextScaled={true}
                    Font={'Ubuntu'}
                    TextColor3={Color3.fromRGB(255, 255, 255)}
                />
            </textbutton>
        </frame>
    </frame>
</screengui>

export default mainUI