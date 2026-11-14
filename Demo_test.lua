-- =============================================================================
-- CHAT BRIDGE CLIENT SCRIPT CHO ROBLOX (CB.lua - Phiên bản v46.0)
-- =============================================================================
-- Kiến trúc tổng thể gồm 6 bảng trung tâm:
--   1. CFG : Cấu hình hằng số hệ thống, danh sách máy chủ Proxy, Emoji & Shortcode.
--   2. H   : Tập hợp các hàm tiện ích xử lý chuỗi, JSON, màu sắc WCAG, UTF-8 & đo chữ.
--   3. P   : Dữ liệu cài đặt cá nhân của người chơi (được lưu bền vững vào file JSON).
--   4. S   : Trạng thái phiên làm việc hiện tại (tin nhắn, người dùng online, role, script).
--   5. U   : Các đối tượng giao diện người dùng (ScreenGui, cửa sổ chính, khung cuộn, nút).
--   6. F   : Toàn bộ các hàm xử lý nghiệp vụ, mạng, sự kiện, vẽ UI và điều khiển ứng dụng.
-- =============================================================================

-- =============================================================================
-- 1. KHỞI TẠO MÔI TRƯỜNG & DỌN DẸP PHIÊN BẢN CŨ
-- =============================================================================
local ENV=(getgenv and getgenv())or _G for v=46,37,-1 do local fn=ENV["CB"..v.."_STOP"]if type(fn)=="function"then pcall(fn)end end
ENV.__CB46_TP_RAN=nil ENV.__CB45_TP_RAN=nil
if game and game.IsLoaded and not game:IsLoaded()and game.Loaded then pcall(function()game.Loaded:Wait()end)end
local CFG={
  -- Khởi tạo bảng cấu hình trung tâm CFG (URL Proxy chính, danh sách Proxy dự phòng, ngưỡng thời gian và giới hạn)
  SCRIPT_URL=(type(ENV.CB46_SCRIPT_URL)=="string"and ENV.CB46_SCRIPT_URL)or(type(ENV.CB45_SCRIPT_URL)=="string"and ENV.CB45_SCRIPT_URL)or(type(ENV.CB44_SCRIPT_URL)=="string"and ENV.CB44_SCRIPT_URL)or(type(ENV.CB43_SCRIPT_URL)=="string"and ENV.CB43_SCRIPT_URL)or(type(ENV.CB42_SCRIPT_URL)=="string"and ENV.CB42_SCRIPT_URL)or"",
  -- BOSS_URL: Server Boss (Render.com) chỉ dùng để quản lý các server & host Bot Discord 24/7 (không chứa dữ liệu player)
  BOSS_URL=(type(ENV.CB46_BOSS_URL)=="string"and ENV.CB46_BOSS_URL~=""and ENV.CB46_BOSS_URL)or(type(ENV.CB45_BOSS_URL)=="string"and ENV.CB45_BOSS_URL~=""and ENV.CB45_BOSS_URL)or"https://cb45-boss.onrender.com",
  -- PROXY & PROXIES: 4 Server Backup (Cloudflare Workers) — Nơi player trò chuyện và mọi server liên kết Mesh với nhau
  PROXY=(type(ENV.CB46_BACKUP_URL)=="string"and ENV.CB46_BACKUP_URL~=""and ENV.CB46_BACKUP_URL)or(type(ENV.CB45_BACKUP_URL)=="string"and ENV.CB45_BACKUP_URL~=""and ENV.CB45_BACKUP_URL)or"https://cb-roblox.phwphat5555.workers.dev",
  PROXIES={
    "https://cb-roblox.phwphat5555.workers.dev",       -- [BACKUP #1 - CLOUDFLARE] Nơi player trò chuyện (Liên kết Mesh)
    "https://backup.phwphat8888.workers.dev",          -- [BACKUP #2 - CLOUDFLARE] Nơi player trò chuyện (Liên kết Mesh)
    "https://backupv2.sillydumb111.workers.dev",       -- [BACKUP #3 - CLOUDFLARE] Nơi player trò chuyện (Liên kết Mesh)
    "https://backupv3.just-a-blur-000.workers.dev",    -- [BACKUP #4 - CLOUDFLARE] Nơi player trò chuyện (Liên kết Mesh)
  },DEVELOPERS={phwphat5555=true},PREFIX="CB42:",LEGACY={},
  VERSION="46.0",SUGGEST_WEBHOOK="https://discord.com/api/webhooks/1568617557253034088/0KYh9iHsjtuYEnR_rS5H-uv9q--V45SXJ0OEQDeSDMAemr9_LOAuqJkeY8qatxd0VDZl",
  BUG_WEBHOOK="https://discord.com/api/webhooks/1568617762371412090/bh_C8jdRsA91WKguiKryM48BpXX1cC7jOAT5C0RenJ9NnlTUnkf8RBtYZF4kCpru29sz",
  LONGPOLL=12,POLL_FAST=0.35,POLL_IDLE=1.5,POLL_AFK=3.5,LP_RETRY=30,HEARTBEAT=90,PRESENCE_TIMEOUT=150,SWEEP=12,OVERLAP_MS=15000,HISTORY=60,MAX_MESSAGES=250,MAX_RENDER=50,MAX_CONTENT=800,
  TYPING_TIMEOUT=4,TYPING_THROTTLE=1.5,REACT_THRO=0.4,GROUP_SECS=300,MENTION_SOUND="rbxassetid://6042053626",MIN_W=60,MIN_H=60,SEEN_MAX=1500,SAVE_THROTTLE=3,GAME_CACHE_TTL=7200,}for v=46,43,-1 do table.insert(CFG.LEGACY,"CB"..v..":")end for v=41,19,-1 do table.insert(CFG.LEGACY,"CB"..v..":")end

-- =============================================================================
-- 2. DANH SÁCH CẢM XÚC NHANH, SHORTCODE & KHO EMOJI UNICODE MẶC ĐỊNH
-- =============================================================================
CFG.REACT={"👍","😂","🔥","💀","😭","👀","🙏","💔","😎","💢","🌹","🐧","🎉","😮","😢","💖","🚨","😍","😡","👑","🙄","💯","💎","🚀"}CFG.SHORTCODES={fire="🔥",heart="💖",love="😍",skull="💀",joy="😂",laugh="😆",
  sob="😭",cry="😢",smile="😄",cool="😎",angry="😡",thinking="😮",thumbsup="👍",like="👍",thumbsdown="👎",dislike="👎",["100"]="💯",sparkles="💫",star="🌟",crown="👑",eyes="👀",check="👍",ok="👌",
  x="💢",no="👎",warning="🚨",rocket="🚀",wave="👋",pray="🙏",party="🎉",tada="🎉",clap="👏",gg="🏆",gem="💎",zap="💥",lightning="💥",rose="🌹",ghost="👻",muscle="💪",brain="💡",}CFG.EMOJI={
  face={"😀","😃","😄","😁","😆","😅","😂","😊","😇","🙂","🙃","😉","😌","😍","😘","😗","😙","😚","😋","😛","😜","😝","😐","😑","😶","😏","😒","🙄","😬","😮","😯","😲","😴","😵","😎","😕","😟","🙁","😮","😨","😰","😥","😢","😭","😱","😖","😣","😞","😓","😩","😫","😤","😡","😠","😈","👿","💀","💩","👻","👹","👺","👽","👾","😺","😸","😹","😻","😼","😽","🙀","😿","😾"},
  hand={"👍","👎","👌","👊","✊","👋","👏","👐","🙌","🙏","👈","👉","👆","👇","💪","👀","👑","💋","💍","💎"},
  sym={"🔥","💯","🌟","💥","💫","🎉","🎊","🎁","🏆","🏅","💎","💰","💵","💸","🚨","🔔","🎵","🎶","🎮","🎲","🎯","💖","💗","💓","💞","💕","💘","💝","💔","💛","💚","💙","💜","💟","🚀","🔰","🔱","🔧","🔨","🔑","🔒","🔓","💬","💭","📢","💢","💤","💣","💦","💧","💨","💡"},
  obj={"🐧","🐶","🐱","🐭","🐹","🐰","🐻","🐼","🐨","🐯","🐮","🐷","🐸","🐵","🙈","🙉","🙊","🐔","🐦","🐤","🐺","🐗","🐴","🐝","🐛","🐌","🐞","🐜","🐢","🐍","🐙","🐠","🐟","🐬","🐳","🐋","🍕","🍔","🍟","🍗","🍖","🍝","🍛","🍣","🍱","🍜","🍙","🍚","🍦","🍧","🍨","🍩","🍪","🎂","🍰","🍫","🍬","🍭","🍺","🍻","🍷","🍸","🍹","🍎","🍊","🍋","🍒","🍇","🍉","🍓","🍑","🍈","🍌","🍐","🍍","🌹","🌸","🌺","🌻","🌼","🌷","🍀","🍁","🍂","🍃","🍄","🌈","🌙","🌎","🌋","🌊"},}

-- =============================================================================
-- 3. KHỞI TẠO DỊCH VỤ ROBLOX (SERVICES) & NHẬN DIỆN EXECUTOR HTTP
-- =============================================================================
local Players=game:GetService("Players")local UIS=game:GetService("UserInputService")local HttpService=game:GetService("HttpService")local TeleportService=game:GetService("TeleportService")
local SoundService=game:GetService("SoundService")local ContentProvider=game:GetService("ContentProvider")local TextService=game:GetService("TextService")local TweenService=game:GetService("TweenService")local Debris=game:GetService("Debris")
local LP=Players.LocalPlayer
if not LP then
  pcall(function()
    local t0=os.clock()
    repeat task.wait(0.05);LP=Players.LocalPlayer until LP or os.clock()-t0>15
  end)
  if not LP then return end
end
local IS_MOBILE=UIS.TouchEnabled and not UIS.KeyboardEnabled
--- [viewNow] Lấy kích thước khung nhìn màn hình hiện tại (ViewportSize), mặc định 1280x720 nếu Camera chưa sẵn sàng
local function viewNow()local cam=workspace.CurrentCamera
  if cam and cam.ViewportSize.X>1 then return cam.ViewportSize end return Vector2.new(1280,720)end
local httpFn=(type(syn)=="table"and syn.request)or(type(request)=="function"and request)
or(type(http_request)=="function"and http_request)or(type(http)=="table"and http.request)or(type(fluxus)=="table"and fluxus.request)or(type(xeno)=="table"and xeno.request)or(type(delta)=="table"and delta.request)
if not httpFn then warn("[CB46] Executor does not support HTTP / Executor không có HTTP.")return end
local EXEC=IS_MOBILE and"Delta"or"Xeno"pcall(function()if identifyexecutor then EXEC=tostring(identifyexecutor())end end)

-- =============================================================================
-- 4. BẢNG TRUNG TÂM (P, S, U, F, H) & CÁC HÀM TIỆN ÍCH CƠ BẢN (H.*)
-- =============================================================================
local P,S,U,F,H={},{},{},{},{}local u2,uo,us,u1=UDim2.new,UDim2.fromOffset,UDim2.fromScale,UDim.new local rgb,c3,v2=Color3.fromRGB,Color3.new,Vector2.new
local fGB,fG,fCode=Enum.Font.GothamBold,Enum.Font.Gotham,Enum.Font.Code local asY,asX,soLO=Enum.AutomaticSize.Y,Enum.AutomaticSize.X,Enum.SortOrder.LayoutOrder
local fdH,fdV,vaC=Enum.FillDirection.Horizontal,Enum.FillDirection.Vertical,Enum.VerticalAlignment.Center
local txL,txC,txR,trEnd=Enum.TextXAlignment.Left,Enum.TextXAlignment.Center,Enum.TextXAlignment.Right,Enum.TextTruncate.AtEnd
local smBorder,mb1,utTouch=Enum.ApplyStrokeMode.Border,Enum.UserInputType.MouseButton1,Enum.UserInputType.Touch local clamp,floor,max,min=math.clamp,math.floor,math.max,math.min
local tinsert,tremove,tconcat,tsort=table.insert,table.remove,table.concat,table.sort
--- [H.jenc] Mã hóa bảng Lua sang chuỗi JSON an toàn (bọc trong pcall)
function H.jenc(v)local ok,s=pcall(HttpService.JSONEncode,HttpService,v);return ok and s or nil end
--- [H.jdec] Giải mã chuỗi JSON sang bảng Lua an toàn (trả về nil nếu lỗi hoặc chuỗi rỗng)
function H.jdec(s)
  if type(s)~="string"or s==""then return nil end
  local ok,v=pcall(HttpService.JSONDecode,HttpService,s)return ok and v or nil end
--- [H.now] Lấy thời gian Unix timestamp hiện tại (giây)
function H.now()return os.time()end
--- [H.uuid] Tạo mã định danh duy nhất (GUID/UUID) không kèm dấu ngoặc nhọn
function H.uuid()return HttpService:GenerateGUID(false)end
--- [H.num] Định dạng số nguyên thành chuỗi không có phần thập phân
function H.num(n)return string.format("%.0f",tonumber(n)or 0)end
--- [H.url] Mã hóa chuỗi an toàn để gắn vào tham số URL (URL Encode)
function H.url(s)return HttpService:UrlEncode(tostring(s or""))end
--- [H.trim] Cắt bỏ khoảng trắng ở đầu và cuối chuỗi
function H.trim(s)return(tostring(s or""):gsub("^%s+",""):gsub("%s+$",""))end
--- [H.esc] Thoát các ký tự đặc biệt (&, <, >) để hiển thị an toàn trong RichText
function H.esc(s)return(tostring(s or""):gsub("&","&amp;"):gsub("<","&lt;"):gsub(">","&gt;"))end
--- [H.clip] Cắt ngắn chuỗi UTF-8 theo giới hạn byte `n` mà không làm đứt gãy ký tự đa byte, thêm dấu '…'
function H.clip(s,n)s=tostring(s or"")
  if#s<=n then return s end
  local cut=n while cut>0 do local b=s:byte(cut+1)if b and b>=0x80 and b<0xC0 then cut=cut-1 else break end end return s:sub(1,cut).."…"end

-- =============================================================================
-- 5. XỬ LÝ MÀU SẮC HEX, ĐỘ TƯƠNG PHẢN WCAG & ĐO KÍCH THƯỚC VĂN BẢN
-- =============================================================================
do local HEX_CACHE,HEX_N={},0
--- [H.hex] Chuyển đổi mã màu Hex (#RRGGBB) sang đối tượng Color3 (có bộ nhớ đệm HEX_CACHE giới hạn 500 mục)
function H.hex(h,fallback)
  local k=tostring(h or"")local cached=HEX_CACHE[k]if cached then return cached end
  local s=k:gsub("#","")if not s:match("^%x%x%x%x%x%x$")then return fallback or rgb(88,101,242)end
  if HEX_N>=500 then HEX_CACHE,HEX_N={},0 end
  local c=rgb(tonumber(s:sub(1,2),16),tonumber(s:sub(3,4),16),tonumber(s:sub(5,6),16))HEX_CACHE[k]=c HEX_N=HEX_N+1 return c end
end
--- [H.tohex] Chuyển đổi đối tượng Color3 sang chuỗi mã màu Hex (#RRGGBB)
function H.tohex(c)
  return string.format("#%02X%02X%02X",clamp(floor(c.R*255+0.5),0,255),clamp(floor(c.G*255+0.5),0,255),clamp(floor(c.B*255+0.5),0,255))end
--- [H.safeHex] Kiểm tra mã màu Hex hợp lệ, trả về màu mặc định nếu sai định dạng
function H.safeHex(c,d)c=tostring(c or"")
  if c:match("^#%x%x%x%x%x%x$")then return c end return d or"#5865F2"end
--- [H.lum] Tính độ chói tương đối (Relative Luminance) của màu theo chuẩn WCAG
function H.lum(c)
  local function f(x)if x<=0.03928 then return x/12.92 end return((x+0.055)/1.055)^2.4 end
  return 0.2126*f(c.R)+0.7152*f(c.G)+0.0722*f(c.B)end
--- [H.contrast] Tính tỷ lệ tương phản (Contrast Ratio) giữa hai màu a và b
function H.contrast(a,b)local la,lb=H.lum(a),H.lum(b)if la<lb then la,lb=lb,la end return(la+0.05)/(lb+0.05)end
--- [H.mix] Nội suy tuyến tính (pha trộn) giữa hai màu a và b theo hệ số t (0..1)
function H.mix(a,b,t)return c3(a.R+(b.R-a.R)*t,a.G+(b.G-a.G)*t,a.B+(b.B-a.B)*t)end
--- [H.ensureContrast] Tự động điều chỉnh màu chữ (fg) để đảm bảo độ tương phản tối thiểu `minR` so với màu nền (bg)
function H.ensureContrast(fg,bg,minR)minR=minR or 4.2 if H.contrast(fg,bg)>=minR then return fg end
  local target=H.lum(bg)<0.45 and c3(1,1,1)or rgb(18,18,24) for step=1,8 do local cand=H.mix(fg,target,step/8)if H.contrast(cand,bg)>=minR then return cand end end return H.mix(fg,target,0.75)end
local TW_CACHE,TW_COUNT,TW_BOUNDS={},0,v2(1000,100)
--- [H.textW] Đo chiều rộng pixel của văn bản theo cỡ chữ và font (có cache TW_CACHE tối đa 900 mục)
function H.textW(text,ts,font)local s=tostring(text or"")if s==""then return 0 end
  ts=ts or 12 font=font or fGB local key=tostring(font)..":"..ts..":"..s local v=TW_CACHE[key]if v then return v end
  local ok,sz=pcall(TextService.GetTextSize,TextService,s,ts,font,TW_BOUNDS)
  v=(ok and sz)and math.ceil(sz.X)or(#s*floor(ts*0.62))if TW_COUNT>=900 then TW_CACHE,TW_COUNT={},0 end TW_CACHE[key],TW_COUNT=v,TW_COUNT+1 return v end
--- [H.shortTime] Định dạng Unix timestamp sang chuỗi giờ:phút (HH:MM)
function H.shortTime(ts)ts=tonumber(ts)
  if not ts or ts<=0 then return""end
  local d=os.date("*t",ts)return string.format("%02d:%02d",d.hour,d.min)end
--- [H.assetId] Trích xuất ID số (5-15 chữ số) từ đường dẫn rbxassetid://, img:, hoặc URL Roblox Library/Catalog
function H.assetId(raw)raw=H.trim(raw)
  local id=raw:match("^rbxassetid://(%d+)")or raw:match("^img:(%d+)$")or raw:match("/library/(%d+)")or raw:match("/catalog/(%d+)")or raw:match("[?&]id=(%d+)")or(raw:match("^%d+$")and raw or nil)
  if id and#id>=5 and#id<=15 then return id end end

-- =============================================================================
-- 6. BẢNG THAY THẾ EMOJI LỖI TRÊN ROBLOX & CHUYỂN ĐỔI CỜ QUỐC GIA
-- =============================================================================
local ROBLOX_EMOJI_FALLBACK={[0x1F309]="💬",[0x1F6E1]="👑",[0x1F9F9]="",[0x1F5D1]="",[0x1F4E8]="💬",[0x1F441]="👀",[0x23F9]="",[0x21A9]="↩",[0x21BA]="↩",[0x21BB]="",[0x1F940]="🌹",[0x1F976]="😰",
  [0x1F975]="🔥",[0x1F97A]="😢",[0x1F973]="🎉",[0x1F971]="😴",[0x1F92A]="😜",[0x1F92D]="😅",[0x1F92B]="😶",[0x1F92F]="😱",[0x1F92C]="😡",[0x1F929]="😍",[0x1F9E1]="💖",[0x1F90D]="💖",[0x1F90E]="💖",
  [0x2764]="💖",[0x2665]="💖",[0x1F5A4]="💖",[0x1F5FF]="😎",[0x1F923]="😂",[0x1F921]="👻",[0x1F913]="😎",[0x1F914]="😮",[0x1F910]="😶",[0x1F911]="😎",[0x1F916]="👽",[0x1F917]="😊",[0x1F920]="😎",[0x1F924]="😋",
  [0x1F918]="👌",[0x1F919]="👌",[0x1F91A]="👋",[0x1F91D]="👏",[0x1F91E]="🙏",[0x1F590]="👋",[0x1F596]="👋",[0x1F9E0]="💡",[0x1F9EA]="💎",[0x2705]="👍",[0x274C]="💢",[0x2728]="💫",[0x2B50]="🌟",[0x26A1]="💥",
  [0x26A0]="🚨",[0x2600]="🌟",[0x2601]="",[0x2744]="",[0x2615]="🍺",[0x270C]="👌",[0x261D]="👆",[0x2709]="",[0x270F]="",[0x2699]="⚙️",[0x26D4]="🚨",[0x23F3]="⏳",[0x2713]="✓",[0x2714]="✓",[0x2715]="×",[0x2716]="×",
  [0x27A4]=">",[0x2922]="",[0x25C9]="•",[0x25E2]="//",[0x2696]="🚨",[0x2705]="👍",[0x270D]="✍️",}
--- [emojiWalk] Duyệt từng mã Unicode (codepoint) trong chuỗi để thay thế các emoji bị lỗi hiển thị trên Roblox bằng emoji tương đương
local function emojiWalk(s,stopZwj)s=tostring(s or"")local out,buf={},{}
  local function flush()if#buf==2 then out[#out+1]=utf8.char(buf[1],buf[2])elseif#buf==1 then out[#out+1]=utf8.char(buf[1])end buf={}end
  local ok=pcall(function()for _,cp in utf8.codes(s)do if cp==0x200D then if stopZwj then break end elseif cp==0xFE0F or cp==0xFE0E or cp==0x20E3 or(cp>=0x1F3FB and cp<=0x1F3FF)then elseif cp>=0x1F1E6 and cp<=0x1F1FF then
        buf[#buf+1]=cp if#buf==2 then flush()end else flush()local fb=ROBLOX_EMOJI_FALLBACK[cp]if fb~=nil then out[#out+1]=fb elseif(cp>=0x1F900 and cp<=0x1FAFF)or(cp>=0x2600 and cp<=0x27BF)then out[#out+1]=stopZwj and"💬"or""else out[#out+1]=utf8.char(cp)end end end flush()end)if not ok then return nil end return tconcat(out)end
--- [H.safeText] Làm sạch văn bản chứa emoji phức hợp để hiển thị không bị ô vuông [?] trên Roblox
function H.safeText(s)return emojiWalk(s,false)or tostring(s or"")end
--- [H.safeEmoji] Làm sạch một ký tự emoji đơn lẻ (dừng tại ZWJ) để hiển thị trên nút hoặc nhãn
function H.safeEmoji(s)local r=emojiWalk(s,true)if not r or r==""then return"?"end return r end
local COUNTRY_MAP={
  ["vietnam"]="VN",["viet nam"]="VN",["việt nam"]="VN",["vnm"]="VN",["vn"]="VN",
  ["israel"]="IL",["isreal"]="IL",["isarel"]="IL",["isr"]="IL",["il"]="IL",["nha nuoc israel"]="IL",
  ["ukraine"]="UA",["ukraina"]="UA",["ukrain"]="UA",["ukrane"]="UA",["ukr"]="UA",["ua"]="UA",["u-crai-na"]="UA",["ucraina"]="UA",
  ["united states"]="US",["united states of america"]="US",["usa"]="US",["america"]="US",["us"]="US",["mỹ"]="US",["hoa ky"]="US",["hoa kỳ"]="US",
  ["united kingdom"]="GB",["great britain"]="GB",["britain"]="GB",["england"]="GB",["scotland"]="GB",["wales"]="GB",["uk"]="GB",["gbr"]="GB",["gb"]="GB",["anh"]="GB",["vương quốc anh"]="GB",
  ["russia"]="RU",["russian federation"]="RU",["russian"]="RU",["rus"]="RU",["ru"]="RU",["nga"]="RU",["liên bang nga"]="RU",
  ["japan"]="JP",["jpn"]="JP",["jp"]="JP",["nhat"]="JP",["nhật"]="JP",["nhat ban"]="JP",["nhật bản"]="JP",
  ["south korea"]="KR",["korea"]="KR",["republic of korea"]="KR",["kor"]="KR",["kr"]="KR",["han quoc"]="KR",["hàn quốc"]="KR",["nam han"]="KR",
  ["north korea"]="KP",["dprk"]="KP",["prk"]="KP",["kp"]="KP",["trieu tien"]="KP",["triều tiên"]="KP",["bac han"]="KP",
  ["china"]="CN",["prc"]="CN",["chn"]="CN",["cn"]="CN",["trung quoc"]="CN",["trung quốc"]="CN",
  ["taiwan"]="TW",["twn"]="TW",["tw"]="TW",["dai loan"]="TW",["đài loan"]="TW",
  ["hong kong"]="HK",["hongkong"]="HK",["hkg"]="HK",["hk"]="HK",
  ["thailand"]="TH",["tha"]="TH",["th"]="TH",["thai lan"]="TH",["thái lan"]="TH",
  ["indonesia"]="ID",["indo"]="ID",["idn"]="ID",["id"]="ID",
  ["philippines"]="PH",["philippine"]="PH",["phl"]="PH",["phi"]="PH",["ph"]="PH",
  ["malaysia"]="MY",["mys"]="MY",["my"]="MY",["ma lai"]="MY",
  ["singapore"]="SG",["sgp"]="SG",["sg"]="SG",
  ["cambodia"]="KH",["campuchia"]="KH",["khm"]="KH",["kh"]="KH",
  ["laos"]="LA",["lao"]="LA",["lào"]="LA",["la"]="LA",
  ["myanmar"]="MM",["burma"]="MM",["mmr"]="MM",["mm"]="MM",
  ["brunei"]="BN",["brn"]="BN",["bn"]="BN",
  ["india"]="IN",["ind"]="IN",["in"]="IN",["an do"]="IN",["ấn độ"]="IN",
  ["pakistan"]="PK",["pak"]="PK",["pk"]="PK",
  ["bangladesh"]="BD",["bgd"]="BD",["bd"]="BD",
  ["australia"]="AU",["aus"]="AU",["au"]="AU",["uc"]="AU",["úc"]="AU",
  ["new zealand"]="NZ",["nzl"]="NZ",["nz"]="NZ",
  ["canada"]="CA",["can"]="CA",["ca"]="CA",
  ["mexico"]="MX",["mex"]="MX",["mx"]="MX",
  ["brazil"]="BR",["brasil"]="BR",["bra"]="BR",["br"]="BR",
  ["argentina"]="AR",["arg"]="AR",["ar"]="AR",
  ["chile"]="CL",["chl"]="CL",["cl"]="CL",
  ["colombia"]="CO",["col"]="CO",["co"]="CO",
  ["peru"]="PE",["per"]="PE",["pe"]="PE",
  ["venezuela"]="VE",["ven"]="VE",["ve"]="VE",
  ["cuba"]="CU",["cub"]="CU",["cu"]="CU",
  ["france"]="FR",["fra"]="FR",["fr"]="FR",["phap"]="FR",["pháp"]="FR",
  ["germany"]="DE",["deutschland"]="DE",["deu"]="DE",["ger"]="DE",["de"]="DE",["duc"]="DE",["đức"]="DE",
  ["italy"]="IT",["italia"]="IT",["ita"]="IT",["it"]="IT",["ý"]="IT",
  ["spain"]="ES",["espana"]="ES",["españa"]="ES",["esp"]="ES",["es"]="ES",["tay ban nha"]="ES",["tây ban nha"]="ES",
  ["portugal"]="PT",["prt"]="PT",["pt"]="PT",["bo dao nha"]="PT",["bồ đào nha"]="PT",
  ["netherlands"]="NL",["holland"]="NL",["nld"]="NL",["nl"]="NL",["ha lan"]="NL",["hà lan"]="NL",
  ["belgium"]="BE",["bel"]="BE",["be"]="BE",["bỉ"]="BE",
  ["switzerland"]="CH",["swiss"]="CH",["che"]="CH",["ch"]="CH",["thuy si"]="CH",["thụy sĩ"]="CH",
  ["austria"]="AT",["aut"]="AT",["at"]="AT",["áo"]="AT",
  ["poland"]="PL",["pol"]="PL",["pl"]="PL",["ba lan"]="PL",
  ["sweden"]="SE",["swe"]="SE",["se"]="SE",["thuy dien"]="SE",["thụy điển"]="SE",
  ["norway"]="NO",["nor"]="NO",["no"]="NO",["na uy"]="NO",
  ["finland"]="FI",["fin"]="FI",["fi"]="FI",["phan lan"]="FI",["phần lan"]="FI",
  ["denmark"]="DK",["dnk"]="DK",["dk"]="DK",["dan mach"]="DK",["đan mạch"]="DK",
  ["iceland"]="IS",["isl"]="IS",["is"]="IS",
  ["ireland"]="IE",["irl"]="IE",["ie"]="IE",
  ["greece"]="GR",["grc"]="GR",["gr"]="GR",["hy lap"]="GR",["hy lạp"]="GR",
  ["turkey"]="TR",["turkiye"]="TR",["türkiye"]="TR",["tur"]="TR",["tr"]="TR",["tho nhi ky"]="TR",["thổ nhĩ kỳ"]="TR",
  ["romania"]="RO",["rou"]="RO",["ro"]="RO",
  ["hungary"]="HU",["hun"]="HU",["hu"]="HU",
  ["czech"]="CZ",["czechia"]="CZ",["czech republic"]="CZ",["cze"]="CZ",["cz"]="CZ",["sec"]="CZ",["séc"]="CZ",
  ["slovakia"]="SK",["svk"]="SK",["sk"]="SK",
  ["bulgaria"]="BG",["bgr"]="BG",["bg"]="BG",
  ["croatia"]="HR",["hrv"]="HR",["hr"]="HR",
  ["serbia"]="RS",["srb"]="RS",["rs"]="RS",
  ["belarus"]="BY",["blr"]="BY",["by"]="BY",
  ["palestine"]="PS",["pse"]="PS",["ps"]="PS",
  ["saudi arabia"]="SA",["saudi"]="SA",["sau"]="SA",["sa"]="SA",["ả rập xê út"]="SA",
  ["uae"]="AE",["united arab emirates"]="AE",["dubai"]="AE",["are"]="AE",["ae"]="AE",
  ["qatar"]="QA",["qat"]="QA",["qa"]="QA",
  ["kuwait"]="KW",["kwt"]="KW",["kw"]="KW",
  ["iran"]="IR",["irn"]="IR",["ir"]="IR",
  ["iraq"]="IQ",["irq"]="IQ",["iq"]="IQ",
  ["syria"]="SY",["syr"]="SY",["sy"]="SY",
  ["lebanon"]="LB",["lbn"]="LB",["lb"]="LB",
  ["jordan"]="JO",["jor"]="JO",["jo"]="JO",
  ["egypt"]="EG",["egy"]="EG",["eg"]="EG",["ai cap"]="EG",["ai cập"]="EG",
  ["south africa"]="ZA",["zaf"]="ZA",["za"]="ZA",["nam phi"]="ZA",
  ["nigeria"]="NG",["nga_ng"]="NG",["ng"]="NG",
  ["morocco"]="MA",["mar"]="MA",["ma"]="MA",
  ["algeria"]="DZ",["dza"]="DZ",["dz"]="DZ",
  ["tunisia"]="TN",["tun"]="TN",["tn"]="TN",
  ["kenya"]="KE",["ken"]="KE",["ke"]="KE",
  ["kazakhstan"]="KZ",["kaz"]="KZ",["kz"]="KZ",
  ["uzbekistan"]="UZ",["uzb"]="UZ",["uz"]="UZ",
  ["mongolia"]="MN",["mng"]="MN",["mn"]="MN",["mong co"]="MN",["mông cổ"]="MN",
  ["nepal"]="NP",["npl"]="NP",["np"]="NP",
  ["sri lanka"]="LK",["lka"]="LK",["lk"]="LK",
}
local COUNTRY_NAMES={
  VN="Vietnam",IL="Israel",UA="Ukraine",US="United States",GB="United Kingdom",RU="Russia",JP="Japan",KR="South Korea",KP="North Korea",
  CN="China",TW="Taiwan",HK="Hong Kong",TH="Thailand",ID="Indonesia",PH="Philippines",MY="Malaysia",SG="Singapore",KH="Cambodia",LA="Laos",
  MM="Myanmar",BN="Brunei",IN="India",PK="Pakistan",BD="Bangladesh",AU="Australia",NZ="New Zealand",CA="Canada",MX="Mexico",BR="Brazil",
  AR="Argentina",CL="Chile",CO="Colombia",PE="Peru",VE="Venezuela",CU="Cuba",FR="France",DE="Germany",IT="Italy",ES="Spain",PT="Portugal",
  NL="Netherlands",BE="Belgium",CH="Switzerland",AT="Austria",PL="Poland",SE="Sweden",NO="Norway",FI="Finland",DK="Denmark",IS="Iceland",
  IE="Ireland",GR="Greece",TR="Turkey",RO="Romania",HU="Hungary",CZ="Czechia",SK="Slovakia",BG="Bulgaria",HR="Croatia",RS="Serbia",
  BY="Belarus",PS="Palestine",SA="Saudi Arabia",AE="UAE",QA="Qatar",KW="Kuwait",IR="Iran",IQ="Iraq",SY="Syria",LB="Lebanon",JO="Jordan",
  EG="Egypt",ZA="South Africa",NG="Nigeria",MA="Morocco",DZ="Algeria",TN="Tunisia",KE="Kenya",KZ="Kazakhstan",UZ="Uzbekistan",MN="Mongolia",
  NP="Nepal",LK="Sri Lanka",
}
--- [H.resolveCountry] Giải mã chính xác tên quốc gia đầy đủ ("Israel", "Isreal", "Ukraine", "Vietnam"...), mã ISO hoặc emoji cờ sang mã ISO-2 chuẩn
function H.resolveCountry(raw)
  local s=H.trim(tostring(raw or""))
  if s==""or s=="??"then return"??"end
  -- Kiểm tra nếu chuỗi truyền vào có chứa emoji cờ quốc gia (Regional Indicator Symbols)
  local reg={}
  pcall(function()
    for _,cp in utf8.codes(s)do
      if cp>=0x1F1E6 and cp<=0x1F1FF then reg[#reg+1]=string.char(cp-0x1F1E6+65)end
    end
  end)
  if#reg>=2 then
    local fc=reg[1]..reg[2]
    return COUNTRY_MAP[fc:lower()]or fc
  end
  local clean=s:lower():gsub("[%.,!%?;:%-_%(%)%[%]\"'`~]+"," "):gsub("%s+"," "):match("^%s*(.-)%s*$")or""
  if clean==""then return"??"end
  if COUNTRY_MAP[clean]then return COUNTRY_MAP[clean]end
  -- Tìm khớp từ khóa cho tên quốc gia dài hoặc gõ dư từ
  for k,v in pairs(COUNTRY_MAP)do
    if#k>=4 and(clean:find(k,1,true)or k:find(clean,1,true))then return v end
  end
  if#clean==2 and clean:match("^%a%a$")then return clean:upper()end
  return"??"
end
--- [H.countryName] Trả về tên quốc gia đầy đủ từ mã ISO-2 (ví dụ "IL" -> "Israel", "UA" -> "Ukraine")
function H.countryName(code)
  local c=H.resolveCountry(code)
  return COUNTRY_NAMES[c]or(c~="??"and c or"Unknown")
end
--- [H.flag] Chuyển đổi mã quốc gia hoặc tên quốc gia sang emoji cờ quốc gia tương ứng
function H.flag(code)
  code=H.resolveCountry(code)
  if#code~=2 or code=="??"then return"🌐"end
  local a,b=code:byte(1)-65,code:byte(2)-65 if a<0 or a>25 or b<0 or b>25 then return"🌐"end return utf8.char(0x1F1E6+a,0x1F1E6+b)end
--- [F.safeTap] Chống bấm đúp (debounce) cho nút bấm theo khóa `id` và độ trễ `delay` (mặc định 0.28s)
function F.safeTap(id,fn,delay)delay=delay or 0.28 local now=os.clock()if S.tapLock[id]and now-S.tapLock[id]<delay then return end
  S.tapLock[id]=now fn()end

-- =============================================================================
-- 7. ĐỌC/GHI FILE LƯU TRỮ CỤC BỘ & TỪ ĐIỂN ĐA NGÔN NGỮ (VIỆT / ANH)
-- =============================================================================
local hasIO=type(writefile)=="function"and type(readfile)=="function"and type(isfile)=="function"
local FILE="cb46_"..tostring(LP.UserId)..".json"
local LAYOUT_FILE="cb46_layout.json"
local REJOIN_FILE="cb46_rejoin_state.json"
--- [loadSave] Đọc dữ liệu cài đặt, vị trí cửa sổ và trạng thái Rejoin từ file JSON cục bộ (tự động kế thừa từ bản v45 trở xuống)
local function loadSave()
  local out={}
  if hasIO then
    local names={FILE}for v=45,30,-1 do tinsert(names,"cb"..v.."_"..tostring(LP.UserId)..".json")end
    for _,f in ipairs(names)do local ok,raw=pcall(function()if isfile(f)then return readfile(f)end end)
      if ok and raw then local d=H.jdec(raw)if type(d)=="table"then out=d;break end end end
    pcall(function()for _,lf in ipairs({LAYOUT_FILE,"cb45_layout.json","cb44_layout.json","cb42_layout.json"})do if isfile(lf)then local ly=H.jdec(readfile(lf))if type(ly)=="table"then
          for _,k in ipairs({"winX","winY","W","H","prevW","prevH","miniX","miniY","minimized"})do if ly[k]~=nil then out[k]=ly[k]end end return end end end end)
    pcall(function()for _,rf in ipairs({REJOIN_FILE,"cb45_rejoin_state.json","cb44_rejoin_state.json","cb42_rejoin_state.json"})do if isfile(rf)then local rj=H.jdec(readfile(rf))if type(rj)=="table"then out._rejoinState=rj;return end end end end)
  end
  local envLayout=type(ENV.CB46_LAYOUT)=="table"and ENV.CB46_LAYOUT or(type(ENV.CB45_LAYOUT)=="table"and ENV.CB45_LAYOUT or(type(ENV.CB44_LAYOUT)=="table"and ENV.CB44_LAYOUT or(type(ENV.CB43_LAYOUT)=="table"and ENV.CB43_LAYOUT or ENV.CB42_LAYOUT)))
  if type(envLayout)=="table"then
    for _,k in ipairs({"winX","winY","W","H","prevW","prevH","miniX","miniY","minimized"})do if envLayout[k]~=nil then out[k]=envLayout[k]end end
  end
  return out end
local saved=loadSave()
local isRejoinSession=type(saved._rejoinState)=="table"and tonumber(saved._rejoinState.placeId)==game.PlaceId and(os.time()-(tonumber(saved._rejoinState.ts)or 0))<180
if hasIO and type(delfile)=="function"then pcall(function()if isfile(REJOIN_FILE)then delfile(REJOIN_FILE)end end)end
local TXT={title={"Chat Bridge","Chat Bridge"},send={"Gửi","Send"},
  -- Từ điển chuỗi giao diện song ngữ: mỗi khóa gồm { [1] = Tiếng Việt, [2] = Tiếng Anh }
  input={"Nhắn tin…","Message…"},online={"Online","Online"},typing={" đang gõ"," typing"},reply={"Trả lời","Reply"},edit={"Sửa","Edit"},delete={"Xóa","Delete"},copy={"Copy","Copy"},save={"Lưu","Save"},
  cancel={"Hủy","Cancel"},profile={"Hồ sơ","Profile"},settings={"Cài đặt","Settings"},dm={"Nhắn riêng","Direct message"},join={"Vào game","Join game"},general={"Chung","General"},game={"Game","Game"},
  dmtab={"DM","DM"},stafftab={"Staff","Staff"},ready={"Đã kết nối.","Connected."},send_fail={"Gửi lỗi.","Send failed."},pick_dm={"Chọn người trong DM.","Pick someone in DM."},no_dm={"Chưa có DM.","No DMs yet."},
  too_long={"Tin quá dài.","Too long."},muted={"Bạn đang bị cấm chat","You are muted"},you_muted={"Bạn bị cấm chat","You are muted"},edited={"(đã sửa)","(edited)"},
  failed={"(chưa gửi)","(not sent)"},resend={"Gửi lại","Resend"},poll={"Bình chọn","Poll"},poll_q={"Câu hỏi","Question"},poll_create={"Tạo","Create"},
  poll_multi={"Chọn nhiều","Multi-choice"},poll_close={"Đóng poll","Close poll"},closed={"Đã đóng","Closed"},no_poll_dm={"Không tạo poll trong DM","No polls in DM"},
  react={"Cảm xúc","React"},custom={"Emoji / ID ảnh / link","Emoji / Image ID / link"},add={"Thêm","Add"},clear={"Xóa tất cả ảnh","Clear images"},theme={"Giao diện","Theme"},preset={"Mẫu","Presets"},
  alpha={"Độ trong suốt","Transparency"},stop={"Dừng script","Stop script"},saved_ok={"Đã lưu.","Saved."},search={"Tìm tin…","Find…"},report={"Báo cáo","Report"},warn={"Cảnh báo","Warn"},
  mute={"Cấm chat","Mute"},unmute={"Gỡ cấm","Unmute"},clear_warn={"Gỡ cảnh báo","Clear warns"},notify={"Thông báo","Notifications"},sound={"Âm mention","Mention sound"},
  bubble={"Bubble trên đầu","Head bubble"},safe_emoji={"Emoji an toàn","Safe emoji"},share={"Chia sẻ game","Share game"},text_size={"Cỡ chữ","Text size"},preview={"Xem trước thông báo","Notification preview"},
  compact={"Luôn gọn","Force compact"},same_user={"Icon cùng server","Same-server icon"},view_as={"Xem như người khác","View as others"},view_self={"Chế độ sửa của bạn","Your edit view"},
  window={"Cửa sổ","Window"},toast_pos={"Vị trí toast","Toast position"},language={"Ngôn ngữ","Language"},roles={"Role","Roles"},staff_only={"Chỉ Staff.","Staff only."},no_perm={"Không có quyền.","No permission."},
  hier={"Không thể thao tác người có quyền cao hơn.","Cannot act on higher rank."},no_ping={"Không có quyền @everyone/@here.","No @everyone/@here permission."},
  admin={"Quản trị","Admin"},reports={"Report gần đây","Recent reports"},no_reports={"Không có report.","No reports."},dismiss={"Ẩn","Dismiss"},ack={"Đã nhận","Ack"},
  reason={"Lý do","Reason"},minutes={"Phút (0 = vĩnh viễn)","Minutes (0 = permanent)"},target={"Đối tượng","Target"},is_public={"Công khai","Public"},is_private={"Riêng tư","Private"},
  report_sent={"Đã gửi report.","Report sent."},mute_sent={"Đã cấm chat.","Muted."},warn_sent={"Đã cảnh báo.","Warned."},need_reason={"Nhập lý do.","Enter a reason."},
  playing={"Đang chơi: ","Playing: "},not_sharing={"Không chia sẻ game","Not sharing game"},status={"Trạng thái","Status"},bio={"Tiểu sử","Bio"},name={"Tên hiển thị","Display name"},
  country={"Quốc gia (2 chữ)","Country (2 letters)"},live={"Đang online","Online"},off={"Offline","Offline"},reply_to={"Trả lời ","Replying to "},editing={"Đang sửa tin","Editing"},
  conn_ok={"Kết nối tốt","Connected"},conn_bad={"Mất kết nối","Offline"},users={"Người online","People online"},warnings={"Cảnh báo","Warnings"},copy_ok={"Đã copy.","Copied."},small={"Nhỏ","Small"},mid={"Vừa","Mid"},
  fit_screen={"Vừa màn","Fit screen"},theme_preview={"Xem trước","Preview"},sec_general={"Chung","General"},sec_appear={"Giao diện","Appearance"},
  sec_account={"Tài khoản","Account"},sec_data={"Dữ liệu","Data"},sec_dev={"Nhà phát triển","Developer"},group_msgs={"Gộp tin liên tiếp","Group consecutive"},
  jump_new={"Tin mới","New"},img_tag={"[ảnh]","[image]"},you={"bạn","you"},pick_user={"Chọn người dùng","Pick a user"},search_user={"Tìm tên / username","Search name"},
  roblox_find={"Tìm trên Roblox: ","Find on Roblox: "},not_found={"Không tìm thấy.","User not found."},accent_quick={"Màu nhấn","Quick accent"},custom_colors={"Tùy chỉnh từng màu","Custom colors"},
  grp_bg={"Nền","Backgrounds"},grp_text={"Chữ","Text"},grp_accent={"Nhấn & tin nhắn","Accent & messages"},grp_state={"Trạng thái","States"},
  ck_bg={"Nền chính","Background"},ck_bg2={"Nền thẻ tin","Message cards"},ck_bg3={"Nền nút / ô nhập","Buttons / inputs"},
  ck_title={"Thanh tiêu đề","Title bar"},ck_text={"Chữ chính","Text"},ck_muted={"Chữ phụ","Muted text"},ck_accent={"Màu nhấn","Accent"},ck_own={"Tin của tôi","My messages"},ck_mention={"Nền tin nhắc tên","Mention card bg"},ck_mentionText={"Chữ @mention","@Mention color"},ck_emojiText={"Màu :Custom_emoji:",":Custom_emoji: color"},
  ck_danger={"Nguy hiểm","Danger"},ck_ok={"Thành công","Success"},ck_warn={"Cảnh báo","Warning"},auto_contrast={"Tự sửa độ tương phản","Auto-fix contrast"},contrast_done={"Đã chỉnh chữ.","Text adjusted."},
  theme_copy={"Sao chép mã theme","Copy theme code"},theme_import={"Nhập mã theme","Import theme"},theme_paste={"Dán mã CBT1:… vào đây","Paste CBT1:… code"},theme_bad={"Mã không hợp lệ.","Invalid code."},
  theme_ok={"Đã áp dụng theme.","Theme applied."},reset_all={"Đặt lại toàn bộ","Reset everything"},recent={"Gần đây","Recent"},
  tab_face={"Mặt","Faces"},tab_hand={"Tay","Hands"},tab_sym={"Biểu tượng","Symbols"},tab_obj={"Vật","Objects"},tab_img={"Ảnh","Images"},
  img_hint={"Dán ID hoặc link ảnh Roblox. Gửi trong tin dạng [img:ID].","Paste a Roblox image ID or link. Sent as [img:ID]."},
  bg_mode={"Kiểu nền","Background mode"},bg_solid={"Màu theme","Theme color"},bg_gradient={"Gradient","Gradient"},bg_image={"Ảnh","Image"},
  bg_image_id={"ID hoặc link ảnh Roblox","Roblox image ID or link"},bg_image_hint={"Chỉ dùng ảnh Roblox công khai. Dán ID hoặc link catalog/library.","Use a public Roblox image. Paste an ID or catalog/library link."},
  bg_apply={"Áp dụng ảnh nền","Apply background"},bg_clear={"Xóa ảnh nền","Clear image"},bg_opacity={"Độ hiện ảnh","Image opacity"},bg_dim={"Lớp phủ tối","Readability overlay"},
  bg_invalid={"ID/link ảnh Roblox không hợp lệ.","Invalid Roblox image ID/link."},bg_applied={"Đã cập nhật nền.","Background updated."},
  img_del_mode={"Chế độ xóa","Delete mode"},img_bad={"ID/link không hợp lệ.","Invalid ID/link."},img_full={"Đã đủ 24 ảnh.","24 images max."},emoji_pick={"Emoji / Ảnh","Emoji / Image"},
  role_new={"Tạo role","New role"},role_edit={"Sửa role","Edit role"},role_name={"Tên role","Role name"},role_color={"Màu","Color"},role_icon={"Icon (emoji / ảnh)","Icon (emoji / image)"},
  role_icon_clear={"Bỏ icon","No icon"},role_pos={"Vị trí (cao = mạnh)","Position (high = strong)"},role_admin={"Admin","Admin"},role_mention={"Được @everyone/@here","Can @everyone/@here"},
  members={"Thành viên","Members"},member_n={" thành viên"," members"},assign_user={"Gán role cho người dùng…","Assign roles…"},
  role_tpl={"Tạo nhanh từ mẫu","Quick templates"},role_saved={"Đã lưu role.","Role saved."},roles_fail={"Lưu role lỗi: ","Role save failed: "},roles_stale={"Role vừa đổi ở nơi khác, đã đồng bộ lại. Hãy thao tác lại.","Roles changed elsewhere, resynced. Please retry."},
  role_perm={"Quyền hạn","Permissions"},no_roles={"Chưa có role.","No roles yet."},role_name_req={"Nhập tên role.","Enter a role name."},color_palette={"Bảng màu chi tiết","Color picker"},
  request_title={"Xin quyền","Request access"},request_intro={"Chọn role muốn xin, ghi lý do ngắn. Dev sẽ duyệt trong Admin panel.","Pick a role, add a short reason. A Dev will review in the Admin panel."},
  request_role={"Role muốn xin","Role to request"},request_reason={"Lý do (ngắn gọn)","Reason (short)"},
  request_send={"Gửi yêu cầu","Send request"},request_sent={"Đã gửi yêu cầu. Chờ duyệt.","Request sent. Awaiting review."},request_pending={"Bạn có yêu cầu đang chờ duyệt.","You have a pending request."},
  request_none={"Chưa có role nào có thể xin.","No requestable roles."},approve={"Duyệt","Approve"},reject={"Từ chối","Reject"},ban={"Ban vĩnh viễn","Permanent ban"},
  requests={"Yêu cầu chờ duyệt","Pending requests"},no_requests={"Không có yêu cầu.","No requests."},revoke={"Thu hồi quyền","Revoke access"},revoked={"Đã thu hồi.","Revoked."},
  unban={"Gỡ ban","Unban"},unbanned={"Đã gỡ ban.","Unbanned."},banned_list={"Danh sách ban","Banned list"},banned_you={"Bạn đã bị ban khỏi chat.","You are banned from chat."},
  select_role={"Chọn role","Select role"},request_from={"Từ","From"},auth_info={"Chat Bridge không dùng token. Chỉ cần chat.","Chat Bridge uses no token. Just chat."},help_title={"Danh sách lệnh","Commands"},
  c_help={"Danh sách lệnh","Commands"},c_online={"Người online","Who's online"},c_find={"Tìm tin nhắn","Search messages"},c_dm={"Nhắn riêng: /dm <tên>","DM: /dm <name>"},
  c_game={"Kênh In-Game","In-Game"},c_general={"Kênh chung","General"},c_staff={"Kênh staff","Staff"},c_profile={"Mở hồ sơ","Open profile"},c_theme={"Đổi giao diện","Theme"},c_settings={"Cài đặt","Settings"},
  c_lang={"Đổi ngôn ngữ","Language"},c_poll={"Tạo bình chọn","Create poll"},c_roles={"Quản lý role (Dev)","Manage roles (Dev)"},c_admin={"Bảng quản trị","Admin panel"},
  c_report={"Báo cáo người dùng","Report user"},c_mute={"Cấm chat","Mute"},c_warn={"Cảnh báo","Warn"},c_unmute={"Gỡ cấm","Unmute"},c_unwarn={"Gỡ cảnh báo","Clear warns"},
  c_react={"Thả cảm xúc vào tin đang trả lời","React to replied message"},c_request={"Xin quyền (mở form)","Request access (open form)"},c_status={"Đặt trạng thái: /status <chữ>","Set status: /status <text>"},
  c_diag={"Chẩn đoán kết nối","Diagnostics"},c_back={"Về kênh In-Game","Back to In-Game"},c_emoji={"Mở bảng emoji","Emoji picker"},status_set={"Đã đặt trạng thái.","Status updated."},
  diag={"Chẩn đoán","Diagnostics"},resync={"Đồng bộ lại","Resync"},ping={"Ping","Ping"},diag_copy={"Copy báo cáo","Copy report"},
  backup_copy={"Sao lưu cài đặt","Backup settings"},backup_paste={"Dán CBS1:… để khôi phục","Paste CBS1:… to restore"},
  backup_import={"Khôi phục","Restore"},backup_ok={"Đã khôi phục.","Restored."},backup_bad={"Mã không hợp lệ.","Invalid code."},
  clear_cache={"Xóa cache tin/ảnh","Clear cache"},cache_cleared={"Đã xóa cache.","Cache cleared."},actions={"Hành động","Actions"},scriptstab={"Scripts","Scripts"},
  script_forum={"Kênh Chủ Đề Share Script","Script Share Forum"},script_new={"Đăng Script","Post Script"},script_title={"Tiêu đề chủ đề","Topic title"},
  script_title_ph={"VD: Auto Farm / ESP / Fly GUI...","e.g. Auto Farm / ESP / Fly GUI..."},script_tag={"Danh mục / Game","Category / Game"},script_desc={"Mô tả ngắn & hướng dẫn","Short description & notes"},
  script_desc_ph={"Mô tả tính năng, phím tắt, lưu ý cho người dùng...","Describe features, keybinds, notes for users..."},script_code={"Code Script (Lua / loadstring / URL)","Script Code (Lua / loadstring / URL)"},
  script_post_ok={"Đã đăng chủ đề script!","Script topic posted!"},script_need_fields={"Vui lòng nhập tiêu đề và code script!","Please enter both a title and script code!"},
  script_empty={"Chưa có chủ đề script nào phù hợp. Hãy bấm '+ Đăng Script' để chia sẻ!","No matching script topics yet. Click '+ Post Script' to share!"},script_view={"Xem","View"},script_paste={"Dán Clipboard","Paste Clipboard"},script_multi={"Chọn xóa","Multi-select"},script_del_sel={"Xóa đã chọn","Delete selected"},script_sel_all={"Chọn hết","Select all"},
  script_unsel={"Bỏ chọn","Clear"},script_report={"Báo cáo chủ đề Script","Report Script Topic"},script_quick_reason={"Chọn nhanh lý do:","Quick reasons:"},
  script_r_scam={"Scam / Key logger / Stealer","Scam / Key logger / Stealer"},script_r_broken={"Script lỗi / Không hoạt động","Broken / Not working"},script_r_spam={"Spam / Trùng lặp","Spam / Duplicate"},
  script_r_mal={"Nội dung độc hại / Phá game","Malicious / Game crasher"},script_reports_hdr={"Danh sách Report chủ đề này","Reports on this topic"},
  script_del_this={"Xóa chủ đề Script này","Delete this Script topic"},script_deleted={"Đã xóa chủ đề script.","Script topic deleted."},tag_all={"Tất cả","All"},tag_cur_game={"Game hiện tại","Current Game"},
  emoji_name_ph={"Tên emoji (vd: pepe_vui)","Emoji name (e.g. pepe_happy)"},emoji_search_ph={"Tìm emoji theo tên, ID, người tạo…","Search emoji by name, ID, creator…"},
  emoji_share_srv={"Share lên Server","Share to Server"},emoji_save_loc={"+ Lưu máy","+ Save Local"},emoji_shared_ok={"Đã chia sẻ emoji lên server!","Shared emoji to server!"},
  emoji_del_multi={"Chọn xóa nhiều","Multi-delete"},emoji_del_sel={"Xóa đã chọn","Delete selected"},emoji_del_on={"Đang bật chạm xóa","Tap-to-delete ON"},emoji_removed={"Đã xóa emoji.","Emoji removed."},
  emoji_insert_chat={"Chèn vào chat","Insert in chat"},emoji_react_btn={"Thả cảm xúc","React"},emoji_copy_name={"Copy :tên:","Copy :name:"},emoji_del_srv={"Xóa khỏi Server","Delete from Server"},
  emoji_srv_hint={" · Gõ :tên: để gửi hoặc thả cảm xúc"," · Type :name: to send or react"},emoji_recent_custom={"Custom Emoji gần đây","Recent Custom Emojis"},emoji_standard={"Emoji chuẩn","Standard Emojis"},
  emoji_matched={"Shared Emoji khớp từ khóa","Matching Shared Emojis"},c_scripts={"Mở kênh chủ đề Share Script","Open Script Share forum"},
  quick_theme={"Đổi nhanh giao diện (Tươi sáng / Tối)","Quick Theme Switcher (Bright / Dark)"},rose_bright={"Rose (Tươi sáng)","Rose (Bright)"},
  theme_studio={"Bảng Giao Diện Chi Tiết (Theme Studio)","Open Theme Studio (Full Editor)"},dev_hub={"Công cụ nhanh Developer & Admin","Developer & Admin Quick Tools"},
  dev_manage_emoji={"Quản lý / Xóa Emoji","Manage / Delete Emojis"},dev_manage_emoji_title={"Quản lý Shared Emoji","Manage Shared Emojis"},dev_manage_script={"Quản lý Kênh Script","Manage Script Forum"},
  role_quick_assign={"Gán nhanh (nhập @username)","Quick assign (enter @username)"},role_assign_btn={"+ Gán role cho user trên","+ Assign role to user above"},tap_again_del={"Chạm lần nữa để xóa","Tap again to delete"},
  sample_hi={"Xin chào mọi người!","Hello everyone!"},sample_reply={"Chào Alice 👋","Hey Alice 👋"},sample_ping={" ơi!"," check this!"},edit_profile={"Chỉnh sửa Hồ sơ của bạn","Edit Your Profile"},
  edit_profile_btn={"Sửa Hồ sơ","Edit Profile"},save_profile={"Lưu Hồ sơ","Save Profile"},quick_status={"Chọn nhanh trạng thái:","Quick status presets:"},
  quick_country={"Chọn nhanh quốc gia:","Quick country flag:"},bio_ph={"Giới thiệu ngắn về bạn...","Short bio about yourself..."},status_ph={"Đang làm gì / trạng thái...","What are you up to..."},
  tok_cmd_ok={"Lệnh hợp lệ: ","Valid command: "},tok_cmd_wait={"Đang gõ lệnh: ","Typing command: "},tok_cmd_bad={"Lệnh không tồn tại: ","Unknown command: "},
  tok_mention_ok={"Đã nhận diện: ","Mention active: "},tok_mention_find={"Đang tìm người chơi: ","Matching player: "},tok_mention_bad={"Không tìm thấy: ","User not found: "},
  tok_emoji_ok={"Emoji hoạt động: ","Emoji active: "},tok_emoji_find={"Đang tìm emoji: ","Matching emoji: "},tok_emoji_bad={"Chưa có emoji: ","Emoji not found: "},tok_state_ok={"HOẠT ĐỘNG","ACTIVE"},
  tok_state_wait={"ĐANG GÕ","TYPING"},tok_state_bad={"CHƯA KHỚP","NO MATCH"},tag_saved={"Đã lưu","Saved"},
  proxy_panel={"HỆ THỐNG MÁY CHỦ [BOSS - RENDER] & [BACKUP - CLOUDFLARE]","[BOSS - RENDER] & [BACKUP - CLOUDFLARE] SERVER POOL"},proxy_ping_all={"Đo Ping Boss & Backup","Ping Test Boss & Backups"},
  proxy_active={"[ĐANG DÙNG]","[ACTIVE]"},proxy_use={"Chuyển","Use"},c_rejoin={"Vào lại server hiện tại ngay lập tức","Rejoin current game server immediately"},
  c_hop={"Chuyển sang server khác của game","Hop to another server of this game"},c_copyjob={"Sao chép JobId / PlaceId server hiện tại","Copy current server JobId / PlaceId"},
  c_clear={"Làm sạch khung nhìn tin nhắn hiện tại","Clear current message view"},c_invite={"Gửi thẻ mời mọi người vào chung server","Send 1-click server invite card to chat"},
  c_fps={"Xem FPS, Ping mạng và thông tin server","Check FPS, Ping and server stats"},
  join_srv_btn={"Vào Server Cùng Nhau","Join This Server"},join_srv_self={"Bạn đang ở trong server này rồi!","You are already in this server!"},
  delta_tp_note={"Lưu ý: Hãy TẮT 'Verify Teleports' trong cài đặt Delta / Executor để vào chung server không bị chặn!","Note: Turn OFF 'Verify Teleports' in Delta / Executor settings so joining servers isn't blocked!"},
  delta_tp_short={"Nhớ tắt 'Verify Teleports' ở cài đặt Delta trước khi bấm Tham gia","Turn OFF 'Verify Teleports' in Delta settings before joining"},announcetab={"Thông báo","Announce"},
  announce_ro={"Chỉ Developer, Admin & Tester mới được đăng trong kênh Thông báo","Only Developer, Admin & Tester can post in Announce"},
  announce_ph={"Nhập thông báo hoặc Script Logs (Dev/Admin/Tester)...","Write announcement or Script Logs (Dev/Admin/Tester)..."},
  announce_perm_note={"📌 Tin nhắn trong kênh Thông báo được lưu trữ vĩnh viễn cho đến khi Dev/Admin xoá","📌 Messages in Announce are stored permanently until deleted by Dev/Admin"},
  announce_clear_block={"Tin nhắn kênh Thông báo được lưu vĩnh viễn (chỉ Dev/Admin mới được xoá từng tin).","Announce messages are stored permanently (only Dev/Admin can delete them)."},
  role_announce={"Quyền đăng kênh Announce / Logs (Tester)","Can post in Announce / Logs channel (Tester)"},
  punishtab={"Xử phạt","Punish"},
  punish_title={"🚨 Kênh Cảnh Báo & Xử Phạt","🚨 Warnings & Punishments"},
  punish_ro={"Kênh thông báo xử phạt & gỡ phạt từ Dev/Admin (Chỉ đọc)","Moderation & unban/unmute notifications from Dev/Admin (Read-only)"},
  punish_ph={"Nhập lệnh /warn, /mute, /unmute, /unwarn, /ban, /unban hoặc dùng nút nhanh...","Type /warn, /mute, /unmute, /unwarn, /ban, /unban or use quick buttons..."},
  punish_empty={"Chưa có thông báo xử phạt hay gỡ phạt (Warn / Mute / Clear Warn / Unban) nào.","No warning, mute, clear warn, or unban notifications yet."},
  punish_you={"🚨 BẠN ĐÃ BỊ XỬ PHẠT","🚨 YOU WERE PENALIZED"},
  punish_you_ok={"✅ BẠN ĐÃ ĐƯỢC GỠ PHẠT","✅ PENALTY REMOVED"},
  punish_my_hdr={"HỒ SƠ KỶ LUẬT CỦA BẠN","YOUR DISCIPLINARY STATUS"},
  punish_clean={"✅ Tài khoản của bạn hiện không có cảnh báo hay lệnh cấm chat nào.","✅ Your account currently has no active warnings or mutes."},
  pf_all={"Tất cả","All"},
  pf_mine={"Của tôi","Mine"},
  pf_warn={"⚠️ Warn / Clear","⚠️ Warn / Clear"},
  pf_mute={"🔇 Mute / Unmute","🔇 Mute / Unmute"},
  pf_ban={"⛔ Ban / Unban","⛔ Ban / Unban"},
  act_warn={"⚠️ CẢNH BÁO (WARN)","⚠️ WARNING (WARN)"},
  act_mute={"🔇 CẤM CHAT (MUTE)","🔇 CHAT MUTE (MUTE)"},
  act_unmute={"🔊 ĐÃ GỠ CẤM CHAT (UNMUTED)","🔊 UNMUTED (CLEAR MUTE)"},
  act_clear_warn={"🧹 ĐÃ XOÁ CẢNH BÁO (CLEAR WARN)","🧹 WARNINGS CLEARED"},
  act_ban={"⛔ ĐÃ CẤM TRUY CẬP (BANNED)","⛔ BANNED (BAN)"},
  act_unban={"🔓 ĐÃ GỠ BAN (UNBANNED)","🔓 UNBANNED (UNBAN)"},
  act_revoke={"⛔ ĐÃ THU HỒI QUYỀN (REVOKED)","⛔ ROLES REVOKED"},
  by_staff={"Bởi Dev/Admin: ","By Dev/Admin: "},
  duration_lbl={"Thời hạn: ","Duration: "},
  perm_lbl={"Vĩnh viễn","Permanent"},
  reason_lbl={"Lý do: ","Reason: "},
  no_reason={"Không ghi lý do cụ thể","No specific reason provided"},
  mod_profile_sec={"Hồ sơ Vi phạm & Xử phạt (Warn / Mute / Ban)","Disciplinary & Moderation Record"},
  active_mute_hdr={"🔇 ĐANG BỊ CẤM CHAT (MUTED)","🔇 CURRENTLY MUTED"},
  active_ban_hdr={"⛔ ĐANG BỊ CẤM TRUY CẬP (BANNED)","⛔ CURRENTLY BANNED"},
  active_warn_hdr={"⚠️ CẢNH BÁO ĐANG HIỆU LỰC","⚠️ ACTIVE WARNINGS"},
  mod_history_hdr={"📜 LỊCH SỬ XỬ PHẠT & GỠ PHẠT GẦN ĐÂY","📜 RECENT MODERATION & UNBAN LOGS"},
  open_punish_ch={"🚨 Mở kênh Xử phạt","🚨 Open Punish Channel"},
  c_punish={"Mở kênh thông báo xử phạt & gỡ phạt (Warn/Mute/Unban)","Open punishment & unban logs channel"},
  c_ban={"Cấm người dùng (Ban) kèm lý do","Ban user with reason"},
  c_unban={"Gỡ ban người dùng (Unban) kèm lý do","Unban user with reason"},
  unmute_sent={"Đã gỡ cấm chat và thông báo lên kênh Xử phạt.","Unmuted and announced in Punish channel."},
  clear_warn_sent={"Đã gỡ cảnh báo và thông báo lên kênh Xử phạt.","Cleared warnings and announced in Punish channel."},
  ban_sent={"Đã cấm (Ban) và thông báo lên kênh Xử phạt.","Banned and announced in Punish channel."},
  unban_sent={"Đã gỡ ban (Unbanned) và thông báo lên kênh Xử phạt.","Unbanned and announced in Punish channel."},
  qr_spam={"Spam tin nhắn / Emoji liên tục","Spamming messages / emojis"},
  qr_toxic={"Ngôn từ xúc phạm / Thiếu tôn trọng","Toxic / Disrespectful language"},
  qr_scam={"Quảng cáo / Phát tán link lừa đảo (Scam)","Advertising / Scam links"},
  qr_rule={"Vi phạm nội quy chung của kênh chat","Breaking general chat rules"},
  qr_forgive={"Đã hết thời hạn phạt / Cam kết không tái phạm","Completed penalty / Promised not to repeat"},
  qr_mistake={"Gỡ phạt do nhầm lẫn từ Quản trị viên","Removed penalty due to Staff mistake"},
  qr_appeal={"Kháng cáo thành công / Được Dev/Admin ân xá","Appeal accepted / Pardoned by Dev/Admin"},
  show_typing={"Chia sẻ trạng thái đang nhập","Share typing indicator"},
  show_seen={"Chia sẻ trạng thái đã xem tin nhắn","Send read receipts (Seen)"},
  st_sending={"⏳","⏳"},
  st_sent={"✓","✓"},
  st_seen={"✓✓","✓✓"},
  st_seen_by={"✓✓ ","✓✓ "},
  nano_cube={"60×60","60×60"},expand_ui={"Mở rộng","Expand"},
  bg_mesh={"Đa tầng (Mesh)","Ambient Mesh"},bg_glass={"Kính mờ (Acrylic)","Frosted Glass"},
  grad_custom={"Tuỳ chỉnh Chuyển sắc (3 điểm màu)","Chroma Gradient Stops (3-Stop)"},
  grad_angle={"Góc nghiêng chuyển sắc","Gradient Angle"},grad_mix={"Cường độ pha trộn màu","Gradient Blend Intensity"},
  ui_style_sec={"Kiểu dáng Khung, Phông chữ & Thẻ tin","Surface Geometry, Typography & Cards"},
  ui_radius={"Độ bo góc giao diện","Corner Roundness"},
  font_family={"Phông chữ hiển thị","Interface Font"},
  msg_style={"Kiểu hiển thị tin nhắn","Message Layout Style"},
  msg_card={"Thẻ nổi","Card"},msg_flat={"Liền mạch","Cozy Flat"},msg_minimal={"Tối giản","Minimal"},
  border_glow={"Viền ánh sáng chuyển sắc (Chroma Stroke)","Chroma Accent Border Glow"},
  saved_themes_sec={"Bộ sưu tập Giao diện cá nhân","Personal Saved Themes"},
  save_slot_btn={"+ Lưu mẫu hiện tại","+ Save Current Look"},
  harmonize_btn={"⚡ Phối màu tự động","⚡ Auto-Harmonize"},
  cat_all={"Tất cả","All"},cat_chroma={"Chuyển sắc","Chroma"},cat_dark={"Tối","Dark"},cat_light={"Sáng","Light"},
  sec_feedback={"Đóng góp Ý tưởng & Báo cáo Lỗi","Suggestions & Bug Reports"},
  fb_intro={"Gửi ý tưởng tính năng mới hoặc báo cáo lỗi trực tiếp tới đội ngũ phát triển. Bạn sẽ nhận được thông báo ngay khi Developer xem hoặc phản hồi.","Send feature ideas or bug reports directly to the development team. You will be notified as soon as a Developer reviews or replies."},
  suggest_btn={"💡 Góp ý (Suggestions)","💡 Suggestions"},
  bug_btn={"🐛 Báo lỗi (Report Bugs)","🐛 Report Bugs"},
  suggest_title={"Góp ý & Đề xuất Tính năng","Feature Suggestions"},
  bug_title={"Báo cáo Lỗi Hệ thống (Bug Report)","System Bug Report"},
  fb_tab_new={"Gửi phiếu mới","Submit New"},
  fb_tab_hist={"Lịch sử & Phản hồi","My History & Replies"},
  fb_cat={"Danh mục","Category"},
  fb_sev={"Mức độ ưu tiên","Severity"},
  fb_sev_low={"Thấp","Low"},fb_sev_med={"Trung bình","Normal"},fb_sev_high={"Nghiêm trọng","Critical"},
  fb_subj={"Tiêu đề ngắn gọn","Short Summary Title"},
  fb_subj_ph={"VD: Thêm hiệu ứng âm thanh tuỳ chỉnh...","e.g. Add custom notification sound..."},
  fb_bug_subj_ph={"VD: Nút cuộn bị kẹt khi đổi kích thước...","e.g. Scrollbar stuck when resizing window..."},
  fb_desc={"Nội dung chi tiết","Detailed Description"},
  fb_desc_ph={"Mô tả rõ ý tưởng hoặc lợi ích mang lại cho người dùng...","Describe how this feature works and why it's useful..."},
  fb_bug_desc_ph={"Mô tả hiện tượng lỗi bạn gặp phải...","Describe what went wrong..."},
  fb_steps={"Các bước tái hiện lỗi (Tùy chọn)","Steps to Reproduce (Optional)"},
  fb_steps_ph={"1. Mở bảng... 2. Bấm vào...","1. Open menu... 2. Click on..."},
  fb_attach_diag={"Đính kèm thông số chẩn đoán (Executor, Ping, Thiết bị)","Attach diagnostic info (Executor, Ping, Device)"},
  fb_send_suggest={"Gửi Góp Ý","Submit Suggestion"},
  fb_send_bug={"Gửi Báo Lỗi","Submit Bug Report"},
  fb_sent_ok={"Đã gửi thành công! Cảm ơn đóng góp của bạn.","Submitted! Thank you for your feedback."},
  fb_need_desc={"Vui lòng nhập nội dung chi tiết (ít nhất 6 ký tự).","Please enter a detailed description (at least 6 chars)."},
  fb_cooldown={"Vui lòng chờ vài giây trước khi gửi tiếp.","Please wait a few seconds before submitting again."},
  fb_empty_hist={"Chưa có phiếu gửi nào. Các góp ý và báo lỗi của bạn sẽ hiển thị tại đây kèm trạng thái phản hồi từ Developer.","No submissions yet. Your suggestions and bug reports will appear here with live Developer replies."},
  fb_st_pending={"⏳ Đang chờ xem","⏳ Pending Review"},
  fb_st_seen={"👀 Đã xem","👀 Reviewed"},
  fb_st_planned={"🛠️ Đã ghi nhận","🛠️ Acknowledged"},
  fb_st_replied={"💬 Đã phản hồi","💬 Replied"},
  c_suggest={"Mở hộp thoại Góp ý tính năng (Suggestions)","Open Feature Suggestions dialog"},
  c_bug={"Mở hộp thoại Báo cáo lỗi (Report Bugs)","Open Bug Report dialog"},
}local L=saved.lang=="en"and"en"or"vi"
--- [T] Hàm dịch đa ngôn ngữ: trả về chuỗi văn bản theo ngôn ngữ hiện tại (Tiếng Việt = 1, Tiếng Anh = 2)
local function T(k)local v=TXT[k]if not v then return k end return v[L=="en"and 2 or 1]end
local REASON_I18N={
  ["Spam tin nhắn / Emoji liên tục"]={"Spam tin nhắn / Emoji liên tục","Spamming messages / emojis"},
  ["Spamming messages / emojis"]={"Spam tin nhắn / Emoji liên tục","Spamming messages / emojis"},
  ["Ngôn từ xúc phạm / Thiếu tôn trọng"]={"Ngôn từ xúc phạm / Thiếu tôn trọng","Toxic / Disrespectful language"},
  ["Toxic / Disrespectful language"]={"Ngôn từ xúc phạm / Thiếu tôn trọng","Toxic / Disrespectful language"},
  ["Quảng cáo / Phát tán link lừa đảo (Scam)"]={"Quảng cáo / Phát tán link lừa đảo (Scam)","Advertising / Scam links"},
  ["Advertising / Scam links"]={"Quảng cáo / Phát tán link lừa đảo (Scam)","Advertising / Scam links"},
  ["Vi phạm nội quy chung của kênh chat"]={"Vi phạm nội quy chung của kênh chat","Breaking general chat rules"},
  ["Breaking general chat rules"]={"Vi phạm nội quy chung của kênh chat","Breaking general chat rules"},
  ["Đã hết thời hạn phạt / Cam kết không tái phạm"]={"Đã hết thời hạn phạt / Cam kết không tái phạm","Completed penalty / Promised not to repeat"},
  ["Completed penalty / Promised not to repeat"]={"Đã hết thời hạn phạt / Cam kết không tái phạm","Completed penalty / Promised not to repeat"},
  ["Gỡ phạt do nhầm lẫn từ Quản trị viên"]={"Gỡ phạt do nhầm lẫn từ Quản trị viên","Removed penalty due to Staff mistake"},
  ["Removed penalty due to Staff mistake"]={"Gỡ phạt do nhầm lẫn từ Quản trị viên","Removed penalty due to Staff mistake"},
  ["Kháng cáo thành công / Được Dev/Admin ân xá"]={"Kháng cáo thành công / Được Dev/Admin ân xá","Appeal accepted / Pardoned by Dev/Admin"},
  ["Appeal accepted / Pardoned by Dev/Admin"]={"Kháng cáo thành công / Được Dev/Admin ân xá","Appeal accepted / Pardoned by Dev/Admin"},
  ["Vi phạm quy định"]={"Vi phạm quy định","Rule violation"},
  ["Vi phạm nội quy cộng đồng"]={"Vi phạm nội quy cộng đồng","Community rules violation"},
  ["Vi phạm quy định chat"]={"Vi phạm quy định chat","Chat rules violation"},
  ["Vi phạm nghiêm trọng quy định"]={"Vi phạm nghiêm trọng quy định","Severe rule violation"},
  ["Bị từ chối xin quyền"]={"Bị từ chối xin quyền","Role request rejected / Banned"},
  ["Bị từ chối xin quyền / Vi phạm quy định"]={"Bị từ chối xin quyền / Vi phạm quy định","Role request rejected / Rule violation"},
  ["Thu hồi quyền (Role) bởi Developer"]={"Thu hồi quyền (Role) bởi Developer","Roles revoked by Developer"},
  ["Thu hồi toàn bộ Role qua Discord Bot"]={"Thu hồi toàn bộ Role từ Hệ thống Quản trị","All roles revoked via Admin System"},
  ["Được gỡ cấm (Unbanned) bởi Dev/Admin"]={"Được gỡ cấm (Unbanned) bởi Dev/Admin","Unbanned by Dev/Admin"},
  ["Được gỡ Ban qua Discord Bot"]={"Được gỡ Ban từ Hệ thống Quản trị","Unbanned via Admin System"},
  ["Được gỡ cấm chat qua Discord Bot"]={"Được gỡ cấm chat từ Hệ thống Quản trị","Unmuted via Admin System"},
  ["Gỡ toàn bộ cảnh cáo qua Discord Bot"]={"Gỡ toàn bộ cảnh cáo từ Hệ thống Quản trị","Cleared all warnings via Admin System"},
}
function F.locText(s)
  s=tostring(s or"")
  if s==""then return""end
  local hit=REASON_I18N[s]
  if hit then return hit[L=="en"and 2 or 1]end
  if L=="en"then
    local idxWarn=s:match("^Gỡ cảnh cáo #(%d+) ")
    if idxWarn then return"Removed warning #"..idxWarn.." via Admin System"end
    local gOwner=s:match("^Nhóm của (.+)$")
    if gOwner then return gOwner.."'s Group"end
  else
    local idxWarn=s:match("^Removed warning #(%d+) ")
    if idxWarn then return"Gỡ cảnh cáo #"..idxWarn.." từ Hệ thống Quản trị"end
    local gOwner=s:match("^(.+)'s Group$")
    if gOwner then return"Nhóm của "..gOwner end
  end
  return s
end

-- =============================================================================
-- 8. BẢNG MÀU CÁC CHỦ ĐỀ (THEMES) & KHỞI TẠO TRẠNG THÁI (P, S)
-- =============================================================================
local THEMES={
  rose={bg="#FFF0F5",bg2="#FFFFFF",bg3="#FFE0EC",title="#FFC8DD",text="#4A1228",muted="#9E4E6E",accent="#FF3E78",danger="#E11D48",ok="#10B981",warn="#F59E0B",own="#FFD4E5",mention="#FFF0B8",g1="#FFF0F5",g2="#FFE4EE",g3="#FCE7F3",gRot=25,cat="light"},
  sakura={bg="#FFF5F9",bg2="#FFFFFF",bg3="#FCE4EC",title="#F8BBD0",text="#3D1828",muted="#8C546B",accent="#EC407A",danger="#E53935",ok="#00BFA5",warn="#FB8C00",own="#F8D7E4",mention="#FFF8CC",g1="#FFF5F9",g2="#FCE4EC",g3="#F3E5F5",gRot=30,cat="light"},
  mint={bg="#F0FDF4",bg2="#FFFFFF",bg3="#DCFCE7",title="#BBF7D0",text="#064E3B",muted="#3B7A57",accent="#10B981",danger="#EF4444",ok="#059669",warn="#D97706",own="#D1FAE5",mention="#FEF3C7",g1="#F0FDF4",g2="#DCFCE7",g3="#E0F2FE",gRot=25,cat="light"},
  sky={bg="#F0F9FF",bg2="#FFFFFF",bg3="#E0F2FE",title="#BAE6FD",text="#0C4A6E",muted="#437496",accent="#0284C7",danger="#E11D48",ok="#16A34A",warn="#EA580C",own="#D4EEFC",mention="#FEF08A",g1="#F0F9FF",g2="#E0F2FE",g3="#EDE9FE",gRot=28,cat="light"},
  lavender={bg="#F5F3FF",bg2="#FFFFFF",bg3="#EDE9FE",title="#DDD6FE",text="#2E1065",muted="#6D549E",accent="#7C3AED",danger="#E11D48",ok="#10B981",warn="#D97706",own="#E4DCFE",mention="#FEF3C7",g1="#F5F3FF",g2="#EDE9FE",g3="#FCE7F3",gRot=32,cat="light"},
  peach={bg="#FFF7ED",bg2="#FFFFFF",bg3="#FFEDD5",title="#FED7AA",text="#431407",muted="#9A5B3E",accent="#F97316",danger="#DC2626",ok="#16A34A",warn="#D97706",own="#FFE4C4",mention="#FEF08A",g1="#FFF7ED",g2="#FFEDD5",g3="#FFE4E6",gRot=24,cat="light"},
  light={bg="#F2F4F8",bg2="#FFFFFF",bg3="#E4E7EC",title="#D5D9E2",text="#0F172A",muted="#586174",accent="#5865F2",danger="#DA373C",ok="#16A34A",warn="#D97706",own="#E0E7FF",mention="#FEF08A",g1="#F2F4F8",g2="#E8ECF4",g3="#E0E7FF",gRot=20,cat="light"},
  midnight={bg="#0E0E12",bg2="#16161D",bg3="#22232E",title="#09090C",text="#F4F4F6",muted="#8E8EA0",accent="#5865F2",danger="#EF4444",ok="#4ADE80",warn="#FBBF24",own="#232242",mention="#3E301B",g1="#0E0E12",g2="#151626",g3="#1E1B38",gRot=28,cat="dark"},
  dark={bg="#313338",bg2="#2B2D31",bg3="#383A40",title="#1E1F22",text="#F2F3F5",muted="#949BA4",accent="#5865F2",danger="#F23F43",ok="#23A55A",warn="#F0B232",own="#35374C",mention="#463826",g1="#2B2D31",g2="#313338",g3="#23273A",gRot=24,cat="dark"},
  rose_noir={bg="#1A0A11",bg2="#261019",bg3="#351724",title="#11060B",text="#FFE4EE",muted="#C4849A",accent="#FF4D79",danger="#FF2A4B",ok="#34D399",warn="#FBBF24",own="#421C2E",mention="#4A2C22",g1="#1A0A11",g2="#2E1120",g3="#1E0D24",gRot=32,cat="chroma"},
  nord={bg="#2E3440",bg2="#3B4252",bg3="#434C5E",title="#242933",text="#ECEFF4",muted="#A3BE8C",accent="#88C0D0",danger="#BF616A",ok="#A3BE8C",warn="#EBCB8B",own="#4C566A",mention="#5E4F3A",g1="#242933",g2="#2E3440",g3="#3B4252",gRot=25,cat="dark"},
  amoled={bg="#000000",bg2="#0A0A0C",bg3="#141418",title="#000000",text="#FFFFFF",muted="#8A8A93",accent="#3B82F6",danger="#F43F5E",ok="#22C55E",warn="#F59E0B",own="#111A2E",mention="#2E2208",g1="#000000",g2="#070B14",g3="#0F172A",gRot=35,cat="dark"},
  ocean={bg="#0F1B2D",bg2="#14253B",bg3="#1B3252",title="#0A1424",text="#E6F1FF",muted="#8FB0D6",accent="#38BDF8",danger="#F87171",ok="#34D399",warn="#FBBF24",own="#173A5E",mention="#4A3B1C",g1="#0A1424",g2="#0F2540",g3="#133B5C",gRot=30,cat="chroma"},
  forest={bg="#17221C",bg2="#1D2B23",bg3="#26382D",title="#101914",text="#E8F5EC",muted="#93B5A0",accent="#4ADE80",danger="#F87171",ok="#86EFAC",warn="#FACC15",own="#25402F",mention="#4A4120",g1="#101914",g2="#172A20",g3="#1E382B",gRot=28,cat="dark"},
  dracula={bg="#282A36",bg2="#21222C",bg3="#343746",title="#191A21",text="#F8F8F2",muted="#9AA5CE",accent="#BD93F9",danger="#FF5555",ok="#50FA7B",warn="#F1FA8C",own="#3B3556",mention="#4D4A2A",g1="#191A21",g2="#282A36",g3="#382A4A",gRot=30,cat="dark"},
  sunset={bg="#2B1B1F",bg2="#36232A",bg3="#442C35",title="#1F1216",text="#FFEFE6",muted="#D1A08F",accent="#FB923C",danger="#EF4444",ok="#84CC16",warn="#FACC15",own="#523036",mention="#5A4420",g1="#1F1216",g2="#381E28",g3="#4A281D",gRot=35,cat="chroma"},
  cyber={bg="#0A0A12",bg2="#12121C",bg3="#1A1A28",title="#06060C",text="#E0E0FF",muted="#8080A0",accent="#00F0FF",danger="#FF2060",ok="#00FF9D",warn="#FFE600",own="#1A2040",mention="#302040",g1="#06060C",g2="#0E172E",g3="#240E38",gRot=40,cat="chroma"},
  void={bg="#050508",bg2="#0A0A10",bg3="#101018",title="#000004",text="#F0F0F8",muted="#606070",accent="#A020F0",danger="#FF0040",ok="#20F0A0",warn="#F0A020",own="#180828",mention="#281018",g1="#050508",g2="#120824",g3="#081624",gRot=36,cat="dark"},
  gold={bg="#1A1408",bg2="#2A2010",bg3="#3A2C18",title="#100C04",text="#FFF8E0",muted="#C0A070",accent="#FFD700",danger="#FF4500",ok="#32CD32",warn="#FFA500",own="#3A3018",mention="#4A3A20",g1="#120E04",g2="#261D0A",g3="#38290E",gRot=26,cat="chroma"},
  catppuccin={bg="#1E1E2E",bg2="#181825",bg3="#313244",title="#11111B",text="#CDD6F4",muted="#A6ADC8",accent="#CBA6F7",danger="#F38BA8",ok="#A6E3A1",warn="#F9E2AF",own="#362C47",mention="#45382B",g1="#181825",g2="#1E1E2E",g3="#2C2540",gRot=28,cat="dark"},
  emerald={bg="#091914",bg2="#0E241D",bg3="#16362B",title="#05100C",text="#E6FFF5",muted="#7AB8A0",accent="#10B981",danger="#F43F5E",ok="#34D399",warn="#FBBF24",own="#134030",mention="#383014",g1="#05100C",g2="#0D281F",g3="#133B2E",gRot=30,cat="chroma"},
  aurora={bg="#0B132B",bg2="#141E3C",bg3="#1C2A52",title="#070C1C",text="#E8F1FF",muted="#84A4D4",accent="#00F5D4",danger="#FF4D6D",ok="#10B981",warn="#FBBF24",own="#17325C",mention="#332A1A",g1="#0B132B",g2="#182B49",g3="#0B3B3C",gRot=38,cat="chroma"},
  synthwave={bg="#160B28",bg2="#21113A",bg3="#2E1850",title="#0E061A",text="#FDF2FF",muted="#B892D4",accent="#FF2A85",danger="#FF3366",ok="#00F5D4",warn="#FFBE0B",own="#3A1652",mention="#462238",g1="#140826",g2="#2C104A",g3="#4A1240",gRot=45,cat="chroma"},
  tokyo_night={bg="#1A1B26",bg2="#16161E",bg3="#24283B",title="#111219",text="#C0CAF5",muted="#7982A9",accent="#7AA2F7",danger="#F7768E",ok="#9ECE6A",warn="#E0AF68",own="#283457",mention="#3B3222",g1="#16161E",g2="#1A1B26",g3="#262B44",gRot=25,cat="chroma"},
  crimson_dusk={bg="#180A0D",bg2="#240F14",bg3="#33161D",title="#100608",text="#FFE8EC",muted="#C2828D",accent="#E11D48",danger="#FF2E4C",ok="#10B981",warn="#F59E0B",own="#3D1420",mention="#422618",g1="#14070A",g2="#2B0E17",g3="#1D1026",gRot=32,cat="chroma"},
  cotton_candy={bg="#FFF5FA",bg2="#FFFFFF",bg3="#F3E8FF",title="#FCE7F3",text="#3B1D54",muted="#7E579E",accent="#EC4899",danger="#E11D48",ok="#059669",warn="#D97706",own="#FCE7F3",mention="#FEF3C7",g1="#FFF0F7",g2="#F3E8FF",g3="#E0F2FE",gRot=28,cat="chroma"},
  obsidian_gold={bg="#0C0B0E",bg2="#141218",bg3="#1F1C26",title="#070608",text="#F8F5EE",muted="#A69B82",accent="#EAB308",danger="#EF4444",ok="#22C55E",warn="#F59E0B",own="#2B2414",mention="#382B12",g1="#09080B",g2="#1E180D",g3="#14111D",gRot=22,cat="chroma"},
  arctic_frost={bg="#0B192C",bg2="#11233D",bg3="#1A3254",title="#07111E",text="#F0F8FF",muted="#8AB4D8",accent="#38BDF8",danger="#FB7185",ok="#34D399",warn="#FBBF24",own="#163B61",mention="#38341E",g1="#081322",g2="#0F2947",g3="#143D59",gRot=40,cat="chroma"},
  monokai={bg="#1E1F1C",bg2="#272822",bg3="#383830",title="#141411",text="#F8F8F2",muted="#90908A",accent="#A6E22E",danger="#F92672",ok="#A6E22E",warn="#FD971F",own="#343924",mention="#423922",g1="#181916",g2="#272822",g3="#2E2B30",gRot=20,cat="dark"},
  solar_flare={bg="#1C100B",bg2="#261710",bg3="#362118",title="#120906",text="#FFF3EB",muted="#C8967C",accent="#F97316",danger="#EF4444",ok="#22C55E",warn="#EAB308",own="#422214",mention="#483214",g1="#160B07",g2="#30160C",g3="#24101C",gRot=34,cat="chroma"},
}
local THEME_ORDER={"dark","midnight","aurora","synthwave","tokyo_night","catppuccin","dracula","crimson_dusk","obsidian_gold","arctic_frost","solar_flare","nord","ocean","emerald","amoled","cyber","void","gold","monokai","forest","sunset","rose_noir","cotton_candy","rose","sakura","mint","sky","lavender","peach","light"}local COLOR_GROUPS={
  {"grp_bg",{"bg","bg2","bg3","title"}},{"grp_text",{"text","muted"}},{"grp_accent",{"accent","own","mention","mentionText","emojiText"}},{"grp_state",{"danger","ok","warn"}},}
local FONT_ORDER={"gotham","sans","mono","rounded","fantasy","arcade","scifi","patrick"}
local FONT_MAP={
  gotham={reg=Enum.Font.Gotham,bold=Enum.Font.GothamBold,name="Gotham"},
  sans={reg=Enum.Font.SourceSans,bold=Enum.Font.SourceSansBold,name="Sans"},
  mono={reg=Enum.Font.Code,bold=Enum.Font.RobotoMono,name="Mono"},
  rounded={reg=Enum.Font.GothamMedium,bold=Enum.Font.FredokaOne,name="Rounded"},
  fantasy={reg=Enum.Font.Fantasy,bold=Enum.Font.Fantasy,name="Fantasy"},
  arcade={reg=Enum.Font.Arcade,bold=Enum.Font.Arcade,name="Arcade"},
  scifi={reg=Enum.Font.SciFi,bold=Enum.Font.SciFi,name="SciFi"},
  patrick={reg=Enum.Font.PatrickHand,bold=Enum.Font.PatrickHand,name="Hand"},
}

-- =============================================================================
-- 10. HỆ THỐNG CHỦ ĐỀ ĐỘNG (THEME ENGINE) & CÁC WIDGET GIAO DIỆN CƠ SỞ
-- =============================================================================
local ACCENTS={"#5865F2","#7C6AF7","#BD93F9","#F472B6","#EF4444","#FB923C","#FACC15","#84CC16","#4ADE80","#2DD4BF","#38BDF8","#3B82F6","#FFFFFF","#94A3B8"}local TH,reg={},{}P.clientId=saved.clientId or H.uuid()
P.username,P.userId=LP.Name,LP.UserId P.display=saved.display or LP.DisplayName or LP.Name P.status,P.bio=saved.status or"",saved.bio or""P.country=H.resolveCountry(saved.country or"??")
P.profBanner=H.assetId(saved.profBanner or"")or""P.profIcon=H.assetId(saved.profIcon or"")or""
P.profTheme=type(saved.profTheme)=="table"and saved.profTheme or{}
P.autoExecute=saved.autoExecute~=false
P.dmList={};(function()local rawDm=type(saved.dmList)=="table"and saved.dmList or{}for k,v in pairs(rawDm)do if type(k)=="number"and type(v)=="string"and v:match("^[%w_]+$")then P.dmList[v]=H.now()elseif type(k)=="string"and k:match("^[%w_]+$")and not k:match("^grp_")then P.dmList[k]=tonumber(v)or H.now()end end end)();P.customEmojis=type(saved.customEmojis)=="table"and saved.customEmojis or{}P.recentEmoji=type(saved.recentEmoji)=="table"and saved.recentEmoji or{}
P.recentColors=type(saved.recentColors)=="table"and saved.recentColors or{}P.themeName=THEMES[saved.themeName]and saved.themeName or"dark"P.custom=type(saved.custom)=="table"and saved.custom or{}
-- Khởi tạo bảng cài đặt người chơi P (khôi phục từ dữ liệu đã lưu trong file JSON nếu có)
P.alpha=clamp(tonumber(saved.alpha)or 0,0,0.85)P.mute=type(saved.mute)=="table"and saved.mute or{on=false,reason="",exp=0,by=""}P.W=tonumber(saved.W or saved.width)or(IS_MOBILE and 330 or 400)
local validBgModes={solid=true,gradient=true,mesh=true,glass=true,image=true}
P.backgroundMode=validBgModes[saved.backgroundMode]and saved.backgroundMode or"solid"
P.backgroundImage=H.assetId(saved.backgroundImage or"")or""
if P.backgroundMode=="image"and P.backgroundImage==""then P.backgroundMode="solid"end
P.backgroundOpacity=clamp(tonumber(saved.backgroundOpacity)or 0.82,0.15,1)
P.backgroundDim=clamp(tonumber(saved.backgroundDim)or 0.25,0,0.75)
P.gradAngle=clamp(tonumber(saved.gradAngle)or 28,0,360)
P.gradMix=clamp(tonumber(saved.gradMix)or 0.65,0.15,1)
P.uiRadius=clamp(tonumber(saved.uiRadius)or 10,3,16)
P.fontFamily=FONT_MAP[saved.fontFamily]and saved.fontFamily or"gotham"
do local fm=FONT_MAP[P.fontFamily]or FONT_MAP.gotham;fG,fGB=fm.reg,fm.bold end
P.msgStyle=(saved.msgStyle=="flat"or saved.msgStyle=="minimal")and saved.msgStyle or"card"
P.borderGlow=saved.borderGlow~=false
do local bf=type(saved.bgFrame)=="table"and saved.bgFrame or{}
  P.bgFrame={
    fit=(bf.fit=="fit"or bf.fit=="stretch"or bf.fit=="tile"or bf.fit=="crop")and bf.fit or"crop",
    zoom=clamp(tonumber(bf.zoom)or 100,100,300),
    x=clamp(tonumber(bf.x)or 0,-100,100),
    y=clamp(tonumber(bf.y)or 0,-100,100),
    aspect=F._ASPECT and F._ASPECT[bf.aspect or""]and bf.aspect or(type(bf.aspect)=="string"and(bf.aspect=="1:1"or bf.aspect=="16:9"or bf.aspect=="4:3"or bf.aspect=="3:4"or bf.aspect=="9:16"or bf.aspect=="21:9")and bf.aspect or"auto"),
  }
end
P.savedThemes=type(saved.savedThemes)=="table"and saved.savedThemes or{}
P.myFeedbacks=type(saved.myFeedbacks)=="table"and saved.myFeedbacks or{}
P.H=tonumber(saved.H or saved.height)or(IS_MOBILE and 380 or 320)P.notify=saved.notify~=false P.sound=saved.sound~=false P.bubble=saved.bubble~=false P.safeEmoji=saved.safeEmoji~=false P.showGame=saved.showGame~=false
P.preview=saved.preview~=false P.compact=saved.compact==true P.sameUser=saved.sameUser~=false P.group=saved.group~=false P.showTyping=saved.showTyping~=false P.showSeen=saved.showSeen~=false S.viewAs=false S.tapLock={}S.sameBb={}P.textSize=clamp(tonumber(saved.textSize)or 13,11,20)
-- Khởi tạo bảng trạng thái phiên chạy S (danh sách người dùng, tin nhắn, cảm xúc, bình chọn, role, script, vị trí cửa sổ)
P.toastPos=saved.toastPos or"tr"P.miniX,P.miniY=tonumber(saved.miniX),tonumber(saved.miniY)
P.winX,P.winY=tonumber(saved.winX),tonumber(saved.winY)P.minimized=saved.minimized==true
P.msgCount=max(0,floor(tonumber(saved.msgCount)or 0))
P.scriptUrl=(type(saved.scriptUrl)=="string"and saved.scriptUrl~=""and H.trim(saved.scriptUrl))or H.trim(tostring(ENV.CB46_SCRIPT_URL or ENV.CB45_SCRIPT_URL or ENV.CB44_SCRIPT_URL or""))
if P.scriptUrl==""and hasIO then for _,uf in ipairs({"cb46_script_url.txt","cb45_script_url.txt"})do local okU,uRaw=pcall(readfile,uf)if okU and type(uRaw)=="string"then uRaw=H.trim(uRaw)if uRaw:match("^https?://")then P.scriptUrl=uRaw;break end end end end
if P.scriptUrl==""then P.scriptUrl=H.trim(tostring(CFG.SCRIPT_URL or""))end
if P.scriptUrl~=""then ENV.CB46_SCRIPT_URL=P.scriptUrl ENV.CB45_SCRIPT_URL=P.scriptUrl end
S.prevW=tonumber(saved.prevW)or((P.W>=240 and P.W)or(IS_MOBILE and 330 or 400))
S.prevH=tonumber(saved.prevH)or((P.H>=220 and P.H)or(IS_MOBILE and 380 or 320))
S.users,S.profiles,S.profFetchedAt,S.uidCache,S.msgs,S.order,S.frames,S.frameQ={},{},{},{},{},{},{},{}S.polls=type(saved.polls)=="table"and saved.polls or{}
S.reactions=type(saved.reactions)=="table"and saved.reactions or{}S.seen,S.seenOld,S.seenN={},{},0 S.typing,S.unread,S.dmUnread={},{game=0,general=0,announce=0,punish=0,scripts=0,staff=0},{}
S.seenBy=type(saved.seenBy)=="table"and saved.seenBy or{}S.seenSeq=0 S.mySentSeen={}S.statusLabels={}S.wasTyping=false
S.roles=type(saved.roles)=="table"and saved.roles or{}S.sharedEmojis=type(saved.sharedEmojis)=="table"and saved.sharedEmojis or{}S.emojiSeq=0 S.scripts=type(saved.scripts)=="table"and saved.scripts or{}S.scriptSeq=0
S.groups=type(saved.groups)=="table"and saved.groups or{}S.groupSeq=0
S.feedbacks=type(saved.feedbacks)=="table"and saved.feedbacks or{}S.feedbackSeq=0 S.fbUnread=0 S.lastFbAt=0 S.themeCatFilter="all" 
S.announceSeq=0 S.modSeq=0 S.punishFilter="all"S.punishments=type(saved.punishments)=="table"and saved.punishments or{}S.bannedMap=type(saved.bannedMap)=="table"and saved.bannedMap or{}
S.scriptTagFilter="All"S.scriptMultiMode=false S.scriptSelected={}P.customEmojiNames=type(saved.customEmojiNames)=="table"and saved.customEmojiNames or{}
P.userNotes=type(saved.userNotes)=="table"and saved.userNotes or{}P.blockedUsers=type(saved.blockedUsers)=="table"and saved.blockedUsers or{}
P.savedScripts=type(saved.savedScripts)=="table"and saved.savedScripts or{}S.assign=type(saved.assign)=="table"and saved.assign or{}S.rolesSeq=0 S.devs={}
S.mutes,S.warns=type(saved.mutes)=="table"and saved.mutes or{},type(saved.warns)=="table"and saved.warns or{}S.reports=type(saved.reports)=="table"and saved.reports or{}S.myRequest=nil S.requests={}S.bannedList={}S.banned=nil
S.chan,S.search,S.orderN,S.reactAt="game","",0,0 S.lastSeq,S.booted,S.lpOn,S.lpFails,S.pollFail=0,false,CFG.LONGPOLL>0,0,0 S.lastPollOk,S.activityAt,S.t0=0,os.clock(),os.clock()
S.placeName,S.bubbles,S.isDirty,S.lastType="?",{},false,0 S.winX,S.winY,S.lastSave=P.winX,P.winY,0 S.lastByChan,S.newBelow,S.assetUrl,S.popN={},0,{},0 S.rtt,S.sendOk,S.sendFail=nil,0,0
S.joinTs,S.gameSessionIds,S.hasChattedInGame,S.isTeleporting,S.quitting,S.feedGen,S.inputFocused=H.now(),{},false,false,false,0,false
if P.mute.on then S.mutes[P.username]=P.mute end;(function()for _,r in ipairs(S.roles)do r.position=tonumber(r.position)or 0 end local norm,lower={},{}for u,v in pairs(S.assign)do local set={}
    if type(v)=="string"then set[v]=true elseif type(v)=="table"then if#v>0 then for _,rid in ipairs(v)do set[rid]=true end else
        for k,x in pairs(v)do if x==true then set[k]=true elseif type(x)=="string"then set[x]=true end end end end
    local lk=tostring(u):lower()local key=lower[lk]or u lower[lk]=key norm[key]=norm[key]or{}
    for rid in pairs(set)do norm[key][rid]=true end end
  S.assign=norm end)()

-- =============================================================================
-- 9. HỆ THỐNG SỰ KIỆN, MẠNG HTTP, HÀNG ĐỢI 3 LUỒNG & AUTO-FAILOVER PROXY
-- =============================================================================
local handlers={}
--- [F.on] Đăng ký hàm lắng nghe sự kiện nội bộ `evt`
function F.on(evt,fn)handlers[evt]=handlers[evt]or{};tinsert(handlers[evt],fn);return fn end
--- [F.emit] Phát sự kiện nội bộ `evt` tới tất cả các hàm lắng nghe đã đăng ký
function F.emit(evt,...)for _,fn in ipairs(handlers[evt]or{})do pcall(fn,...)end end
local NET={alive=true,notBefore=0,lanes={send={},other={},fast={}},busy={},idx=1,cooldown={},fails={}}local conns={}
-- Khởi tạo trạng thái kết nối mạng NET (3 luồng hàng đợi: send, other, fast) và danh sách PROXY_POOL
--- [hook] Kết nối sự kiện RBXScriptSignal và lưu vào danh sách `conns` để tự động ngắt kết nối khi dừng script
local function hook(sig,fn)local c=sig:Connect(fn);tinsert(conns,c);return c end
--- [H.isBossUrl] Kiểm tra một URL có phải là Máy chủ Boss (Render.com - Chỉ Host Bot Discord 24/7) hay không
function H.isBossUrl(u)
  local s=tostring(u or""):lower()
  if s:find("onrender%.com")or s:find("hf%.space")or s:find("huggingface")then return true end
  return false
end
local PROXY_POOL={}for _,u in ipairs(CFG.PROXIES or{CFG.PROXY})do u=H.trim(tostring(u or"")):gsub("/+$","")
  if u:match("^https?://")and not H.isBossUrl(u)then PROXY_POOL[#PROXY_POOL+1]=u end end
if#PROXY_POOL==0 then local fb=H.trim(tostring(CFG.PROXY or"")):gsub("/+$","")if fb:match("^https?://")then PROXY_POOL[1]=fb end end
if PROXY_POOL[1]then CFG.PROXY=PROXY_POOL[1]end
--- [H.proxyRoleLabel] Trả về nhãn hiển thị [BACKUP - CLOUDFLARE #1..4] hoặc [BOSS - BOT DISCORD 24/7]
function H.proxyRoleLabel(u,idx)
  if H.isBossUrl(u)then
    return "[BOSS - BOT DISCORD 24/7]"
  end
  local bIdx=tonumber(idx)or 1
  return string.format("[BACKUP - CLOUDFLARE #%d]",bIdx)
end
--- [autoFailoverProxy] Tự động chuyển tuần tự #1 -> #2 -> #3 -> #4 sang Backup Cloudflare tiếp theo khi kết nối lỗi
local function autoFailoverProxy()if#PROXY_POOL<=1 then return CFG.PROXY end
  local now=os.clock()
  NET.cooldown[CFG.PROXY]=now+180
  for offset=1,#PROXY_POOL-1 do
    local idx=((NET.idx+offset-1)%#PROXY_POOL)+1
    local cand=PROXY_POOL[idx]
    if(NET.cooldown[cand]or 0)<=now then
      NET.idx=idx
      CFG.PROXY=cand
      S.forceRoles=true
      S.scriptSeq=0
      S.lastSeq=0
      return cand
    end
  end
  NET.idx=(NET.idx%#PROXY_POOL)+1
  CFG.PROXY=PROXY_POOL[NET.idx]
  S.forceRoles=true
  S.scriptSeq=0
  S.lastSeq=0
  return CFG.PROXY
end
--- [isQuotaLimitReached] Kiểm tra phản hồi HTTP có phải lỗi hết hạn mức Cloudflare Workers (Error 1027 / limit exceeded) hay không
local function isQuotaLimitReached(code,bodyRaw,data)
  if code==1027 or code==1015 or code==503 then return true end if code==429 and not(type(data)=="table"and data.error=="rate")then return true end
  local lb=tostring(bodyRaw or""):lower()
  if lb:find("1027",1,true)or lb:find("limit exceeded",1,true)or lb:find("workers.dev",1,true)and lb:find("error",1,true)then return true end return false end
--- [rawRequest] Thực hiện HTTP Request tới Proxy kèm cơ chế tự động thử lại và chuyển đổi dự phòng (Failover)
local function rawRequest(method,path,bodyTable)
  local headers={["Content-Type"]="application/json"}local bodyStr=bodyTable~=nil and H.jenc(bodyTable)or nil local maxAttempts=max(3,#PROXY_POOL+1)for attempt=1,maxAttempts do
    while NET.alive and os.clock()<NET.notBefore do task.wait(0.03)end if not NET.alive then return nil,"stopped"end
    local curUrl=CFG.PROXY local opts={Url=curUrl..path,Method=method,Headers=headers}
    if bodyStr then opts.Body=bodyStr end
    local t0=os.clock()local ok,res=pcall(httpFn,opts)if ok and type(res)=="table"then local code=tonumber(res.StatusCode or res.Status)or 0 local data=H.jdec(res.Body)
      if code>=200 and code<300 and type(data)=="table"then NET.fails[curUrl]=0 NET.cooldown[curUrl]=nil local dt=(os.clock()-t0)*1000 if method=="POST"or not path:find("wait=%d*[1-9]")then S.rtt=S.rtt and(S.rtt*0.7+dt*0.3)or dt end return data,nil,code
      elseif code==429 and type(data)=="table"and data.error=="rate"then NET.notBefore=os.clock()+(tonumber(data.retry_after)or 1.2)+0.05 elseif isQuotaLimitReached(code,res.Body,data)then autoFailoverProxy()
      elseif code>=500 or code==0 or type(data)~="table"then NET.fails[curUrl]=(NET.fails[curUrl]or 0)+1 if#PROXY_POOL>1 and NET.fails[curUrl]>=2 then autoFailoverProxy()else task.wait(0.15*attempt)end else
        return type(data)=="table"and data or{},"HTTP "..tostring(code),code end else NET.fails[curUrl]=(NET.fails[curUrl]or 0)+1 if#PROXY_POOL>1 and NET.fails[curUrl]>=2 then autoFailoverProxy()else task.wait(0.12*attempt)end
    end end return nil,"network"end
F.rawRequest=rawRequest
--- [drain] Xử lý tuần tự các yêu cầu HTTP trong hàng đợi của từng luồng (`send`, `other`, `fast`)
local function drain(name)if NET.busy[name]then return end NET.busy[name]=true task.spawn(function()while NET.alive and#NET.lanes[name]>0 do local job=tremove(NET.lanes[name],1)
      local data,err,code=rawRequest(job.method,job.path,job.body)if job.cb then pcall(job.cb,data,err,code)end end NET.busy[name]=false end)end
--- [enqueue] Đưa một yêu cầu HTTP vào hàng đợi theo luồng ưu tiên và kích hoạt `drain`
local function enqueue(lane,method,path,body,cb)
  if not NET.alive then return end if lane=="fast"and(NET.busy.fast or#NET.lanes.fast>0)then return end tinsert(NET.lanes[lane],{method=method,path=path,body=body,cb=cb})drain(lane)end
--- [F.markSeen] Đánh dấu `packetId` đã được xử lý để chống trùng lặp tin nhắn (xoay vòng bộ đệm khi vượt `SEEN_MAX`)
function F.markSeen(id)
  if S.seen[id]or S.seenOld[id]then return true end
  S.seen[id]=true S.seenN=S.seenN+1 if S.seenN>CFG.SEEN_MAX then S.seenOld=S.seen;S.seen={};S.seenN=0 end return false end
--- [F.decode] Giải mã chuỗi nội dung có tiền tố `CB42:` (hoặc tiền tố cũ) thành bảng dữ liệu gói tin Lua
function F.decode(content)
  if type(content)~="string"then return nil end
  local body if content:sub(1,#CFG.PREFIX)==CFG.PREFIX then body=content:sub(#CFG.PREFIX+1)else for _,p in ipairs(CFG.LEGACY)do
      if content:sub(1,#p)==p then body=content:sub(#p+1);break end end end return body and H.jdec(body)or nil end
--- [F.netError] Hiển thị thông báo Toast báo lỗi mạng hoặc lỗi trả về từ máy chủ
function F.netError(e)F.toast("! "..tostring(e or"network"),true)end
--- [F.publish] Đóng gói và gửi gói tin lên endpoint `/api/send`, đồng thời xử lý trạng thái Mute/Ban nếu máy chủ từ chối
function F.publish(pkt,lane,cb)
  pkt.clientId=P.clientId pkt.packetId=pkt.packetId or H.uuid()pkt.ts=pkt.ts or H.now()F.markSeen(pkt.packetId)local raw=H.jenc(pkt)if not raw then if cb then cb(false,"encode")end return end
  local content=CFG.PREFIX..raw if#content>1900 then if cb then cb(false,"big")end return end enqueue(lane or"send","POST","/api/send",{content=content},function(data,err)
    if data and data.ok then S.sendOk=S.sendOk+1;if cb then cb(true)end return end
    S.sendFail=S.sendFail+1 local e=(data and data.error)or err
    if e=="muted"then F.applyMute(P.username,{on=true,reason=data.reason or"",exp=tonumber(data.exp)or 0,by=""})elseif e=="banned"then S.banned={reason=data.reason or"",exp=tonumber(data.exp)or 0}
      F.toast(T("banned_you"),true)elseif pkt.type~="typing"then F.netError(e)end if cb then cb(false,e)end end)F.emit("send",pkt)end
--- [themed] Đăng ký hàm cập nhật giao diện tùy chỉnh cho một Instance mỗi khi đổi Theme
local function themed(o,fn)reg[#reg+1]={o=o,fn=fn};pcall(fn,o)end
--- [th] Gán thuộc tính màu sắc (`BackgroundColor3`, `TextColor3`...) của Instance theo khóa màu của Theme hiện tại
local function th(o,prop,key,isBg)reg[#reg+1]={o=o,p=prop,k=key,a=isBg}pcall(function()o[prop]=TH[key]end)if isBg then pcall(function()o.BackgroundTransparency=P.alpha end)end end
--- [F.pruneThemeReg] Dọn dẹp các Instance đã bị hủy (Destroy) khỏi danh sách đăng ký Theme `reg`
function F.pruneThemeReg()local keep={}for _,r in ipairs(reg)do if r.o and r.o.Parent then keep[#keep+1]=r end end reg=keep end
--- [F.computeTheme] Tính toán bảng màu `TH` hiện hành kèm các điểm dừng Gradient 3 màu (`g1`, `g2`, `g3`), Nút bấm (`btnBg`), Ô nhập (`inputBg`) và Thẻ (`cardBg`)
function F.computeTheme()
  local fm=FONT_MAP[P.fontFamily]or FONT_MAP.gotham
  fG,fGB=fm.reg,fm.bold
  local base=THEMES[P.themeName]or THEMES.dark
  for k,v in pairs(base)do
    if type(v)=="string"and v:sub(1,1)=="#"then TH[k]=H.hex(P.custom[k]or v)end
  end
  local isDark=H.lum(TH.bg)<0.45
  local gMix=clamp(tonumber(P.gradMix)or 0.65,0.15,1)
  local effBg2=(isDark and H.lum(TH.bg2)>0.45)and H.mix(TH.bg,rgb(24,28,38),0.25)or((not isDark and H.lum(TH.bg2)<0.38)and H.mix(TH.bg,c3(1,1,1),0.35)or TH.bg2)
  local effBg3=(isDark and H.lum(TH.bg3)>0.42)and H.mix(effBg2,TH.accent,0.14)or((not isDark and H.lum(TH.bg3)<0.38)and H.mix(effBg2,TH.accent,0.12)or TH.bg3)
  local effTitle=(isDark and H.lum(TH.title)>0.48)and effBg2 or((not isDark and H.lum(TH.title)<0.38)and effBg2 or TH.title)
  TH.text=H.ensureContrast(TH.text,TH.bg,4.5)
  TH.muted=H.ensureContrast(TH.muted,effBg2,3.1)
  local rawG1=P.custom.g1 and H.hex(P.custom.g1)or(base.g1 and H.hex(base.g1))or TH.bg
  local rawG2=P.custom.g2 and H.hex(P.custom.g2)or(base.g2 and H.hex(base.g2))or H.mix(TH.bg,TH.accent,0.34)
  local rawG3=P.custom.g3 and H.hex(P.custom.g3)or(base.g3 and H.hex(base.g3))or H.mix(effBg2,TH.ok,0.26)
  TH.g1=H.mix(TH.bg,rawG1,gMix)
  TH.g2=H.mix(TH.bg,rawG2,gMix)
  TH.g3=H.mix(effBg2,rawG3,gMix)
  TH.inputBg=isDark and H.mix(effTitle,rgb(6,7,10),0.38)or H.mix(effBg2,rgb(255,255,255),0.75)
  TH.inputBorder=H.mix(effBg3,TH.muted,isDark and 0.42 or 0.32)
  TH.btnBg=isDark and H.mix(effBg3,TH.text,0.09)or H.mix(effBg3,TH.accent,0.10)
  TH.btnBorder=H.mix(effBg3,TH.text,isDark and 0.24 or 0.18)
  TH.cardBg=H.mix(effBg2,effBg3,isDark and 0.32 or 0.45)
  TH.border=H.mix(effBg3,TH.muted,0.24)
  TH.mentionText=P.custom.mentionText and H.hex(P.custom.mentionText)or H.ensureContrast(H.mix(TH.accent,TH.warn,0.32),effBg2,4.3)
  TH.emojiText=P.custom.emojiText and H.hex(P.custom.emojiText)or H.ensureContrast(H.mix(TH.accent,TH.ok,0.22),effBg2,4.3)
end
--- [F.surfaceAlpha] Tính độ trong suốt bề mặt (thẻ/thanh công cụ/hộp thoại) thích ứng theo chế độ nền Image/Glass/Chroma
function F.surfaceAlpha(kind)
  local mode=P.backgroundMode or"solid"
  local a=clamp(tonumber(P.alpha)or 0,0,0.85)
  if mode=="image"then
    if kind=="bar"then return clamp(max(a,0.34),0.26,0.72)
    elseif kind=="card"then return clamp(max(a,0.28),0.22,0.68)
    elseif kind=="pill"then return clamp(max(a,0.20),0.16,0.58)
    elseif kind=="modal"then return clamp(max(a,0.14),0.10,0.34)end
    return clamp(max(a,0.24),0.18,0.65)
  elseif mode=="glass"then
    if kind=="bar"then return clamp(max(a,0.30),0.22,0.70)
    elseif kind=="card"then return clamp(max(a,0.24),0.18,0.65)
    elseif kind=="pill"then return clamp(max(a,0.16),0.12,0.52)
    elseif kind=="modal"then return clamp(max(a*0.42,0.10),0.08,0.24)end
    return clamp(max(a,0.26),0.20,0.68)
  end
  if kind=="bar"then return clamp(a*0.85,0,0.75)
  elseif kind=="card"then return clamp(max(a,0.06),0,0.72)
  elseif kind=="pill"then return clamp(a*0.65,0,0.65)
  elseif kind=="modal"then return 0 end
  return a
end
--- [F.applyMainWallpaper] Áp dụng ảnh nền & thông số Crop/Fit/Stretch/Tile + Zoom/Pan/Aspect cho cửa sổ chính
function F.applyMainWallpaper(forceReload)
  if not U.main or not U.main.Parent or not U.wallpaper then return end
  local mode=P.backgroundMode or"solid"
  local imageId=H.assetId(P.backgroundImage or"")
  local active=(mode=="image"and imageId~=nil)
  local wpTrans=1-clamp(tonumber(P.backgroundOpacity)or 0.82,0.15,1)
  if U.wallpaperHost then U.wallpaperHost.Visible=active end
  U.wallpaper.Visible=active
  U.wallpaper.ImageTransparency=wpTrans
  if active then
    if forceReload or U._wpLastId~=imageId then
      U._wpLastId=imageId
      F.setAsset(U.wallpaper,imageId,function()
        if U.wallpaper and U.wallpaper.Parent then
          U.wallpaper.ImageTransparency=wpTrans
          F.applyImageFrame(U.wallpaperHost or U.main,U.wallpaper,P.bgFrame,P.W,P.H)
        end
      end,wpTrans,{force=forceReload==true})
    end
    F.applyImageFrame(U.wallpaperHost or U.main,U.wallpaper,P.bgFrame,P.W,P.H)
  else
    U._wpLastId=nil
    U.wallpaper.Image=""
  end
  if U.wallpaperTint then
    U.wallpaperTint.Visible=active and(tonumber(P.backgroundDim)or 0)>0
    U.wallpaperTint.BackgroundColor3=TH.bg
    U.wallpaperTint.BackgroundTransparency=1-clamp(tonumber(P.backgroundDim)or 0.25,0,0.75)
  end
end
do local function setProp(o,p,v)o[p]=v end
--- [F.paintTheme] Áp dụng lại toàn bộ màu sắc, hiệu ứng Chuyển sắc 3 điểm (Chroma), Mesh Glow, Kính mờ (Glass) và bo góc của Theme cho mọi phần tử UI
function F.paintTheme()F.computeTheme()
  local isGlass=(P.backgroundMode=="glass")
  local effAlpha=isGlass and max(P.alpha,0.26)or P.alpha
  local keep={}for _,r in ipairs(reg)do if r.o and r.o.Parent then
      keep[#keep+1]=r if r.fn then pcall(r.fn,r.o)else pcall(setProp,r.o,r.p,TH[r.k])if r.a then pcall(setProp,r.o,"BackgroundTransparency",effAlpha)end end end end reg=keep if F.paintTabs then pcall(F.paintTabs)end
  if U.main and U.main.Parent then pcall(function()
      local mode=P.backgroundMode or"solid"local imageId=H.assetId(P.backgroundImage or"")
      if mode=="image"and not imageId then mode="solid"end
      local rad=clamp(tonumber(P.uiRadius)or 10,3,16)
      local cornerUDim=u1(0,rad)
      for _,co in ipairs({U.mainCorner,U.wpGradCorner,U.wpMeshCorner,U.wpImgCorner,U.wpTintCorner,U.titleCorner})do
        if co then co.CornerRadius=cornerUDim end
      end
      if U.chatBarCorner then U.chatBarCorner.CornerRadius=u1(0,max(4,rad-2))end
      local useGrad=(mode=="gradient"or mode=="mesh"or mode=="glass")
      U.main.BackgroundTransparency=mode=="solid"and effAlpha or 1
      U.wallpaperGradient.Visible=useGrad
      U.wallpaperGradient.BackgroundColor3= c3(1,1,1)
      U.wallpaperGradient.BackgroundTransparency=useGrad and(mode=="glass"and max(0.18,effAlpha)or P.alpha)or 1
      if U.wallpaperUIGrad and useGrad then
        local baseTheme=THEMES[P.themeName]or THEMES.dark
        U.wallpaperUIGrad.Rotation=tonumber(P.gradAngle)or tonumber(baseTheme.gRot)or 28
        if mode=="glass"then
          U.wallpaperUIGrad.Color=ColorSequence.new({
            ColorSequenceKeypoint.new(0,H.mix(TH.bg,TH.accent,0.18)),
            ColorSequenceKeypoint.new(0.5,TH.bg2),
            ColorSequenceKeypoint.new(1,H.mix(TH.bg,TH.g3,0.35)),
          })
        else
          U.wallpaperUIGrad.Color=ColorSequence.new({
            ColorSequenceKeypoint.new(0,TH.g1),
            ColorSequenceKeypoint.new(0.52,TH.g2),
            ColorSequenceKeypoint.new(1,TH.g3),
          })
        end
      end
      if U.wallpaperMesh then
        local isMesh=(mode=="mesh")
        U.wallpaperMesh.Visible=isMesh
        if isMesh then
          U.wallpaperMesh.BackgroundColor3=c3(1,1,1)
          U.wallpaperMesh.BackgroundTransparency=clamp(0.45+P.alpha*0.4,0.25,0.88)
          if U.wallpaperMeshGrad then
            U.wallpaperMeshGrad.Rotation=(tonumber(P.gradAngle)or 28)+115
            U.wallpaperMeshGrad.Color=ColorSequence.new({
              ColorSequenceKeypoint.new(0,TH.accent),
              ColorSequenceKeypoint.new(0.55,TH.g2),
              ColorSequenceKeypoint.new(1,TH.ok),
            })
          end
        end
      end
      local glowOn=(P.borderGlow~=false)
      if U.mainStrokeGrad then
        U.mainStrokeGrad.Enabled=glowOn
        if glowOn then
          U.mainStrokeGrad.Rotation=(tonumber(P.gradAngle)or 28)+15
          U.mainStrokeGrad.Color=ColorSequence.new({
            ColorSequenceKeypoint.new(0,TH.accent),
            ColorSequenceKeypoint.new(0.5,H.mix(TH.accent,TH.g3,0.6)),
            ColorSequenceKeypoint.new(1,H.mix(TH.accent,TH.ok,0.45)),
          })
        end
      end
      if U.mainStroke then
        U.mainStroke.Color=glowOn and c3(1,1,1)or TH.accent
        U.mainStroke.Transparency=mode=="glass"and 0.18 or(glowOn and 0.25 or 0.45)
        U.mainStroke.Thickness=glowOn and 1.4 or 1.2
      end
      F.applyMainWallpaper(false)
      if U.input then U.input.Font=fG end
      if U.inputRich then U.inputRich.Font=fG end
      if U.titleLbl then U.titleLbl.Font=fGB end
      if U.infoLbl then U.infoLbl.Font=fG end
      if U.typing then U.typing.Font=fG end
      if U.sendBtn then U.sendBtn.Font=fGB end
      if U.mini then U.mini.Font=fGB end
      if U.miniBadge then U.miniBadge.Font=fGB end
      if U.titleGrad then U.titleGrad.Color=ColorSequence.new(TH.title,H.mix(TH.title,TH.accent,(mode=="gradient"or mode=="mesh")and 0.34 or 0.16))end
      for _,tb in pairs(U.tabs or{})do if tb and tb.Parent then tb.Font=fGB end end
      if U.titleBar then U.titleBar.BackgroundTransparency=F.surfaceAlpha("bar")end
      if U.chatBar then U.chatBar.BackgroundTransparency=F.surfaceAlpha("bar")end
      if U.chatBarStroke then U.chatBarStroke.Color=glowOn and H.mix(TH.border,TH.accent,0.35)or TH.border;U.chatBarStroke.Transparency=glowOn and 0.18 or 0.35 end
      if U.infoBar then U.infoBar.BackgroundTransparency=F.surfaceAlpha("bar")end
      if U.infoFrameBtn then U.infoFrameBtn.Visible=(mode=="image"and imageId~=nil)end
    end)end
  if F.paintDot then pcall(F.paintDot)end if F.updateSuggest and U.input then pcall(F.updateSuggest)elseif F.updateTokenFeedback and U.input then pcall(F.updateTokenFeedback,U.input.Text)end
  F.emit("theme",P.themeName)end end
F.refreshTheme=F.paintTheme F.computeTheme()
--- [mk] Hàm tiện ích khởi tạo nhanh `Instance.new(class)` kèm bảng thuộc tính và `Parent`
local function mk(class,props,parent)local o=Instance.new(class)for k,v in pairs(props or{})do o[k]=v end if parent then o.Parent=parent end return o end
--- [corner] Thêm bo góc `UICorner` cho phần tử giao diện (mặc định bán kính 8px)
local function corner(o,r)return mk("UICorner",{CornerRadius=u1(0,r or 8)},o)end
--- [pad] Thêm căn lề trong `UIPadding` (trái, trên, phải, dưới) cho phần tử giao diện
local function pad(o,l,t,r,b)
  return mk("UIPadding",{PaddingLeft=u1(0,l or 0),PaddingTop=u1(0,t or 0),PaddingRight=u1(0,r or 0),PaddingBottom=u1(0,b or 0)},o)end
--- [stroke] Thêm viền `UIStroke` tự động đổi màu theo khóa Theme
local function stroke(o,key,thick,tr)
  local s=mk("UIStroke",{Thickness=thick or 1,Transparency=tr or 0.5,ApplyStrokeMode=smBorder},o)th(s,"Color",key or"accent")return s end
--- [list] Thêm bố cục danh sách `UIListLayout` (dọc hoặc ngang) cho khung chứa
local function list(o,p,dir)
  return mk("UIListLayout",{Padding=u1(0,p or 4),SortOrder=soLO,FillDirection=dir or fdV},o)end
--- [lab] Tạo nhãn văn bản `TextLabel` gắn sẵn font, cỡ chữ, căn lề và màu sắc theo Theme
local function lab(parent,text,o)o=o or{}local l=mk("TextLabel",{
    Text=text or"",BackgroundTransparency=1,BorderSizePixel=0,Size=o.size or u2(1,0,0,o.h or 18),Position=o.pos or u2(),Font=o.bold and fGB or fG,TextSize=o.ts or 12,
    TextXAlignment=o.align or txL,TextYAlignment=o.valign or Enum.TextYAlignment.Center,TextWrapped=o.wrap==true,RichText=o.rich==true,LayoutOrder=o.layout or 0,TextTruncate=o.trunc and trEnd or Enum.TextTruncate.None,
  },parent)if o.auto then l.AutomaticSize=asY;l.Size=u2(1,0,0,0)end th(l,"TextColor3",o.key or"text")return l end
--- [tbtn] Tạo nút bấm văn bản `TextButton` bo góc, viền mảnh tinh tế, tự động đổi màu chữ tương phản theo màu nền Theme
local function tbtn(parent,text,o)o=o or{}local key=o.key or"btnBg"
  local isColored=(key=="accent"or key=="danger"or key=="ok"or key=="warn")
  local b=mk("TextButton",{
    Text=text or"",BorderSizePixel=0,AutoButtonColor=true,Font=fGB,TextSize=o.ts or 12,Size=o.size or u2(1,0,0,o.h or 30),Position=o.pos or u2(),LayoutOrder=o.layout or 0,TextWrapped=false,},parent)
  th(b,"BackgroundColor3",key);corner(b,o.r or 8)
  stroke(b,isColored and key or"btnBorder",1,isColored and 0.35 or 0.45)
  if isColored then themed(b,function(x)x.TextColor3=H.lum(TH[key])>0.42 and rgb(20,20,24)or c3(1,1,1)end)
  else themed(b,function(x)x.TextColor3=H.ensureContrast(TH.text,TH[key]or TH.btnBg,4.8)end)end
  if o.fn then hook(b.MouseButton1Click,o.fn)end return b end
--- [F.styleInput] Định dạng ô nhập liệu (`TextBox`) kiểu hộp lõm (inset) gọn gàng, đổi màu viền khi Focus và không chèn phần tử con gây tràn lề
function F.styleInput(b,mode,multi)
  th(b,"BackgroundColor3","inputBg")
  th(b,"TextColor3","text")
  th(b,"PlaceholderColor3","muted")
  corner(b,7)
  local st=mk("UIStroke",{Thickness=1,Transparency=0.25,ApplyStrokeMode=smBorder},b)
  local focused=false
  local function paintIn()
    st.Color=focused and TH.accent or TH.inputBorder
    st.Thickness=focused and 1.4 or 1
    st.Transparency=focused and 0.05 or 0.25
  end
  themed(b,paintIn)
  hook(b.Focused,function()focused=true;paintIn()end)
  hook(b.FocusLost,function()focused=false;paintIn()end)
  pad(b,8,multi and 6 or 4,8,multi and 6 or 4)
  return b
end
--- [field] Tạo ô nhập liệu `TextBox` có khung bo góc, viền nhận diện Focus và lề trong chuẩn
local function field(parent,label,value,multi,layout)
  if label and label~=""then lab(parent,label,{h=14,ts=10,bold=true,key="muted",layout=layout})end
  local b=mk("TextBox",{Text=value or"",PlaceholderText="",ClearTextOnFocus=false,Font=fG,TextSize=12,
    Size=u2(1,0,0,multi and 60 or 28),BorderSizePixel=0,TextXAlignment=txL,TextYAlignment=multi and Enum.TextYAlignment.Top or Enum.TextYAlignment.Center,MultiLine=multi==true,TextWrapped=multi==true,
    PlaceholderColor3=rgb(130,130,140),},parent)
  return F.styleInput(b,"text",multi==true)end
--- [row] Tạo một hàng ngang `Frame` chứa các phần tử con xếp theo chiều ngang (`FillDirection.Horizontal`)
local function row(parent,h,layout)
  local r=mk("Frame",{Size=u2(1,0,0,h or 30),BackgroundTransparency=1,LayoutOrder=layout or 0},parent)mk("UIListLayout",{FillDirection=fdH,Padding=u1(0,6),SortOrder=soLO,VerticalAlignment=vaC},r)return r end
--- [rbtn] Tạo nút bấm nằm trong một hàng ngang (`row`), mặc định chiếm 50% chiều rộng hàng
local function rbtn(r,text,o)o=o or{};o.size=o.size or u2(0.5,-3,1,0);return tbtn(r,text,o)end
--- [F.section] Tạo tiêu đề phân mục viết hoa sắc nét trong các hộp thoại cài đặt / quản trị
function F.section(parent,title,layout)local f=mk("Frame",{Size=u2(1,0,0,22),BackgroundTransparency=1,LayoutOrder=layout or 0},parent)
  local bar=mk("Frame",{Size=uo(3,12),Position=uo(0,7),BorderSizePixel=0},f)th(bar,"BackgroundColor3","accent");corner(bar,2)
  lab(f,string.upper(title),{size=u2(1,-10,0,16),pos=uo(8,5),ts=10,bold=true,key="muted"})return f end
--- [F.card] Tạo thẻ khung chứa (`Frame`) có nền `cardBg`, viền mảnh `border` và bo góc sắc nét
function F.card(parent,h)local c=mk("Frame",{Size=u2(1,0,0,h or 40),BorderSizePixel=0},parent)
  themed(c,function(o)o.BackgroundColor3=TH.cardBg;o.BackgroundTransparency=F.surfaceAlpha("card")end);corner(c,8);stroke(c,"border",1,0.45)return c end
--- [F.switch] Tạo công tắc bật/tắt (Toggle Switch) kèm hiệu ứng chuyển màu rõ nét
function F.switch(parent,text,get,set)local r=mk("TextButton",{Size=u2(1,0,0,34),Text="",BorderSizePixel=0,AutoButtonColor=true},parent)
  themed(r,function(o)o.BackgroundColor3=TH.cardBg;o.BackgroundTransparency=F.surfaceAlpha("card")end);corner(r,8);stroke(r,"border",1,0.5)lab(r,text,{size=u2(1,-66,1,0),pos=uo(12,0),trunc=true})
  local track=mk("Frame",{Size=uo(38,20),Position=u2(1,-48,0.5,-10),BorderSizePixel=0},r)corner(track,10)
  local trStroke=mk("UIStroke",{Thickness=1,Transparency=0.35,ApplyStrokeMode=smBorder},track)
  local knob=mk("Frame",{Size=uo(14,14),BorderSizePixel=0,BackgroundColor3=c3(1,1,1)},track)corner(knob,7)
  local function paint()local on=get()==true track.BackgroundColor3=on and TH.ok or TH.inputBg
    trStroke.Color=on and TH.ok or TH.inputBorder
    knob.Position=on and uo(21,3)or uo(3,3)end themed(track,paint)hook(r.MouseButton1Click,function()set(not get());paint()end)return r end
--- [F.track] Bắt đầu theo dõi thao tác kéo chuột hoặc chạm vuốt trên thanh trượt / bảng màu
function F.track(frame,fn,done)hook(frame.InputBegan,function(i)
    local ut=i.UserInputType if ut~=mb1 and ut~=utTouch then return end
    local sc=frame:FindFirstAncestorWhichIsA("ScrollingFrame")if sc then sc.ScrollingEnabled=false end
    S.track={input=i,fn=fn,done=done,sc=sc}
    pcall(fn,i.Position)end)end
--- [F.endTrack] Kết thúc theo dõi thao tác kéo chuột / chạm vuốt hiện tại
function F.endTrack()local tk=S.track if not tk then return end
  S.track=nil if tk.sc then pcall(function()tk.sc.ScrollingEnabled=true end)end if tk.done then pcall(tk.done)end end
--- [F.slider] Tạo thanh trượt giá trị số (`Slider`) từ `mn` đến `mx` hỗ trợ kéo trực tiếp
function F.slider(parent,text,mn,mx,val,o)o=o or{}local box=mk("Frame",{Size=u2(1,0,0,46),BorderSizePixel=0},parent)
  themed(box,function(b)b.BackgroundColor3=TH.cardBg;b.BackgroundTransparency=F.surfaceAlpha("card")end);corner(box,8);stroke(box,"border",1,0.5)
  local head=lab(box,"",{size=u2(1,-76,0,16),pos=uo(10,5),ts=11,bold=true,key="text",trunc=true})
  local valPill=lab(box,"",{size=uo(54,16),pos=u2(1,-64,0,5),ts=11,bold=true,key="accent",align=txR})valPill.Font=fCode
  local bar=mk("Frame",{Size=u2(1,-20,0,8),Position=uo(10,28),BorderSizePixel=0},box)th(bar,"BackgroundColor3","inputBg");corner(bar,4);stroke(bar,"inputBorder",1,0.4)
  local fill=mk("Frame",{Size=u2(0,0,1,0),BorderSizePixel=0},bar)
  th(fill,"BackgroundColor3","accent");corner(fill,4)local knob=mk("Frame",{Size=uo(14,14),AnchorPoint=v2(0.5,0.5),Position=u2(0,0,0.5,0),BorderSizePixel=0,BackgroundColor3=c3(1,1,1),ZIndex=2},bar)corner(knob,7)
  stroke(knob,"accent",1.5,0.1)
  local hit=mk("TextButton",{Text="",BackgroundTransparency=1,Size=u2(1,0,0,28),Position=uo(0,18),AutoButtonColor=false,ZIndex=3},box)local cur=val
  local function set(v,fire)v=clamp(v,mn,mx)
    if o.step then v=floor(v/o.step+0.5)*o.step end cur=v local f=(mx>mn)and(v-mn)/(mx-mn)or 0 fill.Size=u2(f,0,1,0)knob.Position=u2(f,0,0.5,0)
    head.Text=text valPill.Text=(o.fmt and o.fmt(v)or tostring(v))
    if fire and o.onChange then o.onChange(v)end end
  F.track(hit,function(pos)set(mn+clamp((pos.X-bar.AbsolutePosition.X)/max(1,bar.AbsoluteSize.X),0,1)*(mx-mn),true)end,function()if o.onDone then o.onDone(cur)end end)
  set(val,false)return box,set end
--- [F.pushRecentColor] Lưu mã màu Hex vừa chọn vào danh sách 10 màu sử dụng gần nhất (`P.recentColors`)
function F.pushRecentColor(hex)hex=H.safeHex(hex,nil)if not hex then return end for i=#P.recentColors,1,-1 do if P.recentColors[i]==hex then tremove(P.recentColors,i)end end
  tinsert(P.recentColors,1,hex)while#P.recentColors>10 do tremove(P.recentColors)end
  S.isDirty=true end
--- [F.colorPicker] Tạo bộ chọn màu HSV đầy đủ (khung bão hòa/độ sáng SV, thanh Hue, ô nhập Hex và bảng màu gần đây)
function F.colorPicker(parent,startHex,onChange,onDone)local c0=H.hex(startHex)local hh,ss,vv=Color3.toHSV(c0)
  local box=mk("Frame",{Size=u2(1,0,0,200),BackgroundTransparency=1},parent)local sv=mk("Frame",{Size=u2(1,-34,0,130),BorderSizePixel=0,Active=true},box)corner(sv,6)
  local white=mk("Frame",{Size=us(1,1),BackgroundColor3=c3(1,1,1),BorderSizePixel=0},sv)corner(white,6)
  mk("UIGradient",{Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(1,1)})},white)local black=mk("Frame",{Size=us(1,1),BackgroundColor3=c3(0,0,0),BorderSizePixel=0},sv)
  corner(black,6)mk("UIGradient",{Rotation=90,Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(1,0)})},black)
  local knob=mk("Frame",{Size=uo(14,14),AnchorPoint=v2(0.5,0.5),BackgroundTransparency=1,BorderSizePixel=0,ZIndex=5},sv)corner(knob,7);mk("UIStroke",{Color=c3(1,1,1),Thickness=2},knob)
  local hue=mk("Frame",{Size=uo(24,130),Position=u2(1,-24,0,0),BorderSizePixel=0,Active=true,BackgroundColor3=c3(1,1,1)},box)corner(hue,6)local kp={}
  for i=0,6 do kp[#kp+1]=ColorSequenceKeypoint.new(i/6,Color3.fromHSV(min(i/6,0.9999),1,1))end mk("UIGradient",{Rotation=90,Color=ColorSequence.new(kp)},hue)
  local hk=mk("Frame",{Size=u2(1,6,0,4),AnchorPoint=v2(0.5,0.5),BackgroundColor3=c3(1,1,1),BorderSizePixel=0,ZIndex=5},hue)corner(hk,2);mk("UIStroke",{Color=c3(0,0,0),Thickness=1,Transparency=0.4},hk)
  local swatch=mk("Frame",{Size=uo(28,28),Position=uo(0,138),BorderSizePixel=0},box)corner(swatch,6)
  local hexBox=mk("TextBox",{Size=u2(1,-36,0,28),Position=uo(34,138),Text="",ClearTextOnFocus=false,Font=fCode,TextSize=13,BorderSizePixel=0,TextXAlignment=txL},box)
  F.styleInput(hexBox,"code",false)local rec=mk("Frame",{Size=u2(1,0,0,22),Position=uo(0,172),BackgroundTransparency=1},box)
  mk("UIListLayout",{FillDirection=fdH,Padding=u1(0,4),SortOrder=soLO,VerticalAlignment=vaC},rec)local obj={frame=box}local last=0
  local function cur()return Color3.fromHSV(hh,ss,vv)end
  local function emit(force)
    local t=os.clock()if force or t-last>=0.05 then last=t;if onChange then onChange(H.tohex(cur()))end end end
  local function render()sv.BackgroundColor3=Color3.fromHSV(hh,1,1)knob.Position=u2(ss,0,1-vv,0)
    hk.Position=u2(0.5,0,hh,0)swatch.BackgroundColor3=cur()hexBox.Text=H.tohex(cur())end
  local function finish()emit(true);F.pushRecentColor(H.tohex(cur()));if onDone then onDone(H.tohex(cur()))end end
  F.track(sv,function(pos)ss=clamp((pos.X-sv.AbsolutePosition.X)/max(1,sv.AbsoluteSize.X),0,1)vv=1-clamp((pos.Y-sv.AbsolutePosition.Y)/max(1,sv.AbsoluteSize.Y),0,1)render();emit(false)end,finish)
  F.track(hue,function(pos)hh=clamp((pos.Y-hue.AbsolutePosition.Y)/max(1,hue.AbsoluteSize.Y),0,0.999)render();emit(false)end,finish)hook(hexBox.FocusLost,function()local h=H.trim(hexBox.Text)
    if not h:find("^#")then h="#"..h end if h:match("^#%x%x%x%x%x%x$")then hh,ss,vv=Color3.toHSV(H.hex(h));render();finish()else render()end end)local n=0 for _,hx in ipairs(P.recentColors)do n=n+1 if n>9 then break end
    local b=mk("TextButton",{Text="",Size=uo(20,20),BackgroundColor3=H.hex(hx),BorderSizePixel=0,LayoutOrder=n},rec)corner(b,5);stroke(b,"muted",1,0.6)
    hook(b.MouseButton1Click,function()hh,ss,vv=Color3.toHSV(H.hex(hx));render();emit(true);if onDone then onDone(hx)end end)end
  function obj.set(hex)hh,ss,vv=Color3.toHSV(H.hex(hex));render()end
  function obj.get()return H.tohex(cur())end render()return obj end
-- Bảng icon vector Lucide chuẩn (nguồn Footagesus/Icons - Roblox AssetID đã kiểm chứng)
F.LUCIDE={
  user="rbxassetid://81589895647169",userRound="rbxassetid://136485052187963",userCog="rbxassetid://92795491530865",users="rbxassetid://115398113982385",
  pencil="rbxassetid://137986121120732",palette="rbxassetid://86350350950064",sparkles="rbxassetid://138635884129147",crown="rbxassetid://127843403295538",
  shield="rbxassetid://110987169760162",shieldAlert="rbxassetid://114995877719925",code="rbxassetid://107380207681249",terminal="rbxassetid://106783148545356",
  gamepad="rbxassetid://92483947987410",globe="rbxassetid://114238209622913",msgCircle="rbxassetid://127255077587058",msgSquare="rbxassetid://83881670383280",
  send="rbxassetid://127751956873796",image="rbxassetid://112751259236831",imagePlus="rbxassetid://70391970623917",crop="rbxassetid://116344601101413",
  maximize="rbxassetid://73085922906397",minimize="rbxassetid://116269596042539",move="rbxassetid://116138709011735",zoomIn="rbxassetid://127956924984803",
  zoomOut="rbxassetid://108334162607319",rotateCcw="rbxassetid://110116685948665",sliders="rbxassetid://85538382643347",store="rbxassetid://90338129673705",
  search="rbxassetid://121018724060431",check="rbxassetid://93898873302694",x="rbxassetid://110786993356448",plus="rbxassetid://111774323017047",
  trash="rbxassetid://109843431391323",copy="rbxassetid://78979572434545",extLink="rbxassetid://129331830773832",eye="rbxassetid://100033680381365",
  eyeOff="rbxassetid://135928786788378",lock="rbxassetid://134724289526879",ban="rbxassetid://90767043015246",volumeX="rbxassetid://139252359189540",
  alertTri="rbxassetid://125920361880643",award="rbxassetid://132740088158419",activity="rbxassetid://94212016861936",grid="rbxassetid://81344910161871",
  note="rbxassetid://111894074643919",calendar="rbxassetid://114792700814035",play="rbxassetid://135609604299893",bookmark="rbxassetid://121093149326239",
  heart="rbxassetid://116559368303288",settings="rbxassetid://80758916183665",ellipsis="rbxassetid://140019550645825",chevLeft="rbxassetid://73780377692148",
  chevRight="rbxassetid://92473583511724",save="rbxassetid://126116963775616",refresh="rbxassetid://138133190015277",link="rbxassetid://131607023382430",
  star="rbxassetid://136141469398409",flame="rbxassetid://98218034436456",flag="rbxassetid://78183383236196",pin="rbxassetid://120978111007514",
  hash="rbxassetid://82890331678520",wrench="rbxassetid://112148279212860",zap="rbxassetid://130551565616516",monitor="rbxassetid://72664649203050",
  smartphone="rbxassetid://96623008834511",frame="rbxassetid://109080612832751",layers="rbxassetid://81973586053257",badgeCheck="rbxassetid://76078495178149",
  scroll="rbxassetid://97321022666868",swords="rbxassetid://81872698913435",circleCheck="rbxassetid://85262178816537",wand="rbxassetid://82546429942392",
  bucket="rbxassetid://124275586663284",
  smile="rbxassetid://105880397565283",smilePlus="rbxassetid://131981881472144",
  reply="rbxassetid://109788633497028",forward="rbxassetid://97545944739523",
  cornerUpLeft="rbxassetid://84669279763024",cornerUpRight="rbxassetid://115099889693145",
  minus="rbxassetid://118026365011536",chartCol="rbxassetid://97915995538580",clipboard="rbxassetid://89601995828423",
}
--- [F.lucide] Tạo ImageLabel hiển thị icon Lucide sắc nét (kích thước cố định, ScaleType.Fit)
function F.lucide(parent,key,sz,o)
  o=o or{}sz=sz or 14
  local col=o.col or(o.contrastBg and H.ensureContrast(TH[o.key or"text"]or TH.text,TH[o.contrastBg]or TH.btnBg,4.8)or TH[o.key or"text"])
  local im=mk("ImageLabel",{
    Size=uo(sz,sz),Position=o.pos or uo(0,0),AnchorPoint=o.anc or v2(0,0),
    BackgroundTransparency=1,BorderSizePixel=0,ScaleType=Enum.ScaleType.Fit,
    Image=F.LUCIDE[key]or tostring(key or""),
    ImageColor3=col,
    ImageTransparency=o.trans or 0,ZIndex=o.z or 4,LayoutOrder=o.layout or 0,
  },parent)
  if o.themed~=false and not o.col then
    if o.contrastBg then
      themed(im,function(ic)ic.ImageColor3=H.ensureContrast(TH[o.key or"text"]or TH.text,TH[o.contrastBg]or TH.btnBg,4.8)end)
    else th(im,"ImageColor3",o.key or"text")end
  end
  return im
end
--- [F.compactProfTheme] Rút gọn bảng profTheme bằng cách bỏ giá trị mặc định nhằm tối ưu băng thông Mesh/Discord Free Tier
function F.compactProfTheme(pt)
  if type(pt)~="table"then return{}end
  local out={}
  for _,k in ipairs({"bg","acc","txt","g1","g2","g3","bgImg"})do
    local v=tostring(pt[k]or"")
    if v~=""then out[k]=v end
  end
  if pt.mode and pt.mode~=""and pt.mode~="solid"then out.mode=pt.mode end
  if pt.font and pt.font~=""and pt.font~="gotham"then out.font=pt.font end
  if pt.gRot~=nil and tonumber(pt.gRot)~=28 then out.gRot=clamp(floor(tonumber(pt.gRot)or 28),0,360)end
  if pt.gMix~=nil and tonumber(pt.gMix)~=65 then out.gMix=clamp(floor(tonumber(pt.gMix)or 65),15,100)end
  if pt.rad~=nil and tonumber(pt.rad)~=10 then out.rad=clamp(floor(tonumber(pt.rad)or 10),3,16)end
  if pt.glow==false then out.glow=false end
  if pt.bgOp~=nil and tonumber(pt.bgOp)~=82 then out.bgOp=clamp(floor(tonumber(pt.bgOp)or 82),15,100)end
  if pt.bgDim~=nil and tonumber(pt.bgDim)~=25 then out.bgDim=clamp(floor(tonumber(pt.bgDim)or 25),0,75)end
  if pt.bf and pt.bf~="crop"then out.bf=pt.bf end
  if pt.bz~=nil and tonumber(pt.bz)~=100 then out.bz=clamp(floor(tonumber(pt.bz)or 100),100,300)end
  if pt.bx~=nil and tonumber(pt.bx)~=0 then out.bx=clamp(floor(tonumber(pt.bx)or 0),-100,100)end
  if pt.by~=nil and tonumber(pt.by)~=0 then out.by=clamp(floor(tonumber(pt.by)or 0),-100,100)end
  if pt.ba and pt.ba~="auto"then out.ba=pt.ba end
  if pt.bh~=nil and tonumber(pt.bh)~=96 then out.bh=clamp(floor(tonumber(pt.bh)or 96),64,150)end
  if pt["if"]~="crop"and pt["if"] and pt["if"]~=""then out["if"]=pt["if"]end
  if pt.iz~=nil and tonumber(pt.iz)~=100 then out.iz=clamp(floor(tonumber(pt.iz)or 100),100,300)end
  if pt.ix~=nil and tonumber(pt.ix)~=0 then out.ix=clamp(floor(tonumber(pt.ix)or 0),-100,100)end
  if pt.iy~=nil and tonumber(pt.iy)~=0 then out.iy=clamp(floor(tonumber(pt.iy)or 0),-100,100)end
  if pt.ia and pt.ia~="auto"then out.ia=pt.ia end
  if pt.ir~=nil and tonumber(pt.ir)~=50 then out.ir=clamp(floor(tonumber(pt.ir)or 50),0,50)end
  if pt.wf and pt.wf~="crop"then out.wf=pt.wf end
  if pt.wz~=nil and tonumber(pt.wz)~=100 then out.wz=clamp(floor(tonumber(pt.wz)or 100),100,300)end
  if pt.wx~=nil and tonumber(pt.wx)~=0 then out.wx=clamp(floor(tonumber(pt.wx)or 0),-100,100)end
  if pt.wy~=nil and tonumber(pt.wy)~=0 then out.wy=clamp(floor(tonumber(pt.wy)or 0),-100,100)end
  if pt.wa and pt.wa~="auto"then out.wa=pt.wa end
  if pt.avDec and pt.avDec~="none"and pt.avDec~=""then out.avDec=pt.avDec end
  if pt.nEff and pt.nEff~="solid"and pt.nEff~=""then out.nEff=pt.nEff end
  if type(pt.tag)=="string"and H.trim(pt.tag)~=""then out.tag=H.clip(H.trim(pt.tag),36)end
  if type(pt.pinSc)=="string"and pt.pinSc~=""then out.pinSc=pt.pinSc:gsub("[^%w_%-]",""):sub(1,48)end
  if type(pt.wOrder)=="string"and pt.wOrder~=""and pt.wOrder~="bio,scripts,game,stats"then out.wOrder=pt.wOrder:sub(1,40)end
  return out
end
--- [F.resolveDecalTexture] Phân giải Decal ID từ Roblox Store thành Texture Image ID gốc độ phân giải cao (không bị nén 420x420)
function F.resolveDecalTexture(id,forceRefresh)
  id=H.assetId(id)or tostring(id or"")
  if id==""then return nil end
  S.textureMap=S.textureMap or{}
  if not forceRefresh and S.textureMap[id]~=nil then
    return S.textureMap[id]~=false and S.textureMap[id]or nil
  end
  local resolved=nil
  local ok,res=pcall(httpFn,{Url="https://assetdelivery.roblox.com/v1/asset/?id="..id,Method="GET",Headers={["User-Agent"]="Roblox/WinInet"}})
  if ok and type(res)=="table"and(tonumber(res.StatusCode or res.Status)or 0)==200 and type(res.Body)=="string"then
    local body=res.Body
    if body:sub(1,120):find("<roblox",1,true)or body:find("Texture",1,true)then
      local texId=body:match('name="Texture"[^>]*>.-rbxassetid://(%d+)')
        or body:match('name="Texture"[^>]*>.-id=(%d+)')
        or body:match("rbxassetid://(%d+)")
        or body:match("[?&]id=(%d+)")
      if texId and texId~=id then resolved=texId end
    end
  end
  S.textureMap[id]=resolved or false
  return resolved
end
F._ASPECT={["1:1"]=1,["16:9"]=16/9,["4:3"]=4/3,["3:4"]=3/4,["9:16"]=9/16,["21:9"]=21/9}
--- [F.applyImageFrame] Căn chỉnh Zoom, Pan X/Y, Fit Mode (Crop/Fit/Stretch/Tile) và Tỉ lệ ảnh gốc cho mọi ImageLabel
function F.applyImageFrame(container,img,cfg,fallbackW,fallbackH)
  if not container or not img or not container.Parent or not img.Parent then return end
  cfg=type(cfg)=="table"and cfg or{}
  local fit=cfg.fit or"crop"
  local z=clamp((tonumber(cfg.zoom)or 100)/100,1,3)
  local px=clamp(tonumber(cfg.x)or 0,-100,100)
  local py=clamp(tonumber(cfg.y)or 0,-100,100)
  local ar=F._ASPECT[tostring(cfg.aspect or"auto")]
  local cw,ch=container.AbsoluteSize.X,container.AbsoluteSize.Y
  if cw<4 then cw=tonumber(fallbackW)or 100 end
  if ch<4 then ch=tonumber(fallbackH)or 100 end
  container.ClipsDescendants=true
  img.AnchorPoint=v2(0.5,0.5)
  if fit=="tile"then
    img.ScaleType=Enum.ScaleType.Tile
    local ts=max(24,floor(min(cw,ch)*0.72/z))
    img.TileSize=uo(ts,ts)
    local ox,oy=cw*0.2,ch*0.2
    img.Size=u2(1.4,0,1.4,0)
    img.Position=u2(0.5,-floor((px/100)*ox+0.5),0.5,-floor((py/100)*oy+0.5))
    return
  elseif fit=="stretch"then
    img.ScaleType=Enum.ScaleType.Stretch
  elseif fit=="fit"then
    img.ScaleType=Enum.ScaleType.Fit
  else
    img.ScaleType=Enum.ScaleType.Crop
  end
  local baseW,baseH=cw,ch
  if fit=="crop"and ar and ar>0 then
    if(cw/max(1,ch))>ar then baseW=cw;baseH=cw/ar else baseH=ch;baseW=ch*ar end
  elseif fit=="crop"and not ar and z<=1.001 and(px~=0 or py~=0)then
    z=1.28
  end
  local finalW=max(1,floor(baseW*z+0.5))
  local finalH=max(1,floor(baseH*z+0.5))
  local overX=max(0,finalW-cw)
  local overY=max(0,finalH-ch)
  img.Size=uo(finalW,finalH)
  img.Position=u2(0.5,-floor((px/100)*(overX*0.5)+0.5),0.5,-floor((py/100)*(overY*0.5)+0.5))
end
--- [F.setAsset] Tải ảnh Roblox độ phân giải gốc (ưu tiên giải mã Decal->Texture rồi mới fallback rbxthumb) kèm hỗ trợ Force Reload
function F.setAsset(img,id,onLoad,targetTrans,opts)
  opts=type(opts)=="table"and opts or{}
  S.assetUrl=S.assetUrl or{};S.assetIsFull=S.assetIsFull or{}
  id=tostring(id or"")
  local tr=(targetTrans~=nil and targetTrans)or((img and img.ImageTransparency>0.01 and img.ImageTransparency<0.99)and img.ImageTransparency)or 0
  if opts.force then S.assetUrl[id]=nil end
  local known=S.assetUrl[id]
  if known then
    img.Image=known;img.ImageTransparency=tr
    if onLoad then onLoad(true,known,S.assetIsFull[id]==true)end
    return
  end
  if opts.thumbOnly then
    local tu="rbxthumb://type=Asset&id="..id.."&w=420&h=420"
    img.Image=tu;img.ImageTransparency=tr
    task.spawn(function()
      pcall(function()ContentProvider:PreloadAsync({img})end)
      if onLoad and img.Parent then onLoad(img.IsLoaded,tu,false)end
    end)
    return
  end
  task.spawn(function()
    local function tryLoad(u,waitSec)
      if not img.Parent then return false end
      img.Image=u;img.ImageTransparency=tr
      pcall(function()ContentProvider:PreloadAsync({img})end)
      local t0=os.clock()
      while img.Parent and not img.IsLoaded and os.clock()-t0<(waitSec or 1.4)do task.wait(0.08)end
      return img.Parent and img.IsLoaded==true
    end
    local cands={{"rbxassetid://"..id,0.9,true}}
    if tryLoad(cands[1][1],cands[1][2])then
      S.assetUrl[id]=cands[1][1];S.assetIsFull[id]=true;img.ImageTransparency=tr
      if onLoad then onLoad(true,cands[1][1],true)end
      return
    end
    local texId=F.resolveDecalTexture(id,opts.force)
    if texId then
      local texUrl="rbxassetid://"..texId
      if tryLoad(texUrl,1.8)then
        S.assetUrl[id]=texUrl;S.assetIsFull[id]=true;img.ImageTransparency=tr
        if onLoad then onLoad(true,texUrl,true)end
        return
      end
    end
    local fallbacks={{"rbxthumb://type=Asset&id="..id.."&w=420&h=420",2.0,false},{"rbxthumb://type=Asset&id="..id.."&w=150&h=150",1.5,false}}
    for _,fb in ipairs(fallbacks)do
      if tryLoad(fb[1],fb[2])then
        S.assetUrl[id]=fb[1];S.assetIsFull[id]=false;img.ImageTransparency=tr
        if onLoad then onLoad(true,fb[1],false)end
        return
      end
    end
    if img.Parent then
      img.Image=fallbacks[1][1];img.ImageTransparency=tr
      S.assetUrl[id]=fallbacks[1][1];S.assetIsFull[id]=false
    end
    if onLoad then onLoad(img.Parent~=nil,img.Image,false)end
  end)
end
--- [F.createClipHost] Tạo CanvasGroup bo góc cắt mượt (fallback về Frame nếu executor không hỗ trợ CanvasGroup)
function F.createClipHost(parent,props)
  local ok,cg=pcall(function()
    local c=Instance.new("CanvasGroup")
    for k,v in pairs(props or{})do c[k]=v end
    c.GroupTransparency=0
    if parent then c.Parent=parent end
    return c
  end)
  if ok and cg then return cg,true end
  return mk("Frame",props,parent),false
end
--- [F.makeFramedAvatar] Vẽ ảnh đại diện nhỏ (Chat/Danh sách/Cài đặt) tôn trọng Crop/Zoom/Pan & Bo góc `ir` của người dùng
function F.makeFramedAvatar(parent,opts)
  opts=opts or{}
  local px=opts.px or 28
  local uPt=type(opts.pt)=="table"and opts.pt or{}
  local radPct=clamp(tonumber(uPt.ir)or 50,0,50)
  local host=F.createClipHost(parent,{
    Size=uo(px,px),Position=opts.pos or uo(0,0),BackgroundTransparency=1,BorderSizePixel=0,
    ClipsDescendants=true,ZIndex=opts.z or 8,LayoutOrder=opts.layout or 0,
  })
  local hc=mk("UICorner",{CornerRadius=u1(radPct/100,0)},host)
  local img=mk("ImageLabel",{
    Size=us(1,1),AnchorPoint=v2(0.5,0.5),Position=us(0.5,0.5),
    BackgroundTransparency=1,BorderSizePixel=0,ScaleType=Enum.ScaleType.Crop,ZIndex=(opts.z or 8)+1,
    Image=opts.customIc and F.thumbUrl(opts.customIc,150,150)or F.avatarUrl(opts.uid or 1),
  },host)
  if opts.customIc and opts.customIc~=""then
    F.setAsset(img,opts.customIc)
    local cfg={fit=uPt["if"]or"crop",zoom=uPt.iz or 100,x=uPt.ix or 0,y=uPt.iy or 0,aspect=uPt.ia or"auto"}
    F.applyImageFrame(host,img,cfg,px,px)
    if (tonumber(cfg.zoom)or 100)<=100 and (cfg.fit=="fit"or cfg.fit=="stretch"or (cfg.aspect or"auto")=="auto") then
      mk("UICorner",{CornerRadius=u1(radPct/100,0)},img)
    end
  else
    mk("UICorner",{CornerRadius=u1(0.5,0)},img)
  end
  if opts.strokeKey then stroke(host,opts.strokeKey,opts.strokeThick or 1.5,opts.strokeTrans or 0.25)end
  if opts.onClick then
    local hit=mk("TextButton",{Size=us(1,1),BackgroundTransparency=1,Text="",AutoButtonColor=false,Active=true,ZIndex=(opts.z or 8)+2},host)
    hook(hit.MouseButton1Click,opts.onClick)
  end
  return host,img,hc
end
--- [F.iconBox] Tạo khung hiển thị biểu tượng (hỗ trợ cả ảnh `img:<id>` và ký tự Emoji Unicode)
function F.iconBox(parent,spec,sz,o)o=o or{}spec=tostring(spec or"")
  local f=mk("Frame",{Size=uo(sz,sz),BackgroundTransparency=1,BorderSizePixel=0,LayoutOrder=o.layout or 0},parent)local id=spec:match("^img:(%d+)$")if id then
    local im=mk("ImageLabel",{Size=us(1,1),BackgroundTransparency=1,ScaleType=Enum.ScaleType.Fit,BorderSizePixel=0,ImageTransparency=0,ZIndex=2},f)
    corner(im,max(4,floor(sz/8)))
    if o.hd then
      local ph=lab(f,"",{size=us(1,1),ts=max(10,sz-8),align=txC,key="muted"})
      F.setAsset(im,id,function(ok)if ph.Parent then ph.Text=ok and""or"?"end end)
    else
      local dim=(sz<=40)and 150 or 420
      local cached=S.assetUrl and S.assetUrl[id]
      im.Image=cached or(F.thumbUrl and F.thumbUrl(id,dim,dim)or("rbxthumb://type=Asset&id="..id.."&w="..dim.."&h="..dim))
    end
  elseif spec~=""then
    local t=mk("TextLabel",{Size=us(1,1),BackgroundTransparency=1,Text=P.safeEmoji and H.safeEmoji(spec)or spec,Font=Enum.Font.SourceSansBold,TextSize=max(10,sz-4),BorderSizePixel=0},f)
    if o.themed~=false then th(t,"TextColor3","text")else t.TextColor3=o.col or TH.text end
  end
  return f
end

-- =============================================================================
-- 11. KHỞI TẠO CỬA SỔ GIAO DIỆN CHÍNH (SCREENGUI, THANH TIÊU ĐỀ, TAB, Ô NHẬP)
-- =============================================================================
local guiParent pcall(function()if gethui then guiParent=gethui()end end)if not guiParent then pcall(function()guiParent=game:GetService("CoreGui")end)end
if not guiParent then guiParent=LP:WaitForChild("PlayerGui")end
pcall(function()for _,c in ipairs(guiParent:GetChildren())do
    if type(c.Name)=="string"and c.Name:match("^CB%d%d_GUI$")then local v=tonumber(c.Name:sub(3,4))if v and v>=37 and v<=46 then c:Destroy()end end end end)
-- Khởi tạo ScreenGui 'CB46_GUI' và nút thu nhỏ nổi (U.mini) kèm huy hiệu đếm tin chưa đọc
U.gui=mk("ScreenGui",{Name="CB46_GUI",ResetOnSpawn=false,ZIndexBehavior=Enum.ZIndexBehavior.Sibling,IgnoreGuiInset=true,DisplayOrder=99999})pcall(function()if syn and syn.protect_gui then syn.protect_gui(U.gui)end end)
U.gui.Parent=guiParent U.mini=mk("TextButton",{Size=uo(42,42),Position=uo(P.miniX or 12,P.miniY or 80),Text="",TextSize=20,Font=fGB,BorderSizePixel=0,Visible=P.minimized==true,ZIndex=50},U.gui)
th(U.mini,"BackgroundColor3","accent");corner(U.mini,21);stroke(U.mini,"btnBorder",1.5,0.25)
do local mi=F.lucide(U.mini,"msgCircle",20,{pos=us(0.5,0.5),anc=v2(0.5,0.5),col=c3(1,1,1),themed=false,z=51})
  themed(mi,function(ic)ic.ImageColor3=H.lum(TH.accent)>0.55 and rgb(20,20,24)or c3(1,1,1)end)
end
U.miniBadge=mk("TextLabel",{Size=uo(18,18),Position=u2(1,-8,0,-4),Text="",TextSize=10,Font=fGB,TextColor3=c3(1,1,1),BorderSizePixel=0,Visible=false,ZIndex=52},U.mini)
th(U.miniBadge,"BackgroundColor3","danger");corner(U.miniBadge,9)U.main=mk("Frame",{Size=uo(P.W,P.H),Position=uo(P.winX or 60,P.winY or 60),BorderSizePixel=0,ClipsDescendants=true,Active=true,Visible=P.minimized~=true},U.gui)
U.wallpaperGradient=mk("Frame",{Size=us(1,1),BackgroundColor3=c3(1,1,1),BackgroundTransparency=1,BorderSizePixel=0,ZIndex=1,Visible=false},U.main)U.wpGradCorner=corner(U.wallpaperGradient,P.uiRadius or 10)
U.wallpaperUIGrad=mk("UIGradient",{Rotation=P.gradAngle or 28},U.wallpaperGradient)
U.wallpaperMesh=mk("Frame",{Size=us(1,1),BackgroundColor3=c3(1,1,1),BackgroundTransparency=0.55,BorderSizePixel=0,ZIndex=1,Visible=false},U.main)U.wpMeshCorner=corner(U.wallpaperMesh,P.uiRadius or 10)
U.wallpaperMeshGrad=mk("UIGradient",{Rotation=140,Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0.15),NumberSequenceKeypoint.new(0.5,0.65),NumberSequenceKeypoint.new(1,0.2)})},U.wallpaperMesh)
U.wallpaperHost=F.createClipHost(U.main,{Size=us(1,1),BackgroundTransparency=1,BorderSizePixel=0,ClipsDescendants=true,ZIndex=1,Visible=false})U.wpImgCorner=corner(U.wallpaperHost,P.uiRadius or 10)
U.wallpaper=mk("ImageLabel",{Size=us(1,1),Position=us(0.5,0.5),AnchorPoint=v2(0.5,0.5),BackgroundTransparency=1,BorderSizePixel=0,Image="",ImageTransparency=1,ScaleType=Enum.ScaleType.Crop,ZIndex=1,Visible=false},U.wallpaperHost)
U.wallpaperTint=mk("Frame",{Size=us(1,1),BackgroundColor3=TH.bg,BackgroundTransparency=1,BorderSizePixel=0,ZIndex=1,Visible=false},U.main)U.wpTintCorner=corner(U.wallpaperTint,P.uiRadius or 10)
-- Khởi tạo khung cửa sổ chính (U.main), thanh tiêu đề (U.titleBar) và dãy nút công cụ góc phải
th(U.main,"BackgroundColor3","bg",true);U.mainCorner=corner(U.main,P.uiRadius or 10)
U.mainStroke=mk("UIStroke",{Thickness=1.4,Transparency=0.25,ApplyStrokeMode=smBorder,Color=c3(1,1,1)},U.main)
U.mainStrokeGrad=mk("UIGradient",{Rotation=40},U.mainStroke)
U.titleBar=mk("Frame",{Size=u2(1,0,0,34),BorderSizePixel=0,ZIndex=8},U.main)themed(U.titleBar,function(o)o.BackgroundColor3=TH.title;o.BackgroundTransparency=F.surfaceAlpha("bar")end);U.titleCorner=corner(U.titleBar,P.uiRadius or 10)
U.titleGrad=mk("UIGradient",{Rotation=15},U.titleBar)themed(U.titleGrad,function(g)g.Color=ColorSequence.new(TH.title,H.mix(TH.title,TH.accent,0.14))end)
U.dot=mk("Frame",{Size=uo(8,8),Position=uo(10,13),BorderSizePixel=0,ZIndex=9},U.titleBar)corner(U.dot,4)
--- [F.paintDot] Cập nhật màu chấm trạng thái kết nối trên thanh tiêu đề (Xanh = Ổn định, Vàng = Chậm/Đang tải, Đỏ = Mất kết nối)
function F.paintDot()local c=(S.pollFail<2 and TH.ok)or TH.danger U.dot.BackgroundColor3=c if U.infoDot then U.infoDot.BackgroundColor3=c end end
U.titleLbl=lab(U.titleBar,T("title"),{size=u2(1,-196,1,0),pos=uo(24,0),bold=true,ts=13,trunc=true})U.titleLbl.ZIndex=9
U.tbtns=mk("Frame",{Size=uo(180,34),Position=u2(1,-184,0,0),BackgroundTransparency=1,ZIndex=9},U.titleBar)
mk("UIListLayout",{FillDirection=fdH,Padding=u1(0,3),SortOrder=soLO,VerticalAlignment=vaC,HorizontalAlignment=Enum.HorizontalAlignment.Right},U.tbtns)
local function tb(text,order,w,icKey)
  local b=mk("TextButton",{Size=uo(w or 26,24),BackgroundTransparency=0.2,Text=text or"",Font=fGB,TextSize=11,BorderSizePixel=0,LayoutOrder=order,AutoButtonColor=true,ZIndex=10},U.tbtns)
  themed(b,function(o)o.BackgroundColor3=TH.btnBg;o.TextColor3=H.ensureContrast(TH.text,TH.btnBg,4.8);o.BackgroundTransparency=clamp(F.surfaceAlpha("pill")+0.12,0.12,0.55)end)
  corner(b,7);stroke(b,"btnBorder",1,0.4)
  if icKey then F.lucide(b,icKey,13,{pos=us(0.5,0.5),anc=v2(0.5,0.5),key="text",contrastBg="btnBg",z=11})end
  return b end
U.bLang,U.bFind,U.bUsers,U.bMe,U.bSet,U.bMin=tb(L=="en"and"EN"or"VI",1,28),tb("",2,26,"search"),tb("",3,26,"users"),tb("",4,26,"userRound"),tb("",5,26,"settings"),tb("",6,24,"minus")
U.nanoBox=mk("Frame",{Size=u2(1,0,1,-22),Position=uo(0,22),BackgroundTransparency=1,Visible=false,ZIndex=12},U.main)
U.nanoBtn=mk("TextButton",{Size=u2(1,-8,1,-4),Position=uo(4,2),Text="",Font=fGB,TextSize=16,BorderSizePixel=0,AutoButtonColor=true,ZIndex=13},U.nanoBox)
th(U.nanoBtn,"BackgroundColor3","btnBg");th(U.nanoBtn,"TextColor3","accent");corner(U.nanoBtn,8)
F.lucide(U.nanoBtn,"msgCircle",16,{pos=us(0.5,0.5),anc=v2(0.5,0.5),key="accent",z=14})
U.nanoBadge=mk("TextLabel",{Size=uo(18,16),Position=u2(1,-20,0,2),Text="",Font=fGB,TextSize=9,TextColor3=c3(1,1,1),BorderSizePixel=0,Visible=false,ZIndex=14},U.nanoBox)
th(U.nanoBadge,"BackgroundColor3","danger");corner(U.nanoBadge,8)hook(U.nanoBtn.MouseButton1Click,function()P.W=S.prevW and S.prevW>=260 and S.prevW or(IS_MOBILE and 340 or 420)
  P.H=S.prevH and S.prevH>=260 and S.prevH or(IS_MOBILE and 460 or 520)S.isDirty=true F.layout()end)U.divider=mk("Frame",{Size=u2(1,0,0,1),Position=uo(0,34),BorderSizePixel=0,ZIndex=8},U.main)
th(U.divider,"BackgroundColor3","border")U.tabsBar=mk("Frame",{Size=u2(1,-12,0,28),Position=uo(6,38),BackgroundTransparency=1,ZIndex=7},U.main)mk("UIListLayout",{FillDirection=fdH,Padding=u1(0,4),SortOrder=soLO},U.tabsBar)
-- Khởi tạo thanh chuyển đổi 7 thẻ kênh: #game (Game), #general (Chung), DM, #scripts, #announce, #punish (Xử phạt) và #staff
U.tabs,U.tabStrokes,U.tabBars,U.tabIcons={},{},{},{}
U._TAB_DEFS={{"game","game","gamepad"},{"general","general","msgCircle"},{"dm","dmtab","msgSquare"},{"scripts","scriptstab","code"},{"announce","announcetab","zap"},{"punish","punishtab","shieldAlert"},{"staff","stafftab","crown"},}
;(function()for i,d in ipairs(U._TAB_DEFS)do local b=mk("TextButton",{Size=u2(1/7,-3,1,0),Text="",BorderSizePixel=0,Font=fGB,TextSize=11,LayoutOrder=i,AutoButtonColor=true,ClipsDescendants=true,ZIndex=7},U.tabsBar)corner(b,8)
  U.tabStrokes[d[1]]=mk("UIStroke",{Color=TH.btnBorder,Thickness=1,Transparency=0.4,ApplyStrokeMode=smBorder},b)
  U.tabBars[d[1]]=mk("Frame",{Size=u2(0.55,0,0,2),Position=u2(0.225,0,1,-2),BorderSizePixel=0,Visible=false,ZIndex=8},b)corner(U.tabBars[d[1]],1)
  local ic=F.lucide(b,d[3],11,{pos=us(0.5,0.5),anc=v2(0.5,0.5),col=TH.muted,themed=false,z=8})
  ic.Visible=false;U.tabIcons[d[1]]=ic
  U.tabs[d[1]]=b end end)()
--- [F.layoutTabs] Tính toán hiển thị và chia đều chiều rộng các thẻ kênh (ẩn/hiện thẻ #staff tùy theo quyền)
function F.layoutTabs()local staff=F.isStaff and F.isStaff(P.username)
  U.tabs.staff.Visible=staff==true local n=staff and 7 or 6 local gap=floor(((n-1)*4)/n)for _,d in ipairs(U._TAB_DEFS)do if U.tabs[d[1]].Visible then U.tabs[d[1]].Size=u2(1/n,-gap,1,0)end end end
--- [F.paintTabs] Cập nhật màu sắc, số lượng tin chưa đọc (unread badge) và gạch chân cho các thẻ kênh
function F.paintTabs()local totalUn=0
  local pillA=clamp(F.surfaceAlpha("pill")+0.14,0.22,0.72)
  for _,d in ipairs(U._TAB_DEFS)do local b=U.tabs[d[1]]local st=U.tabStrokes and U.tabStrokes[d[1]]local on=S.chan==d[1]or(d[1]=="dm"and tostring(S.chan):sub(1,3)=="dm:")
    local un=d[1]=="dm"and F.dmUnreadTotal()or(S.unread[d[1]]or 0)totalUn=totalUn+un local full=T(d[2])local ic=U.tabIcons and U.tabIcons[d[1]]
    local unTxt=un>0 and(un>9 and"9+"or tostring(un))or""
    local lbl
    if P.W<245 then
      lbl=un>0 and unTxt or""
      if ic then ic.Visible=(un==0);ic.Position=us(0.5,0.5);ic.AnchorPoint=v2(0.5,0.5)end
    elseif P.W<440 then
      lbl=(d[1]=="scripts"and"Scripts"or(d[1]=="announce"and(L=="en"and"Announce"or"T.Báo")or(d[1]=="punish"and(L=="en"and"Punish"or"X.Phạt")or full)))..(un>0 and(" "..unTxt)or"")
      if ic then ic.Visible=false end
    else
      lbl="  "..full..(un>0 and(" "..unTxt)or"")
      if ic then ic.Visible=true;ic.Position=u2(0,7,0.5,0);ic.AnchorPoint=v2(0,0.5)end
    end
    b.Text=lbl;b.TextSize=P.W<230 and 12 or 11;b.BackgroundColor3=on and TH.accent or TH.bg2
    b.BackgroundTransparency=on and 0.04 or pillA
    local fg=on and(H.lum(TH.accent)>0.55 and rgb(20,20,24)or c3(1,1,1))or TH.muted b.TextColor3=fg
    if ic then ic.ImageColor3=fg end
    if st then st.Color=on and TH.accent or TH.btnBorder st.Transparency=on and 0.08 or 0.42 end
    local tbBar=U.tabBars and U.tabBars[d[1]]if tbBar then tbBar.Visible=on tbBar.BackgroundColor3=fg end end if U.nanoBadge then
    U.nanoBadge.Visible=totalUn>0 U.nanoBadge.Text=totalUn>9 and"9+"or tostring(totalUn)end end
U.infoBar=mk("Frame",{Size=u2(1,-12,0,18),Position=uo(6,66),BorderSizePixel=0,ZIndex=6},U.main)
-- Khởi tạo thanh thông tin trạng thái kênh (U.infoBar), ô tìm kiếm (U.searchBox) và khung cuộn tin nhắn (U.scroll)
themed(U.infoBar,function(o)o.BackgroundColor3=TH.bg2;o.BackgroundTransparency=F.surfaceAlpha("bar")end);corner(U.infoBar,6);stroke(U.infoBar,"border",1,0.45)
U.infoDot=mk("Frame",{Size=uo(6,6),Position=uo(7,6),BorderSizePixel=0,ZIndex=7},U.infoBar)corner(U.infoDot,3)themed(U.infoDot,function(d)d.BackgroundColor3=(S.pollFail<2 and TH.ok)or TH.danger end)
U.infoLbl=lab(U.infoBar,"",{size=u2(1,-82,1,0),pos=uo(18,0),ts=10,key="muted",trunc=true})U.infoLbl.ZIndex=7
U.infoFrameBtn=mk("TextButton",{Size=uo(56,14),Position=u2(1,-58,0,2),Text=" Frame",Font=fGB,TextSize=9,BorderSizePixel=0,AutoButtonColor=true,Visible=false,ZIndex=8},U.infoBar)
th(U.infoFrameBtn,"BackgroundColor3","btnBg");th(U.infoFrameBtn,"TextColor3","text");corner(U.infoFrameBtn,4);stroke(U.infoFrameBtn,"accent",1,0.4)
F.lucide(U.infoFrameBtn,"crop",10,{pos=uo(4,2),key="accent",z=9})
hook(U.infoFrameBtn.MouseButton1Click,function()
  local imgId=H.assetId(P.backgroundImage or"")
  if not imgId then F.openTheme();return end
  F.openImageCropStudio({target="wallpaper",assetId=imgId,cfg=P.bgFrame,title=L=="en"and"Wallpaper Frame"or"Căn Khung Ảnh Nền",
    onLiveChange=function(st)
      P.backgroundImage=st.id;P.bgFrame={fit=st.fit,zoom=st.zoom,x=st.x,y=st.y,aspect=st.aspect}
      F.applyMainWallpaper(false)
    end,
    onApply=function(st)
      P.backgroundImage=st.id;P.bgFrame={fit=st.fit,zoom=st.zoom,x=st.x,y=st.y,aspect=st.aspect}
      F.paintTheme();S.isDirty=true;F.save(true);F.toast(T("theme_ok"),true)
    end,
    onCancel=function()F.paintTheme()end})
end)
U.searchBox=mk("TextBox",{Size=u2(1,-12,0,26),Position=uo(6,86),Text="",PlaceholderText=T("search"),ClearTextOnFocus=false,Font=fG,TextSize=12,BorderSizePixel=0,Visible=false,TextXAlignment=txL,ZIndex=8},U.main)
F.styleInput(U.searchBox,"text",false)
U.scroll=mk("ScrollingFrame",{Position=uo(6,86),Size=u2(1,-12,1,-155),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=3,CanvasSize=u2(),AutomaticCanvasSize=asY,ScrollingDirection=Enum.ScrollingDirection.Y,ClipsDescendants=true,ZIndex=2},U.main)
-- Khởi tạo thanh hiển thị người đang gõ (U.typing), thanh phản hồi cú pháp Token (U.tokenBar) và thanh trả lời (U.replyBar)
list(U.scroll,4)U.typing=lab(U.main,"",{size=u2(1,-16,0,14),ts=10,key="muted"})U.typing.ZIndex=6 U.tokenBar=mk("Frame",{Size=u2(1,-12,0,22),BorderSizePixel=0,Visible=false,ZIndex=18},U.main)
th(U.tokenBar,"BackgroundColor3","bg2");corner(U.tokenBar,7)U.tokenStroke=mk("UIStroke",{Color=TH.accent,Thickness=1.3,Transparency=0.15,ApplyStrokeMode=smBorder},U.tokenBar)
U.tokenAccent=mk("Frame",{Size=u2(0,3,1,-6),Position=uo(3,3),BackgroundColor3=TH.accent,BorderSizePixel=0,ZIndex=19},U.tokenBar)corner(U.tokenAccent,2)
U.tokenIconHolder=mk("Frame",{Size=uo(16,16),Position=uo(9,3),BackgroundTransparency=1,Visible=false,ZIndex=19},U.tokenBar)U.tokenLbl=lab(U.tokenBar,"",{size=u2(1,-100,1,0),pos=uo(10,0),ts=10,bold=true,trunc=true})
U.tokenLbl.ZIndex=19 U.tokenStatePill=mk("TextLabel",{Size=uo(78,16),Position=u2(1,-82,0.5,-8),BackgroundColor3=TH.ok,TextColor3=c3(1,1,1),Text="",Font=fGB,TextSize=9,BorderSizePixel=0,ZIndex=19},U.tokenBar)
corner(U.tokenStatePill,8)U.replyBar=mk("Frame",{Size=u2(1,-12,0,22),BorderSizePixel=0,Visible=false,ZIndex=16},U.main)th(U.replyBar,"BackgroundColor3","bg2");corner(U.replyBar,6);stroke(U.replyBar,"accent",1,0.4)
U.replyIcon=F.lucide(U.replyBar,"reply",11,{pos=uo(7,5),key="accent",z=17})
U.replyLbl=lab(U.replyBar,"",{size=u2(1,-46,1,0),pos=uo(22,0),ts=10,key="text",trunc=true})U.replyLbl.ZIndex=17
U.replyX=mk("TextButton",{Size=uo(22,22),Position=u2(1,-22,0,0),BackgroundTransparency=1,Text="",BorderSizePixel=0,ZIndex=17},U.replyBar)
F.lucide(U.replyX,"x",10,{pos=us(0.5,0.5),anc=v2(0.5,0.5),key="muted",z=18})
-- Khởi tạo thanh gợi ý tự động (U.suggest) và thanh nhập liệu chính (U.chatBar: nút /, @, ô nhập lõm sâu tinh tế, Emoji, Poll, Gửi)
U.suggest=mk("ScrollingFrame",{Size=u2(1,-12,0,28),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=0,CanvasSize=u2(),AutomaticCanvasSize=asX,ScrollingDirection=Enum.ScrollingDirection.X,Visible=false,ZIndex=18},U.main)
mk("UIListLayout",{FillDirection=fdH,Padding=u1(0,4),SortOrder=soLO,VerticalAlignment=vaC},U.suggest)U.chatBar=mk("Frame",{Size=u2(1,-12,0,40),BorderSizePixel=0,ZIndex=12},U.main)
th(U.chatBar,"BackgroundColor3","bg2");U.chatBarCorner=corner(U.chatBar,max(4,(P.uiRadius or 10)-2))U.chatBarStroke=mk("UIStroke",{Color=TH.border,Thickness=1.2,Transparency=0.25,ApplyStrokeMode=smBorder},U.chatBar)
U.cmdBtn=mk("TextButton",{Size=uo(26,30),Text="/",Font=fGB,TextSize=13,BorderSizePixel=0,AutoButtonColor=true,ZIndex=14},U.chatBar)
th(U.cmdBtn,"BackgroundColor3","btnBg");th(U.cmdBtn,"TextColor3","accent");corner(U.cmdBtn,7)U.cmdBtnStroke=mk("UIStroke",{Color=TH.btnBorder,Thickness=1,Transparency=0.25,ApplyStrokeMode=smBorder},U.cmdBtn)
U.atBtn=mk("TextButton",{Size=uo(26,30),Text="@",Font=fGB,TextSize=12,BorderSizePixel=0,AutoButtonColor=true,ZIndex=14},U.chatBar)th(U.atBtn,"BackgroundColor3","btnBg");th(U.atBtn,"TextColor3","mentionText");corner(U.atBtn,7)
U.atBtnStroke=mk("UIStroke",{Color=TH.btnBorder,Thickness=1,Transparency=0.25,ApplyStrokeMode=smBorder},U.atBtn)U.inputWrap=mk("Frame",{Size=u2(1,-170,0,32),BorderSizePixel=0,ClipsDescendants=true,ZIndex=13},U.chatBar)
th(U.inputWrap,"BackgroundColor3","inputBg");corner(U.inputWrap,8)U.inputStroke=mk("UIStroke",{Color=TH.inputBorder,Thickness=1.3,Transparency=0.15,ApplyStrokeMode=smBorder},U.inputWrap)
U.tokenDot=mk("Frame",{Size=uo(7,7),Position=uo(7,12),BackgroundColor3=TH.muted,BorderSizePixel=0,ZIndex=15},U.inputWrap)corner(U.tokenDot,4)U.input=mk("TextBox",{Size=u2(1,-22,1,0),Position=uo(18,0),
  BackgroundTransparency=1,Text="",PlaceholderText=T("input"),ClearTextOnFocus=false,Font=fG,TextSize=P.textSize,BorderSizePixel=0,TextXAlignment=txL,TextYAlignment=Enum.TextYAlignment.Center,TextWrapped=false,
  ZIndex=16,},U.inputWrap)th(U.input,"PlaceholderColor3","muted")U.inputRich=mk("TextLabel",{Size=u2(1,-22,1,0),Position=uo(18,0),BackgroundTransparency=1,Text="",Font=fG,TextSize=P.textSize,BorderSizePixel=0,
  TextXAlignment=txL,TextYAlignment=Enum.TextYAlignment.Center,TextWrapped=false,RichText=true,Visible=false,Active=false,ZIndex=15,},U.inputWrap)pcall(function()U.inputRich.Interactable=false end)
U.emojiBtn=tbtn(U.chatBar,"",{size=uo(30,30),r=7});U.emojiBtn.ZIndex=15 U.emojiBtnStroke=U.emojiBtn:FindFirstChildOfClass("UIStroke")
F.lucide(U.emojiBtn,"smile",15,{pos=us(0.5,0.5),anc=v2(0.5,0.5),key="text",contrastBg="btnBg",z=16})
U.pollBtn=tbtn(U.chatBar,"",{size=uo(30,30),r=7});U.pollBtn.ZIndex=15
F.lucide(U.pollBtn,"chartCol",14,{pos=us(0.5,0.5),anc=v2(0.5,0.5),key="text",contrastBg="btnBg",z=16})
U.sendBtn=tbtn(U.chatBar,T("send"),{size=uo(64,30),key="accent",r=7});U.sendBtn.ZIndex=15
U.sendPad=pad(U.sendBtn,20,0,5,0)
U.sendIcon=F.lucide(U.sendBtn,"send",12,{pos=u2(0,-13,0.5,0),anc=v2(0,0.5),col=c3(1,1,1),themed=false,z=16})
themed(U.sendIcon,function(ic)ic.ImageColor3=H.lum(TH.accent)>0.55 and rgb(20,20,24)or c3(1,1,1)end)
function F.updateSendBtn()
  if not U.sendBtn then return end
  local w=P.W or 340
  if w<220 then
    U.sendBtn.Text=""
    if U.sendPad then U.sendPad.PaddingLeft=u1(0,0);U.sendPad.PaddingRight=u1(0,0)end
    if U.sendIcon then U.sendIcon.Visible=true;U.sendIcon.Position=us(0.5,0.5);U.sendIcon.AnchorPoint=v2(0.5,0.5)end
  elseif w<285 then
    U.sendBtn.Text=T("send");U.sendBtn.TextSize=11
    if U.sendPad then U.sendPad.PaddingLeft=u1(0,4);U.sendPad.PaddingRight=u1(0,4)end
    if U.sendIcon then U.sendIcon.Visible=false end
  else
    U.sendBtn.Text=T("send");U.sendBtn.TextSize=11
    if U.sendPad then U.sendPad.PaddingLeft=u1(0,20);U.sendPad.PaddingRight=u1(0,5)end
    if U.sendIcon then U.sendIcon.Visible=true;U.sendIcon.Position=u2(0,-13,0.5,0);U.sendIcon.AnchorPoint=v2(0,0.5)end
  end
end hook(U.cmdBtn.MouseButton1Click,function()
  local cur=U.input.Text if cur:sub(1,1)=="/"then U.input.Text=cur:gsub("^/%S*%s*","")else U.input.Text="/"..cur end
  F.updateSuggest()task.defer(function()if U.input and U.input.Parent then
      pcall(function()U.input.CursorPosition=#U.input.Text+1 end)pcall(function()U.input:CaptureFocus()end)end end)end)hook(U.atBtn.MouseButton1Click,function()local cur=U.input.Text if cur:match("@[%w_]*$")then
    U.input.Text=cur:gsub("@[%w_]*$","")else local sep=(cur~=""and not cur:match("%s$"))and" "or""U.input.Text=cur..sep.."@"end
  F.updateSuggest()task.defer(function()if U.input and U.input.Parent then
      pcall(function()U.input.CursorPosition=#U.input.Text+1 end)pcall(function()U.input:CaptureFocus()end)end end)end)U.jump=tbtn(U.main,"↓",{size=uo(60,26),key="accent",ts=11})U.jump.Visible=false;U.jump.ZIndex=10
-- Khởi tạo góc kéo đổi kích thước (U.resize), khung chứa thông báo nổi (U.toasts) và lớp phủ hộp thoại (U.modal)
U.resize=mk("TextButton",{Size=uo(18,18),Position=u2(1,-18,1,-18),BackgroundTransparency=1,Text="◢",TextSize=10,Font=fGB,BorderSizePixel=0,ZIndex=25},U.main)th(U.resize,"TextColor3","muted")
U.toasts=mk("Frame",{Size=uo(250,300),BackgroundTransparency=1,ZIndex=200},U.gui)mk("UIListLayout",{Padding=u1(0,4),SortOrder=soLO},U.toasts)
U.layer=mk("Frame",{Size=us(1,1),BackgroundTransparency=1,ZIndex=100,Visible=false},U.gui)U.modal=mk("Frame",{Size=us(1,1),BackgroundTransparency=1,ZIndex=40,Visible=false},U.gui)

-- =============================================================================
-- 12. TÍNH TOÁN BỐ CỤC ĐÁP ỨNG (RESPONSIVE / NANO MODE) & HỘP THOẠI MODAL/POPUP
-- =============================================================================
--- [tryMatchChatSize] Tự động đồng bộ kích thước cửa sổ Chat Bridge khớp với khung chat mặc định của Roblox khi mới khởi chạy lần đầu
local function tryMatchChatSize()if saved.W~=nil then return end
  pcall(function()local tcs=game:GetService("TextChatService")local win=tcs.ChatWindowConfiguration local sz=win.AbsoluteSize if sz and sz.X>120 and sz.Y>80 then P.W=clamp(sz.X+16,280,480)P.H=clamp(sz.Y+70,220,420)
      S.isDirty=true F.layout()end end)end
task.delay(3,tryMatchChatSize)
--- [F.layout] Tính toán và sắp xếp lại toàn bộ bố cục cửa sổ chính (hỗ trợ chế độ đầy đủ, thu gọn và Nano 60x60) và lưu vị trí
function F.layout()local v=viewNow()P.W=clamp(P.W,CFG.MIN_W,max(CFG.MIN_W,v.X-8))P.H=clamp(P.H,CFG.MIN_H,max(CFG.MIN_H,v.Y-8))
  if P.W>=240 and P.H>=220 then S.prevW,S.prevH=P.W,P.H;P.prevW,P.prevH=P.W,P.H end
  if S.winX==nil or S.winY==nil then
    if P.winX~=nil and P.winY~=nil then S.winX,S.winY=P.winX,P.winY
    else S.winX=max(4,floor((v.X-P.W)/2));S.winY=max(4,floor((v.Y-P.H)/2))end
  end
  S.winX=clamp(floor(S.winX+0.5),0,max(0,v.X-30));S.winY=clamp(floor(S.winY+0.5),0,max(0,v.Y-30))
  P.winX,P.winY=S.winX,S.winY
  U.main.Size=uo(P.W,P.H)U.main.Position=uo(S.winX,S.winY)local W,Hh=P.W,P.H local isNano=(W<115 or Hh<95)local isMicro=not isNano and(W<190 or Hh<165)local isCompact=not isNano and not isMicro and(W<285 or Hh<235)
  local hidden=uo(6,Hh+80)if isNano then U.titleBar.Size=u2(1,0,0,22)U.dot.Position=uo(6,7)U.titleLbl.Visible=W>=85 U.titleLbl.Position=uo(18,0)U.titleLbl.Size=u2(1,-44,1,0)U.titleLbl.Text="CB"U.titleLbl.TextSize=10
    U.bLang.Visible=false;U.bFind.Visible=false;U.bUsers.Visible=false;U.bMe.Visible=false;U.bSet.Visible=false U.bMin.Visible=true U.bMin.Size=uo(20,18)U.tbtns.Size=uo(22,22)U.tbtns.Position=u2(1,-24,0,0)
    U.divider.Position=uo(0,22)U.nanoBox.Visible=true U.nanoBox.Position=uo(0,23)U.nanoBox.Size=u2(1,0,1,-23)local chIcon=S.chan=="announce"and"📢"or(S.chan=="punish"and"🚨"or(S.chan=="game"and"🎮"or(S.chan=="scripts"and"📜"or(tostring(S.chan):sub(1,3)=="dm:"and"💭"or"💬"))))
    U.nanoBtn.Text=chIcon U.nanoBtn.TextSize=clamp(min(W,Hh)-42,13,20)U.tabsBar.Visible=false U.infoBar.Visible=false U.searchBox.Visible=false U.scroll.Visible=false U.typing.Visible=false
    U.tokenBar.Visible=false U.replyBar.Visible=false U.suggest.Visible=false U.chatBar.Visible=false U.jump.Visible=false U.resize.Size=uo(14,14)U.resize.Position=u2(1,-14,1,-14)U.resize.Text="◢"
    if F.paintTabs then pcall(F.paintTabs)end return end
  U.nanoBox.Visible=false U.chatBar.Visible=true U.input.Visible=true U.scroll.Visible=true U.resize.Text="◢"U.resize.Size=uo(18,18)U.resize.Position=u2(1,-18,1,-18)
  U.titleLbl.Text=T("title")U.titleLbl.TextSize=isMicro and 11 or 13 local tbH=isMicro and 26 or(isCompact and 30 or 34)U.titleBar.Size=u2(1,0,0,tbH)U.dot.Position=uo(9,floor((tbH-8)/2))U.divider.Position=uo(0,tbH)
  local showLang=W>=290 local showFind=W>=210 local showUsers=W>=250 local showMe=W>=175 U.bLang.Visible=showLang U.bFind.Visible=showFind U.bUsers.Visible=showUsers U.bMe.Visible=showMe U.bSet.Visible=true
  U.bMin.Visible=true local btnH=max(20,tbH-8)for _,b in ipairs({U.bLang,U.bFind,U.bUsers,U.bMe,U.bSet,U.bMin})do b.Size=uo(b==U.bLang and 28 or(isMicro and 22 or 26),btnH)end
  local visBtns=2+(showLang and 1 or 0)+(showFind and 1 or 0)+(showUsers and 1 or 0)+(showMe and 1 or 0)local tbtnsW=visBtns*(isMicro and 25 or 29)+4 U.tbtns.Size=uo(tbtnsW,tbH)U.tbtns.Position=u2(1,-(tbtnsW+4),0,0)
  U.titleLbl.Visible=W>=145 U.titleLbl.Position=uo(22,0)U.titleLbl.Size=u2(1,-(tbtnsW+28),1,0)local top=tbH+4 local showTabs=Hh>=130 U.tabsBar.Visible=showTabs if showTabs then
    local tabH=(isMicro or P.compact)and 22 or 26 U.tabsBar.Position=uo(6,top)U.tabsBar.Size=u2(1,-12,0,tabH)top=top+tabH+4 end
  local showInfo=Hh>=210 and W>=220 and not P.compact U.infoBar.Visible=showInfo
  if showInfo then U.infoBar.Position=uo(6,top)U.infoBar.Size=u2(1,-12,0,18)top=top+21 end if U.searchBox.Visible then U.searchBox.Position=uo(6,top)U.searchBox.Size=u2(1,-12,0,26)top=top+29 end
  local barH=isMicro and 32 or(isCompact and 36 or 40)local innerH=barH-8 local barY=Hh-(barH+6)local barW=W-12 U.chatBar.Position=uo(6,barY)U.chatBar.Size=uo(barW,barH)local showCmdBtn=W>=210 local showAtBtn=W>=275
  local showEmoji=W>=150 local showPoll=W>=245 local leftX=4 local quickW=isMicro and 22 or 26 U.cmdBtn.Visible=showCmdBtn if showCmdBtn then U.cmdBtn.Position=uo(leftX,4)U.cmdBtn.Size=uo(quickW,innerH)
    leftX=leftX+quickW+4 end
  U.atBtn.Visible=showAtBtn if showAtBtn then U.atBtn.Position=uo(leftX,4)U.atBtn.Size=uo(quickW,innerH)leftX=leftX+quickW+4 end
  local sendW=(W<220)and 32 or(isCompact and 48 or 64)
  if F.updateSendBtn then F.updateSendBtn()end local emojiW=isMicro and 26 or 30 local pollW=isMicro and 26 or 30 local rightX=barW-4-sendW U.sendBtn.Position=uo(rightX,4)
  U.sendBtn.Size=uo(sendW,innerH)U.pollBtn.Visible=showPoll if showPoll then rightX=rightX-4-pollW U.pollBtn.Position=uo(rightX,4)U.pollBtn.Size=uo(pollW,innerH)end
  U.emojiBtn.Visible=showEmoji if showEmoji then
    rightX=rightX-4-emojiW U.emojiBtn.Position=uo(rightX,4)U.emojiBtn.Size=uo(emojiW,innerH)end
  local wrapW=max(36,rightX-leftX-4)U.inputWrap.Position=uo(leftX,4)U.inputWrap.Size=uo(wrapW,innerH)
  U.tokenDot.Position=uo(7,floor((innerH-6)/2))U.input.Position=uo(18,0)U.input.Size=u2(1,-22,1,0)U.inputRich.Position=uo(18,0)U.inputRich.Size=u2(1,-22,1,0)local y=barY-3 local rbOn=U.replyBar.Visible and Hh>=120
  U.replyBar.Position=rbOn and uo(6,y-22)or hidden U.replyBar.Size=u2(1,-12,0,22)if rbOn then y=y-24 end
  local tkOn=U.tokenBar.Visible and Hh>=105 U.tokenBar.Position=tkOn and uo(6,y-22)or hidden
  U.tokenBar.Size=u2(1,-12,0,22)if tkOn then y=y-24 end
  local sgOn=U.suggest.Visible and Hh>=105 U.suggest.Position=sgOn and uo(6,y-26)or hidden U.suggest.Size=u2(1,-12,0,26)if sgOn then y=y-28 end
  local showTyping=Hh>=180 and U.typing.Text~=""U.typing.Visible=Hh>=180 U.typing.Position=uo(8,y-14)U.typing.Size=u2(1,-16,0,14)local bottomEdge=showTyping and(y-15)or(y-2)U.scroll.Position=uo(6,top)
  U.scroll.Size=u2(1,-12,0,max(0,bottomEdge-top))U.jump.Position=uo(max(6,W-68),max(top,bottomEdge-30))local tw=min(250,v.X-16)U.toasts.Size=uo(tw,300)local pos=P.toastPos
  local tx=(pos=="tl"or pos=="bl")and 8 or(v.X-tw-8)local ty=(pos=="tl"or pos=="tr")and 8 or(v.Y-308)U.toasts.Position=uo(tx,ty)
  U.toasts:FindFirstChildOfClass("UIListLayout").VerticalAlignment=(pos=="bl"or pos=="br")and Enum.VerticalAlignment.Bottom or Enum.VerticalAlignment.Top if F.paintTabs then pcall(F.paintTabs)end if F.applyMainWallpaper then pcall(F.applyMainWallpaper,false)end end
--- [F.toast] Hiển thị thông báo nổi (Toast Notification) ở góc màn hình và tự động ẩn sau 4 giây
function F.toast(text,force,fn)if not force and not P.notify then return end
  local b=mk("TextButton",{Size=u2(1,0,0,0),AutomaticSize=asY,Text="",BorderSizePixel=0,AutoButtonColor=false,LayoutOrder=floor(os.clock()*100)%100000},U.toasts)
  th(b,"BackgroundColor3","title");corner(b,8);stroke(b,"accent",1,0.4);pad(b,10,6,10,6)lab(b,tostring(text),{wrap=true,auto=true,ts=12})
  if fn then hook(b.MouseButton1Click,function()b:Destroy();fn()end)else hook(b.MouseButton1Click,function()b:Destroy()end)end Debris:AddItem(b,4)return b end
--- [F.closeModal] Đóng hộp thoại Modal đang mở và xóa toàn bộ các lớp Popup con
function F.closeModal()
  for _,c in ipairs(U.modal:GetChildren())do c:Destroy()end
  U.modal.Visible=false S.popN=0 S.reopenModal=nil end
--- [buildBox] Xây dựng khung hộp thoại chuẩn (có thanh tiêu đề bo góc mượt, nút đóng 'X' và vùng cuộn nội dung)
local function buildBox(parentFrame,title,w,h,z,onClose)local v=viewNow()w=min(w or 340,v.X-16)h=min(h or 420,v.Y-16)
  local mode=P.backgroundMode or"solid"
  local mRad=clamp((tonumber(P.uiRadius)or 10)+2,4,18)
  local box=mk("Frame",{Size=uo(w,h),AnchorPoint=v2(0.5,0.5),Position=us(0.5,0.5),BorderSizePixel=0,ClipsDescendants=true,ZIndex=z+1,Active=true},parentFrame)
  th(box,"BackgroundColor3","bg2");corner(box,mRad)
  if mode=="glass"then box.BackgroundTransparency=F.surfaceAlpha("modal")
  elseif mode=="image"then
    local imgId=H.assetId(P.backgroundImage or"")
    if imgId then
      local wpBg=F.createClipHost(box,{Size=us(1,1),BackgroundTransparency=1,BorderSizePixel=0,ClipsDescendants=true,ZIndex=z+1})
      corner(wpBg,mRad)
      local wpImg=mk("ImageLabel",{Size=us(1,1),AnchorPoint=v2(0.5,0.5),Position=us(0.5,0.5),BackgroundTransparency=1,BorderSizePixel=0,ImageTransparency=clamp(1-(tonumber(P.backgroundOpacity)or 0.82)*0.28,0.68,0.92),ZIndex=z+1},wpBg)
      F.setAsset(wpImg,imgId,function()
        if wpImg and wpImg.Parent then F.applyImageFrame(wpBg,wpImg,P.bgFrame,w,h)end
      end,wpImg.ImageTransparency)
      F.applyImageFrame(wpBg,wpImg,P.bgFrame,w,h)
    end
  end
  if mode=="gradient"or mode=="mesh"or mode=="glass"then
    local bgGrad=mk("UIGradient",{Rotation=tonumber(P.gradAngle)or 28,Color=ColorSequence.new({ColorSequenceKeypoint.new(0,TH.bg2),ColorSequenceKeypoint.new(0.6,H.mix(TH.bg2,TH.g2,0.36)),ColorSequenceKeypoint.new(1,H.mix(TH.bg2,TH.g3,0.42))})},box)
    bgGrad.Enabled=true
  end
  local bs=mk("UIStroke",{Thickness=P.borderGlow~=false and 1.4 or 1.2,Transparency=P.borderGlow~=false and 0.2 or 0.45,ApplyStrokeMode=smBorder,Color=P.borderGlow~=false and c3(1,1,1)or TH.accent},box)
  if P.borderGlow~=false then mk("UIGradient",{Rotation=(tonumber(P.gradAngle)or 28)+15,Color=ColorSequence.new({ColorSequenceKeypoint.new(0,TH.accent),ColorSequenceKeypoint.new(0.5,H.mix(TH.accent,TH.g3,0.6)),ColorSequenceKeypoint.new(1,H.mix(TH.accent,TH.ok,0.45))})},bs)end
  local head=mk("Frame",{Size=u2(1,0,0,34),BackgroundTransparency=1,ZIndex=z+3},box)
  local hBar=mk("Frame",{Size=uo(3,14),Position=uo(10,10),BorderSizePixel=0,ZIndex=z+4},head)th(hBar,"BackgroundColor3","accent");corner(hBar,2)
  local titleLbl=lab(head,title,{size=u2(1,-52,1,0),pos=uo(18,0),bold=true,ts=14,trunc=true});titleLbl.ZIndex=z+4
  themed(titleLbl,function(lb)lb.TextColor3=H.ensureContrast(TH.text,TH.bg2,4.8)end)
  local hdiv=mk("Frame",{Size=u2(1,-16,0,1),Position=uo(8,34),BorderSizePixel=0,ZIndex=z+3},box)th(hdiv,"BackgroundColor3","border")
  local x=tbtn(head,"",{size=uo(28,24),pos=u2(1,-34,0,5),ts=11,key="btnBg",r=max(5,mRad-6)});x.ZIndex=z+4
  F.lucide(x,"x",13,{pos=us(0.5,0.5),anc=v2(0.5,0.5),key="text",contrastBg="btnBg",z=z+5})
  hook(x.MouseButton1Click,onClose)
  local scr=mk("ScrollingFrame",{Size=u2(1,-16,1,-42),Position=uo(8,38),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=3,CanvasSize=u2(),AutomaticCanvasSize=asY,ZIndex=z+3},box)list(scr,6);pad(scr,2,2,4,8)
  return scr,box end
--- [F.modalBox] Mở một hộp thoại Modal chính giữa màn hình (đóng Modal cũ nếu có)
function F.modalBox(title,w,h)F.closeModal()U.modal.Visible=true
  local back=mk("TextButton",{Size=us(1,1),BackgroundColor3=c3(0,0,0),BackgroundTransparency=0.45,Text="",AutoButtonColor=false,ZIndex=40},U.modal)hook(back.MouseButton1Click,F.closeModal)
  local scr,box=buildBox(U.modal,title,w,h,40,F.closeModal)return scr,F.closeModal,box end
--- [F.popup] Mở một hộp thoại Popup xếp chồng lên trên Modal hiện tại
function F.popup(title,w,h)if not U.modal.Visible then local scr,closeFn,box=F.modalBox(title,w,h)return scr,closeFn,box end
  S.popN=S.popN+1 local z=50+S.popN*4 local layer=mk("TextButton",{Size=us(1,1),BackgroundColor3=c3(0,0,0),BackgroundTransparency=0.5,Text="",AutoButtonColor=false,ZIndex=z},U.modal)local box
  local function close()pcall(function()layer:Destroy()end);pcall(function()box:Destroy()end)end
  hook(layer.MouseButton1Click,close)local scr scr,box=buildBox(U.modal,title,w,h,z,close)return scr,close,box end

-- =============================================================================
-- 13. HỆ THỐNG PHÂN QUYỀN ROLE, CẤP BẬC (RANK) & KIỂM TRA CẤM CHAT (MUTE)
-- =============================================================================
F.DEVROLE={id="_dev",name="DEV",color="#FAA81A",icon="",position=9999,isAdmin=true,mentionAll=true}
--- [F.assignKeyFor] Tìm khóa tên người dùng tương ứng (không phân biệt hoa thường) trong bảng phân quyền `S.assign`
function F.assignKeyFor(u)if not u or type(S.assign)~="table"then return nil end if S.assign[u]~=nil then return u end
  local ln=tostring(u):lower()for k in pairs(S.assign)do if type(k)=="string"and k:lower()==ln then return k end end return nil end
--- [F.isDev] Kiểm tra người dùng `u` có phải là Developer của hệ thống hay không
function F.isDev(u)if not u then return false end
  return CFG.DEVELOPERS[u]==true or S.devs[tostring(u):lower()]==true end
--- [F.invalidateRoleCache] Xóa bộ nhớ đệm tra cứu Role để buộc tính toán lại khi dữ liệu phân quyền thay đổi
function F.invalidateRoleCache()S.roleMapCache=nil S.userRolesCache={}end
--- [F.roleById] Tra cứu thông tin đối tượng Role theo `id` (có sử dụng cache `S.roleMapCache`)
function F.roleById(id)if not id then return nil end if not S.roleMapCache then S.roleMapCache={}for _,r in ipairs(S.roles)do if r.id then S.roleMapCache[r.id]=r end end end return S.roleMapCache[id]end
--- [F.userRoles] Lấy danh sách các Role của người dùng `u`, sắp xếp giảm dần theo thứ bậc (`position`)
function F.userRoles(u)if not u then return{}end
  S.userRolesCache=S.userRolesCache or{}local ln=tostring(u):lower()local cached=S.userRolesCache[ln]if cached then return cached end
  local out,seen={},{}for key,set in pairs(S.assign)do if type(key)=="string"and key:lower()==ln and type(set)=="table"then for rid in pairs(set)do
        if not seen[rid]then seen[rid]=true local r=F.roleById(rid)if r then out[#out+1]=r end end end end end tsort(out,function(x,y)if x.position~=y.position then return x.position>y.position end
    return tostring(x.id)<tostring(y.id)end)S.userRolesCache[ln]=out return out end
--- [F.hasRole] Kiểm tra người dùng `u` có đang sở hữu Role có mã `rid` hay không
function F.hasRole(u,rid)if not u or not rid then return false end for _,r in ipairs(F.userRoles(u))do if r.id==rid then return true end end return false end
--- [F.setRole] Gán hoặc gỡ một Role `rid` cho người dùng `u` trong bảng `S.assign`
function F.setRole(u,rid,on)if not u or not rid then return end
  F.invalidateRoleCache()local ln=tostring(u):lower()local canon for k,set in pairs(S.assign)do if type(k)=="string"and k:lower()==ln and type(set)=="table"then canon=canon or k
      set[rid]=nil if not next(set)then S.assign[k]=nil end end end if on then canon=canon or u S.assign[canon]=S.assign[canon]or{}S.assign[canon][rid]=true end end
--- [F.topRole] Lấy Role cao nhất của người dùng `u` (trả về `F.DEVROLE` nếu là Developer)
function F.topRole(u)local l=F.userRoles(u);return l[1]end
--- [F.rank] Lấy chỉ số cấp bậc (`position`) cao nhất của người dùng (Developer = 10000)
function F.rank(u)if F.isDev(u)then return 10000 end
  local r=F.topRole(u)return r and r.position or 0 end
--- [F.isAdmin] Kiểm tra người dùng `u` có quyền Quản trị viên (Admin hoặc Developer) hay không
function F.isAdmin(u)if F.isDev(u)then return true end
  for _,r in ipairs(F.userRoles(u))do if r.isAdmin then return true end end return false end
F.isStaff=F.isAdmin
--- [F.canMentionAll] Kiểm tra người dùng `u` có quyền nhắc tên toàn bộ máy chủ (`@everyone`, `@here`) hay không
function F.canMentionAll(u)if F.isDev(u)then return true end
  for _,r in ipairs(F.userRoles(u))do if r.mentionAll or r.isAdmin then return true end end return false end
--- [F.canAnnounce] Kiểm tra người dùng `u` có quyền đăng tin vào kênh thông báo (`#announce`) hay không
function F.canAnnounce(u)if F.isStaff(u)then return true end for _,r in ipairs(F.userRoles(u))do
    if r.canAnnounce==true then return true end
    local rn=tostring(r.name or""):lower()
    if rn:find("tester",1,true)or rn:find("test",1,true)or rn:find("dev",1,true)or rn:find("admin",1,true)or rn:find("mod",1,true)or rn:find("owner",1,true)or rn:find("staff",1,true)then return true end end return false end
--- [F.canAct] Kiểm tra người thực thi (`actor`) có quyền xử phạt (Mute/Warn/Revoke) đối với `target` hay không (dựa theo cấp bậc)
function F.canAct(actor,target)if not actor or not target or actor==target then return false end if F.isDev(target)then return F.isDev(actor)end if not F.isAdmin(actor)then return false end
  return F.rank(actor)>F.rank(target)end
--- [F.applyRoles] Áp dụng dữ liệu Role và bảng phân quyền mới nhận từ máy chủ vào trạng thái `S.roles` và `S.assign`
function F.applyRoles(obj,seq,trusted)if type(obj)~="table"then return end if not trusted and not F.isDev(obj.by)then return end seq=tonumber(seq)or tonumber(obj.seq)or 0
  if seq<S.rolesSeq then return end
  local roles,assign={},{}for _,r in ipairs(type(obj.roles)=="table"and obj.roles or{})do if type(r)=="table"and r.id and r.name then roles[#roles+1]={
        id=tostring(r.id),name=tostring(r.name),color=H.safeHex(r.color),icon=tostring(r.icon or""),position=tonumber(r.position)or 0,isAdmin=r.isAdmin==true,mentionAll=r.mentionAll==true,canAnnounce=r.canAnnounce==true,}
    end end
  local userCase={}for u in pairs(S.users)do userCase[u:lower()]=u end userCase[P.username:lower()]=P.username for u,v in pairs(type(obj.assign)=="table"and obj.assign or{})do local set={}
    if type(v)=="string"then set[v]=true elseif type(v)=="table"then for k,x in pairs(v)do if x==true then set[k]=true elseif type(x)=="string"then set[x]=true end end end if next(set)then local lk=tostring(u):lower()
      local canon=userCase[lk]or tostring(u)if assign[canon]then for rid in pairs(set)do assign[canon][rid]=true end else assign[canon]=set end end end
  S.roles,S.assign,S.rolesSeq=roles,assign,seq F.invalidateRoleCache()S.isDirty=true
  if F.layoutTabs then F.layoutTabs()end if S.booted and F.rebuildFeed then pcall(F.rebuildFeed)end
  F.emit("roles",roles)end
--- [F.nextPosition] Tính giá trị `position` tiếp theo (lớn nhất hiện tại + 10) khi tạo Role mới
function F.nextPosition()local m=0 for _,r in ipairs(S.roles)do m=max(m,r.position)end
  return m+10 end
--- [F.publishRoles] Đẩy toàn bộ cấu hình Role hiện tại lên endpoint `/api/roles` (chỉ dành cho Developer)
function F.publishRoles(silent)if not F.isDev(P.username)then return end enqueue("send","POST","/api/roles",{by=P.username,base=S.rolesSeq,roles=S.roles,assign=S.assign},function(data,err)
    if data and data.ok then S.rolesSeq=tonumber(data.seq)or S.rolesSeq if type(data.emojis)=="table"then local oldEs=S.emojiSeq S.sharedEmojis=data.emojis S.emojiSeq=tonumber(data.emojiSeq)or 0
        if S.emojiSeq~=oldEs then S.isDirty=true end end if type(data.scripts)=="table"then local oldSs=S.scriptSeq S.scripts=data.scripts S.scriptSeq=tonumber(data.scriptSeq)or 0 if S.scriptSeq~=oldSs then S.isDirty=true
          if S.chan=="scripts"and S.booted then pcall(F.rebuildFeed,true)end end end if type(data.roles)=="table"then F.applyRoles(data.roles,data.seq,true)end
      S.isDirty=true if not silent then F.toast(T("role_saved"),true)end
    elseif data and data.error=="stale"and type(data.roles)=="table"then F.applyRoles(data.roles,data.seq,true)F.toast(T("roles_stale"),true)else F.toast(T("roles_fail")..tostring((data and data.error)or err),true)end
  end)end
--- [F.queueRoles] Đặt lịch đẩy cấu hình Role lên máy chủ sau 0.35s (gom nhiều thao tác chỉnh sửa liên tiếp)
function F.queueRoles()S.rolesToken=(S.rolesToken or 0)+1 local my=S.rolesToken task.delay(1.2,function()if S.rolesToken==my and NET.alive then F.publishRoles()end end)end
--- [F.fmtTimeFull] Định dạng Unix timestamp sang chuỗi Giờ:Phút · Ngày/Tháng (HH:MM · DD/MM)
function F.fmtTimeFull(ts)ts=tonumber(ts)if not ts or ts<=0 then return""end
  local d=os.date("*t",ts)return string.format("%02d:%02d · %02d/%02d",d.hour,d.min,d.day,d.month)end
--- [F.fmtExpire] Định dạng thời hạn hết hạn của lệnh Mute/Ban (hiển thị số phút còn lại hoặc Vĩnh viễn)
function F.fmtExpire(exp)exp=tonumber(exp)or 0 if exp<=0 then return T("perm_lbl")end
  local rem=max(0,math.ceil((exp-H.now())/60))return rem.."m ("..H.shortTime(exp)..")"end
--- [F.getMute] Lấy thông tin cấm chat (Mute) đang còn hiệu lực của người dùng `u` (không phân biệt hoa/thường)
function F.getMute(u)if not u or u==""then return nil end
  local ln=tostring(u):lower()local m=S.mutes[ln]or S.mutes[u]
  if not m then for k,v in pairs(S.mutes)do if tostring(k):lower()==ln then m=v;break end end end
  if type(m)~="table"or m.on==false then return nil end
  local exp=tonumber(m.exp)or 0
  if exp>0 and exp<=H.now()then m.on=false;S.mutes[ln]=nil;S.mutes[u]=nil;return nil end
  return m end
--- [F.muted] Kiểm tra người dùng `u` có đang bị cấm chat (Mute) còn hiệu lực hay không
function F.muted(u)return F.getMute(u)~=nil end
--- [F.applyMute] Cập nhật trạng thái cấm chat (Mute) cho người dùng `u` và hiển thị thông báo nếu là bản thân
function F.applyMute(u,m)if not u or type(m)~="table"then return end
  m.on=m.on~=false m.u=tostring(m.u or u)m.reason=tostring(m.reason or"")m.exp=tonumber(m.exp)or 0 m.by=tostring(m.by or"")m.ts=tonumber(m.ts)or H.now()
  local ln=tostring(u):lower()
  if m.on then S.mutes[ln]=m;S.mutes[u]=m else S.mutes[ln]=nil;S.mutes[u]=nil end
  if ln==P.username:lower()then P.mute=m;S.isDirty=true end end
--- [F.clearMuteState] Xóa trạng thái cấm chat của người dùng `u` khỏi bộ nhớ
function F.clearMuteState(u)if not u then return end
  local ln=tostring(u):lower()for k in pairs(S.mutes)do if tostring(k):lower()==ln then S.mutes[k]=nil end end
  if ln==P.username:lower()then P.mute={on=false,reason="",exp=0,by=""};S.isDirty=true end end
--- [F.getWarns] Lấy danh sách các cảnh báo (Warn) của người dùng `u` (không phân biệt hoa/thường)
function F.getWarns(u)if not u or u==""then return{}end
  local ln=tostring(u):lower()local list=S.warns[ln]or S.warns[u]
  if not list then for k,v in pairs(S.warns)do if tostring(k):lower()==ln and type(v)=="table"then list=v;break end end end
  return type(list)=="table"and list or{}end
--- [F.addWarnState] Thêm một cảnh báo mới vào hồ sơ của người dùng `u` (chống trùng lặp)
function F.addWarnState(u,w)if not u or type(w)~="table"then return end
  local ln=tostring(u):lower()local list=F.getWarns(u)
  local wid=tostring(w.id or("w-"..tostring(w.ts or H.now()).."-"..ln))
  for _,x in ipairs(list)do if x.id==wid or(x.ts==w.ts and x.reason==w.reason and x.by==w.by)then return end end
  tinsert(list,{id=wid,u=tostring(u),reason=tostring(w.reason or""),by=tostring(w.by or""),ts=tonumber(w.ts)or H.now()})
  while#list>50 do tremove(list,1)end
  S.warns[ln]=list if S.warns[u]and u~=ln then S.warns[u]=nil end S.isDirty=true end
--- [F.clearWarnState] Xóa một hoặc toàn bộ cảnh báo của người dùng `u`
function F.clearWarnState(u,warnId,warnIdx)if not u then return end
  local ln=tostring(u):lower()
  if warnId or warnIdx then
    local list=F.getWarns(u)
    if warnId then
      for i=#list,1,-1 do if tostring(list[i].id)==tostring(warnId)then tremove(list,i)end end
    elseif tonumber(warnIdx)and list[tonumber(warnIdx)]then
      tremove(list,tonumber(warnIdx))
    end
    S.warns[ln]=#list>0 and list or nil
    S.isDirty=true
    return
  end
  for k in pairs(S.warns)do if tostring(k):lower()==ln then S.warns[k]=nil end end S.isDirty=true end
--- [F.getBan] Lấy thông tin lệnh Ban của người dùng `u` nếu đang bị Ban
function F.getBan(u)if not u or u==""then return nil end
  local ln=tostring(u):lower()
  if ln==P.username:lower()and type(S.banned)=="table"then return S.banned end
  local b=S.bannedMap and(S.bannedMap[ln]or S.bannedMap[u])
  if type(b)=="table"then
    local exp=tonumber(b.exp)or 0
    if exp>0 and exp<=H.now()then S.bannedMap[ln]=nil;return nil end
    return b
  end
  for _,bn in ipairs(S.bannedList or{})do if tostring(bn.u or""):lower()==ln then return bn end end
  return nil end
--- [F.recordPunish] Lưu một bản ghi thông báo xử phạt hoặc gỡ phạt (Warn/ClearWarn/Mute/Unmute/Ban/Unban/Revoke) vào kênh #punish
function F.recordPunish(entry)if type(entry)~="table"then return nil end
  local id=tostring(entry.id or entry.packetId or("pn-"..tostring(entry.ts or H.now()).."-"..tostring(entry.action or entry.type or"warn").."-"..tostring(entry.target or"?"):lower()))
  for _,x in ipairs(S.punishments)do if tostring(x.id)==id then return x end end
  local item={
    id=id,
    action=tostring(entry.action or entry.type or"warn"),
    target=tostring(entry.target or entry.u or"?"),
    by=tostring(entry.by or"?"),
    reason=tostring(entry.reason or""),
    exp=tonumber(entry.expires_at or entry.exp)or 0,
    ts=tonumber(entry.ts)or H.now(),
  }
  tinsert(S.punishments,item)
  tsort(S.punishments,function(a,b)return(tonumber(a.ts)or 0)<(tonumber(b.ts)or 0)end)
  while#S.punishments>250 do tremove(S.punishments,1)end
  S.isDirty=true
  return item end
--- [F.getUserPunishments] Lấy danh sách lịch sử xử phạt & gỡ phạt của người dùng `u` từ kênh #punish
function F.getUserPunishments(u)if not u or u==""then return{}end
  local ln=tostring(u):lower()local out={}
  for i=#(S.punishments or{}),1,-1 do local p=S.punishments[i]
    if p and tostring(p.target or""):lower()==ln then out[#out+1]=p end
  end
  return out end
--- [F.refreshTypingLabel] Cập nhật nhãn hiển thị danh sách người chơi khác đang nhập tin nhắn (`U.typing`)
function F.refreshTypingLabel()
  if not U.typing then return end
  local now=os.clock()local names={}
  for u,t in pairs(S.typing[S.chan]or{})do
    if u~=P.username and now-t<CFG.TYPING_TIMEOUT then names[#names+1]=u else S.typing[S.chan][u]=nil end
  end
  tsort(names)
  U.typing.Text=#names>0 and(F.disp(tconcat(names,", ",1,min(#names,3)))..T("typing").."…")or""
end
--- [F.msgSeenUsers] Lấy danh sách người dùng khác đã xem tin nhắn `id` (loại trừ tác giả `author`)
function F.msgSeenUsers(id,author)
  local map=id and S.seenBy and S.seenBy[tostring(id)]
  if type(map)~="table"then return{}end
  local out={}local seenLower={}
  local authLow=tostring(author or""):lower()
  for u,ts in pairs(map)do
    local ul=tostring(u or""):lower()
    if ts and ul~=""and ul~=authLow and not seenLower[ul]then
      seenLower[ul]=true
      out[#out+1]=tostring(u)
    end
  end
  tsort(out,function(a,b)return(tonumber(map[a])or 0)<(tonumber(map[b])or 0)end)
  return out end
--- [F.formatMsgStatus] Định dạng chuỗi trạng thái tin nhắn siêu gọn của bản thân (Đang gửi / Đã gửi / Đã xem) mà không mất thông tin
function F.formatMsgStatus(m)
  if not m then return"","muted"end
  if m.failed then return"! "..T("failed"),"danger"end
  if m.sending then return"⏳","warn"end
  local viewers=F.msgSeenUsers(m.packetId,m.author)
  if #viewers>0 then
    local ch=tostring(m.chan or"")
    if ch:sub(1,3)=="dm:"and not F.isGroupChan(ch)then
      return"✓✓","ok"
    end
    local shown={}
    for i=1,min(#viewers,2)do shown[#shown+1]="@"..F.disp(viewers[i])end
    local extra=#viewers>2 and(" +"..(#viewers-2))or""
    return"✓✓ "..tconcat(shown,", ")..extra,"ok"
  end
  return"✓","muted"
end
--- [F.openSeenDetail] Mở hộp thoại xem chi tiết toàn bộ danh sách người đã xem tin nhắn kèm thời gian xem
function F.openSeenDetail(m)
  if not m then return end
  local viewers=F.msgSeenUsers(m.packetId,m.author)
  local map=(m.packetId and S.seenBy and S.seenBy[tostring(m.packetId)])or{}
  local scr=F.popup((L=="en"and"Seen by ("or"Đã xem bởi (")..tostring(#viewers)..")",280,290)
  if #viewers==0 then
    lab(scr,L=="en"and"No one has seen this message yet."or"Chưa có người nào xem tin nhắn này.",{key="muted",wrap=true,auto=true})
    return
  end
  for i,u in ipairs(viewers)do
    local ts=tonumber(map[u])or 0
    local r=mk("TextButton",{Size=u2(1,0,0,30),Text="",BorderSizePixel=0,LayoutOrder=i,AutoButtonColor=true},scr)
    th(r,"BackgroundColor3","cardBg");corner(r,7);stroke(r,"border",1,0.5)
    local av=mk("ImageLabel",{Size=uo(22,22),Position=uo(5,4),BackgroundTransparency=0.2,Image=F.avatarUrl(F.uidOf(u))},r)
    th(av,"BackgroundColor3","bg3");corner(av,11)
    lab(r,"@"..F.disp(u),{size=u2(1,-108,1,0),pos=uo(32,0),bold=true,ts=11,trunc=true})
    lab(r,ts>0 and H.shortTime(ts)or"✓✓",{size=uo(70,30),pos=u2(1,-74,0,0),ts=10,key="ok",align=txR})
    hook(r.MouseButton1Click,function()F.closeModal();F.openProfile(u)end)
  end
end
--- [F.updateMsgStatus] Cập nhật trực tiếp nhãn trạng thái (Đang gửi / Đã gửi / Đã xem) của tin nhắn `id` trên giao diện
function F.updateMsgStatus(id)
  id=tostring(id or"")
  local lbl=S.statusLabels and S.statusLabels[id]
  local m=S.msgs and S.msgs[id]
  if not lbl or not lbl.Parent or not m then return end
  local txt,colKey=F.formatMsgStatus(m)
  lbl.Text=txt
  lbl.TextColor3=TH[colKey]or TH.muted
end
--- [F.markChannelSeen] Đánh dấu đã xem các tin nhắn trong kênh `chan` và gửi gói tin `seen` (nếu người dùng bật `P.showSeen`)
function F.markChannelSeen(chan)
  chan=tostring(chan or S.chan or"general")
  if not P.showSeen or not U.main or not U.main.Visible then return end
  if chan=="scripts"or chan=="punish"then return end
  if chan=="staff"and not F.isStaff(P.username)then return end
  local meLow=P.username:lower()
  local unseen={}
  for i=#S.order,1,-1 do
    local id=S.order[i]
    local m=S.msgs[id]
    if m and not m.deleted and not m.cleared and F.visibleIn(m,chan)then
      if tostring(m.author or""):lower()~=meLow then
        local map=S.seenBy[id]
        local already=(S.mySentSeen and S.mySentSeen[id])or(type(map)=="table"and(map[P.username]~=nil or map[meLow]~=nil))
        if not already then
          unseen[#unseen+1]=id
          if #unseen>=15 then break end
        end
      end
    end
  end
  if #unseen==0 then return end
  local now=H.now()
  for _,id in ipairs(unseen)do
    S.mySentSeen[id]=true
    S.seenBy[id]=type(S.seenBy[id])=="table"and S.seenBy[id]or{}
    S.seenBy[id][P.username]=now
    F.updateMsgStatus(id)
  end
  S.isDirty=true
  F.publish({type="seen",by=P.username,author=P.username,ids=unseen,target=unseen[1],chan=chan,ts=now},"fast")
end
--- [F.disp] Chuyển đổi văn bản sang chuỗi hiển thị an toàn (áp dụng `H.safeText` nếu bật chế độ sửa lỗi Emoji)
function F.disp(t)t=tostring(t or"");return P.safeEmoji and H.safeText(t)or t end

-- =============================================================================
-- 14. QUẢN LÝ NGƯỜI DÙNG TRỰC TUYẾN, KÊNH CHAT RIÊNG (DM) & NHẮC TÊN (@MENTION)
-- =============================================================================
--- [F.avatarUrl] Tạo đường dẫn ảnh đại diện (Avatar HeadShot 60x60) trên Roblox từ `UserId`
function F.avatarUrl(uid)return"rbxthumb://type=AvatarHeadShot&id="..tostring(uid or 1).."&w=60&h=60"end
--- [F.thumbUrl] Tạo đường dẫn rbxthumb hiển thị trực tiếp được cả Decal ID lẫn Image ID từ Roblox Store
function F.thumbUrl(id,w,h)
  id=H.assetId(id)
  if not id then return""end
  return string.format("rbxthumb://type=Asset&id=%s&w=%d&h=%d",id,w or 420,h or 420)
end
--- [F.uidOf] Tìm `UserId` của người chơi theo tên từ danh sách trực tuyến hoặc bộ nhớ đệm `S.uidCache`
function F.rememberProfile(u,data,isOnline)
  local name=H.trim(tostring(u or(type(data)=="table"and(data.u or data.author))or""))
  if name==""or name=="?"then return nil end
  local key=name:lower()
  S.profiles=S.profiles or{}S.uidCache=S.uidCache or{}
  local p=S.profiles[key]or{u=name,display=name,userId=1,status="",bio="",country="??",inGame=false,placeId=0,gameName="",jobId="",profBanner="",profIcon="",profTheme={},lastSeen=0,msgCount=0}
  if type(data)=="table"then
    if data.u and tostring(data.u)~=""and tostring(data.u)~="?"then p.u=tostring(data.u)end
    local allowClear=data._allowClear==true or isOnline==true
    local d=data.display~=nil and data.display or data.d
    if d~=nil and tostring(d)~=""and tostring(d)~="?"then p.display=tostring(d)end
    local uid=tonumber(data.userId or data.id or data.uid)
    if uid and uid>1 then p.userId=uid elseif uid and uid>0 and(not p.userId or p.userId<=1)then p.userId=uid end
    local mc=tonumber(data.mc or data.msgCount)
    if mc and mc>(tonumber(p.msgCount)or 0)then p.msgCount=mc end
    if key==P.username:lower()and(P.msgCount or 0)>(tonumber(p.msgCount)or 0)then p.msgCount=P.msgCount end
    local st=data.status~=nil and data.status or data.st
    if st~=nil and(allowClear or tostring(st)~="")then p.status=tostring(st)end
    if data.bio~=nil and(allowClear or tostring(data.bio)~="")then p.bio=tostring(data.bio)end
    local c=data.country~=nil and data.country or data.c
    if c~=nil then
      local rc=H.resolveCountry(c)
      if rc~=""and(rc~="??"or p.country==""or p.country=="??")then p.country=rc end
    end
    local pb=data.profBanner~=nil and data.profBanner or data.pb
    if pb~=nil and(allowClear or tostring(pb)~="")then p.profBanner=H.assetId(pb)or""end
    local pi=data.profIcon~=nil and data.profIcon or data.pi
    if pi~=nil and(allowClear or tostring(pi)~="")then p.profIcon=H.assetId(pi)or""end
    local pt=data.profTheme~=nil and data.profTheme or data.pt
    if type(pt)=="table"and(allowClear or next(pt)~=nil)then p.profTheme=pt end
    local ls=tonumber(data.lastSeen or data.ts)or 0
    if ls>(tonumber(p.lastSeen)or 0)then p.lastSeen=ls end
    local pl=tonumber(data.placeId or data.pl)
    if pl and pl>0 then p.placeId=pl end
    local gn=data.gameName~=nil and data.gameName or data.gn
    if gn~=nil and tostring(gn)~=""then p.gameName=tostring(gn)end
    if isOnline then
      p.inGame=(data.inGame==true or data.sg==true)
      if data.sg==false or data.inGame==false then p.placeId=0;p.gameName="";p.jobId=""end
      local jb=data.jobId~=nil and data.jobId or data.jb
      if jb~=nil then p.jobId=tostring(jb)end
      p.lastSeen=math.max(tonumber(p.lastSeen)or 0,H.now())
    elseif isOnline==false then
      p.inGame=false;p.jobId=""
    end
  end
  if p.userId and tonumber(p.userId)>1 then
    S.uidCache[name]=p.userId;S.uidCache[key]=p.userId
    if p.u then S.uidCache[p.u]=p.userId end
  end
  S.profiles[key]=p
  return p
end
function F.uidOf(name,hint)
  if not name then return tonumber(hint)or 1 end
  local ln=tostring(name):lower()
  if ln==P.username:lower()then return P.userId end
  local r=F.userRec(name)
  if r and tonumber(r.userId)and tonumber(r.userId)>1 then return tonumber(r.userId)end
  if tonumber(hint)and tonumber(hint)>1 then return tonumber(hint)end
  if S.uidCache then
    local cu=tonumber(S.uidCache[name])or tonumber(S.uidCache[ln])
    if cu and cu>1 then return cu end
  end
  local pr=S.profiles and S.profiles[ln]
  if pr and tonumber(pr.userId)and tonumber(pr.userId)>1 then return tonumber(pr.userId)end
  for _,sc in ipairs(S.scripts or{})do
    if tostring(sc.author or""):lower()==ln and tonumber(sc.uid)and tonumber(sc.uid)>1 then return tonumber(sc.uid)end
  end
  for _,m in pairs(S.msgs or{})do
    if type(m)=="table"and tostring(m.author or""):lower()==ln and tonumber(m.uid)and tonumber(m.uid)>1 then return tonumber(m.uid)end
  end
  return(r and tonumber(r.userId))or tonumber(hint)or 1
end
--- [F.isLive] Kiểm tra bản ghi người dùng còn trực tuyến hay không (dựa theo `PRESENCE_TIMEOUT`)
function F.isLive(rec)if not rec or not rec.recvAt then return false end return(rec.age or 0)+(os.clock()-rec.recvAt)<=CFG.PRESENCE_TIMEOUT end
--- [F.userRec] Tìm bản ghi thông tin trực tuyến của người dùng trong `S.users` (không phân biệt hoa thường)
function F.userRec(name)if not name then return nil end if S.users[name]then return S.users[name]end
  local ln=tostring(name):lower()for u,r in pairs(S.users)do if tostring(u):lower()==ln then return r end end
  return S.profiles and S.profiles[ln]or nil end
function F.fetchUserProfile(u,cb,force)
  local target=H.trim(tostring(u or"")):gsub("^@","")
  if target==""or target:lower()==P.username:lower()then if cb then pcall(cb,F.userRec(target))end return end
  local key=target:lower()
  S.profFetchedAt=S.profFetchedAt or{}
  if not force and(S.profFetchedAt[key]or 0)+10>os.clock()and F.uidOf(target)>1 then
    if cb then pcall(cb,F.userRec(target))end return
  end
  S.profFetchedAt[key]=os.clock()
  task.spawn(function()
    local data=type(F.rawRequest)=="function"and F.rawRequest("GET","/api/profile?u="..H.url(target))or nil
    if type(data)=="table"and data.ok and type(data.profile)=="table"then
      local p=data.profile
      local isOn=(data.online==true or p.online==true)
      local canon=tostring(p.u or target)
      p._allowClear=true
      local stored=F.rememberProfile(canon,p,isOn)
      if isOn and stored then
        local cur=S.users[canon]or{}
        for k,v in pairs(stored)do cur[k]=v end
        cur.age=0;cur.recvAt=os.clock();cur.isScript=true
        S.users[canon]=cur
      end
    end
    if F.uidOf(target)<=1 then
      local ok,id=pcall(Players.GetUserIdFromNameAsync,Players,target)
      if ok and tonumber(id)and tonumber(id)>1 then
        F.rememberProfile(target,{userId=tonumber(id)},false)
      end
    end
    if cb then pcall(cb,F.userRec(target))end
  end)
end
--- [F.isScriptUser] Kiểm tra một người chơi có đang sử dụng Chat Bridge và còn trực tuyến hay không
function F.isScriptUser(name)if not name or name==""then return false end if tostring(name):lower()==P.username:lower()then return true end
  local rec=F.userRec(name)
  if not rec or not rec.isScript then return false end return F.isLive(rec)end
--- [F.touchUser] Cập nhật hoặc khởi tạo bản ghi hoạt động mới nhất cho người dùng `name` trong `S.users`
function F.touchUser(name,uid,display)if not name or name==""or name==P.username then return end
  F.rememberProfile(name,{userId=uid,display=display,lastSeen=H.now()},false)
  local rec=S.users[name]
  if not rec then
    local ln=tostring(name):lower()
    for u,r in pairs(S.users)do if tostring(u):lower()==ln then rec=r;break end end
  end
  local base=S.profiles and S.profiles[tostring(name):lower()]
  if not rec then
    rec={display=(base and base.display)or display or name,userId=(base and base.userId)or tonumber(uid)or 1,status=(base and base.status)or"",bio=(base and base.bio)or"",country=(base and base.country)or"??",inGame=false,placeId=(base and base.placeId)or 0,gameName=(base and base.gameName)or"",jobId="",profBanner=(base and base.profBanner)or"",profIcon=(base and base.profIcon)or"",profTheme=(base and base.profTheme)or{}}
    S.users[name]=rec
  else
    if tonumber(uid)and tonumber(uid)>1 then rec.userId=tonumber(uid)end
    if display and display~=""and display~="?"then rec.display=display end
  end
  rec.isScript=true rec.age,rec.recvAt=0,os.clock()end
--- [F.dmChan] Tạo tên định danh kênh chat riêng chuẩn hóa (`dm:userA|userB` theo thứ tự bảng chữ cái)
function F.dmChan(a,b)if a:lower()>b:lower()then a,b=b,a end return"dm:"..a.."|"..b end
--- [F.isGroupChan] Kiểm tra chuỗi định danh kênh có phải là Group Chat trong DM hay không (`dm:grp_...`)
function F.isGroupChan(chan)return tostring(chan or""):match("^dm:grp_")~=nil end
--- [F.groupByChan] Tìm thông tin đối tượng Group Chat từ chuỗi kênh `chan` hoặc mã `id`
function F.groupByChan(chan)
  chan=tostring(chan or"")
  local gid=chan:match("^dm:(grp_[%w_%-]+)")or chan:match("^(grp_[%w_%-]+)")
  for _,g in ipairs(S.groups or{})do
    if tostring(g.chan)==chan or(gid and tostring(g.id)==gid)then return g end
  end
  if chan:match("^dm:grp_")then
    local parts={}
    for seg in chan:sub(4):gmatch("[^|]+")do parts[#parts+1]=seg end
    local id=parts[1]or"grp"
    local mems={}for i=2,#parts do mems[#mems+1]=parts[i]end
    return{id=id,name="Group ("..#mems..")",owner=mems[1]or"?",members=mems,chan=chan}
  end
  return nil
end
--- [F.dmOther] Lấy tên người đối thoại hoặc tên Group Chat từ chuỗi định danh kênh `dm:...`
function F.dmOther(chan)
  chan=tostring(chan or"")
  if F.isGroupChan(chan)then
    local g=F.groupByChan(chan)
    if not g then return nil end
    local meLow=P.username:lower()
    for _,m in ipairs(g.members or{})do
      if tostring(m):lower()==meLow then return"👥 "..F.locText(g.name or"Group")end
    end
    if F.isStaff(P.username)then return"👥 "..F.locText(g.name or"Group")end
    return nil
  end
  local a,b=chan:match("^dm:(.-)|(.+)$")if not a then return nil end
  if a:lower()==P.username:lower()then return b end if b:lower()==P.username:lower()then return a end return nil end
--- [F.dmUnreadTotal] Tính tổng số tin nhắn riêng (DM) chưa đọc từ tất cả các cuộc trò chuyện
function F.dmUnreadTotal()local n=0;for _,v in pairs(S.dmUnread)do n=n+v end return n end
--- [F.visibleIn] Kiểm tra một tin nhắn `m` có thuộc về kênh `chan` đang mở hay không (kênh `#game` chỉ hiện tin của đúng game `PlaceId` và phiên đó)
function F.visibleIn(m,chan)if not m or m.deleted or m.cleared then return false end
  if m.chan~=chan then return false end
  if chan~="announce"and chan~="punish"and m.author and type(P.blockedUsers)=="table"and P.blockedUsers[tostring(m.author):lower()]==true and tostring(m.author):lower()~=P.username:lower()then return false end
  if chan=="game"then
    if tonumber(m.place)~=game.PlaceId then return false end
    if m.job and tostring(m.job)~=""and tostring(game.JobId or"")~=""and tostring(m.job)~=tostring(game.JobId)then return false end
  end
  return true end
--- [F.mentions] Kiểm tra nội dung văn bản `c` có nhắc tên (`@username`, `@everyone`, `@here`) người chơi hiện tại hay không
function F.mentions(content)local c=tostring(content or""):lower()
  if c:find("@everyone",1,true)or c:find("@here",1,true)then return true end
  local me=P.username:lower()local i=c:find("@"..me,1,true)while i do local nxt=c:sub(i+#me+1,i+#me+1)
    if not nxt:match("[%w_]")then return true end i=c:find("@"..me,i+1,true)end return false end

-- =============================================================================
-- 15. BỘ NHỚ ĐỆM EMOJI, PHÂN TÁCH ẢNH INLINE & CỬA SỔ QUẢN LÝ KHO EMOJI
-- =============================================================================
--- [F.cleanEmojiName] Chuẩn hóa tên gọi của Emoji tùy chỉnh (loại bỏ ký tự đặc biệt, giới hạn 24 ký tự)
function F.cleanEmojiName(s)s=H.trim(tostring(s or"")):gsub("^:+",""):gsub(":+$",""):gsub("[^%w_%-]","_"):sub(1,22)
  return s~=""and s or"emoji"end
--- [F.rebuildEmojiCache] Xây dựng lại bảng tra cứu nhanh Emoji theo ID (`S._emoById`) và theo tên (`S._emoByName`)
function F.rebuildEmojiCache()
  local byId,byName={},{}
  for _,cid in ipairs(P.customEmojis or{})do
    local sId=tostring(cid)local nm=P.customEmojiNames and P.customEmojiNames[sId]or("emo_"..sId:sub(-4))
    byId[sId]={id=sId,name=nm,by=P.username}
    byName[nm:lower()]={id=sId,name=nm}
    byName[("emo_"..sId:sub(-4)):lower()]={id=sId,name=nm}
    byName[("emoji_"..sId:sub(-4)):lower()]={id=sId,name=nm}
    byName[sId]={id=sId,name=nm}
  end
  for id,nm in pairs(P.customEmojiNames or{})do
    local sId=tostring(id)local sNm=tostring(nm)
    byId[sId]=byId[sId]or{id=sId,name=sNm,by=P.username}
    byName[sNm:lower()]={id=sId,name=sNm}
  end
  for _,e in ipairs(S.sharedEmojis or{})do
    local sId=tostring(e.id or"")local sNm=tostring(e.name or"")
    if sId~=""then byId[sId]=e end
    if sNm~=""then byName[sNm:lower()]={id=sId,name=sNm}end
  end
  S._emoById,S._emoByName,S._emoCacheSeq,S._emoCacheN=byId,byName,S.emojiSeq,#(P.customEmojis or{})
end
--- [F.ensureEmojiCache] Đảm bảo bộ nhớ đệm Emoji luôn đồng bộ với danh sách Emoji cá nhân và Emoji chia sẻ
function F.ensureEmojiCache()
  if not S._emoById or S._emoCacheSeq~=S.emojiSeq or S._emoCacheN~=#(P.customEmojis or{})then F.rebuildEmojiCache()end
end
--- [F.emojiInfoById] Tra cứu thông tin chi tiết của một Emoji ảnh theo Asset ID
function F.emojiInfoById(id)id=tostring(id or"")F.ensureEmojiCache()return S._emoById[id]end
--- [F.emojiIdByName] Tra cứu Asset ID của Emoji ảnh theo tên shortcode
function F.emojiIdByName(name)local ln=F.cleanEmojiName(name):lower()if ln==""then return nil end
  F.ensureEmojiCache()local hit=S._emoByName[ln]if hit then return hit.id,hit.name end return nil end
--- [F.expandShortcodes] Chuyển đổi tất cả các cụm `:ten_emoji:` trong văn bản sang thẻ ảnh `[img:id]` hoặc Emoji Unicode
function F.expandShortcodes(text)text=tostring(text or"")
  text=text:gsub("<:([%w_%-]+):(%d+)>",function(_,id)if#id>=5 and#id<=15 then return"[img:"..id.."]"end return _ end)text=text:gsub(":([%w_%-]+):",function(nm)local id=F.emojiIdByName(nm)
    if id then return"[img:"..id.."]"end
    local uni=CFG.SHORTCODES and CFG.SHORTCODES[nm:lower()]if uni then return uni end return":"..nm..":"end)return text end
--- [F.parseImgs] Tách riêng phần văn bản và danh sách các Asset ID ảnh từ chuỗi có chứa thẻ `[img:id]`
function F.parseImgs(content)local ids={}
  local expanded=F.expandShortcodes(content)local text=tostring(expanded or""):gsub("%[img:(%d+)%]",function(id)if#ids<8 and#id>=5 and#id<=15 then ids[#ids+1]=id end return""end)text=H.trim(text:gsub("%s%s+"," "))
  return text,ids end
--- [F.parseInlineSegments] Phân tách nội dung tin nhắn thành chuỗi các đoạn văn bản (`text`) và biểu tượng ảnh (`img`) xen kẽ nhau
function F.parseInlineSegments(content)local expanded=F.expandShortcodes(content)local segs,imgCount,hasText={},0,false local pos=1 while pos<=#expanded do
    local s,e,id=expanded:find("%[img:(%d+)%]",pos)if s then if s>pos then local txt=expanded:sub(pos,s-1)if H.trim(txt)~=""then hasText=true end segs[#segs+1]={kind="text",text=txt}end
      if#id>=5 and#id<=15 and imgCount<10 then imgCount=imgCount+1 segs[#segs+1]={kind="img",id=id}end pos=e+1 else local txt=expanded:sub(pos)if H.trim(txt)~=""then hasText=true end
      if txt~=""then segs[#segs+1]={kind="text",text=txt}end break end end return segs,imgCount,hasText end
--- [F.plain] Chuyển đổi nội dung tin nhắn (có chứa thẻ `[img:id]`) về dạng văn bản thuần để hiển thị trong bản xem trước / trả lời
function F.plain(content)local expanded=F.expandShortcodes(content)
  return(tostring(expanded or""):gsub("%[img:(%d+)%]",function(id)local info=F.emojiInfoById(id)return info and(":"..info.name..":")or T("img_tag")end))end
--- [F.link] Liên kết tin nhắn mới với tin nhắn liền trước trong cùng kênh để quyết định gộp nhóm hiển thị (`m.grp`)
function F.link(m)local prev=S.lastByChan[m.chan]
  m.grp=prev~=nil and prev.author==m.author and not prev.deleted and not m.replyTo and math.abs((tonumber(m.ts)or 0)-(tonumber(prev.ts)or 0))<=CFG.GROUP_SECS m.prevId=prev and prev.packetId or nil
  if prev then prev.nextG=m end
  S.lastByChan[m.chan]=m end
--- [F.onDeleted] Cập nhật lại liên kết gộp nhóm (`prevG` / `nextG`) khi một tin nhắn bị xóa
function F.onDeleted(m)local n=m.nextG if n and n.grp and not m.grp then n.grp=false if S.frames[n.packetId]then F.dropFrame(n.packetId);F.renderMessage(n)end end
end
--- [F.roleChip] Tạo huy hiệu (Badge/Chip) hiển thị tên, màu sắc và biểu tượng của một Role
function F.roleChip(parent,r,order,big)if not r then return nil end
  local col=H.hex(r.color)local h=big and 22 or 18 local ts=big and 12 or 10 local nameStr=F.disp(r.name or"Role")
  local hasIcon=r.icon~=nil and tostring(r.icon)~=""local icSz=hasIcon and(h-4)or 0 local txtW=clamp(H.textW(nameStr,ts,fGB),12,big and 140 or 100)local padL=hasIcon and 5 or 7 local gap=hasIcon and 4 or 0 local padR=7
  local chipW=padL+icSz+gap+txtW+padR local f=mk("Frame",{Size=uo(chipW,h),BackgroundColor3=col,BackgroundTransparency=0.82,BorderSizePixel=0,LayoutOrder=order or 0,ZIndex=5,ClipsDescendants=true,},parent)
  corner(f,floor(h/2))local st=mk("UIStroke",{Color=col,Thickness=1,Transparency=0.32,ApplyStrokeMode=smBorder},f)st.ZIndex=5 if hasIcon then local ic=F.iconBox(f,r.icon,icSz)ic.Position=uo(padL,floor((h-icSz)/2))
    ic.ZIndex=6 end mk("TextLabel",{Size=uo(txtW+2,h),Position=uo(padL+icSz+gap,0),BackgroundTransparency=1,Text=nameStr,TextColor3=col,Font=fGB,TextSize=ts,TextXAlignment=txL,
    TextYAlignment=Enum.TextYAlignment.Center,TextTruncate=trEnd,BorderSizePixel=0,ZIndex=6,},f)return f end
--- [F.pushRecentEmoji] Đưa một Emoji vừa sử dụng lên đầu danh sách Emoji dùng gần đây (`P.recentEmoji`)
function F.pushRecentEmoji(e)
  for i=#P.recentEmoji,1,-1 do if P.recentEmoji[i]==e then tremove(P.recentEmoji,i)end end tinsert(P.recentEmoji,1,e)while#P.recentEmoji>18 do tremove(P.recentEmoji)end
  S.isDirty=true end
--- [F.quickEmoji] Lấy danh sách 4 Emoji gợi ý nhanh để gắn vào thanh thao tác nhanh trên tin nhắn
function F.quickEmoji()
  local out,seen={},{}
  local function add(e)if e and not seen[e]and#out<4 then seen[e]=true;out[#out+1]=e end end for _,e in ipairs(P.recentEmoji)do add(e)end for _,e in ipairs(S.sharedEmojis or{})do
    if e.id then add("img:"..tostring(e.id))end end for _,e in ipairs({"👍","😂","🔥","💀"})do add(e)end return out end
--- [F.deleteSharedEmojis] Gửi yêu cầu xóa một hoặc nhiều Emoji chia sẻ chung lên endpoint `/api/emoji`
function F.deleteSharedEmojis(ids,onDone)if type(ids)~="table"or#ids==0 then return end
  enqueue("other","POST","/api/emoji",{by=P.username,ids=ids,id=ids[1],action=#ids>1 and"remove_multi"or"remove",},function(d,err)if d and d.ok then S.sharedEmojis=d.emojis or S.sharedEmojis
      S.emojiSeq=tonumber(d.emojiSeq)or S.emojiSeq S.isDirty=true F.toast(T("emoji_removed").." ("..tostring(d.removed or#ids)..")",true)if onDone then onDone(true)end else F.netError((d and d.error)or err)
      if onDone then onDone(false)end end end)end
--- [F.openEmojiPreview] Mở hộp thoại xem chi tiết một Emoji ảnh (cho phép sao chép mã `:name:`, lưu về máy hoặc xóa)
function F.openEmojiPreview(id,msgOrTopic,isScript)local info=F.emojiInfoById(id)or{id=id,name="emoji_"..tostring(id):sub(-4),by="?"}
  local scr,close=F.popup(":"..info.name..":",280,250)local topRow=mk("Frame",{Size=u2(1,0,0,76),BackgroundTransparency=1},scr)local ic=F.iconBox(topRow,"img:"..id,64)ic.Position=uo(8,6)
  lab(topRow,":"..F.disp(info.name)..":",{size=u2(1,-84,0,22),pos=uo(80,10),bold=true,ts=15,key="emojiText",trunc=true})lab(topRow,"ID: "..tostring(id),{size=u2(1,-84,0,16),pos=uo(80,32),ts=11,key="muted",trunc=true})
  lab(topRow,"By: @"..F.disp(info.by or"?"),{size=u2(1,-84,0,16),pos=uo(80,48),ts=11,key="muted",trunc=true})local r1=row(scr,30)local bChat=rbtn(r1,T("emoji_insert_chat"),{key="accent",ts=11})
  hook(bChat.MouseButton1Click,function()if type(close)=="function"then close()else F.closeModal()end U.input.Text=U.input.Text..(U.input.Text~=""and not U.input.Text:match("%s$")and" "or"")..":"..info.name..": "
    F.updateSuggest()U.input:CaptureFocus()end)local bReact=rbtn(r1,T("emoji_react_btn"),{ts=11})hook(bReact.MouseButton1Click,function()if type(close)=="function"then close()else F.closeModal()end
    if isScript and msgOrTopic then F.doScriptReact(msgOrTopic,"img:"..id)elseif msgOrTopic then F.doReact(msgOrTopic,"img:"..id)else local lastId=S.order[#S.order]
      if lastId and S.msgs[lastId]then F.doReact(S.msgs[lastId],"img:"..id)end end end)local r2=row(scr,28)local bCopy=rbtn(r2,T("emoji_copy_name"),{ts=11})hook(bCopy.MouseButton1Click,function()
    F.copyText(":"..info.name..":")if type(close)=="function"then close()else F.closeModal()end end)local bSave=rbtn(r2,T("emoji_save_loc"),{ts=11})hook(bSave.MouseButton1Click,function()P.customEmojiNames[id]=info.name;S._emoById=nil
    local exists=false for _,x in ipairs(P.customEmojis)do if x==id then exists=true;break end end if not exists and#P.customEmojis<48 then tinsert(P.customEmojis,id)end
    S.isDirty=true F.toast(T("saved_ok"),true)
    if type(close)=="function"then close()else F.closeModal()end end)if F.isStaff(P.username)or tostring(info.by or""):lower()==P.username:lower()then local bDel=tbtn(scr,T("emoji_del_srv"),{key="danger",h=28,ts=11})
    hook(bDel.MouseButton1Click,function()F.deleteSharedEmojis({tostring(id)},function(ok)if ok then if type(close)=="function"then close()else F.closeModal()end end end)end)end end
--- [F.openEmoji] Mở bảng chọn và quản lý Emoji (Unicode, Gần đây, Emoji chia sẻ chung, và Emoji lưu cục bộ)
function F.openEmoji(opt)opt=opt or{}
  local scr,close=F.popup(opt.title or T("emoji_pick"),390,520)local searchBar=mk("TextBox",{Size=u2(1,0,0,30),Text="",PlaceholderText=T("emoji_search_ph"),ClearTextOnFocus=false,Font=fG,TextSize=12,
    BorderSizePixel=0,TextXAlignment=txL,LayoutOrder=1,},scr)F.styleInput(searchBar,"text",false)
  local tabsRow=row(scr,28);tabsRow.LayoutOrder=2 local body=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BackgroundTransparency=1,LayoutOrder=5},scr)list(body,6)local cur,delMode=opt.tab or P.emojiTab or"recent",false
  local multiMode=false local selectedIds={} local renderSeq,searchSeq=0,0
  local function pick(e)F.pushRecentEmoji(e)if not opt.keepOpen then if type(close)=="function"then pcall(close)else F.closeModal()end end
    if opt.onPick then pcall(opt.onPick,e)end end
  local show
  local function gridUnicode(parent,items,seq)
    local g=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BackgroundTransparency=1},parent)
    mk("UIGridLayout",{CellSize=uo(42,38),CellPadding=uo(4,4),SortOrder=soLO},g)
    local btnBg,btnBdr,btnFg=TH.btnBg,TH.btnBorder,H.ensureContrast(TH.text,TH.btnBg,4.8)
    local function addUni(i,e)
      local b=mk("TextButton",{Text=P.safeEmoji and H.safeEmoji(e)or e,Font=Enum.Font.SourceSansBold,TextSize=22,TextColor3=btnFg,BackgroundColor3=btnBg,BorderSizePixel=0,LayoutOrder=i,AutoButtonColor=true,Active=true},g)
      corner(b,8);mk("UIStroke",{Color=btnBdr,Thickness=1,Transparency=0.35,ApplyStrokeMode=smBorder},b)
      hook(b.MouseButton1Click,function()pick(e)end)
    end
    local syncN=min(#items,40)
    for i=1,syncN do addUni(i,items[i])end
    if#items>syncN then
      task.spawn(function()
        local idx=syncN+1
        while idx<=#items and seq==renderSeq and g.Parent do
          local stopAt=min(#items,idx+27)
          for i=idx,stopAt do addUni(i,items[i])end
          idx=stopAt+1
          if idx<=#items then pcall(function()RunService.Heartbeat:Wait()end)end
        end
      end)
    end
  end
  local function gridNamedImages(parent,entries,isServerShared,seq,showDelete)
    local g=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BackgroundTransparency=1,LayoutOrder=10},parent)mk("UIGridLayout",{CellSize=uo(68,64),CellPadding=uo(5,5),SortOrder=soLO},g)local staff=F.isStaff(P.username)
    local function addImg(i,entry)
      local id=tostring(entry.id)local nm=F.cleanEmojiName(entry.name or P.customEmojiNames[id]or("id_"..id:sub(-4)))local by=tostring(entry.by or P.username)
      local canDel=(showDelete~=false)and((not isServerShared)or staff or(by:lower()==P.username:lower()))local isSel=selectedIds[id]==true
      local b=mk("TextButton",{Text="",BorderSizePixel=0,LayoutOrder=i,ClipsDescendants=true,AutoButtonColor=true,Active=true,BackgroundColor3=isSel and TH.danger or TH.btnBg},g)corner(b,8)
      mk("UIStroke",{Color=isSel and TH.danger or TH.accent,Thickness=isSel and 2 or 1,Transparency=isSel and 0.1 or 0.75,ApplyStrokeMode=smBorder},b)local ic=F.iconBox(b,"img:"..id,34,{themed=false})ic.Position=u2(0.5,-17,0,5)
      local nmLbl=mk("TextLabel",{Size=u2(1,-6,0,16),Position=uo(3,42),BackgroundTransparency=1,Text=":"..nm..":",Font=fGB,TextSize=10,TextColor3=isSel and c3(1,1,1)or TH.emojiText,TextXAlignment=txC,TextTruncate=ttEnd,BorderSizePixel=0},b)
      if nmLbl.TextColor3 and isSel then nmLbl.TextColor3=H.lum(TH.danger)>0.55 and rgb(20,20,24)or c3(1,1,1)end
      if canDel and not multiMode then local xBtn=mk("TextButton",{Size=uo(18,18),
          Position=u2(1,-20,0,2),BackgroundColor3=TH.danger,BackgroundTransparency=0.15,Text="X",TextColor3=c3(1,1,1),Font=fGB,TextSize=10,BorderSizePixel=0,ZIndex=6,},b)corner(xBtn,9)
        hook(xBtn.MouseButton1Click,function()if isServerShared then F.deleteSharedEmojis({id},function(ok)if ok and body.Parent then show(cur)end end)else
            for k=#P.customEmojis,1,-1 do if P.customEmojis[k]==id then tremove(P.customEmojis,k)end end
            P.customEmojiNames[id]=nil;S._emoById=nil S.isDirty=true show(cur)end end)end
      if multiMode and isServerShared and staff then
        local chk=lab(b,isSel and"[x]"or"[ ]",{size=uo(20,20),pos=uo(3,2),ts=12,bold=true,key=isSel and"text"or"accent",})chk.ZIndex=6 end
      hook(b.MouseButton1Click,function()if isServerShared and multiMode and staff then
          selectedIds[id]=not selectedIds[id]or nil show(cur)return end if delMode and canDel then if isServerShared then F.deleteSharedEmojis({id},function(ok)if ok and body.Parent then show(cur)end end)else
            for k=#P.customEmojis,1,-1 do if P.customEmojis[k]==id then tremove(P.customEmojis,k)end end
            P.customEmojiNames[id]=nil;S._emoById=nil S.isDirty=true show(cur)end return end pick("img:"..id)end)
    end
    local syncN=min(#entries,18)
    for i=1,syncN do addImg(i,entries[i])end
    if#entries>syncN then
      task.spawn(function()
        local idx=syncN+1
        while idx<=#entries and seq==renderSeq and g.Parent do
          local stopAt=min(#entries,idx+15)
          for i=idx,stopAt do addImg(i,entries[i])end
          idx=stopAt+1
          if idx<=#entries then pcall(function()RunService.Heartbeat:Wait()end)end
        end
      end)
    end
  end
  local function buildShareAndLocal(isSharedTab,seq)local q=H.trim(searchBar.Text):lower():gsub("^:+",""):gsub(":+$","")local formCard=F.card(body,0)formCard.AutomaticSize=asY formCard.Size=u2(1,0,0,0)
    formCard.LayoutOrder=1 pad(formCard,8,8,8,8);list(formCard,5)lab(formCard,T("img_hint"),{wrap=true,auto=true,ts=10,key="muted",layout=1})
    local topInputRow=mk("Frame",{Size=u2(1,0,0,36),BackgroundTransparency=1,LayoutOrder=2},formCard)
    local idBox=mk("TextBox",{Size=u2(1,-142,0,32),Position=uo(0,2),
      Text="",PlaceholderText=T("custom"),ClearTextOnFocus=false,Font=fG,TextSize=12,BorderSizePixel=0,TextXAlignment=txL,},topInputRow)
    F.styleInput(idBox,"num",false)
    local storeBtn=tbtn(topInputRow,"Store",{size=uo(96,32),pos=u2(1,-138,0,2),key="accent",ts=10,r=6})
    pad(storeBtn,20,0,6,0)
    local storeIc=F.lucide(storeBtn,"store",12,{pos=u2(0,-11,0.5,0),anc=v2(0,0.5),col=H.lum(TH.accent)>0.55 and rgb(20,20,24)or c3(1,1,1),themed=false,z=5})
    themed(storeIc,function(ic)ic.ImageColor3=H.lum(TH.accent)>0.55 and rgb(20,20,24)or c3(1,1,1)end)
    local pv=mk("Frame",{Size=uo(36,36),Position=u2(1,-38,0,0),BackgroundTransparency=0.1},topInputRow)th(pv,"BackgroundColor3","inputBg");corner(pv,7);stroke(pv,"inputBorder",1,0.2)
    local nameBox=mk("TextBox",{Size=u2(1,0,0,30),
      Text="",PlaceholderText=T("emoji_name_ph"),ClearTextOnFocus=false,Font=fG,TextSize=12,BorderSizePixel=0,TextXAlignment=txL,LayoutOrder=3,},formCard)
    F.styleInput(nameBox,"text",false)local shown=nil
    local function preview()local raw=H.trim(idBox.Text)
      for _,c in ipairs(pv:GetChildren())do if not c:IsA("UICorner")and not c:IsA("UIStroke")then c:Destroy()end end
      local id=H.assetId(raw)if id then shown="img:"..id local ic=F.iconBox(pv,shown,32)ic.Position=uo(2,2)
        if H.trim(nameBox.Text)==""then local known=F.emojiInfoById(id)if known and known.name then nameBox.Text=known.name end end elseif raw~=""and#raw<=16 then shown=raw local ic=F.iconBox(pv,raw,32)ic.Position=uo(2,2)else
        shown=nil end end
    hook(idBox:GetPropertyChangedSignal("Text"),function()S.pvTok=(S.pvTok or 0)+1 local my=S.pvTok task.delay(0.35,function()if S.pvTok==my and pv.Parent then preview()end end)end)
    hook(storeBtn.MouseButton1Click,function()
      F.openImageFinder(L=="en"and"Emoji / Icon Store"or"Kho Emoji / Icon Store","icon",function(pickedId,itemInfo)
        idBox.Text=tostring(pickedId)
        if itemInfo and itemInfo.name then
          local clean=F.cleanEmojiName(itemInfo.name)
          if clean~=""then nameBox.Text=clean end
        end
        preview()
      end)
    end)
    local actRow=row(formCard,30);actRow.LayoutOrder=4 local saveLocB=rbtn(actRow,T("emoji_save_loc"),{size=u2(0.45,-3,1,0),ts=11})local shareSrvB=rbtn(actRow,T("emoji_share_srv"),{size=u2(0.55,-3,1,0),ts=11,key="accent"})
    hook(saveLocB.MouseButton1Click,function()preview()if not shown then F.toast(T("img_bad"),true);return end if shown:sub(1,4)=="img:"then local id=shown:sub(5)
        local nm=F.cleanEmojiName(nameBox.Text~=""and nameBox.Text or("emo_"..id:sub(-4)))P.customEmojiNames[id]=nm;S._emoById=nil local exists=false for _,x in ipairs(P.customEmojis)do if x==id then exists=true;break end end
        if not exists then if#P.customEmojis>=48 then F.toast(T("img_full"),true);return end tinsert(P.customEmojis,id)end
        S.isDirty=true pick(shown)else pick(shown)end end)hook(shareSrvB.MouseButton1Click,function()
      preview()if not shown or shown:sub(1,4)~="img:"then F.toast(T("img_bad"),true);return end
      local id=shown:sub(5)local nm=F.cleanEmojiName(nameBox.Text~=""and nameBox.Text or("emo_"..id:sub(-4)))
      P.customEmojiNames[id]=nm;S._emoById=nil enqueue("other","POST","/api/emoji",{by=P.username,id=id,name=nm,action="add"},function(d,e)if d and d.ok then S.sharedEmojis=d.emojis or S.sharedEmojis
          S.emojiSeq=tonumber(d.emojiSeq)or S.emojiSeq S.isDirty=true F.toast(T("emoji_shared_ok").." (:"..nm..":)",true)if body.Parent then show("shared")end else F.toast("! "..tostring((d and d.error)or e or"fail"),true)end
      end)end)if isSharedTab then local staff=F.isStaff(P.username)if staff then local modBar=row(body,28);modBar.LayoutOrder=2 local mBtn=rbtn(modBar,(multiMode and"[x] "or"[ ] ")..T("emoji_del_multi"),{
          size=u2(multiMode and 0.36 or 0.5,-3,1,0),ts=11,key=multiMode and"warn"or"bg3",})hook(mBtn.MouseButton1Click,function()multiMode=not multiMode if not multiMode then selectedIds={}end show("shared")end)
        if multiMode then local cnt=0 for _ in pairs(selectedIds)do cnt=cnt+1 end
          local selAllB=rbtn(modBar,T("script_sel_all"),{size=u2(0.28,-3,1,0),ts=10})hook(selAllB.MouseButton1Click,function()
            for _,e in ipairs(S.sharedEmojis or{})do local nm=tostring(e.name or""):lower()local id=tostring(e.id or"")if q==""or nm:find(q,1,true)or id:find(q,1,true)then selectedIds[id]=true end end show("shared")end)
          local delSelB=rbtn(modBar,T("emoji_del_sel").." ("..cnt..")",{size=u2(0.36,-3,1,0),ts=10,key="danger",})hook(delSelB.MouseButton1Click,function()local ids={}for id in pairs(selectedIds)do ids[#ids+1]=id end
            if#ids==0 then return end
            F.deleteSharedEmojis(ids,function(ok)if ok then selectedIds={}multiMode=false if body.Parent then show("shared")end end end)end)else
          local sDelB=rbtn(modBar,(delMode and T("emoji_del_on")or T("img_del_mode")),{size=u2(0.5,-3,1,0),ts=11,key=delMode and"danger"or"bg3",})hook(sDelB.MouseButton1Click,function()delMode=not delMode show("shared")
          end)end end
      local filtered={}for _,e in ipairs(S.sharedEmojis or{})do local nm=tostring(e.name or""):lower()local id=tostring(e.id or"")local by=tostring(e.by or""):lower()
        if q==""or nm:find(q,1,true)or id:find(q,1,true)or by:find(q,1,true)then filtered[#filtered+1]=e end end lab(body,"Server Shared Emojis ("..#filtered.."/"..#(S.sharedEmojis or{})..")"..T("emoji_srv_hint"),{
        wrap=true,auto=true,ts=10,key="muted",layout=3,})gridNamedImages(body,filtered,true,seq,true)else local tools=row(body,28);tools.LayoutOrder=2
      local del=rbtn(tools,T("img_del_mode"),{size=u2(0.5,-3,1,0),ts=11,key=delMode and"danger"or"bg3"})hook(del.MouseButton1Click,function()delMode=not delMode;show("img")end)
      local clr=rbtn(tools,T("clear"),{size=u2(0.5,-3,1,0),key="danger",ts=11})hook(clr.MouseButton1Click,function()P.customEmojis={};S.isDirty=true;show("img")end)local entries={}for _,id in ipairs(P.customEmojis)do
        local nm=P.customEmojiNames[id]or("emo_"..tostring(id):sub(-4))if q==""or nm:lower():find(q,1,true)or tostring(id):find(q,1,true)then entries[#entries+1]={id=id,name=nm,by=P.username}end end
      gridNamedImages(body,entries,false,seq,true)end end
  local tabDefs={{"recent",T("recent")},{"face",T("tab_face")},{"hand",T("tab_hand")},{"sym",T("tab_sym")},{"obj",T("tab_obj")},{"shared","Shared"},{"img",T("tab_img")},
  }local tabBtns={}show=function(tab)cur=tab;P.emojiTab=tab renderSeq=renderSeq+1 local seq=renderSeq
    F.pruneThemeReg()
    for _,c in ipairs(body:GetChildren())do if not c:IsA("UIListLayout")then c:Destroy()end end
    local tabOffFg=H.ensureContrast(TH.text,TH.btnBg,4.8)
    for k,b in pairs(tabBtns)do local on=(k==tab)b.BackgroundColor3=on and TH.accent or TH.btnBg b.TextColor3=on and(H.lum(TH.accent)>0.55 and rgb(20,20,24)or c3(1,1,1))or tabOffFg end
    local q=H.trim(searchBar.Text):lower():gsub("^:+",""):gsub(":+$","")if tab=="shared"then buildShareAndLocal(true,seq)elseif tab=="img"then
      buildShareAndLocal(false,seq)elseif tab=="recent"then local uni,imgs={},{}for _,e in ipairs(P.recentEmoji)do if tostring(e):sub(1,4)=="img:"then local id=tostring(e):sub(5)
          local info=F.emojiInfoById(id)or{id=id,name="emo_"..id:sub(-4),by="?"}if q==""or tostring(info.name):lower():find(q,1,true)or id:find(q,1,true)then imgs[#imgs+1]=info end elseif q==""then uni[#uni+1]=e end end
      for _,e in ipairs(S.sharedEmojis or{})do if q==""or tostring(e.name or""):lower():find(q,1,true)or tostring(e.id or""):find(q,1,true)then local dup=false
          for _,x in ipairs(imgs)do if tostring(x.id)==tostring(e.id)then dup=true;break end end if not dup and#imgs<12 then imgs[#imgs+1]=e end end end if#uni==0 and q==""then for _,e in ipairs(CFG.REACT)do uni[#uni+1]=e end end
      if#imgs>0 then lab(body,T("emoji_recent_custom"),{ts=10,key="muted",bold=true})gridNamedImages(body,imgs,false,seq,false)end if#uni>0 then lab(body,T("emoji_standard"),{ts=10,key="muted",bold=true})gridUnicode(body,uni,seq)end
    else if q~=""then local matches={}for _,e in ipairs(S.sharedEmojis or{})do if tostring(e.name or""):lower():find(q,1,true)or tostring(e.id or""):find(q,1,true)then matches[#matches+1]=e end end if#matches>0 then
          lab(body,T("emoji_matched").." ("..#matches..")",{ts=10,key="accent",bold=true})gridNamedImages(body,matches,true,seq,false)end end gridUnicode(body,CFG.EMOJI[tab]or{},seq)end end for i,d in ipairs(tabDefs)do
    local b=tbtn(tabsRow,d[2],{size=u2(1/#tabDefs,-5,1,0),ts=10,layout=i})tabBtns[d[1]]=b hook(b.MouseButton1Click,function()show(d[1])end)end
  hook(searchBar:GetPropertyChangedSignal("Text"),function()
    searchSeq=searchSeq+1 local my=searchSeq
    task.delay(0.12,function()if searchSeq==my and body.Parent then show(cur)end end)
  end)
  show(cur)end

-- =============================================================================
-- 16. THẢ CẢM XÚC (REACTIONS), CUỘN KHUNG CHAT, VẼ TIN NHẮN & CONTEXT MENU
-- =============================================================================
--- [F.reactionMap] Lấy (hoặc khởi tạo) bảng lưu danh sách người dùng đã thả cảm xúc cho tin nhắn `id`
function F.reactionMap(id)S.reactions[id]=S.reactions[id]or{};return S.reactions[id]end
--- [F.makeReactionPill] Tạo nút hiển thị một loại cảm xúc kèm số lượng người thả dưới chân tin nhắn hoặc bài đăng Script
function F.makeReactionPill(parent,emoji,count,mine,order,onClick)local h=22 local icSz=15
  local cStr=tostring(count or 1)local cW=max(8,H.textW(cStr,11,fGB))local pillW=6+icSz+4+cW+7 local b=mk("TextButton",{Text="",Size=uo(pillW,h),BorderSizePixel=0,AutoButtonColor=true,Active=true,ZIndex=20,
    LayoutOrder=order or 1,},parent)th(b,"BackgroundColor3",mine and"accent"or"bg3")corner(b,11)local st=mk("UIStroke",{Color=mine and TH.accent or TH.muted,Thickness=1,Transparency=mine and 0.2 or 0.65,
    ApplyStrokeMode=smBorder,},b)st.ZIndex=20 local ic=F.iconBox(b,emoji,icSz)ic.Position=uo(6,floor((h-icSz)/2))ic.ZIndex=21 local cl=lab(b,cStr,{size=uo(cW+2,h),pos=uo(6+icSz+4,0),ts=11,bold=true,})cl.ZIndex=21
  if mine then themed(cl,function(x)x.TextColor3=H.lum(TH.accent)>0.55 and rgb(20,20,24)or c3(1,1,1)end)end if onClick then hook(b.MouseButton1Click,onClick)end return b end
--- [F.renderReactions] Vẽ lại toàn bộ danh sách các cảm xúc (Reactions) của tin nhắn có mã `id`
function F.renderReactions(id)
  local holder=S.rxHolders and S.rxHolders[id]if not holder or not holder.Parent then return end for _,c in ipairs(holder:GetChildren())do if not c:IsA("UIListLayout")then c:Destroy()end end
  local map=S.reactions[id]or{}
  local keys={}for e,users in pairs(map)do if next(users)then keys[#keys+1]=e end end tsort(keys)holder.Visible=#keys>0 holder.ZIndex=12 for i,e in ipairs(keys)do local n=0 for _ in pairs(map[e])do n=n+1 end
    local mine=map[e][P.username]==true F.makeReactionPill(holder,e,n,mine,i,function()F.safeTap("rx:"..id..":"..e,function()F.doReact(S.msgs[id]or{packetId=id,chan=S.chan},e)end,0.32)end)end if#keys>0 then
    local addB=mk("TextButton",{Text="+",Font=fGB,TextSize=12,Size=uo(24,22),BorderSizePixel=0,AutoButtonColor=true,Active=true,ZIndex=20,LayoutOrder=#keys+1,},holder)
    th(addB,"BackgroundColor3","bg3");th(addB,"TextColor3","muted");corner(addB,11)hook(addB.MouseButton1Click,function()local m=S.msgs[id]or{packetId=id,chan=S.chan}
      F.openEmoji({title=T("react"),onPick=function(e)F.doReact(m,e)end})end)end end
--- [F.doReact] Thực hiện thả hoặc gỡ một cảm xúc `e` trên tin nhắn `m` và đồng bộ lên máy chủ
function F.doReact(m,e)local t=os.clock()if t-S.reactAt<CFG.REACT_THRO then return end
  S.reactAt=t
  if F.muted(P.username)then F.toast(T("muted"),true);return end
  local map=F.reactionMap(m.packetId)map[e]=map[e]or{}local add=not map[e][P.username]map[e][P.username]=add and true or nil S.isDirty=true
  F.renderReactions(m.packetId)F.publish({type="react",target=m.packetId,emoji=e,by=P.username,action=add and"add"or"remove",chan=m.chan or S.chan})end
--- [F.nearBottom] Kiểm tra khung cuộn tin nhắn (`U.scroll`) có đang ở gần cuối danh sách hay không
function F.nearBottom()local s=U.scroll
  return s.CanvasPosition.Y+s.AbsoluteWindowSize.Y>=s.AbsoluteCanvasSize.Y-50 end
--- [F.snapBottom] Đặt vị trí khung cuộn xuống dưới cùng ngay lập tức
function F.snapBottom()local sc=U.scroll if not sc or not sc.Parent then return end
  sc.CanvasPosition=v2(0,max(0,sc.AbsoluteCanvasSize.Y-sc.AbsoluteWindowSize.Y+40))end
--- [F.scrollBottom] Cuộn xuống tin nhắn mới nhất ở cuối khung chat và ẩn nút nhảy xuống dưới
function F.scrollBottom()S.stickUntil=os.clock()+0.9 task.defer(function()task.wait()if not U.scroll.Parent then return end
    F.snapBottom()S.newBelow=0;U.jump.Visible=false end)end
--- [F.updateJump] Cập nhật trạng thái hiển thị của nút nhảy xuống cuối khung chat (`U.jump`) kèm số tin nhắn mới bên dưới
function F.updateJump()local show=not F.nearBottom()and S.newBelow>0 U.jump.Visible=show if show then U.jump.Text="v "..S.newBelow end end
--- [F.dropFrame] Xóa triệt để phần tử giao diện (`Frame`) của một tin nhắn khỏi khung cuộn, tránh lỗi bóng ma (ghost message) trên UI
function F.dropFrame(id)local f=S.frames[id]if f then pcall(function()f.Visible=false;f.Size=uo(0,0);f.Parent=nil;f:Destroy()end)end
  if U.scroll and U.scroll.Parent then local ghost=U.scroll:FindFirstChild("Item_"..tostring(id))if ghost then pcall(function()ghost.Visible=false;ghost.Parent=nil;ghost:Destroy()end)end end
  S.frames[id]=nil if S.rxHolders then S.rxHolders[id]=nil end if S.statusLabels then S.statusLabels[id]=nil end
  for i=#S.frameQ,1,-1 do if S.frameQ[i]==id then tremove(S.frameQ,i)end end end
--- [F.sweepGhostFrames] Quét và dọn sạch các khung tin nhắn cũ bị kẹt trong nền `U.scroll` hoặc không khớp kênh hiện tại
function F.sweepGhostFrames()if not U.scroll or not U.scroll.Parent or S.chan=="scripts"or S.chan=="punish"then return end
  local curGen=S.feedGen or 0
  for _,c in ipairs(U.scroll:GetChildren())do
    if c:IsA("GuiObject")and c.Name~="AnnounceHdr"then
      local id=c.Name:match("^Item_(.+)$")local g=c:GetAttribute("FeedGen")
      local valid=false
      if id and S.frames[id]==c then
        local m=S.msgs[id]local p=S.polls[id]
        if m and F.visibleIn(m,S.chan)and F.matchSearch(m)then valid=true
        elseif p and not p.cleared and p.chan==S.chan and S.search==""then valid=true end
      end
      if(g and g<curGen)or not valid then pcall(function()c.Visible=false;c.Size=uo(0,0);c.Parent=nil;c:Destroy()end)end
    end
  end end
--- [F.trimFrames] Giới hạn số lượng tin nhắn hiển thị đồng thời trên UI (`CFG.MAX_RENDER`) bằng cách xóa bớt các khung cũ ở đầu
function F.trimFrames()if S.chan=="announce"then return end while#S.frameQ>CFG.MAX_RENDER do local id=tremove(S.frameQ,1)F.dropFrame(id)end
end
--- [F.matchSearch] Kiểm tra một tin nhắn hoặc chủ đề có khớp với từ khóa tìm kiếm `S.search` hiện tại hay không
function F.matchSearch(m)local q=S.search if not q or q==""then return true end q=q:lower()return tostring(m.content or""):lower():find(q,1,true)~=nil or tostring(m.author or""):lower():find(q,1,true)~=nil end
--- [F.jumpToMsg] Cuộn khung chat tới vị trí của tin nhắn `targetId` và nháy sáng nền để làm nổi bật
function F.jumpToMsg(targetId)local tf=targetId and S.frames and S.frames[targetId]if not tf or not tf.Parent then return end
  pcall(function()
    local dy=tf.AbsolutePosition.Y-U.scroll.AbsolutePosition.Y+U.scroll.CanvasPosition.Y-30 U.scroll.CanvasPosition=v2(0,max(0,dy))local orig=tf.BackgroundColor3 tf.BackgroundColor3=TH.accent
    task.delay(0.55,function()if tf.Parent then tf.BackgroundColor3=orig end end)end)end
--- [F.renderMessage] Khởi tạo và vẽ toàn bộ giao diện của một thẻ tin nhắn `m` vào danh sách cuộn `U.scroll` (gọn gàng, tối ưu chiều cao Seen)
function F.renderMessage(m)if not m or m.deleted or m.cleared or m.type~="msg"then return end
  if not F.visibleIn(m,S.chan)or not F.matchSearch(m)then return end
  local id=m.packetId if S.frames[id]then F.dropFrame(id)end
  S.rxHolders=S.rxHolders or{}local mine=m.author==P.username
  local pinged=(not mine)and F.mentions(m.content)local grp=m.grp==true and not m.failed and P.group and S.search==""and not m.fwdFrom and m.prevId~=nil and S.frames[m.prevId]~=nil
  local mStyle=P.msgStyle or"card"
  local frame=mk("Frame",{Name="Item_"..tostring(id),Size=u2(1,-4,0,0),AutomaticSize=asY,
    BorderSizePixel=0,LayoutOrder=m.order or 0,Active=true,ClipsDescendants=false,},U.scroll)pcall(function()frame:SetAttribute("FeedGen",S.feedGen or 0)end)
  local cardRad=clamp((tonumber(P.uiRadius)or 10)-1,3,14)
  corner(frame,mStyle=="flat"and 4 or cardRad)
  if mStyle=="flat"then
    themed(frame,function(f)
      f.BackgroundColor3=mine and TH.own or(pinged and TH.mention or TH.bg2)
      f.BackgroundTransparency=(mine or pinged)and clamp(P.alpha+0.25,0.15,0.88)or 0.92
    end)
    if pinged then stroke(frame,"mentionText",1,0.4)end
  elseif mStyle=="minimal"then
    themed(frame,function(f)
      f.BackgroundColor3=pinged and TH.mention or TH.bg2
      f.BackgroundTransparency=pinged and 0.35 or 0.96
    end)
  else
    themed(frame,function(f)
      local md=P.backgroundMode or"solid"
      if mine then f.BackgroundColor3=(md=="gradient"or md=="mesh")and H.mix(TH.own,TH.g2,0.22)or TH.own
      elseif pinged then f.BackgroundColor3=TH.mention
      else f.BackgroundColor3=(md=="gradient"or md=="mesh")and H.mix(TH.bg2,TH.g2,0.16)or TH.bg2 end
      f.BackgroundTransparency=F.surfaceAlpha("card")
    end)
    if pinged then stroke(frame,"mentionText",1,0.35)elseif mine and P.borderGlow~=false then stroke(frame,"accent",1,0.42)else stroke(frame,"border",1,0.5)end
  end
  pad(frame,8,grp and 2 or(mStyle=="minimal"and 2 or 4),6,grp and 2 or(mStyle=="minimal"and 2 or 4))local topR=F.topRole(m.author)local barCol=(topR and H.hex(topR.color))or(F.isDev(m.author)and H.hex(F.DEVROLE.color))or TH.accent
  local bar=mk("Frame",{Size=u2(0,mStyle=="minimal"and 2 or 3,1,-6),Position=uo(0,3),BackgroundColor3=barCol,BorderSizePixel=0,ZIndex=2,Visible=(mStyle~="flat"or mine or pinged or topR~=nil)},frame)corner(bar,2)S.frames[id]=frame tinsert(S.frameQ,id)local compactAv=(P.W<210 or mStyle=="minimal")
  if not grp and not compactAv then
    local uRec=F.userRec(m.author)
    local customIc=(mine and P.profIcon~=""and P.profIcon)or(uRec and uRec.profIcon and uRec.profIcon~=""and uRec.profIcon)or nil
    local uPt=(mine and type(P.profTheme)=="table"and P.profTheme)or(uRec and type(uRec.profTheme)=="table"and uRec.profTheme)or{}
    F.makeFramedAvatar(frame,{px=28,pos=uo(0,1),z=8,uid=m.uid or F.uidOf(m.author),customIc=customIc,pt=uPt,onClick=function()F.safeTap("av:"..id,function()F.openProfile(m.author)end)end})end
  local colX=(grp or compactAv)and 7 or 35
  local rightReserve=grp and 22 or 4 local col=mk("Frame",{Position=uo(colX,0),Size=u2(1,-(colX+rightReserve),0,0),AutomaticSize=asY,BackgroundTransparency=1,ZIndex=3,},frame)list(col,2)if not grp then
    local hdr=mk("Frame",{Size=u2(1,-68,0,17),BackgroundTransparency=1,LayoutOrder=1,ZIndex=4},col)mk("UIListLayout",{FillDirection=fdH,Padding=u1(0,4),SortOrder=soLO,VerticalAlignment=vaC,},hdr)
    local dispStr=F.disp(m.display or m.author or"?")local nmW=clamp(H.textW(dispStr,12,fGB)+2,20,116)local nm=mk("TextButton",{Size=uo(nmW,16),BackgroundTransparency=1,Text=dispStr,Font=fGB,TextSize=12,
      TextXAlignment=txL,TextTruncate=trEnd,LayoutOrder=1,BorderSizePixel=0,AutoButtonColor=false,Active=true,ZIndex=8,},hdr)hook(nm.MouseButton1Click,function()F.safeTap("nm:"..id,function()F.openProfile(m.author)end)
    end)if topR then nm.TextColor3=H.hex(topR.color)else th(nm,"TextColor3","text")end if topR then F.roleChip(hdr,topR,2,false)elseif F.isDev(m.author)then F.roleChip(hdr,F.DEVROLE,2,false)end
    local tStr=H.shortTime(m.ts)..(m.edited and(" "..T("edited"))or"")local tW=max(26,H.textW(tStr,9,fG)+4)local tm=mk("TextLabel",{Size=uo(tW,16),BackgroundTransparency=1,Text=tStr,Font=fG,TextSize=9,
      TextXAlignment=txL,LayoutOrder=3,BorderSizePixel=0,ZIndex=4,},hdr)th(tm,"TextColor3","muted")if m.failed then local fStr=T("failed")local fl=mk("TextLabel",{Size=uo(H.textW(fStr,9,fGB)+4,16),
        BackgroundTransparency=1,Text=fStr,Font=fGB,TextSize=9,LayoutOrder=4,BorderSizePixel=0,ZIndex=4,},hdr)th(fl,"TextColor3","danger")end end
  if m.fwdFrom and tostring(m.fwdFrom)~=""then
    local fb=mk("Frame",{Size=u2(1,0,0,15),BackgroundTransparency=1,LayoutOrder=1,ZIndex=5},col)
    local fTxt="↪ "..(L=="en"and"Forwarded from @"or"Chuyển tiếp từ @")..F.disp(m.fwdFrom)..(m.fwdChan and m.fwdChan~=""and(" ("..tostring(m.fwdChan)..")")or"")
    lab(fb,fTxt,{size=us(1,1),ts=9,bold=true,key="accent",trunc=true})
  end
  if m.replyTo then local rb=mk("TextButton",{Size=u2(1,0,0,18),Text="",
      AutoButtonColor=true,BorderSizePixel=0,LayoutOrder=2,ZIndex=6,ClipsDescendants=true,},col)th(rb,"BackgroundColor3","bg3");corner(rb,5)
    local rbar=mk("Frame",{Size=u2(0,3,1,-4),Position=uo(2,2),BackgroundColor3=barCol,BorderSizePixel=0,ZIndex=7},rb)corner(rbar,2)
    local rl=lab(rb,F.disp("↩ @"..tostring(m.replyAuthor or"?")..": "..H.clip(F.plain(m.replySnippet or""),56)),{size=u2(1,-14,1,0),pos=uo(10,0),ts=10,key="muted",trunc=true,})rl.ZIndex=7
    hook(rb.MouseButton1Click,function()F.jumpToMsg(m.replyTo)end)end
  local segs,imgCount,hasText=F.parseInlineSegments(m.content)if imgCount==0 then local rawDisp=F.disp(F.expandShortcodes(m.content))..(grp and m.edited and(" "..T("edited"))or"")
    local body=lab(col,rawDisp,{wrap=true,auto=true,ts=P.textSize,layout=3})if rawDisp:find("@[%w_]+")or rawDisp:find(":[%w_%-]+:")then
      themed(body,function(bLbl)local eHex=H.tohex(TH.emojiText or TH.accent)local escaped=H.esc(rawDisp):gsub("@([%w_]+)",function(u)
          local colHex=H.tohex(F.mentionColorFor(u))return'<font color="'..colHex..'"><b>@'..u..'</b></font>'end):gsub(":([%w_%-]+):",function(em)
          return'<font color="'..eHex..'"><b>:'..em..':</b></font>'end)bLbl.RichText=true bLbl.Text=escaped end)else body.RichText=false
    end body.ZIndex=3 elseif not hasText then local ir=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BackgroundTransparency=1,LayoutOrder=3,ZIndex=4},col)
    mk("UIListLayout",{FillDirection=fdH,Wraps=true,Padding=u1(0,6),SortOrder=soLO,VerticalAlignment=vaC},ir)local sz=imgCount==1 and 50 or 40 for i,seg in ipairs(segs)do if seg.kind=="img"then
        local info=F.emojiInfoById(seg.id)local holder=mk("TextButton",{Size=uo(sz,sz+(info and 13 or 0)),BackgroundTransparency=1,Text="",BorderSizePixel=0,LayoutOrder=i,ZIndex=6,},ir)
        local ib=F.iconBox(holder,"img:"..seg.id,sz)ib.ZIndex=6 if info and info.name then local tagL=lab(holder,":"..info.name..":",{size=u2(1,0,0,12),pos=uo(0,sz),ts=9,bold=true,key="emojiText",align=txC,trunc=true,})tagL.ZIndex=6 end
        hook(holder.MouseButton1Click,function()F.openEmojiPreview(seg.id,m,false)end)end end else local flow=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BackgroundTransparency=1,LayoutOrder=3,ZIndex=4},col)
    mk("UIListLayout",{FillDirection=fdH,Wraps=true,Padding=u1(0,3),SortOrder=soLO,VerticalAlignment=vaC},flow)local orderIdx=0 local inlineSz=clamp(P.textSize+8,20,26)for _,seg in ipairs(segs)do if seg.kind=="text"then
        for word in tostring(seg.text):gmatch("%S+")do orderIdx=orderIdx+1 local wStr=F.disp(word)local wW=max(6,H.textW(wStr,P.textSize,fG)+2)local wl=mk("TextLabel",{Size=uo(wW,inlineSz),BackgroundTransparency=1,
            Text=wStr,Font=fG,TextSize=P.textSize,TextXAlignment=txL,BorderSizePixel=0,LayoutOrder=orderIdx,ZIndex=4,},flow)if wStr:match("^@[%w_]+")then local u=wStr:match("^@([%w_]+)")wl.Font=fGB
            themed(wl,function(x)x.TextColor3=F.mentionColorFor(u)end)elseif wStr:match("^:[%w_%-]+:$")then wl.Font=fGB th(wl,"TextColor3","emojiText")else th(wl,"TextColor3","text")end end elseif seg.kind=="img"then orderIdx=orderIdx+1
        local info=F.emojiInfoById(seg.id)local eb=mk("TextButton",{
          Size=uo(inlineSz,inlineSz),BackgroundTransparency=1,Text="",BorderSizePixel=0,LayoutOrder=orderIdx,ZIndex=6,},flow)local ib=F.iconBox(eb,"img:"..seg.id,inlineSz)ib.ZIndex=6
        hook(eb.MouseButton1Click,function()F.openEmojiPreview(seg.id,m,false)end)end end end
  local jPlace,jJob=tostring(m.content or""):match("%[join:(%d+):([%w_%-]+)%]")if jPlace and jJob then
    local jCard=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BorderSizePixel=0,LayoutOrder=4,ZIndex=6},col)th(jCard,"BackgroundColor3","bg3");corner(jCard,8);stroke(jCard,"ok",1,0.3);pad(jCard,6,5,6,5);list(jCard,3)
    local isSameSrv=(tonumber(jPlace)==game.PlaceId and jJob==game.JobId)local jBtn=tbtn(jCard,isSameSrv and T("join_srv_self")or T("join_srv_btn"),{size=u2(1,0,0,24),key=isSameSrv and"bg2"or"ok",ts=11,r=6,layout=1,
    })jBtn.ZIndex=7 local noteL=lab(jCard,T("delta_tp_short"),{wrap=true,auto=true,ts=9,key="warn",layout=2})noteL.ZIndex=7 hook(jBtn.MouseButton1Click,function()
      if isSameSrv then F.toast(T("join_srv_self"),true);return end if F.armAutoTeleport then F.armAutoTeleport(true)end
      F.toast(T("delta_tp_note"),true)
      pcall(function()TeleportService:TeleportToPlaceInstance(tonumber(jPlace),jJob,LP)end)end)end
  local rx=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BackgroundTransparency=1,LayoutOrder=5,Visible=false,ZIndex=12,
  },col)mk("UIListLayout",{FillDirection=fdH,Wraps=true,Padding=u1(0,4),SortOrder=soLO,VerticalAlignment=vaC},rx)S.rxHolders[id]=rx F.renderReactions(id)
  if mine then
    S.statusLabels=S.statusLabels or{}
    local stTxt,stKey=F.formatMsgStatus(m)
    local stLbl=mk("TextButton",{Name="MsgStatus",Size=u2(1,0,0,11),BackgroundTransparency=1,Text=stTxt,Font=fG,TextSize=9,TextXAlignment=txR,TextTruncate=trEnd,AutoButtonColor=false,LayoutOrder=6,BorderSizePixel=0,ZIndex=8},col)
    themed(stLbl,function(x)local _,k=F.formatMsgStatus(m)x.TextColor3=TH[k]or TH.muted end)
    hook(stLbl.MouseButton1Click,function()if m.failed then F.resend(m)else F.openSeenDetail(m)end end)
    S.statusLabels[id]=stLbl
  end
  local canStaffDel=F.isStaff(P.username)or(m.author==P.username and m.chan~="announce"and m.chan~="punish")
  if not grp then local qbar=mk("Frame",{Size=uo(canStaffDel and 98 or 78,19),
      Position=u2(1,-(canStaffDel and 98 or 78),0,0),BorderSizePixel=0,ZIndex=10},frame)
    themed(qbar,function(o)o.BackgroundColor3=TH.bg3;o.BackgroundTransparency=clamp(F.surfaceAlpha("pill")+0.14,0.18,0.74)end)
    corner(qbar,6);stroke(qbar,"border",1,0.55)
    mk("UIListLayout",{FillDirection=fdH,Padding=u1(0,1),HorizontalAlignment=Enum.HorizontalAlignment.Center,VerticalAlignment=vaC,SortOrder=soLO},qbar)
    local function qic(ord,icKey,colKey,cb,nm)
      local b=mk("TextButton",{Name=nm or("QBtn"..ord),Size=uo(18,17),BackgroundTransparency=1,Text="",BorderSizePixel=0,LayoutOrder=ord,ZIndex=11,Active=true},qbar)
      F.lucide(b,icKey,11,{pos=us(0.5,0.5),anc=v2(0.5,0.5),key=colKey or"muted",z=12})
      hook(b.MouseButton1Click,cb)
      return b
    end
    qic(1,"smilePlus","muted",function()F.openEmoji({title=T("react"),onPick=function(e)F.doReact(m,e)end})end)
    qic(2,"reply","muted",function()F.startReply(m)end)
    qic(3,"forward","muted",function()F.openForward(m)end)
    if canStaffDel then qic(4,"trash","danger",function()F.deleteMsg(m)end)end
    local menu=qic(5,"ellipsis","muted",nil,"MsgMenuBtn")
    hook(menu.MouseButton1Click,function()F.openCtx(m,menu.AbsolutePosition+v2(0,20))end)
  else
    local menu=mk("TextButton",{Name="MsgMenuBtn",Size=uo(24,20),Position=u2(1,-24,0,0),
      BackgroundTransparency=1,Text="",BorderSizePixel=0,ZIndex=11,Active=true},frame)
    F.lucide(menu,"ellipsis",12,{pos=us(0.5,0.5),anc=v2(0.5,0.5),key="muted",z=12})
    hook(menu.MouseButton1Click,function()F.openCtx(m,menu.AbsolutePosition+v2(0,18))end)
  end
  F.trimFrames()end
--- [F.closeCtx] Đóng trình đơn ngữ cảnh (Context Menu) đang mở
function F.closeCtx()for _,c in ipairs(U.layer:GetChildren())do c:Destroy()end
  U.layer.Visible=false
end
--- [F.copyText] Sao chép chuỗi văn bản `s` vào bộ nhớ tạm (Clipboard) của thiết bị
function F.copyText(s)local ok=pcall(function()if setclipboard then setclipboard(s)else toclipboard(s)end end)F.toast(ok and T("copy_ok")or"Clipboard Error",true)end
--- [F.openForward] Mở hộp thoại chuyển tiếp tin nhắn `m` tới các kênh công khai, Group Chat hoặc DM cá nhân
function F.openForward(m)
  if not m then return end
  if F.muted(P.username)then F.toast(T("muted"),true);return end
  if S.banned then F.toast(T("banned_you"),true);return end
  local scr,close=F.popup(L=="en"and"↪ Forward Message"or"↪ Chuyển tiếp tin nhắn",310,380)
  local lo=0
  lo=lo+1;local pv=F.card(scr,0);pv.AutomaticSize=asY;pv.Size=u2(1,0,0,0);pv.LayoutOrder=lo;pad(pv,8,6,8,6);list(pv,2)
  lab(pv,"@"..F.disp(m.author or"?")..": "..H.clip(F.plain(m.content or""),70),{ts=11,key="muted",wrap=true,auto=true})
  lo=lo+1;local noteBox=field(scr,L=="en"and"Optional comment"or"Ghi chú kèm theo (tùy chọn)","",false,lo)
  lo=lo+1;noteBox.LayoutOrder=lo
  local function doFwd(targetChan,labelName)
    if type(close)=="function"then close()else F.closeModal()end
    local extra=H.trim(noteBox.Text)
    local finalText=tostring(m.content or"")
    if extra~=""then finalText=extra.." | "..finalText end
    local pid=H.uuid()local now=H.now()
    local pkt={
      type="msg",packetId=pid,chan=targetChan,author=P.username,display=P.display,uid=P.userId,
      content=H.clip(finalText,CFG.MAX_CONTENT),ts=now,fwdFrom=tostring(m.author or"?"),fwdChan=tostring(m.chan or""),
      place=targetChan=="game"and game.PlaceId or nil,job=targetChan=="game"and tostring(game.JobId or"")or nil,
    }
    F.process(pkt,false)
    if S.msgs[pid]then S.msgs[pid].sending=true;S.msgs[pid].sent=false;F.updateMsgStatus(pid)end
    F.publish(pkt,"send",function(ok)
      local msgObj=S.msgs[pid]
      if msgObj then msgObj.sending=false;msgObj.sent=ok;msgObj.failed=not ok;F.updateMsgStatus(pid)end
    end)
    F.toast((L=="en"and"Forwarded to "or"Đã chuyển tiếp tới ")..tostring(labelName or targetChan),true)
    F.selectChannel(targetChan)
  end
  lo=lo+1;F.section(scr,L=="en"and"Channels"or"Kênh chung",lo)
  lo=lo+1;local chRow=row(scr,28,lo)
  local bGen=rbtn(chRow,"# "..T("general"),{key="accent",ts=11})hook(bGen.MouseButton1Click,function()doFwd("general","#general")end)
  local bGm=rbtn(chRow,"🎮 "..T("game"),{key="btnBg",ts=11})hook(bGm.MouseButton1Click,function()doFwd("game","#game")end)
  if F.canAnnounce(P.username)or F.isStaff(P.username)then
    lo=lo+1;local chRow2=row(scr,28,lo)
    if F.canAnnounce(P.username)then
      local bAnn=rbtn(chRow2,"📢 "..T("announcetab"),{ts=11})hook(bAnn.MouseButton1Click,function()doFwd("announce","#announce")end)
    end
    if F.isStaff(P.username)then
      local bSt=rbtn(chRow2,"👑 "..T("stafftab"),{ts=11})hook(bSt.MouseButton1Click,function()doFwd("staff","#staff")end)
    end
  end
  local myGroups={}
  for _,g in ipairs(S.groups or{})do
    local okMem=false
    for _,mem in ipairs(g.members or{})do if tostring(mem):lower()==P.username:lower()then okMem=true;break end end
    if okMem or F.isStaff(P.username)then myGroups[#myGroups+1]=g end
  end
  if #myGroups>0 then
    lo=lo+1;F.section(scr,"Group Chat ("..#myGroups..")",lo)
    for _,g in ipairs(myGroups)do
      lo=lo+1
      local gb=tbtn(scr,"👥 "..F.disp(g.name or"Group").." ("..#(g.members or{})..")",{h=28,ts=11,key="btnBg",layout=lo})
      gb.TextXAlignment=txL;pad(gb,10,0,10,0)
      hook(gb.MouseButton1Click,function()doFwd(g.chan,"👥 "..tostring(g.name))end)
    end
  end
  lo=lo+1;F.section(scr,L=="en"and"Direct Message (DM)"or"Tin nhắn riêng (DM)",lo)
  lo=lo+1;local dmRow=row(scr,28,lo)
  local dmIn=mk("TextBox",{Size=u2(0.68,-3,1,0),Text="",PlaceholderText=L=="en"and"Username..."or"Nhập tên người nhận...",ClearTextOnFocus=false,Font=fG,TextSize=11,BorderSizePixel=0,TextXAlignment=txL},dmRow)
  F.styleInput(dmIn,"text",false)
  local dmGo=rbtn(dmRow,L=="en"and"Send"or"Gửi",{size=u2(0.32,-3,1,0),key="accent",ts=11})
  hook(dmGo.MouseButton1Click,function()
    local u=H.trim(dmIn.Text):gsub("^@","")
    if u==""or u:lower()==P.username:lower()then return end
    P.dmList=type(P.dmList)=="table"and P.dmList or{}
    P.dmList[u]=H.now();S.isDirty=true
    doFwd(F.dmChan(P.username,u),"@"..u)
  end)
  local seenU={}
  local function addQuickU(u)
    if not u or u==""or u:lower()==P.username:lower()or seenU[u:lower()]then return end
    seenU[u:lower()]=true
    lo=lo+1
    local ub=tbtn(scr,"💬 @"..F.disp(u),{h=26,ts=11,key="btnBg",layout=lo})
    ub.TextXAlignment=txL;pad(ub,10,0,10,0)
    hook(ub.MouseButton1Click,function()
      P.dmList=type(P.dmList)=="table"and P.dmList or{}
      P.dmList[u]=H.now();S.isDirty=true
      doFwd(F.dmChan(P.username,u),"@"..u)
    end)
  end
  local dmUsers={}
  for u in pairs(P.dmList or{})do if type(u)=="string"then dmUsers[#dmUsers+1]=u end end
  tsort(dmUsers,function(a,b)return(tonumber(P.dmList[a])or 0)>(tonumber(P.dmList[b])or 0)end)
  for _,u in ipairs(dmUsers)do addQuickU(u)end
  for u,r in pairs(S.users or{})do if F.isLive(r)then addQuickU(u)end end
end
--- [F.openCtx] Mở trình đơn ngữ cảnh (Context Menu) tại tọa độ chuột/chạm với các thao tác: Trả lời, Chuyển tiếp, Thả cảm xúc, Sao chép, Sửa, Xóa (kể cả Admin/Dev xóa tin nhạy cảm), Báo cáo, Mute
function F.openCtx(m,pos)F.closeCtx()
  U.layer.Visible=true local back=mk("TextButton",{Size=us(1,1),BackgroundTransparency=1,Text="",AutoButtonColor=false,ZIndex=100},U.layer)hook(back.MouseButton1Click,F.closeCtx)local menu=mk("Frame",{Size=uo(226,0),
    AutomaticSize=asY,BorderSizePixel=0,ZIndex=101,},U.layer)th(menu,"BackgroundColor3","bg2");corner(menu,12)stroke(menu,"border",1.2,0.15)pad(menu,8,8,8,8);list(menu,4)local v=viewNow()menu.Position=uo(clamp(pos.X,6,max(6,v.X-232)),clamp(pos.Y,6,max(6,v.Y-260)))
  task.defer(function()if menu.Parent then local vv=viewNow()local mh=menu.AbsoluteSize.Y menu.Position=uo(clamp(pos.X,6,max(6,vv.X-232)),clamp(pos.Y,6,max(6,vv.Y-mh-8)))end end)
  local hdr=mk("Frame",{Size=u2(1,0,0,28),BackgroundTransparency=1,LayoutOrder=0},menu)
  F.lucide(hdr,"msgCircle",13,{pos=uo(2,7),key="muted",z=102})
  lab(hdr,F.disp(H.clip(F.plain(m.content),28)),{size=u2(1,-20,1,0),pos=uo(20,0),ts=11,key="muted",trunc=true,})
  local qr=row(menu,30);qr.LayoutOrder=1 for _,e in ipairs(F.quickEmoji())do local b=tbtn(qr,"",{size=uo(38,30),r=8})local ic=F.iconBox(b,e,22)
    ic.Position=u2(0.5,-11,0.5,-11)hook(b.MouseButton1Click,function()F.closeCtx();F.doReact(m,e)end)end
  local more=tbtn(qr,"",{size=uo(38,30),r=8,key="accent"})
  local moreIc=F.lucide(more,"smilePlus",15,{pos=us(0.5,0.5),anc=v2(0.5,0.5),col=c3(1,1,1),themed=false,z=102})
  themed(moreIc,function(ic)ic.ImageColor3=H.lum(TH.accent)>0.55 and rgb(20,20,24)or c3(1,1,1)end)
  hook(more.MouseButton1Click,function()F.closeCtx()
    F.openEmoji({title=T("react"),onPick=function(e)F.doReact(m,e)end})end)
  local function item(icKey,text,fn,key)
    local b=tbtn(menu,text,{size=u2(1,0,0,27),key=key or"btnBg",ts=11});b.TextXAlignment=txL
    pad(b,28,0,8,0)
    local isCol=(key=="accent"or key=="danger"or key=="ok"or key=="warn")
    if isCol then
      local ic=F.lucide(b,icKey,13,{pos=u2(0,-19,0.5,0),anc=v2(0,0.5),col=H.lum(TH[key])>0.55 and rgb(20,20,24)or c3(1,1,1),themed=false,z=102})
      themed(ic,function(x)x.ImageColor3=H.lum(TH[key])>0.55 and rgb(20,20,24)or c3(1,1,1)end)
    else
      F.lucide(b,icKey,13,{pos=u2(0,-19,0.5,0),anc=v2(0,0.5),key="text",contrastBg=key or"btnBg",z=102})
    end
    hook(b.MouseButton1Click,function()F.closeCtx();fn()end)
  end
  local viewers=F.msgSeenUsers(m.packetId,m.author)
  if #viewers>0 then
    item("eye",(L=="en"and"Seen by ("or"Đã xem bởi (")..#viewers..")",function()F.openSeenDetail(m)end,"ok")
  end
  item("reply",T("reply"),function()F.startReply(m)end)
  item("forward",(L=="en"and"Forward Message"or"Chuyển tiếp tin nhắn"),function()F.openForward(m)end)
  item("clipboard",T("copy"),function()F.copyText(F.plain(m.content))end)
  if m.author==P.username then item("pencil",T("edit"),function()F.startEdit(m)end)end
  local isSt=F.isStaff(P.username)
  local canDelMsg=isSt or(m.chan~="announce"and m.chan~="punish"and(m.author==P.username or F.canAct(P.username,m.author)))
  if canDelMsg then
    local delLabel=(isSt and m.author~=P.username)and(L=="en"and"Delete Sensitive Msg (Staff)"or"Xóa tin nhạy cảm (Admin/Dev)")or T("delete")
    item("trash",delLabel,function()F.deleteMsg(m)end,"danger")
  end
  if m.author~=P.username then
    item("userRound",T("profile"),function()F.openProfile(m.author)end)
    item("flag",T("report"),function()F.openReport(m.author,m)end,"warn")
    if F.canAct(P.username,m.author)then
      item("alertTri",T("warn"),function()F.openWarn(m.author)end,"warn")
      if #F.getWarns(m.author)>0 then item("rotateCcw",T("clear_warn"),function()F.openClearWarn(m.author)end,"ok")end
      if F.muted(m.author)then item("circleCheck",T("unmute"),function()F.openUnmute(m.author)end,"ok")else item("volumeX",T("mute"),function()F.openMute(m.author)end,"danger")end
    end
  end
end
--- [F.chanName] Lấy tên hiển thị đầy đủ của kênh `c` (bao gồm cả kênh chuẩn, Group DM và kênh chat riêng DM)
function F.chanName(c)if c=="general"then return"# "..T("general")elseif c=="announce"then return"📢 "..T("announcetab")elseif c=="punish"then return T("punish_title")elseif c=="game"then return"# "..T("game")
  elseif c=="scripts"then return T("script_forum")elseif c=="staff"then return T("stafftab")end
  if F.isGroupChan(c)then local g=F.groupByChan(c)return g and("👥 "..F.locText(g.name or"Group"))or"👥 Group"end
  local o=F.dmOther(c)return o and("DM · "..o)or c end
--- [F.updateInfo] Cập nhật thanh thông tin phụ (`U.infoBar`): hiển thị số người đang online, tên kênh và thông tin game
function F.updateInfo()local n=0 for _,r in pairs(S.users)do if F.isLive(r)then n=n+1 end end n=max(n,1)U.infoLbl.Text=n.." "..T("online").."  ·  "..F.chanName(S.chan)..(S.rtt and("  ·  "..floor(S.rtt).."ms")or"")end
--- [F.cancelCompose] Hủy chế độ đang trả lời (Reply) hoặc đang chỉnh sửa (Edit) tin nhắn
function F.cancelCompose()S.reply,S.editing=nil,nil U.replyBar.Visible=false F.layout()end
--- [F.startReply] Bắt đầu chế độ trả lời (Reply) cho tin nhắn `m` kèm biểu tượng Lucide nhận diện rõ ràng
function F.startReply(m)S.editing=nil S.reply={id=m.packetId,author=m.author,snippet=H.clip(F.plain(m.content),80)}
  if U.replyIcon then U.replyIcon.Image=F.LUCIDE.reply end
  U.replyLbl.Text=F.disp(T("reply_to").."@"..tostring(m.author)..": "..tostring(S.reply.snippet))U.replyBar.Visible=true;F.layout();U.input:CaptureFocus()end
--- [F.startEdit] Bắt đầu chế độ chỉnh sửa nội dung cho tin nhắn `m` của chính mình
function F.startEdit(m)S.reply=nil S.editing=m.packetId
  if U.replyIcon then U.replyIcon.Image=F.LUCIDE.pencil end
  U.replyLbl.Text=T("editing")U.replyBar.Visible=true;F.layout()U.input.Text=m.content U.input:CaptureFocus()end
--- [F.deleteMsg] Đánh dấu xóa tin nhắn `m` (Admin/Dev có thể xóa bất kỳ tin nhắn nhạy cảm nào ở mọi kênh) và gửi gói tin `delete` lên máy chủ
function F.deleteMsg(m)if not m then return end
  if not F.isStaff(P.username)and(m.chan=="announce"or m.chan=="punish"or m.author~=P.username)then F.toast(T("staff_only"),true);return end
  m.deleted=true F.dropFrame(m.packetId)F.onDeleted(m)S.isDirty=true
  F.publish({type="delete",target=m.packetId,author=P.username,by=P.username,chan=m.chan})
  if F.isStaff(P.username)and m.author~=P.username then
    F.toast((L=="en"and"Deleted message by @"or"Đã xóa tin nhắn nhạy cảm của @")..tostring(m.author),true)
  end end
--- [F.resend] Thử gửi lại một tin nhắn `m` bị lỗi mạng trước đó (hiển thị trạng thái Đang gửi -> Đã gửi)
function F.resend(m)m.failed=false;m.sending=true;m.sent=false F.dropFrame(m.packetId);F.renderMessage(m)
  local pkt={type="msg",packetId=m.packetId,chan=m.chan,author=m.author,display=m.display,uid=m.uid,content=m.content,ts=m.ts,replyTo=m.replyTo,replyAuthor=m.replyAuthor,replySnippet=m.replySnippet,place=m.place,job=m.job}
  F.publish(pkt,"send",function(ok)
    m.sending=false
    if ok then m.sent=true;m.failed=false;F.updateMsgStatus(m.packetId)
    else m.failed=true;F.dropFrame(m.packetId);F.renderMessage(m)end end)end
--- [F.selectChannel] Chuyển sang kênh chat `chan`, đặt lại bộ đếm chưa đọc, đánh dấu đã xem và vẽ lại danh sách tin nhắn
function F.selectChannel(chan)
  if chan=="staff"and not F.isStaff(P.username)then F.toast(T("staff_only"),true);return end
  S.chan=chan if S.unread[chan]then S.unread[chan]=0 end
  S.dmUnread[chan]=nil S.newBelow=0;U.jump.Visible=false
  S.search="";U.searchBox.Text="";U.searchBox.Visible=false if U.input then
    if chan=="announce"then local canPost=F.canAnnounce(P.username)pcall(function()U.input.TextEditable=canPost end)
      U.input.PlaceholderText=canPost and T("announce_ph")or T("announce_ro")
    elseif chan=="punish"then local isSt=F.isStaff(P.username)pcall(function()U.input.TextEditable=isSt end)
      U.input.PlaceholderText=isSt and T("punish_ph")or T("punish_ro")
    else pcall(function()U.input.TextEditable=true end)U.input.PlaceholderText=T("input")end end
  F.cancelCompose();F.layout()
  F.rebuildFeed();F.paintTabs();F.updateInfo();F.refreshTypingLabel()
  if S.booted then F.markChannelSeen(chan)end end

-- =============================================================================
-- 17. DIỄN ĐÀN CHIA SẺ SCRIPT (SCRIPT FORUM: ĐĂNG BÀI, XEM CODE, LỌC & BÁO CÁO)
-- =============================================================================
F.SCRIPT_TAGS={"All","Saved","Universal","Current Game","Hub / GUI","PVP / Combat","Fun / Misc"}
--- [F.cleanScriptSource] Làm sạch mã nguồn Lua khi đăng/sao chép (loại bỏ cặp dấu ``` markdown và chuẩn hóa dấu nháy)
function F.cleanScriptSource(raw)local s=tostring(raw or"")
  s=s:gsub("^%s*```[%w_%-]*%s+",""):gsub("%s*```%s*$","")s=s:gsub("“",'"'):gsub("”",'"'):gsub("‘","'"):gsub("’","'")s=s:gsub("…$","")return H.trim(s)end
--- [F.doScriptReact] Thả hoặc gỡ cảm xúc cho một chủ đề trong diễn đàn Script (`/api/scripts` action `react`)
function F.doScriptReact(sc,emoji)if not sc or not sc.id then return end
  local t=os.clock()
  if t-S.reactAt<CFG.REACT_THRO then return end
  S.reactAt=t if F.muted(P.username)then F.toast(T("muted"),true);return end sc.reactions=type(sc.reactions)=="table"and sc.reactions or{}
  sc.reactions[emoji]=type(sc.reactions[emoji])=="table"and sc.reactions[emoji]or{}local add=not sc.reactions[emoji][P.username]sc.reactions[emoji][P.username]=add and true or nil
  if not next(sc.reactions[emoji])then sc.reactions[emoji]=nil end
  S.isDirty=true if S.chan=="scripts"then F.rebuildFeed(true)end enqueue("other","POST","/api/scripts",{action="react",by=P.username,id=sc.id,
    emoji=emoji,mode=add and"add"or"remove",},function(d)if d and d.ok and type(d.topic)=="table"then sc.reactions=d.topic.reactions or sc.reactions if S.chan=="scripts"then F.rebuildFeed(true)end end end)end
--- [F.deleteScriptTopics] Xóa một hoặc nhiều chủ đề Script trên máy chủ (`/api/scripts` action `delete`/`delete_multi`)
function F.deleteScriptTopics(ids,onDone)if type(ids)~="table"or#ids==0 then return end
  local idSet={}for _,id in ipairs(ids)do idSet[tostring(id)]=true end enqueue("other","POST","/api/scripts",{
    action=#ids>1 and"delete_multi"or"delete",by=P.username,ids=ids,id=ids[1],},function(d,err)if d and d.ok then if type(d.scripts)=="table"then S.scripts=d.scripts else local keep={}for _,sc in ipairs(S.scripts)do
          if not idSet[tostring(sc.id)]then keep[#keep+1]=sc end end
        S.scripts=keep end
      S.scriptSeq=tonumber(d.scriptSeq)or S.scriptSeq S.isDirty=true F.toast(T("script_deleted").." ("..tostring(d.removed or#ids)..")",true)
      if S.chan=="scripts"then F.rebuildFeed(true)end if onDone then onDone(true)end else F.netError((d and d.error)or err)if onDone then onDone(false)end end end)end
--- [F.openScriptReport] Mở hộp thoại báo cáo một chủ đề Script vi phạm cho đội ngũ Quản trị viên
function F.openScriptReport(sc)if not sc then return end
  local scr,close=F.popup(T("script_report"),340,340)lab(scr,"📜 "..F.disp(sc.title).." (by @"..F.disp(sc.author)..")",{bold=true,ts=12,wrap=true,auto=true,key="accent"})
  local quickReasons={T("script_r_scam"),T("script_r_broken"),T("script_r_spam"),T("script_r_mal")}local rs=field(scr,T("reason"),"",true)lab(scr,T("script_quick_reason"),{ts=10,key="muted",bold=true})
  for _,qr in ipairs(quickReasons)do local qb=tbtn(scr,"• "..qr,{h=26,ts=11,key="btnBg"})qb.TextXAlignment=txL;pad(qb,8,0,8,0)hook(qb.MouseButton1Click,function()rs.Text=qr end)end
  local go=tbtn(scr,T("report"),{key="warn",h=34})hook(go.MouseButton1Click,function()local r=H.trim(rs.Text)if r==""then F.toast(T("need_reason"),true);return end enqueue("other","POST","/api/scripts",{
      action="report",by=P.username,id=sc.id,reason=H.clip(r,300),},function(d,err)if d and d.ok then sc.reports=type(sc.reports)=="table"and sc.reports or{}tinsert(sc.reports,{by=P.username,reason=r,ts=H.now()})
        F.toast(T("report_sent"),true)if type(close)=="function"then close()else F.closeModal()end if S.chan=="scripts"then F.rebuildFeed(true)end else F.netError((d and d.error)or err)end end)end)end
--- [F.openScriptDetail] Mở hộp thoại xem chi tiết một chủ đề Script kèm phần Bình luận (Comments), sao chép, lưu hoặc xóa
function F.openScriptDetail(sc)if not sc then return end
  local scr,close=F.modalBox("📜 "..F.disp(sc.title),410,560)local metaCard=F.card(scr,0);metaCard.AutomaticSize=asY;metaCard.Size=u2(1,0,0,0)
  pad(metaCard,10,8,10,8);list(metaCard,5)local authorRow=mk("Frame",{Size=u2(1,0,0,22),BackgroundTransparency=1},metaCard)
  mk("UIListLayout",{FillDirection=fdH,Padding=u1(0,6),SortOrder=soLO,VerticalAlignment=vaC},authorRow)
  local av=mk("ImageButton",{Size=uo(20,20),BackgroundTransparency=1,Image=F.avatarUrl(sc.uid or F.uidOf(sc.author)),BorderSizePixel=0,LayoutOrder=1},authorRow)corner(av,10)
  hook(av.MouseButton1Click,function()F.openProfile(sc.author)end)local topR=F.topRole(sc.author)local authStr=F.disp(sc.display or sc.author or"?")local authBtn=mk("TextButton",{
    Size=uo(clamp(H.textW(authStr,12,fGB)+4,24,130),20),BackgroundTransparency=1,Text=authStr,Font=fGB,TextSize=12,TextXAlignment=txL,TextTruncate=trEnd,BorderSizePixel=0,LayoutOrder=2,},authorRow)
  if topR then authBtn.TextColor3=H.hex(topR.color)else th(authBtn,"TextColor3","text")end
  hook(authBtn.MouseButton1Click,function()F.openProfile(sc.author)end)if topR then F.roleChip(authorRow,topR,3,false)
  elseif F.isDev(sc.author)then F.roleChip(authorRow,F.DEVROLE,3,false)end lab(metaCard,"["..F.disp(sc.tag or"Universal").."]  ·  "..H.shortTime(sc.ts),{ts=11,bold=true,key="accent"})if sc.desc and sc.desc~=""then
    lab(metaCard,F.disp(sc.desc),{wrap=true,auto=true,ts=12})end if sc.gameName and sc.gameName~=""then lab(metaCard,"🎮 Game: "..F.disp(sc.gameName)..(sc.placeId and sc.placeId>0 and(" ("..tostring(sc.placeId)..")")or""),{
      wrap=true,auto=true,ts=10,key="ok",})end
  F.section(scr,T("script_code"))local codeBox=mk("TextBox",{Size=u2(1,0,0,150),Text=tostring(sc.code or""),ClearTextOnFocus=false,TextEditable=false,MultiLine=true,
    TextWrapped=true,Font=fCode,TextSize=11,TextXAlignment=txL,TextYAlignment=Enum.TextYAlignment.Top,BorderSizePixel=0,},scr)
  F.styleInput(codeBox,"code",true)local act1=row(scr,30)local bCopy=rbtn(act1,T("copy"),{key="accent",size=u2(0.5,-3,1,0)})hook(bCopy.MouseButton1Click,function()F.copyText(tostring(sc.code or""))end)local bReact=rbtn(act1,T("react"),{size=u2(0.5,-3,1,0)})
  hook(bReact.MouseButton1Click,function()F.openEmoji({title=T("react"),onPick=function(e)F.doScriptReact(sc,e)end})end)local act2=row(scr,28)local bProf=rbtn(act2,T("profile"),{ts=11})
  hook(bProf.MouseButton1Click,function()F.openProfile(sc.author)end)local bRep=rbtn(act2,T("report"),{key="warn",ts=11})hook(bRep.MouseButton1Click,function()F.openScriptReport(sc)end)
  sc.comments=type(sc.comments)=="table"and sc.comments or{}
  local cmtSecTitle=F.section(scr,(L=="en"and"💬 Comments ("or"💬 Bình luận (")..#sc.comments..")")
  local cmtInputRow=row(scr,30)
  local cmtBox=mk("TextBox",{Size=u2(0.74,-3,1,0),Text="",PlaceholderText=L=="en"and"Write a comment..."or"Viết bình luận về script này...",ClearTextOnFocus=false,Font=fG,TextSize=11,BorderSizePixel=0,TextXAlignment=txL},cmtInputRow)
  F.styleInput(cmtBox,"text",false)
  local cmtSend=rbtn(cmtInputRow,L=="en"and"Post"or"Gửi",{size=u2(0.26,-3,1,0),key="accent",ts=11})
  local cmtList=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BackgroundTransparency=1},scr)list(cmtList,4)
  local function renderComments()
    for _,c in ipairs(cmtList:GetChildren())do if not c:IsA("UIListLayout")then c:Destroy()end end
    sc.comments=type(sc.comments)=="table"and sc.comments or{}
    pcall(function()for _,ch in ipairs(cmtSecTitle:GetChildren())do if ch:IsA("TextLabel")then ch.Text=string.upper((L=="en"and"💬 Comments ("or"💬 Bình luận (")..#sc.comments..")")end end end)
    if #sc.comments==0 then
      lab(cmtList,L=="en"and"No comments yet. Be the first to comment!"or"Chưa có bình luận nào. Hãy là người đầu tiên bình luận!",{ts=11,key="muted",wrap=true,auto=true})
      return
    end
    for idx,cm in ipairs(sc.comments)do
      local cc=F.card(cmtList,0);cc.AutomaticSize=asY;cc.Size=u2(1,0,0,0);cc.LayoutOrder=idx;pad(cc,8,5,8,5);list(cc,2)
      local chdr=mk("Frame",{Size=u2(1,0,0,18),BackgroundTransparency=1,LayoutOrder=1},cc)
      local cAuth=tostring(cm.author or"?")
      local cDisp=F.disp(cm.display or cAuth)
      local cRole=F.topRole(cAuth)
      local nmBtn=mk("TextButton",{Size=u2(1,-86,1,0),BackgroundTransparency=1,Text="@"..cDisp.." · "..H.shortTime(cm.ts),Font=fGB,TextSize=10,TextXAlignment=txL,TextTruncate=trEnd,BorderSizePixel=0},chdr)
      if cRole then nmBtn.TextColor3=H.hex(cRole.color)else th(nmBtn,"TextColor3","accent")end
      hook(nmBtn.MouseButton1Click,function()F.openProfile(cAuth)end)
      local canDelCmt=F.isStaff(P.username)or cAuth:lower()==P.username:lower()or tostring(sc.author or""):lower()==P.username:lower()
      if canDelCmt then
        local dBtn=tbtn(chdr,"X",{size=uo(20,18),pos=u2(1,-20,0,0),key="danger",ts=9,r=5})
        hook(dBtn.MouseButton1Click,function()
          enqueue("other","POST","/api/scripts",{action="comment_del",by=P.username,id=sc.id,commentId=cm.id},function(d,err)
            if d and d.ok then
              if type(d.topic)=="table"then sc.comments=d.topic.comments or{}else
                for k=#sc.comments,1,-1 do if tostring(sc.comments[k].id)==tostring(cm.id)then tremove(sc.comments,k)end end
              end
              S.isDirty=true;renderComments()
              if S.chan=="scripts"then F.rebuildFeed(true)end
            else F.netError((d and d.error)or err)end
          end)
        end)
      end
      lab(cc,F.disp(cm.content or cm.text or""),{ts=11,wrap=true,auto=true,layout=2})
    end
  end
  hook(cmtSend.MouseButton1Click,function()
    if F.muted(P.username)then F.toast(T("muted"),true);return end
    local txt=H.trim(cmtBox.Text)
    if txt==""then return end
    cmtBox.Text=""
    enqueue("send","POST","/api/scripts",{action="comment",by=P.username,display=P.display,uid=P.userId,id=sc.id,content=H.clip(txt,400)},function(d,err)
      if d and d.ok then
        if type(d.topic)=="table"then sc.comments=d.topic.comments or sc.comments
        elseif type(d.comment)=="table"then sc.comments=sc.comments or{};tinsert(sc.comments,d.comment)end
        S.scriptSeq=tonumber(d.scriptSeq)or S.scriptSeq;S.isDirty=true
        renderComments()
        if S.chan=="scripts"then F.rebuildFeed(true)end
      else F.netError((d and d.error)or err)end
    end)
  end)
  renderComments()
  if F.isStaff(P.username)and type(sc.reports)=="table"and#sc.reports>0 then F.section(scr,T("script_reports_hdr").." ("..#sc.reports..")")for _,rp in ipairs(sc.reports)do
      local rc=F.card(scr,0);rc.AutomaticSize=asY;rc.Size=u2(1,0,0,0)pad(rc,8,5,8,5);list(rc,2)lab(rc,"@"..F.disp(rp.by or"?").." · "..H.shortTime(rp.ts),{ts=10,bold=true,key="warn"})
      lab(rc,F.disp(rp.reason or""),{ts=11,wrap=true,auto=true})end end if F.isStaff(P.username)or tostring(sc.author):lower()==P.username:lower()then local bDel=tbtn(scr,T("script_del_this"),{key="danger",h=32})
    hook(bDel.MouseButton1Click,function()F.deleteScriptTopics({sc.id},function(ok)if ok then if type(close)=="function"then close()else F.closeModal()end end end)end)end end
--- [F.openScriptComposer] Mở hộp thoại đăng tải một chủ đề chia sẻ Script mới lên diễn đàn `#scripts`
function F.openScriptComposer()
  if F.muted(P.username)then F.toast(T("muted"),true);return end if S.banned then F.toast(T("banned_you"),true);return end
  local scr,close=F.modalBox("+ "..T("script_new"),400,560)
  local titleBox=field(scr,T("script_title"),"")titleBox.PlaceholderText=T("script_title_ph")lab(scr,T("script_tag"),{h=14,ts=10,bold=true,key="muted"})local chosenTag="Universal"
  local tagRow=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BackgroundTransparency=1},scr)mk("UIListLayout",{FillDirection=fdH,Wraps=true,Padding=u1(0,4),SortOrder=soLO},tagRow)local tagBtns={}
  local postTags={"Universal","Current Game","Hub / GUI","PVP / Combat","Fun / Misc"}
  local function paintTags()for t,b in pairs(tagBtns)do local on=(t==chosenTag)b.BackgroundColor3=on and TH.accent or TH.btnBg b.TextColor3=on and(H.lum(TH.accent)>0.55 and rgb(20,20,24)or c3(1,1,1))or TH.text end end
  for i,tg in ipairs(postTags)do local b=tbtn(tagRow,tg=="Current Game"and("🎮 "..H.clip(S.placeName~="?"and S.placeName or T("tag_cur_game"),18))or tg,{size=uo(112,26),ts=10,r=13,layout=i,})tagBtns[tg]=b
    hook(b.MouseButton1Click,function()chosenTag=tg;paintTags()end)end paintTags()local descBox=field(scr,T("script_desc"),"",true)descBox.PlaceholderText=T("script_desc_ph")local codeHdr=row(scr,22)
  lab(codeHdr,T("script_code"),{size=u2(1,-120,1,0),ts=10,bold=true,key="muted"})local codeBox if type(getclipboard)=="function"then local pst=tbtn(codeHdr,T("script_paste"),{size=uo(114,22),ts=10,key="btnBg",r=6})
    hook(pst.MouseButton1Click,function()pcall(function()local clipStr=getclipboard()if type(clipStr)=="string"and clipStr~=""and codeBox then codeBox.Text=clipStr end end)end)end codeBox=mk("TextBox",{
    Size=u2(1,0,0,120),Text="",PlaceholderText='loadstring(game:HttpGet("https://..."))()',ClearTextOnFocus=false,MultiLine=true,TextWrapped=true,Font=fCode,TextSize=11,TextXAlignment=txL,
    TextYAlignment=Enum.TextYAlignment.Top,BorderSizePixel=0,},scr)F.styleInput(codeBox,"code",true)
  local submit=tbtn(scr,"+ "..T("script_new"),{key="accent",h=36,ts=13})hook(submit.MouseButton1Click,function()local ttl=H.trim(titleBox.Text)local cd=F.cleanScriptSource(codeBox.Text)local ds=H.trim(descBox.Text)
    if ttl==""or cd==""then F.toast(T("script_need_fields"),true)return end
    local finalTag=chosenTag=="Current Game"and H.clip(S.placeName~="?"and S.placeName or"Game",22)or chosenTag enqueue("send","POST","/api/scripts",{
      action="create",by=P.username,display=P.display,uid=P.userId,title=H.clip(ttl,80),tag=finalTag,desc=H.clip(ds,300),code=cd:sub(1,15000),placeId=game.PlaceId,gameName=S.placeName,},function(d,err)
      if d and d.ok then if type(d.scripts)=="table"then S.scripts=d.scripts elseif type(d.topic)=="table"then tinsert(S.scripts,d.topic)end
        S.scriptSeq=tonumber(d.scriptSeq)or S.scriptSeq S.isDirty=true
        if type(close)=="function"then close()else F.closeModal()end
        F.toast(T("script_post_ok"),true)if S.chan=="scripts"then F.rebuildFeed(true)end else F.netError((d and d.error)or err)end end)end)end
--- [F.renderScriptForum] Vẽ giao diện diễn đàn chia sẻ Script (thanh công cụ, bộ lọc Tag, tìm kiếm và danh sách thẻ Script kèm Bình luận)
function F.renderScriptForum()local staff=F.isStaff(P.username)local topBar=mk("Frame",{Size=u2(1,-4,0,0),AutomaticSize=asY,BorderSizePixel=0,LayoutOrder=1,},U.scroll)
  th(topBar,"BackgroundColor3","bg2",true);corner(topBar,10);pad(topBar,8,8,8,8);list(topBar,6)local row1=row(topBar,30);row1.LayoutOrder=1 local postBtn=rbtn(row1,"+ "..T("script_new"),{key="accent",
    size=staff and u2(0.54,-3,1,0)or u2(1,0,1,0),ts=12,})hook(postBtn.MouseButton1Click,F.openScriptComposer)if staff then local multiBtn=rbtn(row1,(S.scriptMultiMode and"[x] "or"[ ] ")..T("script_multi"),{
      key=S.scriptMultiMode and"warn"or"btnBg",size=u2(0.46,-3,1,0),ts=11,})hook(multiBtn.MouseButton1Click,function()S.scriptMultiMode=not S.scriptMultiMode if not S.scriptMultiMode then S.scriptSelected={}end
      F.rebuildFeed(true)end)end if staff and S.scriptMultiMode then local selCount=0 for _ in pairs(S.scriptSelected)do selCount=selCount+1 end
    local bulkRow=row(topBar,28);bulkRow.LayoutOrder=2
    local bAll=rbtn(bulkRow,T("script_sel_all"),{size=u2(0.28,-3,1,0),ts=10})hook(bAll.MouseButton1Click,function()for _,sc in ipairs(S.scripts or{})do S.scriptSelected[tostring(sc.id)]=true end F.rebuildFeed(true)end)
    local bClr=rbtn(bulkRow,T("script_unsel"),{size=u2(0.26,-3,1,0),ts=10})hook(bClr.MouseButton1Click,function()S.scriptSelected={}F.rebuildFeed(true)end)
    local bDel=rbtn(bulkRow,T("script_del_sel").." ("..selCount..")",{size=u2(0.46,-3,1,0),ts=10,key="danger",})hook(bDel.MouseButton1Click,function()local ids={}
      for id in pairs(S.scriptSelected)do ids[#ids+1]=id end if#ids==0 then return end
      F.deleteScriptTopics(ids,function(ok)if ok then S.scriptSelected={};S.scriptMultiMode=false end end)end)end
  local tagScroll=mk("ScrollingFrame",{Size=u2(1,0,0,24),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=0,CanvasSize=u2(),AutomaticCanvasSize=asX,
    ScrollingDirection=Enum.ScrollingDirection.X,LayoutOrder=3,},topBar)mk("UIListLayout",{FillDirection=fdH,Padding=u1(0,4),SortOrder=soLO,VerticalAlignment=vaC},tagScroll)for i,tg in ipairs(F.SCRIPT_TAGS)do
    local on=(S.scriptTagFilter or"All")==tg local dispTag=tg=="All"and T("tag_all")or(tg=="Saved"and T("tag_saved")or(tg=="Current Game"and T("tag_cur_game")or tg))local tgW=max(44,H.textW(dispTag,10,fGB)+18)
    local b=mk("TextButton",{Size=uo(tgW,22),Text=dispTag,Font=fGB,TextSize=10,BorderSizePixel=0,LayoutOrder=i,},tagScroll)th(b,"BackgroundColor3",on and"accent"or"btnBg")if on then
      themed(b,function(x)x.TextColor3=H.lum(TH.accent)>0.55 and rgb(20,20,24)or c3(1,1,1)end)else th(b,"TextColor3","muted")end corner(b,11)hook(b.MouseButton1Click,function()S.scriptTagFilter=tg F.rebuildFeed(true)end)
  end
  local q=H.trim(S.search or""):lower()local filtered={}for i=#(S.scripts or{}),1,-1 do local sc=S.scripts[i]if type(sc)=="table"and sc.id then local tagOk=(S.scriptTagFilter=="All"or not S.scriptTagFilter)
      or(S.scriptTagFilter=="Saved"and P.savedScripts and P.savedScripts[tostring(sc.id)]==true)or(S.scriptTagFilter=="Current Game"and tonumber(sc.placeId)==game.PlaceId)
      or(tostring(sc.tag or""):lower()==tostring(S.scriptTagFilter):lower())local searchOk=q==""or tostring(sc.title or""):lower():find(q,1,true)~=nil or tostring(sc.desc or""):lower():find(q,1,true)~=nil
      or tostring(sc.author or""):lower():find(q,1,true)~=nil or tostring(sc.tag or""):lower():find(q,1,true)~=nil if tagOk and searchOk then filtered[#filtered+1]=sc end end end if#filtered==0 then
    local emptyCard=F.card(U.scroll,64);emptyCard.LayoutOrder=2 pad(emptyCard,12,10,12,10)lab(emptyCard,T("script_empty"),{wrap=true,auto=true,ts=11,key="muted",align=txC})return end for idx,sc in ipairs(filtered)do
    local sid=tostring(sc.id)local isSel=S.scriptSelected[sid]==true local canDel=staff or(tostring(sc.author or""):lower()==P.username:lower())local rptCount=type(sc.reports)=="table"and#sc.reports or 0
    local cmtCount=type(sc.comments)=="table"and#sc.comments or 0
    local card=mk("Frame",{Size=u2(1,-4,0,0),AutomaticSize=asY,BorderSizePixel=0,LayoutOrder=idx+10,},U.scroll)th(card,"BackgroundColor3",isSel and"mention"or"bg2",true)corner(card,12)pad(card,12,8,10,8)list(card,5)
    local topR=F.topRole(sc.author)local barCol=(topR and H.hex(topR.color))or(F.isDev(sc.author)and H.hex(F.DEVROLE.color))or TH.accent mk("UIStroke",{Color=isSel and TH.danger or barCol,Thickness=isSel and 2 or 1,
      Transparency=isSel and 0.15 or 0.65,ApplyStrokeMode=smBorder,},card)local metaTop=mk("Frame",{Size=u2(1,0,0,20),BackgroundTransparency=1,LayoutOrder=1},card)
    mk("UIListLayout",{FillDirection=fdH,Padding=u1(0,5),SortOrder=soLO,VerticalAlignment=vaC},metaTop)if staff and S.scriptMultiMode then local chkBtn=tbtn(metaTop,isSel and"x"or"",{
        size=uo(22,20),ts=11,key=isSel and"danger"or"btnBg",r=6,layout=0,})hook(chkBtn.MouseButton1Click,function()S.scriptSelected[sid]=not S.scriptSelected[sid]or nil F.rebuildFeed(true)end)end
    local tgStr=F.disp(sc.tag or"Universal")local tgPillW=clamp(H.textW(tgStr,10,fGB)+14,42,130)local tagPill=mk("Frame",{Size=uo(tgPillW,18),BorderSizePixel=0,LayoutOrder=1},metaTop)
    th(tagPill,"BackgroundColor3","bg3");corner(tagPill,9)lab(tagPill,tgStr,{size=us(1,1),ts=10,bold=true,key="accent",align=txC,trunc=true})local tmStr=H.shortTime(sc.ts)
    lab(metaTop,"· "..tmStr,{size=uo(H.textW(tmStr,10,fG)+14,18),ts=10,key="muted",layout=2})if staff and rptCount>0 then lab(metaTop,"! "..rptCount,{size=uo(38,18),ts=10,bold=true,key="warn",layout=3})end
    local titleBtn=mk("TextButton",{Size=u2(1,0,0,20),BackgroundTransparency=1,Text=F.disp(sc.title or"Untitled"),Font=fGB,TextSize=13,TextXAlignment=txL,TextTruncate=trEnd,BorderSizePixel=0,LayoutOrder=2,},card)
    th(titleBtn,"TextColor3","text")hook(titleBtn.MouseButton1Click,function()F.openScriptDetail(sc)end)local metaRow=mk("Frame",{Size=u2(1,0,0,20),BackgroundTransparency=1,LayoutOrder=3},card)
    mk("UIListLayout",{FillDirection=fdH,Padding=u1(0,5),SortOrder=soLO,VerticalAlignment=vaC},metaRow)
    local av=mk("ImageButton",{Size=uo(18,18),BackgroundTransparency=1,Image=F.avatarUrl(sc.uid or F.uidOf(sc.author)),BorderSizePixel=0,LayoutOrder=1},metaRow)corner(av,9)
    hook(av.MouseButton1Click,function()F.openProfile(sc.author)end)local authStr=F.disp(sc.display or sc.author or"?")local authW=clamp(H.textW(authStr,11,fGB)+4,20,120)local authBtn=mk("TextButton",{Size=uo(authW,18),
      BackgroundTransparency=1,Text=authStr,Font=fGB,TextSize=11,TextXAlignment=txL,TextTruncate=trEnd,BorderSizePixel=0,LayoutOrder=2,},metaRow)
    if topR then authBtn.TextColor3=H.hex(topR.color)else th(authBtn,"TextColor3","text")end
    hook(authBtn.MouseButton1Click,function()F.openProfile(sc.author)end)if topR then F.roleChip(metaRow,topR,3,false)
    elseif F.isDev(sc.author)then F.roleChip(metaRow,F.DEVROLE,3,false)end if sc.desc and sc.desc~=""then lab(card,F.disp(H.clip(sc.desc,160)),{wrap=true,auto=true,ts=11,key="muted",layout=4})end
    local codePv=mk("TextButton",{Size=u2(1,0,0,38),Text=H.clip(tostring(sc.code or""),120),Font=fCode,TextSize=10,TextXAlignment=txL,TextYAlignment=Enum.TextYAlignment.Top,TextWrapped=true,TextTruncate=trEnd,
      BorderSizePixel=0,LayoutOrder=5,},card)th(codePv,"BackgroundColor3","inputBg");th(codePv,"TextColor3","text")corner(codePv,7);stroke(codePv,"inputBorder",1,0.2);pad(codePv,8,5,8,5)hook(codePv.MouseButton1Click,function()F.openScriptDetail(sc)end)
    local actRow=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BackgroundTransparency=1,LayoutOrder=6,ZIndex=8,},card)mk("UIListLayout",{FillDirection=fdH,Wraps=true,Padding=u1(0,5),SortOrder=soLO,
      VerticalAlignment=vaC,},actRow)local bCopy=tbtn(actRow,T("copy"),{size=uo(54,26),ts=11,key="accent",r=6,layout=1})bCopy.ZIndex=10 hook(bCopy.MouseButton1Click,function()F.copyText(tostring(sc.code or""))end)
    local bView=tbtn(actRow,T("script_view"),{size=uo(50,26),ts=11,key="btnBg",r=6,layout=2})bView.ZIndex=10 hook(bView.MouseButton1Click,function()F.openScriptDetail(sc)end)
    local bCmt=tbtn(actRow,"💬 "..tostring(cmtCount),{size=uo(48,26),ts=11,key=cmtCount>0 and"ok"or"btnBg",r=6,layout=3})bCmt.ZIndex=10 hook(bCmt.MouseButton1Click,function()F.openScriptDetail(sc)end)
    local isSaved=P.savedScripts and P.savedScripts[sid]==true local bSave=tbtn(actRow,isSaved and T("tag_saved")or T("save"),{size=uo(52,26),ts=10,key=isSaved and"warn"or"btnBg",r=6,layout=4})bSave.ZIndex=10
    hook(bSave.MouseButton1Click,function()P.savedScripts=P.savedScripts or{}if P.savedScripts[sid]then P.savedScripts[sid]=nil else P.savedScripts[sid]=true end S.isDirty=true F.rebuildFeed(true)end)
    local bEmo=tbtn(actRow,"😀+",{size=uo(36,26),ts=11,key="btnBg",r=6,layout=5})bEmo.ZIndex=10 hook(bEmo.MouseButton1Click,function()
      F.openEmoji({title=T("react").." · "..H.clip(sc.title,20),onPick=function(e)F.doScriptReact(sc,e)end})end)local bRep=tbtn(actRow,T("report"),{size=uo(52,26),ts=10,key="warn",r=6,layout=6})bRep.ZIndex=10
    hook(bRep.MouseButton1Click,function()F.openScriptReport(sc)end)if canDel then local bDel=tbtn(actRow,T("delete"),{size=uo(46,26),ts=10,key="danger",r=6,layout=7})bDel.ZIndex=10 hook(bDel.MouseButton1Click,function()
        F.deleteScriptTopics({sid})end)end
    local rxMap=type(sc.reactions)=="table"and sc.reactions or{}local rxKeys={}for em,usrs in pairs(rxMap)do if type(usrs)=="table"and next(usrs)then rxKeys[#rxKeys+1]=em end end
    tsort(rxKeys)if#rxKeys>0 then local rxHolder=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BackgroundTransparency=1,LayoutOrder=7,},card)
      mk("UIListLayout",{FillDirection=fdH,Wraps=true,Padding=u1(0,4),SortOrder=soLO,VerticalAlignment=vaC},rxHolder)for rxi,em in ipairs(rxKeys)do local n=0 for _ in pairs(rxMap[em])do n=n+1 end
        local mine=rxMap[em][P.username]==true F.makeReactionPill(rxHolder,em,n,mine,rxi,function()F.doScriptReact(sc,em)end)end end end end
--- [F.punishStyle] Lấy nhãn tiêu đề, khóa màu sắc, biểu tượng và cờ gỡ phạt (isRelief) cho từng loại hành động xử phạt
function F.punishStyle(act)
  act=tostring(act or"warn")
  if act=="mute"then return T("act_mute"),"danger","🔇",false
  elseif act=="unmute"then return T("act_unmute"),"ok","🔊",true
  elseif act=="clear_warn"then return T("act_clear_warn"),"ok","🧹",true
  elseif act=="ban"then return T("act_ban"),"danger","⛔",false
  elseif act=="unban"then return T("act_unban"),"ok","🔓",true
  elseif act=="revoke"then return T("act_revoke"),"danger","⛔",false
  else return T("act_warn"),"warn","⚠️",false end
end
--- [F.renderPunishChannel] Vẽ giao diện kênh thông báo xử phạt & gỡ phạt (#punish): hiển thị trạng thái kỷ luật của bản thân, thanh công cụ Staff, bộ lọc và danh sách thông báo Warn/ClearWarn/Mute/Unmute/Ban/Unban kèm lý do
function F.renderPunishChannel()
  local staff=F.isStaff(P.username)
  local myMute=F.getMute(P.username)
  local myWarns=F.getWarns(P.username)
  local myBan=F.getBan(P.username)
  local hasIssue=(myBan~=nil)or(myMute~=nil)or(#myWarns>0)
  local statusCard=mk("Frame",{Size=u2(1,-4,0,0),AutomaticSize=asY,BorderSizePixel=0,LayoutOrder=1},U.scroll)
  th(statusCard,"BackgroundColor3","bg2",true);corner(statusCard,10);pad(statusCard,10,8,10,8);list(statusCard,5)
  stroke(statusCard,hasIssue and((myBan or myMute)and"danger"or"warn")or"ok",1.3,0.25)
  local sHdr=row(statusCard,22);sHdr.LayoutOrder=1
  lab(sHdr,"🚨 "..T("punish_my_hdr"),{size=u2(1,-96,1,0),ts=11,bold=true,key=hasIssue and"warn"or"ok",trunc=true})
  local myProfBtn=tbtn(sHdr,T("profile"),{size=uo(90,22),ts=10,key="accent",r=6})
  hook(myProfBtn.MouseButton1Click,function()F.openProfile(P.username)end)
  if not hasIssue then
    lab(statusCard,T("punish_clean"),{wrap=true,auto=true,ts=11,key="muted",layout=2})
  else
    if myBan then
      local bc=F.card(statusCard,0);bc.AutomaticSize=asY;bc.Size=u2(1,0,0,0);bc.LayoutOrder=2;pad(bc,8,6,8,6);list(bc,3);stroke(bc,"danger",1,0.3)
      lab(bc,T("active_ban_hdr")..(myBan.by and myBan.by~=""and(" · @"..F.disp(myBan.by))or""),{ts=11,bold=true,key="danger",wrap=true,auto=true})
      lab(bc,"📝 "..T("reason_lbl")..F.disp(myBan.reason~=""and F.locText(myBan.reason)or T("no_reason")),{ts=11,wrap=true,auto=true})
    end
    if myMute then
      local mc=F.card(statusCard,0);mc.AutomaticSize=asY;mc.Size=u2(1,0,0,0);mc.LayoutOrder=3;pad(mc,8,6,8,6);list(mc,3);stroke(mc,"danger",1,0.3)
      lab(mc,T("active_mute_hdr").." · "..T("duration_lbl")..F.fmtExpire(myMute.exp)..(myMute.by and myMute.by~=""and(" · @"..F.disp(myMute.by))or""),{ts=11,bold=true,key="danger",wrap=true,auto=true})
      lab(mc,"📝 "..T("reason_lbl")..F.disp(myMute.reason~=""and F.locText(myMute.reason)or T("no_reason")),{ts=11,wrap=true,auto=true})
    end
    if #myWarns>0 then
      local lastW=myWarns[#myWarns]
      local wc=F.card(statusCard,0);wc.AutomaticSize=asY;wc.Size=u2(1,0,0,0);wc.LayoutOrder=4;pad(wc,8,6,8,6);list(wc,3);stroke(wc,"warn",1,0.3)
      lab(wc,T("active_warn_hdr")..": "..#myWarns.." "..T("warnings")..(lastW and lastW.by and((L=="en"and" (Latest by @"or" (Gần nhất bởi @")..F.disp(lastW.by)..")")or""),{ts=11,bold=true,key="warn",wrap=true,auto=true})
      if lastW then lab(wc,"📝 "..T("reason_lbl")..F.disp(lastW.reason~=""and F.locText(lastW.reason)or T("no_reason")),{ts=11,wrap=true,auto=true})end
    end
  end
  if staff then
    local modBar=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BackgroundTransparency=1,LayoutOrder=5},statusCard)
    mk("UIGridLayout",{CellSize=u2(1/3,-4,0,26),CellPadding=uo(5,5),SortOrder=soLO},modBar)
    local bW=tbtn(modBar,"⚠️ "..T("warn"),{key="warn",ts=10,r=6,layout=1})hook(bW.MouseButton1Click,function()F.openWarn("")end)
    local bCw=tbtn(modBar,"🧹 "..T("clear_warn"),{key="ok",ts=10,r=6,layout=2})hook(bCw.MouseButton1Click,function()F.openClearWarn("")end)
    local bM=tbtn(modBar,"🔇 "..T("mute"),{key="danger",ts=10,r=6,layout=3})hook(bM.MouseButton1Click,function()F.openMute("")end)
    local bUm=tbtn(modBar,"🔊 "..T("unmute"),{key="ok",ts=10,r=6,layout=4})hook(bUm.MouseButton1Click,function()F.openUnmute("")end)
    local bBn=tbtn(modBar,"⛔ "..T("ban"),{key="danger",ts=10,r=6,layout=5})hook(bBn.MouseButton1Click,function()F.openBan("")end)
    local bUb=tbtn(modBar,"🔓 "..T("unban"),{key="ok",ts=10,r=6,layout=6})hook(bUb.MouseButton1Click,function()F.openUnban("")end)
  end
  local fScroll=mk("ScrollingFrame",{Size=u2(1,0,0,24),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=0,CanvasSize=u2(),AutomaticCanvasSize=asX,ScrollingDirection=Enum.ScrollingDirection.X,LayoutOrder=6},statusCard)
  mk("UIListLayout",{FillDirection=fdH,Padding=u1(0,4),SortOrder=soLO,VerticalAlignment=vaC},fScroll)
  local filterDefs={{"all","pf_all"},{"mine","pf_mine"},{"warn","pf_warn"},{"mute","pf_mute"},{"ban","pf_ban"}}
  for fi,fd in ipairs(filterDefs)do
    local on=(S.punishFilter or"all")==fd[1]
    local lblTxt=T(fd[2])
    local fw=max(46,H.textW(lblTxt,10,fGB)+16)
    local fb=mk("TextButton",{Size=uo(fw,22),Text=lblTxt,Font=fGB,TextSize=10,BorderSizePixel=0,LayoutOrder=fi},fScroll)
    th(fb,"BackgroundColor3",on and"accent"or"btnBg")
    if on then themed(fb,function(x)x.TextColor3=H.lum(TH.accent)>0.55 and rgb(20,20,24)or c3(1,1,1)end)else th(fb,"TextColor3","muted")end
    corner(fb,11)
    hook(fb.MouseButton1Click,function()S.punishFilter=fd[1];F.rebuildFeed(true)end)
  end
  local q=H.trim(S.search or""):lower()
  local curF=S.punishFilter or"all"
  local listItems={}
  for i=#(S.punishments or{}),1,-1 do
    local p=S.punishments[i]
    if type(p)=="table"then
      local act=tostring(p.action or"warn")
      local fOk=(curF=="all")
        or(curF=="mine"and tostring(p.target or""):lower()==P.username:lower())
        or(curF=="warn"and(act=="warn"or act=="clear_warn"))
        or(curF=="mute"and(act=="mute"or act=="unmute"))
        or(curF=="ban"and(act=="ban"or act=="unban"or act=="revoke"))
      local match=q==""or tostring(p.target or""):lower():find(q,1,true)~=nil or tostring(p.by or""):lower():find(q,1,true)~=nil or tostring(p.reason or""):lower():find(q,1,true)~=nil or act:lower():find(q,1,true)~=nil
      if fOk and match then listItems[#listItems+1]=p end
    end
  end
  if #listItems==0 then
    local emptyCard=F.card(U.scroll,60);emptyCard.LayoutOrder=2;pad(emptyCard,12,10,12,10)
    lab(emptyCard,T("punish_empty"),{wrap=true,auto=true,ts=11,key="muted",align=txC})
    return
  end
  for idx,p in ipairs(listItems)do
    local actLabel,colKey,_,isRelief=F.punishStyle(p.action)
    local isMe=tostring(p.target or""):lower()==P.username:lower()
    local card=mk("Frame",{Size=u2(1,-4,0,0),AutomaticSize=asY,BorderSizePixel=0,LayoutOrder=idx+10},U.scroll)
    th(card,"BackgroundColor3",isMe and"mention"or"bg2",true);corner(card,10);pad(card,12,8,10,8);list(card,5)
    stroke(card,colKey,isMe and 1.8 or 1.1,isMe and 0.1 or 0.45)
    local bar=mk("Frame",{Size=u2(0,4,1,-8),Position=uo(0,4),BorderSizePixel=0,ZIndex=2},card)th(bar,"BackgroundColor3",colKey);corner(bar,2)
    local topR=mk("Frame",{Size=u2(1,0,0,20),BackgroundTransparency=1,LayoutOrder=1},card)
    mk("UIListLayout",{FillDirection=fdH,Padding=u1(0,5),SortOrder=soLO,VerticalAlignment=vaC},topR)
    local pillW=clamp(H.textW(actLabel,10,fGB)+14,68,215)
    local badge=mk("Frame",{Size=uo(pillW,18),BorderSizePixel=0,LayoutOrder=1},topR)
    th(badge,"BackgroundColor3",colKey);corner(badge,9)
    local bLbl=lab(badge,actLabel,{size=us(1,1),ts=10,bold=true,align=txC,trunc=true})
    themed(bLbl,function(x)x.TextColor3=H.lum(TH[colKey])>0.55 and rgb(20,20,24)or c3(1,1,1)end)
    if isMe then
      local meTxt=isRelief and T("punish_you_ok")or T("punish_you")
      local meKey=isRelief and"ok"or"danger"
      local meW=clamp(H.textW(meTxt,9,fGB)+12,60,165)
      local mePill=mk("Frame",{Size=uo(meW,18),BorderSizePixel=0,LayoutOrder=2},topR)
      th(mePill,"BackgroundColor3",meKey);corner(mePill,9)
      local ml=lab(mePill,meTxt,{size=us(1,1),ts=9,bold=true,align=txC,trunc=true})
      themed(ml,function(x)x.TextColor3=H.lum(TH[meKey])>0.55 and rgb(20,20,24)or c3(1,1,1)end)
    end
    local tmStr=F.fmtTimeFull(p.ts)
    lab(topR,"· "..tmStr,{size=uo(H.textW(tmStr,10,fG)+16,18),ts=10,key="muted",layout=3})
    local whoRow=mk("Frame",{Size=u2(1,0,0,24),BackgroundTransparency=1,LayoutOrder=2},card)
    mk("UIListLayout",{FillDirection=fdH,Padding=u1(0,6),SortOrder=soLO,VerticalAlignment=vaC},whoRow)
    local av=mk("ImageButton",{Size=uo(22,22),BackgroundTransparency=1,Image=F.avatarUrl(F.uidOf(p.target)),BorderSizePixel=0,LayoutOrder=1},whoRow)corner(av,11)
    hook(av.MouseButton1Click,function()F.openProfile(p.target)end)
    local tgStr="@"..F.disp(p.target or"?")
    local tgBtn=mk("TextButton",{Size=uo(clamp(H.textW(tgStr,12,fGB)+6,30,140),22),BackgroundTransparency=1,Text=tgStr,Font=fGB,TextSize=12,TextXAlignment=txL,TextTruncate=trEnd,BorderSizePixel=0,LayoutOrder=2},whoRow)
    th(tgBtn,"TextColor3",colKey)
    hook(tgBtn.MouseButton1Click,function()F.openProfile(p.target)end)
    local byStr="👮 "..T("by_staff").."@"..F.disp(p.by or"?")
    local byBtn=mk("TextButton",{Size=uo(clamp(H.textW(byStr,11,fG)+8,50,180),22),BackgroundTransparency=1,Text=byStr,Font=fG,TextSize=11,TextXAlignment=txL,TextTruncate=trEnd,BorderSizePixel=0,LayoutOrder=3},whoRow)
    th(byBtn,"TextColor3","muted")
    hook(byBtn.MouseButton1Click,function()if p.by and p.by~=""then F.openProfile(p.by)end end)
    if p.action=="mute"then
      lab(card,"⏳ "..T("duration_lbl")..F.fmtExpire(p.exp),{ts=11,bold=true,key="warn",layout=3,wrap=true,auto=true})
    end
    local rBox=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BorderSizePixel=0,LayoutOrder=4},card)
    th(rBox,"BackgroundColor3","inputBg");corner(rBox,7);stroke(rBox,colKey,1,0.55);pad(rBox,8,6,8,6)
    local rText=H.trim(p.reason or"")
    lab(rBox,"📝 "..T("reason_lbl")..F.disp(rText~=""and F.locText(rText)or T("no_reason")),{wrap=true,auto=true,ts=11,key="text"})
    local actRow=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BackgroundTransparency=1,LayoutOrder=5},card)
    mk("UIListLayout",{FillDirection=fdH,Wraps=true,Padding=u1(0,5),SortOrder=soLO,VerticalAlignment=vaC},actRow)
    local bProf=tbtn(actRow,"👤 "..T("profile").." @"..H.clip(p.target or"?",14),{size=uo(135,24),ts=10,key="accent",r=6,layout=1})
    hook(bProf.MouseButton1Click,function()F.openProfile(p.target)end)
    if F.canAct(P.username,p.target)then
      if p.action=="mute"and F.muted(p.target)then
        local bUm=tbtn(actRow,"🔊 "..T("unmute"),{size=uo(82,24),ts=10,key="ok",r=6,layout=2})
        hook(bUm.MouseButton1Click,function()F.openUnmute(p.target)end)
      elseif p.action=="warn"and #F.getWarns(p.target)>0 then
        local bCw=tbtn(actRow,"🧹 "..T("clear_warn"),{size=uo(98,24),ts=10,key="ok",r=6,layout=3})
        hook(bCw.MouseButton1Click,function()F.openClearWarn(p.target)end)
      elseif p.action=="ban"and F.getBan(p.target)then
        local bUb=tbtn(actRow,"🔓 "..T("unban"),{size=uo(82,24),ts=10,key="ok",r=6,layout=4})
        hook(bUb.MouseButton1Click,function()F.openUnban(p.target)end)
      end
    end
    if staff then
      local bDel=tbtn(actRow,T("delete"),{size=uo(52,24),ts=10,key="danger",r=6,layout=9})
      hook(bDel.MouseButton1Click,function()
        local keep={}for _,x in ipairs(S.punishments)do if x.id~=p.id then keep[#keep+1]=x end end
        S.punishments=keep;S.isDirty=true
        F.publish({type="punish_del",target=p.id,id=p.id,by=P.username,chan="punish"})
        F.rebuildFeed(true)
      end)
    end
  end
end
--- [F.rebuildFeed] Xóa triệt để các khung cũ (tránh bóng ma tin nhắn) và vẽ lại nội dung khung cuộn chính (`U.scroll`) theo kênh đang chọn
function F.rebuildFeed(keepScroll)
  S.feedGen=(S.feedGen or 0)+1 local myGen=S.feedGen
  local savedCanvas=keepScroll and U.scroll.CanvasPosition or nil
  for _,c in ipairs(U.scroll:GetChildren())do if c:IsA("GuiObject")then pcall(function()c.Visible=false;c.Size=uo(0,0);c.Parent=nil;c:Destroy()end)end end
  S.frames,S.frameQ,S.rxHolders,S.statusLabels={},{},{},{}F.pruneThemeReg()
  if S.chan=="scripts"then F.renderScriptForum()if savedCanvas then
      task.defer(function()if U.scroll.Parent then U.scroll.CanvasPosition=savedCanvas end end)end return end
  if S.chan=="punish"then F.renderPunishChannel()if savedCanvas then
      task.defer(function()if U.scroll.Parent then U.scroll.CanvasPosition=savedCanvas end end)end return end
  if S.chan=="announce"then
    local aHdr=mk("Frame",{Name="AnnounceHdr",Size=u2(1,-4,0,0),AutomaticSize=asY,BorderSizePixel=0,LayoutOrder=-10},U.scroll)pcall(function()aHdr:SetAttribute("FeedGen",myGen)end)th(aHdr,"BackgroundColor3","bg2",true);corner(aHdr,10);pad(aHdr,8,6,8,6);list(aHdr,3)
    lab(aHdr,T("announce_perm_note"),{wrap=true,auto=true,ts=10,bold=true,key="accent",align=txC})
    if not F.canAnnounce(P.username)then lab(aHdr,T("announce_ro"),{wrap=true,auto=true,ts=10,key="warn",align=txC})end
  end
  local items={}for _,id in ipairs(S.order)do local m=S.msgs[id]if m then
      if F.visibleIn(m,S.chan)and F.matchSearch(m)then items[#items+1]=m end else local p=S.polls[id]if p and not p.cleared and p.chan==S.chan and S.search==""then items[#items+1]=p end end end
  local startIdx=(S.chan=="announce")and 1 or max(1,#items-CFG.MAX_RENDER+1)
  for i=startIdx,#items do local it=items[i]if it.isPoll then F.renderPoll(it)else F.renderMessage(it)end end
  F.sweepGhostFrames()task.defer(function()if S.feedGen==myGen then F.sweepGhostFrames()end end)
  if savedCanvas then task.defer(function()if U.scroll.Parent then U.scroll.CanvasPosition=savedCanvas end end)else F.scrollBottom()end end for _,p in pairs(S.polls)do p.isPoll=true;p.votes=type(p.votes)=="table"and p.votes or{}end

-- =============================================================================
-- 18. HỆ THỐNG BÌNH CHỌN (POLLS), ĐỒNG BỘ PRESENCE & HỒ SƠ CÁ NHÂN (PROFILE)
-- =============================================================================
--- [F.pollCounts] Tính số phiếu bầu cho từng lựa chọn và tổng số người tham gia trong cuộc bình chọn `p`
function F.pollCounts(p)local counts,voters={},0 for _,ch in pairs(p.votes)do local any=false for idx in pairs(ch)do counts[idx]=(counts[idx]or 0)+1;any=true end if any then voters=voters+1 end end return counts,voters
end
--- [F.renderPoll] Vẽ thẻ giao diện của một cuộc bình chọn (Poll) kèm thanh tỷ lệ phần trăm trực quan
function F.renderPoll(p)if S.frames[p.id]then F.dropFrame(p.id)end
  local frame=mk("Frame",{Name="Item_"..tostring(p.id),Size=u2(1,-4,0,0),AutomaticSize=asY,BorderSizePixel=0,LayoutOrder=p.order or 0},U.scroll)
  pcall(function()frame:SetAttribute("FeedGen",S.feedGen or 0)end)
  th(frame,"BackgroundColor3","cardBg",true);corner(frame,8);stroke(frame,"accent",1,0.6);pad(frame,8,6,8,6);list(frame,4)S.frames[p.id]=frame tinsert(S.frameQ,p.id)
  lab(frame,"📊 "..F.disp(p.q),{bold=true,wrap=true,auto=true,ts=13,layout=1})local counts,voters=F.pollCounts(p)local mine=p.votes[P.username]or{}local closed=p.closed or(tonumber(p.exp)and p.exp>0 and p.exp<=H.now())
  for i,o in ipairs(p.o)do local c=counts[i]or 0 local frac=voters>0 and c/voters or 0
    local b=mk("TextButton",{Size=u2(1,0,0,28),Text="",BorderSizePixel=0,ClipsDescendants=true,LayoutOrder=1+i,AutoButtonColor=not closed},frame)th(b,"BackgroundColor3","bg3");corner(b,7);stroke(b,"border",1,0.5)
    local fill=mk("Frame",{Size=u2(frac,0,1,0),BorderSizePixel=0,BackgroundTransparency=0.6},b)th(fill,"BackgroundColor3","accent");corner(fill,7)
    lab(b,(mine[i]and"[x] "or"")..F.disp(o),{size=u2(1,-60,1,0),pos=uo(8,0),trunc=true,bold=mine[i]==true})lab(b,c.." · "..floor(frac*100+0.5).."%",{size=uo(56,28),pos=u2(1,-60,0,0),ts=10,key="muted",align=txR})
    hook(b.MouseButton1Click,function()if not closed then F.votePoll(p,i)end end)end
  local foot=row(frame,22);foot.LayoutOrder=99
  lab(foot,F.disp(p.author or"?").." · "..voters.." "..(L=="en"and"votes"or"phiếu")..(closed and(" · "..T("closed"))or"")..(p.multi and(" · "..T("poll_multi"))or""),{size=u2(1,-90,1,0),ts=10,key="muted",trunc=true})
  if not closed and(p.author==P.username or F.isAdmin(P.username))then local cb=tbtn(foot,T("poll_close"),{size=uo(84,20),ts=10,key="danger",r=6})hook(cb.MouseButton1Click,function()
      p.closed=true;F.renderPoll(p);S.isDirty=true F.publish({type="poll_close",pollId=p.id,closer=P.username,chan=p.chan})end)end end
--- [F.votePoll] Gửi phiếu bầu (hoặc hủy phiếu bầu) cho lựa chọn `idx` trong cuộc bình chọn `p`
function F.votePoll(p,idx)if F.muted(P.username)then F.toast(T("muted"),true);return end
  local mine=p.votes[P.username]or{}p.votes[P.username]=mine local add=not mine[idx]if add and not p.multi then for k in pairs(mine)do mine[k]=nil
      F.publish({type="poll_vote",pollId=p.id,choice=k,voter=P.username,action="remove",chan=p.chan})end end mine[idx]=add and true or nil S.isDirty=true F.renderPoll(p)
  F.publish({type="poll_vote",pollId=p.id,choice=idx,voter=P.username,action=add and"add"or"remove",chan=p.chan})end
--- [F.openPoll] Mở hộp thoại tạo cuộc bình chọn (Poll) mới
function F.openPoll()if tostring(S.chan):sub(1,3)=="dm:"then F.toast(T("no_poll_dm"),true);return end
  local scr=F.modalBox(T("poll"),340,420)local q=field(scr,T("poll_q"),"")local opts={}for i=1,5 do opts[i]=field(scr,(L=="en"and"Option "or"Lựa chọn ")..i,"")end
  local multi=false
  F.switch(scr,T("poll_multi"),function()return multi end,function(v)multi=v end)local go=tbtn(scr,T("poll_create"),{key="accent",h=34})hook(go.MouseButton1Click,function()local o={}
    for _,b in ipairs(opts)do local t=H.trim(b.Text);if t~=""then o[#o+1]=H.clip(t,60)end end
    local qt=H.trim(q.Text)if qt==""or#o<2 then return end
    local id=H.uuid()S.orderN=S.orderN+1
    local p={id=id,isPoll=true,q=H.clip(qt,120),o=o,multi=multi,author=P.username,chan=S.chan,votes={},order=S.orderN,ts=H.now()}S.polls[id]=p;tinsert(S.order,id);S.isDirty=true
    F.closeModal();F.renderPoll(p);F.scrollBottom()F.publish({type="poll",packetId=id,pollId=id,question=p.q,options=o,multi=multi,author=P.username,chan=S.chan})end)end
--- [F.heartbeat] Gửi gói tin nhịp tim (Presence Heartbeat) lên `/api/presence` để báo trạng thái trực tuyến, ảnh Profile, chủ đề riêng và server đang chơi
function F.heartbeat(off)
  local body={u=P.username,d=P.display,id=P.userId,st=P.status,bio=P.bio,c=P.country,pb=P.profBanner,pi=P.profIcon,pt=F.compactProfTheme(P.profTheme),sg=P.showGame,mc=P.msgCount or 0,pl=game.PlaceId,gn=S.placeName,jb=game.JobId,off=off and true or nil}
  enqueue("other","POST","/api/presence",body,function(data,err)if data and data.ok then F.ingestPresence(data)end end)end
--- [F.ingestPresence] Cập nhật danh sách người dùng trực tuyến (`S.users`), ảnh Profile, chủ đề riêng, trạng thái Mute và Ban từ dữ liệu phản hồi của máy chủ
function F.ingestPresence(data)local now=os.clock()for _,u in ipairs(data.users or{})do
    local rec=S.users[u.u]or{}rec.display,rec.userId,rec.status,rec.bio,rec.country=u.d,tonumber(u.id)or 1,u.st or"",u.bio or"",H.resolveCountry(u.c or"??")
    rec.profBanner,rec.profIcon=H.assetId(u.pb or"")or"",H.assetId(u.pi or"")or""
    rec.profTheme=type(u.pt)=="table"and u.pt or{}
    local umc=tonumber(u.mc or u.msgCount)or 0
    rec.msgCount=max(tonumber(rec.msgCount)or 0,umc)
    if tostring(u.u or""):lower()==P.username:lower()and umc>(P.msgCount or 0)then P.msgCount=umc;S.isDirty=true end
    rec.inGame,rec.placeId,rec.gameName,rec.jobId=u.sg==true,tonumber(u.pl)or 0,u.gn or"",u.jb or""rec.age=(tonumber(data.now)or 0)-(tonumber(u.ts)or 0)rec.recvAt=now rec.isScript=true S.users[u.u]=rec
    rec._allowClear=true;F.rememberProfile(u.u,rec,true);rec._allowClear=nil end
  if type(data.mute)=="table"then F.applyMute(P.username,{on=true,reason=data.mute.reason or"",exp=tonumber(data.mute.exp)or 0,by=data.mute.by or"",ts=tonumber(data.mute.ts)or H.now()})
  elseif data.mute==nil and data.ok then F.clearMuteState(P.username)end
  if type(data.banned)=="table"then S.banned=data.banned elseif data.banned==nil and data.ok then S.banned=nil end
  F.updateInfo()end
--- [F.liveUsers] Lấy danh sách tên những người dùng đang trực tuyến, sắp xếp theo tên hiển thị
function F.liveUsers()local out={}for u,r in pairs(S.users)do if F.isLive(r)then out[#out+1]=u end end
  tsort(out,function(a,b)return tostring(S.users[a].display or a):lower()<tostring(S.users[b].display or b):lower()end)return out end
--- [F.userRow] Tạo một hàng giao diện hiển thị ảnh đại diện, tên, quốc kỳ, Role và trạng thái (kèm huy hiệu Warn/Mute/Ban nếu có) của người dùng `u`
function F.userRow(parent,u,o)o=o or{}local rec=F.userRec(u)or{}
  local isMe=(tostring(u):lower()==P.username:lower())
  local uPt=(isMe and type(P.profTheme)=="table"and P.profTheme)or(type(rec.profTheme)=="table"and rec.profTheme)or{}
  local b=mk("TextButton",{Size=u2(1,0,0,38),Text="",BorderSizePixel=0,AutoButtonColor=true,LayoutOrder=o.layout or 0},parent)th(b,"BackgroundColor3","cardBg");corner(b,8);stroke(b,"border",1,0.5)
  local customIc=(isMe and P.profIcon~=""and P.profIcon)or(rec.profIcon and rec.profIcon~=""and rec.profIcon)or nil
  F.makeFramedAvatar(b,{px=28,pos=uo(6,5),z=2,uid=F.uidOf(u),customIc=customIc,pt=uPt})
  local dot=mk("Frame",{Size=uo(9,9),Position=uo(26,26),BorderSizePixel=0},b)corner(dot,5);themed(dot,function(x)x.BackgroundColor3=(isMe or F.isLive(rec))and TH.ok or TH.muted end)local top=F.topRole(u)
  local nm=lab(b,F.disp(rec.display or u),{size=u2(1,-(o.right or 60)-44,0,17),pos=uo(40,3),bold=true,trunc=true})
  if top then nm.TextColor3=H.hex(top.color)elseif H.safeHex(uPt.acc,nil)then nm.TextColor3=H.hex(uPt.acc)end
  if uPt.font and FONT_MAP[uPt.font]then nm.Font=FONT_MAP[uPt.font].bold end
  local sub="@"..u
  local mInfo=F.getMute(u)local wList=F.getWarns(u)local bInfo=F.getBan(u)
  local modTag=(bInfo and" · ⛔ BAN"or"")..(mInfo and" · 🔇 Mute"or"")..(#wList>0 and(" · ⚠️"..#wList)or"")
  if o.sub then sub=o.sub..modTag elseif rec.status and rec.status~=""then sub=sub..modTag.." · "..rec.status else sub=sub..modTag end
  lab(b,F.disp(sub),{size=u2(1,-(o.right or 60)-44,0,14),pos=uo(40,20),ts=10,key=(bInfo or mInfo)and"danger"or(#wList>0 and"warn"or"muted"),trunc=true})
  if o.click then hook(b.MouseButton1Click,function()o.click(u)end)end return b end
--- [F.openOnline] Mở hộp thoại danh sách tất cả người dùng đang trực tuyến
function F.openOnline()S.reopenModal=F.openOnline local scr=F.modalBox(T("users"),350,440)
  lab(scr,T("delta_tp_short"),{wrap=true,auto=true,ts=10,key="warn",layout=0})local live=F.liveUsers()if#live==0 then lab(scr,T("off"),{key="muted"})end
  for i,u in ipairs(live)do F.userRow(scr,u,{layout=i,click=function(x)F.openProfile(x)end})end end
--- [F.openDM] Mở kênh trò chuyện riêng (Direct Message) với người dùng `u`
function F.openDM(u)if u==P.username then return end
  P.dmList[u]=H.now();S.isDirty=true F.closeModal()
  F.selectChannel(F.dmChan(P.username,u))end
--- [F.openGroupCreate] Mở hộp thoại tạo nhóm chat mới (Group Chat) trong kênh DM
function F.openGroupCreate()
  if F.muted(P.username)then F.toast(T("muted"),true);return end
  local scr,close=F.modalBox(L=="en"and"👥 Create Group Chat"or"👥 Tạo Group Chat mới",360,480)
  local gName=field(scr,L=="en"and"Group Name"or"Tên nhóm chat",P.display.."'s Group")
  local selMap={[P.username]=true}
  local addRow=row(scr,28)
  local addIn=mk("TextBox",{Size=u2(0.7,-3,1,0),Text="",PlaceholderText=L=="en"and"Add username..."or"Nhập tên người chơi để thêm...",ClearTextOnFocus=false,Font=fG,TextSize=11,BorderSizePixel=0,TextXAlignment=txL},addRow)
  F.styleInput(addIn,"text",false)
  local addB=rbtn(addRow,L=="en"and"+ Add"or"+ Thêm",{size=u2(0.3,-3,1,0),key="accent",ts=11})
  local memHolder=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BackgroundTransparency=1},scr)list(memHolder,3)
  local function rebuildMems()
    for _,c in ipairs(memHolder:GetChildren())do if not c:IsA("UIListLayout")then c:Destroy()end end
    local pool,seen={},{}
    local function addCand(u)if u and u~=""and not seen[u:lower()]then seen[u:lower()]=true;pool[#pool+1]=u end end
    for u in pairs(selMap)do addCand(u)end
    for u in pairs(P.dmList or{})do addCand(u)end
    for u in pairs(S.users or{})do addCand(u)end
    tsort(pool,function(a,b)if(selMap[a]==true)~=(selMap[b]==true)then return selMap[a]==true end return a:lower()<b:lower()end)
    for idx,u in ipairs(pool)do
      local isMe=(u:lower()==P.username:lower())
      local on=selMap[u]==true
      local b=mk("TextButton",{Size=u2(1,0,0,30),Text="",BorderSizePixel=0,LayoutOrder=idx},memHolder)
      th(b,"BackgroundColor3",on and"own"or"cardBg");corner(b,7);stroke(b,on and"accent"or"border",1,0.4)
      lab(b,(on and"[✓] @"or"[ ] @")..F.disp(u)..(isMe and(L=="en"and" (You)"or" (Bạn)")or""),{size=u2(1,-16,1,0),pos=uo(8,0),ts=11,bold=on,key=on and"accent"or"text",trunc=true})
      if not isMe then
        hook(b.MouseButton1Click,function()selMap[u]=not selMap[u]or nil;rebuildMems()end)
      end
    end
  end
  hook(addB.MouseButton1Click,function()
    local u=H.trim(addIn.Text):gsub("^@","")
    if u~=""then selMap[u]=true;addIn.Text="";rebuildMems()end
  end)
  rebuildMems()
  local go=tbtn(scr,L=="en"and"✓ Create Group Chat"or"✓ Tạo Group Chat",{key="ok",h=34,ts=12})
  hook(go.MouseButton1Click,function()
    local nm=H.clip(H.trim(gName.Text)~=""and H.trim(gName.Text)or"Group Chat",40)
    local mems={}for u in pairs(selMap)do mems[#mems+1]=u end
    enqueue("send","POST","/api/groups",{action="create",by=P.username,name=nm,members=mems},function(d,err)
      if d and d.ok and type(d.group)=="table"then
        if type(d.groups)=="table"then S.groups=d.groups else S.groups=S.groups or{};tinsert(S.groups,d.group)end
        S.groupSeq=tonumber(d.groupSeq)or S.groupSeq;S.isDirty=true
        if type(close)=="function"then close()else F.closeModal()end
        F.toast((L=="en"and"Created group: "or"Đã tạo nhóm: ")..nm,true)
        F.selectChannel(d.group.chan)
      else F.netError((d and d.error)or err)end
    end)
  end)
end
--- [F.openGroupManage] Mở hộp thoại quản lý Group Chat (đổi tên, thêm/xóa thành viên, rời nhóm hoặc giải tán nhóm)
function F.openGroupManage(g)
  if type(g)~="table"then return end
  local isOwner=(tostring(g.owner or""):lower()==P.username:lower())or F.isStaff(P.username)
  local scr,close=F.modalBox("👥 "..F.disp(g.name or"Group"),360,490)
  lab(scr,(L=="en"and"Owner: @"or"Chủ nhóm: @")..F.disp(g.owner or"?").."  ·  "..#(g.members or{})..(L=="en"and" members"or" thành viên"),{ts=11,key="muted"})
  if isOwner then
    local rnRow=row(scr,28)
    local rnIn=mk("TextBox",{Size=u2(0.7,-3,1,0),Text=tostring(g.name or""),ClearTextOnFocus=false,Font=fG,TextSize=11,BorderSizePixel=0,TextXAlignment=txL},rnRow)
    F.styleInput(rnIn,"text",false)
    local rnB=rbtn(rnRow,L=="en"and"Rename"or"Đổi tên",{size=u2(0.3,-3,1,0),key="accent",ts=11})
    hook(rnB.MouseButton1Click,function()
      local nn=H.clip(H.trim(rnIn.Text),40)if nn==""then return end
      enqueue("other","POST","/api/groups",{action="rename",by=P.username,id=g.id,name=nn},function(d,err)
        if d and d.ok then
          if type(d.groups)=="table"then S.groups=d.groups end
          g.name=nn;S.isDirty=true;F.updateInfo();F.toast(T("saved_ok"),true);F.openGroupManage(d.group or g)
        else F.netError((d and d.error)or err)end
      end)
    end)
  end
  local addRow=row(scr,28)
  local addIn=mk("TextBox",{Size=u2(0.68,-3,1,0),Text="",PlaceholderText=L=="en"and"Username to add..."or"Thêm thành viên (@username)...",ClearTextOnFocus=false,Font=fG,TextSize=11,BorderSizePixel=0,TextXAlignment=txL},addRow)
  F.styleInput(addIn,"text",false)
  local addB=rbtn(addRow,L=="en"and"+ Add"or"+ Thêm",{size=u2(0.32,-3,1,0),key="ok",ts=11})
  hook(addB.MouseButton1Click,function()
    local u=H.trim(addIn.Text):gsub("^@","")if u==""then return end
    enqueue("other","POST","/api/groups",{action="add_member",by=P.username,id=g.id,target=u},function(d,err)
      if d and d.ok then
        if type(d.groups)=="table"then S.groups=d.groups end
        if type(d.group)=="table"then g=d.group;if S.chan:match("^dm:grp_")then S.chan=g.chan end end
        S.isDirty=true;F.openGroupManage(g)
      else F.netError((d and d.error)or err)end
    end)
  end)
  F.section(scr,L=="en"and"Members"or"Thành viên trong nhóm")
  for idx,m in ipairs(g.members or{})do
    local mr=F.card(scr,32);mr.LayoutOrder=idx
    lab(mr,"@"..F.disp(m)..(tostring(m):lower()==tostring(g.owner or""):lower()and" 👑"or""),{size=u2(1,-90,1,0),pos=uo(10,0),ts=11,bold=true,trunc=true})
    if isOwner and tostring(m):lower()~=P.username:lower()then
      local kb=tbtn(mr,L=="en"and"Kick"or"Xóa",{size=uo(56,22),pos=u2(1,-62,0.5,-11),key="danger",ts=10,r=6})
      hook(kb.MouseButton1Click,function()
        enqueue("other","POST","/api/groups",{action="remove_member",by=P.username,id=g.id,target=m},function(d,err)
          if d and d.ok then
            if type(d.groups)=="table"then S.groups=d.groups end
            if type(d.group)=="table"then g=d.group end
            S.isDirty=true;F.openGroupManage(g)
          else F.netError((d and d.error)or err)end
        end)
      end)
    end
  end
  local actR=row(scr,32)
  local lvB=rbtn(actR,L=="en"and"Leave Group"or"Rời nhóm",{key="warn",ts=11})
  hook(lvB.MouseButton1Click,function()
    enqueue("other","POST","/api/groups",{action="leave",by=P.username,id=g.id},function(d)
      if d and type(d.groups)=="table"then S.groups=d.groups end
      S.isDirty=true;if type(close)=="function"then close()else F.closeModal()end
      if S.chan==g.chan then F.selectChannel("general")end
    end)
  end)
  if isOwner then
    local dlB=rbtn(actR,L=="en"and"Delete Group"or"Giải tán nhóm",{key="danger",ts=11})
    hook(dlB.MouseButton1Click,function()
      enqueue("other","POST","/api/groups",{action="delete",by=P.username,id=g.id},function(d)
        if d and type(d.groups)=="table"then S.groups=d.groups end
        S.isDirty=true;if type(close)=="function"then close()else F.closeModal()end
        if S.chan==g.chan then F.selectChannel("general")end
      end)
    end)
  end
end
--- [F.openDMList] Mở hộp thoại danh sách các cuộc trò chuyện riêng (DM 1-1 & Group Chat)
function F.openDMList()S.reopenModal=F.openDMList local scr=F.modalBox(T("dm"),360,460)
  local topR=row(scr,32)
  local nb=rbtn(topR,"+ "..T("pick_user"),{key="accent",ts=11})
  hook(nb.MouseButton1Click,function()F.pickUser({title=T("dm"),onPick=function(u)F.openDM(u)end})end)
  local gb=rbtn(topR,L=="en"and"+ Group Chat"or"+ Tạo Group Chat",{key="ok",ts=11})
  hook(gb.MouseButton1Click,function()F.openGroupCreate()end)
  local myGroups={}
  for _,g in ipairs(S.groups or{})do
    local isMem=false
    for _,m in ipairs(g.members or{})do if tostring(m):lower()==P.username:lower()then isMem=true;break end end
    if isMem or F.isStaff(P.username)then myGroups[#myGroups+1]=g end
  end
  if #myGroups>0 then
    F.section(scr,"👥 GROUP CHAT ("..#myGroups..")")
    for idx,g in ipairs(myGroups)do
      local un=S.dmUnread[g.chan]or 0
      local rowCard=mk("Frame",{Size=u2(1,0,0,38),BorderSizePixel=0,LayoutOrder=idx},scr)
      th(rowCard,"BackgroundColor3","cardBg");corner(rowCard,8);stroke(rowCard,un>0 and"accent"or"border",1,0.45)
      local openB=mk("TextButton",{Size=u2(1,-38,1,0),BackgroundTransparency=1,Text="",BorderSizePixel=0},rowCard)
      lab(openB,"👥 "..F.disp(F.locText(g.name or"Group"))..(un>0 and("  ["..un.." "..T("jump_new").."]")or""),{size=u2(1,-12,0,18),pos=uo(10,3),ts=12,bold=true,key=un>0 and"accent"or"text",trunc=true})
      lab(openB,#(g.members or{})..(L=="en"and" members · @"or" thành viên · @")..F.disp(g.owner or"?"),{size=u2(1,-12,0,14),pos=uo(10,20),ts=10,key="muted",trunc=true})
      hook(openB.MouseButton1Click,function()F.closeModal();F.selectChannel(g.chan)end)
      local cfgB=tbtn(rowCard,"⚙️",{size=uo(30,28),pos=u2(1,-34,0.5,-14),ts=11,key="btnBg",r=6})
      hook(cfgB.MouseButton1Click,function()F.openGroupManage(g)end)
    end
  end
  F.section(scr,L=="en"and"💬 DIRECT MESSAGES"or"💬 TIN NHẮN RIÊNG (1-1)")
  local names={}for u in pairs(P.dmList)do names[#names+1]=u end
  tsort(names,function(a,b)return(P.dmList[a]or 0)>(P.dmList[b]or 0)end)
  if#names==0 then lab(scr,T("no_dm"),{wrap=true,auto=true,key="muted"})end for i,u in ipairs(names)do
    local un=S.dmUnread[F.dmChan(P.username,u)]or 0 F.userRow(scr,u,{layout=i+100,sub=un>0 and("• "..un.." "..T("jump_new"))or nil,click=function(x)F.openDM(x)end})end end
--- [F.searchRobloxStore] Truy vấn trực tiếp kho ảnh Decal/Image trên Roblox Creator Store / Catalog thông qua Executor HTTP
function F.searchRobloxStore(keyword,page,cat,cb)
  page=max(1,tonumber(page)or 1)
  local q=H.trim(tostring(keyword or""))
  if q==""then
    q=(cat=="icon"and"anime icon")or(cat=="theme"and"aesthetic background")or"anime banner"
  end
  task.spawn(function()
    local items,seen={},{}
    local function pushItem(id,name,creator)
      local cleanId=H.assetId(id)
      if cleanId and not seen[cleanId]then
        seen[cleanId]=true
        items[#items+1]={id=cleanId,name=H.clip(H.trim(name or("Asset #"..cleanId)),42),creator=H.trim(creator or"Roblox Store")}
      end
    end
    -- Nguồn 1: Roblox Creator Store / Toolbox Service API (chính thức, không bị CAPTCHA như catalog cũ)
    local url1="https://apis.roblox.com/toolbox-service/v1/marketplace/13?keyword="..H.url(q).."&num=24&pageNumber="..tostring(page)
    local ok1,res1=pcall(httpFn,{Url=url1,Method="GET",Headers={["User-Agent"]="Roblox/WinInet",Accept="application/json"}})
    if ok1 and type(res1)=="table"and(tonumber(res1.StatusCode or res1.Status)==200)then
      local data1=H.jdec(res1.Body)
      if type(data1)=="table"and type(data1.data)=="table"then
        local idList={}
        for _,it in ipairs(data1.data)do
          if type(it)=="table"and it.id then idList[#idList+1]=tostring(it.id)end
        end
        local nameMap,creatorMap={},{}
        if#idList>0 then
          local detUrl="https://apis.roblox.com/toolbox-service/v1/items/details?assetIds="..tconcat(idList,",")
          local okD,resD=pcall(httpFn,{Url=detUrl,Method="GET",Headers={["User-Agent"]="Roblox/WinInet",Accept="application/json"}})
          if okD and type(resD)=="table"and(tonumber(resD.StatusCode or resD.Status)==200)then
            local det=H.jdec(resD.Body)
            for _,dItem in ipairs((type(det)=="table"and det.data)or{})do
              if type(dItem)=="table"and type(dItem.asset)=="table"then
                local aid=tostring(dItem.asset.id or"")
                nameMap[aid]=dItem.asset.name
                creatorMap[aid]=type(dItem.creator)=="table"and dItem.creator.name or nil
              end
            end
          end
        end
        for _,aid in ipairs(idList)do
          pushItem(aid,nameMap[aid]or(q.." #"..aid:sub(-4)),creatorMap[aid])
        end
      end
    end
    -- Nguồn 2: Legacy Catalog JSON dự phòng nếu nguồn 1 ít kết quả
    if#items<6 then
      local url2="https://search.roblox.com/catalog/json?Category=Decals&Keyword="..H.url(q).."&ResultsPerPage=24&PageNumber="..tostring(page)
      local ok2,res2=pcall(httpFn,{Url=url2,Method="GET"})
      if ok2 and type(res2)=="table"and(tonumber(res2.StatusCode or res2.Status)==200)then
        local data2=H.jdec(res2.Body)
        if type(data2)=="table"then
          for _,it in ipairs(data2)do
            if type(it)=="table"and(it.AssetId or it.id)then
              pushItem(it.AssetId or it.id,it.Name or it.name,it.Creator or it.creator)
            end
          end
        end
      end
    end
    -- Nguồn 3: Proxy Backup /api/images nếu Executor chặn API Roblox bên ngoài
    if#items==0 then
      enqueue("other","GET","/api/images?q="..H.url(q).."&cat="..H.url(cat or"").."&page="..tostring(page),nil,function(d)
        if d and d.ok and type(d.items)=="table"then
          for _,it in ipairs(d.items)do pushItem(it.id,it.name,it.creator)end
        end
        if cb then pcall(cb,items,q,page)end
      end)
      return
    end
    if cb then pcall(cb,items,q,page)end
  end)
end
--- [F.openImageFinder] Mở cửa sổ tìm kiếm Roblox Store (xem trước toàn khung ScaleType.Fit không bị cắt + hỗ trợ Crop Studio tức thì)
function F.openImageFinder(title,cat,onPick,opts)
  opts=type(opts)=="table"and opts or{}
  local v=viewNow()
  local mw,mh=min(500,v.X-16),min(580,v.Y-16)
  local scr,close=F.popup(title or(L=="en"and"Roblox Store Image Finder"or"Tìm ảnh trên Roblox Store"),mw,mh)
  local noteCard=F.card(scr,0);noteCard.AutomaticSize=asY;noteCard.Size=u2(1,0,0,0);pad(noteCard,10,7,10,7);stroke(noteCard,"accent",1,0.35)
  local noteRow=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BackgroundTransparency=1},noteCard)
  F.lucide(noteRow,"store",15,{pos=uo(0,2),key="accent"})
  lab(noteRow,L=="en"
    and"Search Roblox Creator Store decals & full images. Thumbnails show full uncropped aspect; use Studio to zoom & pan."
    or"Tìm kiếm Decal/Image trên Roblox Creator Store. Ảnh hiện đủ tỉ lệ gốc không bị cắt; có thể căn chỉnh khung hình ngay.",
    {size=u2(1,-22,0,0),pos=uo(22,0),wrap=true,auto=true,ts=10,key="muted"})

  local sRow=row(scr,30)
  local qBox=mk("TextBox",{
    Size=u2(0.72,-3,1,0),Text="",
    PlaceholderText=L=="en"and"Search Roblox Store or paste Asset ID / link..."or"Nhập từ khóa (anime, cyber, neon) hoặc dán Asset ID...",
    ClearTextOnFocus=false,Font=fG,TextSize=11,BorderSizePixel=0,TextXAlignment=txL
  },sRow)
  F.styleInput(qBox,"text",false)
  local sBtn=rbtn(sRow,L=="en"and"Search"or"Tìm",{size=u2(0.28,-3,1,0),key="accent",ts=11})
  F.lucide(sBtn,"search",13,{pos=uo(10,8),col=H.lum(TH.accent)>0.55 and rgb(20,20,24)or c3(1,1,1),themed=false})

  local QUICK_TAGS={
    banner={"Anime Banner","Cyberpunk","Galaxy Space","Sakura","Vaporwave","Dark Matrix","Neon City"},
    icon={"Anime Icon","Cat Avatar","Crown VIP","Skull Gaming","Cute Chibi","Sword Emblem"},
    theme={"Lo-Fi Wallpaper","Night Sky","Dark Abstract","Cherry Blossom","Cyber Grid","Purple Aesthetic"},
  }
  local tagList=QUICK_TAGS[cat or"banner"]or QUICK_TAGS.banner
  local tagScroll=mk("ScrollingFrame",{Size=u2(1,0,0,26),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=0,CanvasSize=u2(),AutomaticCanvasSize=asX,ScrollingDirection=Enum.ScrollingDirection.X},scr)
  mk("UIListLayout",{FillDirection=fdH,Padding=u1(0,5),SortOrder=soLO,VerticalAlignment=vaC},tagScroll)
  local curPage=1
  local doSearch
  for idx,tg in ipairs(tagList)do
    local tw=max(54,H.textW(tg,10,fGB)+18)
    local tb=mk("TextButton",{Size=uo(tw,23),Text=tg,Font=fGB,TextSize=10,BorderSizePixel=0,LayoutOrder=idx},tagScroll)
    th(tb,"BackgroundColor3","btnBg");th(tb,"TextColor3","accent");corner(tb,12);stroke(tb,"btnBorder",1,0.4)
    hook(tb.MouseButton1Click,function()qBox.Text=tg;curPage=1;doSearch()end)
  end

  local navRow=row(scr,26)
  local statusLbl=lab(navRow,"",{size=u2(1,-118,1,0),ts=10,key="muted",trunc=true})
  local prevBtn=tbtn(navRow,"",{size=uo(30,24),pos=u2(1,-108,0,1),key="btnBg",r=6})
  F.lucide(prevBtn,"chevLeft",14,{pos=uo(8,5),key="text"})
  local pageLbl=lab(navRow,"P.1",{size=uo(42,24),pos=u2(1,-74,0,1),ts=10,bold=true,key="accent",align=txC})
  local nextBtn=tbtn(navRow,"",{size=uo(30,24),pos=u2(1,-30,0,1),key="btnBg",r=6})
  F.lucide(nextBtn,"chevRight",14,{pos=uo(8,5),key="text"})

  local gridWrap=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BackgroundTransparency=1},scr)
  local cols=(mw>=430)and 3 or 2
  local cellW=max(114,floor((mw-34-(cols-1)*6)/cols))
  mk("UIGridLayout",{CellSize=uo(cellW,132),CellPadding=uo(6,6),SortOrder=soLO},gridWrap)

  local FALLBACK_IMGS={
    {id="11710334936",name="Cyber Neon Banner",creator="Store",cat="banner"},
    {id="13839964015",name="Starry Night Sky",creator="Store",cat="banner"},
    {id="11379207148",name="Sakura Aesthetic",creator="Store",cat="banner"},
    {id="14846995467",name="Dark Purple Matrix",creator="Store",cat="banner"},
    {id="11739821350",name="Crown VIP Icon",creator="Store",cat="icon"},
    {id="12520481054",name="Anime Cat Icon",creator="Store",cat="icon"},
    {id="13405196215",name="Pro Gamer Emblem",creator="Store",cat="icon"},
    {id="11563251225",name="Fire Skull Badge",creator="Store",cat="icon"},
    {id="12945612890",name="Diamond Shield",creator="Store",cat="icon"},
  }

  local function chooseItem(id,it,openStudio)
    if type(close)=="function"then close()else F.closeModal()end
    if openStudio and opts.onStudio then
      opts.onStudio(id,it)
    elseif onPick then
      F.toast((L=="en"and"Selected Roblox Image ID: "or"Đã chọn ảnh Roblox ID: ")..id,true)
      onPick(id,it)
    end
  end

  local function renderItems(items)
    for _,c in ipairs(gridWrap:GetChildren())do if not c:IsA("UIGridLayout")then c:Destroy()end end
    for idx,it in ipairs(items)do
      local id=H.assetId(it.id)
      if id then
        local card=mk("Frame",{BorderSizePixel=0,LayoutOrder=idx,ClipsDescendants=true},gridWrap)
        th(card,"BackgroundColor3","cardBg");corner(card,8);stroke(card,"border",1,0.35)
        -- Khung xem trước giữ nguyên tỉ lệ ảnh gốc ScaleType.Fit (không cắt méo)
        local imgBg=mk("TextButton",{Size=u2(1,-8,0,76),Position=uo(4,4),Text="",AutoButtonColor=true,BorderSizePixel=0,ClipsDescendants=true},card)
        th(imgBg,"BackgroundColor3","inputBg");corner(imgBg,6)
        local im=mk("ImageLabel",{Size=u2(1,-4,1,-4),Position=uo(2,2),BackgroundTransparency=1,Image=F.thumbUrl(id,420,420),ScaleType=Enum.ScaleType.Fit,BorderSizePixel=0,ZIndex=2},imgBg)
        F.setAsset(im,id,nil,nil,{thumbOnly=true})
        if opts.onStudio then
          local cropMini=mk("TextButton",{Size=uo(22,20),Position=u2(1,-24,0,3),BackgroundColor3=rgb(14,15,20),BackgroundTransparency=0.22,Text="",AutoButtonColor=true,BorderSizePixel=0,ZIndex=5},imgBg)
          corner(cropMini,5);F.lucide(cropMini,"crop",12,{pos=uo(5,4),col=c3(1,1,1),themed=false})
          hook(cropMini.MouseButton1Click,function()chooseItem(id,it,true)end)
        end
        lab(card,F.disp(it.name or("ID "..id)),{size=u2(1,-10,0,14),pos=uo(5,82),ts=10,bold=true,align=txC,trunc=true})
        lab(card,(it.creator and("@"..H.clip(it.creator,10).." · ")or"")..id,{size=u2(1,-10,0,11),pos=uo(5,96),ts=9,key="muted",align=txC,trunc=true})
        local useBtn=mk("TextButton",{Size=u2(1,-10,0,18),Position=uo(5,110),Text="",AutoButtonColor=true,BorderSizePixel=0},card)
        th(useBtn,"BackgroundColor3","accent");corner(useBtn,5)
        local ulTxtCol=H.lum(TH.accent)>0.55 and rgb(20,20,24)or c3(1,1,1)
        local ul=lab(useBtn,L=="en"and"Use Image"or"Chọn ảnh",{size=us(1,1),ts=9,bold=true,align=txC})
        ul.TextColor3=ulTxtCol
        hook(imgBg.MouseButton1Click,function()chooseItem(id,it,false)end)
        hook(useBtn.MouseButton1Click,function()chooseItem(id,it,false)end)
      end
    end
  end

  local searchSeq=0
  doSearch=function()
    searchSeq=searchSeq+1
    local mySeq=searchSeq
    local q=H.trim(qBox.Text)
    pageLbl.Text="P."..tostring(curPage)
    local directId=H.assetId(q)
    if directId then
      statusLbl.Text="Direct Asset ID: "..directId
      renderItems({{id=directId,name="Asset #"..directId,creator="Direct ID"}})
      return
    end
    statusLbl.Text=L=="en"and"Searching Roblox Creator Store..."or"Đang tìm trên Roblox Store..."
    F.searchRobloxStore(q,curPage,cat,function(items,usedQuery)
      if mySeq~=searchSeq or not gridWrap.Parent then return end
      if#items>0 then
        statusLbl.Text=string.format(L=="en"and"%d results for '%s'"or"%d ảnh cho '%s'",#items,usedQuery)
        renderItems(items)
      else
        statusLbl.Text=L=="en"and"Showing built-in gallery:"or"Bộ sưu tập có sẵn:"
        renderItems(FALLBACK_IMGS)
      end
    end)
  end
  hook(sBtn.MouseButton1Click,function()curPage=1;doSearch()end)
  hook(qBox.FocusLost,function(enter)if enter then curPage=1;doSearch()end end)
  hook(prevBtn.MouseButton1Click,function()if curPage>1 then curPage=curPage-1;doSearch()end end)
  hook(nextBtn.MouseButton1Click,function()curPage=curPage+1;doSearch()end)
  doSearch()
end
--- [F.openImageCropStudio] Trình căn chỉnh khung hình & Zoom/Pan trực quan (khắc phục méo/cắt ảnh từ Roblox Store)
function F.openImageCropStudio(opts)
  opts=type(opts)=="table"and opts or{}
  local target=opts.target or"banner"
  local initCfg=type(opts.cfg)=="table"and opts.cfg or{}
  local st={
    id=H.assetId(opts.assetId or"")or"",
    fit=initCfg.fit or"crop",
    zoom=clamp(tonumber(initCfg.zoom)or 100,100,300),
    x=clamp(tonumber(initCfg.x)or 0,-100,100),
    y=clamp(tonumber(initCfg.y)or 0,-100,100),
    aspect=initCfg.aspect or"auto",
    height=clamp(tonumber(initCfg.height)or 96,64,150),
    radius=clamp(tonumber(initCfg.radius)or 50,0,50),
  }
  local v=viewNow()
  local mw,mh=min(470,v.X-16),min(575,v.Y-16)
  local titleTxt=opts.title or(
    target=="banner"and(L=="en"and"Banner Crop & Framing Studio"or"Căn chỉnh Ảnh Bìa (Banner Studio)")
    or(target=="icon"and(L=="en"and"Avatar Crop & Frame Studio"or"Căn chỉnh Ảnh Đại Diện (Avatar Studio)")
    or(L=="en"and"Wallpaper Crop & Framing Studio"or"Căn chỉnh Ảnh Nền Thẻ (Wallpaper Studio)"))
  )
  local scr,rawClose=F.popup(titleTxt,mw,mh)
  local studioConns={}
  local function closeStudio()
    for _,c in ipairs(studioConns)do pcall(function()c:Disconnect()end)end
    studioConns={}
    if type(rawClose)=="function"then rawClose()else F.closeModal()end
  end

  local hdNote=F.card(scr,0);hdNote.AutomaticSize=asY;hdNote.Size=u2(1,0,0,0);pad(hdNote,10,6,10,6);stroke(hdNote,"accent",1,0.3)
  local hdRow=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BackgroundTransparency=1},hdNote)
  F.lucide(hdRow,"crop",15,{pos=uo(0,2),key="accent"})
  lab(hdRow,L=="en"
    and"Drag inside the preview box (or use sliders) to re-center faces & focal points. Use Fit mode or Source Ratio to stop square Roblox Store clipping."
    or"Kéo trực tiếp trong khung xem trước (hoặc dùng thanh trượt) để căn tâm ảnh. Chọn chế độ Fit hoặc Tỉ lệ gốc để hết bị cắt méo ảnh Store.",
    {size=u2(1,-22,0,0),pos=uo(22,0),wrap=true,auto=true,ts=10,key="muted"})

  local topTools=row(scr,28)
  local srcBadge=lab(topTools,st.id~=""and("ID: "..st.id)or(L=="en"and"No image"or"Chưa chọn ảnh"),{size=u2(1,-214,1,0),ts=10,bold=true,key="muted",trunc=true})
  local pickStoreBtn=tbtn(topTools,L=="en"and" Store"or" Kho ảnh",{size=uo(96,26),pos=u2(1,-208,0,1),key="accent",ts=10,r=6})
  F.lucide(pickStoreBtn,"store",12,{pos=uo(8,7),col=H.lum(TH.accent)>0.55 and rgb(20,20,24)or c3(1,1,1),themed=false})
  local reloadHdBtn=tbtn(topTools,L=="en"and" Reload HD"or" Tải nét HD",{size=uo(106,26),pos=u2(1,-106,0,1),key="btnBg",ts=10,r=6})
  F.lucide(reloadHdBtn,"refresh",12,{pos=uo(8,7),key="ok"})

  local pvShell=mk("Frame",{Size=u2(1,0,0,164),BorderSizePixel=0},scr)
  th(pvShell,"BackgroundColor3","cardBg");corner(pvShell,10);stroke(pvShell,"border",1,0.35);pad(pvShell,10,10,10,10)
  local pvFrameW=(target=="icon")and 128 or(mw-48)
  local pvFrameH=(target=="icon")and 128 or((target=="banner")and clamp(st.height,64,142)or 138)
  local pvClip=F.createClipHost(pvShell,{
    Size=uo(pvFrameW,pvFrameH),AnchorPoint=v2(0.5,0.5),Position=us(0.5,0.5),
    BorderSizePixel=0,ClipsDescendants=true,Active=true,
  })
  th(pvClip,"BackgroundColor3","inputBg")
  local pvCorner=mk("UICorner",{CornerRadius=(target=="icon")and u1(st.radius/100,0)or u1(0,10)},pvClip)
  stroke(pvClip,"accent",1.4,0.2)
  local pvImg=mk("ImageLabel",{Size=us(1,1),BackgroundTransparency=1,BorderSizePixel=0,ScaleType=Enum.ScaleType.Crop,ZIndex=2},pvClip)
  local pvEmpty=lab(pvClip,L=="en"and"Pick an image from Store or enter Asset ID"or"Chọn ảnh từ Roblox Store để xem trước",{size=u2(1,-16,1,0),pos=uo(8,0),ts=11,key="muted",wrap=true,align=txC})
  pvEmpty.ZIndex=3
  -- Lưới 1/3 (Rule of Thirds) giúp căn bố cục chuyên nghiệp
  for _,p in ipairs({0.333,0.666})do
    mk("Frame",{Size=u2(1,0,0,1),Position=us(0,p),BackgroundColor3=c3(1,1,1),BackgroundTransparency=0.78,BorderSizePixel=0,ZIndex=4},pvClip)
    mk("Frame",{Size=u2(0,1,1,0),Position=us(p,0),BackgroundColor3=c3(1,1,1),BackgroundTransparency=0.78,BorderSizePixel=0,ZIndex=4},pvClip)
  end
  local dragHint=mk("Frame",{Size=uo(106,18),Position=uo(6,6),BackgroundColor3=rgb(12,14,18),BackgroundTransparency=0.35,BorderSizePixel=0,ZIndex=5},pvClip)
  corner(dragHint,9);F.lucide(dragHint,"move",10,{pos=uo(6,4),col=c3(1,1,1),themed=false})
  local dhl=lab(dragHint,L=="en"and"Drag to Pan"or"Kéo để căn",{size=u2(1,-20,1,0),pos=uo(18,0),ts=9,bold=true});dhl.TextColor3=c3(1,1,1)

  local refreshFns={}
  local function updatePv(forceLoad)
    local curH=(target=="banner")and clamp(st.height,64,150)or((target=="icon")and 128 or 138)
    pvFrameH=curH
    pvShell.Size=u2(1,0,0,max(148,curH+24))
    pvClip.Size=uo(pvFrameW,curH)
    pvCorner.CornerRadius=(target=="icon")and u1(st.radius/100,0)or u1(0,10)
    if st.id~=""then
      pvEmpty.Visible=false;pvImg.Visible=true
      if forceLoad~=nil or pvImg.Image==""then
        srcBadge.Text="ID "..st.id.." · ..."
        F.setAsset(pvImg,st.id,function(ok,_,isFull)
          if srcBadge.Parent then
            srcBadge.Text="ID "..st.id.." · "..(isFull and"HD Native"or"Thumb 420px")
          end
        end,0,{force=(forceLoad==true)})
      end
      F.applyImageFrame(pvClip,pvImg,st,pvFrameW,curH)
      if opts.onLiveChange then pcall(opts.onLiveChange,st)end
    else
      pvImg.Visible=false;pvEmpty.Visible=true;srcBadge.Text=L=="en"and"No Asset ID"or"Chưa có ID ảnh"
    end
  end

  local slZoom,setSlZoom,slX,setSlX,slY,setSlY,slExtra,setSlExtra
  local fitBtns,aspectBtns={},{}
  local function paintStudioPills()
    for k,b in pairs(fitBtns)do
      local on=(st.fit==k)
      b.BackgroundColor3=on and TH.accent or TH.btnBg
      b.TextColor3=on and(H.lum(TH.accent)>0.55 and rgb(18,18,22)or c3(1,1,1))or TH.text
    end
    for k,b in pairs(aspectBtns)do
      local on=(st.aspect==k)
      b.BackgroundColor3=on and TH.accent or TH.btnBg
      b.TextColor3=on and(H.lum(TH.accent)>0.55 and rgb(18,18,22)or c3(1,1,1))or TH.text
    end
  end

  -- Hỗ trợ kéo chuột / chạm tay trực tiếp trên khung preview
  local dragState=nil
  studioConns[#studioConns+1]=pvClip.InputBegan:Connect(function(inp)
    if inp.UserInputType==mb1 or inp.UserInputType==utTouch then
      if st.fit=="crop"and st.aspect=="auto"and st.zoom<=105 then
        st.zoom=135;if setSlZoom then setSlZoom(135,false)end;updatePv()
      end
      dragState={start=inp.Position,sx=st.x,sy=st.y,inp=inp}
    end
  end)
  studioConns[#studioConns+1]=UIS.InputChanged:Connect(function(inp)
    if not dragState or not pvClip.Parent then return end
    local okMove=(dragState.inp.UserInputType==utTouch and inp==dragState.inp)or(dragState.inp.UserInputType==mb1 and inp.UserInputType==Enum.UserInputType.MouseMovement)
    if not okMove then return end
    local dx=inp.Position.X-dragState.start.X
    local dy=inp.Position.Y-dragState.start.Y
    local sensX=max(0.7,pvFrameW/190)
    local sensY=max(0.7,pvFrameH/190)
    st.x=clamp(floor(dragState.sx-dx/sensX+0.5),-100,100)
    st.y=clamp(floor(dragState.sy-dy/sensY+0.5),-100,100)
    if setSlX then setSlX(st.x,false)end
    if setSlY then setSlY(st.y,false)end
    updatePv()
  end)
  studioConns[#studioConns+1]=UIS.InputEnded:Connect(function(inp)
    if dragState and(inp==dragState.inp or inp.UserInputType==mb1)then dragState=nil end
  end)

  local fitSec=F.card(scr,0);fitSec.AutomaticSize=asY;fitSec.Size=u2(1,0,0,0);pad(fitSec,10,8,10,8);list(fitSec,6);stroke(fitSec,"border",1,0.35)
  lab(fitSec,L=="en"and"FIT MODE"or"CHẾ ĐỘ KHỚP KHUNG",{ts=10,bold=true,key="accent"})
  local fitList=(target=="icon")and{{"crop","Crop (Fill)"},{"fit","Fit (Full)"},{"stretch","Stretch"}}or{{"crop","Crop (Fill)"},{"fit","Fit (Full)"},{"stretch","Stretch"},{"tile","Tile"}}
  local fitRow=row(fitSec,26)
  for idx,fd in ipairs(fitList)do
    local b=tbtn(fitRow,fd[2],{size=u2(1/#fitList,-3,1,0),ts=10,r=6,layout=idx})
    fitBtns[fd[1]]=b
    hook(b.MouseButton1Click,function()st.fit=fd[1];paintStudioPills();updatePv()end)
  end

  lab(fitSec,L=="en"and"SOURCE IMAGE ASPECT RATIO"or"TỈ LỆ ẢNH GỐC (TRÁNH CẮT/DẸT)",{ts=10,bold=true,key="accent"})
  local arRow=row(fitSec,24)
  local arOpts={"auto","1:1","16:9","4:3","3:4","9:16"}
  for idx,ak in ipairs(arOpts)do
    local b=tbtn(arRow,ak=="auto"and"Auto"or ak,{size=u2(1/#arOpts,-3,1,0),ts=10,r=6,layout=idx})
    aspectBtns[ak]=b
    hook(b.MouseButton1Click,function()st.aspect=ak;paintStudioPills();updatePv()end)
  end

  local ctrlSec=F.card(scr,0);ctrlSec.AutomaticSize=asY;ctrlSec.Size=u2(1,0,0,0);pad(ctrlSec,10,8,10,8);list(ctrlSec,5);stroke(ctrlSec,"border",1,0.35)
  local zHead=row(ctrlSec,24)
  local zMinus=tbtn(zHead,"-",{size=uo(30,22),ts=12,r=6,layout=1})
  local zLbl=lab(zHead,L=="en"and"Zoom & Precision Nudge"or"Thu phóng & Dịch chuyển",{size=u2(1,-162,1,0),ts=10,bold=true,key="muted",align=txC,layout=2})
  local zPlus=tbtn(zHead,"+",{size=uo(30,22),ts=12,r=6,layout=3})
  local rstBtn=tbtn(zHead,L=="en"and" Reset"or" Đặt lại",{size=uo(84,22),ts=10,key="btnBg",r=6,layout=4})
  F.lucide(rstBtn,"rotateCcw",11,{pos=uo(6,5),key="warn"})

  slZoom,setSlZoom=F.slider(ctrlSec,L=="en"and"Zoom Scale"or"Độ phóng đại (Zoom)",100,300,st.zoom,{step=5,fmt=function(val)return val.."%"end,onChange=function(val)st.zoom=val;updatePv()end})
  slX,setSlX=F.slider(ctrlSec,L=="en"and"Horizontal Pan (X)"or"Vị trí ngang (Pan X)",-100,100,st.x,{step=2,fmt=function(val)return val.."%"end,onChange=function(val)st.x=val;updatePv()end})
  slY,setSlY=F.slider(ctrlSec,L=="en"and"Vertical Pan (Y)"or"Vị trí dọc (Pan Y)",-100,100,st.y,{step=2,fmt=function(val)return val.."%"end,onChange=function(val)st.y=val;updatePv()end})

  if target=="banner"then
    slExtra,setSlExtra=F.slider(ctrlSec,L=="en"and"Banner Height"or"Chiều cao Ảnh Bìa",64,150,st.height,{step=2,fmt=function(val)return val.."px"end,onChange=function(val)st.height=val;updatePv()end})
  elseif target=="icon"then
    local rRow=row(ctrlSec,22)
    for idx,rp in ipairs({{50,L=="en"and"Circle"or"Tròn"},{22,"Squircle"},{10,"Soft"},{0,L=="en"and"Square"or"Vuông"}})do
      local rb=tbtn(rRow,rp[2],{size=u2(0.25,-3,1,0),ts=10,r=6,layout=idx})
      hook(rb.MouseButton1Click,function()st.radius=rp[1];if setSlExtra then setSlExtra(rp[1],false)end;updatePv()end)
    end
    slExtra,setSlExtra=F.slider(ctrlSec,L=="en"and"Corner Roundness"or"Độ bo góc Avatar",0,50,st.radius,{step=1,fmt=function(val)return val.."%"end,onChange=function(val)st.radius=val;updatePv()end})
  end

  hook(zMinus.MouseButton1Click,function()st.zoom=clamp(st.zoom-10,100,300);setSlZoom(st.zoom,false);updatePv()end)
  hook(zPlus.MouseButton1Click,function()st.zoom=clamp(st.zoom+10,100,300);setSlZoom(st.zoom,false);updatePv()end)
  hook(rstBtn.MouseButton1Click,function()
    st.fit="crop";st.zoom=100;st.x=0;st.y=0;st.aspect="auto";st.height=96;st.radius=50
    setSlZoom(100,false);setSlX(0,false);setSlY(0,false)
    if setSlExtra then setSlExtra(target=="banner"and 96 or 50,false)end
    paintStudioPills();updatePv()
  end)
  hook(reloadHdBtn.MouseButton1Click,function()if st.id~=""then S.textureMap[st.id]=nil;updatePv(true)end end)
  hook(pickStoreBtn.MouseButton1Click,function()
    F.openImageFinder(titleTxt,target=="wallpaper"and"theme"or target,function(pickedId)
      st.id=tostring(pickedId)
      updatePv(true)
    end)
  end)

  local footRow=row(scr,34)
  local cancelB=rbtn(footRow,T("cancel"),{size=u2(0.36,-3,1,0),key="btnBg",ts=11})
  local applyB=rbtn(footRow,L=="en"and" Apply Framing"or" Áp dụng khung",{size=u2(0.64,-3,1,0),key="accent",ts=11})
  F.lucide(applyB,"check",14,{pos=uo(12,10),col=H.lum(TH.accent)>0.55 and rgb(20,20,24)or c3(1,1,1),themed=false})
  hook(cancelB.MouseButton1Click,function()
    if opts.onCancel then pcall(opts.onCancel)end
    closeStudio()
  end)
  hook(applyB.MouseButton1Click,function()
    if opts.onApply then pcall(opts.onApply,st)end
    closeStudio()
  end)
  paintStudioPills()
  updatePv(true)
end

-- Namespace nội bộ cho giao diện Hồ sơ Discord-Style (giữ mỗi hàm dưới 25 upvalues cho Lua 5.1)
F._PROF={}

F._AV_DECS={
  {id="none",name="None",c1=nil,c2=nil},
  {id="chroma",name="Chroma",c1="#38BDF8",c2="#EC4899"},
  {id="flame",name="Flame",c1="#FF4500",c2="#FACC15"},
  {id="cyber",name="Cyber",c1="#00F5D4",c2="#7C3AED"},
  {id="frost",name="Frost",c1="#BAE6FD",c2="#3B82F6"},
  {id="gold",name="Gold VIP",c1="#FDE047",c2="#D97706"},
  {id="void",name="Void",c1="#A855F7",c2="#311042"},
  {id="sakura",name="Sakura",c1="#F9A8D4",c2="#F43F5E"},
}

F._NAME_EFFS={
  {id="solid",name="Solid"},
  {id="gradient",name="Gradient"},
  {id="neon",name="Neon"},
  {id="gold",name="Gold"},
  {id="ice",name="Ice"},
}

function F._PROF.initState(u,initTab)
  local isSelf=(tostring(u):lower()==P.username:lower())
  local isPov=isSelf and(S.viewAs==true)
  local canEdit=isSelf and not isPov
  local rec=S.users[u]or F.userRec(u)or{}
  local rlist=F.userRoles(u)
  local rawPt=(isSelf and type(P.profTheme)=="table"and P.profTheme)or(type(rec.profTheme)=="table"and rec.profTheme)or{}
  local mode=(rawPt.mode=="solid"or rawPt.mode=="gradient"or rawPt.mode=="mesh"or rawPt.mode=="glass"or rawPt.mode=="image")and rawPt.mode
    or((rawPt.bgImg and H.assetId(rawPt.bgImg))and"image"or((rawPt.g1 or rawPt.g2 or rawPt.g3)and"gradient"or"solid"))
  local pTheme={
    bg=H.safeHex(rawPt.bg,nil)or"",acc=H.safeHex(rawPt.acc,nil)or"",txt=H.safeHex(rawPt.txt,nil)or"",
    g1=H.safeHex(rawPt.g1,nil)or"",g2=H.safeHex(rawPt.g2,nil)or"",g3=H.safeHex(rawPt.g3,nil)or"",
    bgImg=H.assetId(rawPt.bgImg or"")or"",mode=mode,
    font=(rawPt.font and FONT_MAP[rawPt.font])and rawPt.font or"gotham",
    gRot=clamp(tonumber(rawPt.gRot)or 28,0,360),gMix=clamp(tonumber(rawPt.gMix)or 65,15,100),
    rad=clamp(tonumber(rawPt.rad)or 12,3,16),glow=rawPt.glow~=false,
    bgOp=clamp(tonumber(rawPt.bgOp)or 82,15,100),bgDim=clamp(tonumber(rawPt.bgDim)or 25,0,75),
    bf=(rawPt.bf=="fit"or rawPt.bf=="stretch"or rawPt.bf=="tile")and rawPt.bf or"crop",
    bz=clamp(tonumber(rawPt.bz)or 100,100,300),bx=clamp(tonumber(rawPt.bx)or 0,-100,100),by=clamp(tonumber(rawPt.by)or 0,-100,100),
    ba=F._ASPECT[rawPt.ba or""]and rawPt.ba or"auto",bh=clamp(tonumber(rawPt.bh)or 96,64,150),
    ["if"]=(rawPt["if"]=="fit"or rawPt["if"]=="stretch")and rawPt["if"]or"crop",
    iz=clamp(tonumber(rawPt.iz)or 100,100,300),ix=clamp(tonumber(rawPt.ix)or 0,-100,100),iy=clamp(tonumber(rawPt.iy)or 0,-100,100),
    ia=F._ASPECT[rawPt.ia or""]and rawPt.ia or"auto",ir=clamp(tonumber(rawPt.ir)or 50,0,50),
    wf=(rawPt.wf=="fit"or rawPt.wf=="stretch"or rawPt.wf=="tile")and rawPt.wf or"crop",
    wz=clamp(tonumber(rawPt.wz)or 100,100,300),wx=clamp(tonumber(rawPt.wx)or 0,-100,100),wy=clamp(tonumber(rawPt.wy)or 0,-100,100),
    wa=F._ASPECT[rawPt.wa or""]and rawPt.wa or"auto",
    avDec=tostring(rawPt.avDec or"none"),nEff=tostring(rawPt.nEff or"solid"),
    tag=H.clip(H.trim(tostring(rawPt.tag or"")),36),
    pinSc=tostring(rawPt.pinSc or""),
    wOrder=tostring(rawPt.wOrder or"bio,scripts,game,stats"),
  }
  local mappedTab=tonumber(initTab)or 1
  if not canEdit and mappedTab>2 then mappedTab=1 end
  if canEdit and initTab==3 then mappedTab=5 elseif canEdit and initTab==2 then mappedTab=3 end
  return{
    u=u,uLower=tostring(u):lower(),isSelf=isSelf,isPov=isPov,canEdit=canEdit,rec=rec,
    isDevU=F.isDev(u),rlist=rlist,top=rlist[1],
    live=(tostring(u):lower()==P.username:lower())or F.isLive(rec),
    bannerId=H.assetId((isSelf and P.profBanner)or rec.profBanner or"")or"",
    iconId=H.assetId((isSelf and P.profIcon)or rec.profIcon or"")or"",
    muteInfo=F.getMute(u),warnList=F.getWarns(u),banInfo=F.getBan(u),punishHist=F.getUserPunishments(u),
    pTheme=pTheme,curTab=mappedTab,
    cards={},subCards={},inputs={},texts={},muted={},accents={},chips={},dividers={},
    cardCorners={},subCorners={},cardStrokes={},tabBtns={},modeBtns={},fontBtns={},gStopBtns={},decBtns={},neffBtns={},
    cols={card=TH.cardBg,box=TH.bg2,acc=TH.accent,txt=TH.text,muted=TH.muted,sub=TH.bg3,inpBg=TH.inputBg,inpTxt=TH.text,cBorder=TH.border,iBorder=TH.inputBorder,g1=TH.g1 or TH.bg,g2=TH.g2 or TH.bg2,g3=TH.g3 or TH.bg3},
    ui={},fields={},fn={},
  }
end

function F._PROF.makeCard(st,parent,order,padX,padY)
  local c=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BackgroundColor3=st.cols.card,BorderSizePixel=0,LayoutOrder=order or 0},parent)
  local cc=corner(c,st.pTheme.rad or 12)
  local stObj=mk("UIStroke",{Color=st.cols.cBorder,Thickness=1,Transparency=0.4,ApplyStrokeMode=smBorder},c)
  local sg=mk("UIGradient",{Rotation=35,Enabled=false},stObj)
  pad(c,padX or 10,padY or 8,padX or 10,padY or 8);list(c,6)
  st.cards[#st.cards+1]=c;st.cardCorners[#st.cardCorners+1]=cc;st.cardStrokes[#st.cardStrokes+1]={st=stObj,sg=sg}
  return c
end

function F._PROF.section(st,parent,title,ord,icKey)
  local s=mk("Frame",{Size=u2(1,0,0,20),BackgroundTransparency=1,LayoutOrder=ord or 0},parent)
  local bar=mk("Frame",{Size=uo(3,12),Position=uo(0,4),BackgroundColor3=st.cols.acc,BorderSizePixel=0},s)corner(bar,2)
  st.accents[#st.accents+1]=bar
  local xOff=8
  if icKey then F.lucide(s,icKey,13,{pos=uo(8,3),col=st.cols.acc,themed=false});xOff=25 end
  local l=lab(s,string.upper(title),{size=u2(1,-xOff,1,0),pos=uo(xOff,0),ts=10,bold=true})
  l.TextColor3=st.cols.muted;st.muted[#st.muted+1]=l
  return s
end

function F._PROF.applyImages(st)
  local pt=st.pTheme
  local u=st.ui
  if u.bannerContainer and u.bannerContainer.Parent then
    local bh=clamp(tonumber(pt.bh)or 96,64,150)
    u.bannerContainer.Size=u2(1,0,0,bh)
    if u.hdTop and u.hdTop.Parent then u.hdTop.Size=u2(1,0,0,bh+46)end
    if u.avWrap then u.avWrap.Position=uo(14,max(8,bh-40))end
    if u.dotDot1 then u.dotDot1.Position=uo(90,bh+2)end
    if u.dotDot2 then u.dotDot2.Position=uo(98,bh-5)end
    if u.stBubble then u.stBubble.Position=uo(106,max(6,bh-24))end
    if u.bImg then
      local hasB=(st.bannerId~="")
      u.bImg.Visible=hasB
      if hasB then
        F.applyImageFrame(u.bannerContainer,u.bImg,{fit=pt.bf,zoom=pt.bz,x=pt.bx,y=pt.by,aspect=pt.ba},260,bh)
      end
    end
  end
  if u.avClip and u.avClip.Parent and u.avImg then
    local ir=clamp(tonumber(pt.ir)or 50,0,50)
    if u.avCorner then u.avCorner.CornerRadius=u1(ir/100,0)end
    if u.avOuterCorner then u.avOuterCorner.CornerRadius=u1(ir/100,0)end
    if u.avDecCorner then u.avDecCorner.CornerRadius=u1(ir/100,0)end
    if st.iconId~=""then
      F.applyImageFrame(u.avClip,u.avImg,{fit=pt["if"],zoom=pt.iz,x=pt.ix,y=pt.iy,aspect=pt.ia},76,76)
      if u.avImgCorner then
        local showDirect=(tonumber(pt.iz)or 100)<=100 and(pt["if"]=="fit"or pt["if"]=="stretch"or(pt.ia or"auto")=="auto")
        u.avImgCorner.CornerRadius=showDirect and u1(ir/100,0)or u1(0,0)
      end
    else
      u.avImg.AnchorPoint=v2(0.5,0.5);u.avImg.Position=us(0.5,0.5);u.avImg.Size=us(1,1);u.avImg.ScaleType=Enum.ScaleType.Crop
      if u.avImgCorner then u.avImgCorner.CornerRadius=u1(0.5,0)end
    end
  end
  if u.boxBgImg and u.boxBgImg.Parent and pt.bgImg~=""then
    local bw,bh=u.box and u.box.AbsoluteSize.X or 420,u.box and u.box.AbsoluteSize.Y or 540
    F.applyImageFrame(u.box,u.boxBgImg,{fit=pt.wf,zoom=pt.wz,x=pt.wx,y=pt.wy,aspect=pt.wa},bw,bh)
  end
end

function F._PROF.applyColors(st,bgHex,accHex,txtHex)
  local pt=st.pTheme
  if bgHex~=nil then pt.bg=bgHex end
  if accHex~=nil then pt.acc=accHex end
  if txtHex~=nil then pt.txt=txtHex end
  local vBg=H.safeHex(pt.bg,nil);local vAcc=H.safeHex(pt.acc,nil);local vTxt=H.safeHex(pt.txt,nil)
  local vG1=H.safeHex(pt.g1,nil);local vG2=H.safeHex(pt.g2,nil);local vG3=H.safeHex(pt.g3,nil)
  local mode=pt.mode or"solid"
  local hasCustom=(vBg and pt.bg~="")or(vG1 and pt.g1~="")or(vG2 and pt.g2~="")or(vG3 and pt.g3~="")or mode~="solid"
  local cols=st.cols
  if not hasCustom and not vAcc and not vTxt then
    cols.card=TH.cardBg;cols.box=TH.bg2
  else
    cols.card=(vBg and pt.bg~=""and H.hex(vBg))or(vG1 and pt.g1~=""and H.hex(vG1))or TH.cardBg
    cols.box=(H.lum(cols.card)<0.45)and H.mix(cols.card,c3(0,0,0),0.22)or H.mix(cols.card,c3(1,1,1),0.22)
  end
  cols.acc=(vAcc and pt.acc~=""and H.hex(vAcc))or(st.top and H.hex(st.top.color))or(st.isDevU and H.hex(F.DEVROLE.color))or TH.accent
  local rawTxt=(vTxt and pt.txt~=""and H.hex(vTxt))or(hasCustom and(H.lum(cols.card)<0.45 and rgb(244,245,248)or rgb(18,20,28))or TH.text)
  cols.txt=H.ensureContrast(rawTxt,cols.card,4.6)
  cols.muted=H.ensureContrast(H.mix(cols.txt,cols.card,0.38),cols.card,3.2)
  cols.sub=(H.lum(cols.card)<0.45)and H.mix(cols.card,c3(0,0,0),0.28)or H.mix(cols.card,c3(1,1,1),0.65)
  cols.inpBg=(H.lum(cols.card)<0.45)and H.mix(cols.card,c3(0,0,0),0.42)or H.mix(cols.card,c3(1,1,1),0.85)
  cols.inpTxt=H.ensureContrast(cols.txt,cols.inpBg,4.6)
  cols.cBorder=H.mix(cols.card,cols.acc,0.36)
  cols.iBorder=H.mix(cols.inpBg,cols.acc,0.42)

  local gMix=clamp((tonumber(pt.gMix)or 65)/100,0.15,1)
  cols.g1=H.mix(cols.box,(vG1 and pt.g1~=""and H.hex(vG1))or cols.box,gMix)
  cols.g2=H.mix(cols.box,(vG2 and pt.g2~=""and H.hex(vG2))or H.mix(cols.box,cols.acc,0.38),gMix)
  cols.g3=H.mix(cols.card,(vG3 and pt.g3~=""and H.hex(vG3))or H.mix(cols.card,TH.ok,0.28),gMix)

  local rad=clamp(tonumber(pt.rad)or 12,3,16)
  local gRot=clamp(tonumber(pt.gRot)or 28,0,360)
  local useGlow=(pt.glow~=false)
  local useGrad=(mode=="gradient"or mode=="mesh"or mode=="glass")
  local isGlass=(mode=="glass")
  local cardTrans=isGlass and 0.24 or(useGrad and 0.08 or 0)
  local fm=FONT_MAP[pt.font or"gotham"]or FONT_MAP.gotham
  local pReg,pBold=fm.reg,fm.bold
  local u=st.ui

  if u.box and u.box.Parent then
    local bc=u.box:FindFirstChildOfClass("UICorner")
    if bc then bc.CornerRadius=u1(0,max(6,rad+2))end
    for _,co in ipairs({u.boxGradCorner,u.boxMeshCorner,u.boxImgCorner,u.boxTintCorner})do if co then co.CornerRadius=u1(0,max(6,rad+2))end end
    u.box.BackgroundColor3=cols.box
    u.box.BackgroundTransparency=isGlass and 0.16 or 0
    u.boxGradFrame.Visible=useGrad
    u.boxGradFrame.BackgroundTransparency=isGlass and 0.18 or 0.04
    u.boxUIGrad.Rotation=gRot
    if isGlass then
      u.boxUIGrad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,H.mix(cols.box,cols.acc,0.22)),ColorSequenceKeypoint.new(0.5,cols.card),ColorSequenceKeypoint.new(1,H.mix(cols.box,cols.g3,0.38))})
    else
      u.boxUIGrad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,cols.g1),ColorSequenceKeypoint.new(0.52,cols.g2),ColorSequenceKeypoint.new(1,cols.g3)})
    end
    u.boxMeshFrame.Visible=(mode=="mesh")
    u.boxMeshGrad.Rotation=(gRot+115)%360
    u.boxMeshGrad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,cols.acc),ColorSequenceKeypoint.new(0.55,cols.g2),ColorSequenceKeypoint.new(1,cols.g3)})
    if st.fn.updWallpaper then st.fn.updWallpaper(pt.bgImg or"")end
    u.boxTintFrame.Visible=(pt.bgImg~=""and(tonumber(pt.bgDim)or 25)>0)
    u.boxTintFrame.BackgroundColor3=cols.box
    u.boxTintFrame.BackgroundTransparency=1-clamp((tonumber(pt.bgDim)or 25)/100,0,0.75)
    if u.boxStroke then
      u.boxStroke.Color=useGlow and c3(1,1,1)or cols.cBorder
      u.boxStroke.Thickness=useGlow and 1.5 or 1.2
      u.boxStroke.Transparency=isGlass and 0.15 or(useGlow and 0.2 or 0.4)
    end
    if u.boxStrokeGrad then
      u.boxStrokeGrad.Enabled=useGlow;u.boxStrokeGrad.Rotation=(gRot+18)%360
      u.boxStrokeGrad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,cols.acc),ColorSequenceKeypoint.new(0.5,H.mix(cols.acc,cols.g3,0.58)),ColorSequenceKeypoint.new(1,H.mix(cols.acc,cols.g2,0.48))})
    end
    for _,ch in ipairs(u.box:GetChildren())do
      if ch:IsA("Frame")and ch.Size.Y.Offset==34 then
        for _,lbl in ipairs(ch:GetChildren())do if lbl:IsA("TextLabel")then lbl.TextColor3=cols.txt;lbl.Font=pBold end end
      elseif ch:IsA("Frame")and ch.Size.Y.Offset==1 then ch.BackgroundColor3=cols.cBorder end
    end
  end

  if u.bannerGrad then
    u.bannerGrad.Rotation=gRot
    u.bannerGrad.Color=ColorSequence.new({
      ColorSequenceKeypoint.new(0,useGrad and cols.g1 or cols.acc),
      ColorSequenceKeypoint.new(0.52,useGrad and cols.g2 or H.mix(cols.acc,c3(0,0,0),0.26)),
      ColorSequenceKeypoint.new(1,useGrad and cols.g3 or H.mix(cols.acc,c3(1,1,1),0.14)),
    })
  end
  if u.hdGradFrame and u.hdUIGrad then
    u.hdGradFrame.Visible=useGrad;u.hdGradFrame.BackgroundTransparency=isGlass and 0.35 or 0.22;u.hdUIGrad.Rotation=gRot
    u.hdUIGrad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,H.mix(cols.card,cols.g1,0.65)),ColorSequenceKeypoint.new(0.52,H.mix(cols.card,cols.g2,0.65)),ColorSequenceKeypoint.new(1,H.mix(cols.card,cols.g3,0.65))})
  end
  for _,cc in ipairs(st.cardCorners)do if cc and cc.Parent then cc.CornerRadius=u1(0,rad)end end
  for _,sc in ipairs(st.subCorners)do if sc and sc.Parent then sc.CornerRadius=u1(0,max(4,rad-2))end end
  for _,c in ipairs(st.cards)do if c and c.Parent then c.BackgroundColor3=cols.card;if c~=u.avWrap and c~=u.stBubble then c.BackgroundTransparency=cardTrans end end end
  for _,cs in ipairs(st.cardStrokes)do
    if cs.st and cs.st.Parent then
      cs.st.Color=useGlow and c3(1,1,1)or cols.cBorder;cs.st.Thickness=useGlow and 1.25 or 1;cs.st.Transparency=useGlow and 0.26 or 0.42
      if cs.sg then cs.sg.Enabled=useGlow;cs.sg.Rotation=(gRot+22)%360;cs.sg.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,cols.acc),ColorSequenceKeypoint.new(0.5,H.mix(cols.acc,cols.g3,0.55)),ColorSequenceKeypoint.new(1,H.mix(cols.acc,cols.g2,0.45))})end
    end
  end
  for _,c in ipairs(st.subCards)do
    if c and c.Parent then c.BackgroundColor3=cols.sub;c.BackgroundTransparency=isGlass and 0.25 or 0;local so=c:FindFirstChildOfClass("UIStroke");if so then so.Color=cols.cBorder end end
  end
  for _,inp in ipairs(st.inputs)do
    if inp and inp.Parent then inp.BackgroundColor3=cols.inpBg;inp.TextColor3=cols.inpTxt;inp.PlaceholderColor3=cols.muted;if inp.Font~=fCode then inp.Font=pReg end;local so=inp:FindFirstChildOfClass("UIStroke");if so then so.Color=cols.iBorder end end
  end
  for _,lbl in ipairs(st.texts)do if lbl and lbl.Parent then lbl.TextColor3=cols.txt;local isB=(lbl.Font==fGB or lbl.Font==Enum.Font.GothamBold or lbl.Font==Enum.Font.SourceSansBold or lbl.Font==Enum.Font.RobotoMono or lbl.Font==Enum.Font.FredokaOne);lbl.Font=isB and pBold or pReg end end
  for _,lbl in ipairs(st.muted)do if lbl and lbl.Parent then lbl.TextColor3=cols.muted;local isB=(lbl.Font==fGB or lbl.Font==Enum.Font.GothamBold or lbl.Font==Enum.Font.SourceSansBold or lbl.Font==Enum.Font.RobotoMono or lbl.Font==Enum.Font.FredokaOne);lbl.Font=isB and pBold or pReg end end
  for _,item in ipairs(st.accents)do
    if item and item.Parent then
      if item:IsA("UIStroke")then item.Color=cols.acc
      elseif item:IsA("TextLabel")then item.TextColor3=H.ensureContrast(cols.acc,cols.card,4.2);item.Font=pBold
      elseif item:IsA("TextButton")then item.BackgroundColor3=cols.acc;item.TextColor3=H.ensureContrast(rgb(255,255,255),cols.acc,4.5);item.Font=pBold
      else item.BackgroundColor3=cols.acc end
    end
  end
  for _,chip in ipairs(st.chips)do
    if chip and chip.Parent then chip.BackgroundColor3=cols.sub;chip.TextColor3=cols.txt;chip.Font=pBold;local so=chip:FindFirstChildOfClass("UIStroke");if so then so.Color=cols.cBorder end end
  end
  for _,d in ipairs(st.dividers)do if d and d.Parent then d.BackgroundColor3=cols.cBorder end end
  if u.avWrap then u.avWrap.BackgroundColor3=cols.card end
  if u.avStroke then u.avStroke.Color=cols.card end
  if u.avDotStroke then u.avDotStroke.Color=cols.card end
  if u.dotDot1 then u.dotDot1.BackgroundColor3=cols.sub;local s1=u.dotDot1:FindFirstChildOfClass("UIStroke");if s1 then s1.Color=cols.cBorder end end
  if u.dotDot2 then u.dotDot2.BackgroundColor3=cols.sub;local s2=u.dotDot2:FindFirstChildOfClass("UIStroke");if s2 then s2.Color=cols.cBorder end end
  if u.stBubble then u.stBubble.BackgroundColor3=cols.sub;local sb=u.stBubble:FindFirstChildOfClass("UIStroke");if sb then sb.Color=cols.cBorder end end
  if u.stBubbleLbl then u.stBubbleLbl.Font=pReg end

  -- Áp dụng Avatar Decoration & Name Effect (Discord-style)
  if u.avDecFrame and u.avDecStroke and u.avDecGrad then
    local decInfo
    for _,d in ipairs(F._AV_DECS)do if d.id==(pt.avDec or"none")then decInfo=d;break end end
    local showDec=(decInfo and decInfo.c1~=nil)
    u.avDecFrame.Visible=showDec
    if showDec then
      u.avDecStroke.Color=c3(1,1,1)
      u.avDecGrad.Color=ColorSequence.new(H.hex(decInfo.c1),H.hex(decInfo.c2))
    end
  end
  if u.dnameLbl and u.dnameLbl.Parent then
    u.dnameLbl.Font=pBold
    local eff=pt.nEff or"solid"
    if eff=="solid"then
      u.dnameLbl.TextColor3=H.ensureContrast(cols.txt,cols.card,4.6)
      if u.dnameGrad then u.dnameGrad.Enabled=false end
      if u.dnameStroke then u.dnameStroke.Transparency=1 end
    else
      u.dnameLbl.TextColor3=c3(1,1,1)
      if u.dnameGrad then
        u.dnameGrad.Enabled=true
        if eff=="neon"then u.dnameGrad.Color=ColorSequence.new(rgb(110,231,255),rgb(192,132,252))
        elseif eff=="gold"then u.dnameGrad.Color=ColorSequence.new(rgb(254,240,138),rgb(234,179,8))
        elseif eff=="ice"then u.dnameGrad.Color=ColorSequence.new(rgb(224,247,255),rgb(56,189,248))
        else u.dnameGrad.Color=ColorSequence.new(cols.acc,H.mix(cols.acc,cols.txt,0.45))end
      end
      if u.dnameStroke then
        u.dnameStroke.Transparency=(eff=="neon")and 0.2 or 0.45
        u.dnameStroke.Color=(eff=="neon")and H.mix(cols.acc,c3(0,0,0),0.5)or rgb(12,14,20)
      end
    end
  end

  if st.fn.refreshTabVisuals then st.fn.refreshTabVisuals()end
  for k,mb in pairs(st.modeBtns)do if mb.btn and mb.btn.Parent then local on=(mode==k);mb.btn.BackgroundColor3=on and cols.acc or cols.sub;mb.btn.TextColor3=on and H.ensureContrast(rgb(255,255,255),cols.acc,4.5)or cols.txt;if mb.st then mb.st.Color=on and cols.acc or cols.cBorder end end end
  for k,fb in pairs(st.fontBtns)do if fb.btn and fb.btn.Parent then local on=((pt.font or"gotham")==k);fb.btn.BackgroundColor3=on and cols.acc or cols.sub;fb.btn.TextColor3=on and H.ensureContrast(rgb(255,255,255),cols.acc,4.5)or cols.txt;if fb.st then fb.st.Color=on and cols.acc or cols.cBorder end end end
  for k,db in pairs(st.decBtns)do if db.btn and db.btn.Parent then local on=((pt.avDec or"none")==k);db.btn.BackgroundColor3=on and cols.acc or cols.sub;db.btn.TextColor3=on and H.ensureContrast(rgb(255,255,255),cols.acc,4.5)or cols.txt;if db.st then db.st.Color=on and cols.acc or cols.cBorder end end end
  for k,nb in pairs(st.neffBtns)do if nb.btn and nb.btn.Parent then local on=((pt.nEff or"solid")==k);nb.btn.BackgroundColor3=on and cols.acc or cols.sub;nb.btn.TextColor3=on and H.ensureContrast(rgb(255,255,255),cols.acc,4.5)or cols.txt;if nb.st then nb.st.Color=on and cols.acc or cols.cBorder end end end
  for gk,gb in pairs(st.gStopBtns)do
    if gb.sw and gb.sw.Parent then
      local cC=(gk=="g1"and cols.g1)or(gk=="g2"and cols.g2)or cols.g3
      gb.sw.BackgroundColor3=cC;gb.lbl.Text=gb.title.." "..H.tohex(cC);gb.lbl.TextColor3=cols.txt
      gb.btn.BackgroundColor3=cols.sub;if gb.st then gb.st.Color=cols.cBorder end
    end
  end
  if st.fn.refreshColorPickBtns then st.fn.refreshColorPickBtns(vBg,vAcc,vTxt)end
  F._PROF.applyImages(st)
end

function F._PROF.buildLeftIdentity(st,parent)
  local u=st.ui
  local pt=st.pTheme
  local bh=clamp(tonumber(pt.bh)or 96,64,150)
  local hd=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BackgroundColor3=st.cols.card,BorderSizePixel=0,ClipsDescendants=true,LayoutOrder=1},parent)
  st.cards[#st.cards+1]=hd;st.cardCorners[#st.cardCorners+1]=corner(hd,pt.rad or 12)
  local hdSt=mk("UIStroke",{Color=st.cols.cBorder,Thickness=1.3,Transparency=0.25,ApplyStrokeMode=smBorder},hd)
  st.cardStrokes[#st.cardStrokes+1]={st=hdSt,sg=mk("UIGradient",{Rotation=35,Enabled=pt.glow~=false},hdSt)}

  u.hdGradFrame=mk("Frame",{Size=us(1,1),BackgroundColor3=c3(1,1,1),BackgroundTransparency=0.22,BorderSizePixel=0,ZIndex=1,Visible=false},hd)
  st.cardCorners[#st.cardCorners+1]=corner(u.hdGradFrame,pt.rad or 12)
  u.hdUIGrad=mk("UIGradient",{Rotation=pt.gRot or 28},u.hdGradFrame)

  local hdContent=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BackgroundTransparency=1,ZIndex=2},hd)
  list(hdContent,0)

  local hdTop=mk("Frame",{Size=u2(1,0,0,bh+46),BackgroundTransparency=1,LayoutOrder=1},hdContent)
  u.hdTop=hdTop
  local banner=mk("Frame",{Size=u2(1,0,0,bh),BackgroundColor3=c3(1,1,1),BorderSizePixel=0,ClipsDescendants=true,ZIndex=2},hdTop)
  u.bannerContainer=banner
  st.cardCorners[#st.cardCorners+1]=corner(banner,pt.rad or 12)
  u.bannerGrad=mk("UIGradient",{Rotation=pt.gRot or 22},banner)
  u.bImg=mk("ImageLabel",{Size=us(1,1),BackgroundTransparency=1,Image="",Visible=(st.bannerId~=""),ScaleType=Enum.ScaleType.Crop,BorderSizePixel=0,ZIndex=3},banner)
  if st.bannerId~=""then F.setAsset(u.bImg,st.bannerId)end

  if st.canEdit then
    local qCrop=mk("TextButton",{Size=uo(72,22),Position=u2(1,-78,0,8),BackgroundColor3=rgb(14,16,22),BackgroundTransparency=0.28,Text="",AutoButtonColor=true,BorderSizePixel=0,ZIndex=6},hdTop)
    corner(qCrop,11);stroke(qCrop,"border",1,0.3)
    F.lucide(qCrop,"crop",11,{pos=uo(7,5),col=c3(1,1,1),themed=false})
    local qcl=lab(qCrop,L=="en"and"Frame"or"Căn bìa",{size=u2(1,-22,1,0),pos=uo(20,0),ts=9,bold=true});qcl.TextColor3=c3(1,1,1)
    hook(qCrop.MouseButton1Click,function()
      F.openImageCropStudio({
        target="banner",assetId=st.bannerId,
        cfg={fit=pt.bf,zoom=pt.bz,x=pt.bx,y=pt.by,aspect=pt.ba,height=pt.bh},
        onApply=function(res)
          st.bannerId=res.id or""
          if st.fields.tBanner then st.fields.tBanner.Text=st.bannerId end
          pt.bf=res.fit;pt.bz=res.zoom;pt.bx=res.x;pt.by=res.y;pt.ba=res.aspect;pt.bh=res.height
          if st.bannerId~=""then F.setAsset(u.bImg,st.bannerId)end
          F._PROF.applyImages(st)
        end,
      })
    end)
  end

  -- Avatar nổi overlapping Banner (Discord cutout ring + Decoration ring + Online dot)
  local ir=clamp(tonumber(pt.ir)or 50,0,50)
  local avWrap=mk("Frame",{Size=uo(78,78),Position=uo(14,max(8,bh-40)),BackgroundColor3=st.cols.card,BorderSizePixel=0,ZIndex=6},hdTop)
  u.avWrap=avWrap;st.cards[#st.cards+1]=avWrap
  u.avOuterCorner=mk("UICorner",{CornerRadius=u1(ir/100,0)},avWrap)
  u.avStroke=mk("UIStroke",{Color=st.cols.card,Thickness=4,Transparency=0,ApplyStrokeMode=smBorder},avWrap)

  local avDecFrame=mk("Frame",{Size=u2(1,6,1,6),Position=uo(-3,-3),BackgroundTransparency=1,BorderSizePixel=0,ZIndex=7,Visible=false},avWrap)
  u.avDecFrame=avDecFrame
  u.avDecCorner=mk("UICorner",{CornerRadius=u1(ir/100,0)},avDecFrame)
  u.avDecStroke=mk("UIStroke",{Color=c3(1,1,1),Thickness=2.6,Transparency=0,ApplyStrokeMode=smBorder},avDecFrame)
  u.avDecGrad=mk("UIGradient",{Rotation=35},u.avDecStroke)

  local avClip=F.createClipHost(avWrap,{Size=us(1,1),BackgroundTransparency=1,BorderSizePixel=0,ClipsDescendants=true,ZIndex=8})
  u.avClip=avClip
  u.avCorner=mk("UICorner",{CornerRadius=u1(ir/100,0)},avClip)
  u.avImg=mk("ImageLabel",{Size=us(1,1),BackgroundTransparency=1,BorderSizePixel=0,Image=st.iconId~=""and F.thumbUrl(st.iconId,420,420)or F.avatarUrl(F.uidOf(st.u)),ScaleType=Enum.ScaleType.Crop,ZIndex=9},avClip)
  u.avImgCorner=mk("UICorner",{CornerRadius=u1(ir/100,0)},u.avImg)
  if st.iconId~=""then F.setAsset(u.avImg,st.iconId)end

  local dotCol=st.banInfo and TH.danger or(st.muteInfo and TH.warn or(st.live and rgb(35,165,90)or rgb(128,132,142)))
  local dot=mk("Frame",{Size=uo(16,16),Position=u2(1,-16,1,-16),BackgroundColor3=dotCol,BorderSizePixel=0,ZIndex=11},avWrap)
  corner(dot,8);u.avDotStroke=mk("UIStroke",{Thickness=2.6,Color=st.cols.card,ApplyStrokeMode=smBorder},dot)

  -- Bong bóng suy nghĩ (Status Thought Bubble kiểu Discord kèm 2 chấm nối)
  local stShort=(st.isSelf and P.status)or st.rec.status or""
  u.dotDot1=mk("Frame",{Size=uo(6,6),Position=uo(90,bh+2),BackgroundColor3=st.cols.sub,BorderSizePixel=0,ZIndex=7,Visible=(stShort~=""or st.canEdit)},hdTop)
  corner(u.dotDot1,3);mk("UIStroke",{Color=st.cols.cBorder,Thickness=1,Transparency=0.35},u.dotDot1)
  u.dotDot2=mk("Frame",{Size=uo(9,9),Position=uo(98,bh-5),BackgroundColor3=st.cols.sub,BorderSizePixel=0,ZIndex=7,Visible=(stShort~=""or st.canEdit)},hdTop)
  corner(u.dotDot2,5);mk("UIStroke",{Color=st.cols.cBorder,Thickness=1,Transparency=0.35},u.dotDot2)

  local stBubble=mk("TextButton",{
    Size=u2(1,-116,0,38),Position=uo(106,max(6,bh-24)),
    BackgroundColor3=st.cols.sub,Text="",AutoButtonColor=st.canEdit,BorderSizePixel=0,ZIndex=8,ClipsDescendants=true,
    Visible=(stShort~=""or st.canEdit),
  },hdTop)
  u.stBubble=stBubble;corner(stBubble,12);mk("UIStroke",{Color=st.cols.cBorder,Thickness=1,Transparency=0.35,ApplyStrokeMode=smBorder},stBubble)
  pad(stBubble,8,3,8,3)
  u.stBubbleLbl=lab(stBubble,stShort~=""and F.disp(stShort)or(L=="en"and"+ Set status..."or"+ Đặt trạng thái..."),{size=us(1,1),ts=10,wrap=true,trunc=true,align=txL})
  st[stShort~=""and"texts"or"muted"][#st[stShort~=""and"texts"or"muted"]+1]=u.stBubbleLbl
  if st.canEdit then hook(stBubble.MouseButton1Click,function()if st.fn.setTab then st.fn.setTab(3)end end)end

  -- Phần thân dưới Identity Card (Tên, Tag, Huy hiệu, Nút hành động, Roles, Member Meta, Ghi chú riêng)
  local body=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BackgroundTransparency=1,LayoutOrder=2},hdContent)
  pad(body,14,2,14,12);list(body,7)

  local nameCol=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BackgroundTransparency=1,LayoutOrder=1},body)
  list(nameCol,2)
  local dStr=F.disp((st.isSelf and P.display)or st.rec.display or st.u)
  u.dnameLbl=mk("TextLabel",{Size=u2(1,0,0,22),BackgroundTransparency=1,Text=dStr,Font=fGB,TextSize=16,TextXAlignment=txL,TextTruncate=trEnd,BorderSizePixel=0,LayoutOrder=1},nameCol)
  u.dnameGrad=mk("UIGradient",{Rotation=15,Enabled=false},u.dnameLbl)
  local okCtx,ctxMode=pcall(function()return Enum.ApplyStrokeMode.Contextual end)
  u.dnameStroke=mk("UIStroke",{Thickness=1.2,Transparency=1,Color=rgb(12,14,20),ApplyStrokeMode=okCtx and ctxMode or smBorder},u.dnameLbl)

  local handleRow=mk("Frame",{Size=u2(1,0,0,18),BackgroundTransparency=1,LayoutOrder=2},nameCol)
  mk("UIListLayout",{FillDirection=fdH,Padding=u1(0,6),SortOrder=soLO,VerticalAlignment=vaC},handleRow)
  local uBtn=mk("TextButton",{Size=uo(min(150,max(48,H.textW("@"..st.u,11,fG)+6)),16),BackgroundTransparency=1,Text="@"..st.u,Font=fG,TextSize=11,TextXAlignment=txL,TextTruncate=trEnd,BorderSizePixel=0,LayoutOrder=1},handleRow)
  st.muted[#st.muted+1]=uBtn
  hook(uBtn.MouseButton1Click,function()F.copyText("@"..st.u)end)

  local cc=H.resolveCountry((st.isSelf and P.country)or st.rec.country or"??")
  local cPill=mk("Frame",{Size=uo(50,16),BackgroundColor3=st.cols.sub,BorderSizePixel=0,LayoutOrder=2,Visible=(cc~=""and cc~="??")},handleRow)
  corner(cPill,8);mk("UIStroke",{Color=st.cols.cBorder,Thickness=1,Transparency=0.5,ApplyStrokeMode=smBorder},cPill)
  st.subCards[#st.subCards+1]=cPill
  local cPillLbl=lab(cPill,"",{size=us(1,1),ts=9,bold=true,align=txC,trunc=true});st.texts[#st.texts+1]=cPillLbl
  st.fn.refreshFlag=function(codeRaw)
    local c2=H.resolveCountry(codeRaw)
    if c2~=""and c2~="??"then
      local ft=H.flag(c2).." "..c2
      cPill.Size=uo(clamp(H.textW(ft,9,fGB)+12,40,86),16);cPillLbl.Text=ft;cPill.Visible=true
    else cPill.Visible=false end
  end
  st.fn.refreshFlag(cc)

  u.flairPill=mk("Frame",{Size=uo(70,18),BackgroundColor3=st.cols.sub,BorderSizePixel=0,LayoutOrder=3,Visible=(pt.tag~="")},handleRow)
  corner(u.flairPill,9);mk("UIStroke",{Color=st.cols.acc,Thickness=1,Transparency=0.35,ApplyStrokeMode=smBorder},u.flairPill)
  st.subCards[#st.subCards+1]=u.flairPill
  u.flairLbl=lab(u.flairPill,"",{size=us(1,1),ts=9,bold=true,align=txC,trunc=true})
  st.accents[#st.accents+1]=u.flairLbl
  st.fn.refreshFlair=function(txt)
    local clean=H.clip(H.trim(tostring(txt or"")),36)
    pt.tag=clean;u.flairPill.Visible=(clean~="")
    if clean~=""then u.flairLbl.Text=F.disp(clean);u.flairPill.Size=uo(clamp(H.textW(clean,9,fGB)+16,44,126),18)end
  end
  st.fn.refreshFlair(pt.tag)

  -- Dải huy hiệu gọn gàng (Status, Dev, Script Author, Theme/Mod Badges)
  local badgeWrap=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BackgroundTransparency=1,LayoutOrder=2},body)
  mk("UIListLayout",{FillDirection=fdH,Wraps=true,Padding=u1(0,4),SortOrder=soLO,VerticalAlignment=vaC},badgeWrap)
  local function badgePill(txt,col,icKey,ord)
    local offX=icKey and 16 or 0
    local pw=clamp(H.textW(txt,9,fGB)+12+offX,42,130)
    local p=mk("Frame",{Size=uo(pw,18),BackgroundColor3=col,BackgroundTransparency=0.84,BorderSizePixel=0,LayoutOrder=ord},badgeWrap)
    corner(p,9);mk("UIStroke",{Color=col,Thickness=1,Transparency=0.5,ApplyStrokeMode=smBorder},p)
    if icKey then F.lucide(p,icKey,10,{pos=uo(6,4),col=col,themed=false})end
    local pl=lab(p,txt,{size=u2(1,-offX-4,1,0),pos=uo(offX+2,0),ts=9,bold=true,align=txC,trunc=true});pl.TextColor3=col
    return p,pl
  end
  local bOrd=1
  badgePill(st.live and T("live")or T("off"),st.live and TH.ok or TH.muted,"activity",bOrd);bOrd=bOrd+1
  if st.isDevU then badgePill("DEV",rgb(250,168,26),"crown",bOrd);bOrd=bOrd+1 end
  local scCount=0
  for _,sc in ipairs(S.scripts or{})do if tostring(sc.author or""):lower()==st.uLower then scCount=scCount+1 end end
  if scCount>0 then badgePill(scCount.." Script"..(scCount>1 and"s"or""),st.cols.acc,"code",bOrd);bOrd=bOrd+1 end
  if st.muteInfo then badgePill("MUTED",TH.danger,"volumeX",bOrd);bOrd=bOrd+1 end
  if st.banInfo then badgePill("BANNED",TH.danger,"ban",bOrd);bOrd=bOrd+1 end
  if#st.warnList>0 then badgePill(#st.warnList.." "..T("warnings"),TH.warn,"alertTri",bOrd);bOrd=bOrd+1 end
  local chromaP,chromaPL=badgePill("CHROMA",st.cols.acc,"sparkles",bOrd);bOrd=bOrd+1
  st.fn.refreshThemeBadges=function()
    local m=pt.mode or"solid";local isCh=(m=="gradient"or m=="mesh"or m=="glass")
    chromaP.Visible=isCh
    if isCh then
      local mt=(m=="mesh"and"MESH")or(m=="glass"and"GLASS")or"CHROMA"
      chromaPL.Text=mt;chromaP.Size=uo(clamp(H.textW(mt,9,fGB)+28,58,108),18)
    end
  end
  st.fn.refreshThemeBadges()

  -- Hàng nút hành động chính kiểu Discord [Edit / Studio / POV] hoặc [DM / Join / More]
  local actRow=row(body,30,3)
  if st.canEdit then
    local edB=tbtn(actRow,"  "..(L=="en"and"Edit Profile"or"Sửa hồ sơ"),{size=u2(1,-104,1,0),key="accent",ts=11,r=7,layout=1})
    st.accents[#st.accents+1]=edB
    F.lucide(edB,"pencil",13,{pos=uo(10,8),col=H.lum(st.cols.acc)>0.55 and rgb(20,20,24)or c3(1,1,1),themed=false})
    hook(edB.MouseButton1Click,function()if st.fn.setTab then st.fn.setTab(3)end end)

    local imgB=tbtn(actRow,"",{size=uo(30,30),key="btnBg",r=7,layout=2})
    st.chips[#st.chips+1]=imgB;F.lucide(imgB,"crop",14,{pos=uo(8,8),col=st.cols.txt,themed=false})
    hook(imgB.MouseButton1Click,function()if st.fn.setTab then st.fn.setTab(4)end end)

    local povB=tbtn(actRow,"",{size=uo(30,30),key="btnBg",r=7,layout=3})
    st.chips[#st.chips+1]=povB;F.lucide(povB,S.viewAs and"eyeOff"or"eye",14,{pos=uo(8,8),col=st.cols.txt,themed=false})
    hook(povB.MouseButton1Click,function()S.viewAs=not S.viewAs;F.openProfile(st.u,1)end)

    local setB=tbtn(actRow,"",{size=uo(30,30),key="btnBg",r=7,layout=4})
    st.chips[#st.chips+1]=setB;F.lucide(setB,"settings",14,{pos=uo(8,8),col=st.cols.txt,themed=false})
    hook(setB.MouseButton1Click,function()F.openSettings()end)
  else
    local dmB=tbtn(actRow,"  "..T("dm"),{size=u2(1,-70,1,0),key="accent",ts=11,r=7,layout=1})
    st.accents[#st.accents+1]=dmB
    F.lucide(dmB,"msgCircle",13,{pos=uo(10,8),col=H.lum(st.cols.acc)>0.55 and rgb(20,20,24)or c3(1,1,1),themed=false})
    hook(dmB.MouseButton1Click,function()F.openDM(st.u)end)

    local copyB=tbtn(actRow,"",{size=uo(30,30),key="btnBg",r=7,layout=2})
    st.chips[#st.chips+1]=copyB;F.lucide(copyB,"copy",13,{pos=uo(8,8),col=st.cols.txt,themed=false})
    hook(copyB.MouseButton1Click,function()F.copyText("@"..st.u)end)

    local thirdB=tbtn(actRow,"",{size=uo(30,30),key="btnBg",r=7,layout=3})
    st.chips[#st.chips+1]=thirdB
    if st.isSelf then
      F.lucide(thirdB,"eyeOff",14,{pos=uo(8,8),col=TH.ok,themed=false})
      hook(thirdB.MouseButton1Click,function()S.viewAs=false;F.openProfile(st.u,1)end)
    else
      F.lucide(thirdB,"flag",13,{pos=uo(8,8),col=TH.warn,themed=false})
      hook(thirdB.MouseButton1Click,function()F.openReport(st.u)end)
    end
  end

  local d1=mk("Frame",{Size=u2(1,0,0,1),BackgroundColor3=st.cols.cBorder,BackgroundTransparency=0.5,BorderSizePixel=0,LayoutOrder=4},body)
  st.dividers[#st.dividers+1]=d1

  -- Thông tin Roblox UserId + Executor/Server gọn gàng kiểu "Member Since"
  local metaBox=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BackgroundTransparency=1,LayoutOrder=5},body)
  list(metaBox,4)
  local hdrMeta=lab(metaBox,L=="en"and"ROBLOX & SCRIPT INFO"or"THÔNG TIN ROBLOX",{ts=9,bold=true,layout=1});st.muted[#st.muted+1]=hdrMeta
  local uidVal=F.uidOf(st.u)
  local m1=mk("TextButton",{Size=u2(1,0,0,18),BackgroundTransparency=1,Text="",AutoButtonColor=true,LayoutOrder=2},metaBox)
  F.lucide(m1,"hash",12,{pos=uo(0,3),col=st.cols.muted,themed=false})
  local m1l=lab(m1,"UserId: "..tostring(uidVal).." ("..(L=="en"and"tap copy"or"chạm sao chép")..")",{size=u2(1,-18,1,0),pos=uo(18,0),ts=10,trunc=true})
  st.texts[#st.texts+1]=m1l
  hook(m1.MouseButton1Click,function()F.copyText(tostring(uidVal))end)

  if st.isSelf then
    local m2=mk("Frame",{Size=u2(1,0,0,18),BackgroundTransparency=1,LayoutOrder=3},metaBox)
    F.lucide(m2,"terminal",12,{pos=uo(0,3),col=st.cols.muted,themed=false})
    local m2l=lab(m2,"Executor: "..tostring(EXEC).." · v"..tostring(CFG.VERSION),{size=u2(1,-18,1,0),pos=uo(18,0),ts=10,trunc=true})
    st.texts[#st.texts+1]=m2l
  elseif not st.live and tonumber(st.rec.lastSeen)and tonumber(st.rec.lastSeen)>0 then
    local m2=mk("Frame",{Size=u2(1,0,0,18),BackgroundTransparency=1,LayoutOrder=3},metaBox)
    F.lucide(m2,"clock",12,{pos=uo(0,3),col=st.cols.muted,themed=false})
    local lsTxt=F.fmtTimeFull and F.fmtTimeFull(st.rec.lastSeen)or""
    local m2l=lab(m2,(L=="en"and"Last seen: "or"Hoạt động: ")..(lsTxt~=""and lsTxt or os.date("%H:%M",tonumber(st.rec.lastSeen))),{size=u2(1,-18,1,0),pos=uo(18,0),ts=10,trunc=true})
    st.muted[#st.muted+1]=m2l
  end

  -- Roles
  local roleHdr=lab(body,L=="en"and"ROLES"or"VAI TRÒ (ROLES)",{ts=9,bold=true,layout=6});st.muted[#st.muted+1]=roleHdr
  local rWrap=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BackgroundTransparency=1,LayoutOrder=7},body)
  mk("UIListLayout",{FillDirection=fdH,Wraps=true,Padding=u1(0,5),SortOrder=soLO,VerticalAlignment=vaC},rWrap)
  local hasRole=false;local rOrd=0
  if st.isDevU then rOrd=rOrd+1;F.roleChip(rWrap,F.DEVROLE,rOrd,false);hasRole=true end
  for _,r in ipairs(st.rlist)do rOrd=rOrd+1;F.roleChip(rWrap,r,rOrd,false);hasRole=true end
  if not hasRole then
    local noR=lab(rWrap,L=="en"and"Member"or"Thành viên",{size=u2(1,0,0,16),ts=10});st.muted[#st.muted+1]=noR
  end

  -- Ghi chú riêng tư (chỉ lưu local trên máy bạn, giống hệt Discord "Note (only visible to you)")
  local noteHdr=lab(body,L=="en"and"NOTE (ONLY VISIBLE TO YOU)"or"GHI CHÚ RIÊNG (CHỈ BẠN THẤY)",{ts=9,bold=true,layout=8});st.muted[#st.muted+1]=noteHdr
  local savedNote=tostring((P.userNotes and P.userNotes[st.uLower])or"")
  local noteInp=mk("TextBox",{
    Size=u2(1,0,0,46),BackgroundColor3=st.cols.inpBg,TextColor3=st.cols.inpTxt,PlaceholderColor3=st.cols.muted,
    Text=savedNote,PlaceholderText=L=="en"and"Click to add a private note..."or"Chạm để ghi chú riêng về người này...",
    ClearTextOnFocus=false,MultiLine=true,TextWrapped=true,Font=fG,TextSize=10,
    TextXAlignment=txL,TextYAlignment=Enum.TextYAlignment.Top,BorderSizePixel=0,LayoutOrder=9
  },body)
  corner(noteInp,7);pad(noteInp,7,5,7,5);mk("UIStroke",{Color=st.cols.iBorder,Thickness=1,Transparency=0.35,ApplyStrokeMode=smBorder},noteInp)
  st.inputs[#st.inputs+1]=noteInp
  hook(noteInp.FocusLost,function()
    P.userNotes=P.userNotes or{}
    local txt=H.clip(H.trim(noteInp.Text),220)
    if txt==""then P.userNotes[st.uLower]=nil else P.userNotes[st.uLower]=txt end
    S.isDirty=true;F.save(true)
  end)
end

function F._PROF.buildBoardTab(st,parent)
  local pt=st.pTheme
  local u=st.ui
  local headerRow=row(parent,24,1)
  local bHdr=lab(headerRow,L=="en"and"Profile Board & Widgets"or"Bảng Hồ Sơ & Tiện Ích",{size=u2(1,-120,1,0),ts=11,bold=true});st.muted[#st.muted+1]=bHdr
  if st.canEdit then
    local addW=tbtn(headerRow,"  "..(L=="en"and"Widgets"or"Tuỳ chỉnh"),{size=uo(106,24),pos=u2(1,-106,0,0),key="btnBg",ts=10,r=6})
    st.chips[#st.chips+1]=addW;F.lucide(addW,"grid",12,{pos=uo(8,6),col=st.cols.txt,themed=false})
    hook(addW.MouseButton1Click,function()if st.fn.openWidgetModal then st.fn.openWidgetModal()end end)
  end

  local wOrderStr=pt.wOrder or"bio,scripts,game,stats"
  local wList={}
  for part in wOrderStr:gmatch("[^,]+")do local p=H.trim(part:lower());if p~=""then wList[#wList+1]=p end end
  if#wList==0 then wList={"bio","scripts","game","stats"}end

  local userScripts={}
  for i=#(S.scripts or{}),1,-1 do
    local sc=S.scripts[i]
    if type(sc)=="table"and sc.id and tostring(sc.author or""):lower()==st.uLower then userScripts[#userScripts+1]=sc end
  end
  if pt.pinSc~=""then
    for i,sc in ipairs(userScripts)do
      if tostring(sc.id)==pt.pinSc and i>1 then tremove(userScripts,i);tinsert(userScripts,1,sc);break end
    end
  end

  local bioText=(st.isSelf and P.bio)or st.rec.bio or""
  local dStr=F.disp((st.isSelf and P.display)or st.rec.display or st.u)
  local gName=(st.isSelf and(S.placeName~="?"and S.placeName or"Roblox"))or st.rec.gameName or""
  local gPlace=(st.isSelf and game.PlaceId)or st.rec.placeId or 0
  local gJob=(st.isSelf and tostring(game.JobId or""))or st.rec.jobId or""
  local inGame=(tonumber(gPlace)and tonumber(gPlace)>0 and gName~="")or(st.isSelf and game.PlaceId>0)

  local wOrd=2
  for _,wKey in ipairs(wList)do
    if wKey=="bio"then
      local spot=F._PROF.makeCard(st,parent,wOrd,12,10);wOrd=wOrd+1
      local topBar=mk("Frame",{Size=u2(1,0,0,18),BackgroundTransparency=1,LayoutOrder=1},spot)
      F.lucide(topBar,"userRound",13,{pos=uo(0,2),col=st.cols.acc,themed=false})
      local tl=lab(topBar,"@"..st.u.." · "..(L=="en"and"About Me"or"Giới thiệu"),{size=u2(1,-20,1,0),pos=uo(18,0),ts=10,bold=true});st.muted[#st.muted+1]=tl
      local hiL=lab(spot,(L=="en"and"Hi, I'm "or"Xin chào, mình là ")..dStr.."!",{ts=15,bold=true,wrap=true,auto=true,layout=2})
      st.texts[#st.texts+1]=hiL;u.spotTitle=hiL
      local emptyBio=st.isSelf and(L=="en"and"No bio yet — switch to the Edit tab to customize your intro."or"Chưa có tiểu sử — chọn tab Sửa hồ sơ để viết giới thiệu.")or(L=="en"and"No bio written."or"Chưa viết tiểu sử.")
      local bl=lab(spot,bioText~=""and F.disp(bioText)or emptyBio,{ts=11,wrap=true,auto=true,layout=3})
      u.spotBio=bl
      if bioText==""then st.muted[#st.muted+1]=bl else st.texts[#st.texts+1]=bl end
    elseif wKey=="scripts"then
      local scCard=F._PROF.makeCard(st,parent,wOrd,12,10);wOrd=wOrd+1
      local sh=mk("Frame",{Size=u2(1,0,0,18),BackgroundTransparency=1,LayoutOrder=1},scCard)
      F.lucide(sh,"code",13,{pos=uo(0,2),col=st.cols.acc,themed=false})
      local shL=lab(sh,L=="en"and("Shared Scripts Showcase ("..#userScripts..")")or("Kho Script Đã Chia Sẻ ("..#userScripts..")"),{size=u2(1,-20,1,0),pos=uo(18,0),ts=10,bold=true})
      st.muted[#st.muted+1]=shL
      if#userScripts==0 then
        local noSc=lab(scCard,L=="en"and"No scripts published on Chat Bridge Script Forum yet."or"Người dùng chưa đăng script nào lên Diễn đàn Script.",{ts=11,wrap=true,auto=true,layout=2})
        st.muted[#st.muted+1]=noSc
      else
        local sGrid=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BackgroundTransparency=1,LayoutOrder=2},scCard)
        mk("UIGridLayout",{CellSize=u2(0.5,-4,0,64),CellPadding=uo(6,6),SortOrder=soLO},sGrid)
        for idx=1,min(4,#userScripts)do
          local sc=userScripts[idx]
          local isPin=(pt.pinSc~=""and tostring(sc.id)==pt.pinSc)
          local tile=mk("TextButton",{Size=u2(1,0,1,0),BackgroundColor3=st.cols.sub,Text="",AutoButtonColor=true,BorderSizePixel=0,LayoutOrder=idx,ClipsDescendants=true},sGrid)
          corner(tile,8);mk("UIStroke",{Color=isPin and st.cols.acc or st.cols.cBorder,Thickness=isPin and 1.4 or 1,Transparency=0.35,ApplyStrokeMode=smBorder},tile)
          st.subCards[#st.subCards+1]=tile
          F.lucide(tile,isPin and"pin"or"scroll",14,{pos=uo(8,9),col=st.cols.acc,themed=false})
          local ttl=lab(tile,F.disp(sc.title or"Script"),{size=u2(1,-58,0,16),pos=uo(26,7),ts=11,bold=true,trunc=true});st.texts[#st.texts+1]=ttl
          local metaS=F.disp((sc.tag or"Universal").." · "..(sc.gameName~=""and sc.gameName or"All Games"))
          local ml=lab(tile,metaS,{size=u2(1,-34,0,13),pos=uo(26,24),ts=9,trunc=true});st.muted[#st.muted+1]=ml
          local subS=H.clip(tostring(sc.desc~=""and sc.desc or sc.code or""),40)
          local sl=lab(tile,F.disp(subS),{size=u2(1,-16,0,14),pos=uo(8,42),ts=9,trunc=true});st.muted[#st.muted+1]=sl
          local cpB=mk("TextButton",{Size=uo(22,22),Position=u2(1,-26,0,5),BackgroundColor3=st.cols.card,Text="",AutoButtonColor=true,BorderSizePixel=0,ZIndex=4},tile)
          corner(cpB,6);F.lucide(cpB,"copy",11,{pos=uo(5,5),col=st.cols.acc,themed=false})
          hook(cpB.MouseButton1Click,function()F.copyText(tostring(sc.code or""))end)
          hook(tile.MouseButton1Click,function()F.openScriptDetail(sc)end)
        end
      end
    elseif wKey=="game"and inGame then
      local gCard=F._PROF.makeCard(st,parent,wOrd,12,10);wOrd=wOrd+1
      local gh=mk("Frame",{Size=u2(1,0,0,18),BackgroundTransparency=1,LayoutOrder=1},gCard)
      F.lucide(gh,"gamepad",13,{pos=uo(0,2),col=TH.ok,themed=false})
      local ghl=lab(gh,L=="en"and"ACTIVE ROBLOX SESSION"or"ĐANG TRONG GAME ROBLOX",{size=u2(1,-20,1,0),pos=uo(18,0),ts=10,bold=true});st.muted[#st.muted+1]=ghl
      local gRow=mk("Frame",{Size=u2(1,0,0,46),BackgroundTransparency=1,LayoutOrder=2},gCard)
      local gIc=mk("ImageLabel",{Size=uo(44,44),Position=uo(0,1),BackgroundColor3=st.cols.sub,BorderSizePixel=0,Image="rbxthumb://type=GameIcon&id="..tostring(gPlace).."&w=150&h=150",ScaleType=Enum.ScaleType.Crop},gRow)
      corner(gIc,8);mk("UIStroke",{Color=st.cols.cBorder,Thickness=1,Transparency=0.4},gIc)
      local gnLbl=lab(gRow,F.disp(gName),{size=u2(1,-164,0,18),pos=uo(52,3),ts=12,bold=true,trunc=true});st.texts[#st.texts+1]=gnLbl
      local gpLbl=lab(gRow,"PlaceId: "..tostring(gPlace)..(gJob~=""and(" · "..gJob:sub(1,8).."...")or""),{size=u2(1,-164,0,14),pos=uo(52,23),ts=9,trunc=true});st.muted[#st.muted+1]=gpLbl
      local isSame=(tonumber(gPlace)==game.PlaceId and gJob==tostring(game.JobId or""))
      local jBtn=tbtn(gRow,isSame and(L=="en"and"Same Server"or"Cùng Server")or(" "..T("join")),{pos=u2(1,-108,0,9),size=uo(108,28),key=isSame and"btnBg"or"ok",ts=10,r=6})
      if isSame then st.chips[#st.chips+1]=jBtn end
      hook(jBtn.MouseButton1Click,function()
        if isSame then F.toast(T("join_srv_self"),true);return end
        if F.armAutoTeleport then F.armAutoTeleport(true)end
        F.toast(T("delta_tp_note"),true)
        pcall(function()
          if gJob~=""then TeleportService:TeleportToPlaceInstance(tonumber(gPlace),gJob,LP)
          else TeleportService:Teleport(tonumber(gPlace),LP)end
        end)
      end)
    elseif wKey=="stats"then
      local sCard=F._PROF.makeCard(st,parent,wOrd,12,10);wOrd=wOrd+1
      local sh=mk("Frame",{Size=u2(1,0,0,18),BackgroundTransparency=1,LayoutOrder=1},sCard)
      F.lucide(sh,"award",13,{pos=uo(0,2),col=st.cols.acc,themed=false})
      local shl=lab(sh,L=="en"and"COMMUNITY HIGHLIGHTS"or"CHỈ SỐ CỘNG ĐỒNG",{size=u2(1,-20,1,0),pos=uo(18,0),ts=10,bold=true});st.muted[#st.muted+1]=shl
      local stGrid=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BackgroundTransparency=1,LayoutOrder=2},sCard)
      mk("UIGridLayout",{CellSize=u2(0.5,-4,0,42),CellPadding=uo(6,6),SortOrder=soLO},stGrid)
      local emCnt=0;for _,e in ipairs(S.sharedEmojis or{})do if tostring(e.by or""):lower()==st.uLower then emCnt=emCnt+1 end end
      local bufCnt=0;for _,m in pairs(S.msgs or{})do if type(m)=="table"and not m.deleted and tostring(m.author or""):lower()==st.uLower then bufCnt=bufCnt+1 end end
      local recMc=tonumber(st.rec and(st.rec.msgCount or st.rec.mc))or 0
      local msgCnt=st.isSelf and max(P.msgCount or 0,recMc,bufCnt)or max(recMc,bufCnt)
      local statItems={
        {ic="code",lbl=L=="en"and"Scripts"or"Scripts đăng",val=tostring(#userScripts)},
        {ic="msgSquare",lbl=L=="en"and"Messages"or"Tin nhắn",val=tostring(msgCnt)},
        {ic="star",lbl=L=="en"and"Emojis Shared"or"Emoji đóng góp",val=tostring(emCnt)},
        {ic="shield",lbl=L=="en"and"Top Role"or"Cấp bậc",val=st.isDevU and"DEV"or(st.top and st.top.name or"Member")},
      }
      for idx,si in ipairs(statItems)do
        local tile=mk("Frame",{Size=u2(1,0,1,0),BackgroundColor3=st.cols.sub,BorderSizePixel=0,LayoutOrder=idx},stGrid)
        corner(tile,7);mk("UIStroke",{Color=st.cols.cBorder,Thickness=1,Transparency=0.45,ApplyStrokeMode=smBorder},tile)
        st.subCards[#st.subCards+1]=tile
        F.lucide(tile,si.ic,14,{pos=uo(8,14),col=st.cols.acc,themed=false})
        local vl=lab(tile,F.disp(si.val),{size=u2(1,-34,0,16),pos=uo(28,4),ts=11,bold=true,trunc=true});st.texts[#st.texts+1]=vl
        local ll=lab(tile,si.lbl,{size=u2(1,-34,0,13),pos=uo(28,22),ts=9,trunc=true});st.muted[#st.muted+1]=ll
      end
    end
  end
end

function F._PROF.buildActivityTab(st,parent)
  local u=st.u
  local gName=(st.isSelf and(S.placeName~="?"and S.placeName or"Roblox Game"))or st.rec.gameName or""
  local gPlace=(st.isSelf and game.PlaceId)or st.rec.placeId or 0
  local gJob=(st.isSelf and tostring(game.JobId or""))or st.rec.jobId or""
  local inGame=(tonumber(gPlace)and tonumber(gPlace)>0 and gName~="")or(st.isSelf and game.PlaceId>0)

  if inGame then
    local gc=F._PROF.makeCard(st,parent,1,12,10)
    local gh=mk("Frame",{Size=u2(1,0,0,18),BackgroundTransparency=1,LayoutOrder=1},gc)
    F.lucide(gh,"gamepad",13,{pos=uo(0,2),col=TH.ok,themed=false})
    local gl=lab(gh,T("playing")..F.disp(gName),{size=u2(1,-20,1,0),pos=uo(18,0),ts=11,bold=true,trunc=true});gl.TextColor3=TH.ok
    local aRow=row(gc,28,2)
    local bCpPlace=rbtn(aRow,"Copy PlaceId",{size=u2(0.5,-3,1,0),key="btnBg",ts=10,r=6});st.chips[#st.chips+1]=bCpPlace
    hook(bCpPlace.MouseButton1Click,function()F.copyText(tostring(gPlace))end)
    local bCpJob=rbtn(aRow,gJob~=""and"Copy JobId"or"No JobId",{size=u2(0.5,-3,1,0),key="btnBg",ts=10,r=6});st.chips[#st.chips+1]=bCpJob
    hook(bCpJob.MouseButton1Click,function()if gJob~=""then F.copyText(gJob)end end)
  end

  if st.banInfo or st.muteInfo or#st.warnList>0 or#st.punishHist>0 then
    local modC=F._PROF.makeCard(st,parent,2,12,10)
    lab(modC,string.upper(T("mod_profile_sec")),{ts=10,bold=true,key="warn",layout=1})
    local mOrd=2
    if st.banInfo then
      local bc=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BorderSizePixel=0,LayoutOrder=mOrd,BackgroundColor3=st.cols.sub},modC)
      corner(bc,6);pad(bc,8,6,8,6);list(bc,3);st.subCards[#st.subCards+1]=bc
      lab(bc,T("active_ban_hdr"),{ts=11,bold=true,key="danger",layout=1})
      local lr=lab(bc,T("reason_lbl")..F.disp(st.banInfo.reason~=""and F.locText(st.banInfo.reason)or T("no_reason")),{ts=10,wrap=true,auto=true,layout=2});st.texts[#st.texts+1]=lr
      if F.canAct(P.username,u)then local ubb=tbtn(bc,T("unban"),{key="ok",h=24,ts=10,layout=3});hook(ubb.MouseButton1Click,function()F.openUnban(u)end)end
      mOrd=mOrd+1
    end
    if st.muteInfo then
      local mc=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BorderSizePixel=0,LayoutOrder=mOrd,BackgroundColor3=st.cols.sub},modC)
      corner(mc,6);pad(mc,8,6,8,6);list(mc,3);st.subCards[#st.subCards+1]=mc
      lab(mc,T("active_mute_hdr"),{ts=11,bold=true,key="danger",layout=1})
      lab(mc,T("duration_lbl")..F.fmtExpire(st.muteInfo.exp).." · @"..F.disp(st.muteInfo.by~=""and st.muteInfo.by or"Staff"),{ts=10,bold=true,key="warn",wrap=true,auto=true,layout=2})
      local lr=lab(mc,T("reason_lbl")..F.disp(st.muteInfo.reason~=""and F.locText(st.muteInfo.reason)or T("no_reason")),{ts=10,wrap=true,auto=true,layout=3});st.texts[#st.texts+1]=lr
      if F.canAct(P.username,u)then local ub=tbtn(mc,T("unmute"),{key="ok",h=24,ts=10,layout=4});hook(ub.MouseButton1Click,function()F.openUnmute(u)end)end
      mOrd=mOrd+1
    end
    if#st.warnList>0 then
      local wc=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BorderSizePixel=0,LayoutOrder=mOrd,BackgroundColor3=st.cols.sub},modC)
      corner(wc,6);pad(wc,8,6,8,6);list(wc,3);st.subCards[#st.subCards+1]=wc
      lab(wc,T("active_warn_hdr").." ("..#st.warnList..")",{ts=11,bold=true,key="warn",layout=1})
      for idx=#st.warnList,max(1,#st.warnList-2),-1 do
        local w=st.warnList[idx]
        local lw=lab(wc,"• #"..idx..": "..F.disp(w.reason~=""and F.locText(w.reason)or T("no_reason")).." (@"..F.disp(w.by~=""and w.by or"Staff")..")",{ts=10,wrap=true,auto=true,layout=2});st.texts[#st.texts+1]=lw
      end
      if F.canAct(P.username,u)then local cwb=tbtn(wc,T("clear_warn"),{key="ok",h=24,ts=10,layout=3});hook(cwb.MouseButton1Click,function()F.openClearWarn(u)end)end
      mOrd=mOrd+1
    end
    if#st.punishHist>0 then
      local hc=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BorderSizePixel=0,LayoutOrder=mOrd,BackgroundColor3=st.cols.sub},modC)
      corner(hc,6);pad(hc,8,6,8,6);list(hc,3);st.subCards[#st.subCards+1]=hc
      local lh=lab(hc,T("mod_history_hdr").." ("..#st.punishHist..")",{ts=10,bold=true,layout=1});st.muted[#st.muted+1]=lh
      for idx=1,min(#st.punishHist,3)do
        local ph=st.punishHist[idx];local actLbl,colKey=F.punishStyle(ph.action)
        lab(hc,actLbl.." · @"..F.disp(ph.by or"?").." · "..F.fmtTimeFull(ph.ts),{ts=10,bold=true,key=colKey,wrap=true,auto=true,layout=idx+1})
      end
    end
  end

  if not st.isSelf or st.isPov then
    local utilC=F._PROF.makeCard(st,parent,3,12,10)
    local isBlocked=P.blockedUsers and P.blockedUsers[st.uLower]==true
    local ar=row(utilC,30,1)
    local blkB=rbtn(ar,isBlocked and(L=="en"and"Unblock Locally"or"Bỏ chặn tin")or(L=="en"and"Block User Locally"or"Chặn tin cục bộ"),{size=u2(0.5,-3,1,0),key=isBlocked and"ok"or"btnBg",ts=10,r=6})
    if not isBlocked then st.chips[#st.chips+1]=blkB end
    hook(blkB.MouseButton1Click,function()
      P.blockedUsers=P.blockedUsers or{}
      if P.blockedUsers[st.uLower]then P.blockedUsers[st.uLower]=nil else P.blockedUsers[st.uLower]=true end
      S.isDirty=true;F.save(true);if F.rebuildFeed then pcall(F.rebuildFeed,true)end
      F.toast(P.blockedUsers[st.uLower]and(L=="en"and"Blocked @"..u or"Đã ẩn tin nhắn @"..u)or(L=="en"and"Unblocked @"..u or"Đã bỏ chặn @"..u),true)
      F.openProfile(u,2)
    end)
    local rpB=rbtn(ar,T("report"),{size=u2(0.5,-3,1,0),key="warn",ts=10,r=6})
    hook(rpB.MouseButton1Click,function()F.openReport(u)end)

    if F.canAct(P.username,u)then
      F._PROF.section(st,parent,T("admin"),4,"shieldAlert")
      local admC=F._PROF.makeCard(st,parent,5,10,8)
      local r2=row(admC,28,1)
      local m1=rbtn(r2,T("mute"),{key="danger",ts=10});hook(m1.MouseButton1Click,function()F.openMute(u)end)
      local m2=rbtn(r2,T("warn"),{key="warn",ts=10});hook(m2.MouseButton1Click,function()F.openWarn(u)end)
      local r3=row(admC,28,2)
      local u1=rbtn(r3,T("unmute"),{key="ok",ts=10});hook(u1.MouseButton1Click,function()F.openUnmute(u)end)
      local u2=rbtn(r3,T("clear_warn"),{key="ok",ts=10});hook(u2.MouseButton1Click,function()F.openClearWarn(u)end)
      local r4=row(admC,28,3)
      local b1=rbtn(r4,T("ban"),{key="danger",ts=10});hook(b1.MouseButton1Click,function()F.openBan(u)end)
      local b2=rbtn(r4,T("unban"),{key="ok",ts=10});hook(b2.MouseButton1Click,function()F.openUnban(u)end)
    end
    if F.isDev(P.username)then
      local devC=F._PROF.makeCard(st,parent,6,10,8)
      local r5=row(devC,28,1)
      local rl=rbtn(r5,T("roles"),{key="accent",ts=10});hook(rl.MouseButton1Click,function()F.openUserRoles(u)end)
      if#st.rlist>0 then
        local rv=rbtn(r5,T("revoke"),{key="danger",ts=10})
        hook(rv.MouseButton1Click,function()
          enqueue("other","POST","/api/revoke",{by=P.username,u=u},function(d2,e2)
            if d2 and d2.ok then
              if d2.roles then F.applyRoles(d2.roles,d2.seq,true)end
              local ak=F.assignKeyFor(u);if ak then S.assign[ak]=nil end;F.invalidateRoleCache();S.isDirty=true
              F.toast(T("revoked"),true);F.closeModal()
            else F.netError(d2 and d2.error or e2)end
          end)
        end)
      end
    end
  else
    local selfC=F._PROF.makeCard(st,parent,3,10,8)
    local sr=row(selfC,28,1)
    local rqB=rbtn(sr,T("request_title"),{key="btnBg",ts=10});st.chips[#st.chips+1]=rqB
    hook(rqB.MouseButton1Click,function()F.openRequest()end)
    local hdRefB=rbtn(sr,L=="en"and"Refresh HD Assets"or"Làm nét lại ảnh",{key="btnBg",ts=10});st.chips[#st.chips+1]=hdRefB
    hook(hdRefB.MouseButton1Click,function()
      if st.bannerId~=""then S.assetUrl[st.bannerId]=nil;S.textureMap[st.bannerId]=nil;F.setAsset(st.ui.bImg,st.bannerId,nil,0,{force=true})end
      if st.iconId~=""then S.assetUrl[st.iconId]=nil;S.textureMap[st.iconId]=nil;F.setAsset(st.ui.avImg,st.iconId,nil,0,{force=true})end
      F.toast(L=="en"and"Re-fetching full-res textures..."or"Đang tải lại ảnh độ phân giải gốc...",true)
    end)
  end
end

function F._PROF.buildEditTab(st,parent)
  local pt=st.pTheme
  local u=st.ui
  local infoCard=F._PROF.makeCard(st,parent,1,12,10)
  local function profField(labelTxt,defaultVal,isMulti,ord)
    local f=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BackgroundTransparency=1,LayoutOrder=ord},infoCard)
    list(f,3)
    local l=lab(f,labelTxt,{ts=11,bold=true,layout=1});st.muted[#st.muted+1]=l
    local tb=mk("TextBox",{
      Size=u2(1,0,0,isMulti and 54 or 28),BackgroundColor3=st.cols.inpBg,TextColor3=st.cols.inpTxt,PlaceholderColor3=st.cols.muted,
      Text=defaultVal or"",ClearTextOnFocus=false,Font=fG,TextSize=12,TextXAlignment=txL,
      TextYAlignment=isMulti and Enum.TextYAlignment.Top or Enum.TextYAlignment.Center,TextWrapped=isMulti,MultiLine=isMulti,BorderSizePixel=0,LayoutOrder=2
    },f)
    corner(tb,7);mk("UIStroke",{Color=st.cols.iBorder,Thickness=1,Transparency=0.35,ApplyStrokeMode=smBorder},tb);pad(tb,8,4,8,4)
    st.inputs[#st.inputs+1]=tb
    return tb
  end
  local tName=profField(T("name"),P.display,false,1)
  local tStatus=profField(T("status"),P.status,false,2);tStatus.PlaceholderText=T("status_ph")
  local stRow=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BackgroundTransparency=1,LayoutOrder=3},infoCard)
  mk("UIListLayout",{FillDirection=fdH,Wraps=true,Padding=u1(0,4),SortOrder=soLO},stRow)
  for idx,preset in ipairs({"Gaming","Coding","Scripting","AFK","Busy","X"})do
    local sb=tbtn(stRow,preset,{size=uo(preset=="X"and 28 or 66,22),ts=10,key="btnBg",r=6,layout=idx})
    st.chips[#st.chips+1]=sb;hook(sb.MouseButton1Click,function()tStatus.Text=(preset=="X"and""or preset)end)
  end
  local tBio=profField(T("bio"),P.bio,true,4);tBio.PlaceholderText=T("bio_ph")
  local tTag=profField(L=="en"and"Profile Flair / Tag Badge (max 36 chars)"or"Nhãn cá nhân / Flair Badge (tối đa 36 ký tự)",pt.tag,false,5)
  tTag.PlaceholderText=L=="en"and"e.g. Script Dev, Trade King, Chill..."or"vd: Script Dev, Collector, Chill..."
  local tCountry=profField(L=="en"and"Country (ISO Code or Full Name)"or"Quốc gia (Mã 2 chữ hoặc Tên đầy đủ)",P.country,false,6)
  local ccPv=lab(infoCard,"",{ts=10,key="ok",h=16,layout=7})
  local function updCc()
    local res=H.resolveCountry(tCountry.Text)
    ccPv.Text="-> "..H.flag(res).." "..H.countryName(res).." ("..res..")"
    if st.fn.refreshFlag then st.fn.refreshFlag(res)end
  end
  hook(tCountry:GetPropertyChangedSignal("Text"),updCc);updCc()
  local ccRow=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BackgroundTransparency=1,LayoutOrder=8},infoCard)
  mk("UIListLayout",{FillDirection=fdH,Wraps=true,Padding=u1(0,4),SortOrder=soLO},ccRow)
  for idx,ccode in ipairs({"VN","US","IL","UA","JP","KR","GB","SG","??"})do
    local cb=tbtn(ccRow,ccode=="??"and"Global ??"or(H.flag(ccode).." "..ccode),{size=uo(54,22),ts=10,key="btnBg",r=6,layout=idx})
    st.chips[#st.chips+1]=cb;hook(cb.MouseButton1Click,function()tCountry.Text=ccode end)
  end

  -- Ghim Script nổi bật lên Profile Board
  F._PROF.section(st,parent,L=="en"and"PIN SCRIPT TO PROFILE BOARD"or"GHIM SCRIPT NỔI BẬT LÊN BOARD",2,"pin")
  local pinCard=F._PROF.makeCard(st,parent,3,12,10)
  local myScripts={}
  for i=#(S.scripts or{}),1,-1 do local sc=S.scripts[i];if type(sc)=="table"and sc.id and tostring(sc.author or""):lower()==st.uLower then myScripts[#myScripts+1]=sc end end
  if#myScripts==0 then
    local noS=lab(pinCard,L=="en"and"Post a script in the Scripts tab first to feature it on your Profile."or"Hãy đăng script trong tab Script trước để ghim lên Profile của bạn.",{ts=10,wrap=true,auto=true});st.muted[#st.muted+1]=noS
  else
    local pinWrap=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BackgroundTransparency=1,LayoutOrder=1},pinCard)
    mk("UIListLayout",{FillDirection=fdH,Wraps=true,Padding=u1(0,5),SortOrder=soLO},pinWrap)
    local pBtns={}
    local function paintPinBtns()
      for sid,b in pairs(pBtns)do local on=(pt.pinSc==sid);b.BackgroundColor3=on and st.cols.acc or st.cols.sub;b.TextColor3=on and H.ensureContrast(rgb(255,255,255),st.cols.acc,4.5)or st.cols.txt end
    end
    local noneB=tbtn(pinWrap,L=="en"and"Auto Latest"or"Tự động mới nhất",{size=uo(106,24),ts=10,r=6,layout=0});pBtns[""]=noneB
    hook(noneB.MouseButton1Click,function()pt.pinSc="";paintPinBtns()end)
    for idx=1,min(8,#myScripts)do
      local sc=myScripts[idx];local sid=tostring(sc.id)
      local b=tbtn(pinWrap,H.clip(sc.title or sid,18),{size=uo(clamp(H.textW(H.clip(sc.title or sid,18),10,fGB)+16,64,160),24),ts=10,r=6,layout=idx})
      pBtns[sid]=b;hook(b.MouseButton1Click,function()pt.pinSc=sid;paintPinBtns()end)
    end
    paintPinBtns()
  end

  hook(tName:GetPropertyChangedSignal("Text"),function()
    local s=H.trim(tName.Text);local ds=F.disp(s~=""and s or LP.DisplayName)
    if u.dnameLbl then u.dnameLbl.Text=ds end
    if u.spotTitle then u.spotTitle.Text=(L=="en"and"Hi, I'm "or"Xin chào, mình là ")..ds.."!"end
  end)
  hook(tStatus:GetPropertyChangedSignal("Text"),function()
    local s=H.trim(tStatus.Text)
    if u.stBubble then u.stBubble.Visible=(s~=""or st.canEdit)end
    if u.dotDot1 then u.dotDot1.Visible=(s~=""or st.canEdit)end
    if u.dotDot2 then u.dotDot2.Visible=(s~=""or st.canEdit)end
    if u.stBubbleLbl then u.stBubbleLbl.Text=s~=""and F.disp(s)or(L=="en"and"+ Set status..."or"+ Đặt trạng thái...");u.stBubbleLbl.TextColor3=s~=""and st.cols.txt or st.cols.muted end
  end)
  hook(tBio:GetPropertyChangedSignal("Text"),function()
    local s=H.trim(tBio.Text)
    if u.spotBio then u.spotBio.Text=s~=""and F.disp(s)or(L=="en"and"No bio yet."or"Chưa có tiểu sử.");u.spotBio.TextColor3=s~=""and st.cols.txt or st.cols.muted end
  end)
  hook(tTag:GetPropertyChangedSignal("Text"),function()if st.fn.refreshFlair then st.fn.refreshFlair(tTag.Text)end end)
  st.fields.tName=tName;st.fields.tStatus=tStatus;st.fields.tBio=tBio;st.fields.tCountry=tCountry;st.fields.tTag=tTag
end

function F._PROF.buildImagesTab(st,parent)
  local pt=st.pTheme
  local u=st.ui
  local noteC=F._PROF.makeCard(st,parent,0,10,8)
  local nRow=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BackgroundTransparency=1},noteC)
  F.lucide(nRow,"sparkles",15,{pos=uo(0,2),col=st.cols.acc,themed=false})
  local nl=lab(nRow,L=="en"
    and"Roblox Store decals are automatically resolved to native HD textures. Tap 'Crop / Frame' to drag, zoom (100-300%), change Fit mode (Crop/Fit/Stretch/Tile), or adjust aspect ratio!"
    or"Ảnh Decal từ Roblox Store được tự động tải ở độ phân giải gốc. Bấm 'Căn khung' để kéo ảnh, phóng to/nhỏ, đổi chế độ Fit (không cắt ảnh) hoặc chỉnh tỉ lệ!",
    {size=u2(1,-22,0,0),pos=uo(22,0),ts=10,wrap=true,auto=true});st.muted[#st.muted+1]=nl

  local function buildSlot(titleTxt,cat,targetKey,initVal,ord,getCfg,setCfg,onImgText)
    local itemC=F._PROF.makeCard(st,parent,ord,10,8)
    local topR=mk("Frame",{Size=u2(1,0,0,40),BackgroundTransparency=1,LayoutOrder=1},itemC)
    local tw=mk("Frame",{Size=uo(40,40),Position=uo(0,0),BackgroundColor3=st.cols.sub,BorderSizePixel=0,ClipsDescendants=true},topR)
    corner(tw,8);st.subCards[#st.subCards+1]=tw
    local ti=mk("ImageLabel",{Size=us(1,1),BackgroundTransparency=1,ScaleType=Enum.ScaleType.Crop,BorderSizePixel=0},tw)
    local emp=lab(tw,"", {size=us(1,1),ts=12,align=txC});F.lucide(emp,"image",16,{pos=uo(12,12),col=st.cols.muted,themed=false})
    local tl=lab(topR,titleTxt,{size=u2(1,-212,0,18),pos=uo(48,2),ts=11,bold=true,trunc=true});st.texts[#st.texts+1]=tl
    local infoL=lab(topR,"",{size=u2(1,-212,0,14),pos=uo(48,22),ts=9,trunc=true});st.muted[#st.muted+1]=infoL

    local storeB=tbtn(topR," Store",{size=uo(72,28),pos=u2(1,-172,0,6),key="accent",ts=10,r=6})
    st.accents[#st.accents+1]=storeB;F.lucide(storeB,"store",12,{pos=uo(7,8),col=H.lum(st.cols.acc)>0.55 and rgb(20,20,24)or c3(1,1,1),themed=false})
    local cropB=tbtn(topR," "..(L=="en"and"Crop"or"Căn"),{size=uo(64,28),pos=u2(1,-96,0,6),key="btnBg",ts=10,r=6})
    st.chips[#st.chips+1]=cropB;F.lucide(cropB,"crop",12,{pos=uo(7,8),col=st.cols.txt,themed=false})
    local clrB=tbtn(topR,"X",{size=uo(28,28),pos=u2(1,-28,0,6),key="danger",ts=11,r=6})

    local boxInp=mk("TextBox",{
      Size=u2(1,0,0,26),BackgroundColor3=st.cols.inpBg,TextColor3=st.cols.inpTxt,PlaceholderColor3=st.cols.muted,
      Text=tostring(initVal or""),PlaceholderText=L=="en"and"Roblox Asset ID or Store URL..."or"Nhập Roblox Asset ID hoặc link Store...",
      ClearTextOnFocus=false,Font=fCode,TextSize=11,BorderSizePixel=0,TextXAlignment=txL,LayoutOrder=2
    },itemC)
    corner(boxInp,6);pad(boxInp,8,2,8,2);mk("UIStroke",{Color=st.cols.iBorder,Thickness=1,Transparency=0.35,ApplyStrokeMode=smBorder},boxInp)
    st.inputs[#st.inputs+1]=boxInp

    local function syncInfoLabel()
      local c=getCfg()
      infoL.Text=string.format("%s · %d%% · (%d,%d)",tostring(c.fit or"crop"):upper(),tonumber(c.zoom)or 100,tonumber(c.x)or 0,tonumber(c.y)or 0)
    end
    local function updThumb()
      local aid=H.assetId(boxInp.Text)
      syncInfoLabel()
      if aid and aid~=""then
        emp.Visible=false;ti.Visible=true;F.setAsset(ti,aid)
        F.applyImageFrame(tw,ti,getCfg(),40,40)
      else ti.Image="";ti.Visible=false;emp.Visible=true end
      if onImgText then onImgText(aid or"")end
    end
    local function openStudioWithId(idOverride)
      local aid=idOverride or H.assetId(boxInp.Text)or""
      F.openImageCropStudio({
        target=targetKey,assetId=aid,cfg=getCfg(),
        onApply=function(res)
          if res.id~=""then boxInp.Text=res.id end
          setCfg(res);updThumb();F._PROF.applyImages(st)
        end,
      })
    end
    hook(boxInp:GetPropertyChangedSignal("Text"),updThumb)
    hook(clrB.MouseButton1Click,function()boxInp.Text="";updThumb()end)
    hook(cropB.MouseButton1Click,function()openStudioWithId()end)
    hook(storeB.MouseButton1Click,function()
      F.openImageFinder(titleTxt,cat,function(pickedId)boxInp.Text=tostring(pickedId);updThumb()end,{
        onStudio=function(pickedId)openStudioWithId(pickedId)end,
      })
    end)
    updThumb()
    return boxInp,updThumb
  end

  local tBanner=buildSlot(L=="en"and"1. Profile Banner"or"1. Ảnh Bìa (Banner)","banner","banner",P.profBanner,1,
    function()return{fit=pt.bf,zoom=pt.bz,x=pt.bx,y=pt.by,aspect=pt.ba,height=pt.bh}end,
    function(res)pt.bf=res.fit;pt.bz=res.zoom;pt.bx=res.x;pt.by=res.y;pt.ba=res.aspect;pt.bh=res.height end,
    function(aid)
      st.bannerId=aid
      if u.bImg then u.bImg.Visible=(aid~="");if aid~=""then F.setAsset(u.bImg,aid)else u.bImg.Image=""end end
      F._PROF.applyImages(st)
    end)

  local tIcon=buildSlot(L=="en"and"2. Profile Avatar Icon"or"2. Ảnh Đại Diện (Avatar)","icon","icon",P.profIcon,2,
    function()return{fit=pt["if"],zoom=pt.iz,x=pt.ix,y=pt.iy,aspect=pt.ia,radius=pt.ir}end,
    function(res)pt["if"]=res.fit;pt.iz=res.zoom;pt.ix=res.x;pt.iy=res.y;pt.ia=res.aspect;pt.ir=res.radius end,
    function(aid)
      st.iconId=aid
      if u.avImg then if aid~=""then F.setAsset(u.avImg,aid)else u.avImg.Image=F.avatarUrl(F.uidOf(st.u))end end
      F._PROF.applyImages(st)
    end)

  local tBgImg,updBgImg=buildSlot(L=="en"and"3. Card Wallpaper"or"3. Ảnh Nền Thẻ Profile","theme","wallpaper",pt.bgImg or"",3,
    function()return{fit=pt.wf,zoom=pt.wz,x=pt.wx,y=pt.wy,aspect=pt.wa}end,
    function(res)pt.wf=res.fit;pt.wz=res.zoom;pt.wx=res.x;pt.wy=res.y;pt.wa=res.aspect end,
    function(aid)
      pt.bgImg=aid
      if aid~=""and pt.mode=="solid"then pt.mode="image"end
      if st.fn.refreshThemeBadges then st.fn.refreshThemeBadges()end
      F._PROF.applyColors(st)
    end)

  st.fields.tBanner=tBanner;st.fields.tIcon=tIcon;st.fields.tBgImg=tBgImg;st.fields.updBgImg=updBgImg
end

function F._PROF.buildStyleTab(st,parent)
  local pt=st.pTheme
  local cols=st.cols
  local refresh=function()F._PROF.applyColors(st,st.fields.tBg and st.fields.tBg.Text or pt.bg,st.fields.tAcc and st.fields.tAcc.Text or pt.acc,st.fields.tTxt and st.fields.tTxt.Text or pt.txt)end

  -- 1. Discord Avatar Decoration & Nameplate Effects
  F._PROF.section(st,parent,L=="en"and"AVATAR DECORATION & NAME EFFECT"or"KHUNG AVATAR & HIỆU ỨNG TÊN",1,"sparkles")
  local cosC=F._PROF.makeCard(st,parent,2,10,8)
  local decLbl=lab(cosC,L=="en"and"Avatar Decoration Ring"or"Viền trang trí Avatar",{ts=10,bold=true,layout=1});st.muted[#st.muted+1]=decLbl
  local decGrid=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BackgroundTransparency=1,LayoutOrder=2},cosC)
  mk("UIGridLayout",{CellSize=u2(0.25,-4,0,26),CellPadding=uo(4,4),SortOrder=soLO},decGrid)
  for idx,d in ipairs(F._AV_DECS)do
    local b=mk("TextButton",{Size=us(1,1),BackgroundColor3=cols.sub,Text=d.name,Font=fGB,TextSize=10,TextColor3=cols.txt,BorderSizePixel=0,AutoButtonColor=true,LayoutOrder=idx},decGrid)
    corner(b,6);local bSt=mk("UIStroke",{Color=cols.cBorder,Thickness=1.1,Transparency=0.3,ApplyStrokeMode=smBorder},b)
    st.decBtns[d.id]={btn=b,st=bSt}
    hook(b.MouseButton1Click,function()pt.avDec=d.id;refresh()end)
  end
  local neLbl=lab(cosC,L=="en"and"Display Name Effect"or"Hiệu ứng Tên hiển thị",{ts=10,bold=true,layout=3});st.muted[#st.muted+1]=neLbl
  local neRow=row(cosC,26,4)
  for idx,ne in ipairs(F._NAME_EFFS)do
    local b=mk("TextButton",{Size=u2(1/#F._NAME_EFFS,-3,1,0),BackgroundColor3=cols.sub,Text=ne.name,Font=fGB,TextSize=10,TextColor3=cols.txt,BorderSizePixel=0,AutoButtonColor=true,LayoutOrder=idx},neRow)
    corner(b,6);local bSt=mk("UIStroke",{Color=cols.cBorder,Thickness=1.1,Transparency=0.3,ApplyStrokeMode=smBorder},b)
    st.neffBtns[ne.id]={btn=b,st=bSt}
    hook(b.MouseButton1Click,function()pt.nEff=ne.id;refresh()end)
  end

  -- 2. Chroma & Background Modes
  F._PROF.section(st,parent,L=="en"and"CHROMA & BACKGROUND MODE"or"CHẾ ĐỘ NỀN & CHUYỂN SẮC CHROMA",3,"layers")
  local chC=F._PROF.makeCard(st,parent,4,10,8)
  local mR1,mR2=row(chC,26,1),row(chC,26,2)
  local function mkModeB(pr,ws,mkKey,lblK,ord)
    local b=mk("TextButton",{Size=u2(ws,-4,1,0),BackgroundColor3=cols.sub,Text=T(lblK),Font=fGB,TextSize=10,TextColor3=cols.txt,BorderSizePixel=0,AutoButtonColor=true,LayoutOrder=ord},pr)
    corner(b,6);local bst=mk("UIStroke",{Color=cols.cBorder,Thickness=1.2,Transparency=0.25,ApplyStrokeMode=smBorder},b)
    st.modeBtns[mkKey]={btn=b,st=bst};st.chips[#st.chips+1]=b
    hook(b.MouseButton1Click,function()pt.mode=mkKey;if st.fn.refreshThemeBadges then st.fn.refreshThemeBadges()end;refresh()end)
  end
  mkModeB(mR1,1/3,"solid","bg_solid",1);mkModeB(mR1,1/3,"gradient","bg_gradient",2);mkModeB(mR1,1/3,"mesh","bg_mesh",3)
  mkModeB(mR2,0.5,"glass","bg_glass",1);mkModeB(mR2,0.5,"image","bg_image",2)

  local gRow=row(chC,28,3)
  local gWrap=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BackgroundTransparency=1,Visible=false,LayoutOrder=4},chC)
  local actGK,gPicker
  for idx,gk in ipairs({"g1","g2","g3"})do
    local gb=mk("TextButton",{Size=u2(1/3,-4,1,0),BackgroundColor3=cols.sub,Text="",BorderSizePixel=0,LayoutOrder=idx,AutoButtonColor=true},gRow)
    corner(gb,6);local gst=mk("UIStroke",{Color=cols.cBorder,Thickness=1,Transparency=0.35,ApplyStrokeMode=smBorder},gb)
    local sw=mk("Frame",{Size=uo(14,14),Position=uo(6,7),BorderSizePixel=0},gb);corner(sw,4)
    local sTitle="Stop #"..idx;local gl=lab(gb,sTitle,{size=u2(1,-24,1,0),pos=uo(23,0),ts=9,bold=true,trunc=true});st.texts[#st.texts+1]=gl
    st.gStopBtns[gk]={btn=gb,sw=sw,lbl=gl,st=gst,title=sTitle}
    hook(gb.MouseButton1Click,function()
      if gWrap.Visible and actGK==gk then gWrap.Visible=false;actGK=nil;return end
      actGK=gk;local curC=(gk=="g1"and cols.g1)or(gk=="g2"and cols.g2)or cols.g3
      local sh=H.safeHex(pt[gk],H.tohex(curC))
      if not gPicker then gPicker=F.colorPicker(gWrap,sh,function(hex)if actGK then pt[actGK]=hex;if pt.mode=="solid"then pt.mode="gradient"end;refresh()end end)
      else gPicker.set(sh)end
      gWrap.Visible=true
    end)
  end
  local slRot,setSlRot=F.slider(chC,T("grad_angle"),0,360,pt.gRot,{step=5,fmt=function(v)return v.."°"end,onChange=function(v)pt.gRot=v;refresh()end});slRot.LayoutOrder=5;st.subCards[#st.subCards+1]=slRot
  local slMix,setSlMix=F.slider(chC,T("grad_mix"),15,100,pt.gMix,{step=1,fmt=function(v)return v.."%"end,onChange=function(v)pt.gMix=v;refresh()end});slMix.LayoutOrder=6;st.subCards[#st.subCards+1]=slMix
  local slOp=F.slider(chC,T("bg_opacity"),15,100,pt.bgOp,{step=1,fmt=function(v)return v.."%"end,onChange=function(v)pt.bgOp=v;refresh()end});slOp.LayoutOrder=7;st.subCards[#st.subCards+1]=slOp
  local slDim=F.slider(chC,T("bg_dim"),0,75,pt.bgDim,{step=1,fmt=function(v)return v.."%"end,onChange=function(v)pt.bgDim=v;refresh()end});slDim.LayoutOrder=8;st.subCards[#st.subCards+1]=slDim

  -- 3. Interface Font & Surface Geometry
  F._PROF.section(st,parent,L=="en"and"FONT & SURFACE GEOMETRY"or"PHÔNG CHỮ & BO GÓC",5,"sliders")
  local sfC=F._PROF.makeCard(st,parent,6,10,8)
  local fGrid=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BackgroundTransparency=1,LayoutOrder=1},sfC)
  mk("UIGridLayout",{CellSize=u2(0.25,-4,0,26),CellPadding=uo(4,4),SortOrder=soLO},fGrid)
  for idx,fk in ipairs(FONT_ORDER)do
    local fm=FONT_MAP[fk]
    local fb=mk("TextButton",{Size=us(1,1),BackgroundColor3=cols.sub,Text=fm.name,Font=fm.bold,TextSize=10,TextColor3=cols.txt,BorderSizePixel=0,AutoButtonColor=true,LayoutOrder=idx},fGrid)
    corner(fb,6);local fst=mk("UIStroke",{Color=cols.cBorder,Thickness=1.1,Transparency=0.3,ApplyStrokeMode=smBorder},fb)
    st.fontBtns[fk]={btn=fb,st=fst};hook(fb.MouseButton1Click,function()pt.font=fk;refresh()end)
  end
  local slRad,setSlRad=F.slider(sfC,T("ui_radius"),3,16,pt.rad,{step=1,fmt=function(v)return v.."px"end,onChange=function(v)pt.rad=v;refresh()end});slRad.LayoutOrder=2;st.subCards[#st.subCards+1]=slRad
  local gSw=F.switch(sfC,T("border_glow"),function()return pt.glow~=false end,function(v)pt.glow=v;refresh()end);gSw.LayoutOrder=3

  -- 4. Colors & Harmonizer + Sync + Export/Import CBT1
  F._PROF.section(st,parent,L=="en"and"COLORS & THEME TRANSFER"or"MÀU SẮC & CHIA SẺ MÃ THEME",7,"palette")
  local colC=F._PROF.makeCard(st,parent,8,10,8)
  local thR=row(colC,26,1)
  local tBg=mk("TextBox",{Size=u2(1/3,-4,1,0),Text=tostring(pt.bg or""),PlaceholderText="Bg #1A1B26",ClearTextOnFocus=false,Font=fCode,TextSize=10,BorderSizePixel=0,TextXAlignment=txL},thR)
  local tAcc=mk("TextBox",{Size=u2(1/3,-4,1,0),Text=tostring(pt.acc or""),PlaceholderText="Acc #5865F2",ClearTextOnFocus=false,Font=fCode,TextSize=10,BorderSizePixel=0,TextXAlignment=txL},thR)
  local tTxt=mk("TextBox",{Size=u2(1/3,-4,1,0),Text=tostring(pt.txt or""),PlaceholderText="Txt #F4F4F6",ClearTextOnFocus=false,Font=fCode,TextSize=10,BorderSizePixel=0,TextXAlignment=txL},thR)
  for _,tb in ipairs({tBg,tAcc,tTxt})do corner(tb,6);pad(tb,6,2,6,2);mk("UIStroke",{Color=cols.iBorder,Thickness=1,Transparency=0.35,ApplyStrokeMode=smBorder},tb);st.inputs[#st.inputs+1]=tb end
  st.fields.tBg=tBg;st.fields.tAcc=tAcc;st.fields.tTxt=tTxt

  local pkR=row(colC,26,2)
  local bPkBg=mk("TextButton",{Size=u2(1/3,-4,1,0),BackgroundColor3=cols.card,Text="Bg Color",Font=fGB,TextSize=10,BorderSizePixel=0,LayoutOrder=1},pkR);corner(bPkBg,6)
  local bPkAcc=mk("TextButton",{Size=u2(1/3,-4,1,0),BackgroundColor3=cols.acc,Text="Accent",Font=fGB,TextSize=10,BorderSizePixel=0,LayoutOrder=2},pkR);corner(bPkAcc,6)
  local bPkTxt=mk("TextButton",{Size=u2(1/3,-4,1,0),BackgroundColor3=cols.txt,Text="Text",Font=fGB,TextSize=10,BorderSizePixel=0,LayoutOrder=3},pkR);corner(bPkTxt,6)
  st.fn.refreshColorPickBtns=function(vBg,vAcc,vTxt)
    local c1=(vBg and pt.bg~=""and H.hex(vBg))or cols.card;bPkBg.BackgroundColor3=c1;bPkBg.TextColor3=H.ensureContrast(rgb(255,255,255),c1,4.5)
    local c2=(vAcc and pt.acc~=""and H.hex(vAcc))or cols.acc;bPkAcc.BackgroundColor3=c2;bPkAcc.TextColor3=H.ensureContrast(rgb(255,255,255),c2,4.5)
    local c3=(vTxt and pt.txt~=""and H.hex(vTxt))or cols.txt;bPkTxt.BackgroundColor3=c3;bPkTxt.TextColor3=H.ensureContrast(rgb(255,255,255),c3,4.5)
  end
  local pkWrap=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BackgroundTransparency=1,Visible=false,LayoutOrder=3},colC)
  local actBox,pkObj
  local function togglePk(tb,defH)
    if pkWrap.Visible and actBox==tb then pkWrap.Visible=false;actBox=nil;return end
    actBox=tb;local sc=H.safeHex(tb.Text,defH)
    if not pkObj then pkObj=F.colorPicker(pkWrap,sc,function(hex)if actBox then actBox.Text=hex;refresh()end end)else pkObj.set(sc)end
    pkWrap.Visible=true
  end
  hook(bPkBg.MouseButton1Click,function()togglePk(tBg,H.tohex(TH.cardBg))end)
  hook(bPkAcc.MouseButton1Click,function()togglePk(tAcc,H.tohex(TH.accent))end)
  hook(bPkTxt.MouseButton1Click,function()togglePk(tTxt,H.tohex(TH.text))end)
  hook(tBg:GetPropertyChangedSignal("Text"),refresh);hook(tAcc:GetPropertyChangedSignal("Text"),refresh);hook(tTxt:GetPropertyChangedSignal("Text"),refresh)

  local tr1=row(colC,26,4)
  local bHarm=rbtn(tr1,T("harmonize_btn"),{size=u2(0.5,-3,1,0),key="ok",ts=10,r=6})
  local bAutoC=rbtn(tr1,T("auto_contrast"),{size=u2(0.5,-3,1,0),key="btnBg",ts=10,r=6});st.chips[#st.chips+1]=bAutoC
  hook(bHarm.MouseButton1Click,function()
    local hb=math.random();local ha=(hb+0.08+math.random()*0.22)%1;local hs=(ha+0.33)%1
    tBg.Text=H.tohex(Color3.fromHSV(hb,0.36,0.14));tAcc.Text=H.tohex(Color3.fromHSV(ha,0.80,0.96));tTxt.Text=H.tohex(Color3.fromHSV(hb,0.06,0.96))
    pt.g1=H.tohex(Color3.fromHSV(hb,0.40,0.11));pt.g2=H.tohex(Color3.fromHSV(ha,0.52,0.23));pt.g3=H.tohex(Color3.fromHSV(hs,0.48,0.21))
    if pt.mode=="solid"then pt.mode="gradient"end;refresh()
  end)
  hook(bAutoC.MouseButton1Click,function()
    local bgC=H.safeHex(tBg.Text,nil)and H.hex(tBg.Text)or cols.card
    tTxt.Text=H.lum(bgC)<0.45 and"#F4F5F8"or"#14161E";refresh();F.toast(T("contrast_done"),true)
  end)

  local tr2=row(colC,26,5)
  local bFromApp=rbtn(tr2,L=="en"and"From App Theme"or"Lấy từ App",{size=u2(0.5,-3,1,0),key="btnBg",ts=10,r=6});st.chips[#st.chips+1]=bFromApp
  local bToApp=rbtn(tr2,L=="en"and"Apply to App"or"Đặt làm App",{size=u2(0.5,-3,1,0),key="btnBg",ts=10,r=6});st.chips[#st.chips+1]=bToApp
  hook(bFromApp.MouseButton1Click,function()
    F.computeTheme();tBg.Text=H.tohex(TH.bg2);tAcc.Text=H.tohex(TH.accent);tTxt.Text=H.tohex(TH.text)
    pt.g1=H.tohex(TH.g1);pt.g2=H.tohex(TH.g2);pt.g3=H.tohex(TH.g3);pt.mode=P.backgroundMode or"gradient";pt.font=P.fontFamily or"gotham"
    pt.gRot=tonumber(P.gradAngle)or 28;pt.gMix=floor((tonumber(P.gradMix)or 0.65)*100+0.5);pt.rad=tonumber(P.uiRadius)or 10;pt.glow=(P.borderGlow~=false)
    if(P.backgroundImage or"")~=""then pt.bgImg=H.assetId(P.backgroundImage)or""end
    pt.bgOp=clamp(floor((tonumber(P.backgroundOpacity)or 0.82)*100+0.5),15,100)
    pt.bgDim=clamp(floor((tonumber(P.backgroundDim)or 0.25)*100+0.5),0,75)
    do local bf=type(P.bgFrame)=="table"and P.bgFrame or{}
      pt.wf=(bf.fit=="fit"or bf.fit=="stretch"or bf.fit=="tile")and bf.fit or"crop"
      pt.wz=clamp(tonumber(bf.zoom)or 100,100,300);pt.wx=clamp(tonumber(bf.x)or 0,-100,100);pt.wy=clamp(tonumber(bf.y)or 0,-100,100)
      pt.wa=(F._ASPECT and F._ASPECT[bf.aspect or""])and bf.aspect or"auto"
    end
    setSlRot(pt.gRot,false);setSlMix(pt.gMix,false);setSlRad(pt.rad,false);refresh();if st.fn.applyImages then st.fn.applyImages(false)end;F.toast(T("theme_ok"),true)
  end)
  hook(bToApp.MouseButton1Click,function()
    if H.safeHex(tBg.Text,nil)then P.custom.bg2=H.safeHex(tBg.Text,nil);P.custom.bg=H.safeHex(tBg.Text,nil)end
    if H.safeHex(tAcc.Text,nil)then P.custom.accent=H.safeHex(tAcc.Text,nil)end
    if H.safeHex(tTxt.Text,nil)then P.custom.text=H.safeHex(tTxt.Text,nil)end
    if H.safeHex(pt.g1,nil)then P.custom.g1=pt.g1 end;if H.safeHex(pt.g2,nil)then P.custom.g2=pt.g2 end;if H.safeHex(pt.g3,nil)then P.custom.g3=pt.g3 end
    P.backgroundMode=pt.mode or"gradient"
    if(pt.bgImg or"")~=""then P.backgroundImage=H.assetId(pt.bgImg)or""
    elseif P.backgroundMode=="image"and(P.backgroundImage or"")==""and(st.bannerId or"")~=""then P.backgroundImage=st.bannerId end
    if pt.bgOp~=nil then P.backgroundOpacity=clamp((tonumber(pt.bgOp)or 82)/100,0.15,1)end
    if pt.bgDim~=nil then P.backgroundDim=clamp((tonumber(pt.bgDim)or 25)/100,0,0.75)end
    P.bgFrame={
      fit=(pt.wf=="fit"or pt.wf=="stretch"or pt.wf=="tile")and pt.wf or"crop",
      zoom=clamp(tonumber(pt.wz)or 100,100,300),x=clamp(tonumber(pt.wx)or 0,-100,100),y=clamp(tonumber(pt.wy)or 0,-100,100),
      aspect=(F._ASPECT and F._ASPECT[pt.wa or""])and pt.wa or"auto",
    }
    P.fontFamily=pt.font or"gotham"
    P.gradAngle=pt.gRot or 28;P.gradMix=(tonumber(pt.gMix)or 65)/100;P.uiRadius=pt.rad or 10;P.borderGlow=(pt.glow~=false)
    F.paintTheme();if S.booted and F.rebuildFeed then pcall(F.rebuildFeed,true)end;S.isDirty=true;F.save(true);F.toast(T("theme_ok"),true)
  end)

  local codeR=row(colC,26,6)
  local bCopyT=rbtn(codeR,T("theme_copy"),{size=u2(0.45,-3,1,0),key="btnBg",ts=10,r=6});st.chips[#st.chips+1]=bCopyT
  local codeInp=mk("TextBox",{Size=u2(0.55,-3,1,0),BackgroundColor3=cols.inpBg,TextColor3=cols.inpTxt,PlaceholderColor3=cols.muted,Text="",PlaceholderText=T("theme_paste"),ClearTextOnFocus=false,Font=fCode,TextSize=10,BorderSizePixel=0,TextXAlignment=txL},codeR)
  corner(codeInp,6);pad(codeInp,6,2,6,2);mk("UIStroke",{Color=cols.iBorder,Thickness=1,Transparency=0.35,ApplyStrokeMode=smBorder},codeInp);st.inputs[#st.inputs+1]=codeInp
  hook(bCopyT.MouseButton1Click,function()
    F.copyText("CBT1:"..H.jenc({n="custom",a=0,c={bg=tBg.Text,bg2=tBg.Text,accent=tAcc.Text,text=tTxt.Text,g1=pt.g1,g2=pt.g2,g3=pt.g3},bm=pt.mode,bi=pt.bgImg,bo=(pt.bgOp or 82)/100,bd=(pt.bgDim or 25)/100,ga=pt.gRot,gm=(pt.gMix or 65)/100,ur=pt.rad,ff=pt.font,bglow=pt.glow}))
  end)
  hook(codeInp.FocusLost,function(enter)
    local raw=H.trim(codeInp.Text);if raw==""then return end
    local j=raw:match("^CBT[12]:(.+)$");local d=j and H.jdec(j)
    if type(d)=="table"then
      local c=type(d.c)=="table"and d.c or{};local base=d.n and THEMES[d.n]
      tBg.Text=H.safeHex(c.bg2 or c.bg or(base and base.bg2),nil)or tBg.Text;tAcc.Text=H.safeHex(c.accent or(base and base.accent),nil)or tAcc.Text;tTxt.Text=H.safeHex(c.text or(base and base.text),nil)or tTxt.Text
      pt.g1=H.safeHex(c.g1 or(base and base.g1),nil)or pt.g1;pt.g2=H.safeHex(c.g2 or(base and base.g2),nil)or pt.g2;pt.g3=H.safeHex(c.g3 or(base and base.g3),nil)or pt.g3
      if d.bm and(d.bm=="solid"or d.bm=="gradient"or d.bm=="mesh"or d.bm=="glass"or d.bm=="image")then pt.mode=d.bm end
      if d.ff and FONT_MAP[d.ff]then pt.font=d.ff end
      if d.ga then pt.gRot=clamp(tonumber(d.ga)or 28,0,360);setSlRot(pt.gRot,false)end
      if d.gm then pt.gMix=clamp(floor((tonumber(d.gm)or 0.65)*100+0.5),15,100);setSlMix(pt.gMix,false)end
      if d.ur then pt.rad=clamp(tonumber(d.ur)or 10,3,16);setSlRad(pt.rad,false)end
      if d.bglow~=nil then pt.glow=(d.bglow==true)end
      codeInp.Text="";refresh();F.toast(T("theme_ok"),true)
    elseif enter then F.toast(T("theme_bad"),true)end
  end)

  -- 5. 34 Preset Themes
  F._PROF.section(st,parent,L=="en"and"34 CHROMA & PRESET THEMES"or"34 MẪU CHROMA & THEME CÓ SẴN",9,"wand")
  local catRow=row(parent,24,10)
  local pGrid=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BackgroundTransparency=1,LayoutOrder=11},parent)
  local curCat="all";local cBtns={};local presets={}
  for _,tn in ipairs(THEME_ORDER)do
    local t=THEMES[tn]
    if t then presets[#presets+1]={label=tn:sub(1,1):upper()..tn:sub(2):gsub("_"," "),bg=t.bg2,acc=t.accent,txt=t.text,g1=t.g1 or t.bg,g2=t.g2 or t.bg2,g3=t.g3 or t.bg3,gRot=t.gRot or 28,cat=t.cat or(H.lum(H.hex(t.bg))<0.45 and"dark"or"light")}end
  end
  presets[#presets+1]={label="Gold VIP",bg="#1A1813",acc="#E6B422",txt="#FFF6D6",g1="#120E04",g2="#261D0A",g3="#38290E",gRot=26,cat="chroma"}
  presets[#presets+1]={label="Crimson",bg="#1F1114",acc="#FF2D55",txt="#FFE8EC",g1="#14070A",g2="#2B0E17",g3="#1D1026",gRot=32,cat="chroma"}
  presets[#presets+1]={label="Galaxy",bg="#110D24",acc="#8A2BE2",txt="#F3E8FF",g1="#0B0719",g2="#1E1038",g3="#2D124D",gRot=36,cat="chroma"}
  presets[#presets+1]={label=L=="en"and"Default"or"Mặc định",bg="",acc="",txt="",g1="",g2="",g3="",gRot=28,cat="all",isReset=true}

  local function rebuildPresets()
    for _,c in ipairs(pGrid:GetChildren())do c:Destroy()end
    mk("UIGridLayout",{CellSize=u2(1/3,-5,0,34),CellPadding=uo(5,5),SortOrder=soLO},pGrid)
    for idx,pr in ipairs(presets)do
      if curCat=="all"or pr.isReset or pr.cat==curCat or(curCat=="dark"and pr.cat=="chroma"and H.lum(H.hex(pr.bg))<0.45)then
        local pBg=(pr.bg~=""and H.hex(pr.bg))or TH.cardBg;local pTxt=(pr.txt~=""and H.hex(pr.txt))or TH.text;local pAcc=(pr.acc~=""and H.hex(pr.acc))or TH.accent
        local pb=mk("TextButton",{Size=us(1,1),BackgroundColor3=pr.cat=="chroma"and c3(1,1,1)or pBg,Text="",BorderSizePixel=0,AutoButtonColor=true,LayoutOrder=idx,ClipsDescendants=true},pGrid)
        corner(pb,7);mk("UIStroke",{Color=pAcc,Thickness=1.1,Transparency=0.3,ApplyStrokeMode=smBorder},pb)
        if pr.cat=="chroma"then mk("UIGradient",{Rotation=pr.gRot or 28,Color=ColorSequence.new({ColorSequenceKeypoint.new(0,H.hex(pr.g1)),ColorSequenceKeypoint.new(0.55,H.hex(pr.g2)),ColorSequenceKeypoint.new(1,H.hex(pr.g3))})},pb)end
        local pl=lab(pb,pr.label,{size=u2(1,-8,1,0),pos=uo(4,0),bold=true,ts=10,align=txC,trunc=true});pl.TextColor3=H.ensureContrast(pTxt,pBg,4.5)
        hook(pb.MouseButton1Click,function()
          tBg.Text=pr.bg;tAcc.Text=pr.acc;tTxt.Text=pr.txt;pt.g1=pr.g1;pt.g2=pr.g2;pt.g3=pr.g3;pt.gRot=pr.gRot or 28;setSlRot(pt.gRot,false)
          if pr.isReset then
            pt.mode="solid";pt.font="gotham";pt.rad=12;pt.glow=true;pt.avDec="none";pt.nEff="solid";setSlRad(12,false)
            if st.fields.tBgImg then st.fields.tBgImg.Text=""end
          elseif pr.cat=="chroma"and pt.mode=="solid"then pt.mode="gradient"end
          if st.fn.refreshThemeBadges then st.fn.refreshThemeBadges()end
          F._PROF.applyColors(st,pr.bg,pr.acc,pr.txt)
        end)
      end
    end
  end
  for idx,cd in ipairs({{"all","cat_all"},{"chroma","cat_chroma"},{"dark","cat_dark"},{"light","cat_light"}})do
    local cid,ck=cd[1],cd[2]
    local cb=mk("TextButton",{Size=u2(0.25,-4,1,0),BackgroundColor3=cid=="all"and cols.acc or cols.sub,Text=T(ck),Font=fGB,TextSize=10,TextColor3=cid=="all"and H.ensureContrast(rgb(255,255,255),cols.acc,4.5)or cols.txt,BorderSizePixel=0,AutoButtonColor=true,LayoutOrder=idx},catRow)
    corner(cb,6);cBtns[cid]=cb
    hook(cb.MouseButton1Click,function()
      curCat=cid;for k,b in pairs(cBtns)do local on=(k==curCat);b.BackgroundColor3=on and cols.acc or cols.sub;b.TextColor3=on and H.ensureContrast(rgb(255,255,255),cols.acc,4.5)or cols.txt end
      rebuildPresets()
    end)
  end
  rebuildPresets()
end

function F._PROF.saveProfile(st)
  local f=st.fields
  local pt=st.pTheme
  if f.tName then P.display=H.clip(H.trim(f.tName.Text)~=""and H.trim(f.tName.Text)or LP.DisplayName,40)end
  if f.tStatus then P.status=H.clip(H.trim(f.tStatus.Text),80)end
  if f.tBio then P.bio=H.clip(H.trim(f.tBio.Text),180)end
  if f.tCountry then P.country=H.resolveCountry(f.tCountry.Text)end
  if f.tTag then pt.tag=H.clip(H.trim(f.tTag.Text),36)end
  if f.tBanner then P.profBanner=H.assetId(f.tBanner.Text)or""end
  if f.tIcon then P.profIcon=H.assetId(f.tIcon.Text)or""end
  if f.tBg then pt.bg=H.safeHex(f.tBg.Text,nil)or""end
  if f.tAcc then pt.acc=H.safeHex(f.tAcc.Text,nil)or""end
  if f.tTxt then pt.txt=H.safeHex(f.tTxt.Text,nil)or""end
  if f.tBgImg then pt.bgImg=H.assetId(f.tBgImg.Text)or""end
  P.profTheme=F.compactProfTheme(pt)
  if S.users[P.username]then S.users[P.username].profTheme=P.profTheme;S.users[P.username].profBanner=P.profBanner;S.users[P.username].profIcon=P.profIcon end
  S.isDirty=true;F.save(true);F.heartbeat(false)
  if F.rebuildFeed then pcall(F.rebuildFeed,true)end
  F.toast(T("saved_ok"),true);F.closeModal()
end

--- [F.openProfile] Mở hộp thoại Hồ sơ người dùng chuẩn Discord hiện đại (Responsive 2 cột trên PC / 1 cột trên Mobile) kèm Studio cắt ảnh
function F.openProfile(u,initTab,_noFetch)
  if not u then return end
  u=H.trim(tostring(u)):gsub("^@","")
  if u==""then return end
  S._profReqGen=(S._profReqGen or 0)+1
  local reqGen=S._profReqGen
  S.reopenModal=function()F.openProfile(u,initTab,true)end
  local st=F._PROF.initState(u,initTab)
  local pt=st.pTheme
  local v=viewNow()
  local isWide=(v.X>=680 and v.Y>=460)
  local mw=isWide and min(770,v.X-24)or min(425,v.X-16)
  local mh=isWide and min(565,v.Y-24)or min(650,v.Y-16)

  local scr,_,box=F.modalBox(T("profile"),mw,mh)
  box.ClipsDescendants=true

  local uSt=st.ui
  uSt.box=box
  uSt.boxGradFrame=mk("Frame",{Size=us(1,1),BackgroundColor3=c3(1,1,1),BackgroundTransparency=1,BorderSizePixel=0,ZIndex=40,Visible=false},box)
  uSt.boxGradCorner=corner(uSt.boxGradFrame,pt.rad or 12)
  uSt.boxUIGrad=mk("UIGradient",{Rotation=pt.gRot or 28},uSt.boxGradFrame)
  uSt.boxMeshFrame=mk("Frame",{Size=us(1,1),BackgroundColor3=c3(1,1,1),BackgroundTransparency=0.52,BorderSizePixel=0,ZIndex=40,Visible=false},box)
  uSt.boxMeshCorner=corner(uSt.boxMeshFrame,pt.rad or 12)
  uSt.boxMeshGrad=mk("UIGradient",{Rotation=140,Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0.15),NumberSequenceKeypoint.new(0.5,0.65),NumberSequenceKeypoint.new(1,0.2)})},uSt.boxMeshFrame)
  uSt.boxBgImg=mk("ImageLabel",{Size=us(1,1),BackgroundTransparency=1,ImageTransparency=0.82,ScaleType=Enum.ScaleType.Crop,BorderSizePixel=0,ZIndex=41,Visible=false},box)
  uSt.boxImgCorner=corner(uSt.boxBgImg,pt.rad or 12)
  uSt.boxTintFrame=mk("Frame",{Size=us(1,1),BackgroundColor3=st.cols.box,BackgroundTransparency=1,BorderSizePixel=0,ZIndex=41,Visible=false},box)
  uSt.boxTintCorner=corner(uSt.boxTintFrame,pt.rad or 12)
  uSt.boxStroke=box:FindFirstChildOfClass("UIStroke")
  uSt.boxStrokeGrad=uSt.boxStroke and(uSt.boxStroke:FindFirstChildOfClass("UIGradient")or mk("UIGradient",{Rotation=40},uSt.boxStroke))or nil

  st.fn.updWallpaper=function(rawVal)
    local aid=H.assetId(rawVal);pt.bgImg=aid or""
    local wt=1-clamp((tonumber(pt.bgOp)or 82)/100,0.15,1)
    if aid and aid~=""then
      local tr=(pt.mode=="image"or pt.mode==nil or pt.mode=="")and wt or max(0.76,wt)
      uSt.boxBgImg.ImageTransparency=tr;uSt.boxBgImg.Visible=true;F.setAsset(uSt.boxBgImg,aid,nil,tr)
      F.applyImageFrame(box,uSt.boxBgImg,{fit=pt.wf,zoom=pt.wz,x=pt.wx,y=pt.wy,aspect=pt.wa},mw,mh)
    else uSt.boxBgImg.Visible=false;uSt.boxBgImg.Image=""end
  end

  local leftParent,rightParent,navParent,saveParent
  if isWide then
    scr.ScrollingEnabled=false;scr.AutomaticCanvasSize=Enum.AutomaticSize.None;scr.ScrollBarThickness=0
    local split=mk("Frame",{Size=us(1,1),BackgroundTransparency=1},scr)
    local leftScr=mk("ScrollingFrame",{Size=u2(0.37,-5,1,0),Position=uo(0,0),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=2,CanvasSize=u2(),AutomaticCanvasSize=asY},split)
    list(leftScr,8);pad(leftScr,2,2,4,6)
    local rightCol=mk("Frame",{Size=u2(0.63,-5,1,0),Position=u2(0.37,5,0,0),BackgroundTransparency=1},split)
    navParent=mk("Frame",{Size=u2(1,0,0,32),Position=uo(0,0),BackgroundTransparency=1},rightCol)
    local rFootH=st.canEdit and 42 or 0
    local rightScr=mk("ScrollingFrame",{Size=u2(1,0,1,-(36+rFootH)),Position=uo(0,36),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=3,CanvasSize=u2(),AutomaticCanvasSize=asY},rightCol)
    list(rightScr,8);pad(rightScr,2,2,6,8)
    leftParent=leftScr;rightParent=rightScr
    if st.canEdit then
      saveParent=mk("Frame",{Size=u2(1,0,0,36),Position=u2(0,0,1,-36),BackgroundTransparency=1},rightCol)
    end
  else
    leftParent=scr
    navParent=mk("Frame",{Size=u2(1,0,0,32),BackgroundTransparency=1,LayoutOrder=2},scr)
    rightParent=scr;saveParent=scr
  end

  F._PROF.buildLeftIdentity(st,leftParent)

  -- Thanh Tab kiểu gạch chân hiện đại của Discord
  local tabRow=mk("Frame",{Size=us(1,1),BackgroundTransparency=1},navParent)
  mk("UIListLayout",{FillDirection=fdH,Padding=u1(0,10),SortOrder=soLO,VerticalAlignment=vaC},tabRow)
  local navLine=mk("Frame",{Size=u2(1,0,0,1),Position=u2(0,0,1,-1),BackgroundColor3=st.cols.cBorder,BackgroundTransparency=0.5,BorderSizePixel=0},navParent)
  st.dividers[#st.dividers+1]=navLine

  local tabDefs=st.canEdit and{
    {id=1,txt="Board",ic="grid"},
    {id=2,txt=L=="en"and"Activity"or"Hoạt động",ic="activity"},
    {id=3,txt=L=="en"and"Edit"or"Sửa",ic="pencil"},
    {id=4,txt=L=="en"and"Images"or"Ảnh",ic="crop"},
    {id=5,txt=L=="en"and"Style"or"Style",ic="palette"},
  }or{
    {id=1,txt="Board",ic="grid"},
    {id=2,txt=L=="en"and"Activity"or"Hoạt động",ic="activity"},
  }

  local panes={}
  local function getPane(idx)
    if not panes[idx]then
      local p=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BackgroundTransparency=1,LayoutOrder=2+idx,Visible=(st.curTab==idx)},rightParent)
      list(p,7);panes[idx]=p
    end
    return panes[idx]
  end
  F._PROF.buildBoardTab(st,getPane(1))
  F._PROF.buildActivityTab(st,getPane(2))
  if st.canEdit then
    F._PROF.buildEditTab(st,getPane(3))
    F._PROF.buildImagesTab(st,getPane(4))
    F._PROF.buildStyleTab(st,getPane(5))
  end

  st.fn.openWidgetModal=function()
    local wScr,wClose=F.popup(L=="en"and"Customize Board Widgets"or"Tuỳ chỉnh Bảng Hồ Sơ",340,360)
    local curOrder={}
    for p in tostring(pt.wOrder or"bio,scripts,game,stats"):gmatch("[^,]+")do curOrder[#curOrder+1]=H.trim(p:lower())end
    local enabled={};for _,k in ipairs(curOrder)do enabled[k]=true end
    for _,k in ipairs({"bio","scripts","game","stats"})do if not enabled[k]then curOrder[#curOrder+1]=k end end
    local wNames={bio=L=="en"and"About Me / Bio"or"Giới thiệu (Bio)",scripts=L=="en"and"Shared Scripts Showcase"or"Kho Script Chia Sẻ",game=L=="en"and"Live Roblox Game Card"or"Game Roblox Đang Chơi",stats=L=="en"and"Community Stats"or"Chỉ số Cộng đồng"}
    local listWrap=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BackgroundTransparency=1},wScr);list(listWrap,6)
    local function redraw()
      for _,c in ipairs(listWrap:GetChildren())do if not c:IsA("UIListLayout")then c:Destroy()end end
      for idx,k in ipairs(curOrder)do
        local rCard=F.card(listWrap,idx);rCard.Size=u2(1,0,0,36);pad(rCard,8,4,8,4)
        local r=mk("Frame",{Size=us(1,1),BackgroundTransparency=1},rCard)
        local tog=tbtn(r,enabled[k]and"ON"or"OFF",{size=uo(42,24),pos=uo(0,2),key=enabled[k]and"ok"or"btnBg",ts=10,r=6})
        lab(r,wNames[k]or k,{size=u2(1,-108,1,0),pos=uo(50,0),ts=11,bold=true,trunc=true})
        local upB=tbtn(r,"▲",{size=uo(24,24),pos=u2(1,-52,0,2),key="btnBg",ts=10,r=5})
        local dnB=tbtn(r,"▼",{size=uo(24,24),pos=u2(1,-24,0,2),key="btnBg",ts=10,r=5})
        hook(tog.MouseButton1Click,function()enabled[k]=not enabled[k]or nil;redraw()end)
        hook(upB.MouseButton1Click,function()if idx>1 then curOrder[idx],curOrder[idx-1]=curOrder[idx-1],curOrder[idx];redraw()end end)
        hook(dnB.MouseButton1Click,function()if idx<#curOrder then curOrder[idx],curOrder[idx+1]=curOrder[idx+1],curOrder[idx];redraw()end end)
      end
    end
    redraw()
    local apB=tbtn(wScr,L=="en"and"Apply Board Layout"or"Áp dụng Bố cục",{key="accent",h=32})
    hook(apB.MouseButton1Click,function()
      local nextList={};for _,k in ipairs(curOrder)do if enabled[k]then nextList[#nextList+1]=k end end
      if#nextList==0 then nextList={"bio"}end
      pt.wOrder=tconcat(nextList,",")
      wClose()
      for _,c in ipairs(panes[1]:GetChildren())do if not c:IsA("UIListLayout")then c:Destroy()end end
      F._PROF.buildBoardTab(st,panes[1]);F._PROF.applyColors(st)
    end)
  end

  st.fn.refreshTabVisuals=function()
    local fm=FONT_MAP[pt.font or"gotham"]or FONT_MAP.gotham
    for _,tb in ipairs(st.tabBtns)do
      local on=(tb.id==st.curTab)
      tb.lbl.TextColor3=on and st.cols.txt or st.cols.muted
      tb.lbl.Font=fm.bold
      if tb.ic then tb.ic.ImageColor3=on and st.cols.acc or st.cols.muted end
      tb.line.Visible=on;tb.line.BackgroundColor3=st.cols.acc
    end
  end

  st.fn.setTab=function(idx)
    st.curTab=idx;initTab=idx
    for k,p in pairs(panes)do p.Visible=(k==idx)end
    st.fn.refreshTabVisuals()
  end

  for idx,td in ipairs(tabDefs)do
    local tw=clamp(H.textW(td.txt,11,fGB)+26,56,112)
    local b=mk("TextButton",{Size=uo(tw,30),BackgroundTransparency=1,Text="",AutoButtonColor=true,BorderSizePixel=0,LayoutOrder=idx},tabRow)
    local ic=F.lucide(b,td.ic,12,{pos=uo(2,9),col=st.cols.muted,themed=false})
    local tl=lab(b,td.txt,{size=u2(1,-18,1,0),pos=uo(18,0),ts=11,bold=true,align=txL,trunc=true})
    local ln=mk("Frame",{Size=u2(1,0,0,2),Position=u2(0,0,1,-2),BackgroundColor3=st.cols.acc,BorderSizePixel=0,Visible=(td.id==st.curTab)},b)
    st.tabBtns[#st.tabBtns+1]={id=td.id,btn=b,ic=ic,lbl=tl,line=ln}
    hook(b.MouseButton1Click,function()st.fn.setTab(td.id)end)
  end

  if st.canEdit and saveParent then
    local sv=mk("TextButton",{Size=u2(1,0,0,34),BackgroundColor3=st.cols.acc,Text="  "..T("save_profile"),Font=fGB,TextSize=12,TextColor3=H.ensureContrast(rgb(255,255,255),st.cols.acc,4.5),BorderSizePixel=0,AutoButtonColor=true,LayoutOrder=90},saveParent)
    corner(sv,8);st.accents[#st.accents+1]=sv
    F.lucide(sv,"save",14,{pos=uo(14,10),col=H.lum(st.cols.acc)>0.55 and rgb(20,20,24)or c3(1,1,1),themed=false})
    hook(sv.MouseButton1Click,function()F._PROF.saveProfile(st)end)
  end

  st.fn.refreshThemeBadges()
  F._PROF.applyColors(st,pt.bg or"",pt.acc or"",pt.txt or"")
  if not _noFetch and not st.isSelf then
    local preSig=H.jenc({uid=F.uidOf(u),d=st.rec.display or"",b=st.bannerId,i=st.iconId,s=st.rec.status or"",bio=st.rec.bio or"",c=st.rec.country or"",ls=tonumber(st.rec.lastSeen)or 0,live=st.live,pt=F.compactProfTheme(pt)})
    F.fetchUserProfile(u,function(newRec)
      if not box or not box.Parent or not U.modal.Visible or S._profReqGen~=reqGen then return end
      local nr=newRec or{}
      local npt=type(nr.profTheme)=="table"and nr.profTheme or{}
      local postSig=H.jenc({uid=F.uidOf(u),d=nr.display or"",b=H.assetId(nr.profBanner or"")or"",i=H.assetId(nr.profIcon or"")or"",s=nr.status or"",bio=nr.bio or"",c=nr.country or"",ls=tonumber(nr.lastSeen)or 0,live=F.isLive(nr),pt=F.compactProfTheme(npt)})
      if postSig~=preSig then
        F.openProfile(u,st.curTab,true)
      end
    end)
  end
end

-- =============================================================================
-- 19. CÔNG CỤ QUẢN TRỊ (MODERATION: REPORT, MUTE, WARN, ADMIN PANEL & ROLE EDITOR)
-- =============================================================================
--- [F.resolveUser] Tìm kiếm tài khoản Roblox theo tên qua `Players:GetUserIdFromNameAsync` để lấy tên chuẩn và UserId
function F.resolveUser(text,cb)text=H.trim(text):gsub("^@","")task.spawn(function()local uid,name
    if text:match("^%d+$")then uid=tonumber(text)local ok,n=pcall(Players.GetNameFromUserIdAsync,Players,uid)name=ok and n or nil else local ok,id=pcall(Players.GetUserIdFromNameAsync,Players,text)if ok and id then uid=id
        local ok2,n=pcall(Players.GetNameFromUserIdAsync,Players,id)name=ok2 and n or text end end if name and uid then S.users[name]=S.users[name]or{display=name,userId=uid}S.users[name].userId=S.users[name].userId or uid end
    cb(name and{u=name,id=uid}or nil)end)end
--- [F.pickUser] Mở hộp thoại tìm kiếm và chọn người dùng (hỗ trợ chọn đơn hoặc chọn nhiều người để gán Role)
function F.pickUser(o)local scr,close=F.popup(o.title or T("pick_user"),340,450)local q=field(scr,"","")q.PlaceholderText=T("search_user")
  local box=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BackgroundTransparency=1,LayoutOrder=3},scr)list(box,3)
  local function candidates()local seen,out={},{}
    local function add(u)if u and not seen[u]then seen[u]=true;out[#out+1]=u end end add(P.username)for u in pairs(S.users)do add(u)end if o.assigned then for u in pairs(S.assign)do add(u)end end
    for u in pairs(P.dmList)do add(u)end tsort(out,function(a,b)local la,lb=(a==P.username or F.isLive(S.users[a])),(b==P.username or F.isLive(S.users[b]))if la~=lb then return la end return a:lower()<b:lower()end)
    return out end
  local function build()for _,c in ipairs(box:GetChildren())do if not c:IsA("UIListLayout")then c:Destroy()end end
    local needle=H.trim(q.Text):lower():gsub("^@","")local n,exact=0,false
    for _,u in ipairs(candidates())do local rec=S.users[u]or{}if needle==""or u:lower():find(needle,1,true)or tostring(rec.display or""):lower():find(needle,1,true)then n=n+1 if n>60 then break end
        if u:lower()==needle then exact=true end
        local rowB rowB=F.userRow(box,u,{layout=n,right=o.multi and 30 or 0,click=function(x)if o.multi then local on=not o.isOn(x)o.onToggle(x,on)
              rowB:FindFirstChild("chk").Text=o.isOn(x)and"[x]"or""else close();o.onPick(x)end end})if o.multi then local c=lab(rowB,o.isOn(u)and"[x]"or"",{size=uo(24,38),pos=u2(1,-28,0,0),bold=true,ts=15,align=txC,key="ok"})
          c.Name="chk"end end end if needle~=""and not exact and#needle>=3 then local fb=tbtn(box,T("roblox_find")..needle,{key="accent",h=32,layout=999})hook(fb.MouseButton1Click,function()fb.Text="…"
        F.resolveUser(needle,function(r)if not r then if fb.Parent then fb.Text=T("not_found")end return end if o.multi then o.onToggle(r.u,true);if box.Parent then build()end else close();o.onPick(r.u)end end)end)end end
  hook(q:GetPropertyChangedSignal("Text"),build)build()end
--- [F.userField] Tạo ô nhập tên người dùng kèm nút mở nhanh danh sách chọn người dùng (`F.pickUser`)
function F.userField(parent,label,value)lab(parent,label,{h=14,ts=10,bold=true,key="muted"})
  local r=mk("Frame",{Size=u2(1,0,0,30),BackgroundTransparency=1},parent)local b=mk("TextBox",{Size=u2(1,-36,1,0),Text=value or"",ClearTextOnFocus=false,Font=fG,TextSize=12,BorderSizePixel=0,TextXAlignment=txL},r)
  F.styleInput(b,"text",false)local p=tbtn(r,"@",{size=uo(32,30),pos=u2(1,-32,0,0),key="accent",r=6})
  hook(p.MouseButton1Click,function()F.pickUser({title=T("pick_user"),onPick=function(u)b.Text=u end})end)return b end
--- [F.recentBy] Lấy tối đa `n` tin nhắn gần nhất của người dùng `user` để đính kèm làm bằng chứng khi gửi Báo cáo (Report)
function F.recentBy(user,n)local out={}for i=#S.order,1,-1 do local m=S.msgs[S.order[i]]
    if m and m.author==user and not m.deleted then tinsert(out,1,{author=m.author,content=H.clip(F.plain(m.content),100)})if#out>=n then break end end end return out end
--- [F.openReport] Mở hộp thoại gửi Báo cáo vi phạm (Report) đối với một người dùng
function F.openReport(target,msg)
  local scr=F.modalBox(T("report"),340,420)local tg=F.userField(scr,T("target"),target or"")local rs=field(scr,T("reason"),"",true)local pub=true
  F.switch(scr,T("is_public"),function()return pub end,function(v)pub=v end)local go=tbtn(scr,T("report"),{key="warn",h=34})hook(go.MouseButton1Click,function()local t,r=H.trim(tg.Text),H.trim(rs.Text)
    if t==""or r==""then F.toast(T("need_reason"),true);return end
    local ev=F.recentBy(t,3)if msg then ev={{author=msg.author,content=H.clip(F.plain(msg.content),100)}}end
    F.publish({type="report",reporter=P.username,target=t,reason=H.clip(r,300),evidence=ev,isPublic=pub,chan="staff"})F.closeModal();F.toast(T("report_sent"),true)end)end
--- [F.openMute] Mở hộp thoại cấm chat (Mute) một người dùng kèm thời hạn và lý do thông báo lên kênh #punish & Profile
function F.openMute(target)
  local scr=F.modalBox("🔇 "..T("mute"),360,480)local tg=F.userField(scr,T("target"),target or"")local mn=field(scr,T("minutes"),"10")
  local durRow=row(scr,24)for idx,d in ipairs({{"5m","5"},{"15m","15"},{"60m","60"},{T("perm_lbl"),"0"}})do
    local db=rbtn(durRow,d[1],{size=u2(0.25,-4,1,0),ts=10,key="bg3",r=6,layout=idx})hook(db.MouseButton1Click,function()mn.Text=d[2]end)
  end
  local rs=field(scr,T("reason"),"",true)lab(scr,T("script_quick_reason"),{ts=10,key="muted",bold=true})
  for _,qr in ipairs({T("qr_spam"),T("qr_toxic"),T("qr_scam"),T("qr_rule")})do
    local qb=tbtn(scr,"• "..qr,{h=24,ts=10,key="btnBg"})qb.TextXAlignment=txL;pad(qb,8,0,8,0)hook(qb.MouseButton1Click,function()rs.Text=qr end)
  end
  local go=tbtn(scr,"🔇 "..T("mute"),{key="danger",h=34})
  hook(go.MouseButton1Click,function()local t,r=H.trim(tg.Text):gsub("^@",""),H.trim(rs.Text)if t==""or r==""then F.toast(T("need_reason"),true);return end
    if not F.canAct(P.username,t)then F.toast(T("hier"),true);return end local mins=tonumber(mn.Text)or 0
    local exp=mins>0 and(H.now()+mins*60)or 0 local pid=H.uuid()local now=H.now()
    F.applyMute(t,{on=true,u=t,reason=H.clip(r,200),exp=exp,by=P.username,ts=now})
    F.recordPunish({id=pid,action="mute",target=t,by=P.username,reason=H.clip(r,200),exp=exp,ts=now})
    F.publish({type="mute",packetId=pid,by=P.username,target=t,reason=H.clip(r,200),expires_at=exp,chan="punish",ts=now})
    F.closeModal();if S.chan=="punish"then F.rebuildFeed(true)end F.toast(T("mute_sent"),true)end)end
--- [F.openWarn] Mở hộp thoại gửi Cảnh báo (Warn) tới một người dùng kèm lý do hiển thị trên kênh #punish & Profile
function F.openWarn(target)
  local scr=F.modalBox("⚠️ "..T("warn"),360,430)local tg=F.userField(scr,T("target"),target or"")local rs=field(scr,T("reason"),"",true)
  lab(scr,T("script_quick_reason"),{ts=10,key="muted",bold=true})
  for _,qr in ipairs({T("qr_spam"),T("qr_toxic"),T("qr_scam"),T("qr_rule")})do
    local qb=tbtn(scr,"• "..qr,{h=24,ts=10,key="btnBg"})qb.TextXAlignment=txL;pad(qb,8,0,8,0)hook(qb.MouseButton1Click,function()rs.Text=qr end)
  end
  local go=tbtn(scr,"⚠️ "..T("warn"),{key="warn",h=34})hook(go.MouseButton1Click,function()
    local t,r=H.trim(tg.Text):gsub("^@",""),H.trim(rs.Text)if t==""or r==""then F.toast(T("need_reason"),true);return end if not F.canAct(P.username,t)then F.toast(T("hier"),true);return end
    local pid=H.uuid()local now=H.now()
    F.addWarnState(t,{id=pid,u=t,reason=H.clip(r,200),by=P.username,ts=now})
    F.recordPunish({id=pid,action="warn",target=t,by=P.username,reason=H.clip(r,200),exp=0,ts=now})
    F.publish({type="warn",packetId=pid,by=P.username,target=t,reason=H.clip(r,200),chan="punish",ts=now})
    F.closeModal();if S.chan=="punish"then F.rebuildFeed(true)end F.toast(T("warn_sent"),true)end)end
--- [F.openUnmute] Mở hộp thoại gỡ cấm chat (Unmute) kèm lý do thông báo lên kênh #punish
function F.openUnmute(target)
  local scr=F.modalBox("🔊 "..T("unmute"),350,390)local tg=F.userField(scr,T("target"),target or"")local rs=field(scr,T("reason"),T("qr_forgive"),true)
  lab(scr,T("script_quick_reason"),{ts=10,key="muted",bold=true})
  for _,qr in ipairs({T("qr_forgive"),T("qr_mistake"),T("qr_appeal")})do
    local qb=tbtn(scr,"• "..qr,{h=24,ts=10,key="btnBg"})qb.TextXAlignment=txL;pad(qb,8,0,8,0)hook(qb.MouseButton1Click,function()rs.Text=qr end)
  end
  local go=tbtn(scr,"🔊 "..T("unmute"),{key="ok",h=34})hook(go.MouseButton1Click,function()
    local t,r=H.trim(tg.Text):gsub("^@",""),H.trim(rs.Text)if t==""then return end if not F.canAct(P.username,t)then F.toast(T("hier"),true);return end
    if r==""then r=T("qr_forgive")end local pid=H.uuid()local now=H.now()
    F.clearMuteState(t)
    F.recordPunish({id=pid,action="unmute",target=t,by=P.username,reason=H.clip(r,200),exp=0,ts=now})
    F.publish({type="unmute",packetId=pid,by=P.username,target=t,reason=H.clip(r,200),chan="punish",ts=now})
    F.closeModal();if S.chan=="punish"then F.rebuildFeed(true)end F.toast(T("unmute_sent"),true)end)end
--- [F.openClearWarn] Mở hộp thoại xóa cảnh báo (Clear Warn) kèm lý do thông báo lên kênh #punish
function F.openClearWarn(target)
  local scr=F.modalBox("🧹 "..T("clear_warn"),350,390)local tg=F.userField(scr,T("target"),target or"")local rs=field(scr,T("reason"),T("qr_forgive"),true)
  lab(scr,T("script_quick_reason"),{ts=10,key="muted",bold=true})
  for _,qr in ipairs({T("qr_forgive"),T("qr_mistake"),T("qr_appeal")})do
    local qb=tbtn(scr,"• "..qr,{h=24,ts=10,key="btnBg"})qb.TextXAlignment=txL;pad(qb,8,0,8,0)hook(qb.MouseButton1Click,function()rs.Text=qr end)
  end
  local go=tbtn(scr,"🧹 "..T("clear_warn"),{key="ok",h=34})hook(go.MouseButton1Click,function()
    local t,r=H.trim(tg.Text):gsub("^@",""),H.trim(rs.Text)if t==""then return end if not F.canAct(P.username,t)then F.toast(T("hier"),true);return end
    if r==""then r=T("qr_forgive")end local pid=H.uuid()local now=H.now()
    F.clearWarnState(t)
    F.recordPunish({id=pid,action="clear_warn",target=t,by=P.username,reason=H.clip(r,200),exp=0,ts=now})
    F.publish({type="clear_warn",packetId=pid,by=P.username,target=t,reason=H.clip(r,200),chan="punish",ts=now})
    F.closeModal();if S.chan=="punish"then F.rebuildFeed(true)end F.toast(T("clear_warn_sent"),true)end)end
--- [F.openBan] Mở hộp thoại cấm người dùng (Ban) kèm lý do thông báo lên kênh #punish & Profile
function F.openBan(target,onDone)
  local scr=F.modalBox("⛔ "..T("ban"),360,430)local tg=F.userField(scr,T("target"),target or"")local rs=field(scr,T("reason"),"",true)
  lab(scr,T("script_quick_reason"),{ts=10,key="muted",bold=true})
  for _,qr in ipairs({T("qr_scam"),T("qr_toxic"),T("qr_spam"),T("qr_rule")})do
    local qb=tbtn(scr,"• "..qr,{h=24,ts=10,key="btnBg"})qb.TextXAlignment=txL;pad(qb,8,0,8,0)hook(qb.MouseButton1Click,function()rs.Text=qr end)
  end
  local go=tbtn(scr,"⛔ "..T("ban"),{key="danger",h=34})hook(go.MouseButton1Click,function()
    local t,r=H.trim(tg.Text):gsub("^@",""),H.trim(rs.Text)if t==""or r==""then F.toast(T("need_reason"),true);return end if not F.canAct(P.username,t)then F.toast(T("hier"),true);return end
    local pid="ban-"..t:lower().."-"..tostring(H.now())local now=H.now()
    S.bannedMap[t:lower()]={u=t,reason=H.clip(r,200),exp=0,by=P.username,ts=now}
    F.recordPunish({id=pid,action="ban",target=t,by=P.username,reason=H.clip(r,200),exp=0,ts=now})
    F.publish({type="ban",packetId=pid,by=P.username,target=t,reason=H.clip(r,200),chan="punish",ts=now})
    if F.isDev(P.username)then enqueue("other","POST","/api/approve",{by=P.username,u=t,reason=H.clip(r,200),action="ban"})end
    F.closeModal();if S.chan=="punish"then F.rebuildFeed(true)end if onDone then pcall(onDone)end F.toast(T("ban_sent"),true)end)end
--- [F.openUnban] Mở hộp thoại gỡ cấm (Unban) kèm lý do thông báo lên kênh #punish
function F.openUnban(target,onDone)
  local scr=F.modalBox("🔓 "..T("unban"),350,390)local tg=F.userField(scr,T("target"),target or"")local rs=field(scr,T("reason"),T("qr_appeal"),true)
  lab(scr,T("script_quick_reason"),{ts=10,key="muted",bold=true})
  for _,qr in ipairs({T("qr_appeal"),T("qr_forgive"),T("qr_mistake")})do
    local qb=tbtn(scr,"• "..qr,{h=24,ts=10,key="btnBg"})qb.TextXAlignment=txL;pad(qb,8,0,8,0)hook(qb.MouseButton1Click,function()rs.Text=qr end)
  end
  local go=tbtn(scr,"🔓 "..T("unban"),{key="ok",h=34})hook(go.MouseButton1Click,function()
    local t,r=H.trim(tg.Text):gsub("^@",""),H.trim(rs.Text)if t==""then return end
    if r==""then r=T("qr_appeal")end local pid="unb-"..t:lower().."-"..tostring(H.now())local now=H.now()
    S.bannedMap[t:lower()]=nil
    for i=#(S.bannedList or{}),1,-1 do if tostring(S.bannedList[i].u or""):lower()==t:lower()then tremove(S.bannedList,i)end end
    F.recordPunish({id=pid,action="unban",target=t,by=P.username,reason=H.clip(r,200),exp=0,ts=now})
    enqueue("other","POST","/api/unban",{by=P.username,u=t,reason=H.clip(r,200)},function(d)
      if not(d and d.ok)then F.publish({type="unban",packetId=pid,by=P.username,target=t,reason=H.clip(r,200),chan="punish",ts=now})end
    end)
    F.closeModal();if S.chan=="punish"then F.rebuildFeed(true)end if onDone then pcall(onDone)end F.toast(T("unban_sent"),true)end)end
--- [F.openAdmin] Mở bảng điều khiển Quản trị (Admin Panel): công cụ xử phạt/gỡ phạt nhanh, duyệt Role, quản lý danh sách Ban và xem Report
function F.openAdmin()
  if not F.isStaff(P.username)then F.toast(T("staff_only"),true);return end
  local scr=F.modalBox(T("admin"),400,560)
  local r1=row(scr,28)
  local b1=rbtn(r1,"⚠️ "..T("warn").."…",{key="warn",ts=11});hook(b1.MouseButton1Click,function()F.openWarn("")end)
  local b2=rbtn(r1,"🧹 "..T("clear_warn").."…",{key="ok",ts=11});hook(b2.MouseButton1Click,function()F.openClearWarn("")end)
  local r1b=row(scr,28)
  local b3=rbtn(r1b,"🔇 "..T("mute").."…",{key="danger",ts=11});hook(b3.MouseButton1Click,function()F.openMute("")end)
  local b4=rbtn(r1b,"🔊 "..T("unmute").."…",{key="ok",ts=11});hook(b4.MouseButton1Click,function()F.openUnmute("")end)
  local r1c=row(scr,28)
  local b5=rbtn(r1c,"⛔ "..T("ban").."…",{key="danger",ts=11});hook(b5.MouseButton1Click,function()F.openBan("")end)
  local b6=rbtn(r1c,"🔓 "..T("unban").."…",{key="ok",ts=11});hook(b6.MouseButton1Click,function()F.openUnban("")end)
  if F.isDev(P.username)then local rb=tbtn(scr,T("roles"),{key="accent",h=30})hook(rb.MouseButton1Click,function()F.openRoles()end)local ub=tbtn(scr,T("requests").." (Refresh)",{h=28,ts=11})
    hook(ub.MouseButton1Click,function()enqueue("other","GET","/api/requests?by="..H.url(P.username),nil,function(d)if d and d.ok then S.requests=d.requests or{}S.bannedList=d.banned or{}F.toast("Refreshed",true);F.openAdmin()
        else F.netError(d and d.error or"network")end end)end)end
  F.section(scr,T("requests"))local pending=S.requests or{}if#pending==0 then lab(scr,T("no_requests"),{key="muted"})else for i,rq in ipairs(pending)do
      local c=F.card(scr,0);c.AutomaticSize=asY;c.Size=u2(1,0,0,0)pad(c,8,6,8,6);list(c,3);c.LayoutOrder=i lab(c,"👤 "..F.disp(rq.u).."  ·  "..H.shortTime(rq.ts),{bold=true,ts=12,trunc=true})local rn=rq.role
      for _,r in ipairs(S.roles)do if r.id==rq.role then rn=r.name;break end end lab(c,"-> "..F.disp(tostring(rn))..(rq.reason~=""and("  ·  "..F.disp(rq.reason))or""),{ts=11,key="muted",wrap=true,auto=true})local rr=row(c,28)
      local ap=rbtn(rr,T("approve"),{key="ok",ts=11,size=u2(0.32,-2,1,0)})hook(ap.MouseButton1Click,function()enqueue("other","POST","/api/approve",{by=P.username,u=rq.u,role=rq.role,action="approve"},function(d,e)
          if d and d.ok then if d.roles then F.applyRoles(d.roles,d.seq,true)end for k,v in ipairs(S.requests)do if v.u==rq.u then tremove(S.requests,k);break end end
            F.toast(T("approve"),true);F.openAdmin()
          else F.netError(d and d.error or e)end end)end)local rj=rbtn(rr,T("reject"),{ts=11,size=u2(0.32,-2,1,0)})hook(rj.MouseButton1Click,function()
        enqueue("other","POST","/api/approve",{by=P.username,u=rq.u,action="reject"},function(d,e)if d and d.ok then for k,v in ipairs(S.requests)do if v.u==rq.u then tremove(S.requests,k);break end end
            F.toast(T("dismiss"),true);F.openAdmin()else F.netError(d and d.error or e)end end)end)local bn=rbtn(rr,T("ban"),{key="danger",ts=11,size=u2(0.32,-2,1,0)})hook(bn.MouseButton1Click,function()
        F.openBan(rq.u,function()for k,v in ipairs(S.requests)do if v.u==rq.u then tremove(S.requests,k);break end end end)end)end end if F.isDev(P.username)and#(S.bannedList or{})>0 then F.section(scr,T("banned_list").." ("..#S.bannedList..")")
    for i,bn in ipairs(S.bannedList)do local c=F.card(scr,0);c.AutomaticSize=asY;c.Size=u2(1,0,0,0)pad(c,8,6,8,6);list(c,3)
      lab(c,F.disp(bn.u)..(bn.reason~=""and("  ·  "..F.disp(bn.reason))or""),{bold=true,ts=12,trunc=true,key="danger"})local rr=row(c,26)local un=rbtn(rr,T("unban"),{key="ok",ts=11})
      hook(un.MouseButton1Click,function()F.openUnban(bn.u)end)local pf=rbtn(rr,T("profile"),{ts=11})hook(pf.MouseButton1Click,function()F.openProfile(bn.u)end)end end
  F.section(scr,T("reports"))
  if#S.reports==0 then lab(scr,T("no_reports"),{key="muted"})end for i=#S.reports,max(1,#S.reports-20),-1 do local rp=S.reports[i]local c=F.card(scr,0);c.AutomaticSize=asY;c.Size=u2(1,0,0,0);pad(c,8,6,8,6);list(c,3)
    lab(c,(rp.isPublic and""or"🔒 ")..F.disp(rp.reporter).." -> "..F.disp(rp.target).."  ·  "..H.shortTime(rp.ts),{bold=true,ts=11,trunc=true})lab(c,F.disp(rp.reason),{wrap=true,auto=true,ts=11})
    for _,e in ipairs(rp.evidence or{})do lab(c,"› "..F.disp(e.author)..": "..F.disp(e.content),{wrap=true,auto=true,ts=10,key="muted"})end
    local rr=row(c,26)
    local pf=rbtn(rr,T("profile"),{ts=11});hook(pf.MouseButton1Click,function()F.openProfile(rp.target)end)local ak=rbtn(rr,T("dismiss"),{ts=11})hook(ak.MouseButton1Click,function()tremove(S.reports,i);S.isDirty=true
      F.publish({type="report_ack",admin=P.username,target=rp.reporter,chan="staff"})F.openAdmin()end)end
  F.section(scr,T("sec_feedback").." ("..tostring(#(S.feedbacks or{}))..")")
  for i=#(S.feedbacks or{}),max(1,#(S.feedbacks or{})-15),-1 do
    local fb=S.feedbacks[i]
    if type(fb)=="table"and fb.id then
      local c=F.card(scr,0);c.AutomaticSize=asY;c.Size=u2(1,0,0,0);pad(c,8,6,8,6);list(c,4)
      local isBug=(fb.kind=="bug")
      lab(c,(isBug and"🐛 "or"💡 ").."#"..tostring(fb.id).." · @"..F.disp(fb.author).." ("..tostring(fb.category or"")..")"..(fb.seen and" [✓]"or""),{bold=true,ts=11,key=isBug and"danger"or"ok",trunc=true})
      lab(c,(fb.title and fb.title~=""and("["..fb.title.."] ")or"")..tostring(fb.content or""),{wrap=true,auto=true,ts=11})
      local repBox=field(c,"","",false)
      repBox.PlaceholderText=L=="en"and"Write reply or click Thanks..."or"Nhập phản hồi hoặc bấm Cảm ơn..."
      local rr=row(c,26)
      local bSeen=rbtn(rr,"👀 "..T("fb_st_seen"),{size=u2(0.32,-2,1,0),ts=10,key=fb.seen and"ok"or"btnBg"})
      local bThx=rbtn(rr,"💖 "..(L=="en"and"Thanks"or"Cảm ơn"),{size=u2(0.32,-2,1,0),ts=10,key="ok"})
      local bRep=rbtn(rr,"💬 "..T("reply"),{size=u2(0.36,-2,1,0),ts=10,key="accent"})
      local function sendAct(act,txt)
        enqueue("other","POST","/api/feedback",{action=act,id=fb.id,by=P.username,replyText=txt},function(d)
          fb.seen=true
          if d and d.ok then F.toast(T("saved_ok"),true);F.openAdmin()end
        end)
      end
      hook(bSeen.MouseButton1Click,function()sendAct("seen","")end)
      hook(bThx.MouseButton1Click,function()sendAct("thanks",H.trim(repBox.Text))end)
      hook(bRep.MouseButton1Click,function()
        local txt=H.trim(repBox.Text)
        sendAct(txt~=""and"reply"or"thanks",txt)
      end)
    end
  end end
-- Bảng màu mẫu, biểu tượng mẫu và các mẫu Role (Templates) tạo nhanh cho Developer
F.ROLE_COLORS={"#F04747","#E67E22","#F1C40F","#2ECC71","#1ABC9C","#3498DB","#5865F2","#9B59B6","#E91E63","#95A5A6","#FFFFFF","#FAA81A"}F.ROLE_ICONS={"👑","🌟","🔰","🔧","💎","🔥","🏆","🚀","🎮","💬","💖","💯"}F.ROLE_TEMPLATES={
  {name="Owner",color="#F1C40F",icon="👑",isAdmin=true,mentionAll=true,canAnnounce=true},{name="Admin",color="#E74C3C",icon="🔰",isAdmin=true,mentionAll=true,canAnnounce=true},
  {name="Mod",color="#3498DB",icon="🔧",isAdmin=true,mentionAll=false,canAnnounce=true},{name="Tester",color="#1ABC9C",icon="💎",isAdmin=false,mentionAll=false,canAnnounce=true},
  {name="VIP",color="#9B59B6",icon="💎",isAdmin=false,mentionAll=false,canAnnounce=false},{name="Member",color="#2ECC71",icon="",isAdmin=false,mentionAll=false,canAnnounce=false},}
--- [F.sortedRoles] Lấy danh sách tất cả các Role đã sắp xếp giảm dần theo cấp bậc (`position`)
function F.sortedRoles()local l={}
  for _,r in ipairs(S.roles)do l[#l+1]=r end tsort(l,function(a,b)if a.position~=b.position then return a.position>b.position end return a.id<b.id end)return l end
--- [F.roleMembers] Đếm số lượng thành viên đang sở hữu Role `r`
function F.roleMembers(r)local n=0
  for _,set in pairs(S.assign)do if set[r.id]then n=n+1 end end return n end
--- [F.moveRole] Thay đổi vị trí ưu tiên (lên/xuống) của một Role trong danh sách và đồng bộ lên máy chủ
function F.moveRole(r,dir)local l=F.sortedRoles()local idx for i,x in ipairs(l)do if x==r then idx=i end end
  local j=idx and idx+dir
  if not j or j<1 or j>#l then return end l[idx],l[j]=l[j],l[idx]for i,x in ipairs(l)do x.position=(#l-i+1)*10 end
  F.invalidateRoleCache()S.isDirty=true;F.queueRoles()end
--- [F.openRoles] Mở hộp thoại quản lý danh sách Role (tạo mới, tạo từ mẫu, đổi thứ tự, gán Role cho thành viên)
function F.openRoles(keep)
  if not F.isDev(P.username)then F.toast(T("no_perm"),true);return end
  local scr=F.modalBox(T("roles"),400,580)local r1=row(scr,32)
  local nb=rbtn(r1,"+ "..T("role_new"),{key="accent"});hook(nb.MouseButton1Click,function()F.openRoleEditor(nil)end)local tb2=rbtn(r1,T("role_tpl"));hook(tb2.MouseButton1Click,function()
    local ps,close=F.popup(T("role_tpl"),300,340)for i,t in ipairs(F.ROLE_TEMPLATES)do local b=tbtn(ps,"",{h=36})F.roleChip(b,t,0,true).Position=uo(8,8)hook(b.MouseButton1Click,function()
        for _,x in ipairs(S.roles)do if x.name:lower()==t.name:lower()then F.toast(T("role_saved"),true);close();return end end
        S.roles[#S.roles+1]={id=H.uuid():sub(1,8),name=t.name,color=t.color,icon=t.icon,position=F.nextPosition(),isAdmin=t.isAdmin,mentionAll=t.mentionAll,canAnnounce=t.canAnnounce==true}
        S.isDirty=true;F.queueRoles();close();F.openRoles()end)end end)local ab=tbtn(scr,T("assign_user"),{h=30})
  hook(ab.MouseButton1Click,function()F.pickUser({title=T("assign_user"),assigned=true,onPick=function(u)F.openUserRoles(u)end})end)local ub=F.userField(scr,T("role_quick_assign"),"")
  local ab2=tbtn(scr,T("role_assign_btn"),{key="accent",h=28,ts=11})hook(ab2.MouseButton1Click,function()local u=H.trim(ub.Text):gsub("^@","")if u==""then return end F.openUserRoles(u)end)F.section(scr,T("roles"))
  local l=F.sortedRoles()if#l==0 then lab(scr,T("no_roles"),{wrap=true,auto=true,key="muted"})end for i,r in ipairs(l)do local card=F.card(scr,50);card.LayoutOrder=i+10
    local bar=mk("Frame",{Size=u2(0,4,1,-12),Position=uo(6,6),BackgroundColor3=H.hex(r.color),BorderSizePixel=0},card)corner(bar,2)local tap=mk("TextButton",{Size=u2(1,-64,1,0),BackgroundTransparency=1,Text=""},card)
    hook(tap.MouseButton1Click,function()F.openRoleEditor(r)end)local ic=F.iconBox(card,r.icon~=""and r.icon or"•",24);ic.Position=uo(18,13)
    lab(card,F.disp(r.name),{size=u2(1,-120,0,18),pos=uo(50,6),bold=true,ts=13,trunc=true}).TextColor3=H.hex(r.color)
    lab(card,r.position.." · "..F.roleMembers(r)..T("member_n")..(r.isAdmin and" · Admin"or"")..(r.mentionAll and" · @all"or""),{size=u2(1,-120,0,14),pos=uo(50,26),ts=10,key="muted",trunc=true})
    local up=tbtn(card,"^",{size=uo(28,20),pos=u2(1,-62,0,4),ts=11,key="bg2",r=5})local dn=tbtn(card,"v",{size=uo(28,20),pos=u2(1,-62,0,26),ts=10,key="bg2",r=5})
    hook(up.MouseButton1Click,function()F.moveRole(r,-1);F.openRoles(scr.CanvasPosition)end)hook(dn.MouseButton1Click,function()F.moveRole(r,1);F.openRoles(scr.CanvasPosition)end)
    local mb=tbtn(card,"👥",{size=uo(28,42),pos=u2(1,-32,0,4),ts=13,key="bg2",r=6})hook(mb.MouseButton1Click,function()F.openMembers(r)end)end
  if keep then task.defer(function()if scr.Parent then scr.CanvasPosition=keep end end)end end
--- [F.openMembers] Mở hộp thoại quản lý danh sách thành viên đang thuộc một Role cụ thể
function F.openMembers(r)F.pickUser({title=F.disp(r.name).." · "..T("members"),multi=true,assigned=true,
    isOn=function(u)return F.hasRole(u,r.id)end,onToggle=function(u,on)F.setRole(u,r.id,on)S.isDirty=true;F.queueRoles()end,})end
--- [F.openUserRoles] Mở hộp thoại bật/tắt từng Role cho một người dùng cụ thể `u`
function F.openUserRoles(u)local scr=F.popup(F.disp(u).." · "..T("roles"),320,400)
  local l=F.sortedRoles()if#l==0 then lab(scr,T("no_roles"),{wrap=true,auto=true,key="muted"})end for i,r in ipairs(l)do local b=mk("TextButton",{Size=u2(1,0,0,36),Text="",BorderSizePixel=0,LayoutOrder=i},scr)
    th(b,"BackgroundColor3","cardBg");corner(b,8);stroke(b,"border",1,0.5)F.roleChip(b,r,0,true).Position=uo(8,8)local ck=lab(b,"",{size=uo(28,36),pos=u2(1,-34,0,0),bold=true,ts=16,align=txC,key="ok"})
    local function paint()ck.Text=F.hasRole(u,r.id)and"[x]"or""end paint()hook(b.MouseButton1Click,function()F.setRole(u,r.id,not F.hasRole(u,r.id))S.isDirty=true;paint();F.queueRoles()end)end end
--- [F.openRoleEditor] Mở hộp thoại chỉnh sửa chi tiết hoặc tạo mới một Role (tên, màu sắc, biểu tượng, cấp bậc và các quyền hạn)
function F.openRoleEditor(role)local isNew=role==nil
  local d=role and{name=role.name,color=role.color,icon=role.icon or"",position=role.position,isAdmin=role.isAdmin,mentionAll=role.mentionAll,canAnnounce=role.canAnnounce==true}
  or{name="",color="#5865F2",icon="",position=F.nextPosition(),isAdmin=false,mentionAll=false,canAnnounce=false}local scr=F.modalBox(isNew and T("role_new")or T("role_edit"),400,620)local pv=F.card(scr,40)
  local pvRow=mk("Frame",{Size=u2(1,-16,1,0),Position=uo(8,0),BackgroundTransparency=1},pv)mk("UIListLayout",{FillDirection=fdH,Padding=u1(0,6),SortOrder=soLO,VerticalAlignment=vaC},pvRow)
  local function refreshPv()
    for _,c in ipairs(pvRow:GetChildren())do if not c:IsA("UIListLayout")then c:Destroy()end end
    mk("TextLabel",{AutomaticSize=asX,Size=uo(0,20),BackgroundTransparency=1,Text="Alice",Font=fGB,TextSize=13,TextColor3=H.hex(d.color),LayoutOrder=1,BorderSizePixel=0},pvRow)
    F.roleChip(pvRow,{name=d.name~=""and d.name or"Role",color=d.color,icon=d.icon},2,true)end refreshPv()local nameBox=field(scr,T("role_name"),d.name)
  hook(nameBox:GetPropertyChangedSignal("Text"),function()d.name=H.clip(nameBox.Text,24);refreshPv()end)lab(scr,T("role_color"),{h=14,ts=10,bold=true,key="muted"})
  local pal=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BackgroundTransparency=1},scr)mk("UIGridLayout",{CellSize=uo(30,30),CellPadding=uo(5,5),SortOrder=soLO},pal)local pk for i,hx in ipairs(F.ROLE_COLORS)do
    local b=mk("TextButton",{Text="",BackgroundColor3=H.hex(hx),BorderSizePixel=0,LayoutOrder=i},pal)corner(b,15);stroke(b,"muted",1,0.7)
    hook(b.MouseButton1Click,function()d.color=hx;refreshPv();if pk then pk.set(hx)end end)end
  local holder=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BackgroundTransparency=1,Visible=false},scr)
  local tgl=tbtn(scr,T("color_palette"),{h=28,ts=11})hook(tgl.MouseButton1Click,function()if not pk then pk=F.colorPicker(holder,d.color,function(hex)d.color=hex;refreshPv()end)end holder.Visible=not holder.Visible
  end)tgl.LayoutOrder=0;pal.LayoutOrder=0 lab(scr,T("role_icon"),{h=14,ts=10,bold=true,key="muted"})local ig=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BackgroundTransparency=1},scr)
  mk("UIGridLayout",{CellSize=uo(34,34),CellPadding=uo(4,4),SortOrder=soLO},ig)for i,e in ipairs(F.ROLE_ICONS)do local b=tbtn(ig,e,{ts=16,r=7,layout=i})hook(b.MouseButton1Click,function()d.icon=e;refreshPv()end)end
  local ir=row(scr,30)
  local pb=rbtn(ir,T("emoji_pick").."…",{size=u2(0.36,-3,1,0),key="accent",ts=10})
  hook(pb.MouseButton1Click,function()F.openEmoji({title=T("role_icon"),onPick=function(e)d.icon=e;refreshPv()end})end)
  local sb=rbtn(ir,"Store",{size=u2(0.36,-3,1,0),key="accent",ts=10})
  pad(sb,20,0,6,0)
  local sbIc=F.lucide(sb,"store",12,{pos=u2(0,-11,0.5,0),anc=v2(0,0.5),col=H.lum(TH.accent)>0.55 and rgb(20,20,24)or c3(1,1,1),themed=false,z=5})
  themed(sbIc,function(ic)ic.ImageColor3=H.lum(TH.accent)>0.55 and rgb(20,20,24)or c3(1,1,1)end)
  hook(sb.MouseButton1Click,function()F.openImageFinder(T("role_icon"),"icon",function(pickedId)d.icon="img:"..pickedId;refreshPv()end)end)
  local cb=rbtn(ir,T("role_icon_clear"),{size=u2(0.28,-3,1,0),key="btnBg",ts=10})
  hook(cb.MouseButton1Click,function()d.icon="";refreshPv()end)lab(scr,T("role_pos"),{h=14,ts=10,bold=true,key="muted"})local pr=row(scr,30)
  local pl=lab(pr,tostring(d.position),{size=u2(1,-150,1,0),bold=true,ts=14,align=txC})
  local function stepB(txt,dv,order)local b=tbtn(pr,txt,{size=uo(34,28),layout=order,r=7})
    hook(b.MouseButton1Click,function()d.position=clamp(d.position+dv,-1000,1000);pl.Text=tostring(d.position)end)end pl.LayoutOrder=3 stepB("-10",-10,1);stepB("-",-1,2);stepB("+",1,4);stepB("+10",10,5)
  F.section(scr,T("role_perm"))F.switch(scr,T("role_admin"),function()return d.isAdmin end,function(v)d.isAdmin=v end)F.switch(scr,T("role_mention"),function()return d.mentionAll end,function(v)d.mentionAll=v end)
  F.switch(scr,T("role_announce"),function()return d.canAnnounce end,function(v)d.canAnnounce=v end)local save=tbtn(scr,T("save"),{key="ok",h=34})hook(save.MouseButton1Click,function()local nm=H.trim(d.name)
    if nm==""then F.toast(T("role_name_req"),true);return end if isNew then role={id=H.uuid():sub(1,8)};S.roles[#S.roles+1]=role end
    role.name,role.color,role.icon,role.position,role.isAdmin,role.mentionAll,role.canAnnounce=nm,H.safeHex(d.color),d.icon,d.position,d.isAdmin,d.mentionAll,d.canAnnounce==true F.invalidateRoleCache()S.isDirty=true F.publishRoles()F.openRoles()end)if not isNew then
    local mb=tbtn(scr,"👥 "..T("members").." ("..F.roleMembers(role)..")",{h=30})hook(mb.MouseButton1Click,function()F.openMembers(role)end)local del=tbtn(scr,T("delete"),{key="danger",h=30})local armed=false
    hook(del.MouseButton1Click,function()if not armed then armed=true;del.Text=T("tap_again_del")task.delay(3,function()if del.Parent then armed=false;del.Text=T("delete")end end)return end
      for i,x in ipairs(S.roles)do if x==role then tremove(S.roles,i)break end end for u,set in pairs(S.assign)do set[role.id]=nil;if not next(set)then S.assign[u]=nil end end
      F.invalidateRoleCache();S.isDirty=true;F.publishRoles();F.openRoles()end)
  end end

-- =============================================================================
-- 20. TÙY CHỈNH CHỦ ĐỀ (THEME STUDIO), XIN CẤP ROLE, CÀI ĐẶT & CHẨN ĐOÁN
-- =============================================================================
--- [F.autoContrast] Tự động cân chỉnh lại màu chữ chính và chữ phụ để đảm bảo độ tương phản tốt trên nền Theme hiện tại
function F.autoContrast()local bgc=TH.bg if H.contrast(TH.text,bgc)<4.5 then P.custom.text=H.lum(bgc)<0.4 and"#F2F3F5"or"#111214"end
  F.computeTheme()
  if H.contrast(TH.muted,bgc)<3 then P.custom.muted=H.tohex(H.mix(TH.text,bgc,0.38))end
  F.paintTheme();S.isDirty=true F.toast(T("contrast_done"),true)end
--- [F.harmonizePalette] Tự động sinh bảng màu hài hòa theo lý thuyết vòng tròn màu HSV kèm kiểm tra tương phản WCAG
function F.harmonizePalette()
  local isDark=H.lum(TH.bg)<0.45
  local hBase=math.random()
  local hAcc=(hBase+0.08+math.random()*0.22)%1
  local hSec=(hAcc+0.33)%1
  local bgCol=isDark and Color3.fromHSV(hBase,0.38,0.11)or Color3.fromHSV(hBase,0.08,0.96)
  local bg2Col=isDark and Color3.fromHSV(hBase,0.34,0.15)or Color3.fromHSV(hBase,0.04,1.0)
  local bg3Col=isDark and Color3.fromHSV(hBase,0.32,0.22)or Color3.fromHSV(hBase,0.12,0.91)
  local titleCol=isDark and Color3.fromHSV(hBase,0.42,0.07)or Color3.fromHSV(hBase,0.16,0.86)
  local accCol=Color3.fromHSV(hAcc,isDark and 0.78 or 0.85,isDark and 0.96 or 0.86)
  local g1Col=bgCol
  local g2Col=isDark and Color3.fromHSV(hAcc,0.52,0.22)or Color3.fromHSV(hAcc,0.16,0.93)
  local g3Col=isDark and Color3.fromHSV(hSec,0.48,0.20)or Color3.fromHSV(hSec,0.16,0.94)
  local txtCol=isDark and Color3.fromHSV(hBase,0.06,0.96)or Color3.fromHSV(hBase,0.45,0.14)
  local mutCol=isDark and Color3.fromHSV(hBase,0.18,0.68)or Color3.fromHSV(hBase,0.24,0.45)
  P.custom.bg=H.tohex(bgCol);P.custom.bg2=H.tohex(bg2Col);P.custom.bg3=H.tohex(bg3Col);P.custom.title=H.tohex(titleCol)
  P.custom.accent=H.tohex(accCol);P.custom.text=H.tohex(txtCol);P.custom.muted=H.tohex(mutCol)
  P.custom.own=H.tohex(H.mix(bg2Col,accCol,isDark and 0.25 or 0.18))
  P.custom.g1=H.tohex(g1Col);P.custom.g2=H.tohex(g2Col);P.custom.g3=H.tohex(g3Col)
  if P.backgroundMode=="solid"then P.backgroundMode="gradient"end
  F.autoContrast()
end
--- [F.themeCode] Xuất cấu hình Theme hiện tại thành chuỗi mã chia sẻ (`CBT1:...`)
function F.themeCode()
  local bf=type(P.bgFrame)=="table"and P.bgFrame or{}
  local t={n=P.themeName,a=P.alpha,c={},bm=P.backgroundMode,bi=P.backgroundImage,bo=P.backgroundOpacity,bd=P.backgroundDim,bf=bf.fit or"crop",bz=tonumber(bf.zoom)or 100,bx=tonumber(bf.x)or 0,by=tonumber(bf.y)or 0,ba=bf.aspect or"auto",ga=P.gradAngle,gm=P.gradMix,ur=P.uiRadius,ff=P.fontFamily,ms=P.msgStyle,bglow=P.borderGlow}
  for k,v in pairs(P.custom)do t.c[k]=v end return"CBT1:"..H.jenc(t)
end
--- [F.importTheme] Nhập và áp dụng cấu hình Theme từ chuỗi mã chia sẻ (`CBT1:...`)
function F.importTheme(code)
  local j=H.trim(code):match("^CBT[12]:(.+)$")local d=j and H.jdec(j)if type(d)~="table"then return false end
  if THEMES[d.n]then P.themeName=d.n end
  P.custom={}
  for k,v in pairs(type(d.c)=="table"and d.c or{})do
    if(THEMES.dark[k]or k=="mentionText"or k=="emojiText"or k=="g1"or k=="g2"or k=="g3")and tostring(v):match("^#%x%x%x%x%x%x$")then P.custom[k]=v end
  end
  P.alpha=clamp(tonumber(d.a)or 0,0,0.85)
  local validModes={solid=true,gradient=true,mesh=true,glass=true,image=true}
  P.backgroundMode=validModes[d.bm]and d.bm or"solid"
  P.backgroundImage=H.assetId(d.bi or"")or""
  P.backgroundOpacity=clamp(tonumber(d.bo)or 0.82,0.15,1)
  P.backgroundDim=clamp(tonumber(d.bd)or 0.25,0,0.75)
  P.bgFrame={
    fit=(d.bf=="fit"or d.bf=="stretch"or d.bf=="tile")and d.bf or"crop",
    zoom=clamp(tonumber(d.bz)or 100,100,300),
    x=clamp(tonumber(d.bx)or 0,-100,100),
    y=clamp(tonumber(d.by)or 0,-100,100),
    aspect=(F._ASPECT and F._ASPECT[d.ba or""])and d.ba or"auto",
  }
  if d.ga~=nil then P.gradAngle=clamp(tonumber(d.ga)or 28,0,360)end
  if d.gm~=nil then P.gradMix=clamp(tonumber(d.gm)or 0.65,0.15,1)end
  if d.ur~=nil then P.uiRadius=clamp(tonumber(d.ur)or 10,3,16)end
  if d.ff and FONT_MAP[d.ff]then P.fontFamily=d.ff end
  if d.ms=="card"or d.ms=="flat"or d.ms=="minimal"then P.msgStyle=d.ms end
  if d.bglow~=nil then P.borderGlow=d.bglow==true end
  if P.backgroundMode=="image"and P.backgroundImage==""then P.backgroundMode="solid"end
  F.paintTheme();if S.booted and F.rebuildFeed then pcall(F.rebuildFeed,true)end S.isDirty=true return true
end
--- Namespace nội bộ Theme Studio: tái sử dụng Preview đóng khung, Wallpaper Framing Studio (Store/Crop/HD) & Đồng bộ Profile <-> App
F._THEME={}
function F._THEME.buildPreview(scr,onPickCrop)
  local pv=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BorderSizePixel=0,ClipsDescendants=true},scr)
  corner(pv,P.uiRadius or 10);stroke(pv,"border",1.2,0.3)
  local pvWpHost=F.createClipHost(pv,{Size=us(1,1),BackgroundTransparency=1,BorderSizePixel=0,ClipsDescendants=true,ZIndex=1,Visible=false})
  local pvWp=mk("ImageLabel",{Size=us(1,1),AnchorPoint=v2(0.5,0.5),Position=us(0.5,0.5),BackgroundTransparency=1,BorderSizePixel=0,ZIndex=1},pvWpHost)
  local pvTint=mk("Frame",{Size=us(1,1),BorderSizePixel=0,ZIndex=1,Visible=false},pv)
  local pvBody=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BackgroundTransparency=1,ZIndex=2},pv)
  pad(pvBody,8,8,8,8);list(pvBody,4)
  local pvGrad=mk("UIGradient",{Rotation=P.gradAngle or 28},pv)
  local pvFrameBtn=mk("TextButton",{Size=uo(62,20),Position=u2(1,-6,0,6),AnchorPoint=v2(1,0),Text="  Frame",Font=fGB,TextSize=9,BorderSizePixel=0,AutoButtonColor=true,Visible=false,ZIndex=6},pv)
  th(pvFrameBtn,"BackgroundColor3","title");th(pvFrameBtn,"TextColor3","text");corner(pvFrameBtn,6);stroke(pvFrameBtn,"accent",1,0.35)
  F.lucide(pvFrameBtn,"crop",10,{pos=uo(6,5),key="accent",z=7})
  hook(pvFrameBtn.MouseButton1Click,function()if onPickCrop then onPickCrop()end end)
  local function updPv()
    local m=P.backgroundMode or"solid"
    local imgId=H.assetId(P.backgroundImage or"")
    local showImg=(m=="image"and imgId~=nil)
    pvWpHost.Visible=showImg
    pvFrameBtn.Visible=showImg
    pvTint.Visible=showImg and(tonumber(P.backgroundDim)or 0)>0
    if showImg then
      local wpTr=1-clamp(tonumber(P.backgroundOpacity)or 0.82,0.15,1)
      pvWp.ImageTransparency=wpTr
      pvTint.BackgroundColor3=TH.bg
      pvTint.BackgroundTransparency=1-clamp(tonumber(P.backgroundDim)or 0.25,0,0.75)
      if pv._lastImg~=imgId then
        pv._lastImg=imgId
        F.setAsset(pvWp,imgId,function()
          if pvWp and pvWp.Parent then
            pvWp.ImageTransparency=wpTr
            F.applyImageFrame(pvWpHost,pvWp,P.bgFrame,380,145)
          end
        end,wpTr)
      end
      F.applyImageFrame(pvWpHost,pvWp,P.bgFrame,380,145)
    end
    if m=="gradient"or m=="mesh"or m=="glass"then
      pv.BackgroundColor3=c3(1,1,1)
      pvGrad.Enabled=true
      pvGrad.Rotation=tonumber(P.gradAngle)or 28
      pvGrad.Color=ColorSequence.new({
        ColorSequenceKeypoint.new(0,TH.g1),
        ColorSequenceKeypoint.new(0.52,TH.g2),
        ColorSequenceKeypoint.new(1,TH.g3),
      })
    else
      pv.BackgroundColor3=TH.bg
      pvGrad.Enabled=false
    end
  end
  themed(pv,updPv)
  local function sample(who,text,key,order)
    local f=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BorderSizePixel=0,LayoutOrder=order,ZIndex=3},pvBody)
    themed(f,function(o)o.BackgroundColor3=TH[key];o.BackgroundTransparency=F.surfaceAlpha("card")end)
    corner(f,max(4,(P.uiRadius or 10)-2));pad(f,8,4,8,4);lab(f,who.."  "..text,{ts=12,wrap=true,auto=true})
  end
  sample("Alice",T("sample_hi"),"cardBg",1)
  sample(T("you"),T("sample_reply"),"own",2)
  sample("Bob","@"..P.username..T("sample_ping"),"mention",3)
  local chipsR=row(pvBody,26,4);chipsR.ZIndex=3
  tbtn(chipsR,"Accent",{size=u2(0.25,-5,1,0),key="accent",ts=11})
  tbtn(chipsR,"OK",{size=u2(0.25,-5,1,0),key="ok",ts=11})
  tbtn(chipsR,"Warn",{size=u2(0.25,-5,1,0),key="warn",ts=11})
  tbtn(chipsR,"Danger",{size=u2(0.25,-5,1,0),key="danger",ts=11})
  return updPv
end
function F._THEME.buildWallpaperCard(scr,onBgChanged)
  local bgCard=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BorderSizePixel=0},scr)
  themed(bgCard,function(o)o.BackgroundColor3=TH.cardBg;o.BackgroundTransparency=F.surfaceAlpha("card")end)
  corner(bgCard,10);stroke(bgCard,"border",1,0.4);pad(bgCard,10,8,10,8);list(bgCard,6)
  local rTop=mk("Frame",{Size=u2(1,0,0,46),BackgroundTransparency=1,LayoutOrder=1},bgCard)
  local thumbHost=F.createClipHost(rTop,{Size=uo(44,44),Position=uo(0,1),BackgroundTransparency=0,BorderSizePixel=0,ClipsDescendants=true})
  th(thumbHost,"BackgroundColor3","inputBg");corner(thumbHost,8);stroke(thumbHost,"border",1,0.45)
  local thumbImg=mk("ImageLabel",{Size=us(1,1),AnchorPoint=v2(0.5,0.5),Position=us(0.5,0.5),BackgroundTransparency=1,ScaleType=Enum.ScaleType.Crop,BorderSizePixel=0,Visible=false},thumbHost)
  local emptyIc=F.lucide(thumbHost,"image",18,{pos=us(0.5,0.5),anc=v2(0.5,0.5),key="muted"})
  lab(rTop,T("bg_image"),{size=u2(1,-58,0,18),pos=uo(52,2),bold=true,ts=11,trunc=true})
  local specLbl=lab(rTop,"CROP · 100% · (0,0)",{size=u2(1,-58,0,16),pos=uo(52,22),ts=10,key="muted",trunc=true})
  local actRow=row(bgCard,28,2)
  local sBtn=rbtn(actRow,L=="en"and"   Store"or"   Kho ảnh",{size=u2(0.34,-4,1,0),key="accent",ts=10,r=6,layout=1})
  F.lucide(sBtn,"store",12,{pos=uo(8,8),col=H.lum(TH.accent)>0.55 and rgb(20,20,24)or c3(1,1,1),themed=false})
  local fBtn=rbtn(actRow,L=="en"and"   Frame"or"   Căn khung",{size=u2(0.36,-4,1,0),key="btnBg",ts=10,r=6,layout=2})
  F.lucide(fBtn,"crop",12,{pos=uo(8,8),key="accent"})
  local hdBtn=rbtn(actRow,"",{size=u2(0.15,-4,1,0),key="btnBg",ts=10,r=6,layout=3})
  F.lucide(hdBtn,"refresh",12,{pos=us(0.5,0.5),anc=v2(0.5,0.5),key="ok"})
  local clearBg=rbtn(actRow,"",{size=u2(0.15,-2,1,0),key="danger",ts=10,r=6,layout=4})
  F.lucide(clearBg,"x",12,{pos=us(0.5,0.5),anc=v2(0.5,0.5),col=c3(1,1,1),themed=false})
  local bgInput=mk("TextBox",{
    Size=u2(1,0,0,26),Text=tostring(P.backgroundImage or""),
    PlaceholderText=T("bg_image_hint"),ClearTextOnFocus=false,Font=fCode,TextSize=11,BorderSizePixel=0,TextXAlignment=txL,LayoutOrder=3
  },bgCard)
  F.styleInput(bgInput,"code",false)
  local reuseRow=row(bgCard,24,4)
  local useBan=rbtn(reuseRow,L=="en"and"   Profile Banner"or"   Banner Hồ sơ",{size=u2(0.38,-3,1,0),key="btnBg",ts=9,r=6,layout=1})
  F.lucide(useBan,"image",11,{pos=uo(6,6),key="accent"})
  local useProfBg=rbtn(reuseRow,L=="en"and"   Profile Card"or"   Nền Hồ sơ",{size=u2(0.36,-3,1,0),key="btnBg",ts=9,r=6,layout=2})
  F.lucide(useProfBg,"layers",11,{pos=uo(6,6),key="accent"})
  local applyBg=rbtn(reuseRow,L=="en"and"   Apply"or"   Áp dụng",{size=u2(0.26,-2,1,0),key="ok",ts=9,r=6,layout=3})
  F.lucide(applyBg,"check",11,{pos=uo(6,6),col=c3(1,1,1),themed=false})
  local function updBgCard(forceReload)
    local bf=type(P.bgFrame)=="table"and P.bgFrame or{}
    specLbl.Text=string.upper(bf.fit or"crop").." · "..tostring(floor(tonumber(bf.zoom)or 100)).."% · ("..tostring(floor(tonumber(bf.x)or 0))..","..tostring(floor(tonumber(bf.y)or 0))..")"
    local id=H.assetId(bgInput.Text)
    if id and id~=""then
      emptyIc.Visible=false;thumbImg.Visible=true
      if forceReload or thumbImg:GetAttribute("Aid")~=id then
        thumbImg:SetAttribute("Aid",id)
        F.setAsset(thumbImg,id,function()
          if thumbImg and thumbImg.Parent then F.applyImageFrame(thumbHost,thumbImg,P.bgFrame,44,44)end
        end,0,{force=forceReload==true})
      end
      F.applyImageFrame(thumbHost,thumbImg,P.bgFrame,44,44)
    else
      thumbImg.Image="";thumbImg:SetAttribute("Aid","");thumbImg.Visible=false;emptyIc.Visible=true
    end
  end
  updBgCard(false)
  hook(bgInput:GetPropertyChangedSignal("Text"),function()updBgCard(false)end)
  local function commitImg(id,frameCfg)
    P.backgroundImage=id;P.backgroundMode="image";bgInput.Text=id
    if type(frameCfg)=="table"then P.bgFrame=frameCfg end
    updBgCard(false);F.paintTheme();S.isDirty=true;F.save(true)
    if onBgChanged then onBgChanged()end
    F.toast(T("bg_applied"),true)
  end
  hook(bgInput.FocusLost,function(enter)if enter then local id=H.assetId(bgInput.Text);if id then commitImg(id)end end end)
  hook(sBtn.MouseButton1Click,function()
    F.openImageFinder(T("bg_image"),"theme",function(pickedId)commitImg(tostring(pickedId))end)
  end)
  local function openCrop()
    local curId=H.assetId(bgInput.Text)or H.assetId(P.backgroundImage or"")
    F.openImageCropStudio({target="wallpaper",assetId=curId or"",cfg=P.bgFrame,title=L=="en"and"Wallpaper Crop & Framing Studio"or"Căn Khung Ảnh Nền (Wallpaper Studio)",
      onLiveChange=function(st)
        P.backgroundImage=st.id;P.bgFrame={fit=st.fit,zoom=st.zoom,x=st.x,y=st.y,aspect=st.aspect}
        if st.id~=""then P.backgroundMode="image"end
        updBgCard(false);F.applyMainWallpaper(false);if onBgChanged then onBgChanged()end
      end,
      onApply=function(st)
        P.backgroundImage=st.id;P.bgFrame={fit=st.fit,zoom=st.zoom,x=st.x,y=st.y,aspect=st.aspect}
        if st.id~=""then bgInput.Text=st.id;P.backgroundMode="image"end
        updBgCard(false);F.paintTheme();S.isDirty=true;F.save(true);if onBgChanged then onBgChanged()end;F.toast(T("theme_ok"),true)
      end,
      onCancel=function()updBgCard(false);F.paintTheme();if onBgChanged then onBgChanged()end end})
  end
  hook(fBtn.MouseButton1Click,openCrop)
  hook(hdBtn.MouseButton1Click,function()
    local id=H.assetId(bgInput.Text)
    if not id then F.toast(T("bg_invalid"),true);return end
    S.assetUrl[id]=nil;if S.textureMap then S.textureMap[id]=nil end
    updBgCard(true);F.applyMainWallpaper(true);F.toast(L=="en"and"Refreshing HD asset..."or"Đang tải lại ảnh HD gốc...",true)
  end)
  hook(applyBg.MouseButton1Click,function()
    local id=H.assetId(bgInput.Text)
    if not id then F.toast(T("bg_invalid"),true);return end
    commitImg(id)
  end)
  hook(clearBg.MouseButton1Click,function()
    P.backgroundImage="";P.backgroundMode="solid";bgInput.Text="";updBgCard(false)
    F.paintTheme();S.isDirty=true;F.save(true);if onBgChanged then onBgChanged()end;F.toast(T("bg_applied"),true)
  end)
  hook(useBan.MouseButton1Click,function()
    local id=H.assetId(P.profBanner or"")
    if not id then F.toast(L=="en"and"No Profile Banner set yet"or"Hồ sơ chưa có ảnh bìa!",true);return end
    local pt=type(P.profTheme)=="table"and P.profTheme or{}
    commitImg(id,{fit=pt.bf or"crop",zoom=tonumber(pt.bz)or 100,x=tonumber(pt.bx)or 0,y=tonumber(pt.by)or 0,aspect=pt.ba or"auto"})
  end)
  hook(useProfBg.MouseButton1Click,function()
    local pt=type(P.profTheme)=="table"and P.profTheme or{}
    local id=H.assetId(pt.bgImg or"")
    if not id then F.toast(L=="en"and"No Profile Card Wallpaper set yet"or"Hồ sơ chưa có ảnh nền thẻ!",true);return end
    if pt.bgOp then P.backgroundOpacity=clamp((tonumber(pt.bgOp)or 82)/100,0.15,1)end
    if pt.bgDim then P.backgroundDim=clamp((tonumber(pt.bgDim)or 25)/100,0,0.75)end
    commitImg(id,{fit=pt.wf or"crop",zoom=tonumber(pt.wz)or 100,x=tonumber(pt.wx)or 0,y=tonumber(pt.wy)or 0,aspect=pt.wa or"auto"})
  end)
  return{bgInput=bgInput,update=updBgCard,openCrop=openCrop}
end
--- [F.openTheme] Mở hộp thoại tùy chỉnh Giao diện & Màu sắc (Theme Studio v46) kèm Chuyển sắc 3 điểm (Chroma), Mesh, Kính mờ & Wallpaper Framing
function F.openTheme()
  S.reopenModal=F.openTheme
  local scr=F.modalBox(T("theme"),420,660)
  local bgCtrl,updPv,refreshRows
  local function saveThemeAll(closeAfter)
    if bgCtrl and bgCtrl.bgInput then
      local rawBg=H.trim(bgCtrl.bgInput.Text)
      if rawBg~=""then
        local id=H.assetId(rawBg)
        if id then
          P.backgroundImage=id
          P.backgroundMode="image"
          bgCtrl.bgInput.Text=id
          if bgCtrl.update then bgCtrl.update(false)end
        end
      elseif P.backgroundMode=="image"and P.backgroundImage==""then
        P.backgroundMode="solid"
      end
    end
    F.paintTheme()
    if S.booted and F.rebuildFeed then pcall(F.rebuildFeed,true)end
    S.isDirty=true
    F.save(true)
    F.toast(T("saved_ok"),true)
    if closeAfter then F.closeModal()end
  end

  local topHdr=row(scr,28)
  lab(topHdr,string.upper(T("theme_preview")),{size=u2(0.52,-4,1,0),ts=10,bold=true,key="muted"})
  local topSaveBtn=rbtn(topHdr,"   "..(L=="en"and"Save Theme"or"Lưu Giao Diện"),{size=u2(0.48,-4,1,0),key="ok",ts=11,r=7})
  F.lucide(topSaveBtn,"save",12,{pos=uo(10,8),col=c3(1,1,1),themed=false})
  hook(topSaveBtn.MouseButton1Click,function()saveThemeAll(false)end)

  updPv=F._THEME.buildPreview(scr,function()if bgCtrl and bgCtrl.openCrop then bgCtrl.openCrop()end end)

  -- 1. Chế độ nền (5 chế độ: Màu phẳng, Chuyển sắc Chroma, Đa tầng Mesh, Kính mờ Glass, Ảnh nền)
  F.section(scr,T("bg_mode"))
  local bgModes1=row(scr,28)
  local bgModes2=row(scr,28)
  local function makeModeBtn(parentRow,wScale,mode,labelKey)
    local b=tbtn(parentRow,T(labelKey),{size=u2(wScale,-4,1,0),ts=10,r=7})
    local st=mk("UIStroke",{Thickness=1.3,Transparency=0.2,ApplyStrokeMode=smBorder},b)
    themed(b,function(button)
      local active=(P.backgroundMode==mode)
      button.BackgroundColor3=active and TH.accent or TH.btnBg
      button.TextColor3=active and(H.lum(TH.accent)>0.42 and rgb(20,20,24)or c3(1,1,1))or H.ensureContrast(TH.text,TH.btnBg,4.8)
      st.Color=active and TH.accent or TH.border
    end)
    hook(b.MouseButton1Click,function()
      P.backgroundMode=mode;F.paintTheme();if updPv then updPv()end;S.isDirty=true;F.save(true)
    end)
  end
  makeModeBtn(bgModes1,1/3,"solid","bg_solid")
  makeModeBtn(bgModes1,1/3,"gradient","bg_gradient")
  makeModeBtn(bgModes1,1/3,"mesh","bg_mesh")
  makeModeBtn(bgModes2,0.5,"glass","bg_glass")
  makeModeBtn(bgModes2,0.5,"image","bg_image")

  -- Thanh chỉnh Góc nghiêng & Cường độ Chuyển sắc + 3 Điểm màu Gradient (Stop 1, Stop 2, Stop 3)
  F.section(scr,T("grad_custom"))
  local gStopRow=row(scr,32)
  local gradHolder=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BackgroundTransparency=1,Visible=false},scr)
  local gradPk,activeGradKey
  local gStopBtns={}
  for idx,gk in ipairs({"g1","g2","g3"})do
    local gb=mk("TextButton",{Size=u2(1/3,-4,1,0),Text="",BorderSizePixel=0,LayoutOrder=idx,AutoButtonColor=true},gStopRow)
    th(gb,"BackgroundColor3","cardBg");corner(gb,8);stroke(gb,"border",1,0.4)
    local sw=mk("Frame",{Size=uo(18,18),Position=uo(6,7),BorderSizePixel=0},gb)corner(sw,5);stroke(sw,"muted",1,0.4)
    local lbl=lab(gb,"Stop #"..idx,{size=u2(1,-30,1,0),pos=uo(28,0),ts=10,bold=true,trunc=true})
    themed(gb,function()
      sw.BackgroundColor3=TH[gk]or TH.bg
      lbl.Text="Stop #"..idx.." "..H.tohex(TH[gk]or TH.bg)
    end)
    gStopBtns[gk]={sw=sw,lbl=lbl}
    hook(gb.MouseButton1Click,function()
      if activeGradKey==gk and gradHolder.Visible then
        gradHolder.Visible=false;activeGradKey=nil;return
      end
      activeGradKey=gk
      for _,c in ipairs(gradHolder:GetChildren())do c:Destroy()end
      gradHolder.Visible=true
      gradPk=F.colorPicker(gradHolder,H.tohex(TH[gk]or TH.bg),function(hex)
        P.custom[gk]=hex
        if P.backgroundMode=="solid"then P.backgroundMode="gradient"end
        F.paintTheme();S.isDirty=true
      end)
    end)
  end
  F.slider(scr,T("grad_angle"),0,360,floor(tonumber(P.gradAngle)or 28),{step=5,fmt=function(v)return v.."°"end,
    onChange=function(v)P.gradAngle=v;F.paintTheme()end,onDone=function()S.isDirty=true end})
  F.slider(scr,T("grad_mix"),15,100,floor((tonumber(P.gradMix)or 0.65)*100+0.5),{step=1,fmt=function(v)return v.."%"end,
    onChange=function(v)P.gradMix=v/100;F.paintTheme()end,onDone=function()S.isDirty=true end})

  bgCtrl=F._THEME.buildWallpaperCard(scr,function()if updPv then updPv()end end)
  F.slider(scr,T("bg_opacity"),15,100,floor(P.backgroundOpacity*100+0.5),{step=1,fmt=function(v)return v.."%"end,
    onChange=function(v)P.backgroundOpacity=v/100;F.paintTheme()end,onDone=function()S.isDirty=true end})
  F.slider(scr,T("bg_dim"),0,75,floor(P.backgroundDim*100+0.5),{step=1,fmt=function(v)return v.."%"end,
    onChange=function(v)P.backgroundDim=v/100;F.paintTheme()end,onDone=function()S.isDirty=true end})

  -- 2. Bộ sưu tập 30 Mẫu Giao diện (Presets) có bộ lọc Danh mục (Tất cả / Chuyển sắc / Tối / Sáng)
  F.section(scr,T("preset").." (30)")
  local catRow=row(scr,26)
  local pg=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BackgroundTransparency=1},scr)
  local selStrokes,rows={},{}
  local function paintSel()for n,s in pairs(selStrokes)do s.Transparency=(n==P.themeName)and 0 or 1 end end
  refreshRows=function()
    F.computeTheme()
    for k,r in pairs(rows)do
      if r.sw and r.sw.Parent then
        r.sw.BackgroundColor3=TH[k]
        r.hx.Text=H.tohex(TH[k])
        r.reset.Visible=P.custom[k]~=nil
      end
    end
  end
  local function buildPresetGrid()
    for _,c in ipairs(pg:GetChildren())do c:Destroy()end
    selStrokes={}
    mk("UIGridLayout",{CellSize=u2(1/3,-4,0,48),CellPadding=uo(5,5),SortOrder=soLO},pg)
    local curCat=S.themeCatFilter or"all"
    for i,name in ipairs(THEME_ORDER)do
      local t=THEMES[name]
      local tCat=t.cat or(H.lum(H.hex(t.bg))<0.45 and"dark"or"light")
      if curCat=="all"or curCat==tCat or(curCat=="dark"and tCat=="chroma"and H.lum(H.hex(t.bg))<0.45)then
        local b=mk("TextButton",{Text="",BackgroundColor3=c3(1,1,1),BorderSizePixel=0,LayoutOrder=i,AutoButtonColor=true,ClipsDescendants=true},pg)corner(b,8)
        local bGrad=mk("UIGradient",{Rotation=t.gRot or 28,Color=ColorSequence.new({
          ColorSequenceKeypoint.new(0,H.hex(t.g1 or t.bg)),
          ColorSequenceKeypoint.new(0.55,H.hex(t.g2 or t.bg2)),
          ColorSequenceKeypoint.new(1,H.hex(t.g3 or t.bg3)),
        })},b)
        local s=mk("UIStroke",{Color=H.hex(t.accent),Thickness=2,Transparency=1,ApplyStrokeMode=smBorder},b)selStrokes[name]=s
        for j,k in ipairs({"bg","accent","text"})do
          local sq=mk("Frame",{Size=uo(12,12),Position=uo(6+(j-1)*15,6),BackgroundColor3=H.hex(t[k]),BorderSizePixel=0},b)corner(sq,6)
          mk("UIStroke",{Color=H.hex(t.bg3),Thickness=1,Transparency=0.4},sq)
        end
        if t.cat=="chroma"then
          local tag=mk("TextLabel",{Size=uo(36,13),Position=u2(1,-40,0,5),BackgroundColor3=H.hex(t.accent),Text="CHROMA",Font=fGB,TextSize=7,TextColor3=H.lum(H.hex(t.accent))>0.55 and rgb(18,18,22)or c3(1,1,1),BorderSizePixel=0},b)
          corner(tag,4)
        end
        local dispName=name:gsub("_"," ")
        mk("TextLabel",{Size=u2(1,-10,0,18),Position=uo(6,25),BackgroundTransparency=1,Text=dispName,Font=fGB,TextSize=10,TextColor3=H.hex(t.text),TextXAlignment=txL,TextTruncate=trEnd,BorderSizePixel=0},b)
        hook(b.MouseButton1Click,function()
          P.themeName=name;P.custom={}
          if t.cat=="chroma"and P.backgroundMode=="solid"then P.backgroundMode="gradient"end
          if t.gRot then P.gradAngle=t.gRot end
          F.paintTheme();S.isDirty=true;paintSel();refreshRows()
        end)
      end
    end
    paintSel()
  end
  for idx,catDef in ipairs({{"all","cat_all"},{"chroma","cat_chroma"},{"dark","cat_dark"},{"light","cat_light"}})do
    local cid,ckey=catDef[1],catDef[2]
    local cb=tbtn(catRow,T(ckey),{size=u2(0.25,-4,1,0),ts=10,r=6,layout=idx})
    themed(cb,function(btn)
      local on=(S.themeCatFilter or"all")==cid
      btn.BackgroundColor3=on and TH.accent or TH.btnBg
      btn.TextColor3=on and(H.lum(TH.accent)>0.55 and rgb(20,20,24)or c3(1,1,1))or TH.text
    end)
    hook(cb.MouseButton1Click,function()S.themeCatFilter=cid;F.paintTheme();buildPresetGrid()end)
  end
  buildPresetGrid()

  -- 3. Bộ sưu tập Mẫu cá nhân đã lưu (Personal Saved Theme Slots)
  F.section(scr,T("saved_themes_sec"))
  local savedWrap=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BackgroundTransparency=1},scr)list(savedWrap,4)
  local function rebuildSavedSlots()
    for _,c in ipairs(savedWrap:GetChildren())do if not c:IsA("UIListLayout")then c:Destroy()end end
    P.savedThemes=type(P.savedThemes)=="table"and P.savedThemes or{}
    local topRow=row(savedWrap,28,1)
    local saveSlotBtn=rbtn(topRow,T("save_slot_btn"),{size=u2(0.54,-3,1,0),key="accent",ts=10,r=7})
    local harmBtn=rbtn(topRow,T("harmonize_btn"),{size=u2(0.46,-3,1,0),key="ok",ts=10,r=7})
    hook(saveSlotBtn.MouseButton1Click,function()
      if #P.savedThemes>=6 then tremove(P.savedThemes,1)end
      local copyCustom={}for k,v in pairs(P.custom)do copyCustom[k]=v end
      tinsert(P.savedThemes,{
        name=(P.themeName:gsub("_"," ")).." #"..tostring(#P.savedThemes+1),
        themeName=P.themeName,
        custom=copyCustom,
        alpha=P.alpha,
        backgroundMode=P.backgroundMode,
        backgroundImage=P.backgroundImage,
        backgroundOpacity=P.backgroundOpacity,
        backgroundDim=P.backgroundDim,
        bgFrame=P.bgFrame,
        gradAngle=P.gradAngle,
        gradMix=P.gradMix,
        uiRadius=P.uiRadius,
        fontFamily=P.fontFamily,
        msgStyle=P.msgStyle,
        borderGlow=P.borderGlow,
      })
      S.isDirty=true;F.save(true);rebuildSavedSlots();F.toast(T("saved_ok"),true)
    end)
    hook(harmBtn.MouseButton1Click,function()
      F.harmonizePalette();refreshRows();paintSel()
    end)
    for idx,slot in ipairs(P.savedThemes)do
      local sr=mk("Frame",{Size=u2(1,0,0,30),BorderSizePixel=0,LayoutOrder=idx+1},savedWrap)
      themed(sr,function(o)o.BackgroundColor3=TH.cardBg;o.BackgroundTransparency=F.surfaceAlpha("card")end);corner(sr,7);stroke(sr,"border",1,0.45)
      F.lucide(sr,"palette",12,{pos=uo(8,9),key="accent"})
      local useB=mk("TextButton",{Size=u2(1,-56,1,0),Position=uo(24,0),BackgroundTransparency=1,Text=tostring(slot.name or("Slot #"..idx)).." ("..tostring(slot.backgroundMode or"solid")..")",Font=fGB,TextSize=11,TextXAlignment=txL,TextTruncate=trEnd,BorderSizePixel=0},sr)
      th(useB,"TextColor3","text")
      local delB=tbtn(sr,"",{size=uo(24,22),pos=u2(1,-28,0,4),key="danger",ts=10,r=5})
      F.lucide(delB,"x",11,{pos=us(0.5,0.5),anc=v2(0.5,0.5),col=c3(1,1,1),themed=false})
      hook(useB.MouseButton1Click,function()
        if slot.themeName and THEMES[slot.themeName]then P.themeName=slot.themeName end
        P.custom={}for k,v in pairs(type(slot.custom)=="table"and slot.custom or{})do P.custom[k]=v end
        P.alpha=tonumber(slot.alpha)or P.alpha
        P.backgroundMode=slot.backgroundMode or P.backgroundMode
        if slot.backgroundImage~=nil then P.backgroundImage=slot.backgroundImage end
        if slot.backgroundOpacity~=nil then P.backgroundOpacity=slot.backgroundOpacity end
        if slot.backgroundDim~=nil then P.backgroundDim=slot.backgroundDim end
        if type(slot.bgFrame)=="table"then P.bgFrame=slot.bgFrame end
        P.gradAngle=tonumber(slot.gradAngle)or P.gradAngle
        P.gradMix=tonumber(slot.gradMix)or P.gradMix
        P.uiRadius=tonumber(slot.uiRadius)or P.uiRadius
        P.fontFamily=slot.fontFamily or P.fontFamily
        P.msgStyle=slot.msgStyle or P.msgStyle
        if slot.borderGlow~=nil then P.borderGlow=slot.borderGlow end
        F.paintTheme();S.isDirty=true;F.openTheme();F.toast(T("theme_ok"),true)
      end)
      hook(delB.MouseButton1Click,function()
        tremove(P.savedThemes,idx);S.isDirty=true;F.save(true);rebuildSavedSlots()
      end)
    end
  end
  rebuildSavedSlots()

  -- 4. Tuỳ chỉnh Kiểu dáng Khung, Bo góc, Phông chữ, Kiểu thẻ tin & Viền Chroma
  F.section(scr,T("ui_style_sec"))
  F.slider(scr,T("alpha"),0,85,floor(P.alpha*100+0.5),{step=1,fmt=function(v)return v.."%"end,onChange=function(v)P.alpha=v/100;F.paintTheme()end,onDone=function()S.isDirty=true end})
  F.slider(scr,T("ui_radius"),3,16,floor(tonumber(P.uiRadius)or 10),{step=1,fmt=function(v)return v.."px"end,
    onChange=function(v)P.uiRadius=v;F.paintTheme()end,onDone=function()S.isDirty=true;if S.booted and F.rebuildFeed then pcall(F.rebuildFeed,true)end end})
  F.switch(scr,T("border_glow"),function()return P.borderGlow~=false end,function(v)P.borderGlow=v;F.paintTheme();S.isDirty=true end)

  lab(scr,T("font_family"),{h=14,ts=10,bold=true,key="muted"})
  local fontGrid=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BackgroundTransparency=1},scr)
  mk("UIGridLayout",{CellSize=u2(0.25,-4,0,28),CellPadding=uo(5,5),SortOrder=soLO,Parent=fontGrid})
  for idx,fKey in ipairs(FONT_ORDER)do
    local fm=FONT_MAP[fKey]
    local fb=tbtn(fontGrid,fm.name,{size=u2(1,0,1,0),ts=10,r=6,layout=idx})
    fb.Font=fm.bold
    themed(fb,function(btn)
      local on=(P.fontFamily==fKey)
      btn.BackgroundColor3=on and TH.accent or TH.btnBg
      btn.TextColor3=on and(H.lum(TH.accent)>0.55 and rgb(20,20,24)or c3(1,1,1))or H.ensureContrast(TH.text,TH.btnBg,4.8)
    end)
    hook(fb.MouseButton1Click,function()
      P.fontFamily=fKey;F.paintTheme();if S.booted and F.rebuildFeed then pcall(F.rebuildFeed,true)end;S.isDirty=true;F.save(true)
    end)
  end

  lab(scr,T("msg_style"),{h=14,ts=10,bold=true,key="muted"})
  local msRow=row(scr,28)
  for idx,mDef in ipairs({{"card","msg_card"},{"flat","msg_flat"},{"minimal","msg_minimal"}})do
    local mid,mkey=mDef[1],mDef[2]
    local mb=tbtn(msRow,T(mkey),{size=u2(1/3,-4,1,0),ts=10,r=6,layout=idx})
    themed(mb,function(btn)
      local on=(P.msgStyle==mid)
      btn.BackgroundColor3=on and TH.accent or TH.btnBg
      btn.TextColor3=on and(H.lum(TH.accent)>0.55 and rgb(20,20,24)or c3(1,1,1))or H.ensureContrast(TH.text,TH.btnBg,4.8)
    end)
    hook(mb.MouseButton1Click,function()
      P.msgStyle=mid;F.paintTheme();if S.booted and F.rebuildFeed then pcall(F.rebuildFeed,true)end;S.isDirty=true;F.save(true)
    end)
  end

  -- 5. Màu nhấn nhanh & Tùy chỉnh từng màu chi tiết
  F.section(scr,T("accent_quick"))
  local ag=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BackgroundTransparency=1},scr)mk("UIGridLayout",{CellSize=uo(34,30),CellPadding=uo(5,5),SortOrder=soLO},ag)for i,hx in ipairs(ACCENTS)do
    local b=mk("TextButton",{Text="",BackgroundColor3=H.hex(hx),BorderSizePixel=0,LayoutOrder=i},ag)corner(b,8);stroke(b,"muted",1,0.7)
    hook(b.MouseButton1Click,function()P.custom.accent=hx;F.paintTheme();S.isDirty=true;refreshRows()end)end
  F.section(scr,T("custom_colors"))local openKey for _,g in ipairs(COLOR_GROUPS)do
    lab(scr,T(g[1]),{h=14,ts=10,bold=true,key="muted"})for _,k in ipairs(g[2])do local wrap=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BackgroundTransparency=1},scr)list(wrap,4)
      local head=mk("TextButton",{Size=u2(1,0,0,32),Text="",BorderSizePixel=0,LayoutOrder=1},wrap)th(head,"BackgroundColor3","cardBg");corner(head,8);stroke(head,"border",1,0.5)local sw=mk("Frame",{Size=uo(22,22),Position=uo(6,5),BorderSizePixel=0},head)
      corner(sw,6);stroke(sw,"muted",1,0.5)lab(head,T("ck_"..k),{size=u2(1,-150,1,0),pos=uo(34,0),trunc=true})local hx=lab(head,"",{size=uo(70,32),pos=u2(1,-102,0,0),ts=11,key="muted",align=txR})hx.Font=fCode
      local rs=tbtn(head,"R",{size=uo(24,24),pos=u2(1,-28,0,4),ts=11,key="bg2",r=6})rows[k]={sw=sw,hx=hx,reset=rs}
      local holder=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BackgroundTransparency=1,Visible=false,LayoutOrder=2},wrap)local pk
      hook(rs.MouseButton1Click,function()P.custom[k]=nil;F.paintTheme();S.isDirty=true;refreshRows();if pk then pk.set(H.tohex(TH[k]))end end)hook(head.MouseButton1Click,function()if not pk then
          pk=F.colorPicker(holder,H.tohex(TH[k]),function(hex)P.custom[k]=hex;F.paintTheme();S.isDirty=true sw.BackgroundColor3=TH[k];hx.Text=H.tohex(TH[k]);rs.Visible=true end)end
        if openKey and openKey~=holder then openKey.Visible=false end holder.Visible=not holder.Visible openKey=holder.Visible and holder or nil end)end end refreshRows()local r1=row(scr,30)
  local ac=rbtn(r1,T("auto_contrast"),{ts=11});hook(ac.MouseButton1Click,function()F.autoContrast();refreshRows()end)local rr=rbtn(r1,T("reset_all"),{key="danger",ts=11})
  hook(rr.MouseButton1Click,function()
    P.themeName="midnight";P.custom={};P.alpha=0;P.backgroundMode="solid";P.backgroundImage="";P.backgroundOpacity=0.82;P.backgroundDim=0.25
    P.bgFrame={fit="crop",zoom=100,x=0,y=0,aspect="auto"}
    P.gradAngle=28;P.gradMix=0.65;P.uiRadius=10;P.fontFamily="gotham";P.msgStyle="card";P.borderGlow=true
    F.paintTheme();if S.booted and F.rebuildFeed then pcall(F.rebuildFeed,true)end;S.isDirty=true;F.openTheme()
  end)
  local cp=tbtn(scr,T("theme_copy"),{h=30,ts=11})
  hook(cp.MouseButton1Click,function()F.copyText(F.themeCode())end)local imp=field(scr,"","")imp.PlaceholderText=T("theme_paste")local ib=tbtn(scr,T("theme_import"),{key="accent",h=30,ts=11})
  hook(ib.MouseButton1Click,function()if F.importTheme(imp.Text)then F.save(true);F.toast(T("theme_ok"),true);F.openTheme()else F.toast(T("theme_bad"),true)end end)
  local svThemeBtn=tbtn(scr,"   "..(L=="en"and"Save Theme"or"Lưu Giao Diện"),{key="ok",h=36,ts=12})
  F.lucide(svThemeBtn,"save",14,{pos=uo(12,11),col=c3(1,1,1),themed=false})
  hook(svThemeBtn.MouseButton1Click,function()saveThemeAll(true)end)
end
--- [F.openRequest] Mở hộp thoại để người dùng chọn Role và gửi đơn xin cấp Role tới đội ngũ Quản trị
function F.openRequest()
  local scr=F.modalBox(T("request_title"),380,500)lab(scr,T("request_intro"),{wrap=true,auto=true,ts=11,key="muted"})if#S.roles==0 then lab(scr,T("request_none"),{wrap=true,auto=true,ts=11,key="warn"})return end
  if S.myRequest then lab(scr,T("request_pending"),{ts=12,bold=true,key="warn",wrap=true,auto=true})end lab(scr,T("request_role"),{h=14,ts=10,bold=true,key="muted"})local chosen=nil
  local roleGrid=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BackgroundTransparency=1},scr)list(roleGrid,4)local buttons={}local sorted=F.sortedRoles()for i,r in ipairs(sorted)do local has=F.hasRole(P.username,r.id)
    local b=mk("TextButton",{Size=u2(1,0,0,36),Text="",BorderSizePixel=0,LayoutOrder=i},roleGrid)th(b,"BackgroundColor3","cardBg");corner(b,8);stroke(b,"border",1,0.5)F.roleChip(b,r,0,true).Position=uo(8,8)
    local ck=lab(b,has and"[x]"or"",{size=uo(32,36),pos=u2(1,-36,0,0),bold=true,ts=12,align=txC,key="ok"})buttons[#buttons+1]={r=r,b=b,ck=ck,has=has}hook(b.MouseButton1Click,function()if has then return end chosen=r
      for _,x in ipairs(buttons)do if x.has then x.b.BackgroundColor3=TH.cardBg elseif x.r==r then x.b.BackgroundColor3=TH.accent;x.ck.Text="[x]"else x.b.BackgroundColor3=TH.cardBg;x.ck.Text=""end end end)end
  local rs=field(scr,T("request_reason"),"",true)local go=tbtn(scr,T("request_send"),{key="accent",h=34})hook(go.MouseButton1Click,function()if not chosen then F.toast(T("select_role"),true);return end
    enqueue("other","POST","/api/request",{u=P.username,role=chosen.id,reason=H.clip(H.trim(rs.Text),200)},function(d,e)if d and d.ok then S.myRequest=d.request F.toast(T("request_sent"),true);F.closeModal()
      elseif d and d.error=="pending"then F.toast(T("request_pending"),true)else F.netError(d and d.error or e)end end)end)end
--- [F.exportSettings] Xuất toàn bộ cài đặt cá nhân, Theme và danh sách Emoji cục bộ ra chuỗi mã sao lưu (`CBS1:...`)
function F.exportSettings()
  local t={lang=L,display=P.display,status=P.status,bio=P.bio,country=P.country,profBanner=P.profBanner,profIcon=P.profIcon,profTheme=P.profTheme,autoExecute=P.autoExecute,scriptUrl=P.scriptUrl,msgCount=P.msgCount,themeName=P.themeName,custom=P.custom,alpha=P.alpha,backgroundMode=P.backgroundMode,backgroundImage=P.backgroundImage,backgroundOpacity=P.backgroundOpacity,backgroundDim=P.backgroundDim,bgFrame=P.bgFrame,gradAngle=P.gradAngle,gradMix=P.gradMix,uiRadius=P.uiRadius,fontFamily=P.fontFamily,msgStyle=P.msgStyle,borderGlow=P.borderGlow,savedThemes=P.savedThemes,userNotes=P.userNotes,blockedUsers=P.blockedUsers,notify=P.notify,sound=P.sound,bubble=P.bubble,safeEmoji=P.safeEmoji,showGame=P.showGame,preview=P.preview,compact=P.compact,sameUser=P.sameUser,group=P.group,showTyping=P.showTyping,showSeen=P.showSeen,textSize=P.textSize,toastPos=P.toastPos,customEmojis=P.customEmojis,recentEmoji=P.recentEmoji,dmList=P.dmList}
  return"CBS1:"..H.jenc(t)end
--- [F.importSettings] Khôi phục cài đặt cá nhân từ chuỗi mã sao lưu (`CBS1:...`)
function F.importSettings(code)local j=H.trim(code):match("^CBS1:(.+)$")local d=j and H.jdec(j)if type(d)~="table"then return false end
  for _,k in ipairs({"display","status","bio","country","profBanner","profIcon","autoExecute","scriptUrl","themeName","alpha","backgroundMode","backgroundOpacity","backgroundDim","gradAngle","gradMix","uiRadius","fontFamily","msgStyle","borderGlow","notify","sound","bubble","safeEmoji","showGame","preview","compact","sameUser","group","showTyping","showSeen","textSize","toastPos"})do if d[k]~=nil then P[k]=d[k]end
  end
  P.msgCount=max(P.msgCount or 0,floor(tonumber(d.msgCount)or 0))
  P.scriptUrl=H.trim(tostring(P.scriptUrl or""))
  if P.scriptUrl~=""then ENV.CB46_SCRIPT_URL=P.scriptUrl ENV.CB45_SCRIPT_URL=P.scriptUrl end
  P.country=H.resolveCountry(P.country)
  if not THEMES[P.themeName]then P.themeName="midnight"end for _,k in ipairs({"custom","customEmojis","recentEmoji","dmList","profTheme","bgFrame","savedThemes","userNotes","blockedUsers"})do if type(d[k])=="table"then P[k]=d[k]end end
  P.backgroundImage=H.assetId(d.backgroundImage or P.backgroundImage or"")or""
  local validModes={solid=true,gradient=true,mesh=true,glass=true,image=true}
  if not validModes[P.backgroundMode]then P.backgroundMode="solid"end
  if P.backgroundMode=="image"and P.backgroundImage==""then P.backgroundMode="solid"end
  P.backgroundOpacity=clamp(tonumber(P.backgroundOpacity)or 0.82,0.15,1)P.backgroundDim=clamp(tonumber(P.backgroundDim)or 0.25,0,0.75)
  P.alpha=clamp(tonumber(P.alpha)or 0,0,0.85)
  P.textSize=clamp(tonumber(P.textSize)or 13,11,20)if d.lang=="en"or d.lang=="vi"then L=d.lang end
  F.paintTheme();F.layout();S.isDirty=true return true end
--- [F.setLang] Chuyển đổi ngôn ngữ hiển thị (Tiếng Việt / Tiếng Anh) và cập nhật lại toàn bộ nhãn giao diện ngay lập tức
function F.setLang(l)
  L=l
  U.bLang.Text=L=="en"and"EN"or"VI"
  if S.chan=="announce"then
    U.input.PlaceholderText=F.canAnnounce(P.username)and T("announce_ph")or T("announce_ro")
  elseif S.chan=="punish"then
    U.input.PlaceholderText=F.isStaff(P.username)and T("punish_ph")or T("punish_ro")
  else
    U.input.PlaceholderText=T("input")
  end
  U.searchBox.PlaceholderText=T("search")
  if F.updateSendBtn then F.updateSendBtn()else U.sendBtn.Text=(P.W<220)and">"or T("send")end
  U.titleLbl.Text=(P.W<115 or P.H<95)and"CB"or T("title")
  if S.reply and U.replyBar and U.replyBar.Visible then
    if U.replyIcon then U.replyIcon.Image=F.LUCIDE.reply end
    U.replyLbl.Text=F.disp(T("reply_to").."@"..tostring(S.reply.author)..": "..tostring(S.reply.snippet))
  elseif S.editing and U.replyBar and U.replyBar.Visible then
    if U.replyIcon then U.replyIcon.Image=F.LUCIDE.pencil end
    U.replyLbl.Text=T("editing")
  end
  if F.refreshTypingLabel then pcall(F.refreshTypingLabel)end
  if F.updateTokenFeedback and U.input then pcall(F.updateTokenFeedback,U.input.Text)end
  S.isDirty=true
  F.save(true)
  F.paintTabs()
  F.updateInfo()
  if S.booted and F.rebuildFeed then pcall(F.rebuildFeed,true)end
  if U.modal and U.modal.Visible and type(S.reopenModal)=="function"then
    local fn=S.reopenModal
    pcall(fn)
  end
end
--- [F.upsertMyFeedback] Cập nhật hoặc chèn một phiếu Góp ý / Báo lỗi vào danh sách cá nhân `P.myFeedbacks`
function F.upsertMyFeedback(fb,notifyUser)
  if type(fb)~="table"or not fb.id then return end
  P.myFeedbacks=type(P.myFeedbacks)=="table"and P.myFeedbacks or{}
  local fid=tostring(fb.id)
  local found=nil
  for _,item in ipairs(P.myFeedbacks)do
    if tostring(item.id)==fid then found=item;break end
  end
  local prevSeen=found and found.seen==true or false
  local prevRepCount=found and type(found.replies)=="table"and #found.replies or 0
  if not found then
    found={
      id=fid,
      kind=fb.kind=="bug"and"bug"or"suggest",
      author=tostring(fb.author or P.username),
      category=tostring(fb.category or""),
      severity=tostring(fb.severity or""),
      title=tostring(fb.title or""),
      content=tostring(fb.content or""),
      steps=tostring(fb.steps or""),
      seen=fb.seen==true,
      seenBy=tostring(fb.seenBy or fb.by or""),
      status=tostring(fb.status or"pending"),
      replies=type(fb.replies)=="table"and fb.replies or{},
      ts=tonumber(fb.ts)or H.now(),
    }
    tinsert(P.myFeedbacks,found)
    while #P.myFeedbacks>50 do tremove(P.myFeedbacks,1)end
  else
    if fb.seen~=nil then found.seen=fb.seen==true end
    if fb.seenBy and fb.seenBy~=""then found.seenBy=tostring(fb.seenBy)elseif fb.by and fb.by~=""then found.seenBy=tostring(fb.by)end
    if fb.status and fb.status~=""then found.status=tostring(fb.status)end
    if type(fb.replies)=="table"then found.replies=fb.replies end
    if fb.replyText and fb.replyText~=""then
      found.replies=type(found.replies)=="table"and found.replies or{}
      local rId=tostring(fb.packetId or("r-"..tostring(H.now())))
      local dup=false
      for _,r in ipairs(found.replies)do if tostring(r.id)==rId or(r.text==fb.replyText and math.abs((tonumber(r.ts)or 0)-(tonumber(fb.ts)or 0))<5)then dup=true;break end end
      if not dup then
        tinsert(found.replies,{id=rId,by=tostring(fb.by or fb.seenBy or"Developer"),text=tostring(fb.replyText),kind=tostring(fb.replyKind or"reply"),ts=tonumber(fb.ts)or H.now()})
      end
      found.status="replied"
      found.seen=true
    end
  end
  S.isDirty=true
  local newRepCount=type(found.replies)=="table"and #found.replies or 0
  if notifyUser then
    if newRepCount>prevRepCount then
      local lastRep=found.replies[newRepCount]
      S.fbUnread=(S.fbUnread or 0)+1
      F.pingSound()
      local msgToast="💬 @"..F.disp(lastRep.by or"Developer")..": "..H.clip(tostring(lastRep.text or""),90)
      F.toast(msgToast,true,function()
        S.fbUnread=0
        if found.kind=="bug"then F.openBugReport(2)else F.openSuggestions(2)end
      end)
    elseif found.seen and not prevSeen then
      S.fbUnread=(S.fbUnread or 0)+1
      F.pingSound()
      local seenToast="👀 "..(L=="en"and("Developer @"..F.disp(found.seenBy~=""and found.seenBy or"Dev").." reviewed your "..(found.kind=="bug"and"bug report"or"suggestion").." (#"..fid..")")or("Developer @"..F.disp(found.seenBy~=""and found.seenBy or"Dev").." đã xem "..(found.kind=="bug"and"báo lỗi"or"góp ý").." #"..fid.." của bạn!"))
      F.toast(seenToast,true,function()
        S.fbUnread=0
        if found.kind=="bug"then F.openBugReport(2)else F.openSuggestions(2)end
      end)
    end
  end
end
--- [F.submitFeedback] Gửi phiếu Góp ý (`suggest`) hoặc Báo lỗi (`bug`) lên Worker (tự động chuyển tới Webhook kèm nút bấm tương tác Đã xem / Phản hồi)
function F.submitFeedback(kind,payload,onDone)
  local nowC=os.clock()
  if S.lastFbAt and nowC-S.lastFbAt<8 then
    F.toast(T("fb_cooldown"),true)
    return
  end
  local desc=H.trim(payload.content or"")
  if #desc<6 then
    F.toast(T("fb_need_desc"),true)
    return
  end
  S.lastFbAt=nowC
  local ts=H.now()
  local fid=(kind=="bug"and"BG-"or"SG-")..string.upper(string.format("%x",ts):sub(-4)).."-"..string.upper(H.uuid():sub(1,4))
  local body={
    action="submit",
    id=fid,
    kind=kind,
    by=P.username,
    author=P.username,
    display=P.display or P.username,
    uid=P.userId,
    category=payload.category or(kind=="bug"and"UI / Script"or"Feature"),
    severity=payload.severity or"Normal",
    title=H.clip(H.trim(payload.title or""),100),
    content=H.clip(desc,1200),
    steps=H.clip(H.trim(payload.steps or""),600),
    exec=payload.attachDiag~=false and EXEC or"Hidden",
    device=payload.attachDiag~=false and(IS_MOBILE and"Mobile"or"PC")or"Hidden",
    placeId=payload.attachDiag~=false and tonumber(game.PlaceId)or 0,
    gameName=payload.attachDiag~=false and tostring(S.placeName or"")or"",
    rtt=payload.attachDiag~=false and(S.rtt and(floor(S.rtt).."ms")or"n/a")or"",
    ts=ts,
  }
  F.upsertMyFeedback(body,false)
  F.save(true)
  enqueue("send","POST","/api/feedback",body,function(d,err)
    if d and d.ok then
      if type(d.feedback)=="table"then F.upsertMyFeedback(d.feedback,false)end
      F.toast(T("fb_sent_ok"),true)
      if onDone then pcall(onDone,true)end
    else
      -- Dự phòng gửi trực tiếp tới Webhook nếu kết nối Proxy đang gián đoạn
      task.spawn(function()
        local whUrl=kind=="bug"and CFG.BUG_WEBHOOK or CFG.SUGGEST_WEBHOOK
        if whUrl and whUrl~=""then
          local emb={
            title=(kind=="bug"and"🐛 BÁO LỖI (BUG REPORT) · #"or"💡 GÓP Ý (SUGGESTION) · #")..fid..(body.title~=""and(" — "..body.title)or""),
            description=body.content,
            color=kind=="bug"and 0xef4444 or 0x10b981,
            fields={
              {name="👤 Người gửi (Roblox)",value=string.format("**%s** (`@%s` • UID: `%s`)",tostring(body.display),tostring(body.author),tostring(body.uid)),inline=true},
              {name=kind=="bug"and"⚠️ Khu vực & Mức độ"or"🏷️ Danh mục",value=kind=="bug"and(body.category.." • **"..body.severity.."**")or body.category,inline=true},
              {name="💻 Môi trường",value=string.format("Executor: `%s` • Thiết bị: `%s` • PlaceId: `%s` • v46.0",tostring(body.exec),tostring(body.device),tostring(body.placeId)),inline=false},
            },
          }
          if kind=="bug"and body.steps~=""then
            tinsert(emb.fields,3,{name="🔁 Các bước tái hiện",value=body.steps,inline=false})
          end
          pcall(httpFn,{
            Url=whUrl,
            Method="POST",
            Headers={["Content-Type"]="application/json"},
            Body=H.jenc({username=kind=="bug"and"CB46 Bug Reports"or"CB46 Suggestions",embeds={emb}}),
          })
        end
      end)
      F.publish({type="feedback",packetId="fb-"..fid,id=fid,kind=kind,author=P.username,display=P.display,uid=P.userId,category=body.category,severity=body.severity,title=body.title,content=body.content,steps=body.steps,exec=body.exec,device=body.device,placeId=body.placeId,gameName=body.gameName,rtt=body.rtt,chan="staff",ts=ts})
      F.toast(T("fb_sent_ok"),true)
      if onDone then pcall(onDone,true)end
    end
  end)
end
--- [F.renderFeedbackHistory] Vẽ danh sách các phiếu Góp ý / Báo lỗi đã gửi kèm trạng thái "Đã xem" và phản hồi từ Developer
function F.renderFeedbackHistory(parentFrame,filterKind)
  for _,c in ipairs(parentFrame:GetChildren())do if not c:IsA("UIListLayout")then c:Destroy()end end
  local listItems={}
  for i=#(P.myFeedbacks or{}),1,-1 do
    local it=P.myFeedbacks[i]
    if it and(not filterKind or it.kind==filterKind)then listItems[#listItems+1]=it end
  end
  if #listItems==0 then
    local emptyCard=F.card(parentFrame,64)
    pad(emptyCard,10,10,10,10)
    lab(emptyCard,T("fb_empty_hist"),{wrap=true,auto=true,ts=11,key="muted"})
    return
  end
  for idx,it in ipairs(listItems)do
    local isBug=(it.kind=="bug")
    local hasRep=type(it.replies)=="table"and #it.replies>0
    local stKey=hasRep and"ok"or(it.status=="planned"and"accent"or(it.seen and"accent"or"warn"))
    local stText=hasRep and T("fb_st_replied")or(it.status=="planned"and T("fb_st_planned")or(it.seen and T("fb_st_seen")or T("fb_st_pending")))
    if it.seen and it.seenBy and it.seenBy~=""and not hasRep then
      stText=stText.." (@"..it.seenBy..")"
    end
    local card=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BorderSizePixel=0,LayoutOrder=idx},parentFrame)
    th(card,"BackgroundColor3","cardBg");corner(card,8);stroke(card,hasRep and"ok"or"border",1,hasRep and 0.25 or 0.45)
    pad(card,10,8,10,8);list(card,4)
    local hdr=mk("Frame",{Size=u2(1,0,0,20),BackgroundTransparency=1,LayoutOrder=1},card)
    lab(hdr,(isBug and"🐛 "or"💡 ").."#"..tostring(it.id).." · "..H.clip(it.title~=""and it.title or it.category,36),{size=u2(0.62,0,1,0),bold=true,ts=11,trunc=true})
    local pill=mk("TextLabel",{Size=u2(0.38,-2,0,18),Position=u2(0.62,2,0,1),Text=stText,Font=fGB,TextSize=9,BorderSizePixel=0,TextTruncate=trEnd},hdr)
    th(pill,"BackgroundColor3",stKey);corner(pill,6)
    themed(pill,function(p)p.TextColor3=H.lum(TH[stKey]or TH.accent)>0.55 and rgb(18,18,22)or c3(1,1,1)end)
    lab(card,tostring(it.content or""),{wrap=true,auto=true,ts=11,key="text",layout=2})
    if isBug and it.steps and it.steps~=""then
      lab(card,"› "..tostring(it.steps),{wrap=true,auto=true,ts=10,key="muted",layout=3})
    end
    if hasRep then
      for rIdx,rep in ipairs(it.replies)do
        local rBox=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BorderSizePixel=0,LayoutOrder=10+rIdx},card)
        th(rBox,"BackgroundColor3","bg3");corner(rBox,7);stroke(rBox,"ok",1,0.35);pad(rBox,8,6,8,6);list(rBox,2)
        lab(rBox,"💖 "..(L=="en"and"Reply from @"or"Phản hồi từ @")..F.disp(rep.by or"Developer").." · "..H.shortTime(rep.ts),{bold=true,ts=10,key="ok",layout=1})
        lab(rBox,tostring(rep.text or""),{wrap=true,auto=true,ts=11,key="text",layout=2})
      end
    end
  end
end
--- [F.openSuggestions] Mở hộp thoại Góp ý & Đề xuất Tính năng (UI Suggestions) gửi tới Webhook Suggestions kèm lịch sử phản hồi
function F.openSuggestions(initTab)
  local curTab=tonumber(initTab)or 1
  S.reopenModal=function()F.openSuggestions(curTab)end
  S.fbUnread=0
  local scr=F.modalBox("💡 "..T("suggest_title"),410,600)
  local navRow=row(scr,30)
  local tabNew=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BackgroundTransparency=1,Visible=(curTab==1)},scr)list(tabNew,6)
  local tabHist=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BackgroundTransparency=1,Visible=(curTab==2)},scr)list(tabHist,6)
  local bNew=rbtn(navRow,"✍️ "..T("fb_tab_new"),{size=u2(0.5,-3,1,0),ts=11,r=7})
  local bHist=rbtn(navRow,"📬 "..T("fb_tab_hist").." ("..tostring(#(P.myFeedbacks or{}))..")",{size=u2(0.5,-3,1,0),ts=11,r=7})
  local function updateTabUI()
    tabNew.Visible=(curTab==1)
    tabHist.Visible=(curTab==2)
    bNew.BackgroundColor3=(curTab==1)and TH.accent or TH.btnBg
    bNew.TextColor3=(curTab==1)and(H.lum(TH.accent)>0.55 and rgb(20,20,24)or c3(1,1,1))or TH.text
    bHist.BackgroundColor3=(curTab==2)and TH.accent or TH.btnBg
    bHist.TextColor3=(curTab==2)and(H.lum(TH.accent)>0.55 and rgb(20,20,24)or c3(1,1,1))or TH.text
    if curTab==2 then F.renderFeedbackHistory(tabHist,"suggest")end
  end
  hook(bNew.MouseButton1Click,function()curTab=1;updateTabUI()end)
  hook(bHist.MouseButton1Click,function()curTab=2;updateTabUI()end)

  lab(tabNew,T("fb_intro"),{wrap=true,auto=true,ts=11,key="muted"})
  lab(tabNew,T("fb_cat"),{h=14,ts=10,bold=true,key="muted"})
  local cats=L=="en"and{"UI / Theme","Chat Features","Channels & Groups","Performance","Other"}or{"Giao diện / Theme","Tính năng Chat","Kênh & Nhóm","Tối ưu Hiệu năng","Khác"}
  local chosenCat=cats[1]
  local catGrid=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BackgroundTransparency=1},tabNew)
  mk("UIGridLayout",{CellSize=u2(1/3,-4,0,26),CellPadding=uo(4,4),SortOrder=soLO},catGrid)
  local catBtns={}
  local function paintCats()
    for _,item in ipairs(catBtns)do
      local on=(item.c==chosenCat)
      item.b.BackgroundColor3=on and TH.accent or TH.btnBg
      item.b.TextColor3=on and(H.lum(TH.accent)>0.55 and rgb(20,20,24)or c3(1,1,1))or TH.text
    end
  end
  for i,cName in ipairs(cats)do
    local b=tbtn(catGrid,cName,{ts=10,r=6,layout=i})
    catBtns[#catBtns+1]={c=cName,b=b}
    hook(b.MouseButton1Click,function()chosenCat=cName;paintCats()end)
  end
  paintCats()

  local subjBox=field(tabNew,T("fb_subj"),"",false)
  subjBox.PlaceholderText=T("fb_subj_ph")
  local descBox=field(tabNew,T("fb_desc"),"",true)
  descBox.Size=u2(1,0,0,86)
  descBox.PlaceholderText=T("fb_desc_ph")

  local attachDiag=true
  F.switch(tabNew,T("fb_attach_diag"),function()return attachDiag end,function(v)attachDiag=v end)

  local sendBtn=tbtn(tabNew,"🚀 "..T("fb_send_suggest"),{key="ok",h=36,ts=12})
  hook(sendBtn.MouseButton1Click,function()
    F.submitFeedback("suggest",{
      category=chosenCat,
      title=subjBox.Text,
      content=descBox.Text,
      attachDiag=attachDiag,
    },function(ok)
      if ok then
        subjBox.Text="";descBox.Text=""
        bHist.Text="📬 "..T("fb_tab_hist").." ("..tostring(#(P.myFeedbacks or{}))..")"
        curTab=2;updateTabUI()
      end
    end)
  end)
  updateTabUI()
end
--- [F.openBugReport] Mở hộp thoại Báo cáo lỗi (UI Report Bugs) gửi tới Webhook Report Bugs kèm thông số chẩn đoán & lịch sử phản hồi
function F.openBugReport(initTab)
  local curTab=tonumber(initTab)or 1
  S.reopenModal=function()F.openBugReport(curTab)end
  S.fbUnread=0
  local scr=F.modalBox("🐛 "..T("bug_title"),410,630)
  local navRow=row(scr,30)
  local tabNew=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BackgroundTransparency=1,Visible=(curTab==1)},scr)list(tabNew,6)
  local tabHist=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BackgroundTransparency=1,Visible=(curTab==2)},scr)list(tabHist,6)
  local bNew=rbtn(navRow,"🐛 "..T("fb_tab_new"),{size=u2(0.5,-3,1,0),ts=11,r=7})
  local bHist=rbtn(navRow,"📬 "..T("fb_tab_hist").." ("..tostring(#(P.myFeedbacks or{}))..")",{size=u2(0.5,-3,1,0),ts=11,r=7})
  local function updateTabUI()
    tabNew.Visible=(curTab==1)
    tabHist.Visible=(curTab==2)
    bNew.BackgroundColor3=(curTab==1)and TH.danger or TH.btnBg
    bNew.TextColor3=(curTab==1)and c3(1,1,1)or TH.text
    bHist.BackgroundColor3=(curTab==2)and TH.accent or TH.btnBg
    bHist.TextColor3=(curTab==2)and(H.lum(TH.accent)>0.55 and rgb(20,20,24)or c3(1,1,1))or TH.text
    if curTab==2 then F.renderFeedbackHistory(tabHist,"bug")end
  end
  hook(bNew.MouseButton1Click,function()curTab=1;updateTabUI()end)
  hook(bHist.MouseButton1Click,function()curTab=2;updateTabUI()end)

  lab(tabNew,T("fb_cat"),{h=14,ts=10,bold=true,key="muted"})
  local areas=L=="en"and{"UI / Theme","Chat / Messages","Network / Proxy","Profile / Emojis","Auto-Execute"}or{"Giao diện / Theme","Tin nhắn / Kênh","Kết nối / Proxy","Hồ sơ / Emoji","Auto-Execute"}
  local chosenArea=areas[1]
  local areaGrid=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BackgroundTransparency=1},tabNew)
  mk("UIGridLayout",{CellSize=u2(1/3,-4,0,26),CellPadding=uo(4,4),SortOrder=soLO},areaGrid)
  local areaBtns={}
  local function paintAreas()
    for _,item in ipairs(areaBtns)do
      local on=(item.c==chosenArea)
      item.b.BackgroundColor3=on and TH.accent or TH.btnBg
      item.b.TextColor3=on and(H.lum(TH.accent)>0.55 and rgb(20,20,24)or c3(1,1,1))or TH.text
    end
  end
  for i,aName in ipairs(areas)do
    local b=tbtn(areaGrid,aName,{ts=10,r=6,layout=i})
    areaBtns[#areaBtns+1]={c=aName,b=b}
    hook(b.MouseButton1Click,function()chosenArea=aName;paintAreas()end)
  end
  paintAreas()

  lab(tabNew,T("fb_sev"),{h=14,ts=10,bold=true,key="muted"})
  local sevRow=row(tabNew,26)
  local chosenSev=T("fb_sev_med")
  local sevBtns={}
  local function paintSev()
    for _,item in ipairs(sevBtns)do
      local on=(item.s==chosenSev)
      item.b.BackgroundColor3=on and TH[item.k]or TH.btnBg
      item.b.TextColor3=on and(H.lum(TH[item.k])>0.55 and rgb(20,20,24)or c3(1,1,1))or TH.text
    end
  end
  for i,sDef in ipairs({{T("fb_sev_low"),"ok"},{T("fb_sev_med"),"warn"},{T("fb_sev_high"),"danger"}})do
    local b=tbtn(sevRow,sDef[1],{size=u2(1/3,-4,1,0),ts=10,r=6,layout=i})
    sevBtns[#sevBtns+1]={s=sDef[1],k=sDef[2],b=b}
    hook(b.MouseButton1Click,function()chosenSev=sDef[1];paintSev()end)
  end
  paintSev()

  local subjBox=field(tabNew,T("fb_subj"),"",false)
  subjBox.PlaceholderText=T("fb_bug_subj_ph")
  local descBox=field(tabNew,T("fb_desc"),"",true)
  descBox.Size=u2(1,0,0,76)
  descBox.PlaceholderText=T("fb_bug_desc_ph")
  local stepsBox=field(tabNew,T("fb_steps"),"",true)
  stepsBox.Size=u2(1,0,0,54)
  stepsBox.PlaceholderText=T("fb_steps_ph")

  local attachDiag=true
  F.switch(tabNew,T("fb_attach_diag"),function()return attachDiag end,function(v)attachDiag=v end)

  local sendBtn=tbtn(tabNew,"🐛 "..T("fb_send_bug"),{key="danger",h=36,ts=12})
  hook(sendBtn.MouseButton1Click,function()
    F.submitFeedback("bug",{
      category=chosenArea,
      severity=chosenSev,
      title=subjBox.Text,
      content=descBox.Text,
      steps=stepsBox.Text,
      attachDiag=attachDiag,
    },function(ok)
      if ok then
        subjBox.Text="";descBox.Text="";stepsBox.Text=""
        bHist.Text="📬 "..T("fb_tab_hist").." ("..tostring(#(P.myFeedbacks or{}))..")"
        curTab=2;updateTabUI()
      end
    end)
  end)
  updateTabUI()
end
--- [F.openSettings] Mở hộp thoại Cài đặt tổng hợp (Hồ sơ nhanh, Cài đặt chung, Giao diện, Góp ý & Báo lỗi, Dữ liệu & Công cụ Quản trị)
function F.openSettings()S.reopenModal=F.openSettings local scr=F.modalBox(T("settings"),420,640)
  local wrap=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BackgroundTransparency=1},scr)list(wrap,8)
  local hd=mk("Frame",{Size=u2(1,0,0,76),BorderSizePixel=0,LayoutOrder=1},wrap)
  th(hd,"BackgroundColor3","cardBg");corner(hd,10);stroke(hd,"border",1,0.35)
  local grad=mk("UIGradient",{Rotation=15},hd)
  themed(grad,function(g)g.Color=ColorSequence.new(TH.cardBg,H.mix(TH.cardBg,TH.accent,0.15))end)
  F.makeFramedAvatar(hd,{px=48,pos=uo(10,14),z=2,uid=F.uidOf(P.username),customIc=(P.profIcon and P.profIcon~="")and P.profIcon or nil,pt=P.profTheme,strokeKey="accent",strokeThick=2,strokeTrans=0.2})
  lab(hd,F.disp(P.display or P.username),{size=u2(1,-230,0,20),pos=uo(66,10),bold=true,ts=15,trunc=true})
  lab(hd,"@"..P.username,{size=u2(1,-172,0,14),pos=uo(66,32),ts=10,key="muted",trunc=true})
  lab(hd,H.flag(P.country).." "..(H.countryName(P.country)or P.country).." ("..P.country..")",{size=u2(1,-172,0,16),pos=uo(66,48),ts=10,key="muted",trunc=true})
  local langBtn=tbtn(hd,"   "..(L=="en"and"EN"or"VI"),{key="bg2",ts=10,size=uo(52,26),r=6,pos=u2(1,-158,0,10)})
  F.lucide(langBtn,"globe",11,{pos=uo(7,7),key="accent"})
  hook(langBtn.MouseButton1Click,function()F.setLang(L=="en"and"vi"or"en");F.openSettings()end)
  local pBtn=tbtn(hd,"   "..(L=="en"and"Profile"or"Hồ Sơ"),{key="accent",ts=10,size=uo(94,26),r=6,pos=u2(1,-102,0,10)})
  F.lucide(pBtn,"userRound",11,{pos=uo(9,7),col=H.lum(TH.accent)>0.55 and rgb(20,20,24)or c3(1,1,1),themed=false})
  hook(pBtn.MouseButton1Click,function()F.openProfile(P.username)end)
  local tBtn=tbtn(hd,"   "..(L=="en"and"Theme"or"Giao diện"),{key="btnBg",ts=10,size=uo(94,26),r=6,pos=u2(1,-102,0,40)})
  F.lucide(tBtn,"palette",11,{pos=uo(9,7),key="accent"})
  hook(tBtn.MouseButton1Click,function()F.openTheme()end)
  local function sectionCard(icon,title)local c=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BorderSizePixel=0},wrap)
    themed(c,function(o)o.BackgroundColor3=TH.cardBg;o.BackgroundTransparency=F.surfaceAlpha("card")end);corner(c,8);stroke(c,"border",1,0.45);pad(c,10,8,10,10);list(c,6)local hdr=mk("Frame",{Size=u2(1,0,0,20),BackgroundTransparency=1},c)
    local sbar=mk("Frame",{Size=uo(3,12),Position=uo(0,4),BorderSizePixel=0},hdr);th(sbar,"BackgroundColor3","accent");corner(sbar,2)
    lab(hdr,string.upper(title),{size=u2(1,-10,1,0),pos=uo(8,0),ts=10,bold=true,key="accent"})return c end
  -- Khu vực Góp ý (Suggestions) & Báo cáo lỗi (Report Bugs) ngay trong Cài đặt
  local fbSec=sectionCard("",T("sec_feedback"))
  lab(fbSec,T("fb_intro"),{ts=11,key="muted",wrap=true,auto=true})
  local fbRow=row(fbSec,34)
  local sugBtn=rbtn(fbRow,T("suggest_btn"),{size=u2(0.5,-3,1,0),key="ok",ts=11,r=8})
  local bugBtn=rbtn(fbRow,T("bug_btn"),{size=u2(0.5,-3,1,0),key="danger",ts=11,r=8})
  hook(sugBtn.MouseButton1Click,function()F.openSuggestions(1)end)
  hook(bugBtn.MouseButton1Click,function()F.openBugReport(1)end)
  if(S.fbUnread or 0)>0 or #(P.myFeedbacks or{})>0 then
    local totalReplied=0
    for _,item in ipairs(P.myFeedbacks or{})do
      if item.status=="replied"or(type(item.replies)=="table"and #item.replies>0)then totalReplied=totalReplied+1 end
    end
    local histLabel=(S.fbUnread and S.fbUnread>0)
      and("🔔 "..(L=="en"and("You have "..S.fbUnread.." new reply/update from Developer!")or("Bạn có "..S.fbUnread.." phản hồi mới từ Developer!")))
      or("📬 "..T("fb_tab_hist").." ("..tostring(#(P.myFeedbacks or{})).." · "..tostring(totalReplied).." "..(L=="en"and"replied"or"phản hồi")..")")
    local histBtn=tbtn(fbSec,histLabel,{key=(S.fbUnread and S.fbUnread>0)and"accent"or"btnBg",h=28,ts=10,r=7})
    hook(histBtn.MouseButton1Click,function()S.fbUnread=0;F.openSuggestions(2)end)
  end
  local gen=sectionCard("",T("sec_general"))
  local function sw(key,tk,cb)F.switch(gen,T(tk),function()return P[key]end,function(v)P[key]=v;S.isDirty=true;if cb then cb()end end)end
  do
    local aeStateLbl
    local function updAeLbl()
      if not aeStateLbl or not aeStateLbl.Parent then return end
      if P.autoExecute==false then
        aeStateLbl.Text="⏸ "..(L=="en"and"Auto-Execute disabled"or"Đang tắt Auto-Execute")
        aeStateLbl.TextColor3=TH.muted
        return
      end
      local ready,kind=F.autoExecStatus()
      if ready then
        aeStateLbl.Text="✅ "..(L=="en"and("Auto-Execute Ready · "..kind)or("Sẵn sàng Rejoin · "..kind))
        aeStateLbl.TextColor3=TH.ok
      else
        aeStateLbl.Text="⚠️ "..(L=="en"and("Paste Script URL below for Delta rejoin ("..kind..")")or("Dán Script URL bên dưới để Delta tự chạy lại ("..kind..")"))
        aeStateLbl.TextColor3=TH.warn
      end
    end
    F.switch(gen,L=="en"and"Auto-Execute on Rejoin (IY)"or"Tự chạy lại khi Rejoin (Auto Execute)",function()return P.autoExecute~=false end,function(v)
      P.autoExecute=v;S.isDirty=true;F.save(true)
      if v then
        S.tpCheck=false;S.teleportQueued=false
        local ok=F.armAutoTeleport(false)
        F.toast(ok and(L=="en"and"Auto-Execute armed (queue_on_teleport)"or"Đã bật & xếp hàng Auto-Execute")or(L=="en"and"Executor lacks queue_on_teleport"or"Executor chưa hỗ trợ queue_on_teleport"),true)
      else
        if F.disarmAutoTeleport then F.disarmAutoTeleport()end
        F.toast(L=="en"and"Auto-Execute OFF"or"Đã tắt Auto-Execute khi Rejoin",true)
      end
      updAeLbl()
    end)
    aeStateLbl=lab(gen,"",{ts=10,bold=true,wrap=true,auto=true})
    local urlRow=row(gen,28)
    local urlIn=mk("TextBox",{Size=u2(1,-66,1,0),Text=tostring(P.scriptUrl or""),PlaceholderText=L=="en"and"Raw Script URL (optional if file cached)"or"Link Raw Script (nếu chạy bằng dán code)",ClearTextOnFocus=false,Font=fG,TextSize=10,BorderSizePixel=0,TextXAlignment=txL},urlRow)
    F.styleInput(urlIn,"text",false)
    local saveUrlB=rbtn(urlRow,L=="en"and"Save"or"Lưu",{size=uo(60,28),key="accent",ts=10,r=7})
    hook(saveUrlB.MouseButton1Click,function()
      local u=H.trim(urlIn.Text)
      if u~=""and not u:match("^https?://")then F.toast(L=="en"and"URL must start with https://"or"Link phải bắt đầu bằng https://",true);return end
      P.scriptUrl=u;ENV.CB46_SCRIPT_URL=u~=""and u or nil ENV.CB45_SCRIPT_URL=ENV.CB46_SCRIPT_URL
      if hasIO then S._savedUrl=u;pcall(writefile,"cb46_script_url.txt",u)end
      S.isDirty=true;F.save(true)
      S.tpCheck=false;S.teleportQueued=false
      if P.autoExecute~=false then F.armAutoTeleport(false)end
      updAeLbl();F.toast(L=="en"and"Saved Auto-Execute URL"or"Đã lưu Script URL cho Rejoin!",true)
    end)
    updAeLbl()
  end
  sw("notify","notify");sw("sound","sound");sw("bubble","bubble")sw("safeEmoji","safe_emoji",F.rebuildFeed)sw("showGame","share",function()F.heartbeat(false)end)sw("group","group_msgs",F.rebuildFeed)
  sw("preview","preview");sw("compact","compact",F.layout)sw("sameUser","same_user")
  sw("showTyping","show_typing",function()
    if not P.showTyping and S.wasTyping then
      S.wasTyping=false;S.lastType=0
      F.publish({type="typing",author=P.username,chan=S.chan,stop=true},"fast")
    end
  end)
  sw("showSeen","show_seen",function()
    if P.showSeen and S.booted then F.markChannelSeen(S.chan)end
  end)local app=sectionCard("",T("sec_appear"))lab(app,T("quick_theme"),{ts=10,bold=true,key="muted"})
  local qThemes={{"aurora","Aurora ✨"},{"synthwave","Synthwave ✨"},{"tokyo_night","Tokyo Night"},{"obsidian_gold","Obsidian Gold"},{"cotton_candy","Cotton Candy"},{"midnight","Midnight"},}
  local qGrid=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BackgroundTransparency=1},app)mk("UIGridLayout",{CellSize=u2(1/3,-4,0,28),CellPadding=uo(4,4),SortOrder=soLO},qGrid)for i,qt in ipairs(qThemes)do
    local t=THEMES[qt[1]]local b=mk("TextButton",{Text=qt[2],Font=fGB,TextSize=10,BackgroundColor3=H.hex(t.bg2),TextColor3=H.hex(t.text),BorderSizePixel=0,LayoutOrder=i,},qGrid)corner(b,6)
    mk("UIStroke",{Color=H.hex(t.accent),Thickness=P.themeName==qt[1]and 1.6 or 1,Transparency=P.themeName==qt[1]and 0 or 0.5,ApplyStrokeMode=smBorder},b)hook(b.MouseButton1Click,function()
      P.themeName=qt[1];P.custom={};F.paintTheme();S.isDirty=true;F.save(true);F.openSettings()end)end
  do
    local modeRow=row(app,26)
    for idx,md in ipairs({{"solid","Solid"},{"gradient","Chroma"},{"mesh","Mesh"},{"glass","Glass"},{"image",L=="en"and"Image"or"Ảnh"}})do
      local on=(P.backgroundMode==md[1])
      local mb=rbtn(modeRow,md[2],{size=u2(0.2,-3,1,0),key=on and"accent"or"btnBg",ts=9,r=6,layout=idx})
      hook(mb.MouseButton1Click,function()
        if md[1]=="image"and not H.assetId(P.backgroundImage or"")then
          local pt=type(P.profTheme)=="table"and P.profTheme or{}
          local cand=H.assetId(pt.bgImg or"")or H.assetId(P.profBanner or"")
          if cand then P.backgroundImage=cand else F.openTheme();return end
        end
        P.backgroundMode=md[1];F.paintTheme();F.rebuildFeed();S.isDirty=true;F.save(true);F.openSettings()
      end)
    end
    local fxRow=row(app,26)
    local fLbl=(FONT_MAP[P.fontFamily]and FONT_MAP[P.fontFamily].name)or"Gotham"
    local fBtn=rbtn(fxRow,"Font: "..fLbl,{size=u2(0.5,-3,1,0),key="btnBg",ts=10,r=6})
    hook(fBtn.MouseButton1Click,function()
      local nxt=FONT_ORDER[1]
      for i,fk in ipairs(FONT_ORDER)do if fk==P.fontFamily then nxt=FONT_ORDER[(i%#FONT_ORDER)+1];break end end
      P.fontFamily=nxt;F.paintTheme();F.rebuildFeed();S.isDirty=true;F.save(true);F.openSettings()
    end)
    local msOrder={"card","flat","minimal"}
    local msBtn=rbtn(fxRow,(L=="en"and"Msg: "or"Tin: ")..tostring(P.msgStyle or"card"),{size=u2(0.5,-3,1,0),key="btnBg",ts=10,r=6})
    hook(msBtn.MouseButton1Click,function()
      local nxt=msOrder[1]
      for i,mk2 in ipairs(msOrder)do if mk2==P.msgStyle then nxt=msOrder[(i%#msOrder)+1];break end end
      P.msgStyle=nxt;F.rebuildFeed();S.isDirty=true;F.save(true);F.openSettings()
    end)
    local stRow=row(app,26)
    local bFrameMain=rbtn(stRow,L=="en"and"Frame Wallpaper"or"Căn Ảnh Nền",{size=u2(1,0,1,0),key="btnBg",ts=10,r=6,layout=1})
    F.lucide(bFrameMain,"crop",11,{pos=uo(10,7),key="accent"})
    hook(bFrameMain.MouseButton1Click,function()
      local imgId=H.assetId(P.backgroundImage or"")
      if not imgId then F.openTheme();return end
      F.openImageCropStudio({target="wallpaper",assetId=imgId,cfg=P.bgFrame,
        onLiveChange=function(st)P.backgroundImage=st.id;P.bgFrame={fit=st.fit,zoom=st.zoom,x=st.x,y=st.y,aspect=st.aspect};F.applyMainWallpaper(false)end,
        onApply=function(st)P.backgroundImage=st.id;P.bgFrame={fit=st.fit,zoom=st.zoom,x=st.x,y=st.y,aspect=st.aspect};F.paintTheme();S.isDirty=true;F.save(true);F.toast(T("theme_ok"),true)end,
        onCancel=function()F.paintTheme()end})
    end)
  end
  local tt=tbtn(app,T("theme_studio"),{key="accent",h=32})hook(tt.MouseButton1Click,F.openTheme)
  F.slider(app,T("text_size"),11,20,P.textSize,{step=1,fmt=function(v)return v.."px"end,
    onChange=function(v)P.textSize=v;U.input.TextSize=v;if U.inputRich then U.inputRich.TextSize=v end;if F.updateTokenFeedback then F.updateTokenFeedback(U.input.Text)end end,
    onDone=function()S.isDirty=true;F.rebuildFeed()end,})local wr=row(app,28)
  local function wb(txt,fnc)local b=rbtn(wr,txt,{size=u2(0.25,-4,1,0),ts=10})
    hook(b.MouseButton1Click,function()fnc();S.winX=nil;P.winX=nil;P.winY=nil;F.layout();S.isDirty=true;F.save(true);F.closeModal()end)end wb(T("nano_cube"),function()P.W,P.H=60,60 end)wb(T("small"),function()P.W,P.H=300,400 end)
  wb(T("mid"),function()P.W,P.H=IS_MOBILE and 340 or 520,IS_MOBILE and 480 or 560 end)wb(T("fit_screen"),function()local v=viewNow();P.W,P.H=v.X-12,v.Y-12 end)
  local tp=tbtn(app,T("toast_pos")..": "..P.toastPos,{h=28,ts=11})hook(tp.MouseButton1Click,function()local nx={tl="tr",tr="br",br="bl",bl="tl"}P.toastPos=nx[P.toastPos]or"tr"tp.Text=T("toast_pos")..": "..P.toastPos
    F.layout();S.isDirty=true end)local dat=sectionCard("",T("sec_data"))local dr=row(dat,28)local ex=rbtn(dr,T("backup_copy"),{ts=11})hook(ex.MouseButton1Click,function()F.copyText(F.exportSettings())end)
  local cc=rbtn(dr,T("clear_cache"),{ts=11})hook(cc.MouseButton1Click,function()S.reactions,S.polls,S.warns,S.reports={},{},{},{}S.isDirty=true;F.toast(T("cache_cleared"),true)end)
  local im=field(dat,"","");im.PlaceholderText=T("backup_paste")local ib=tbtn(dat,T("backup_import"),{h=28,ts=11})hook(ib.MouseButton1Click,function()
    if F.importSettings(im.Text)then F.toast(T("backup_ok"),true);F.openSettings()else F.toast(T("backup_bad"),true)end end)if F.isStaff(P.username)then local dev=sectionCard("",T("dev_hub"))local r1=row(dev,30)
    local hb=rbtn(r1,"/ "..T("help_title"),{ts=11});hook(hb.MouseButton1Click,function()F.openHelp()end)local db=rbtn(r1,T("diag"),{ts=11});hook(db.MouseButton1Click,function()F.openDiag()end)local r2=row(dev,30)
    local ab=rbtn(r2,T("admin"),{key="accent",ts=11});hook(ab.MouseButton1Click,function()F.openAdmin()end)if F.isDev(P.username)then
      local rb=rbtn(r2,T("roles"),{key="accent",ts=11});hook(rb.MouseButton1Click,function()F.openRoles()end)end
    local r3=row(dev,30)local emB=rbtn(r3,T("dev_manage_emoji"),{key="warn",ts=11})
    hook(emB.MouseButton1Click,function()P.emojiTab="shared"F.openEmoji({tab="shared",title=T("dev_manage_emoji_title"),onPick=function()end})end)local scB=rbtn(r3,T("dev_manage_script"),{key="ok",ts=11})
    hook(scB.MouseButton1Click,function()F.closeModal()F.selectChannel("scripts")end)else local misc=sectionCard("",T("sec_dev"))local r1=row(misc,30)
    local hb=rbtn(r1,"/ "..T("help_title"),{size=u2(1/3,-3,1,0),ts=10});hook(hb.MouseButton1Click,function()F.openHelp()end)local db=rbtn(r1,T("diag"),{size=u2(1/3,-3,1,0),ts=10});hook(db.MouseButton1Click,function()F.openDiag()end)
    local rq=rbtn(r1,S.myRequest and T("request_pending")or T("request_title"),{size=u2(1/3,-3,1,0),key=S.myRequest and"warn"or"accent",ts=10});hook(rq.MouseButton1Click,F.openRequest)end
  local st=tbtn(wrap,T("stop"),{key="danger",h=34})hook(st.MouseButton1Click,function()F.stop()end)lab(wrap,"CB46.0 · "..EXEC.." · "..(S.lpOn and"long-poll"or"poll"),{ts=10,key="muted",align=txC})end
--- [F.openHelp] Mở hộp thoại Hướng dẫn sử dụng và danh sách các lệnh Slash (`/cmd`)
function F.openHelp()S.reopenModal=F.openHelp local scr=F.modalBox(T("help_title"),360,480)for i,c in ipairs(F.cmdList)do if(not c.staff or F.isStaff(P.username))and(not c.dev or F.isDev(P.username))then
      local b=mk("TextButton",{Size=u2(1,0,0,40),Text="",BorderSizePixel=0,LayoutOrder=i},scr)th(b,"BackgroundColor3","cardBg");corner(b,8);stroke(b,"border",1,0.5)
      lab(b,"/"..c.name..(c.arg and(" "..c.arg)or""),{size=u2(1,-12,0,18),pos=uo(10,3),bold=true,key="accent"})lab(b,T(c.desc),{size=u2(1,-12,0,16),pos=uo(10,21),ts=10,key="muted",trunc=true})
      hook(b.MouseButton1Click,function()F.closeModal();U.input.Text="/"..c.name.." ";U.input:CaptureFocus()end)end end end
--- [F.diagText] Tạo báo cáo văn bản chẩn đoán chi tiết về trạng thái mạng, Máy chủ Boss/Backup, độ trễ RTT và bộ nhớ
function F.diagText()local nM,nF=0,0 for _ in pairs(S.msgs)do nM=nM+1 end
  for _ in pairs(S.frames)do nF=nF+1 end
  local roleTag=H.proxyRoleLabel(CFG.PROXY,NET.idx)
  return tconcat({
    "CB46.0 · "..EXEC.." · "..(IS_MOBILE and"mobile"or"pc"),
    "user: "..P.username.." ("..P.userId..")",
    "server: "..roleTag.." · "..CFG.PROXY,
    "mode: "..(S.lpOn and"long-poll"or"poll").." · fails "..S.pollFail.." · lastOk "..string.format("%.1f",os.clock()-S.lastPollOk).."s ago",
    "rtt: "..(S.rtt and(floor(S.rtt).."ms")or"n/a").." · sent ok/fail: "..S.sendOk.."/"..S.sendFail,
    "seq: "..H.num(S.lastSeq).." · rolesSeq: "..H.num(S.rolesSeq),
    "queue send/other/fast: "..#NET.lanes.send.."/"..#NET.lanes.other.."/"..#NET.lanes.fast,
    "msgs "..nM.." · frames "..nF.." · theme-reg "..#reg,
  },"\n")
end
--- [F.openDiag] Mở hộp thoại Chẩn đoán kết nối (Diagnostics) kèm kiểm tra `/api/health` & trạng thái Auto Failover
function F.openDiag()
  S.reopenModal=F.openDiag
  local scr=F.modalBox(T("diag"),380,440)
  local info=lab(scr,F.diagText(),{wrap=true,auto=true,ts=11})
  info.Font=fCode
  local routeL=lab(scr,string.format("auto-failover: #1 -> #%d (active: #%d)",#PROXY_POOL,NET.idx),{wrap=true,auto=true,ts=10,key="accent"})
  routeL.Font=fCode
  local hl=lab(scr,"server: …",{wrap=true,auto=true,ts=11,key="muted"})
  hl.Font=fCode
  local function health()
    enqueue("other","GET","/api/health",nil,function(d,err)
      if not hl.Parent then return end
      if d and d.ok then
        hl.Text=string.format("%s · %s · store=%s · online=%s · items=%s · emojis=%s · scripts=%s · up=%ss",H.proxyRoleLabel(CFG.PROXY,NET.idx),tostring(d.build),tostring(d.store),tostring(d.online),tostring(d.items),tostring(d.emojis or 0),tostring(d.scripts or 0),tostring(d.uptime))
      else
        hl.Text="server: error "..tostring(err)
      end
    end)
  end
  health()

  local r1=row(scr,30)
  local pg=rbtn(r1,T("ping"),{key="accent"})
  hook(pg.MouseButton1Click,function()
    local t0=os.clock()
    enqueue("other","GET","/api/ping",nil,function(d)
      F.toast(d and d.ok and string.format("%d ms",floor((os.clock()-t0)*1000))or"Error",true)
    end)
  end)
  local rs=rbtn(r1,T("resync"))
  hook(rs.MouseButton1Click,function()
    S.lastSeq=0;S.pollFail=0;S.lpOn=CFG.LONGPOLL>0
    F.toast(T("resync"),true)
    F.closeModal()
  end)
  local cp=tbtn(scr,T("diag_copy"),{h=30})
  hook(cp.MouseButton1Click,function()F.copyText(F.diagText())end)
  local rf=tbtn(scr,"Refresh",{h=28})
  hook(rf.MouseButton1Click,function()info.Text=F.diagText();routeL.Text=string.format("auto-failover: #1 -> #%d (active: #%d)",#PROXY_POOL,NET.idx);health()end)
end

-- =============================================================================
-- 21. ÂM THANH THÔNG BÁO, BONG BÓNG CHAT 3D TRÊN ĐẦU NHÂN VẬT & XỬ LÝ GÓI TIN
-- =============================================================================
--- [F.pingSound] Phát âm thanh thông báo khi có tin nhắn nhắc tên (`@mention`) hoặc tin nhắn riêng (DM)
function F.pingSound()
  if not P.sound then return end
  pcall(function()local s=Instance.new("Sound")s.SoundId=CFG.MENTION_SOUND;s.Volume=0.6;s.Parent=SoundService s:Play();Debris:AddItem(s,3)end)end
--- [F.findPlayerHead] Tìm bộ phận `Head` của nhân vật người chơi `author` đang ở trong cùng server game
function F.findPlayerHead(author)
  if not author or author==""then return nil,nil end
  local ln=tostring(author):lower()local targetPl=nil for _,pl in ipairs(Players:GetPlayers())do if pl.Name:lower()==ln then targetPl=pl;break end end
  if not targetPl then return nil,nil end
  local ch=targetPl.Character if not ch then return nil,targetPl end
  local head=ch:FindFirstChild("Head")or ch:FindFirstChild("HumanoidRootPart")or ch.PrimaryPart
  return head,targetPl end
--- [F.billboardContainer] Lấy hoặc tạo thư mục chứa các bảng `BillboardGui` trong `PlayerGui`
function F.billboardContainer(head)local pg=LP and LP:FindFirstChildOfClass("PlayerGui")return pg or head end
--- [F.calcBubbleOffset] Tính khoảng cách đặt bong bóng chat ngay trên đầu nhân vật (tự động hạ thấp mượt mà khi ở trong không gian hẹp / trần thấp)
function F.calcBubbleOffset(head,ch)
  local offsetY=2.15
  pcall(function()
    if workspace and workspace.Raycast and head and head.Position then
      local rp=RaycastParams.new()
      rp.FilterType=Enum.RaycastFilterType.Exclude
      rp.FilterDescendantsInstances={ch or head,LP and LP.Character or nil}
      local hit=workspace:Raycast(head.Position,Vector3.new(0,4.8,0),rp)
      if hit and hit.Distance and hit.Distance<3.8 then
        offsetY=clamp(hit.Distance-1.2,0.85,offsetY)
      end
    end
  end)
  return Vector3.new(0,offsetY,0)
end
--- [F.bubble] Hiển thị bong bóng chat 3D (`BillboardGui`) trên đầu nhân vật theo cơ chế Roblox BubbleChat (xếp chồng tối đa 3 tin, hiệu ứng pop-in, tự thu gọn khi ở xa hoặc không gian hẹp)
function F.bubble(author,text,chan)if not P.bubble then return end
  chan=tostring(chan or"general")if chan~="general"and chan~="game"then return end
  pcall(function()local head,pl=F.findPlayerHead(author)if not head then return end local key=pl and pl.Name or tostring(author)
    local ch=pl and pl.Character
    local segs,imgCount,hasText=F.parseInlineSegments(text)local plainTxt=F.disp(H.clip(F.plain(text),110))
    if plainTxt==""and imgCount==0 then return end
    local state=S.bubbles[key]
    if state and(not state.bb or not state.bb.Parent or state.bb.Adornee~=head)then
      pcall(function()if state.bb then state.bb:Destroy()end end)
      state=nil;S.bubbles[key]=nil
    end
    if not state then
      local bb=Instance.new("BillboardGui")
      bb.Name="CB46Bubble_"..key
      bb.Adornee=head
      bb.Size=uo(250,180)
      bb.SizeOffset=v2(0,0.5)
      bb.StudsOffset=F.calcBubbleOffset(head,ch)
      bb.AlwaysOnTop=true
      bb.MaxDistance=140
      bb.LightInfluence=0
      bb.Parent=F.billboardContainer(head)
      local tailWrap=Instance.new("Frame")
      tailWrap.Name="TailWrap"
      tailWrap.Size=uo(14,8)
      tailWrap.Position=u2(0.5,-7,1,-9)
      tailWrap.BackgroundTransparency=1
      tailWrap.ZIndex=0
      tailWrap.Parent=bb
      local tail=Instance.new("Frame")
      tail.Name="Tail"
      tail.Size=uo(8,8)
      tail.Position=uo(3,-4)
      tail.Rotation=45
      tail.BackgroundColor3=TH.bg2
      tail.BackgroundTransparency=0.04
      tail.BorderSizePixel=0
      tail.ZIndex=0
      tail.Parent=tailWrap
      local stack=Instance.new("Frame")
      stack.Name="Stack"
      stack.Size=u2(1,0,1,-8)
      stack.Position=uo(0,0)
      stack.BackgroundTransparency=1
      stack.ZIndex=2
      stack.Parent=bb
      mk("UIListLayout",{FillDirection=fdV,HorizontalAlignment=Enum.HorizontalAlignment.Center,VerticalAlignment=Enum.VerticalAlignment.Bottom,Padding=u1(0,4),SortOrder=soLO},stack)
      state={bb=bb,stack=stack,tail=tail,head=head,ch=ch,items={},seq=0}
      S.bubbles[key]=state
    else
      state.bb.StudsOffset=F.calcBubbleOffset(head,ch)
    end
    if S.sameBb and S.sameBb[key]then pcall(function()S.sameBb[key].Enabled=false end)end
    while #state.items>=3 do
      local oldest=tremove(state.items,1)
      if oldest and oldest.card then pcall(function()oldest.card:Destroy()end)end
    end
    state.seq=state.seq+1
    local topR=F.topRole(author)
    local strokeCol=(topR and H.hex(topR.color))or(F.isDev(author)and H.hex(F.DEVROLE.color))or TH.accent
    local bW,bH
    if not hasText and imgCount>0 then
      bW=clamp(imgCount*36+22,56,185)
      bH=44
    else
      local singleW=H.textW(plainTxt,12,fGB)
      bW=clamp(max(72,min(220,singleW+24+imgCount*24)),72,225)
      local innerW=max(48,bW-18)
      local okTs,ts=pcall(function()return TextService:GetTextSize(plainTxt,12,fGB,v2(innerW,500))end)
      local txtH=(okTs and ts and ts.Y)or(clamp(math.ceil((utf8.len(plainTxt)or#plainTxt)/24),1,4)*16)
      bH=clamp(txtH+14+(imgCount>0 and 20 or 0),28,115)
    end
    local card=Instance.new("Frame")
    card.Name="Bubble_"..state.seq
    card.Size=uo(bW,bH)
    card.BackgroundColor3=TH.bg2
    card.BackgroundTransparency=0.04
    card.BorderSizePixel=0
    card.LayoutOrder=state.seq
    card.ClipsDescendants=true
    card.Parent=state.stack
    corner(card,10)
    local st=mk("UIStroke",{Color=strokeCol,Thickness=1.3,Transparency=0.2,ApplyStrokeMode=smBorder},card)
    pad(card,9,5,9,5)
    state.tail.BackgroundColor3=TH.bg2
    local contentHolder=Instance.new("Frame")
    contentHolder.Name="Content"
    contentHolder.Size=us(1,1)
    contentHolder.BackgroundTransparency=1
    contentHolder.Parent=card
    local dotsLbl=Instance.new("TextLabel")
    dotsLbl.Name="FarDots"
    dotsLbl.Size=us(1,1)
    dotsLbl.BackgroundTransparency=1
    dotsLbl.Text="⋯"
    dotsLbl.TextColor3=TH.muted
    dotsLbl.Font=fGB
    dotsLbl.TextSize=16
    dotsLbl.Visible=false
    dotsLbl.Parent=card
    if imgCount==0 then
      local l=Instance.new("TextLabel")
      l.Size=us(1,1)
      l.BackgroundTransparency=1
      l.TextColor3=TH.text
      l.Font=fGB
      l.TextSize=12
      l.TextWrapped=true
      l.Text=plainTxt
      l.ZIndex=2
      l.Parent=contentHolder
    else
      local flow=Instance.new("Frame")
      flow.Size=us(1,1)
      flow.BackgroundTransparency=1
      flow.ZIndex=2
      flow.Parent=contentHolder
      mk("UIListLayout",{FillDirection=fdH,Wraps=true,Padding=u1(0,3),HorizontalAlignment=Enum.HorizontalAlignment.Center,VerticalAlignment=vaC,SortOrder=soLO},flow)
      local ord=0
      local emSz=hasText and 18 or 30
      for _,seg in ipairs(segs)do
        if seg.kind=="text"then
          for w in tostring(seg.text):gmatch("%S+")do
            ord=ord+1
            local wStr=F.disp(w)
            local wl=Instance.new("TextLabel")
            wl.Size=uo(max(6,H.textW(wStr,12,fGB)+2),16)
            wl.BackgroundTransparency=1
            wl.TextColor3=TH.text
            wl.Font=fGB
            wl.TextSize=12
            wl.Text=wStr
            wl.LayoutOrder=ord
            wl.Parent=flow
          end
        elseif seg.kind=="img"then
          ord=ord+1
          local ic=F.iconBox(flow,"img:"..seg.id,emSz,{layout=ord})
          ic.ZIndex=3
        end
      end
    end
    local sc=Instance.new("UIScale")
    sc.Scale=0.82
    sc.Parent=card
    pcall(function()TweenService:Create(sc,TweenInfo.new(0.16,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Scale=1}):Play()end)
    for idx,it in ipairs(state.items)do
      local ageRank=#state.items-idx+1
      if it.card and it.card.Parent then
        it.card.BackgroundTransparency=clamp(0.04+ageRank*0.1,0.04,0.35)
      end
    end
    local entry={card=card,stroke=st,content=contentHolder,dots=dotsLbl,w=bW,h=bH,ts=os.clock()}
    tinsert(state.items,entry)
    local totalH=12
    for _,it in ipairs(state.items)do totalH=totalH+(it.h or 28)+4 end
    state.bb.Size=uo(250,clamp(totalH,42,210))
    task.delay(8,function()
      if not S.bubbles[key]or S.bubbles[key]~=state then return end
      for i,it in ipairs(state.items)do
        if it==entry then tremove(state.items,i);break end
      end
      if card and card.Parent then
        pcall(function()TweenService:Create(card,TweenInfo.new(0.2,Enum.EasingStyle.Quad,Enum.EasingDirection.In),{BackgroundTransparency=1}):Play()end)
        task.delay(0.2,function()pcall(function()card:Destroy()end)end)
      end
      if #state.items==0 then
        if state.bb then pcall(function()state.bb:Destroy()end)end
        if S.bubbles[key]==state then S.bubbles[key]=nil end
        if S.sameBb and S.sameBb[key]and P.sameUser then pcall(function()S.sameBb[key].Enabled=true end)end
      else
        local newH=12
        for _,it in ipairs(state.items)do newH=newH+(it.h or 28)+4 end
        if state.bb and state.bb.Parent then state.bb.Size=uo(250,clamp(newH,42,210))end
      end
    end)
  end)end
--- [F.addMsg] Lưu trữ một tin nhắn mới vào bảng `S.msgs`, cập nhật thứ tự `S.order` và cắt bớt nếu vượt `CFG.MAX_MESSAGES`
function F.addMsg(m)S.orderN=S.orderN+1 m.order=S.orderN F.link(m)
  S.msgs[m.packetId]=m tinsert(S.order,m.packetId)
  if m.chan=="game"and tonumber(m.place)==game.PlaceId then S.gameSessionIds[m.packetId]=true end
  while#S.order>CFG.MAX_MESSAGES do
    local dropIdx=nil
    for i,oid in ipairs(S.order)do
      local om=S.msgs[oid]local op=S.polls[oid]
      local ch=(om and om.chan)or(op and op.chan)or""
      if ch~="announce"and ch~="punish"then dropIdx=i;break end
    end
    if not dropIdx then break end
    local old=tremove(S.order,dropIdx)local om=S.msgs[old]if om and S.lastByChan[om.chan]==om then S.lastByChan[om.chan]=nil end
    S.msgs[old]=nil;S.polls[old]=nil S.reactions[old]=nil S.gameSessionIds[old]=nil F.dropFrame(old)
  end end

-- Khôi phục tin nhắn kênh #game đã lưu trong cùng phiên chơi / khi người chơi vừa Rejoin tại đúng tựa game và thời điểm đó
;(function()if type(saved.gameChat)=="table"and tonumber(saved.gameChat.placeId)==game.PlaceId then
  local gc=saved.gameChat
  local age=os.time()-(tonumber(gc.savedAt)or 0)
  local sameJob=(tostring(gc.jobId or"")==""or tostring(gc.jobId)==tostring(game.JobId))
  if isRejoinSession or(age>=0 and age<=CFG.GAME_CACHE_TTL and sameJob)then
    if tonumber(gc.joinTs)and tonumber(gc.joinTs)>0 then S.joinTs=min(S.joinTs,tonumber(gc.joinTs))end
    for _,gm in ipairs(type(gc.msgs)=="table"and gc.msgs or{})do
      if type(gm)=="table"and gm.packetId and not S.msgs[gm.packetId]then
        F.markSeen(gm.packetId)
        local m={type="msg",packetId=tostring(gm.packetId),chan="game",author=tostring(gm.author or"?"),display=gm.display,uid=tonumber(gm.uid),
          content=tostring(gm.content or""),ts=tonumber(gm.ts)or H.now(),replyTo=gm.replyTo,replyAuthor=gm.replyAuthor,replySnippet=gm.replySnippet,
          place=game.PlaceId,job=gm.job}
        S.gameSessionIds[m.packetId]=true
        F.addMsg(m)
      end
    end
  end
end end)()
-- Khôi phục bộ nhớ đệm tin nhắn kênh #general ("Chung") đã lưu cục bộ để giữ lịch sử khi Server Backup khởi động lại
;(function()
  for _,gm in ipairs(type(saved.generalChat)=="table"and saved.generalChat or{})do
    if type(gm)=="table"and gm.packetId and not S.msgs[gm.packetId]then
      F.markSeen(gm.packetId)
      local m={type="msg",packetId=tostring(gm.packetId),chan="general",author=tostring(gm.author or"?"),display=gm.display,uid=tonumber(gm.uid),
        content=tostring(gm.content or""),ts=tonumber(gm.ts)or H.now(),replyTo=gm.replyTo,replyAuthor=gm.replyAuthor,replySnippet=gm.replySnippet,edited=gm.edited==true}
      if type(gm.reactions)=="table"then S.reactions[m.packetId]=gm.reactions end
      F.addMsg(m)
    end
  end
  local localOwn=0
  for _,m in pairs(S.msgs or{})do
    if type(m)=="table"and not m.deleted and tostring(m.author or""):lower()==P.username:lower()then localOwn=localOwn+1 end
  end
  P.msgCount=max(P.msgCount or 0,localOwn)
end)()
--- [F.process] Xử lý một gói tin nhận được từ máy chủ (tin nhắn, sửa/xóa, cảm xúc, bình chọn, quản trị, đồng bộ Role/Script)
function F.process(pkt,stale)if type(pkt)~="table"or not pkt.type then return end
  local t,id=pkt.type,pkt.packetId
  if id and F.markSeen(id)then return end
  local me=P.username if t=="msg"then
    local chan=tostring(pkt.chan or"general")
    if chan:match("^dm:grp_[%w_%-]+|")then chan="dm:"..chan:match("^dm:(grp_[%w_%-]+)")end
    if chan=="staff"and not F.isStaff(me)then return end
    local other=F.dmOther(chan)
    if chan:sub(1,3)=="dm:"and not other then return end
    if not id then return end
    if S.msgs[id]then
      if S.msgs[id].sending then S.msgs[id].sending=false;S.msgs[id].sent=true;S.msgs[id].failed=false;F.updateMsgStatus(id)end
      return
    end
    local pktPlace=tonumber(pkt.place)
    local pktJob=pkt.job and tostring(pkt.job)or nil
    local pktTs=tonumber(pkt.ts)or H.now()
    if chan=="game"then
      if pktPlace~=game.PlaceId then return end
      if pktJob and pktJob~=""and tostring(game.JobId)~=""and pktJob~=tostring(game.JobId)then return end
      if stale and not S.gameSessionIds[id]and pktTs<(S.joinTs-120)then return end
    end
    local m={type="msg",packetId=id,chan=chan,author=tostring(pkt.author or"?"),display=pkt.display,uid=tonumber(pkt.uid),content=tostring(pkt.content or""),ts=pktTs,sending=false,sent=true,failed=false,replyTo=pkt.replyTo,replyAuthor=pkt.replyAuthor,replySnippet=pkt.replySnippet,fwdFrom=pkt.fwdFrom,fwdChan=pkt.fwdChan,place=pktPlace,job=pktJob}
    if m.uid and m.uid>1 then S.uidCache=S.uidCache or{};S.uidCache[m.author]=m.uid;S.uidCache[m.author:lower()]=m.uid end
    F.rememberProfile(m.author,{display=m.display,userId=m.uid,mc=tonumber(pkt.mc),lastSeen=pktTs,placeId=pktPlace,gameName=pkt.gameName,jobId=pktJob},false)
    if m.author:lower()==me:lower()and tonumber(pkt.mc)and tonumber(pkt.mc)>(P.msgCount or 0)then P.msgCount=tonumber(pkt.mc);S.isDirty=true end
    F.addMsg(m)if other and not F.isGroupChan(chan)then P.dmList[other]=P.dmList[other]or H.now()end
    if chan=="game"or chan=="general"or chan=="announce"then S.isDirty=true end
    local mine=m.author==me
    if S.booted and chan==S.chan and F.visibleIn(m,S.chan)and F.matchSearch(m)and U.main.Visible then local was=F.nearBottom()F.renderMessage(m)
      if was or mine then F.scrollBottom()else S.newBelow=S.newBelow+1;task.defer(F.updateJump)end
      if not mine then F.markChannelSeen(chan)end
    elseif not mine and not stale then if other then S.dmUnread[chan]=(S.dmUnread[chan]or 0)+1
      elseif S.unread[chan]~=nil then S.unread[chan]=S.unread[chan]+1 end
      F.paintTabs()end if not mine and not stale then F.touchUser(m.author,m.uid,m.display)local ping=F.mentions(m.content)if ping or other then
        local head=F.disp(m.display or m.author)local body=P.preview and(": "..F.disp(H.clip(F.plain(m.content),70)))or""
        F.toast((ping and"@ "or"DM ")..head..body,false,function()U.main.Visible=true;U.mini.Visible=false;F.selectChannel(chan)end)F.pingSound()end
      F.bubble(m.author,m.content,chan)if not U.main.Visible then
        S.miniUnread=(S.miniUnread or 0)+1 U.miniBadge.Text=tostring(min(S.miniUnread,9));U.miniBadge.Visible=true end if S.typing[chan]then S.typing[chan][m.author]=nil;if chan==S.chan then F.refreshTypingLabel()end end end
    F.emit("message",m,stale)elseif t=="edit"then
    local m=S.msgs[pkt.target]if m and m.author==pkt.author then m.content=tostring(pkt.content or"");m.edited=true if S.frames[m.packetId]then F.dropFrame(m.packetId);F.renderMessage(m)end end elseif t=="delete"then
    local m=S.msgs[pkt.target]local p=S.polls[pkt.target]
    local actor=pkt.author or pkt.by
    if m then
      local allowDel=F.isStaff(actor)or F.isAdmin(actor)or(m.chan~="announce"and m.author==actor)
      if allowDel then m.deleted=true;F.dropFrame(m.packetId);F.onDeleted(m);S.isDirty=true end
    elseif p then
      local allowDel=F.isStaff(actor)or F.isAdmin(actor)or(p.chan~="announce"and p.author==actor)
      if allowDel then p.cleared=true;S.polls[pkt.target]=nil;F.dropFrame(pkt.target);S.isDirty=true end
    end elseif t=="react"then local e=tostring(pkt.emoji or"")
    if e==""then return end
    local hitScript=false for _,sc in ipairs(S.scripts or{})do if sc.id==pkt.target or sc.id==pkt.scriptId then sc.reactions=type(sc.reactions)=="table"and sc.reactions or{}
        sc.reactions[e]=type(sc.reactions[e])=="table"and sc.reactions[e]or{}sc.reactions[e][tostring(pkt.by)]=(pkt.action~="remove")and true or nil if not next(sc.reactions[e])then sc.reactions[e]=nil end hitScript=true end
    end if hitScript then S.isDirty=true if S.chan=="scripts"and U.main.Visible then F.rebuildFeed(true)end return end
    local map=F.reactionMap(pkt.target)map[e]=map[e]or{}
    map[e][tostring(pkt.by)]=(pkt.action~="remove")and true or nil S.isDirty=true F.renderReactions(pkt.target)
  elseif t=="script_post"then
    local sid=tostring(pkt.scriptId or id or"")if sid==""then return end
    for _,x in ipairs(S.scripts)do
      if x.id==sid then
        if pkt.author~=me and not stale and(S.chan~="scripts"or not U.main.Visible)then
          S.unread.scripts=(S.unread.scripts or 0)+1
          F.paintTabs()
        end
        return
      end
    end
    local topic={id=sid,title=tostring(pkt.title or"Untitled"),tag=tostring(pkt.tag or"Universal"),desc=tostring(pkt.desc or""),
      code=tostring(pkt.code or""),author=tostring(pkt.author or"?"),display=tostring(pkt.display or pkt.author or"?"),uid=tonumber(pkt.uid)or 1,placeId=tonumber(pkt.placeId)or 0,gameName=tostring(pkt.gameName or""),
      ts=tonumber(pkt.ts)or H.now(),reactions=type(pkt.reactions)=="table"and pkt.reactions or{},comments=type(pkt.comments)=="table"and pkt.comments or{},reports={},}tinsert(S.scripts,topic)S.isDirty=true
    F.rememberProfile(topic.author,{display=topic.display,userId=topic.uid,lastSeen=topic.ts,placeId=topic.placeId,gameName=topic.gameName},false)
    if S.chan=="scripts"and U.main.Visible then F.rebuildFeed(true)
    elseif pkt.author~=me and not stale then S.unread.scripts=(S.unread.scripts or 0)+1 F.paintTabs()end
  elseif t=="script_del"then local delSet={}for _,did in ipairs(type(pkt.ids)=="table"and pkt.ids or{pkt.id})do
      if did then delSet[tostring(did)]=true end end
    local keep={}for _,sc in ipairs(S.scripts or{})do if not delSet[tostring(sc.id)]then keep[#keep+1]=sc end end
    S.scripts=keep S.isDirty=true
    if S.chan=="scripts"and U.main.Visible then F.rebuildFeed(true)end
  elseif t=="script_comment"then
    local sid=tostring(pkt.scriptId or pkt.target or"")
    local cObj=type(pkt.comment)=="table"and pkt.comment or pkt
    local cid=tostring(pkt.commentId or cObj.id or id or H.uuid())
    for _,sc in ipairs(S.scripts or{})do
      if tostring(sc.id)==sid then
        sc.comments=type(sc.comments)=="table"and sc.comments or{}
        local exists=false
        for _,cm in ipairs(sc.comments)do if tostring(cm.id)==cid then exists=true;break end end
        if not exists then
          local cTxt=tostring(cObj.content or cObj.text or pkt.content or pkt.text or"")
          tinsert(sc.comments,{
            id=cid,
            author=tostring(cObj.author or pkt.author or"?"),
            display=tostring(cObj.display or pkt.display or cObj.author or pkt.author or"?"),
            uid=tonumber(cObj.uid or pkt.uid)or 1,
            content=cTxt,
            text=cTxt,
            ts=tonumber(cObj.ts or pkt.ts)or H.now()
          })
        end
        S.isDirty=true
        if S.chan=="scripts"and U.main.Visible then F.rebuildFeed(true)end
        break
      end
    end
  elseif t=="script_comment_del"then
    local sid=tostring(pkt.scriptId or pkt.target or"")
    local cid=tostring(pkt.commentId or pkt.id or"")
    for _,sc in ipairs(S.scripts or{})do
      if tostring(sc.id)==sid and type(sc.comments)=="table"then
        local keep={}
        for _,cm in ipairs(sc.comments)do if tostring(cm.id)~=cid then keep[#keep+1]=cm end end
        sc.comments=keep
        S.isDirty=true
        if S.chan=="scripts"and U.main.Visible then F.rebuildFeed(true)end
        break
      end
    end
  elseif t=="group_sync"then
    S.groups=type(S.groups)=="table"and S.groups or{}
    local act=tostring(pkt.action or"")
    local gObj=type(pkt.group)=="table"and pkt.group or(pkt.id and{
      id=tostring(pkt.id),
      name=tostring(pkt.name or"Group"),
      icon=tostring(pkt.icon or"👥"),
      owner=tostring(pkt.owner or pkt.by or"?"),
      members=type(pkt.members)=="table"and pkt.members or{},
      chan=tostring(pkt.chan or("dm:"..tostring(pkt.id))),
      ts=tonumber(pkt.ts)or H.now(),
    }or nil)
    local gid=tostring(pkt.id or pkt.groupId or(gObj and gObj.id)or"")
    if act=="delete"and gid~=""then
      local keep={}
      for _,g in ipairs(S.groups)do if tostring(g.id)~=gid then keep[#keep+1]=g end end
      S.groups=keep
      local curG=F.groupByChan(S.chan)
      if curG and tostring(curG.id)==gid then F.selectChannel("general")end
    elseif gObj and gObj.id then
      local isMember=false
      local myLow=tostring(P.username):lower()
      for _,m in ipairs(gObj.members or{})do
        if tostring(m):lower()==myLow then isMember=true;break end
      end
      if not isMember and not F.isStaff(P.username)then
        local keep={}
        for _,g in ipairs(S.groups)do if tostring(g.id)~=tostring(gObj.id)then keep[#keep+1]=g end end
        S.groups=keep
        local curG=F.groupByChan(S.chan)
        if curG and tostring(curG.id)==tostring(gObj.id)then F.selectChannel("general")end
      else
        local found=false
        for i,g in ipairs(S.groups)do
          if tostring(g.id)==tostring(gObj.id)then S.groups[i]=gObj;found=true;break end
        end
        if not found then tinsert(S.groups,gObj)end
      end
    end
    S.isDirty=true;F.paintTabs();F.updateInfo()
  elseif t=="typing"then local chan=tostring(pkt.chan or"general")
    if pkt.author and pkt.author~=me and not stale then
      F.touchUser(pkt.author)
      S.typing[chan]=S.typing[chan]or{}
      if pkt.stop==true then S.typing[chan][pkt.author]=nil else S.typing[chan][pkt.author]=os.clock()end
      if chan==S.chan then F.refreshTypingLabel()end
    end
  elseif t=="seen"then
    local viewer=tostring(pkt.by or pkt.author or"")
    if viewer~=""then
      local rawIds=type(pkt.ids)=="table"and pkt.ids or(pkt.target and{pkt.target}or{})
      local ts=tonumber(pkt.ts)or H.now()
      for _,rawId in ipairs(rawIds)do
        local mid=tostring(rawId or"")
        if mid~=""then
          S.seenBy[mid]=type(S.seenBy[mid])=="table"and S.seenBy[mid]or{}
          local m=S.msgs[mid]
          if not m or tostring(m.author or""):lower()~=viewer:lower()then
            S.seenBy[mid][viewer]=ts
            F.updateMsgStatus(mid)
          end
        end
      end
      S.isDirty=true
    end
  elseif t=="poll"then local pid=tostring(pkt.pollId or id)
    local chan=tostring(pkt.chan or"general")if S.polls[pid]or chan:sub(1,3)=="dm:"then return end if chan=="staff"and not F.isStaff(me)then return end
    S.orderN=S.orderN+1
    local p={id=pid,isPoll=true,q=tostring(pkt.question or""),o=type(pkt.options)=="table"and pkt.options or{},multi=pkt.multi==true,author=tostring(pkt.author or"?"),chan=chan,votes={},order=S.orderN,ts=tonumber(pkt.ts)or H.now(),exp=tonumber(pkt.expires_at)or 0}
    S.polls[pid]=p;tinsert(S.order,pid);S.isDirty=true if S.booted and chan==S.chan and U.main.Visible then F.renderPoll(p);F.scrollBottom()end elseif t=="poll_vote"then local p=S.polls[tostring(pkt.pollId)]if p then
      local v=tostring(pkt.voter)p.votes[v]=p.votes[v]or{}local c=tonumber(pkt.choice)if c then p.votes[v][c]=(pkt.action~="remove")and true or nil end
      if not p.multi and pkt.action~="remove"then for k in pairs(p.votes[v])do if k~=c then p.votes[v][k]=nil end end end if S.frames[p.id]then F.renderPoll(p)end
      S.isDirty=true end elseif t=="poll_close"then
    local p=S.polls[tostring(pkt.pollId)]if p and(pkt.closer==p.author or F.isAdmin(pkt.closer))then p.closed=true;if S.frames[p.id]then F.renderPoll(p)end end elseif t=="mute"or t=="unmute"or t=="warn"or t=="clear_warn"or t=="ban"or t=="unban"or t=="revoke"then
    if (F.isAdmin(pkt.by)or F.isDev(pkt.by))and pkt.target then
      local tg=tostring(pkt.target)local by=tostring(pkt.by or"?")local rs=tostring(pkt.reason or"")local ts=tonumber(pkt.ts)or H.now()local exp=tonumber(pkt.expires_at or pkt.exp)or 0
      if t=="mute"then F.applyMute(tg,{on=true,u=tg,reason=rs,exp=exp,by=by,ts=ts})
      elseif t=="unmute"then F.clearMuteState(tg)
      elseif t=="warn"then F.addWarnState(tg,{id=id,u=tg,reason=rs,by=by,ts=ts})
      elseif t=="clear_warn"then F.clearWarnState(tg,pkt.warnId,pkt.warnIndex)
      elseif t=="ban"then S.bannedMap[tg:lower()]={u=tg,reason=rs,exp=exp,by=by,ts=ts}if tg:lower()==me:lower()then S.banned={reason=rs,exp=exp,by=by,ts=ts}end
      elseif t=="unban"then S.bannedMap[tg:lower()]=nil if tg:lower()==me:lower()then S.banned=nil end end
      F.recordPunish({id=id,action=t,target=tg,by=by,reason=rs,exp=exp,ts=ts})
      if S.chan=="punish"and U.main.Visible then F.rebuildFeed(true)
      elseif by~=me and not stale then S.unread.punish=(S.unread.punish or 0)+1;F.paintTabs()end
      if not stale and tg:lower()==me:lower()then
        local actLbl=F.punishStyle(t)
        F.pingSound()
        F.toast(actLbl.." ("..T("by_staff").."@"..F.disp(by)..")"..(rs~=""and(": "..F.disp(rs))or""),true,function()U.main.Visible=true;U.mini.Visible=false;F.selectChannel("punish")end)
      end
    end
  elseif t=="punish_del"then
    if F.isStaff(pkt.by or pkt.author)then
      local tid=tostring(pkt.target or pkt.id or"")
      local keep={}for _,x in ipairs(S.punishments or{})do if tostring(x.id)~=tid then keep[#keep+1]=x end end
      S.punishments=keep;S.isDirty=true
      if S.chan=="punish"and U.main.Visible then F.rebuildFeed(true)end
    end
  elseif t=="report"then if F.isStaff(me)then
      tinsert(S.reports,{reporter=tostring(pkt.reporter),target=tostring(pkt.target),reason=tostring(pkt.reason or""),evidence=type(pkt.evidence)=="table"and pkt.evidence or{},isPublic=pkt.isPublic==true,ts=tonumber(pkt.ts)or H.now()})
      while#S.reports>60 do tremove(S.reports,1)end
      S.isDirty=true if not stale then F.toast(T("report")..": "..F.disp(pkt.target),false,F.openAdmin)end end elseif t=="report_ack"then
    if pkt.target==me and not stale then F.toast(T("ack"),true)end elseif t=="request"then if F.isStaff(me)then local dup=false for _,r in ipairs(S.requests)do if r.u==pkt.by then dup=true end end if not dup then
        tinsert(S.requests,{u=tostring(pkt.by),role=tostring(pkt.role or""),reason=tostring(pkt.reason or""),ts=tonumber(pkt.ts)or H.now()})
        if not stale then F.toast(T("request_title")..": "..F.disp(pkt.by),false,F.openAdmin)end end
      S.isDirty=true end if pkt.by==me then S.myRequest={u=me,role=pkt.role,reason=pkt.reason,ts=pkt.ts}end
  elseif t=="request_result"then if pkt.target==me and pkt.action=="approve"then S.forceRoles=true end if pkt.target==me and not stale then if pkt.action=="approve"then S.myRequest=nil
        F.toast(T("approve")..(pkt.role and(": "..pkt.role)or""),true)elseif pkt.action=="reject"then S.myRequest=nil F.toast(T("reject"),true)elseif pkt.action=="ban"then S.myRequest=nil
        F.toast(T("ban"),true)end end elseif t=="roles"then F.applyRoles(pkt,pkt.seq,false)elseif t=="roles_part"then if not S.roleParts then S.roleParts={}end
    local seq=tonumber(pkt.seq)or 0
    local total=tonumber(pkt.parts)or 0 local part=tonumber(pkt.part)or 0 if seq>0 and total>0 and part>0 then S.roleParts[seq]=S.roleParts[seq]or{by=pkt.by,total=total,got={},roles={},assign={}}local buf=S.roleParts[seq]
      if buf.total==total and not buf.got[part]then buf.got[part]=true for _,it in ipairs(type(pkt.items)=="table"and pkt.items or{})do if type(it)=="table"then if it.k=="r"and type(it.v)=="table"then tinsert(buf.roles,it.v)
            elseif it.k=="a"and type(it.u)=="string"and type(it.v)=="table"then buf.assign[it.u]=it.v end end end
        local gotN=0 for _ in pairs(buf.got)do gotN=gotN+1 end if gotN==buf.total then
          F.applyRoles({type="roles",by=buf.by,seq=seq,roles=buf.roles,assign=buf.assign},seq,false)S.roleParts[seq]=nil end end end elseif t=="feedback"then
    if tostring(pkt.author or""):lower()==me:lower()then
      F.upsertMyFeedback(pkt,false)
    elseif F.isStaff(me)then
      S.feedbacks=type(S.feedbacks)=="table"and S.feedbacks or{}
      tinsert(S.feedbacks,pkt)
      while #S.feedbacks>60 do tremove(S.feedbacks,1)end
      if not stale then
        F.toast((pkt.kind=="bug"and"🐛 Bug: "or"💡 Idea: ")..F.disp(pkt.author)..": "..H.clip(tostring(pkt.title or pkt.content or""),50),false,F.openAdmin)
      end
    end
  elseif t=="feedback_reply"then
    if tostring(pkt.target or""):lower()==me:lower()then
      F.upsertMyFeedback({
        id=pkt.feedbackId or pkt.id,
        packetId=pkt.packetId,
        kind=pkt.kind,
        seen=true,
        seenBy=pkt.by,
        by=pkt.by,
        status=pkt.status or(pkt.replyText and pkt.replyText~=""and"replied"or"seen"),
        replyKind=pkt.replyKind,
        replyText=pkt.replyText,
        ts=pkt.ts,
      },not stale)
    end
  elseif t=="presence"then
    local pu=tostring(pkt.u or pkt.author or"")
    if pu~=""and pu:lower()~=me:lower()then
      local rec=S.users[pu]or F.userRec(pu)or{}
      if pkt.off==true then
        rec.age=9999;rec.recvAt=0;rec.inGame=false;rec.jobId=""
        rec.lastSeen=tonumber(pkt.ts)or H.now()
        F.rememberProfile(pu,rec,false)
      else
        rec.display=pkt.d or rec.display or pu
        rec.userId=tonumber(pkt.id or pkt.uid)or rec.userId or 1
        if pkt.st~=nil then rec.status=tostring(pkt.st)end
        if pkt.bio~=nil then rec.bio=tostring(pkt.bio)end
        if pkt.c~=nil then rec.country=H.resolveCountry(pkt.c)end
        if pkt.pb~=nil then rec.profBanner=H.assetId(pkt.pb)or""end
        if pkt.pi~=nil then rec.profIcon=H.assetId(pkt.pi)or""end
        if pkt.pt~=nil then rec.profTheme=type(pkt.pt)=="table"and pkt.pt or{}end
        rec.inGame=(pkt.sg==true or(tonumber(pkt.pl)or 0)>0)
        rec.placeId=tonumber(pkt.pl)or 0
        rec.gameName=tostring(pkt.gn or"")
        rec.jobId=tostring(pkt.jb or"")
        rec.age=0;rec.recvAt=os.clock();rec.isScript=true
        rec._allowClear=true;F.rememberProfile(pu,rec,true);rec._allowClear=nil
      end
      S.users[pu]=rec
      F.updateInfo()
    end
  elseif t=="req_presence"then if pkt.author~=me and not stale then task.delay(0.4+math.random()*1.4,function()if NET.alive then F.heartbeat(false)end end)end end end
--- [F.ingest] Tiếp nhận toàn bộ gói dữ liệu trả về từ `/api/feed` (đồng bộ Devs, Presence, Emojis, Scripts, Groups, Roles và danh sách tin nhắn)
function F.ingest(data,first)
  if type(data.devs)=="table"then for _,n in ipairs(data.devs)do S.devs[tostring(n):lower()]=true end end
  S.strong=data.strong==true local nowMs=tonumber(data.nowMs)or 0 if type(data.users)=="table"then
    pcall(F.ingestPresence,{ok=true,now=data.now,users=data.users,mute=data.mute,banned=data.banned})end
  if type(data.emojis)=="table"then S.sharedEmojis=data.emojis S.emojiSeq=tonumber(data.emojiSeq)or 0 end
  if type(data.scripts)=="table"then
    local oldSs=S.scriptSeq S.scripts=data.scripts S.scriptSeq=tonumber(data.scriptSeq)or 0
    if S.scriptSeq~=oldSs then S.isDirty=true if S.chan=="scripts"and S.booted and U.main.Visible then pcall(F.rebuildFeed,true)end end
  end
  if type(data.groups)=="table"then
    local oldGs=S.groupSeq S.groups=data.groups S.groupSeq=tonumber(data.groupSeq)or S.groupSeq
    if S.groupSeq~=oldGs then S.isDirty=true;F.paintTabs();F.updateInfo()end
  end
  if type(data.feedbacks)=="table"then
    local oldFbs=S.feedbackSeq S.feedbackSeq=tonumber(data.feedbackSeq)or S.feedbackSeq
    local notifyNow=(S.booted and not first and S.feedbackSeq~=oldFbs)
    for _,fb in ipairs(data.feedbacks)do
      if type(fb)=="table"and fb.id then
        if tostring(fb.author or""):lower()==P.username:lower()then
          F.upsertMyFeedback(fb,notifyNow)
        end
      end
    end
    if F.isStaff(P.username)then S.feedbacks=data.feedbacks end
  end
  if type(data.announces)=="table"then
    local oldAs=S.announceSeq S.announceSeq=tonumber(data.announceSeq)or S.announceSeq
    local validAnn={}
    local changedAnn=(S.announceSeq~=oldAs)
    for _,am in ipairs(data.announces)do
      if type(am)=="table"and am.packetId then
        local pid=tostring(am.packetId)
        validAnn[pid]=true
        F.markSeen(pid)
        if am.type=="poll"then
          local exP=S.polls[pid]
          if not exP then
            S.orderN=S.orderN+1
            local p={id=pid,isPoll=true,q=tostring(am.question or""),o=type(am.options)=="table"and am.options or{},multi=am.multi==true,author=tostring(am.author or"?"),chan="announce",votes=type(am.votes)=="table"and am.votes or{},closed=am.closed==true,order=S.orderN,ts=tonumber(am.ts)or H.now(),exp=tonumber(am.expires_at)or 0}
            S.polls[pid]=p;tinsert(S.order,pid);changedAnn=true
          else
            exP.votes=type(am.votes)=="table"and am.votes or exP.votes
            exP.closed=am.closed==true or exP.closed
          end
        else
          local exM=S.msgs[pid]
          if not exM then
            local m={type="msg",packetId=pid,chan="announce",author=tostring(am.author or"?"),display=am.display,uid=tonumber(am.uid),content=tostring(am.content or""),ts=tonumber(am.ts)or H.now(),sending=false,sent=true,failed=false,replyTo=am.replyTo,replyAuthor=am.replyAuthor,replySnippet=am.replySnippet,fwdFrom=am.fwdFrom,fwdChan=am.fwdChan,edited=am.edited==true}
            if type(am.reactions)=="table"then S.reactions[pid]=am.reactions end
            F.addMsg(m);changedAnn=true
          else
            exM.sending=false;exM.sent=true
            if am.content and exM.content~=am.content then exM.content=tostring(am.content);exM.edited=am.edited==true;changedAnn=true end
            if type(am.reactions)=="table"then S.reactions[pid]=am.reactions end
          end
        end
      end
    end
    for id,m in pairs(S.msgs)do
      if m and m.chan=="announce"and not m.deleted and not validAnn[id]then
        m.deleted=true;F.dropFrame(id);F.onDeleted(m);changedAnn=true
      end
    end
    for id,p in pairs(S.polls)do
      if p and p.chan=="announce"and not p.cleared and not validAnn[id]then
        p.cleared=true;S.polls[id]=nil;F.dropFrame(id);changedAnn=true
      end
    end
    if changedAnn then S.isDirty=true if S.chan=="announce"and S.booted and U.main.Visible then pcall(F.rebuildFeed,true)end end
  end
  if type(data.mutesAll)=="table"then
    local newMutes={}
    for k,v in pairs(data.mutesAll)do
      if type(v)=="table"then
        local exp=tonumber(v.exp)or 0
        if exp==0 or exp>H.now()then
          newMutes[tostring(k):lower()]={on=true,u=tostring(v.u or k),reason=tostring(v.reason or""),exp=exp,by=tostring(v.by or""),ts=tonumber(v.ts)or 0}
        end
      end
    end
    S.mutes=newMutes
    local myM=newMutes[P.username:lower()]
    P.mute=myM or{on=false,reason="",exp=0,by=""}
    S.isDirty=true
  end
  if type(data.warnsAll)=="table"then
    local newWarns={}
    for k,v in pairs(data.warnsAll)do
      if type(v)=="table"and #v>0 then newWarns[tostring(k):lower()]=v end
    end
    S.warns=newWarns
    S.isDirty=true
  end
  if type(data.bannedAll)=="table"then
    local newBanned={}
    for k,v in pairs(data.bannedAll)do
      if type(v)=="table"then newBanned[tostring(k):lower()]=v end
    end
    S.bannedMap=newBanned
    S.isDirty=true
  end
  if type(data.punishments)=="table"then
    local oldMs=S.modSeq S.modSeq=tonumber(data.modSeq)or S.modSeq
    S.punishments=data.punishments
    if S.modSeq~=oldMs then S.isDirty=true if S.chan=="punish"and S.booted and U.main.Visible then pcall(F.rebuildFeed,true)end end
  end
  if type(data.seenBy)=="table"then
    S.seenSeq=tonumber(data.seenSeq)or S.seenSeq
    for mid,vmap in pairs(data.seenBy)do
      if type(vmap)=="table"then
        local smid=tostring(mid)
        S.seenBy[smid]=type(S.seenBy[smid])=="table"and S.seenBy[smid]or{}
        for viewer,ts in pairs(vmap)do
          S.seenBy[smid][tostring(viewer)]=tonumber(ts)or H.now()
        end
        F.updateMsgStatus(smid)
      end
    end
    S.isDirty=true
  end
  if type(data.roles)=="table"then
    F.applyRoles(data.roles,data.rolesSeq,true)S.forceRoles=false end
  local srv=tonumber(data.rolesSeq)or 0 if srv==0 and data.ready==true and F.isDev(P.username)and#S.roles>0 and os.clock()-(S.rolesRepub or-999)>60 then
    S.rolesRepub=os.clock();F.publishRoles(true)end
  local now=H.now()for _,m in ipairs(data.messages or{})do local seq=tonumber(m.seq)or 0 if seq>S.lastSeq then S.lastSeq=seq end
    local pkt=F.decode(m.c)if pkt then
      local stale if nowMs>0 and seq>0 then stale=first or(nowMs-seq>30000)else stale=first or(tonumber(pkt.ts)~=nil and now-pkt.ts>30)end
      local ok,err=pcall(F.process,pkt,stale)
      if not ok then warn("[CB46] process: "..tostring(err))end end end
  if S.lastSeq==0 then S.lastSeq=1 end
  if S.booted and U.main and U.main.Visible then F.markChannelSeen(S.chan)end end
--- [F.sendNow] Xử lý gửi nội dung trong ô nhập chat (thực thi lệnh `/slash`, lưu nội dung sửa, hoặc gửi tin nhắn mới)
function F.sendNow()local rawInput=H.trim(U.input.Text)if rawInput==""then return end
  if rawInput:sub(1,1)=="/"and F.slash(rawInput)then U.input.Text="";F.updateSuggest();return end if S.chan=="scripts"then F.openScriptComposer()return end if S.chan=="punish"then
    if F.isStaff(P.username)then F.openWarn("")else F.toast(T("punish_ro"),true)end return end if S.chan=="announce"and not F.canAnnounce(P.username)then
    F.toast(T("announce_ro"),true)return end
  local text=F.expandShortcodes(rawInput)if#text>CFG.MAX_CONTENT then F.toast(T("too_long"),true);return end if F.muted(P.username)then F.toast(T("muted"),true);return end
  if S.banned then F.toast(T("banned_you"),true);return end
  local lt=text:lower()if(lt:find("@everyone",1,true)or lt:find("@here",1,true))and not F.canMentionAll(P.username)then F.toast(T("no_ping"),true);return end
  if S.editing then local m=S.msgs[S.editing]if m and m.author==P.username then m.content=text;m.edited=true if S.frames[m.packetId]then F.dropFrame(m.packetId);F.renderMessage(m)end
      F.bubble(P.username,text,m.chan)
      F.publish({type="edit",target=m.packetId,author=P.username,content=text,chan=m.chan})end
    F.cancelCompose();U.input.Text="";return end
  local id=H.uuid()
  local isGame=(S.chan=="game")
  if isGame then S.hasChattedInGame=true end
  S.wasTyping=false;S.lastType=0
  P.msgCount=(P.msgCount or 0)+1
  F.rememberProfile(P.username,{mc=P.msgCount},true)
  local m={type="msg",packetId=id,chan=S.chan,author=P.username,display=P.display,uid=P.userId,content=text,ts=H.now(),mc=P.msgCount,sending=true,sent=false,failed=false,place=isGame and game.PlaceId or nil,job=isGame and tostring(game.JobId or"")or nil}
  if S.reply then m.replyTo,m.replyAuthor,m.replySnippet=S.reply.id,S.reply.author,S.reply.snippet end
  F.addMsg(m)local other=F.dmOther(S.chan)if other and not F.isGroupChan(S.chan)then P.dmList[other]=H.now()end
  F.renderMessage(m);F.scrollBottom()
  F.bubble(P.username,text,m.chan)U.input.Text="";F.cancelCompose();F.updateSuggest()S.activityAt=os.clock()
  if isGame or m.chan=="general"then S.isDirty=true;F.save(true)end
  F.publish({type="msg",packetId=id,chan=m.chan,author=m.author,display=m.display,uid=m.uid,content=text,ts=m.ts,mc=P.msgCount,replyTo=m.replyTo,replyAuthor=m.replyAuthor,replySnippet=m.replySnippet,place=m.place,job=m.job},"send",function(ok)
    m.sending=false
    if ok then
      m.sent=true;m.failed=false
      F.updateMsgStatus(id)
    else
      m.sent=false;m.failed=true
      F.dropFrame(id);F.renderMessage(m);F.toast(T("send_fail"),true)
    end end)S.isDirty=true end
--- [F.insertEmoji] Chèn mã shortcode `:name:` hoặc ký tự Emoji vào vị trí con trỏ trong ô nhập tin nhắn
function F.insertEmoji()F.openEmoji({title=T("emoji_pick"),onPick=function(e)e=tostring(e or"")
      if e==""then return end
      local tok=e if e:sub(1,4)=="img:"then local id=e:sub(5)local info=F.emojiInfoById(id)tok=(info and info.name)and(":"..info.name..":")or("[img:"..id.."]")local curTxt=U.input.Text
        local sep=(curTxt~=""and not curTxt:match("%s$"))and" "or""U.input.Text=curTxt..sep..tok.." "else U.input.Text=U.input.Text..tok end
      F.updateSuggest()task.defer(function()if U.input and U.input.Parent then
          pcall(function()U.input.CursorPosition=#U.input.Text+1 end)pcall(function()U.input:CaptureFocus()end)end end)end})end

-- =============================================================================
-- 22. ĐĂNG KÝ LỆNH SLASH (/CMD), TÔ MÀU TOKEN THỜI GIAN THỰC & GỢI Ý TỰ ĐỘNG
-- =============================================================================
F.cmds={}
F.cmdList={}
function
  F.command(name,desc,fn,opt)opt=opt or{}
  local c={name=name,desc=desc,fn=fn,staff=opt.staff,dev=opt.dev,arg=opt.arg}F.cmds[name]=c for _,a in ipairs(opt.alias or{})do F.cmds[a]=c end
  for i,x in ipairs(F.cmdList)do if x.name==name then tremove(F.cmdList,i)break end end tinsert(F.cmdList,c)return c end
--- [F.slash] Phân tích và thực thi lệnh Slash bắt đầu bằng dấu `/` từ ô nhập chat
function F.slash(text)local cmd,arg=text:match("^/(%S+)%s*(.*)$")if not cmd then return false end
  local c=F.cmds[cmd:lower()]if not c then return false end if c.dev and not F.isDev(P.username)then F.toast(T("no_perm"),true);return true end
  if c.staff and not F.isStaff(P.username)then F.toast(T("staff_only"),true);return true end
  local ok,err=pcall(c.fn,H.trim(arg))if not ok then F.toast("/"..cmd..": "..tostring(err),true)end return true end
local function withUser(arg,fn)if arg==""then fn(nil)return end arg=arg:gsub("^@","")for u in pairs(S.users)do if u:lower()==arg:lower()then fn(u)return end end
  -- Đăng ký danh sách các lệnh Slash (/shrug, /tableflip, /me, /pm, /r, /clear, /React, /online, /profile, /report, /mute, /warn, /unmute, /unwarn, /admin, /roles, /theme, /request, /settings, /status, /invite, /rejoin, /hop, /help, /diag, /back, /emoji, /poll, /scripts)
  F.resolveUser(arg,function(r)if r then fn(r.u)else F.toast(T("not_found"),true)end end)end
-- Lệnh /help: Mở danh sách hướng dẫn các lệnh Slash
F.command("help","c_help",function()F.openHelp()end,{alias={"?","commands"}})
-- Lệnh /online: Mở hộp thoại danh sách người dùng đang trực tuyến
F.command("online","c_online",function()F.openOnline()end,{alias={"who"}})
F.command("find","c_find",function(a)U.searchBox.Visible=true;U.searchBox.Text=a;F.layout()end,{alias={"search"},arg="<text>"})
F.command("dm","c_dm",function(a)if a==""then F.openDMList()else withUser(a,function(u)if u then F.openDM(u)end end)end end,{alias={"w","msg"},arg="<name>"})
F.command("general","c_general",function()F.selectChannel("general")end)
F.command("announce","announcetab",function()F.selectChannel("announce")end,{alias={"tb","thongbao"}})
F.command("punish","c_punish",function()F.selectChannel("punish")end,{alias={"warns","xuphat","vipham","modlog"}})
F.command("game","c_game",function()F.selectChannel("game")end)
-- Lệnh /scripts: Chuyển nhanh sang tab Diễn đàn chia sẻ Script (#scripts)
F.command("scripts","c_scripts",function()F.selectChannel("scripts")end,{alias={"script","forum"}})
F.command("staff","c_staff",function()F.selectChannel("staff")end,{staff=true})
-- Lệnh /profile: Xem hồ sơ cá nhân của bản thân hoặc người dùng khác
F.command("profile","c_profile",function(a)withUser(a,function(u)F.openProfile(u or P.username)end)end,{alias={"me","user"},arg="[name]"})
-- Lệnh /theme: Mở trình tùy chỉnh màu sắc giao diện (Theme Studio)
F.command("theme","c_theme",function()F.openTheme()end)
-- Lệnh /settings: Mở hộp thoại Cài đặt tổng hợp
F.command("settings","c_settings",function()F.openSettings()end,{alias={"set"}})
F.command("lang","c_lang",function()F.setLang(L=="en"and"vi"or"en")end)
-- Lệnh /poll: Mở hộp thoại tạo cuộc bình chọn mới
F.command("poll","c_poll",function()F.openPoll()end)
-- Lệnh /emoji: Mở bảng chọn và quản lý kho Emoji
F.command("emoji","c_emoji",function()F.insertEmoji()end)
-- Lệnh /report: Mở hộp thoại báo cáo người dùng vi phạm
F.command("report","c_report",function(a)withUser(a,function(u)F.openReport(u)end)end,{arg="[name]"})
-- Lệnh /roles (Developer): Mở trình quản lý và phân quyền Role
F.command("roles","c_roles",function()F.openRoles()end,{dev=true})
-- Lệnh /admin (Staff): Mở bảng điều khiển Quản trị (Admin Panel)
F.command("admin","c_admin",function()F.openAdmin()end,{staff=true})
-- Lệnh /mute (Staff): Mở hộp thoại cấm chat một người dùng
F.command("mute","c_mute",function(a)withUser(a,function(u)F.openMute(u)end)end,{staff=true,arg="[name]"})
-- Lệnh /warn (Staff): Mở hộp thoại cảnh báo một người dùng
F.command("warn","c_warn",function(a)withUser(a,function(u)F.openWarn(u)end)end,{staff=true,arg="[name]"})
-- Lệnh /unmute (Staff): Mở hộp thoại gỡ lệnh cấm chat kèm lý do cho một người dùng
F.command("unmute","c_unmute",function(a)withUser(a,function(u)F.openUnmute(u or"")end)end,{staff=true,alias={"clearmute"},arg="[name]"})
-- Lệnh /unwarn (Staff): Mở hộp thoại xóa cảnh báo kèm lý do của một người dùng
F.command("unwarn","c_unwarn",function(a)withUser(a,function(u)F.openClearWarn(u or"")end)end,{staff=true,alias={"clearwarn"},arg="[name]"})
-- Lệnh /ban (Staff): Mở hộp thoại cấm người dùng kèm lý do
F.command("ban","c_ban",function(a)withUser(a,function(u)F.openBan(u or"")end)end,{staff=true,arg="[name]"})
-- Lệnh /unban (Staff): Mở hộp thoại gỡ ban kèm lý do
F.command("unban","c_unban",function(a)withUser(a,function(u)F.openUnban(u or"")end)end,{staff=true,arg="[name]"})
-- Lệnh /react: Thả cảm xúc vào tin nhắn đang được chọn trả lời (Reply)
F.command("react","c_react",function(a)local m=S.reply and S.msgs[S.reply.id];if m and a~=""then F.doReact(m,a)end end,{arg="<emoji>"})
-- Lệnh /request: Mở biểu mẫu xin cấp Role
F.command("request","c_request",function()F.openRequest()end,{alias={"xin"}})
-- Lệnh /status: Đặt nhanh dòng trạng thái cá nhân
F.command("status","c_status",function(a)P.status=H.clip(a,80);S.isDirty=true;F.heartbeat(false);F.toast(T("status_set"),true)end,{arg="<text>"})
-- Lệnh /diag: Mở hộp thoại chẩn đoán kết nối và kiểm tra máy chủ
F.command("diag","c_diag",function()F.openDiag()end,{alias={"debug"}})
-- Lệnh /suggest: Mở hộp thoại Góp ý tính năng (Suggestions)
F.command("suggest","c_suggest",function()F.openSuggestions(1)end,{alias={"gopy","idea","suggestions"}})
-- Lệnh /bug: Mở hộp thoại Báo cáo lỗi (Report Bugs)
F.command("bug","c_bug",function()F.openBugReport(1)end,{alias={"bugs","reportbug","baoloi"}})
--- [F._missing] Hàm kiểm tra kiểu dữ liệu theo chuẩn mã nguồn mở Infinite Yield (`EdgeIY/infiniteyield`)
function F._missing(t,f,fallback)
  if type(f)==t then return f end
  return fallback
end
--- [F._queueteleport] Tìm hàm `queue_on_teleport` tương thích đa Executor (chuẩn Infinite Yield)
function F._queueteleport()
  local q=(type(ENV)=="table"and(rawget(ENV,"queue_on_teleport")or rawget(ENV,"queueonteleport")))or nil
  if type(q)~="function"then q=queue_on_teleport or queueonteleport end
  if type(q)~="function"then
    q=(type(syn)=="table"and syn.queue_on_teleport)
      or(type(fluxus)=="table"and fluxus.queue_on_teleport)
      or(type(delta)=="table"and delta.queue_on_teleport)
      or(type(krnl)=="table"and krnl.queue_on_teleport)
      or(type(codex)=="table"and codex.queue_on_teleport)
      or(type(arceus)=="table"and arceus.queue_on_teleport)
  end
  return F._missing("function",q)
end
do
local AUTO_PATHS={"cb46_source.lua","cb46_autorun.lua","cb45_source.lua","cb45_autorun.lua","CB.lua","CB.lua.txt","Scripts/CB.lua","Scripts/CB.txt","scripts/CB.lua","Delta/Scripts/CB.lua","Delta/Autoexecute/CB.lua","CB (Note ver 46.0) - Updated.lua","CB (Note ver 46.0).lua","CB (Note ver 45.0) - Updated.lua","CB (Note ver 45.0).lua","ChatBridge.lua","autoexec/cb46_autorun.lua","autoexec/cb45_autorun.lua","autoexec/CB.lua","cb44_source.lua","cb44_autorun.lua"}
local function isFullCBSource(s)
  return type(s)=="string"and #s>5000 and(s:find("CHAT BRIDGE CLIENT SCRIPT",1,true)~=nil or s:find("Chat Bridge v46",1,true)~=nil or s:find("Chat Bridge v45",1,true)~=nil or s:find("Chat Bridge v44",1,true)~=nil)and s:sub(1,60):find("__CB46_LOADER_STUB",1,true)==nil and s:sub(1,60):find("__CB45_LOADER_STUB",1,true)==nil
end
--- [F.autoExecStatus] Kiểm tra nhanh khả năng Auto-Execute thực tế (queue_on_teleport + mã nguồn/URL hợp lệ)
function F.autoExecStatus()
  if type(F._queueteleport())~="function"then return false,"No queue_on_teleport"end
  local src=rawget(ENV,"CB46_SOURCE")or rawget(ENV,"CB45_SOURCE")or rawget(ENV,"CB44_SOURCE")
  if isFullCBSource(src)then return true,"Local Cache"end
  if hasIO then
    for _,fn in ipairs(AUTO_PATHS)do
      local ok,r=pcall(readfile,fn)
      if ok and isFullCBSource(r)then return true,"Workspace File"end
    end
  end
  local u=H.trim(tostring((P and P.scriptUrl)or ENV.CB46_SCRIPT_URL or ENV.CB45_SCRIPT_URL or CFG.SCRIPT_URL or""))
  if u:match("^https?://")then return true,"Script URL"end
  return false,"Missing Source/URL"
end
--- [F.ensureAutorunFile] Lưu bản sao mã nguồn hoặc URL của riêng Script Chat Bridge này vào workspace để tự thực thi lại khi Rejoin / Teleport
function F.ensureAutorunFile()
  if not hasIO then return end
  pcall(function()
    local flagStr=(P.autoExecute~=false)and"1"or"0"
    if S._savedAutoFlag~=flagStr or not isfile("cb46_autoexec_on.txt")then
      if pcall(writefile,"cb46_autoexec_on.txt",flagStr)then S._savedAutoFlag=flagStr end
    end
    local effUrl=H.trim(tostring((P and P.scriptUrl)or ENV.CB46_SCRIPT_URL or ENV.CB45_SCRIPT_URL or CFG.SCRIPT_URL or""))
    if effUrl:match("^https?://")and(S._savedUrl~=effUrl or not isfile("cb46_script_url.txt"))then
      if pcall(writefile,"cb46_script_url.txt",effUrl)then S._savedUrl=effUrl end
    end
    local src=rawget(ENV,"CB46_SOURCE")or rawget(ENV,"CB45_SOURCE")or rawget(ENV,"CB44_SOURCE")or rawget(ENV,"CB43_SOURCE")or rawget(ENV,"CB42_SOURCE")
    if isFullCBSource(src)then
      ENV.CB46_SOURCE=src ENV.CB45_SOURCE=src
      if S._autorunLen==#src and isfile("cb46_source.lua")and isfile("cb46_autorun.lua")then return end
      pcall(writefile,"cb46_source.lua",src)
      pcall(writefile,"cb46_autorun.lua",src)
      S._autorunLen=#src
      return
    end
    for _,fn in ipairs(AUTO_PATHS)do
      local ok,r=pcall(readfile,fn)
      if ok and isFullCBSource(r)then src=r;break end
    end
    if not isFullCBSource(src)and not S._scannedAutoPaths then
      S._scannedAutoPaths=true
      local lf=rawget(ENV,"listfiles")or listfiles
      if type(lf)=="function"then
        for _,dir in ipairs({"",".","Scripts","scripts","Delta","Delta/Scripts","Delta/Autoexecute","autoexec","Autoexecute","workspace"})do
          local okL,files=pcall(lf,dir)
          if okL and type(files)=="table"then
            for _,fp in ipairs(files)do
              local sfp=tostring(fp or"")
              if sfp:lower():match("%.lua")or sfp:lower():match("%.txt$")then
                local okR,r=pcall(readfile,sfp)
                if okR and isFullCBSource(r)then src=r;break end
              end
            end
          end
          if isFullCBSource(src)then break end
        end
      end
    end
    if isFullCBSource(src)then
      ENV.CB46_SOURCE=src ENV.CB45_SOURCE=src
      pcall(writefile,"cb46_source.lua",src)
      pcall(writefile,"cb46_autorun.lua",src)
      S._autorunLen=#src
      return
    end
    local fallback=string.format([[
-- __CB46_LOADER_STUB
repeat task.wait() until game:IsLoaded() and game:GetService("Players").LocalPlayer
local env=(type(getgenv)=="function"and getgenv())or _G
local rf=rawget(env,"readfile")or readfile
local lf=rawget(env,"loadfile")or loadfile
for _,p in ipairs({"cb46_source.lua","cb45_source.lua","CB.lua","CB.lua.txt","Scripts/CB.lua","Scripts/CB.txt","scripts/CB.lua","Delta/Scripts/CB.lua","Delta/Autoexecute/CB.lua","CB (Note ver 46.0) - Updated.lua","CB (Note ver 46.0).lua","CB (Note ver 45.0) - Updated.lua","CB (Note ver 45.0).lua","ChatBridge.lua"})do
  if type(rf)=="function"then
    local ok,code=pcall(rf,p)
    if ok and type(code)=="string"and #code>1000 and not code:sub(1,60):find("__CB46_LOADER_STUB",1,true)and not code:sub(1,60):find("__CB45_LOADER_STUB",1,true)then
      local fn=loadstring(code)
      if fn then return fn()end
    end
  end
  if type(lf)=="function"then
    local ok,fn=pcall(lf,p)
    if ok and type(fn)=="function"then return fn()end
  end
end
local url=(env and(env.CB46_SCRIPT_URL or env.CB45_SCRIPT_URL or env.CB44_SCRIPT_URL or env.CB43_SCRIPT_URL))or %q
if (type(url)~="string"or #url<=8)and type(rf)=="function"then
  for _,uf in ipairs({"cb46_script_url.txt","cb45_script_url.txt"})do
    local okU,uRaw=pcall(rf,uf)
    if okU and type(uRaw)=="string"and #uRaw>8 then url=uRaw:gsub("^%%s+",""):gsub("%%s+$","")break end
  end
end
if type(url)=="string"and #url>8 then
  local ok,code=pcall(function()return game:HttpGet(url)end)
  if ok and type(code)=="string"and #code>40 then
    local fn=loadstring(code)
    if fn then return fn()end
  end
end
]],tostring(effUrl or""))
    pcall(writefile,"cb46_autorun.lua",fallback)
  end)
end
--- [F.disarmAutoTeleport] Tắt chế độ Auto-Execute khi Rejoin (chỉ áp dụng cho Script Chat Bridge này)
function F.disarmAutoTeleport()
  ENV.__CB46_AUTOEXEC_OFF=true ENV.__CB45_AUTOEXEC_OFF=true
  S.tpCheck=false
  S.teleportQueued=false
  S._autorunLen=nil
  local clr=(type(ENV)=="table"and(rawget(ENV,"clear_teleport_queue")or rawget(ENV,"clearteleportqueue")))or clear_teleport_queue or clearteleportqueue
  if type(clr)=="function"then pcall(clr)end
  if hasIO then
    pcall(writefile,"cb46_autoexec_on.txt","0")
    S._savedAutoFlag="0"
    if type(delfile)=="function"then pcall(delfile,"cb46_autorun.lua")pcall(delfile,"cb45_autorun.lua")end
  end
end
--- [F.markTeleporting] Đánh dấu trạng thái đang Rejoin / Teleport để giữ lại lịch sử chat In-Game (`#game`) của phiên hiện tại
function F.markTeleporting()
  S.isTeleporting=true
  S.quitting=false
  if hasIO then
    pcall(writefile,REJOIN_FILE,H.jenc({ts=os.time(),placeId=game.PlaceId,jobId=tostring(game.JobId or""),joinTs=S.joinTs})or"{}")
  end
  if F.save then F.save(true)end
end
--- [F.clearGameChatOnQuit] Xóa lịch sử chat `#game` được lưu tạm khi người chơi thoát hẳn game (không phải Rejoin)
function F.clearGameChatOnQuit()
  if S.isTeleporting then return end
  S.quitting=true
  if hasIO and type(delfile)=="function"then pcall(delfile,REJOIN_FILE)end
  if F.save then F.save(true)end
end
--- [F.buildTeleportPayload] Tạo đoạn mã nạp lại Chat Bridge theo cơ chế đợi tải trang & guard của Infinite Yield (có cache)
function F.buildTeleportPayload()
  local effUrl=H.trim(tostring((P and P.scriptUrl)or ENV.CB46_SCRIPT_URL or ENV.CB45_SCRIPT_URL or CFG.SCRIPT_URL or""))
  local cfgPath=tostring(FILE or"cb46_settings.json")
  if S._tpPayload and S._tpUrl==effUrl and S._tpCfg==cfgPath then return S._tpPayload end
  S._tpUrl,S._tpCfg=effUrl,cfgPath
  S._tpPayload=string.format([[
pcall(function()
  repeat task.wait() until game:IsLoaded() and game:GetService("Players").LocalPlayer
  local env=(type(getgenv)=="function"and getgenv())or _G
  if env.__CB46_AUTOEXEC_OFF or env.__CB45_AUTOEXEC_OFF then return end
  local rf=rawget(env,"readfile")or readfile
  if type(rf)=="function"then
    for _,ff in ipairs({"cb46_autoexec_on.txt","cb45_autoexec_on.txt"})do
      local okFlag,flag=pcall(rf,ff)
      if okFlag and type(flag)=="string"and flag:match("%%S")then
        if flag:match("^%%s*0%%s*$")then return end
        break
      end
    end
    local okCfg,cfgRaw=pcall(rf,%q)
    if okCfg and type(cfgRaw)=="string"and cfgRaw:find('"autoExecute"%%s*:%%s*false')then return end
  end
  local cur=env and(env.CB46 or env.CB45)
  if cur and cur.U and cur.U.gui and cur.U.gui.Parent then return end
  local paths={"cb46_source.lua","cb46_autorun.lua","cb45_source.lua","cb45_autorun.lua","CB.lua","CB.lua.txt","Scripts/CB.lua","Scripts/CB.txt","scripts/CB.lua","Delta/Scripts/CB.lua","Delta/Autoexecute/CB.lua","CB (Note ver 46.0) - Updated.lua","CB (Note ver 46.0).lua","CB (Note ver 45.0) - Updated.lua","CB (Note ver 45.0).lua","ChatBridge.lua"}
  if type(rf)=="function"then
    for _,fn in ipairs(paths)do
      local ok,src=pcall(rf,fn)
      if ok and type(src)=="string"and #src>200 and not src:sub(1,60):find("__CB46_LOADER_STUB",1,true)and not src:sub(1,60):find("__CB45_LOADER_STUB",1,true)then
        local f=loadstring(src)
        if f then task.spawn(f)return end
      end
    end
  end
  local url=(env and(env.CB46_SCRIPT_URL or env.CB45_SCRIPT_URL or env.CB44_SCRIPT_URL or env.CB43_SCRIPT_URL))or %q
  if (type(url)~="string"or #url<=8)and type(rf)=="function"then
    for _,uf in ipairs({"cb46_script_url.txt","cb45_script_url.txt"})do
      local okU,uRaw=pcall(rf,uf)
      if okU and type(uRaw)=="string"and #uRaw>8 then url=uRaw:gsub("^%%s+",""):gsub("%%s+$","")break end
    end
  end
  if type(url)=="string"and #url>8 then
    local ok,src=pcall(function()return game:HttpGet(url)end)
    if ok and type(src)=="string"and #src>200 then
      local f=loadstring(src)
      if f then task.spawn(f)end
    end
  end
end)
]],cfgPath,effUrl)
  return S._tpPayload
end
end
--- [F.armAutoTeleport] Đăng ký tự động chạy lại Chat Bridge qua `queue_on_teleport` chủ động ngay khi khởi động theo chuẩn Infinite Yield (`TeleportCheck`)
function F.armAutoTeleport(forceNow)
  if P.autoExecute==false then
    F.disarmAutoTeleport()
    return false
  end
  ENV.__CB46_AUTOEXEC_OFF=nil ENV.__CB45_AUTOEXEC_OFF=nil
  F.ensureAutorunFile()
  if forceNow then F.markTeleporting()end
  if S.tpCheck then return true end
  local qot=F._queueteleport()
  if type(qot)~="function"then return false end
  S.tpCheck=true
  local ok=pcall(qot,F.buildTeleportPayload())
  if ok then
    S.teleportQueued=true
    return true
  else
    S.tpCheck=false
    S.teleportQueued=false
    return false
  end
end
pcall(function()
  if LP and LP.OnTeleport then
    hook(LP.OnTeleport,function(tpState)
      if tpState==Enum.TeleportState.Failed then
        S.tpCheck=false;S.teleportQueued=false;S.isTeleporting=false
        return
      end
      if P.autoExecute~=false and(not S.tpCheck)then
        F.armAutoTeleport(true)
      else
        F.markTeleporting()
      end
    end)
  end
end)
pcall(function()
  hook(TeleportService.TeleportInitFailed,function()
    S.tpCheck=false;S.teleportQueued=false;S.isTeleporting=false
  end)
end)
pcall(function()
  local gs=game:GetService("GuiService")
  if gs and gs.ErrorMessageChanged then
    hook(gs.ErrorMessageChanged,function(errMsg)
      if tostring(errMsg or"")~=""and P.autoExecute~=false and(not S.tpCheck)then
        F.armAutoTeleport(true)
      end
    end)
  end
end)
pcall(function()
  hook(game.Close,function()
    if not S.isTeleporting then F.clearGameChatOnQuit()end
  end)
end)
pcall(function()
  hook(Players.PlayerRemoving,function(pl)
    if pl==LP and not S.isTeleporting then F.clearGameChatOnQuit()end
  end)
end)
-- Lệnh /invite: Gửi lời mời vào server game hiện tại lên khung chat
F.command("invite","c_invite",function(a)local note=H.trim(a)
  local msg=(note~=""and(note.." ")or("🎮 "..F.disp(S.placeName or"Server").." "))..string.format("[join:%s:%s]",tostring(game.PlaceId),tostring(game.JobId))U.input.Text=msg F.sendNow()
end,{alias={"joinme","party"},arg="[note]"})
F.command("fps","c_fps",function()local fps=floor(1/max(0.001,game:GetService("RunService").RenderStepped:Wait()))local rtt=S.rtt and(floor(S.rtt).."ms")or"—"
  F.toast(string.format("FPS: %d · Ping: %s · Players: %d/%d",fps,rtt,#Players:GetPlayers(),Players.MaxPlayers),true)end,{alias={"stats"}})
-- Lệnh /back: Quay trở về kênh chat trong game (#game)
F.command("back","c_back",function()F.selectChannel("game")end)
-- Lệnh /clear: Xóa trắng danh sách tin nhắn đang hiển thị trong kênh hiện tại (kênh #announce lưu trữ vĩnh viễn chỉ xóa bởi Dev/Admin)
F.command("clear","c_clear",function()
  if S.chan=="announce"then F.toast(T("announce_clear_block"),true);return end
  for _,id in ipairs(S.order)do
    local m=S.msgs[id]
    if m and F.visibleIn(m,S.chan)then m.cleared=true end
    local p=S.polls[id]
    if p and p.chan==S.chan then p.cleared=true end
  end
  F.rebuildFeed()
  F.toast("Cleared view",true)
end,{alias={"cls"}})
F.command("copyjob","c_copyjob",function()F.copyText(string.format("PlaceId: %s | JobId: %s",tostring(game.PlaceId),tostring(game.JobId)))end,{alias={"jobid","server"}})
-- Lệnh /rejoin: Tự động kết nối lại vào chính server Roblox hiện tại
F.command("rejoin","c_rejoin",function()
  F.markTeleporting();if P.autoExecute~=false then F.armAutoTeleport(true)end F.toast("Rejoining server...",true)pcall(function()TeleportService:TeleportToPlaceInstance(game.PlaceId,game.JobId,LP)end)end,{alias={"rj"}})
-- Lệnh /hop: Tìm và chuyển sang một server công cộng khác của cùng tựa game
F.command("hop","c_hop",function()
  F.markTeleporting();if P.autoExecute~=false then F.armAutoTeleport(true)end F.toast("Hopping to another server...",true)pcall(function()TeleportService:Teleport(game.PlaceId,LP)end)end,{alias={"serverhop"}})
--- [F.tokColors] Lấy bảng màu phản hồi trạng thái cú pháp (Hợp lệ / Đang gõ / Không hợp lệ) cho lệnh `/`, `@mention` và `:emoji:`
function F.tokColors()
  local mCol=TH.mentionText or TH.accent
  local eCol=TH.emojiText or TH.accent
  return{
    cmd_ok=H.ensureContrast(TH.ok,TH.bg2,4.2),
    cmd_wait=H.ensureContrast(TH.accent,TH.bg2,4.2),
    cmd_bad=H.ensureContrast(TH.danger,TH.bg2,4.2),
    men_ok=mCol,
    men_wait=H.ensureContrast(H.mix(mCol,TH.warn,0.4),TH.bg2,4.2),
    men_bad=H.ensureContrast(TH.danger,TH.bg2,4.2),
    emo_ok=eCol,
    emo_wait=H.ensureContrast(H.mix(eCol,TH.text,0.35),TH.bg2,4.2),
    emo_bad=H.ensureContrast(TH.danger,TH.bg2,4.2),
  }end
--- [F.mentionColorFor] Lấy màu sắc hiển thị nổi bật cho thẻ `@username` dựa theo Role cao nhất của người được nhắc tên
function F.mentionColorFor(u)
  local lu=tostring(u or""):lower()
  local base=TH.mentionText or TH.accent
  if lu==P.username:lower()then return H.ensureContrast(H.mix(base,TH.ok,0.35),TH.bg2,4.3)end
  if lu=="everyone"or lu=="here"or lu=="all"then return H.ensureContrast(H.mix(base,TH.warn,0.45),TH.bg2,4.3)end
  local role=F.topRole(u)
  if role and not P.custom.mentionText then return H.ensureContrast(H.mix(H.hex(role.color),base,0.45),TH.bg2,4.3)end
  return base
end
--- [F.resolveCmdToken] Kiểm tra tính hợp lệ và gợi ý cho token lệnh `/command` đang gõ
function F.resolveCmdToken(rawCmd)local TC=F.tokColors()local lc=tostring(rawCmd or""):lower()if lc==""then return{status="wait",col=TC.cmd_wait,label="/ (help, dm, scripts, emoji, poll...)"}end
  local exact=F.cmds[lc]if exact then
    local allowed=(not exact.staff or F.isStaff(P.username))and(not exact.dev or F.isDev(P.username))if allowed then return{status="ok",col=TC.cmd_ok,cmd=exact,
        label="/"..exact.name..(exact.arg and(" "..exact.arg)or"").." — "..T(exact.desc),}else return{status="bad",col=TC.cmd_bad,label="/"..rawCmd.." (Staff/Dev)"}end end for _,c in ipairs(F.cmdList)do
    if(not c.staff or F.isStaff(P.username))and(not c.dev or F.isDev(P.username))and c.name:sub(1,#lc)==lc then return{status="wait",col=TC.cmd_wait,cmd=c,label="/"..rawCmd.." -> /"..c.name.." ("..T(c.desc)..")",
      }end end return{status="bad",col=TC.cmd_bad,label="/"..rawCmd}end
--- [F.resolveMentionToken] Kiểm tra tính hợp lệ và tìm người dùng khớp với token `@username` đang gõ
function F.resolveMentionToken(name,isAtEnd)local TC=F.tokColors()local ln=tostring(name or""):lower()if ln==""then
    return{status="wait",col=TC.men_wait,label="@ (everyone, "..P.username.."...)"}end if ln=="everyone"or ln=="here"or ln=="all"then if F.canMentionAll(P.username)then
      return{status="ok",col=F.mentionColorFor(ln),label="@"..ln}else return{status="bad",col=TC.men_bad,label="@"..ln.." (Role)"}end end if ln==P.username:lower()or(P.display and P.display:lower()==ln)then
    return{status="ok",col=F.mentionColorFor(P.username),label="@"..P.username}end for u,r in pairs(S.users)do if u:lower()==ln or tostring(r.display or""):lower()==ln then return{status="ok",
        col=F.mentionColorFor(u),label="@"..u..(r.display and r.display~=u and(" ("..r.display..")")or""),}end end for _,pl in ipairs(Players:GetPlayers())do
    if pl.Name:lower()==ln or tostring(pl.DisplayName or""):lower()==ln then return{status="ok",col=F.mentionColorFor(pl.Name),
        label="@"..pl.Name..(pl.DisplayName and pl.DisplayName~=pl.Name and(" ("..pl.DisplayName..")")or""),}end end for u,r in pairs(S.users)do
    if u:lower():find(ln,1,true)or tostring(r.display or""):lower():find(ln,1,true)then return{status=isAtEnd and"wait"or"bad",col=isAtEnd and TC.men_wait or TC.men_bad,label="@"..name.." -> @"..u,}end
  end for _,pl in ipairs(Players:GetPlayers())do if pl.Name:lower():find(ln,1,true)or tostring(pl.DisplayName or""):lower():find(ln,1,true)then return{status=isAtEnd and"wait"or"bad",
        col=isAtEnd and TC.men_wait or TC.men_bad,label="@"..name.." -> @"..pl.Name,}end end if("everyone"):find(ln,1,true)==1 or("here"):find(ln,1,true)==1 then return{status=isAtEnd and"wait"or"bad",
      col=isAtEnd and TC.men_wait or TC.men_bad,label="@"..name.." -> @everyone",}end return{status="bad",col=TC.men_bad,label="@"..name}end
--- [F.resolveKnownMention] Phân giải nhanh tên người dùng được nhắc tới trong `@mention`
function F.resolveKnownMention(name)
  local res=F.resolveMentionToken(name,false)if res and res.status=="ok"then return res.label,res.col end return nil end
--- [F.resolveEmojiToken] Kiểm tra tính hợp lệ và tìm biểu tượng khớp với token `:emoji:` đang gõ
function F.resolveEmojiToken(rawName,isClosed)local TC=F.tokColors()local clean=F.cleanEmojiName(rawName):lower()
  if rawName==""and not isClosed then return{status="wait",col=TC.emo_wait,label=":emoji: (fire, heart, skull, custom...)"}end
  local id,realNm=F.emojiIdByName(rawName)if id then return{
      status=isClosed and"ok"or"wait",col=isClosed and TC.emo_ok or TC.emo_wait,icon="img:"..tostring(id),label=":"..tostring(realNm or rawName)..":"..(isClosed and""or(L=="en"and" (type : or pick)"or" (nhấn : hoặc chọn)")),}end
  local uni=CFG.SHORTCODES and CFG.SHORTCODES[clean]if uni then return{status=isClosed and"ok"or"wait",col=isClosed and TC.emo_ok or TC.emo_wait,icon=uni,
      label=":"..clean..": "..uni..(isClosed and""or(L=="en"and" (type : or pick)"or" (nhấn : hoặc chọn)")),}end if not isClosed and clean~=""then for _,e in ipairs(S.sharedEmojis or{})do local nm=tostring(e.name or"")
      if nm:lower():find(clean,1,true)or tostring(e.id or""):find(clean,1,true)then return{status="wait",col=TC.emo_wait,icon="img:"..tostring(e.id),label=":"..rawName.." -> :"..nm..":",}end end
    for cid,nm in pairs(P.customEmojiNames or{})do if tostring(nm):lower():find(clean,1,true)then return{status="wait",col=TC.emo_wait,icon="img:"..tostring(cid),label=":"..rawName.." -> :"..tostring(nm)..":",}
      end end for _,cid in ipairs(P.customEmojis or{})do local sId=tostring(cid)local defNm=P.customEmojiNames[sId]or("emo_"..sId:sub(-4))if defNm:lower():find(clean,1,true)or sId:find(clean,1,true)then return{
          status="wait",col=TC.emo_wait,icon="img:"..sId,label=":"..rawName.." -> :"..defNm..":",}end end for k,uChar in pairs(CFG.SHORTCODES or{})do if k:find(clean,1,true)then return{status="wait",
          col=TC.emo_wait,icon=uChar,label=":"..rawName.." -> :"..k..": "..uChar,}end end end return{status="bad",col=TC.emo_bad,label=":"..tostring(rawName)..(isClosed and":"or""),}end
--- [F.updateTokenFeedback] Tô màu trực tiếp (RichText Overlay) các cụm `/cmd`, `@user`, `:emoji:` trong ô nhập và hiển thị thanh trạng thái token
function F.updateTokenFeedback(text)if not U.inputStroke or not U.tokenBar then return false end text=tostring(text or"")for _,c in ipairs(U.tokenIconHolder:GetChildren())do c:Destroy()end
  U.tokenIconHolder.Visible=false local tokens={}local richParts={}local n=#text local i=1 while i<=n do local ch=text:sub(i,i)local prevCh=(i>1)and text:sub(i-1,i-1)or" "if ch=="/"and(i==1 or prevCh:match("%s"))then
      local s,e,cmdWord=text:find("^/([%w_%-?]*)",i)if s then local rawToken=text:sub(s,e)local info=F.resolveCmdToken(cmdWord or"")info.kind="cmd"info.raw=rawToken tokens[#tokens+1]=info
        richParts[#richParts+1]='<font color="'..H.tohex(info.col)..'">'..H.esc(rawToken)..'</font>'i=e+1 else richParts[#richParts+1]=H.esc(ch)i=i+1 end elseif ch=="@"then local s,e,mWord=text:find("^@([%w_]*)",i)if s then
        local rawToken=text:sub(s,e)local isAtEnd=(e==n)local info=F.resolveMentionToken(mWord or"",isAtEnd)info.kind="mention"info.raw=rawToken tokens[#tokens+1]=info
        richParts[#richParts+1]='<font color="'..H.tohex(info.col)..'">'..H.esc(rawToken)..'</font>'i=e+1 else richParts[#richParts+1]=H.esc(ch)i=i+1 end elseif ch=="["and text:find("^%[img:(%d+)%]",i)then
      local s,e,imgId=text:find("^%[img:(%d+)%]",i)local rawToken=text:sub(s,e)local eInfo=F.emojiInfoById(imgId)local col=F.tokColors().emo_ok tokens[#tokens+1]={kind="emoji",status="ok",col=col,icon="img:"..imgId,
        label=":"..((eInfo and eInfo.name)or("img:"..imgId))..":",raw=rawToken,}richParts[#richParts+1]='<font color="'..H.tohex(col)..'">'..H.esc(rawToken)..'</font>'i=e+1
    elseif ch==":"and not text:sub(max(1,i-10),i-1):lower():match("https?$")and not text:sub(max(1,i-12),i-1):lower():match("rbxassetid$")then local s1,e1,closedWord=text:find("^:([%w_%-]+):",i)if s1 then
        local rawToken=text:sub(s1,e1)local info=F.resolveEmojiToken(closedWord,true)info.kind="emoji"info.raw=rawToken tokens[#tokens+1]=info
        richParts[#richParts+1]='<font color="'..H.tohex(info.col)..'">'..H.esc(rawToken)..'</font>'i=e1+1 else local s2,e2,openWord=text:find("^:([%w_%-]*)",i)if s2 and e2==n then local rawToken=text:sub(s2,e2)
          local info=F.resolveEmojiToken(openWord or"",false)info.kind="emoji"info.raw=rawToken tokens[#tokens+1]=info richParts[#richParts+1]='<font color="'..H.tohex(info.col)..'">'..H.esc(rawToken)..'</font>'i=e2+1 else
          richParts[#richParts+1]=H.esc(ch)i=i+1 end end else richParts[#richParts+1]=H.esc(ch)i=i+1 end end
  local hasTokens=#tokens>0 local active=hasTokens and tokens[#tokens]or nil
  local cmdActive,menActive,emoActive=nil,nil,nil for _,tk in ipairs(tokens)do if tk.kind=="cmd"then cmdActive=tk elseif tk.kind=="mention"then menActive=tk elseif tk.kind=="emoji"then emoActive=tk end end if U.cmdBtn then
    U.cmdBtn.BackgroundColor3=cmdActive and cmdActive.col or TH.btnBg U.cmdBtn.TextColor3=cmdActive and c3(1,1,1)or TH.accent if U.cmdBtnStroke then U.cmdBtnStroke.Color=cmdActive and cmdActive.col or TH.btnBorder
      U.cmdBtnStroke.Transparency=cmdActive and 0.05 or 0.35 end end if U.atBtn then U.atBtn.BackgroundColor3=menActive and menActive.col or TH.btnBg U.atBtn.TextColor3=menActive and c3(1,1,1)or(TH.mentionText or TH.warn) if U.atBtnStroke then
      U.atBtnStroke.Color=menActive and menActive.col or TH.btnBorder U.atBtnStroke.Transparency=menActive and 0.05 or 0.35 end end if U.emojiBtn then U.emojiBtn.BackgroundColor3=emoActive and emoActive.col or TH.btnBg
    if U.emojiBtnStroke then U.emojiBtnStroke.Color=emoActive and emoActive.col or TH.btnBorder U.emojiBtnStroke.Transparency=emoActive and 0.05 or 0.35 end end if active then local col=active.col U.inputStroke.Color=col
    U.inputStroke.Transparency=0.05 if U.chatBarStroke then U.chatBarStroke.Color=col U.chatBarStroke.Transparency=0.1 end if U.tokenDot then U.tokenDot.BackgroundColor3=col end
    local maxW=(U.inputWrap and U.inputWrap.AbsoluteSize.X>40)and(U.inputWrap.AbsoluteSize.X-24)or 220 local fitsInBox=H.textW(text,P.textSize,fG)<=maxW
    local isFocused=S.inputFocused or(U.input and U.input:IsFocused())
    if U.inputRich and text~=""and fitsInBox and not isFocused and #tokens>0 then U.inputRich.TextSize=P.textSize U.inputRich.TextColor3=TH.text
      U.inputRich.Text=tconcat(richParts)U.inputRich.Visible=true U.input.TextTransparency=1 U.input.TextColor3=col else if U.inputRich then U.inputRich.Visible=false;U.inputRich.Text=""end
      U.input.TextTransparency=0 U.input.TextColor3=col
    end
    local prefix=""if active.kind=="cmd"then prefix=T(active.status=="ok"and"tok_cmd_ok"or(active.status=="wait"and"tok_cmd_wait"or"tok_cmd_bad"))elseif active.kind=="mention"then
      prefix=T(active.status=="ok"and"tok_mention_ok"or(active.status=="wait"and"tok_mention_find"or"tok_mention_bad"))elseif active.kind=="emoji"then
      prefix=T(active.status=="ok"and"tok_emoji_ok"or(active.status=="wait"and"tok_emoji_find"or"tok_emoji_bad"))end if active.icon then U.tokenIconHolder.Visible=true F.iconBox(U.tokenIconHolder,active.icon,16)end
    U.tokenAccent.BackgroundColor3=col U.tokenStroke.Color=col U.tokenLbl.Position=uo(U.tokenIconHolder.Visible and 28 or 10,0)U.tokenLbl.Size=u2(1,U.tokenIconHolder.Visible and-114 or-96,1,0)
    U.tokenLbl.Text=prefix..tostring(active.label or"")U.tokenLbl.TextColor3=col if U.tokenStatePill then U.tokenStatePill.BackgroundColor3=col U.tokenStatePill.TextColor3=H.lum(col)>0.6 and rgb(18,18,22)or c3(1,1,1)
      U.tokenStatePill.Text=T(active.status=="ok"and"tok_state_ok"or(active.status=="wait"and"tok_state_wait"or"tok_state_bad"))end else if U.inputRich then U.inputRich.Visible=false;U.inputRich.Text=""end
    U.input.TextTransparency=0
    local isFocused=S.inputFocused or(U.input and U.input:IsFocused())
    U.input.TextColor3=TH.text U.inputStroke.Color=isFocused and TH.accent or TH.inputBorder U.inputStroke.Transparency=isFocused and 0.05 or 0.25 if U.chatBarStroke then U.chatBarStroke.Color=TH.border U.chatBarStroke.Transparency=0.35 end if U.tokenDot then
      U.tokenDot.BackgroundColor3=(text~=""or isFocused)and TH.accent or TH.muted end end
  local changed=(U.tokenBar.Visible~=hasTokens)U.tokenBar.Visible=hasTokens return changed end
--- [F.updateSuggest] Cập nhật thanh gợi ý tự động hoàn thành (Autocomplete Suggestions) cho lệnh `/`, `@mention` và `:emoji:`
function F.updateSuggest()local text=U.input.Text
  local tokChanged=F.updateTokenFeedback(text)local items={}local trimmedLead=text:match("^%s*(.*)$")or text if trimmedLead:sub(1,1)=="/"and not trimmedLead:find("%s")then local pre=trimmedLead:sub(2):lower()
    for _,c in ipairs(F.cmdList)do if(not c.staff or F.isStaff(P.username))and(not c.dev or F.isDev(P.username))and c.name:sub(1,#pre)==pre then items[#items+1]={label="/"..c.name,fill="/"..c.name.." ",kind="cmd"}end end
  else local emoWord=text:match(":([%w_%-]*)$")local word=text:match("@([%w_]*)$")if emoWord~=nil and not text:match(":([%w_%-]+):$")then local ew=emoWord:lower()local seenId={}for _,e in ipairs(S.sharedEmojis or{})do
        local nm=tostring(e.name or"")local id=tostring(e.id or"")if id~=""and not seenId[id]and(ew==""or nm:lower():find(ew,1,true)or id:find(ew,1,true))then seenId[id]=true items[#items+1]={label=":"..nm..":",
            icon="img:"..id,fill=text:gsub(":[%w_%-]*$",":"..nm..": "),kind="emoji",}if#items>=8 then break end end end for id,nm in pairs(P.customEmojiNames or{})do if#items>=8 then break end
        if not seenId[tostring(id)]and(ew==""or tostring(nm):lower():find(ew,1,true))then seenId[tostring(id)]=true items[#items+1]={label=":"..nm..":",icon="img:"..tostring(id),fill=text:gsub(":[%w_%-]*$",":"..nm..": "),
            kind="emoji",}end end for _,cid in ipairs(P.customEmojis or{})do if#items>=8 then break end
        local sId=tostring(cid)local nm=P.customEmojiNames[sId]or("emo_"..sId:sub(-4))
        if not seenId[sId]and(ew==""or nm:lower():find(ew,1,true)or sId:find(ew,1,true))then seenId[sId]=true items[#items+1]={label=":"..nm..":",icon="img:"..sId,fill=text:gsub(":[%w_%-]*$",":"..nm..": "),kind="emoji",}
        end end
      local scOrder={"fire","heart","skull","joy","sob","thumbsup","100","sparkles","crown","star","eyes","check","rocket","wave","pray","party","cool","thinking","gg","gem"}for _,k in ipairs(scOrder)do
        if#items>=10 then break end
        local uChar=CFG.SHORTCODES and CFG.SHORTCODES[k]if uChar and(ew==""or k:find(ew,1,true))then items[#items+1]={label=":"..k..":",icon=uChar,fill=text:gsub(":[%w_%-]*$",":"..k..": "),
            kind="emoji",}end end elseif word~=nil then local w=word:lower()local names={}local seenU={}
      local function addCandidate(u,disp)if not u or seenU[u:lower()]then return end
        if w==""or u:lower():find(w,1,true)or tostring(disp or""):lower():find(w,1,true)then seenU[u:lower()]=true names[#names+1]=u end end for u,r in pairs(S.users)do addCandidate(u,r.display)end
      for _,pl in ipairs(Players:GetPlayers())do addCandidate(pl.Name,pl.DisplayName)end tsort(names,function(a,b)local la,lb=F.isLive(S.users[a]),F.isLive(S.users[b])if la~=lb then return la end return a:lower()<b:lower()
      end)if F.canMentionAll(P.username)then for _,x in ipairs({"everyone","here"})do if w==""or x:find(w,1,true)==1 then tinsert(names,1,x)end end end for i=1,min(#names,8)do items[#items+1]={label="@"..names[i],
          fill=text:gsub("@[%w_]*$","@"..names[i].." "),kind="mention",user=names[i],}end end end for _,c in ipairs(U.suggest:GetChildren())do if not c:IsA("UIListLayout")then c:Destroy()end end
  local show=#items>0
  for i,it in ipairs(items)do local hasIc=it.icon~=nil local lblW=clamp(H.textW(it.label,11,fGB)+4,24,150)local btnW=8+(hasIc and 20 or 0)+lblW+8
    local b=mk("TextButton",{Size=uo(btnW,24),Text="",BorderSizePixel=0,LayoutOrder=i},U.suggest)th(b,"BackgroundColor3","bg2");corner(b,12)
    local TC=F.tokColors()local chipCol=it.kind=="cmd"and TC.cmd_wait or(it.kind=="mention"and(it.user and F.mentionColorFor(it.user)or TC.men_ok)or TC.emo_ok)
    mk("UIStroke",{Color=chipCol,Thickness=1.2,Transparency=0.2,ApplyStrokeMode=smBorder},b)if hasIc then local ic=F.iconBox(b,it.icon,16)ic.Position=uo(7,4)end
    local l=lab(b,it.label,{size=uo(lblW,24),
      pos=uo(hasIc and 26 or 8,0),ts=11,bold=true,})l.TextColor3=chipCol hook(b.MouseButton1Click,function()U.input.Text=it.fill;F.updateSuggest();U.input:CaptureFocus()end)end
  if U.suggest.Visible~=show or tokChanged then U.suggest.Visible=show;F.layout()end end

-- =============================================================================
-- 23. LƯU FILE, KÉO THẢ CỬA SỔ, VÒNG LẶP LONG-POLLING & KHỞI CHẠY HỆ THỐNG
-- =============================================================================
--- [F.save] Lưu toàn bộ cài đặt cá nhân (`P`), vị trí cửa sổ (`winX`, `winY`) và bộ đệm tin nhắn (`S`) xuống file JSON cục bộ
function F.save(force)
  local layoutData={winX=P.winX,winY=P.winY,W=P.W,H=P.H,prevW=P.prevW,prevH=P.prevH,miniX=P.miniX,miniY=P.miniY,minimized=P.minimized}
  ENV.CB46_LAYOUT=layoutData ENV.CB45_LAYOUT=layoutData ENV.CB44_LAYOUT=layoutData ENV.CB43_LAYOUT=layoutData ENV.CB42_LAYOUT=layoutData
  if not hasIO then return end
  if not force and(not S.isDirty or os.clock()-S.lastSave<CFG.SAVE_THROTTLE)then return end
  S.lastSave=os.clock();S.isDirty=false local rx={}for id,m in pairs(S.reactions)do if S.msgs[id]and next(m)then rx[id]=m end end
  local polls,n={},0 for id,p in pairs(S.polls)do n=n+1;if n<=60 then polls[id]=p end end
  local gameMsgs,announceMsgs,generalMsgs={},{},{}
  local curPlace,trackGame=game.PlaceId,not S.quitting
  for _,id in ipairs(S.order)do
    local m=S.msgs[id]
    local isAnn=m and m.chan=="announce"and not m.deleted
    if m then
      local ch=m.chan
      if trackGame and ch=="game"and not m.deleted and not m.cleared and tonumber(m.place)==curPlace then
        gameMsgs[#gameMsgs+1]={packetId=m.packetId,author=m.author,display=m.display,uid=m.uid,content=m.content,ts=m.ts,replyTo=m.replyTo,replyAuthor=m.replyAuthor,replySnippet=m.replySnippet,place=m.place,job=m.job}
      elseif isAnn then
        announceMsgs[#announceMsgs+1]={type="msg",packetId=m.packetId,chan="announce",author=m.author,display=m.display,uid=m.uid,content=m.content,ts=m.ts,replyTo=m.replyTo,replyAuthor=m.replyAuthor,replySnippet=m.replySnippet,edited=m.edited,reactions=rx[id]}
      elseif ch=="general"and not m.deleted and not m.cleared then
        generalMsgs[#generalMsgs+1]={packetId=m.packetId,author=m.author,display=m.display,uid=m.uid,content=m.content,ts=m.ts,replyTo=m.replyTo,replyAuthor=m.replyAuthor,replySnippet=m.replySnippet,edited=m.edited,reactions=rx[id]}
      end
    end
    if not isAnn then
      local ap=S.polls[id]
      if ap and ap.chan=="announce"and not ap.cleared then
        announceMsgs[#announceMsgs+1]={type="poll",packetId=ap.id,pollId=ap.id,chan="announce",question=ap.q,options=ap.o,multi=ap.multi,author=ap.author,ts=ap.ts,expires_at=ap.exp,votes=ap.votes,closed=ap.closed}
      end
    end
  end
  if #gameMsgs>120 then local out={}for i=#gameMsgs-119,#gameMsgs do out[#out+1]=gameMsgs[i]end gameMsgs=out end
  if #generalMsgs>60 then local out={}for i=#generalMsgs-59,#generalMsgs do out[#out+1]=generalMsgs[i]end generalMsgs=out end
  local seenOut={}
  for id,vmap in pairs(S.seenBy or{})do if S.msgs[id]and type(vmap)=="table"and next(vmap)then seenOut[id]=vmap end end
  local gameChat=(not S.quitting and #gameMsgs>0)and{placeId=curPlace,jobId=tostring(game.JobId or""),savedAt=os.time(),joinTs=S.joinTs,msgs=gameMsgs}or nil
  local d={clientId=P.clientId,lang=L,display=P.display,status=P.status,bio=P.bio,country=P.country,
    profBanner=P.profBanner,profIcon=P.profIcon,profTheme=P.profTheme,autoExecute=P.autoExecute,scriptUrl=P.scriptUrl,msgCount=P.msgCount,
    dmList=P.dmList,customEmojis=P.customEmojis,recentEmoji=P.recentEmoji,recentColors=P.recentColors,themeName=P.themeName,custom=P.custom,alpha=P.alpha,
    backgroundMode=P.backgroundMode,backgroundImage=P.backgroundImage,backgroundOpacity=P.backgroundOpacity,backgroundDim=P.backgroundDim,bgFrame=P.bgFrame,
    gradAngle=P.gradAngle,gradMix=P.gradMix,uiRadius=P.uiRadius,fontFamily=P.fontFamily,msgStyle=P.msgStyle,borderGlow=P.borderGlow,savedThemes=P.savedThemes,userNotes=P.userNotes,blockedUsers=P.blockedUsers,myFeedbacks=P.myFeedbacks,mute=P.mute,
    W=P.W,H=P.H,prevW=P.prevW,prevH=P.prevH,winX=P.winX,winY=P.winY,minimized=P.minimized,
    notify=P.notify,sound=P.sound,bubble=P.bubble,safeEmoji=P.safeEmoji,showGame=P.showGame,preview=P.preview,compact=P.compact,sameUser=P.sameUser,group=P.group,showTyping=P.showTyping,showSeen=P.showSeen,textSize=P.textSize,toastPos=P.toastPos,
    miniX=P.miniX,miniY=P.miniY,roles=S.roles,assign=S.assign,rolesSeq=S.rolesSeq,mutes=S.mutes,warns=S.warns,bannedMap=S.bannedMap,punishments=S.punishments,reports=S.reports,reactions=rx,seenBy=seenOut,polls=polls,
    customEmojiNames=P.customEmojiNames,sharedEmojis=S.sharedEmojis,scripts=S.scripts,groups=S.groups,savedScripts=P.savedScripts,gameChat=gameChat,generalChat=generalMsgs}local s=H.jenc(d)
  if s then pcall(writefile,FILE,s)end
  local flagStr=(P.autoExecute~=false)and"1"or"0"
  if S._savedAutoFlag~=flagStr or not isfile("cb46_autoexec_on.txt")then
    if pcall(writefile,"cb46_autoexec_on.txt",flagStr)then S._savedAutoFlag=flagStr end
  end
  if type(P.scriptUrl)=="string"and P.scriptUrl~=""and(S._savedUrl~=P.scriptUrl or not isfile("cb46_script_url.txt"))then
    if pcall(writefile,"cb46_script_url.txt",P.scriptUrl)then S._savedUrl=P.scriptUrl end
  end
  local ls=H.jenc(layoutData)
  if ls then pcall(writefile,LAYOUT_FILE,ls)end end
-- Xử lý sự kiện nhấn giữ và kéo chuột / chạm cảm ứng để di chuyển hoặc thay đổi kích thước cửa sổ và nút thu nhỏ (tự lưu vị trí ngay khi thả tay)
local drag,md
local function isPress(i)return i.UserInputType==mb1 or i.UserInputType==utTouch end
local function isMove(i,ref)return(ref.UserInputType==utTouch and i==ref)or(ref.UserInputType==mb1 and i.UserInputType==Enum.UserInputType.MouseMovement)end
hook(U.titleBar.InputBegan,function(i)if isPress(i)then drag={kind="move",start=i.Position,ox=S.winX,oy=S.winY,input=i}end end)
hook(U.resize.InputBegan,function(i)if isPress(i)then drag={kind="size",start=i.Position,w=P.W,h=P.H,input=i}end end)hook(U.mini.InputBegan,function(i)
  if isPress(i)then S.miniMoved=false;md={start=i.Position,ox=U.mini.Position.X.Offset,oy=U.mini.Position.Y.Offset,input=i,moved=false}end end)hook(UIS.InputChanged,function(i)local tk=S.track
  if tk and isMove(i,tk.input)then pcall(tk.fn,i.Position)end if drag and isMove(i,drag.input)then local d=i.Position-drag.start
    if drag.kind=="move"then S.winX,S.winY=drag.ox+d.X,drag.oy+d.Y;P.winX,P.winY=S.winX,S.winY else P.W,P.H=drag.w+d.X,drag.h+d.Y end
    F.layout()end if md and isMove(i,md.input)then local d=i.Position-md.start
    if d.Magnitude>6 then md.moved=true;S.miniMoved=true end if md.moved then local v=viewNow()U.mini.Position=uo(clamp(md.ox+d.X,0,v.X-42),clamp(md.oy+d.Y,0,v.Y-42))end end end)hook(UIS.InputEnded,function(i)
  if S.track and(i==S.track.input or(S.track.input.UserInputType==mb1 and i.UserInputType==mb1))then F.endTrack()end if drag and(i==drag.input or i.UserInputType==mb1)then
    P.winX,P.winY=S.winX,S.winY;drag=nil;S.isDirty=true;F.save(true)end
  if md and(i==md.input or i.UserInputType==mb1)then if md.moved then P.miniX,P.miniY=U.mini.Position.X.Offset,U.mini.Position.Y.Offset;S.isDirty=true;F.save(true)end md=nil end end)hook(UIS.InputBegan,function(i,gp)
  S.activityAt=os.clock()if not gp and i.KeyCode==Enum.KeyCode.RightShift then U.main.Visible=not U.main.Visible;P.minimized=not U.main.Visible if U.main.Visible then U.mini.Visible=false end S.isDirty=true;F.save(true)end end)
--- [showMain] Hiển thị lại cửa sổ chính khi người dùng bấm vào nút thu nhỏ (`U.mini`)
local function showMain()
  U.main.Visible=true;U.mini.Visible=false;P.minimized=false S.miniUnread=0;U.miniBadge.Visible=false F.layout();F.selectChannel(S.chan);S.isDirty=true;F.save(true)end
hook(U.mini.MouseButton1Click,function()if S.miniMoved then S.miniMoved=false return end showMain()end)
-- Gắn sự kiện click cho các nút trên thanh tiêu đề, ô tìm kiếm, ô nhập chat và phím tắt Enter / Escape
hook(U.bMin.MouseButton1Click,function()U.main.Visible=false;U.mini.Visible=true;P.minimized=true;S.isDirty=true;F.save(true)end)hook(U.bLang.MouseButton1Click,function()F.setLang(L=="en"and"vi"or"en")end)hook(U.bFind.MouseButton1Click,function()
  U.searchBox.Visible=not U.searchBox.Visible if not U.searchBox.Visible then U.searchBox.Text="";S.search="";F.rebuildFeed()else U.searchBox:CaptureFocus()end
  F.layout()end)
hook(U.searchBox:GetPropertyChangedSignal("Text"),function()S.search=U.searchBox.Text;F.rebuildFeed()end)hook(U.bUsers.MouseButton1Click,F.openOnline)hook(U.bMe.MouseButton1Click,function()F.openProfile(P.username)end)
hook(U.bSet.MouseButton1Click,F.openSettings);(function()for name,b in pairs(U.tabs)do hook(b.MouseButton1Click,function()if name=="dm"then F.openDMList()else F.selectChannel(name)end end)end end)()
hook(U.sendBtn.MouseButton1Click,F.sendNow)
hook(U.input.Focused,function()S.inputFocused=true;if U.inputRich then U.inputRich.Visible=false;U.inputRich.Text=""end;U.input.TextTransparency=0;F.updateTokenFeedback(U.input.Text)end)
hook(U.input.FocusLost,function(enter)S.inputFocused=false;if enter then F.sendNow()else F.updateTokenFeedback(U.input.Text)end end)
hook(U.input:GetPropertyChangedSignal("Text"),function()F.updateSuggest()local t=U.input.Text
  if t~=""and t:sub(1,1)~="/"and S.chan~="scripts"and S.chan~="punish"then
    if P.showTyping and os.clock()-S.lastType>CFG.TYPING_THROTTLE and not F.muted(P.username)then
      S.lastType=os.clock();S.wasTyping=true
      F.publish({type="typing",author=P.username,chan=S.chan},"fast")
    end
  elseif S.wasTyping then
    S.wasTyping=false;S.lastType=0
    if P.showTyping and not F.muted(P.username)then
      F.publish({type="typing",author=P.username,chan=S.chan,stop=true},"fast")
    end
  end end)
hook(U.emojiBtn.MouseButton1Click,function()F.insertEmoji()end)hook(U.pollBtn.MouseButton1Click,F.openPoll)hook(U.replyX.MouseButton1Click,function()F.cancelCompose();U.input.Text=""end)
hook(U.jump.MouseButton1Click,function()F.scrollBottom()end)hook(U.scroll:GetPropertyChangedSignal("CanvasPosition"),function()if F.nearBottom()then S.newBelow=0 end F.updateJump()end)
hook(U.scroll:GetPropertyChangedSignal("AbsoluteCanvasSize"),function()if S.stickUntil and os.clock()<S.stickUntil then F.snapBottom()end end);(function()local vcam=workspace.CurrentCamera
if vcam then hook(vcam:GetPropertyChangedSignal("ViewportSize"),F.layout)end end)();(function()
--- [pollDelay] Tính thời gian chờ giữa các lần lấy tin nhắn (tự động giãn cách khi người chơi treo máy / AFK)
local function pollDelay()local idleSec=os.clock()-S.activityAt if not U.main.Visible or(P.W<115 or P.H<95)then
    return idleSec>60 and(CFG.POLL_AFK or 4)or CFG.POLL_IDLE end return idleSec<30 and CFG.POLL_FAST or(idleSec>120 and(CFG.POLL_AFK or 4)or CFG.POLL_IDLE)end
--- [pollLoop] Vòng lặp nền chính gọi `/api/feed` (Long-Polling) liên tục để nhận tin nhắn và sự kiện thời gian thực
local function pollLoop()while NET.alive do
    local lp=S.lpOn and S.lastSeq>0 local since,wait,sweep=S.lastSeq,(lp and CFG.LONGPOLL or 0),false if S.lastSeq>0 and not S.strong and os.clock()-(S.sweepAt or 0)>=CFG.SWEEP then sweep=true
      since,wait=max(1,S.lastSeq-CFG.OVERLAP_MS),0 end
    local rs=S.forceRoles and 0 or S.rolesSeq
    local pQuery=""
    if S.lastSeq==0 or os.clock()-(S.lastPresPiggy or 0)>40 then
      local pTheme=F.compactProfTheme(P.profTheme or{})
      local ptJson=(type(pTheme)=="table"and next(pTheme)~=nil and H.jenc(pTheme))or""
      pQuery=string.format("&d=%s&id=%d&st=%s&bio=%s&c=%s&sg=%d&mc=%d&pl=%d&gn=%s&jb=%s&pb=%s&pi=%s&ptb=%s&pta=%s&ptt=%s&ptbi=%s&ptj=%s",H.url(P.display),P.userId,H.url(P.status),H.url(P.bio or""),H.url(P.country),P.showGame and 1 or 0,P.msgCount or 0,P.showGame and game.PlaceId or 0,H.url(P.showGame and S.placeName or""),H.url(P.showGame and game.JobId or""),H.url(P.profBanner or""),H.url(P.profIcon or""),H.url(pTheme.bg or""),H.url(pTheme.acc or""),H.url(pTheme.txt or""),H.url(pTheme.bgImg or""),H.url(ptJson))
      S.lastPresPiggy=os.clock()
    end
    local path=string.format("/api/feed?since=%s&limit=%d&rs=%s&ss=%s&es=%s&as=%s&ms=%s&vws=%s&gs=%s&fbs=%s&u=%s&gpl=%d&gjb=%s&wait=%d%s",H.num(since),S.lastSeq==0 and CFG.HISTORY or 100,H.num(rs),H.num(S.scriptSeq or 0),H.num(S.emojiSeq or 0),H.num(S.announceSeq or 0),H.num(S.modSeq or 0),H.num(S.seenSeq or 0),H.num(S.groupSeq or 0),H.num(S.feedbackSeq or 0),H.url(P.username),tonumber(game.PlaceId)or 0,H.url(tostring(game.JobId or"")),wait,pQuery)local t0=os.clock()
    local data,err=rawRequest("GET",path)if not NET.alive then break end if data and data.ok then if sweep then S.sweepAt=os.clock()end
      local first=S.lastSeq==0 S.pollFail,S.lpFails,S.lastPollOk=0,0,os.clock()
      local ok,e=pcall(F.ingest,data,first)if not ok then warn("[CB46] ingest: "..tostring(e))end if first and not S.booted then F.afterBoot()end
      F.paintDot()
      if not first then if#(data.messages or{})==0 and os.clock()-t0<0.35 then task.wait(lp and 0.25 or pollDelay())elseif not lp then task.wait(pollDelay())end end else S.pollFail=S.pollFail+1;S.lpFails=S.lpFails+1
      if S.lpOn and S.lpFails>=3 then S.lpOn=false;S.lpRetryAt=os.clock()+CFG.LP_RETRY end
      F.paintDot()task.wait(min(5,0.5*S.pollFail))end
    if not S.lpOn and S.lpRetryAt and os.clock()>S.lpRetryAt and CFG.LONGPOLL>0 then S.lpOn,S.lpFails,S.lpRetryAt=true,0,nil end end end
--- [heartbeatLoop] Vòng lặp nền định kỳ gửi tín hiệu trực tuyến (`F.heartbeat`) mỗi `CFG.HEARTBEAT` giây
local function heartbeatLoop()while NET.alive do task.wait(CFG.HEARTBEAT)
    if NET.alive then F.heartbeat(false)end end end
local function updateBubbles()
  local camPos=workspace.CurrentCamera and workspace.CurrentCamera.CFrame and workspace.CurrentCamera.CFrame.Position
  for _,st in pairs(S.bubbles)do
    if type(st)=="table"and st.bb and st.bb.Parent and st.head and st.head.Parent then
      st.bb.StudsOffset=F.calcBubbleOffset(st.head,st.ch)
      if camPos and st.head.Position then
        local isFar=(camPos-st.head.Position).Magnitude>48
        local items=st.items or{}
        local lastIdx=#items
        for idx,it in ipairs(items)do
          if it.card and it.card.Parent then
            if isFar then
              if idx==lastIdx then
                it.card.Visible=true
                it.card.Size=uo(42,26)
                if it.content then it.content.Visible=false end
                if it.dots then it.dots.Visible=true end
              else
                it.card.Visible=false
              end
            else
              it.card.Visible=true
              it.card.Size=uo(it.w or 100,it.h or 28)
              if it.content then it.content.Visible=true end
              if it.dots then it.dots.Visible=false end
            end
          end
        end
      end
    end
  end
end
--- [tickLoop] Vòng lặp bảo trì mỗi 0.5 giây: cập nhật độ cao bong bóng chat 3D trong không gian hẹp / thu gọn khi ở xa, dọn trạng thái `typing`, kiểm tra Mute và lưu file
local function tickLoop()local n=0 while NET.alive do task.wait(0.5)n=n+1 local now=os.clock()local names={}for u,t in pairs(S.typing[S.chan]or{})do
      if now-t<CFG.TYPING_TIMEOUT then names[#names+1]=u else S.typing[S.chan][u]=nil end end
    U.typing.Text=#names>0 and(F.disp(tconcat(names,", ",1,min(#names,3)))..T("typing").."…")or""
    if next(S.bubbles)~=nil then pcall(updateBubbles)end
    if n%10==0 then local alive={}
      for _,c in ipairs(conns)do if c.Connected then alive[#alive+1]=c end end conns=alive if#reg>800 then F.pruneThemeReg()end
      F.updateInfo()
      if S.mutes[P.username]and not F.muted(P.username)and P.mute.on then P.mute.on=false;S.isDirty=true end
      pcall(F.refreshSame)if n%120==0 then local cnt=0 for _,r in pairs(S.users)do if F.isLive(r)then cnt=cnt+1 end end
        if cnt<=1 and#Players:GetPlayers()>1 then F.publish({type="req_presence",author=P.username,chan="general"},"fast")end end end
    if S.isDirty then F.save(false)end end end
F._bootLoops=function()task.spawn(pollLoop)task.spawn(heartbeatLoop)task.spawn(tickLoop)end end)()
--- [F.refreshSame] Gắn huy hiệu biểu tượng `[CB]` ngay trên đầu những người chơi khác trong cùng server Roblox cũng đang dùng Chat Bridge (tự ẩn khi người đó đang có bong bóng chat)
function F.refreshSame()if not P.sameUser then
    for u,bb in pairs(S.sameBb)do pcall(function()bb:Destroy()end);S.sameBb[u]=nil end return end
  local alive={}
  local function headOf(pl)local ch=pl and pl.Character
    return ch and(ch:FindFirstChild("Head")or ch:FindFirstChild("HumanoidRootPart")or ch.PrimaryPart)end
  local function pin(name,head)alive[name]=true local curBb=S.sameBb[name]
    local bState=S.bubbles[name]
    local hasBubble=bState and type(bState)=="table"and #(bState.items or{})>0
    if curBb and curBb.Parent and curBb.Adornee==head then
      curBb.Enabled=not hasBubble
      return
    end
    if curBb then pcall(function()curBb:Destroy()end)end
    local bb=Instance.new("BillboardGui")bb.Name="CB46Same_"..name bb.Adornee=head bb.Size=uo(44,20)
    bb.StudsOffset=Vector3.new(0,2.35,0)bb.AlwaysOnTop=true bb.MaxDistance=140 bb.LightInfluence=0 bb.Enabled=not hasBubble bb.Parent=F.billboardContainer(head)local pill=Instance.new("Frame")pill.Size=us(1,1)pill.BackgroundColor3=TH.bg2
    pill.BackgroundTransparency=0.15 pill.BorderSizePixel=0 pill.Parent=bb corner(pill,10)mk("UIStroke",{Color=TH.accent,Thickness=1.2,Transparency=0.25},pill)local l=Instance.new("TextLabel")l.Size=us(1,1)
    l.BackgroundTransparency=1 l.Text="💬 CB"l.TextColor3=TH.accent l.TextSize=11 l.Font=fGB l.Parent=pill S.sameBb[name]=bb end for _,pl in ipairs(Players:GetPlayers())do if pl~=LP and F.isScriptUser(pl.Name)then
      local h=headOf(pl)if h then pin(pl.Name,h)end end end for u,bb in pairs(S.sameBb)do if not alive[u]then pcall(function()bb:Destroy()end);S.sameBb[u]=nil end end end
--- [F.afterBoot] Hoàn tất quá trình khởi động sau khi nạp xong dữ liệu lần đầu từ máy chủ
function F.afterBoot()if S.booted then return end
  S.booted=true F.armAutoTeleport()F.layoutTabs();F.selectChannel(S.chan)F.toast(T("ready"),false)F.emit("ready")end
--- [F.stop] Dừng toàn bộ vòng lặp mạng, lưu dữ liệu lần cuối, ngắt mọi kết nối sự kiện và xóa giao diện Chat Bridge
function F.stop()if S.stopped then return end
  S.stopped=true F.save(true)
  task.spawn(function()pcall(rawRequest,"POST","/api/presence",{u=P.username,off=true})end)task.delay(0.5,function()NET.alive=false end)F.emit("stop")for _,c in ipairs(conns)do pcall(function()c:Disconnect()end)end
  for _,b in pairs(S.bubbles)do pcall(function()if type(b)=="table"and b.bb then b.bb:Destroy()elseif b.Destroy then b:Destroy()end end)end for _,b in pairs(S.sameBb or{})do pcall(function()b:Destroy()end)end
  pcall(function()U.gui:Destroy()end)
  for v=46,41,-1 do ENV["CB"..v.."_STOP"]=nil ENV["CB"..v]=nil end end
for v=46,41,-1 do ENV["CB"..v.."_STOP"]=F.stop end
;(function()local CB_API={version="46.0",cfg=CFG,F=F,S=S,P=P,U=U,H=H,command=F.command,on=F.on,toast=F.toast,
  send=function(text,chan)if chan then F.selectChannel(chan)end
    U.input.Text=tostring(text);F.sendNow()end,
    request=F.openRequest,admin=F.openAdmin,roles=F.openRoles,diag=F.openDiag,suggest=F.openSuggestions,bug=F.openBugReport}
for v=46,41,-1 do ENV["CB"..v]=CB_API end
F.armAutoTeleport()F.layout();F.paintTheme();F.layoutTabs();F.paintTabs();F.updateInfo()task.spawn(function()
  local ok,info=pcall(function()return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)end)S.placeName=(ok and info and info.Name)or tostring(game.Name or"?")S.lastPresPiggy=0
end)if F._bootLoops then F._bootLoops()end task.spawn(function()
  -- Gửi 1 nhịp đánh thức ngầm tới Server Boss (Render.com) khi khởi động để Bot Discord luôn thức 24/7
  if CFG.BOSS_URL and CFG.BOSS_URL~=""then pcall(httpFn,{Url=CFG.BOSS_URL.."/api/ping?source=client-boot",Method="GET"})end
  task.wait(30)
  while NET.alive do
    task.wait(60)
    if CFG.BOSS_URL and CFG.BOSS_URL~=""then
      task.spawn(function()pcall(httpFn,{Url=CFG.BOSS_URL.."/api/ping?source=client-keepalive",Method="GET"})end)
    end
    if NET.idx>1 and PROXY_POOL[1] and (NET.cooldown[PROXY_POOL[1]]or 0)<=os.clock() then
      local ok,res=pcall(httpFn,{Url=PROXY_POOL[1].."/api/ping",Method="GET"})
      if ok and type(res)=="table"and(tonumber(res.StatusCode or res.Status)or 0)==200 then
        NET.idx=1;CFG.PROXY=PROXY_POOL[1];NET.cooldown[PROXY_POOL[1]]=nil;S.lastSeq=0;S.pollFail=0
      end
    end
    if S.lastPollOk==0 or os.clock()-S.lastPollOk>90 then S.pollFail=0 S.lpOn=CFG.LONGPOLL>0 S.lpFails=0 warn("[CB46] Watchdog: resync")end
  end
end)if saved.W==nil and IS_MOBILE then P.W,P.H=340,480 end
print("[CB46] Chat Bridge v46.0 · "..EXEC.." · "..(L=="en"and"Stop: getgenv().CB46_STOP()"or"Dừng: getgenv().CB46_STOP()"))
end)()
