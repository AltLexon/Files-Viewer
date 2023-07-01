import Roact, { oneChild } from "@rbxts/roact";

const templateButton = <textbutton
    Size={new UDim2(0.95, 0, 0, 40)}
    BackgroundColor3={Color3.fromRGB(16, 16, 16)}
    AnchorPoint={new Vector2(0.5, 0.5)}
    Text={''}
    AutoButtonColor={false}

    Event={{
        Activated: (rbx) => {
            const Files_Viewer_Table = (getgenv()['Files-Viewer'] as Map<any, any>)
            let oldButton: TextButton = Files_Viewer_Table.get('_ Selected') as TextButton

            if (oldButton !== undefined && oldButton.IsA('TextButton') && oldButton.FindFirstChildOfClass('TextLabel')) {
                const Label = oldButton.FindFirstChildOfClass('TextLabel') as TextLabel
                Label.Text = Label.Text.split(' -')[0]
            }

            Files_Viewer_Table.set('_ Selected', rbx);
            (rbx.FindFirstChildOfClass('TextLabel') as TextLabel).Text += ' - Selected'
        }
    }}
>
    <uicorner CornerRadius={new UDim(0, 8)}/>
    
    <textlabel
        Size={new UDim2(0.8, 0, 0.8, 0)}
        Position={UDim2.fromScale(0.5, 0.5)}
        AnchorPoint={new Vector2(0.5, 0.5)}
        Text={'📁 '}
        TextScaled={true}
        BackgroundTransparency={1}
        Font={'Ubuntu'}
    />
</textbutton>

export default templateButton