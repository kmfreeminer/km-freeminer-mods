jabber = {}

local loaded, verse = pcall(function()
    package.path = package.path ..
        ";" .. os.getenv("HOME") .. "/.luarocks/share/lua/5.1/?.lua" ..
        ";" .. os.getenv("HOME") .. "/.luarocks/share/lua/5.1/?/init.lua"
    package.cpath = package.cpath ..
        ";" .. os.getenv("HOME") .. "/.luarocks/lib/lua/5.1/?.so" ..
        ";" .. os.getenv("HOME") .. "/.luarocks/lib/lua/5.1/?/init.so"

    return require "verse".init("client");
end)

if not loaded then
    minetest.log("error",
        "Jabber support mod launch failed."
    )

    function jabber.send(message)
        return
    end

    return
end

local JID, PASSWORD = "sullome@jabbim.com/freeminer", "";
local ROOM = {
    name = "kmrp-elite@conference.jabber.ru",
    password = "",
    nick = "freeminer-bot"
}

c = verse.new();
c:add_plugin("groupchat")

-- Add some hooks for debugging
c:hook("opened", function () print("Stream opened!") end);
c:hook("closed", function () print("Stream closed!") end);
c:hook("stanza", function (stanza) print("Stanza:", stanza) end);

-- This one prints all received data
c:hook("incoming-raw", print, 1000);

-- Print a message after authentication
c:hook("authentication-success", function () print("Logged in!"); end);
c:hook("authentication-failure", function (err) print("Failed to log in! Error: "..tostring(err.condition)); end);

-- Print a message and exit when disconnected
c:hook("disconnected", function () print("Disconnected!") end);

-- Catch the "ready" event to know when the stream is ready to use
c:hook("ready", function ()
	print("Stream ready!");
    ROOM.verse = c:join_room(ROOM.name, ROOM.nick, {password = ROOM.password})
end);

minetest.register_globalstep(function(dtime)
    verse.step()
end)

function jabber.send(message)
    ROOM.verse:send_message(message)
end

--minetest.register_on_shutdown(function()
--    ROOM.verse:leave("Freeminer server shut down")
--    c:close()
--    verse.quit()
--end)

-- Now, actually start the connection:
c:connect_client(JID, PASSWORD);
