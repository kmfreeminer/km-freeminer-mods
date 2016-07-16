jabber = {}

--{{{ Initialization
local verse, c

local function init ()
    package.path = package.path ..
        ";" .. minetest.get_modpath("jabber") .. "/lib/?.lua" ..
        ";" .. minetest.get_modpath("jabber") .. "/lib/?/init.lua"
    package.cpath = package.cpath ..
        ";" .. minetest.get_modpath("jabber") .. "/lib/?.so" ..
        ";" .. minetest.get_modpath("jabber") .. "/lib/?/init.so"

    verse = require "verse".init("client")
    c = verse.new()
    c:add_plugin("groupchat_with_password")

    jabber.jid = minetest.setting_get("jabber-jid")
    jabber.password = minetest.setting_get("jabber-password")
    jabber.room_name = minetest.setting_get("jabber-room-name")
    jabber.room_pass = minetest.setting_get("jabber-room-password")
    jabber.room_nick = "gamechat"

    if jabber.jid == nil
    or jabber.password == nil
    or jabber.room_name == nil
    or jabber.room_pass == nil
    then
        error("Jabber configuration not found.")
    end
end

local function init_error_handle (err)
    minetest.log("error",
        "Jabber support mod launch failed.\n" ..
        "Reason: " .. err
    )

    function jabber.send(message)
        return
    end
end

if not xpcall(init, init_error_handle) then return end
--}}}

--{{{ Verse

-- Status logging
local function log (message)
    minetest.log("verbose", "Jabber: " .. message)
end

-- This one prints all received data
--c:hook("incoming-raw", print, 1000);

c:hook("opened", function () log("Stream opened!") end)
c:hook("closed", function () log("Stream closed!") end)
c:hook("authentication-success", function () log("Logged in!") end)
c:hook("authentication-failure", function (err)
    log("Failed to log in!\nError: " .. tostring(err.condition))
end)
c:hook("connected", function () log("Connected!") end)
c:hook("disconnected", function () log("Disconnected!") end)

-- Catch the "ready" event to know when the stream is ready to use
c:hook("ready", function ()
    log("Stream ready!")
    jabber.room = c:join_room(
        jabber.room_name,
        jabber.room_nick,
        {password = jabber.room_pass}
    )
    jabber.room:hook("message", function (event)
        local message = event.stanza:get_child_text("body")

        -- Filter jabber server messages
        local sender
        if event.sender then
            sender = event.sender.nick

            -- Filter history and own messages
            if (not event.stanza:child_with_name("delay")
                and sender ~= jabber.room_nick)
            then
                jabber.on_message(message, sender)
            end
        end
    end)
end)
--}}}

--{{{ Minetest
minetest.register_globalstep(function(dtime)
    verse.step()
end)

function jabber.send(message)
    jabber.room:send_message(message)
end

local function format_message(sender, message)
    local result = "(( " .. sender .. ": " .. message .. "))"
    return freeminer.colorize("007F00", result)
end

function jabber.on_message(message, sender)
    if not sender then return end

    cmd = message:match("^#(%a+)")
    if cmd then
        -- There can be no params (like "#help"),
        -- and because Lua doesn't support subpatterns,
        -- we need to add some additional logic
        local params = message:gsub("^#" .. cmd, "")
        if params ~= "" then params:gsub("^ ", "") end

        if not minetest.get_player_by_name(sender) then sender = "admin" end
        local status, answer = core.chatcommands[cmd].func(sender, params)
        if status then
            -- Some of the space characters invokes an xml error,
            -- so we replacing them with regular space.
            -- And we need to save newlines also.
            answer = answer:gsub("\n", "\\n"):gsub("%s", " "):gsub("\\n", "\n")
            jabber.room:send_message(answer)
        end
    else
        local formatted = format_message(sender, message)
        if formatted then minetest.chat_send_all(formatted) end
    end
end
--}}}

-- After all configuration, start actual connection
c:connect_client(jabber.jid, jabber.password)
