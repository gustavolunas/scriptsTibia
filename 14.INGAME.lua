setDefaultTab("Tools")

UI.Separator():setMarginTop(-0)

LABEL = UI.Label("[LNS TOOLS]")
LABEL:setMarginTop(-1)
LABEL:setFont("sono_bold_border_14")
macro(10, function()
    local text = 'TOOLS SCRIPTS'
    local time = os.clock() * 4
    local coloredText = {}


    for i = 1, #text do
        local char = text:sub(i, i)
        local color = setRainbowColor(time + i * 0.1) 
        table.insert(coloredText, char) 
        table.insert(coloredText, color) 
    end


    if LABEL and LABEL then
        LABEL:setColoredText(coloredText)
    end
end)

UI.Separator():setMarginTop(-2)

local scriptsIngameEditor = nil

-- =========================
-- EDITOR LNS (WINDOW PRÓPRIA)
-- =========================
local function LnsEditorWindow(text, opts, onSave)
  opts = opts or {}
  local root = g_ui.getRootWidget()

local win = setupUI([[
UIWindow
  id: lnsEditor
  size: 390 310
  opacity: 0.96
  draggable: true
  anchors.centerIn: parent

  Panel
    id: bg
    anchors.fill: parent
    background-color: #111111
    border: 1 #2a2a2a

  Panel
    id: header
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    height: 27
    background-color: #161616
    border-bottom: 1 #2c2c2c

    Label
      id: title
      anchors.centerIn: parent
      text: LNS Custom | Ingame Script Editor
      font: verdana-11px-rounded
      color: #ff9d2e
      text-auto-resize: true

  Panel
    id: editorFrame
    anchors.top: header.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: footer.top
    margin-top: 8
    margin-left: 8
    margin-right: 8
    margin-bottom: 8
    background-color: #0c0c0c
    border: 1 #242424

  Panel
    id: editorInner
    anchors.fill: editorFrame
    margin-top: 4
    margin-left: 4
    margin-right: 4
    margin-bottom: 4
    background-color: #101010
    border: 1 #1c1c1c

  VerticalScrollBar
    id: textScroll
    anchors.top: editorInner.top
    anchors.right: editorInner.right
    anchors.bottom: editorInner.bottom
    margin-top: 2
    margin-right: 2
    margin-bottom: 2
    step: 14
    pixels-scroll: true

  TextEdit
    id: textContent
    anchors.top: editorInner.top
    anchors.left: editorInner.left
    anchors.right: textScroll.left
    anchors.bottom: editorInner.bottom
    margin-left: 6
    margin-top: 5
    margin-right: 4
    margin-bottom: 5
    vertical-scrollbar: textScroll
    color: #f0f0f0
    font: verdana-9px
    multiline: true 
    text-wrap: true

  Panel
    id: footer
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    height: 30
    background-color: #141414
    border-top: 1 #2c2c2c

  Button
    id: btnSave
    anchors.right: btnClose.left
    anchors.verticalCenter: footer.verticalCenter
    margin-right: 8
    margin-top: -5
    width: 82
    height: 24
    text: Salvar
    font: verdana-9px
    image-source: /images/ui/button_rounded
    image-color: #2f6b3d
    color: white

    $hover:
      image-color: #3b824b

  Button
    id: btnClose
    anchors.right: parent.right
    anchors.verticalCenter: footer.verticalCenter
    margin-right: 10
    margin-top: -5
    width: 82
    height: 24
    text: Fechar
    font: verdana-9px
    image-source: /images/ui/button_rounded
    image-color: #7a3232
    color: white

    $hover:
      image-color: #944040
]], root)

  -- título
  if opts.title and win.topPanel and win.topPanel.title then
    win.topPanel.title:setText(opts.title)
  end

  -- tamanho opcional
  if opts.width and opts.height then
    win:setSize({ width = 380, height = 400 })
  end

  -- texto inicial
  win.textContent:setText(text or "")

  local function closeWin()
    if win and type(win.destroy) == "function" then
      win:destroy()
    end
  end

  win.btnSave.onClick = function()
    if type(onSave) == "function" then
      onSave(win.textContent:getText())
    end
    closeWin()
  end

  win.btnClose.onClick = closeWin

  win:show()
  win:raise()
  win:focus()

  return win
end

-- =========================
-- ABRIR EDITOR
-- =========================
local butt = addButton("", "INGAME SCRIPT EDITOR", function()
  LnsEditorWindow(storage.ingame_hotkeys or "", { title = "LNS Custom | Ingame Script", width = 380, height = 300 }, function(text)
    storage.ingame_hotkeys = text
    reload()
  end)
end)
butt:setImageSource("/images/ui/button_rounded")
butt:setFont("verdana-9px")
butt:setImageColor("#363636")
butt:setHeight(18)

-- =========================
-- EXECUÇÃO PADRÃO (IGUAL SEU EXEMPLO)
-- =========================
for _, scripts in pairs({ storage.ingame_hotkeys }) do
  if type(scripts) == "string" and scripts:len() > 3 then
    local originalMacro = macro

    if not originalMacro then
      error("A função global 'macro' não foi encontrada.")
      return
    end

    macro = function(time, name, func, panel, ...)
      if panel == nil then
        originalMacro(time, name, func, scriptsIngameEditor, ...)
      else
        originalMacro(time, name, func, panel, ...)
      end
    end

    local status, result = pcall(function()
      assert(load(scripts, "ingame_editor"))()
    end)

    macro = originalMacro

    if not status then
      error("Ingame editor error:\n" .. result)
    end
  end
end

UI.Separator()