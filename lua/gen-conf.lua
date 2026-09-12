












local out_target = nil

do
  local i = 1
  while i <= #arg do
    if arg[i] == "-o" then
      out_target = arg[i + 1]
      i = i + 2
    else
      i = i + 1
    end
  end
end

local spec = {
  meta = {
    generatedBy = "lua/gen-conf.lua",
    brand = "jeri-desktop",
    managed = true,
  },

  general = {
    col_active_border = "rgba(7aa2f7ee) rgba(3a537faa) 45deg",
    col_inactive_border = "rgba(262b34aa)",
    border_size = 2,
  },

  bind = {

  },
}

local function emit(s)
  io.write(s .. "\n")
end

local function render()
  emit("# Jeri Desktop - generated Hyprland include")
  emit("# Source: lua/gen-conf.lua | Owned by Jeri Desktop | DO NOT EDIT IN PLACE")
  emit("# Uninstall: stripper matches the trailing '# jeri-desktop' marker line")
  emit("")
  if spec.general then
    emit("general {")
    for _, k in ipairs({ "col_active_border", "col_inactive_border", "border_size" }) do
      if spec.general[k] then
        emit(string.format("  %s = %s", k, tostring(spec.general[k])))
      end
    end
    emit("}")
    emit("")
  end
  if spec.bind and #spec.bind > 0 then
    for _, b in ipairs(spec.bind) do
      emit("bind = " .. b)
    end
    emit("")
  end
end

local function run()
  local buf = {}
  local orig = io.write
  if out_target then
    io.write = function(s) buf[#buf + 1] = s end
  end
  render()
  io.write = orig
  if out_target then
    local fh = assert(io.open(out_target, "w"), "cannot open output: " .. out_target)
    fh:write(table.concat(buf))
    fh:close()
    print("wrote " .. out_target)
  end
end

run()