--!strict

local Players = game:GetService("Players");

local packages = script.Parent.roblox_packages;
local React = require(packages.react);
local IConversation = require(packages.conversation_types);

type Conversation = IConversation.Conversation;

local function useMaximumDistance(npc: Model, conversation: Conversation, endConversation: () -> ())

  React.useEffect(function(): ()
    
    local distanceSettings = conversation:getSettings().distance;
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

  end, {npc :: unknown, conversation, endConversation});

end;

return useMaximumDistance;