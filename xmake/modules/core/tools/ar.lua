--!A cross-platform build utility based on Lua
--
-- Licensed to the Apache Software Foundation (ASF) under one
-- or more contributor license agreements.  See the NOTICE file
-- distributed with this work for additional information
-- regarding copyright ownership.  The ASF licenses this file
-- to you under the Apache License, Version 2.0 (the
-- "License"); you may not use this file except in compliance
-- with the License.  You may obtain a copy of the License at
--
--     http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
-- 
-- Copyright (C) 2015 - 2018, TBOOX Open Source Group.
--
-- @author      ruki
-- @file        ar.lua
--

-- imports
import("core.tool.compiler")

-- init it
function init(self)
    _g.arflags = { "-cr" }
end

-- get the property
function get(self, name)
    return _g[name]
end

-- make the strip flag
function strip(self, level)

    -- the maps
    local maps = 
    {   
        debug = "-S"
    ,   all   = "-s"
    }

    -- make it
    return maps[level] 
end

-- make the link arguments list
function linkargv(self, objectfiles, targetkind, targetfile, flags)

    -- check
    assert(targetkind == "static")

    -- make it
    return self:program(), table.join(flags, targetfile, objectfiles)
end

-- link the library file
function link(self, objectfiles, targetkind, targetfile, flags)

    -- check
    assert(targetkind == "static", "the target kind: %s is not support for ar", targetkind)

    -- ensure the target directory
    os.mkdir(path.directory(targetfile))

    -- @note remove the previous archived file first to force recreating a new file
    os.tryrm(targetfile)

    -- link it
    os.runv(linkargv(self, objectfiles, targetkind, targetfile, flags))
end

-- extract the static library to object directory
function extract(self, libraryfile, objectdir)

    -- make the object directory first
    os.mkdir(objectdir)

    -- get the absolute path of this library
    libraryfile = path.absolute(libraryfile)

    -- enter the object directory
    local oldir = os.cd(objectdir)

    -- extract it
    os.runv(self:program(), {"-x", libraryfile})

    -- check repeat object name
    local repeats = {}
    local objectfiles = os.iorunv(self:program(), {"-t", libraryfile})
    for _, objectfile in ipairs(objectfiles:split('\n')) do
        if repeats[objectfile] then
            raise("object name(%s) conflicts in library: %s", objectfile, libraryfile)
        end
        repeats[objectfile] = true
    end                                                          

    -- leave the object directory
    os.cd(oldir)
end

