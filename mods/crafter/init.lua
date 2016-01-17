crafter = {}

crafter.crafts = {}

--{{{ local function check_craft
local function check_craft(data, w, c)
  if c.type == data.method then
    -- Here we go..
    for i=1,w-c._h+1 do
      for j=1,w-c._w+1 do
        local p=(i-1)*w+j
        minetest.log("verbose",
            "Checking data.items[" .. dump(i) .. "]["
                .. dump(j) .. "]("
                .. dump(p) .. ")=" ..
                dump(data.items[p]:get_name()) ..
            " vs craft.recipe[1][1]=" ..
                dump(c.recipe[1][1])
        )
        if data.items[p]:get_name() == c.recipe[1][1] then
            local equal = {}
            for m=1,c._h do
                for n=1,c._w do
                    local q=(i+m-1-1)*w+j+n-1
                    minetest.log("verbose",
                        "  Checking data.items[" .. dump(i + m - 1) .. "]["
                            .. dump(j + n - 1) .. "]("
                            .. dump(q) .. ")=" ..
                            dump(data.items[q]:get_name()) ..
                        " vs craft.recipe[" .. dump(m) ..  "]["
                            .. dump(n) .. "]=" ..
                            dump(c.recipe[m][n])
                    )
                    if c.recipe[m][n] == data.items[q]:get_name() then
                        equal[q] = true
                    else
                        return nil
                    end
                end
            end
            -- found! we still must check that is not any other stuff outside the limits of the recipe sizes...
            for cell = 1, #data.items do
                if data.items[cell]:get_name() ~= "" and not equal[cell] then
                    return nil
                end
            end
          -- Checking at right of the matching square
          --for m=i,w do
          --  for n=j+c._w,w do
          --    local q=(m-1)*w+n
          --    minetest.log("verbose", "    Checking right data.items["..dump(m).."]["..dump(n).."]("..dump(q)..")="..dump(data.items[q]:get_name()))
          --    if data.items[q]:get_name() ~= "" then
          --      return nil
          --    end
          --  end
          --end
          ---- Checking at left of the matching square (the first row has been already scanned)
          --for m=i,w do
          --  for n=1,j-1 do
          --    local q=(m-1)*w+n
          --    minetest.log("verbose", "    Checking left data.items["..dump(m).."]["..dump(n).."]("..dump(q)..")="..dump(data.items[q]:get_name()))
          --    if data.items[q]:get_name() ~= "" then
          --      return nil
          --    end
          --  end
          --end
          ---- Checking at bottom of the matching square
          --for m=i+c._h,w do
          --  for n=j,j+c._w do
          --    local q=(m-1)*w+n
          --    minetest.log("verbose", "    Checking bottom data.items["..dump(m).."]["..dump(n).."]("..dump(q)..")="..dump(data.items[q]:get_name()))
          --    if data.items[q]:get_name() ~= "" then
          --      return nil
          --    end
          --  end
          --end
          minetest.log("verbose", "Craft found! " .. c.output)
          return ItemStack(c.output)
        elseif data.items[p] ~= nil and data.items[p]:get_name() ~= "" then
          minetest.log("verbose",
              "Invalid data item "  ..  dump(data.items[p]:get_name())
          )
          return nil
        end
      end
    end
  end
end
--}}}

function crafter.register_craft(craft)
    -- craft definition must have type, recipe and output
    if craft.type ~= nil
    and craft.recipe ~= nil
    and craft.output ~= nil
    -- 'recipe' must be a bidimensional table
    and type(craft.recipe) == "table"
    and type(craft.recipe[1]) == "table"
    then
        minetest.log("info",
            "registerCraft (" .. craft.type ..
            ", output=" .. craft.output .. 
            " recipe=" .. dump(craft.recipe)
        )
        craft._h = #craft.recipe
        craft._w = #craft.recipe[1]
        -- TODO check that all the arrays have the same length...
        table.insert(crafter.crafts, craft)
    end
end

function crafter.get_craft_result(data)
    if data.method and data.items then
        local width = 1
        if data.width > 0 then width = data.width end

        local result = {}

        for _, craft in ipairs(crafter.crafts) do
            r = check_craft(data, width, craft)
            if r ~= nil then
                table.insert(result, r)
            end
        end

        return result
    end
end

