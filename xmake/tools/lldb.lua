--!The Make-like Build Utility based on Lua
-- 
-- XMake is free software; you can redistribute it and/or modify
-- it under the terms of the GNU Lesser General Public License as published by
-- the Free Software Foundation; either version 2.1 of the License, or
-- (at your option) any later version.
-- 
-- XMake is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU Lesser General Public License for more details.
-- 
-- You should have received a copy of the GNU Lesser General Public License
-- along with XMake; 
-- If not, see <a href="http://www.gnu.org/licenses/"> http://www.gnu.org/licenses/</a>
-- 
-- Copyright (C) 2015 - 2016, ruki All rights reserved.
--
-- @author      ruki
-- @file        lldb.lua
--

-- init it
function init(shellname)

    -- save name
    _g.shellname = shellname or "lldb"

end

-- get the property
function get(name)

    -- get it
    return _g[name]
end

-- run the debugged program with arguments
function run(shellname, argv)

    -- attempt to split shellname, .e.g xcrun -sdk macosx lldb 
    local shellnames = _g.shellname:split("%s")

    -- patch arguments
    table.insert(argv, 1, shellname)
    for i = #shellnames, 2, -1 do
        table.insert(argv, 1, shellnames[i])
    end

    -- run it
    os.execv(shellnames[1], argv)
end

-- check the given flags 
function check(flags)

    -- check it
    os.run("%s %s -h", _g.shellname, ifelse(flags, flags, ""))
end