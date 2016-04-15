jabber = {}

--{{{ Initialization
local verse, c

local function init ()
    package.path = package.path ..
        ";" .. os.getenv("HOME") .. "/.luarocks/share/lua/5.1/?.lua" ..
        ";" .. os.getenv("HOME") .. "/.luarocks/share/lua/5.1/?/init.lua"
    package.cpath = package.cpath ..
        ";" .. os.getenv("HOME") .. "/.luarocks/lib/lua/5.1/?.so" ..
        ";" .. os.getenv("HOME") .. "/.luarocks/lib/lua/5.1/?/init.so"

    verse = require "verse".init("client")
    c = verse.new()
    c:add_plugin("groupchat")

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
        "Jabber support mod launch failed." ..
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

c:hook("opened", log("Stream opened!"))
c:hook("closed", log("Stream closed!"))
c:hook("stanza", log("Stanza:", stanza))
c:hook("authentication-success", log("Logged in!"))
c:hook("authentication-failure", function (err)
    log("Failed to log in!\nError: " .. tostring(err.condition))
end)
c:hook("disconnected", log("Disconnected!"))

-- Catch the "ready" event to know when the stream is ready to use
c:hook("ready", function ()
	log("Stream ready!")
    jabber.room = c:join_room(
        jabber.room_name,
        jabber.room_nick,
        {password = jabber.room_pass}
    )
end)
--}}}

--{{{ Minetest
minetest.register_globalstep(function(dtime)
    verse.step()
end)

function jabber.send(message)
    jabber.room:send_message(message)
end
--}}}

-- After all configuration, start actual connection
c:connect_client(jabber.jid, jabber.password)
