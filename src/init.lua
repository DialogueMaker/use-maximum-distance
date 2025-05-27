--!strict

local Players = game:GetService("Players");

local React = require(script.Parent.react);
local IDialogueServer = require(script.Parent["dialogue-server-types"]);

type DialogueServer = IDialogueServer.DialogueServer;

local function useMaximumDistance(npc: Model, dialogueServer: DialogueServer, endConversation: () -> ())

  React.useEffect(function(): ()
    
    local distanceSettings = dialogueServer:getSettings().distance;
    if distanceSettings.maxConversationDistance and distanceSettings.relativePart then

      local detectionTask = task.spawn(function() 

        while task.wait() do

          if math.abs(distanceSettings.relativePart.Position.Magnitude - Players.LocalPlayer.Character.PrimaryPart.Position.Magnitude) > distanceSettings.maxConversationDistance then

            endConversation();
            break;

          end;

        end;

      end);

      return function()

        task.cancel(detectionTask);

      end;

    end;

  end, {npc :: unknown, dialogueServer, endConversation});

end;

return useMaximumDistance;