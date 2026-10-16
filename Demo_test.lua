local ENV=(getgenv and getgenv())or _G for _,k in ipairs({"CB43_STOP","CB42_STOP","CB41_STOP","CB40_STOP","CB39_STOP","CB38_STOP","CB37_STOP"})do if type(ENV[k])=="function"then pcall(ENV[k])end end pcall(function()if type(isfile)=="function"and type(delfile)=="function"and isfile("cb42_autorun.lua")then delfile("cb42_autorun.lua")end end) local CFG={
SCRIPT_URL=(type(ENV.CB42_SCRIPT_URL)=="string"and ENV.CB42_SCRIPT_URL)or"",PROXY="https://cb-roblox.phwphat5555.workers.dev",PROXIES={"https://cb-roblox.phwphat5555.workers.dev",
"https://backup.phwphat8888.workers.dev","https://backupv2.sillydumb111.workers.dev","https://backupv3.just-a-blur-000.workers.dev",},DEVELOPERS={phwphat5555=true},PREFIX="CB42:",LEGACY={},
LONGPOLL=12,POLL_FAST=0.35,POLL_IDLE=1.5,POLL_AFK=3.5,LP_RETRY=30,HEARTBEAT=90,PRESENCE_TIMEOUT=150,SWEEP=6,OVERLAP_MS=15000,HISTORY=60,MAX_MESSAGES=250,MAX_RENDER=50,MAX_CONTENT=800,
TYPING_TIMEOUT=4,TYPING_THROTTLE=1.5,REACT_THRO=0.4,GROUP_SECS=300,MENTION_SOUND="rbxassetid://6042053626",MIN_W=60,MIN_H=60,SEEN_MAX=1500,SAVE_THROTTLE=3,}table.insert(CFG.LEGACY,"CB43:")for v=41,19,-1 do table.insert(CFG.LEGACY,"CB"..v..":")end
CFG.REACT={"👍","😂","🔥","💀","😭","👀","🙏","💔","😎","💢","🌹","🐧","🎉","😮","😢","💖","🚨","😍","😡","👑","🙄","💯","💎","🚀"}CFG.SHORTCODES={fire="🔥",heart="💖",love="😍",skull="💀",joy="😂",laugh="😆",
sob="😭",cry="😢",smile="😄",cool="😎",angry="😡",thinking="😮",thumbsup="👍",like="👍",thumbsdown="👎",dislike="👎",["100"]="💯",sparkles="💫",star="🌟",crown="👑",eyes="👀",check="👍",ok="👌",
x="💢",no="👎",warning="🚨",rocket="🚀",wave="👋",pray="🙏",party="🎉",tada="🎉",clap="👏",gg="🏆",gem="💎",zap="💥",lightning="💥",rose="🌹",ghost="👻",muscle="💪",brain="💡",}CFG.EMOJI={
face={"😀","😃","😄","😁","😆","😅","😂","😊","😇","🙂","🙃","😉","😌","😍","😘","😗","😙","😚","😋","😛","😜","😝","😐","😑","😶","😏","😒","🙄","😬","😮","😯","😲","😴","😵","😎","😕","😟","🙁","😮","😨","😰","😥","😢","😭","😱","😖","😣","😞","😓","😩","😫","😤","😡","😠","😈","👿","💀","💩","👻","👹","👺","👽","👾","😺","😸","😹","😻","😼","😽","🙀","😿","😾"},
hand={"👍","👎","👌","👊","✊","👋","👏","👐","🙌","🙏","👈","👉","👆","👇","💪","👀","👑","💋","💍","💎"},
sym={"🔥","💯","🌟","💥","💫","🎉","🎊","🎁","🏆","🏅","💎","💰","💵","💸","🚨","🔔","🎵","🎶","🎮","🎲","🎯","💖","💗","💓","💞","💕","💘","💝","💔","💛","💚","💙","💜","💟","🚀","🔰","🔱","🔧","🔨","🔑","🔒","🔓","💬","💭","📢","💢","💤","💣","💦","💧","💨","💡"},
obj={"🐧","🐶","🐱","🐭","🐹","🐰","🐻","🐼","🐨","🐯","🐮","🐷","🐸","🐵","🙈","🙉","🙊","🐔","🐦","🐤","🐺","🐗","🐴","🐝","🐛","🐌","🐞","🐜","🐢","🐍","🐙","🐠","🐟","🐬","🐳","🐋","🍕","🍔","🍟","🍗","🍖","🍝","🍛","🍣","🍱","🍜","🍙","🍚","🍦","🍧","🍨","🍩","🍪","🎂","🍰","🍫","🍬","🍭","🍺","🍻","🍷","🍸","🍹","🍎","🍊","🍋","🍒","🍇","🍉","🍓","🍑","🍈","🍌","🍐","🍍","🌹","🌸","🌺","🌻","🌼","🌷","🍀","🍁","🍂","🍃","🍄","🌈","🌙","🌎","🌋","🌊"},}
local Players=game:GetService("Players")local UIS=game:GetService("UserInputService")local HttpService=game:GetService("HttpService")local TeleportService=game:GetService("TeleportService")
local SoundService=game:GetService("SoundService")local ContentProvider=game:GetService("ContentProvider")local TextService=game:GetService("TextService")local Debris=game:GetService("Debris")
local LP=Players.LocalPlayer if not LP then return end local IS_MOBILE=UIS.TouchEnabled and not UIS.KeyboardEnabled local function viewNow()local cam=workspace.CurrentCamera
if cam and cam.ViewportSize.X>1 then return cam.ViewportSize end return Vector2.new(1280,720)end local httpFn=(type(syn)=="table"and syn.request)or(type(request)=="function"and request)
or(type(http_request)=="function"and http_request)or(type(http)=="table"and http.request)or(type(fluxus)=="table"and fluxus.request)or(type(xeno)=="table"and xeno.request)or(type(delta)=="table"and delta.request)
if not httpFn then warn("[CB42] Executor không có HTTP.")return end local EXEC=IS_MOBILE and"Delta"or"Xeno"pcall(function()if identifyexecutor then EXEC=tostring(identifyexecutor())end end)
local P,S,U,F,H={},{},{},{},{}local u2,uo,us,u1=UDim2.new,UDim2.fromOffset,UDim2.fromScale,UDim.new local rgb,c3,v2=Color3.fromRGB,Color3.new,Vector2.new
local fGB,fG,fCode=Enum.Font.GothamBold,Enum.Font.Gotham,Enum.Font.Code local asY,asX,soLO=Enum.AutomaticSize.Y,Enum.AutomaticSize.X,Enum.SortOrder.LayoutOrder
local fdH,fdV,vaC=Enum.FillDirection.Horizontal,Enum.FillDirection.Vertical,Enum.VerticalAlignment.Center
local txL,txC,txR,trEnd=Enum.TextXAlignment.Left,Enum.TextXAlignment.Center,Enum.TextXAlignment.Right,Enum.TextTruncate.AtEnd
local smBorder,mb1,utTouch=Enum.ApplyStrokeMode.Border,Enum.UserInputType.MouseButton1,Enum.UserInputType.Touch local clamp,floor,max,min=math.clamp,math.floor,math.max,math.min
local tinsert,tremove,tconcat,tsort=table.insert,table.remove,table.concat,table.sort function H.jenc(v)local ok,s=pcall(HttpService.JSONEncode,HttpService,v);return ok and s or nil end function H.jdec(s)
if type(s)~="string"or s==""then return nil end local ok,v=pcall(HttpService.JSONDecode,HttpService,s)return ok and v or nil end function H.now()return os.time()end
function H.uuid()return HttpService:GenerateGUID(false)end function H.num(n)return string.format("%.0f",tonumber(n)or 0)end function H.url(s)return HttpService:UrlEncode(tostring(s or""))end
function H.trim(s)return(tostring(s or""):gsub("^%s+",""):gsub("%s+$",""))end function H.esc(s)return(tostring(s or""):gsub("&","&amp;"):gsub("<","&lt;"):gsub(">","&gt;"))end function H.clip(s,n)s=tostring(s or"")
if#s<=n then return s end local cut=n while cut>0 do local b=s:byte(cut+1)if b and b>=0x80 and b<0xC0 then cut=cut-1 else break end end return s:sub(1,cut).."…"end local HEX_CACHE={}function H.hex(h,fallback)
local k=tostring(h or"")local cached=HEX_CACHE[k]if cached then return cached end local s=k:gsub("#","")if not s:match("^%x%x%x%x%x%x$")then return fallback or rgb(88,101,242)end
local c=rgb(tonumber(s:sub(1,2),16),tonumber(s:sub(3,4),16),tonumber(s:sub(5,6),16))HEX_CACHE[k]=c return c end function H.tohex(c)
return string.format("#%02X%02X%02X",clamp(floor(c.R*255+0.5),0,255),clamp(floor(c.G*255+0.5),0,255),clamp(floor(c.B*255+0.5),0,255))end function H.safeHex(c,d)c=tostring(c or"")
if c:match("^#%x%x%x%x%x%x$")then return c end return d or"#5865F2"end function H.lum(c)local function f(x)if x<=0.03928 then return x/12.92 end return((x+0.055)/1.055)^2.4 end
return 0.2126*f(c.R)+0.7152*f(c.G)+0.0722*f(c.B)end function H.contrast(a,b)local la,lb=H.lum(a),H.lum(b)if la<lb then la,lb=lb,la end return(la+0.05)/(lb+0.05)end
function H.mix(a,b,t)return c3(a.R+(b.R-a.R)*t,a.G+(b.G-a.G)*t,a.B+(b.B-a.B)*t)end function H.ensureContrast(fg,bg,minR)minR=minR or 4.2 if H.contrast(fg,bg)>=minR then return fg end local target=H.lum(bg)<0.45 and c3(1,1,1)or rgb(18,18,24) for step=1,8 do local cand=H.mix(fg,target,step/8)if H.contrast(cand,bg)>=minR then return cand end end return H.mix(fg,target,0.75)end local TW_CACHE,TW_COUNT,TW_BOUNDS={},0,v2(1000,100)function H.textW(text,ts,font)local s=tostring(text or"")if s==""then return 0 end
ts=ts or 12 font=font or fGB local key=tostring(font)..":"..ts..":"..s local v=TW_CACHE[key]if v then return v end local ok,sz=pcall(TextService.GetTextSize,TextService,s,ts,font,TW_BOUNDS)
v=(ok and sz)and math.ceil(sz.X)or(#s*floor(ts*0.62))if TW_COUNT>=900 then TW_CACHE,TW_COUNT={},0 end TW_CACHE[key],TW_COUNT=v,TW_COUNT+1 return v end function H.shortTime(ts)ts=tonumber(ts)
if not ts or ts<=0 then return""end local d=os.date("*t",ts)return string.format("%02d:%02d",d.hour,d.min)end function H.assetId(raw)raw=H.trim(raw)
local id=raw:match("^rbxassetid://(%d+)")or raw:match("^img:(%d+)$")or raw:match("/library/(%d+)")or raw:match("/catalog/(%d+)")or raw:match("[?&]id=(%d+)")or(raw:match("^%d+$")and raw or nil)
if id and#id>=5 and#id<=15 then return id end end local ROBLOX_EMOJI_FALLBACK={[0x1F309]="💬",[0x1F6E1]="👑",[0x1F9F9]="",[0x1F5D1]="",[0x1F4E8]="💬",[0x1F441]="👀",[0x23F9]="",[0x21BA]="",[0x21BB]="",[0x1F940]="🌹",[0x1F976]="😰",
[0x1F975]="🔥",[0x1F97A]="😢",[0x1F973]="🎉",[0x1F971]="😴",[0x1F92A]="😜",[0x1F92D]="😅",[0x1F92B]="😶",[0x1F92F]="😱",[0x1F92C]="😡",[0x1F929]="😍",[0x1F9E1]="💖",[0x1F90D]="💖",[0x1F90E]="💖",
[0x2764]="💖",[0x2665]="💖",[0x1F5A4]="💖",[0x1F5FF]="😎",[0x1F923]="😂",[0x1F921]="👻",[0x1F913]="😎",[0x1F914]="😮",[0x1F910]="😶",[0x1F911]="😎",[0x1F916]="👽",[0x1F917]="😊",[0x1F920]="😎",[0x1F924]="😋",
[0x1F918]="👌",[0x1F919]="👌",[0x1F91A]="👋",[0x1F91D]="👏",[0x1F91E]="🙏",[0x1F590]="👋",[0x1F596]="👋",[0x1F9E0]="💡",[0x1F9EA]="💎",[0x2705]="👍",[0x274C]="💢",[0x2728]="💫",[0x2B50]="🌟",[0x26A1]="💥",
[0x26A0]="🚨",[0x2600]="🌟",[0x2601]="",[0x2744]="",[0x2615]="🍺",[0x270C]="👌",[0x261D]="👆",[0x2709]="",[0x270F]="",[0x2699]="⚙️",[0x26D4]="",[0x23F3]="",[0x2713]="👍",[0x2714]="👍",[0x2715]="×",[0x2716]="×",
[0x27A4]=">",[0x2922]="",[0x25C9]="•",[0x25E2]="//",}
local function emojiWalk(s,stopZwj)s=tostring(s or"")local out,buf={},{}local function flush()if#buf==2 then out[#out+1]=utf8.char(buf[1],buf[2])elseif#buf==1 then out[#out+1]=utf8.char(buf[1])end buf={}end
local ok=pcall(function()for _,cp in utf8.codes(s)do if cp==0x200D then if stopZwj then break end elseif cp==0xFE0F or cp==0xFE0E or cp==0x20E3 or(cp>=0x1F3FB and cp<=0x1F3FF)then elseif cp>=0x1F1E6 and cp<=0x1F1FF then
buf[#buf+1]=cp if#buf==2 then flush()end else flush()local fb=ROBLOX_EMOJI_FALLBACK[cp]if fb~=nil then out[#out+1]=fb elseif(cp>=0x1F900 and cp<=0x1FAFF)or(cp>=0x2600 and cp<=0x27BF)then out[#out+1]=stopZwj and"💬"or""else out[#out+1]=utf8.char(cp)end end end flush()end)if not ok then return nil end return tconcat(out)end
function H.safeText(s)return emojiWalk(s,false)or tostring(s or"")end function H.safeEmoji(s)local r=emojiWalk(s,true)if not r or r==""then return"?"end return r end function H.flag(code)
code=tostring(code or""):upper()if#code~=2 or code=="??"then return"🌐"end local a,b=code:byte(1)-65,code:byte(2)-65 if a<0 or a>25 or b<0 or b>25 then return"🌐"end return utf8.char(0x1F1E6+a,0x1F1E6+b)end
function F.safeTap(id,fn,delay)delay=delay or 0.28 local now=os.clock()if S.tapLock[id]and now-S.tapLock[id]<delay then return end S.tapLock[id]=now fn()end
local hasIO=type(writefile)=="function"and type(readfile)=="function"and type(isfile)=="function"local FILE="cb42_"..tostring(LP.UserId)..".json"local function loadSave()if not hasIO then return{}end
local names={FILE}for v=41,30,-1 do tinsert(names,"cb"..v.."_"..tostring(LP.UserId)..".json")end for _,f in ipairs(names)do local ok,raw=pcall(function()if isfile(f)then return readfile(f)end end)if ok and raw then
local d=H.jdec(raw)if type(d)=="table"then return d end end end return{}end local saved=loadSave()local TXT={title={"Chat Bridge","Chat Bridge"},send={"Gửi","Send"},
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
fit_screen={"Vừa màn","Fit screen"},preview={"Xem trước","Preview"},sec_general={"Chung","General"},sec_appear={"Giao diện","Appearance"},
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
c_game={"Kênh game","Game"},c_general={"Kênh chung","General"},c_staff={"Kênh staff","Staff"},c_profile={"Mở hồ sơ","Open profile"},c_theme={"Đổi giao diện","Theme"},c_settings={"Cài đặt","Settings"},
c_lang={"Đổi ngôn ngữ","Language"},c_poll={"Tạo bình chọn","Create poll"},c_roles={"Quản lý role (Dev)","Manage roles (Dev)"},c_admin={"Bảng quản trị","Admin panel"},
c_report={"Báo cáo người dùng","Report user"},c_mute={"Cấm chat","Mute"},c_warn={"Cảnh báo","Warn"},c_unmute={"Gỡ cấm","Unmute"},c_unwarn={"Gỡ cảnh báo","Clear warns"},
c_react={"Thả cảm xúc vào tin đang trả lời","React to replied message"},c_request={"Xin quyền (mở form)","Request access (open form)"},c_status={"Đặt trạng thái: /status <chữ>","Set status: /status <text>"},
c_diag={"Chẩn đoán kết nối","Diagnostics"},c_back={"Về kênh chung","Back"},c_emoji={"Mở bảng emoji","Emoji picker"},status_set={"Đã đặt trạng thái.","Status updated."},
diag={"Chẩn đoán","Diagnostics"},resync={"Đồng bộ lại","Resync"},ping={"Ping","Ping"},diag_copy={"Copy báo cáo","Copy report"},
backup_copy={"Sao lưu cài đặt","Backup settings"},backup_paste={"Dán CBS1:… để khôi phục","Paste CBS1:… to restore"},
backup_import={"Khôi phục","Restore"},backup_ok={"Đã khôi phục.","Restored."},backup_bad={"Mã không hợp lệ.","Invalid code."},
clear_cache={"Xóa cache tin/ảnh","Clear cache"},cache_cleared={"Đã xóa cache.","Cache cleared."},actions={"Hành động","Actions"},hold_hint={"Giữ để mở menu","Hold to open menu"},scriptstab={"Scripts","Scripts"},
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
proxy_panel={"HỆ THỐNG MULTI-PROXY & BACKUP (400K REQ/NGÀY)","MULTI-PROXY & FAILOVER POOL (400K REQ/DAY)"},proxy_ping_all={"Đo Ping Tất Cả Proxy","Ping Test All Proxies"},
proxy_active={"[ĐANG DÙNG]","[ACTIVE]"},proxy_use={"Chuyển","Use"},c_rejoin={"Vào lại server hiện tại ngay lập tức","Rejoin current game server immediately"},
c_hop={"Chuyển sang server khác của game","Hop to another server of this game"},c_copyjob={"Sao chép JobId / PlaceId server hiện tại","Copy current server JobId / PlaceId"},
c_clear={"Làm sạch khung nhìn tin nhắn hiện tại","Clear current message view"},c_invite={"Gửi thẻ mời mọi người vào chung server","Send 1-click server invite card to chat"},
c_fps={"Xem FPS, Ping mạng và thông tin server","Check FPS, Ping and server stats"},
join_srv_btn={"Vào Server Cùng Nhau","Join This Server"},join_srv_self={"Bạn đang ở trong server này rồi!","You are already in this server!"},
delta_tp_note={"Lưu ý: Hãy TẮT 'Verify Teleports' trong cài đặt Delta / Executor để vào chung server không bị chặn!","Note: Turn OFF 'Verify Teleports' in Delta / Executor settings so joining servers isn't blocked!"},
delta_tp_short={"Nhớ tắt 'Verify Teleports' ở cài đặt Delta trước khi bấm Tham gia","Turn OFF 'Verify Teleports' in Delta settings before joining"},announcetab={"Thông báo","Announce"},
announce_ro={"Chỉ Developer, Admin & Tester mới được đăng trong kênh Thông báo","Only Developer, Admin & Tester can post in Announce"},
announce_ph={"Nhập thông báo hoặc Script Logs (Dev/Admin/Tester)...","Write announcement or Script Logs (Dev/Admin/Tester)..."},
role_announce={"Quyền đăng kênh Announce / Logs (Tester)","Can post in Announce / Logs channel (Tester)"},
nano_cube={"60×60","60×60"},expand_ui={"Mở rộng","Expand"},}local L=saved.lang=="en"and"en"or"vi"local function T(k)local v=TXT[k]if not v then return k end return v[L=="en"and 2 or 1]end local THEMES={
rose={bg="#FFF0F5",bg2="#FFFFFF",bg3="#FFE0EC",title="#FFC8DD",text="#4A1228",muted="#9E4E6E",accent="#FF3E78",danger="#E11D48",ok="#10B981",warn="#F59E0B",own="#FFD4E5",mention="#FFF0B8"},
sakura={bg="#FFF5F9",bg2="#FFFFFF",bg3="#FCE4EC",title="#F8BBD0",text="#3D1828",muted="#8C546B",accent="#EC407A",danger="#E53935",ok="#00BFA5",warn="#FB8C00",own="#F8D7E4",mention="#FFF8CC"},
mint={bg="#F0FDF4",bg2="#FFFFFF",bg3="#DCFCE7",title="#BBF7D0",text="#064E3B",muted="#3B7A57",accent="#10B981",danger="#EF4444",ok="#059669",warn="#D97706",own="#D1FAE5",mention="#FEF3C7"},
sky={bg="#F0F9FF",bg2="#FFFFFF",bg3="#E0F2FE",title="#BAE6FD",text="#0C4A6E",muted="#437496",accent="#0284C7",danger="#E11D48",ok="#16A34A",warn="#EA580C",own="#D4EEFC",mention="#FEF08A"},
lavender={bg="#F5F3FF",bg2="#FFFFFF",bg3="#EDE9FE",title="#DDD6FE",text="#2E1065",muted="#6D549E",accent="#7C3AED",danger="#E11D48",ok="#10B981",warn="#D97706",own="#E4DCFE",mention="#FEF3C7"},
peach={bg="#FFF7ED",bg2="#FFFFFF",bg3="#FFEDD5",title="#FED7AA",text="#431407",muted="#9A5B3E",accent="#F97316",danger="#DC2626",ok="#16A34A",warn="#D97706",own="#FFE4C4",mention="#FEF08A"},
light={bg="#F2F4F8",bg2="#FFFFFF",bg3="#E4E7EC",title="#D5D9E2",text="#0F172A",muted="#586174",accent="#5865F2",danger="#DA373C",ok="#16A34A",warn="#D97706",own="#E0E7FF",mention="#FEF08A"},
midnight={bg="#0E0E12",bg2="#16161D",bg3="#1E1E28",title="#09090C",text="#F4F4F6",muted="#8E8EA0",accent="#7C6AF7",danger="#EF4444",ok="#4ADE80",warn="#FBBF24",own="#261F46",mention="#42321B"},
dark={bg="#313338",bg2="#2B2D31",bg3="#383A40",title="#1E1F22",text="#F2F3F5",muted="#949BA4",accent="#5865F2",danger="#ED4245",ok="#57F287",warn="#FAA81A",own="#3A3454",mention="#4A3A24"},
rose_noir={bg="#1A0A11",bg2="#261019",bg3="#351724",title="#11060B",text="#FFE4EE",muted="#C4849A",accent="#FF4D79",danger="#FF2A4B",ok="#34D399",warn="#FBBF24",own="#421C2E",mention="#4A2C22"},
nord={bg="#2E3440",bg2="#3B4252",bg3="#434C5E",title="#242933",text="#ECEFF4",muted="#A3BE8C",accent="#88C0D0",danger="#BF616A",ok="#A3BE8C",warn="#EBCB8B",own="#4C566A",mention="#5E4F3A"},
amoled={bg="#000000",bg2="#0A0A0C",bg3="#141418",title="#000000",text="#FFFFFF",muted="#8A8A93",accent="#3B82F6",danger="#F43F5E",ok="#22C55E",warn="#F59E0B",own="#111A2E",mention="#2E2208"},
ocean={bg="#0F1B2D",bg2="#14253B",bg3="#1B3252",title="#0A1424",text="#E6F1FF",muted="#8FB0D6",accent="#38BDF8",danger="#F87171",ok="#34D399",warn="#FBBF24",own="#173A5E",mention="#4A3B1C"},
forest={bg="#17221C",bg2="#1D2B23",bg3="#26382D",title="#101914",text="#E8F5EC",muted="#93B5A0",accent="#4ADE80",danger="#F87171",ok="#86EFAC",warn="#FACC15",own="#25402F",mention="#4A4120"},
dracula={bg="#282A36",bg2="#21222C",bg3="#343746",title="#191A21",text="#F8F8F2",muted="#9AA5CE",accent="#BD93F9",danger="#FF5555",ok="#50FA7B",warn="#F1FA8C",own="#3B3556",mention="#4D4A2A"},
sunset={bg="#2B1B1F",bg2="#36232A",bg3="#442C35",title="#1F1216",text="#FFEFE6",muted="#D1A08F",accent="#FB923C",danger="#EF4444",ok="#84CC16",warn="#FACC15",own="#523036",mention="#5A4420"},
cyber={bg="#0A0A12",bg2="#12121C",bg3="#1A1A28",title="#06060C",text="#E0E0FF",muted="#8080A0",accent="#00F0FF",danger="#FF2060",ok="#00FF9D",warn="#FFE600",own="#1A2040",mention="#302040"},
void={bg="#050508",bg2="#0A0A10",bg3="#101018",title="#000004",text="#F0F0F8",muted="#606070",accent="#A020F0",danger="#FF0040",ok="#20F0A0",warn="#F0A020",own="#180828",mention="#281018"},
gold={bg="#1A1408",bg2="#2A2010",bg3="#3A2C18",title="#100C04",text="#FFF8E0",muted="#C0A070",accent="#FFD700",danger="#FF4500",ok="#32CD32",warn="#FFA500",own="#3A3018",mention="#4A3A20"},
catppuccin={bg="#1E1E2E",bg2="#181825",bg3="#313244",title="#11111B",text="#CDD6F4",muted="#A6ADC8",accent="#CBA6F7",danger="#F38BA8",ok="#A6E3A1",warn="#F9E2AF",own="#362C47",mention="#45382B"},
emerald={bg="#091914",bg2="#0E241D",bg3="#16362B",title="#05100C",text="#E6FFF5",muted="#7AB8A0",accent="#10B981",danger="#F43F5E",ok="#34D399",warn="#FBBF24",own="#134030",mention="#383014"},}
local THEME_ORDER={"rose","sakura","mint","sky","lavender","peach","light","midnight","dark","catppuccin","emerald","rose_noir","nord","amoled","ocean","forest","dracula","sunset","cyber","void","gold"}local COLOR_GROUPS={
{"grp_bg",{"bg","bg2","bg3","title"}},{"grp_text",{"text","muted"}},{"grp_accent",{"accent","own","mention","mentionText","emojiText"}},{"grp_state",{"danger","ok","warn"}},}
local ACCENTS={"#5865F2","#7C6AF7","#BD93F9","#F472B6","#EF4444","#FB923C","#FACC15","#84CC16","#4ADE80","#2DD4BF","#38BDF8","#3B82F6","#FFFFFF","#94A3B8"}local TH,reg={},{}P.clientId=saved.clientId or H.uuid()
P.username,P.userId=LP.Name,LP.UserId P.display=saved.display or LP.DisplayName or LP.Name P.status,P.bio=saved.status or"",saved.bio or""P.country=saved.country or"??"
P.dmList=type(saved.dmList)=="table"and saved.dmList or{}P.customEmojis=type(saved.customEmojis)=="table"and saved.customEmojis or{}P.recentEmoji=type(saved.recentEmoji)=="table"and saved.recentEmoji or{}
P.recentColors=type(saved.recentColors)=="table"and saved.recentColors or{}P.themeName=THEMES[saved.themeName]and saved.themeName or"midnight"P.custom=type(saved.custom)=="table"and saved.custom or{}
P.alpha=clamp(tonumber(saved.alpha)or 0,0,0.85)P.mute=type(saved.mute)=="table"and saved.mute or{on=false,reason="",exp=0,by=""}P.W=tonumber(saved.W or saved.width)or(IS_MOBILE and 300 or 380)
P.H=tonumber(saved.H or saved.height)or(IS_MOBILE and 360 or 300)P.notify=saved.notify~=false P.sound=saved.sound~=false P.bubble=saved.bubble~=false P.safeEmoji=saved.safeEmoji~=false P.showGame=saved.showGame~=false
P.preview=saved.preview~=false P.compact=saved.compact==true P.sameUser=saved.sameUser~=false P.group=saved.group~=false S.viewAs=false S.tapLock={}S.sameBb={}P.textSize=clamp(tonumber(saved.textSize)or 13,11,20)
P.toastPos=saved.toastPos or"tr"P.miniX,P.miniY=tonumber(saved.miniX),tonumber(saved.miniY)S.users,S.msgs,S.order,S.frames,S.frameQ={},{},{},{},{}S.polls=type(saved.polls)=="table"and saved.polls or{}
S.reactions=type(saved.reactions)=="table"and saved.reactions or{}S.seen,S.seenOld,S.seenN={},{},0 S.typing,S.unread,S.dmUnread={},{general=0,announce=0,game=0,scripts=0,staff=0},{}
S.roles=type(saved.roles)=="table"and saved.roles or{}S.sharedEmojis=type(saved.sharedEmojis)=="table"and saved.sharedEmojis or{}S.emojiSeq=0 S.scripts=type(saved.scripts)=="table"and saved.scripts or{}S.scriptSeq=0
S.scriptTagFilter="All"S.scriptMultiMode=false S.scriptSelected={}S.emojiMultiMode=false S.emojiSelected={}P.customEmojiNames=type(saved.customEmojiNames)=="table"and saved.customEmojiNames or{}
P.proxies=type(saved.proxies)=="table"and saved.proxies or{}P.savedScripts=type(saved.savedScripts)=="table"and saved.savedScripts or{}S.assign=type(saved.assign)=="table"and saved.assign or{}S.rolesSeq=0 S.devs={}
S.mutes,S.warns={},type(saved.warns)=="table"and saved.warns or{}S.reports=type(saved.reports)=="table"and saved.reports or{}S.myRequest=nil S.requests={}S.bannedList={}S.banned=nil
S.chan,S.search,S.orderN,S.reactAt="general","",0,0 S.lastSeq,S.booted,S.lpOn,S.lpFails,S.pollFail=0,false,CFG.LONGPOLL>0,0,0 S.lastPollOk,S.activityAt,S.t0=0,os.clock(),os.clock()
S.placeName,S.bubbles,S.isDirty,S.tapAt,S.lastType="?",{},false,{},0 S.winX,S.winY,S.lastSave=nil,nil,0 S.lastByChan,S.newBelow,S.assetOk,S.assetUrl,S.popN={},0,{},{},0 S.rtt,S.sendOk,S.sendFail=nil,0,0 S.holdState={}
if P.mute.on then S.mutes[P.username]=P.mute end for _,r in ipairs(S.roles)do r.position=tonumber(r.position)or 0 end do local norm,lower={},{}for u,v in pairs(S.assign)do local set={}
if type(v)=="string"then set[v]=true elseif type(v)=="table"then if#v>0 then for _,rid in ipairs(v)do set[rid]=true end else
for k,x in pairs(v)do if x==true then set[k]=true elseif type(x)=="string"then set[x]=true end end end end local lk=tostring(u):lower()local key=lower[lk]or u lower[lk]=key norm[key]=norm[key]or{}
for rid in pairs(set)do norm[key][rid]=true end end S.assign=norm end local handlers={}function F.on(evt,fn)handlers[evt]=handlers[evt]or{};tinsert(handlers[evt],fn);return fn end
function F.emit(evt,...)for _,fn in ipairs(handlers[evt]or{})do pcall(fn,...)end end local NET={alive=true,notBefore=0,lanes={send={},other={},fast={}},busy={},idx=1,cooldown={},fails={}}local conns={}
local function hook(sig,fn)local c=sig:Connect(fn);tinsert(conns,c);return c end local PROXY_POOL={}for _,u in ipairs(CFG.PROXIES or{CFG.PROXY})do u=H.trim(tostring(u or"")):gsub("/+$","")
if u:match("^https?://")then PROXY_POOL[#PROXY_POOL+1]=u end end if#PROXY_POOL==0 then PROXY_POOL[1]=CFG.PROXY end local function autoFailoverProxy()if#PROXY_POOL<=1 then return CFG.PROXY end local now=os.clock()
NET.cooldown[CFG.PROXY]=now+600 for offset=1,#PROXY_POOL do local idx=((NET.idx+offset-1)%#PROXY_POOL)+1 local cand=PROXY_POOL[idx]if(NET.cooldown[cand]or 0)<=now then NET.idx=idx CFG.PROXY=cand S.forceRoles=true
S.scriptSeq=0 return cand end end NET.idx=(NET.idx%#PROXY_POOL)+1 CFG.PROXY=PROXY_POOL[NET.idx]S.forceRoles=true return CFG.PROXY end local function isQuotaLimitReached(code,bodyRaw,data)
if code==1027 or code==1015 or code==503 then return true end if code==429 and not(type(data)=="table"and data.error=="rate")then return true end local lb=tostring(bodyRaw or""):lower()
if lb:find("1027",1,true)or lb:find("limit exceeded",1,true)or lb:find("workers.dev",1,true)and lb:find("error",1,true)then return true end return false end local function rawRequest(method,path,bodyTable)
local headers={["Content-Type"]="application/json"}local bodyStr=bodyTable~=nil and H.jenc(bodyTable)or nil local maxAttempts=max(3,#PROXY_POOL+1)for attempt=1,maxAttempts do
while NET.alive and os.clock()<NET.notBefore do task.wait(0.03)end if not NET.alive then return nil,"stopped"end local curUrl=CFG.PROXY local opts={Url=curUrl..path,Method=method,Headers=headers}
if bodyStr then opts.Body=bodyStr end local t0=os.clock()local ok,res=pcall(httpFn,opts)if ok and type(res)=="table"then local code=tonumber(res.StatusCode or res.Status)or 0 local data=H.jdec(res.Body)
if code>=200 and code<300 and type(data)=="table"then NET.fails[curUrl]=0 NET.cooldown[curUrl]=nil local dt=(os.clock()-t0)*1000 if method=="POST"or not path:find("wait=%d*[1-9]")then S.rtt=S.rtt and(S.rtt*0.7+dt*0.3)or dt end return data,nil,code
elseif code==429 and type(data)=="table"and data.error=="rate"then NET.notBefore=os.clock()+(tonumber(data.retry_after)or 1.2)+0.05 elseif isQuotaLimitReached(code,res.Body,data)then autoFailoverProxy()
elseif code>=500 or code==0 or type(data)~="table"then NET.fails[curUrl]=(NET.fails[curUrl]or 0)+1 if#PROXY_POOL>1 and NET.fails[curUrl]>=2 then autoFailoverProxy()else task.wait(0.15*attempt)end else
return type(data)=="table"and data or{},"HTTP "..tostring(code),code end else NET.fails[curUrl]=(NET.fails[curUrl]or 0)+1 if#PROXY_POOL>1 and NET.fails[curUrl]>=2 then autoFailoverProxy()else task.wait(0.12*attempt)end
end end return nil,"network"end local function drain(name)if NET.busy[name]then return end NET.busy[name]=true task.spawn(function()while NET.alive and#NET.lanes[name]>0 do local job=tremove(NET.lanes[name],1)
local data,err,code=rawRequest(job.method,job.path,job.body)if job.cb then pcall(job.cb,data,err,code)end end NET.busy[name]=false end)end local function enqueue(lane,method,path,body,cb)
if not NET.alive then return end if lane=="fast"and(NET.busy.fast or#NET.lanes.fast>0)then return end tinsert(NET.lanes[lane],{method=method,path=path,body=body,cb=cb})drain(lane)end function F.markSeen(id)
if S.seen[id]or S.seenOld[id]then return true end S.seen[id]=true S.seenN=S.seenN+1 if S.seenN>CFG.SEEN_MAX then S.seenOld=S.seen;S.seen={};S.seenN=0 end return false end function F.decode(content)
if type(content)~="string"then return nil end local body if content:sub(1,#CFG.PREFIX)==CFG.PREFIX then body=content:sub(#CFG.PREFIX+1)else for _,p in ipairs(CFG.LEGACY)do
if content:sub(1,#p)==p then body=content:sub(#p+1);break end end end return body and H.jdec(body)or nil end function F.netError(e)F.toast("! "..tostring(e or"network"),true)end function F.publish(pkt,lane,cb)
pkt.clientId=P.clientId pkt.packetId=pkt.packetId or H.uuid()pkt.ts=pkt.ts or H.now()F.markSeen(pkt.packetId)local raw=H.jenc(pkt)if not raw then if cb then cb(false,"encode")end return end
local content=CFG.PREFIX..raw if#content>1900 then if cb then cb(false,"big")end return end enqueue(lane or"send","POST","/api/send",{content=content},function(data,err)
if data and data.ok then S.sendOk=S.sendOk+1;if cb then cb(true)end return end S.sendFail=S.sendFail+1 local e=(data and data.error)or err
if e=="muted"then F.applyMute(P.username,{on=true,reason=data.reason or"",exp=tonumber(data.exp)or 0,by=""})elseif e=="banned"then S.banned={reason=data.reason or"",exp=tonumber(data.exp)or 0}
F.toast(T("banned_you"),true)elseif pkt.type~="typing"then F.netError(e)end if cb then cb(false,e)end end)F.emit("send",pkt)end local function themed(o,fn)reg[#reg+1]={o=o,fn=fn};pcall(fn,o)end
local function th(o,prop,key,isBg)reg[#reg+1]={o=o,p=prop,k=key,a=isBg}pcall(function()o[prop]=TH[key]end)if isBg then pcall(function()o.BackgroundTransparency=P.alpha end)end end function F.pruneThemeReg()local keep={}for _,r in ipairs(reg)do if r.o and r.o.Parent then keep[#keep+1]=r end end reg=keep end
function F.computeTheme()
local base=THEMES[P.themeName]or THEMES.dark for k,v in pairs(base)do TH[k]=H.hex(P.custom[k]or v)end
TH.mentionText=P.custom.mentionText and H.hex(P.custom.mentionText)or H.ensureContrast(H.mix(TH.accent,TH.warn,0.32),TH.bg2,4.3)
TH.emojiText=P.custom.emojiText and H.hex(P.custom.emojiText)or H.ensureContrast(H.mix(TH.accent,TH.ok,0.22),TH.bg2,4.3)
end function F.paintTheme()F.computeTheme()local keep={}for _,r in ipairs(reg)do if r.o and r.o.Parent then
keep[#keep+1]=r if r.fn then pcall(r.fn,r.o)else pcall(function()r.o[r.p]=TH[r.k]end)if r.a then pcall(function()r.o.BackgroundTransparency=P.alpha end)end end end end reg=keep if F.paintTabs then pcall(F.paintTabs)end
if F.paintDot then pcall(F.paintDot)end if F.updateSuggest and U.input then pcall(F.updateSuggest)elseif F.updateTokenFeedback and U.input then pcall(F.updateTokenFeedback,U.input.Text)end F.emit("theme",P.themeName)end F.refreshTheme=F.paintTheme F.computeTheme()
local function mk(class,props,parent)local o=Instance.new(class)for k,v in pairs(props or{})do o[k]=v end if parent then o.Parent=parent end return o end
local function corner(o,r)return mk("UICorner",{CornerRadius=u1(0,r or 8)},o)end local function pad(o,l,t,r,b)
return mk("UIPadding",{PaddingLeft=u1(0,l or 0),PaddingTop=u1(0,t or 0),PaddingRight=u1(0,r or 0),PaddingBottom=u1(0,b or 0)},o)end local function stroke(o,key,thick,tr)
local s=mk("UIStroke",{Thickness=thick or 1,Transparency=tr or 0.5,ApplyStrokeMode=smBorder},o)th(s,"Color",key or"accent")return s end local function list(o,p,dir)
return mk("UIListLayout",{Padding=u1(0,p or 4),SortOrder=soLO,FillDirection=dir or fdV},o)end local function lab(parent,text,o)o=o or{}local l=mk("TextLabel",{
Text=text or"",BackgroundTransparency=1,BorderSizePixel=0,Size=o.size or u2(1,0,0,o.h or 18),Position=o.pos or u2(),Font=o.bold and fGB or fG,TextSize=o.ts or 12,
TextXAlignment=o.align or txL,TextYAlignment=o.valign or Enum.TextYAlignment.Center,TextWrapped=o.wrap==true,RichText=o.rich==true,LayoutOrder=o.layout or 0,TextTruncate=o.trunc and trEnd or Enum.TextTruncate.None,
},parent)if o.auto then l.AutomaticSize=asY;l.Size=u2(1,0,0,0)end th(l,"TextColor3",o.key or"text")return l end local function tbtn(parent,text,o)o=o or{}local key=o.key or"bg3"local b=mk("TextButton",{
Text=text or"",BorderSizePixel=0,AutoButtonColor=true,Font=fGB,TextSize=o.ts or 12,Size=o.size or u2(1,0,0,o.h or 30),Position=o.pos or u2(),LayoutOrder=o.layout or 0,TextWrapped=false,},parent)
th(b,"BackgroundColor3",key);corner(b,o.r or 8)if key=="accent"or key=="danger"or key=="ok"or key=="warn"then themed(b,function(x)x.TextColor3=H.lum(TH[key])>0.55 and rgb(20,20,24)or c3(1,1,1)end)
else th(b,"TextColor3","text")end if o.fn then hook(b.MouseButton1Click,o.fn)end return b end local function field(parent,label,value,multi,layout)
if label and label~=""then lab(parent,label,{h=14,ts=10,bold=true,key="muted",layout=layout})end local b=mk("TextBox",{Text=value or"",PlaceholderText="",ClearTextOnFocus=false,Font=fG,TextSize=12,
Size=u2(1,0,0,multi and 60 or 28),BorderSizePixel=0,TextXAlignment=txL,TextYAlignment=multi and Enum.TextYAlignment.Top or Enum.TextYAlignment.Center,MultiLine=multi==true,TextWrapped=multi==true,
PlaceholderColor3=rgb(130,130,140),},parent)th(b,"BackgroundColor3","bg3");th(b,"TextColor3","text");th(b,"PlaceholderColor3","muted");corner(b,7);pad(b,8,4,8,4)return b end local function row(parent,h,layout)
local r=mk("Frame",{Size=u2(1,0,0,h or 30),BackgroundTransparency=1,LayoutOrder=layout or 0},parent)mk("UIListLayout",{FillDirection=fdH,Padding=u1(0,6),SortOrder=soLO,VerticalAlignment=vaC},r)return r end
local function rbtn(r,text,o)o=o or{};o.size=o.size or u2(0.5,-3,1,0);return tbtn(r,text,o)end function F.section(parent,title)local f=mk("Frame",{Size=u2(1,0,0,22),BackgroundTransparency=1},parent)
lab(f,string.upper(title),{size=u2(1,0,0,16),pos=uo(0,6),ts=10,bold=true,key="accent"})return f end function F.card(parent,h)local c=mk("Frame",{Size=u2(1,0,0,h or 40),BorderSizePixel=0},parent)
th(c,"BackgroundColor3","bg3");corner(c,8)return c end function F.switch(parent,text,get,set)local r=mk("TextButton",{Size=u2(1,0,0,32),Text="",BorderSizePixel=0,AutoButtonColor=true},parent)
th(r,"BackgroundColor3","bg3");corner(r,8)lab(r,text,{size=u2(1,-62,1,0),pos=uo(10,0),trunc=true})local track=mk("Frame",{Size=uo(36,18),Position=u2(1,-46,0.5,-9),BorderSizePixel=0},r)corner(track,9)
local knob=mk("Frame",{Size=uo(14,14),BorderSizePixel=0,BackgroundColor3=c3(1,1,1)},track)corner(knob,7)local function paint()local on=get()==true track.BackgroundColor3=on and TH.accent or TH.muted
knob.Position=on and uo(20,2)or uo(2,2)end themed(track,paint)hook(r.MouseButton1Click,function()set(not get());paint()end)return r end function F.track(frame,fn,done)hook(frame.InputBegan,function(i)
local ut=i.UserInputType if ut~=mb1 and ut~=utTouch then return end local sc=frame:FindFirstAncestorWhichIsA("ScrollingFrame")if sc then sc.ScrollingEnabled=false end S.track={input=i,fn=fn,done=done,sc=sc}
pcall(fn,i.Position)end)end function F.endTrack()local tk=S.track if not tk then return end S.track=nil if tk.sc then pcall(function()tk.sc.ScrollingEnabled=true end)end if tk.done then pcall(tk.done)end end
function F.slider(parent,text,mn,mx,val,o)o=o or{}local box=mk("Frame",{Size=u2(1,0,0,44),BackgroundTransparency=1},parent)local head=lab(box,"",{size=u2(1,0,0,16),ts=11,bold=true,key="muted"})
local bar=mk("Frame",{Size=u2(1,-16,0,8),Position=uo(8,28),BorderSizePixel=0},box)th(bar,"BackgroundColor3","bg3");corner(bar,4)local fill=mk("Frame",{Size=u2(0,0,1,0),BorderSizePixel=0},bar)
th(fill,"BackgroundColor3","accent");corner(fill,4)local knob=mk("Frame",{Size=uo(16,16),AnchorPoint=v2(0.5,0.5),Position=u2(0,0,0.5,0),BorderSizePixel=0,BackgroundColor3=c3(1,1,1),ZIndex=2},bar)corner(knob,8)
local hit=mk("TextButton",{Text="",BackgroundTransparency=1,Size=u2(1,0,0,28),Position=uo(0,18),AutoButtonColor=false,ZIndex=3},box)local cur=val local function set(v,fire)v=clamp(v,mn,mx)
if o.step then v=floor(v/o.step+0.5)*o.step end cur=v local f=(mx>mn)and(v-mn)/(mx-mn)or 0 fill.Size=u2(f,0,1,0)knob.Position=u2(f,0,0.5,0)head.Text=text..": "..(o.fmt and o.fmt(v)or tostring(v))
if fire and o.onChange then o.onChange(v)end end F.track(hit,function(pos)set(mn+clamp((pos.X-bar.AbsolutePosition.X)/max(1,bar.AbsoluteSize.X),0,1)*(mx-mn),true)end,function()if o.onDone then o.onDone(cur)end end)
set(val,false)return box,set end function F.pushRecentColor(hex)hex=H.safeHex(hex,nil)if not hex then return end for i=#P.recentColors,1,-1 do if P.recentColors[i]==hex then tremove(P.recentColors,i)end end
tinsert(P.recentColors,1,hex)while#P.recentColors>10 do tremove(P.recentColors)end S.isDirty=true end function F.colorPicker(parent,startHex,onChange,onDone)local c0=H.hex(startHex)local hh,ss,vv=Color3.toHSV(c0)
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
th(hexBox,"BackgroundColor3","bg3");th(hexBox,"TextColor3","text");corner(hexBox,6);pad(hexBox,8,0,8,0)local rec=mk("Frame",{Size=u2(1,0,0,22),Position=uo(0,172),BackgroundTransparency=1},box)
mk("UIListLayout",{FillDirection=fdH,Padding=u1(0,4),SortOrder=soLO,VerticalAlignment=vaC},rec)local obj={frame=box}local last=0 local function cur()return Color3.fromHSV(hh,ss,vv)end local function emit(force)
local t=os.clock()if force or t-last>=0.05 then last=t;if onChange then onChange(H.tohex(cur()))end end end local function render()sv.BackgroundColor3=Color3.fromHSV(hh,1,1)knob.Position=u2(ss,0,1-vv,0)
hk.Position=u2(0.5,0,hh,0)swatch.BackgroundColor3=cur()hexBox.Text=H.tohex(cur())end local function finish()emit(true);F.pushRecentColor(H.tohex(cur()));if onDone then onDone(H.tohex(cur()))end end
F.track(sv,function(pos)ss=clamp((pos.X-sv.AbsolutePosition.X)/max(1,sv.AbsoluteSize.X),0,1)vv=1-clamp((pos.Y-sv.AbsolutePosition.Y)/max(1,sv.AbsoluteSize.Y),0,1)render();emit(false)end,finish)
F.track(hue,function(pos)hh=clamp((pos.Y-hue.AbsolutePosition.Y)/max(1,hue.AbsoluteSize.Y),0,0.999)render();emit(false)end,finish)hook(hexBox.FocusLost,function()local h=H.trim(hexBox.Text)
if not h:find("^#")then h="#"..h end if h:match("^#%x%x%x%x%x%x$")then hh,ss,vv=Color3.toHSV(H.hex(h));render();finish()else render()end end)local n=0 for _,hx in ipairs(P.recentColors)do n=n+1 if n>9 then break end
local b=mk("TextButton",{Text="",Size=uo(20,20),BackgroundColor3=H.hex(hx),BorderSizePixel=0,LayoutOrder=n},rec)corner(b,5);stroke(b,"muted",1,0.6)
hook(b.MouseButton1Click,function()hh,ss,vv=Color3.toHSV(H.hex(hx));render();emit(true);if onDone then onDone(hx)end end)end function obj.set(hex)hh,ss,vv=Color3.toHSV(H.hex(hex));render()end
function obj.get()return H.tohex(cur())end render()return obj end function F.setAsset(img,id,onLoad)S.assetUrl=S.assetUrl or{}id=tostring(id or"")local known=S.assetUrl[id]if known then
img.Image=known;img.ImageTransparency=0 if onLoad then onLoad(true)end return end local urls={"rbxthumb://type=Asset&id="..id.."&w=420&h=420","rbxassetid://"..id,"rbxthumb://type=Asset&id="..id.."&w=150&h=150",}
task.spawn(function()for _,u in ipairs(urls)do if not img.Parent then return end img.Image=u img.ImageTransparency=0 pcall(function()ContentProvider:PreloadAsync({img})end)local t0=os.clock()
while img.Parent and not img.IsLoaded and os.clock()-t0<2.4 do task.wait(0.1)end if img.Parent and(img.IsLoaded or img.Image~="")then S.assetUrl[id]=u img.ImageTransparency=0 if onLoad then onLoad(true)end return end end
if img.Parent then img.Image=urls[1];img.ImageTransparency=0 end if onLoad then onLoad(img.Parent~=nil)end end)end function F.iconBox(parent,spec,sz,o)o=o or{}spec=tostring(spec or"")
local f=mk("Frame",{Size=uo(sz,sz),BackgroundTransparency=1,BorderSizePixel=0,LayoutOrder=o.layout or 0},parent)local id=spec:match("^img:(%d+)$")if id then
local ph=lab(f,"",{size=us(1,1),ts=max(10,sz-8),align=txC,key="muted"})local im=mk("ImageLabel",{Size=us(1,1),BackgroundTransparency=1,ScaleType=Enum.ScaleType.Fit,BorderSizePixel=0,ImageTransparency=0,ZIndex=2},f)
corner(im,max(4,floor(sz/8)))F.setAsset(im,id,function(ok)if ph.Parent then ph.Text=ok and""or"?"end end)elseif spec~=""then
local t=mk("TextLabel",{Size=us(1,1),BackgroundTransparency=1,Text=P.safeEmoji and H.safeEmoji(spec)or spec,Font=Enum.Font.SourceSansBold,TextSize=max(10,sz-4),BorderSizePixel=0},f)th(t,"TextColor3","text")end return f
end local guiParent pcall(function()if gethui then guiParent=gethui()end end)if not guiParent then pcall(function()guiParent=game:GetService("CoreGui")end)end
if not guiParent then guiParent=LP:WaitForChild("PlayerGui")end pcall(function()for _,c in ipairs(guiParent:GetChildren())do
if c.Name=="CB43_GUI"or c.Name=="CB42_GUI"or c.Name=="CB41_GUI"or c.Name=="CB40_GUI"or c.Name=="CB39_GUI"or c.Name=="CB38_GUI"or c.Name=="CB37_GUI"then c:Destroy()end end end)
U.gui=mk("ScreenGui",{Name="CB42_GUI",ResetOnSpawn=false,ZIndexBehavior=Enum.ZIndexBehavior.Sibling,IgnoreGuiInset=true,DisplayOrder=99999})pcall(function()if syn and syn.protect_gui then syn.protect_gui(U.gui)end end)
U.gui.Parent=guiParent U.mini=mk("TextButton",{Size=uo(42,42),Position=uo(P.miniX or 12,P.miniY or 80),Text="💬",TextSize=20,Font=fGB,BorderSizePixel=0,Visible=false,ZIndex=50},U.gui)
th(U.mini,"BackgroundColor3","accent");corner(U.mini,21)
U.miniBadge=mk("TextLabel",{Size=uo(18,18),Position=u2(1,-8,0,-4),Text="",TextSize=10,Font=fGB,TextColor3=c3(1,1,1),BorderSizePixel=0,Visible=false,ZIndex=51},U.mini)
th(U.miniBadge,"BackgroundColor3","danger");corner(U.miniBadge,9)U.main=mk("Frame",{Size=uo(P.W,P.H),Position=uo(60,60),BorderSizePixel=0,ClipsDescendants=true,Active=true},U.gui)
th(U.main,"BackgroundColor3","bg",true);corner(U.main,12);stroke(U.main,"accent",1.2,0.45)U.titleBar=mk("Frame",{Size=u2(1,0,0,34),BorderSizePixel=0,ZIndex=5},U.main)th(U.titleBar,"BackgroundColor3","title")
U.titleGrad=mk("UIGradient",{Rotation=15},U.titleBar)themed(U.titleGrad,function(g)g.Color=ColorSequence.new(TH.title,H.mix(TH.title,TH.accent,0.16))end)
U.dot=mk("Frame",{Size=uo(8,8),Position=uo(10,13),BorderSizePixel=0,ZIndex=6},U.titleBar)corner(U.dot,4)function F.paintDot()local c=(S.pollFail<2 and TH.ok)or TH.danger U.dot.BackgroundColor3=c if U.infoDot then U.infoDot.BackgroundColor3=c end end
U.titleLbl=lab(U.titleBar,T("title"),{size=u2(1,-196,1,0),pos=uo(24,0),bold=true,ts=13,trunc=true})U.titleLbl.ZIndex=6
U.tbtns=mk("Frame",{Size=uo(180,34),Position=u2(1,-184,0,0),BackgroundTransparency=1,ZIndex=6},U.titleBar)
mk("UIListLayout",{FillDirection=fdH,Padding=u1(0,3),SortOrder=soLO,VerticalAlignment=vaC,HorizontalAlignment=Enum.HorizontalAlignment.Right},U.tbtns)local function tb(text,order,w)
local b=mk("TextButton",{Size=uo(w or 26,24),BackgroundTransparency=0.2,Text=text,Font=fGB,TextSize=11,BorderSizePixel=0,LayoutOrder=order,AutoButtonColor=true,ZIndex=7},U.tbtns)
th(b,"BackgroundColor3","bg3");th(b,"TextColor3","text");corner(b,7)return b end
U.bLang,U.bFind,U.bUsers,U.bMe,U.bSet,U.bMin=tb(L=="en"and"EN"or"VI",1,28),tb("🔍",2,26),tb("👥",3,26),tb("👤",4,26),tb("⚙️",5,26),tb("-",6,24)
U.nanoBox=mk("Frame",{Size=u2(1,0,1,-22),Position=uo(0,22),BackgroundTransparency=1,Visible=false,ZIndex=12},U.main)
U.nanoBtn=mk("TextButton",{Size=u2(1,-8,1,-4),Position=uo(4,2),Text="💬",Font=fGB,TextSize=16,BorderSizePixel=0,AutoButtonColor=true,ZIndex=13},U.nanoBox)
th(U.nanoBtn,"BackgroundColor3","bg3");th(U.nanoBtn,"TextColor3","accent");corner(U.nanoBtn,8)
U.nanoBadge=mk("TextLabel",{Size=uo(18,16),Position=u2(1,-20,0,2),Text="",Font=fGB,TextSize=9,TextColor3=c3(1,1,1),BorderSizePixel=0,Visible=false,ZIndex=14},U.nanoBox)
th(U.nanoBadge,"BackgroundColor3","danger");corner(U.nanoBadge,8)hook(U.nanoBtn.MouseButton1Click,function()P.W=S.prevW and S.prevW>=260 and S.prevW or(IS_MOBILE and 340 or 420)
P.H=S.prevH and S.prevH>=260 and S.prevH or(IS_MOBILE and 460 or 520)S.isDirty=true F.layout()end)U.divider=mk("Frame",{Size=u2(1,0,0,1),Position=uo(0,34),BorderSizePixel=0,ZIndex=2},U.main)
th(U.divider,"BackgroundColor3","bg3")U.tabsBar=mk("Frame",{Size=u2(1,-12,0,28),Position=uo(6,38),BackgroundTransparency=1},U.main)mk("UIListLayout",{FillDirection=fdH,Padding=u1(0,4),SortOrder=soLO},U.tabsBar)
U.tabs,U.tabStrokes={},{}local TAB_DEFS={{"general","general","💬"},{"announce","announcetab","📢"},{"game","game","🎮"},{"scripts","scriptstab","📜"},{"dm","dmtab","💭"},{"staff","stafftab","👑"},}
U.tabBars={}for i,d in ipairs(TAB_DEFS)do local b=mk("TextButton",{Size=u2(1/6,-3,1,0),Text="",BorderSizePixel=0,Font=fGB,TextSize=11,LayoutOrder=i,AutoButtonColor=true,ClipsDescendants=true},U.tabsBar)corner(b,8)
U.tabStrokes[d[1]]=mk("UIStroke",{Color=TH.bg3,Thickness=1,Transparency=0.45,ApplyStrokeMode=smBorder},b)
U.tabBars[d[1]]=mk("Frame",{Size=u2(0.55,0,0,2),Position=u2(0.225,0,1,-2),BorderSizePixel=0,Visible=false},b)corner(U.tabBars[d[1]],1)
U.tabs[d[1]]=b end function F.layoutTabs()local staff=F.isStaff and F.isStaff(P.username)
U.tabs.staff.Visible=staff==true local n=staff and 6 or 5 local gap=floor(((n-1)*4)/n)for _,d in ipairs(TAB_DEFS)do if U.tabs[d[1]].Visible then U.tabs[d[1]].Size=u2(1/n,-gap,1,0)end end end function F.paintTabs()local totalUn=0
for _,d in ipairs(TAB_DEFS)do local b=U.tabs[d[1]]local st=U.tabStrokes and U.tabStrokes[d[1]]local on=S.chan==d[1]or(d[1]=="dm"and tostring(S.chan):sub(1,3)=="dm:")
local un=d[1]=="dm"and F.dmUnreadTotal()or(S.unread[d[1]]or 0)totalUn=totalUn+un local full=T(d[2])local iconOnly=d[3]or"💬"local lbl if P.W<215 then lbl=iconOnly elseif P.W<340 then
lbl=d[1]=="scripts"and"Scripts"or(d[1]=="announce"and(L=="en"and"Announce"or"T.Báo")or full)else lbl=full end b.Text=lbl..(un>0 and(" "..(un>9 and"9+"or un))or"")b.TextSize=P.W<230 and 12 or 11 b.BackgroundColor3=on and TH.accent or TH.bg2
local fg=on and(H.lum(TH.accent)>0.55 and rgb(20,20,24)or c3(1,1,1))or TH.muted b.TextColor3=fg if st then st.Color=on and TH.accent or TH.bg3 st.Transparency=on and 0.08 or 0.45 end
local tbBar=U.tabBars and U.tabBars[d[1]]if tbBar then tbBar.Visible=on tbBar.BackgroundColor3=fg end end if U.nanoBadge then
U.nanoBadge.Visible=totalUn>0 U.nanoBadge.Text=totalUn>9 and"9+"or tostring(totalUn)end end U.infoBar=mk("Frame",{Size=u2(1,-12,0,18),Position=uo(6,66),BorderSizePixel=0},U.main)
th(U.infoBar,"BackgroundColor3","bg2");corner(U.infoBar,6);stroke(U.infoBar,"bg3",1,0.5)
U.infoDot=mk("Frame",{Size=uo(6,6),Position=uo(7,6),BorderSizePixel=0},U.infoBar)corner(U.infoDot,3)themed(U.infoDot,function(d)d.BackgroundColor3=(S.pollFail<2 and TH.ok)or TH.danger end)
U.infoLbl=lab(U.infoBar,"",{size=u2(1,-22,1,0),pos=uo(18,0),ts=10,key="muted",trunc=true})
U.searchBox=mk("TextBox",{Size=u2(1,-12,0,24),Position=uo(6,86),Text="",PlaceholderText=T("search"),ClearTextOnFocus=false,Font=fG,TextSize=12,BorderSizePixel=0,Visible=false,TextXAlignment=txL},U.main)
th(U.searchBox,"BackgroundColor3","bg3");th(U.searchBox,"TextColor3","text");th(U.searchBox,"PlaceholderColor3","muted");corner(U.searchBox,7);pad(U.searchBox,8,0,8,0)
U.scroll=mk("ScrollingFrame",{Position=uo(6,86),Size=u2(1,-12,1,-155),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=3,CanvasSize=u2(),AutomaticCanvasSize=asY,ScrollingDirection=Enum.ScrollingDirection.Y},U.main)
list(U.scroll,4)U.typing=lab(U.main,"",{size=u2(1,-16,0,14),ts=10,key="muted"})U.tokenBar=mk("Frame",{Size=u2(1,-12,0,22),BorderSizePixel=0,Visible=false,ZIndex=18},U.main)
th(U.tokenBar,"BackgroundColor3","bg2");corner(U.tokenBar,7)U.tokenStroke=mk("UIStroke",{Color=TH.accent,Thickness=1.3,Transparency=0.15,ApplyStrokeMode=smBorder},U.tokenBar)
U.tokenAccent=mk("Frame",{Size=u2(0,3,1,-6),Position=uo(3,3),BackgroundColor3=TH.accent,BorderSizePixel=0,ZIndex=19},U.tokenBar)corner(U.tokenAccent,2)
U.tokenIconHolder=mk("Frame",{Size=uo(16,16),Position=uo(9,3),BackgroundTransparency=1,Visible=false,ZIndex=19},U.tokenBar)U.tokenLbl=lab(U.tokenBar,"",{size=u2(1,-100,1,0),pos=uo(10,0),ts=10,bold=true,trunc=true})
U.tokenLbl.ZIndex=19 U.tokenStatePill=mk("TextLabel",{Size=uo(78,16),Position=u2(1,-82,0.5,-8),BackgroundColor3=TH.ok,TextColor3=c3(1,1,1),Text="",Font=fGB,TextSize=9,BorderSizePixel=0,ZIndex=19},U.tokenBar)
corner(U.tokenStatePill,8)U.replyBar=mk("Frame",{Size=u2(1,-12,0,20),BorderSizePixel=0,Visible=false,ZIndex=16},U.main)th(U.replyBar,"BackgroundColor3","bg3");corner(U.replyBar,6)
U.replyLbl=lab(U.replyBar,"",{size=u2(1,-28,1,0),pos=uo(8,0),ts=10,key="muted",trunc=true})U.replyLbl.ZIndex=17
U.replyX=mk("TextButton",{Size=uo(22,20),Position=u2(1,-22,0,0),BackgroundTransparency=1,Text="X",TextSize=11,Font=fGB,BorderSizePixel=0,ZIndex=17},U.replyBar)th(U.replyX,"TextColor3","muted")
U.suggest=mk("ScrollingFrame",{Size=u2(1,-12,0,28),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=0,CanvasSize=u2(),AutomaticCanvasSize=asX,ScrollingDirection=Enum.ScrollingDirection.X,Visible=false,ZIndex=18},U.main)
mk("UIListLayout",{FillDirection=fdH,Padding=u1(0,4),SortOrder=soLO,VerticalAlignment=vaC},U.suggest)U.chatBar=mk("Frame",{Size=u2(1,-12,0,40),BorderSizePixel=0,ZIndex=12},U.main)
th(U.chatBar,"BackgroundColor3","bg2");corner(U.chatBar,11)U.chatBarStroke=mk("UIStroke",{Color=TH.bg3,Thickness=1.5,Transparency=0.25,ApplyStrokeMode=smBorder},U.chatBar)
U.cmdBtn=mk("TextButton",{Size=uo(26,30),Text="/",Font=fGB,TextSize=13,BorderSizePixel=0,AutoButtonColor=true,ZIndex=14},U.chatBar)
th(U.cmdBtn,"BackgroundColor3","bg3");th(U.cmdBtn,"TextColor3","accent");corner(U.cmdBtn,8)U.cmdBtnStroke=mk("UIStroke",{Color=TH.bg3,Thickness=1,Transparency=0.5,ApplyStrokeMode=smBorder},U.cmdBtn)
U.atBtn=mk("TextButton",{Size=uo(26,30),Text="@",Font=fGB,TextSize=12,BorderSizePixel=0,AutoButtonColor=true,ZIndex=14},U.chatBar)th(U.atBtn,"BackgroundColor3","bg3");th(U.atBtn,"TextColor3","mentionText");corner(U.atBtn,8)
U.atBtnStroke=mk("UIStroke",{Color=TH.bg3,Thickness=1,Transparency=0.5,ApplyStrokeMode=smBorder},U.atBtn)U.inputWrap=mk("Frame",{Size=u2(1,-170,0,32),BorderSizePixel=0,ClipsDescendants=true,ZIndex=13},U.chatBar)
th(U.inputWrap,"BackgroundColor3","bg3");corner(U.inputWrap,9)U.inputStroke=mk("UIStroke",{Color=TH.bg3,Thickness=1.4,Transparency=0.45,ApplyStrokeMode=smBorder},U.inputWrap)
U.tokenDot=mk("Frame",{Size=uo(7,7),Position=uo(7,12),BackgroundColor3=TH.muted,BorderSizePixel=0,ZIndex=15},U.inputWrap)corner(U.tokenDot,4)U.input=mk("TextBox",{Size=u2(1,-22,1,0),Position=uo(18,0),
BackgroundTransparency=1,Text="",PlaceholderText=T("input"),ClearTextOnFocus=false,Font=fG,TextSize=P.textSize,BorderSizePixel=0,TextXAlignment=txL,TextYAlignment=Enum.TextYAlignment.Center,TextWrapped=false,
ZIndex=16,},U.inputWrap)th(U.input,"PlaceholderColor3","muted")U.inputRich=mk("TextLabel",{Size=u2(1,-22,1,0),Position=uo(18,0),BackgroundTransparency=1,Text="",Font=fG,TextSize=P.textSize,BorderSizePixel=0,
TextXAlignment=txL,TextYAlignment=Enum.TextYAlignment.Center,TextWrapped=false,RichText=true,Visible=false,Active=false,ZIndex=15,},U.inputWrap)pcall(function()U.inputRich.Interactable=false end)
U.emojiBtn=tbtn(U.chatBar,"😀",{size=uo(30,30),ts=14,r=8});U.emojiBtn.ZIndex=15 U.emojiBtnStroke=mk("UIStroke",{Color=TH.bg3,Thickness=1,Transparency=0.5,ApplyStrokeMode=smBorder},U.emojiBtn)
U.pollBtn=tbtn(U.chatBar,"📊",{size=uo(30,30),ts=13,r=8});U.pollBtn.ZIndex=15 U.sendBtn=tbtn(U.chatBar,T("send"),{size=uo(54,30),key="accent",r=8});U.sendBtn.ZIndex=15 hook(U.cmdBtn.MouseButton1Click,function()
local cur=U.input.Text if cur:sub(1,1)=="/"then U.input.Text=cur:gsub("^/%S*%s*","")else U.input.Text="/"..cur end F.updateSuggest()task.defer(function()if U.input and U.input.Parent then
pcall(function()U.input.CursorPosition=#U.input.Text+1 end)pcall(function()U.input:CaptureFocus()end)end end)end)hook(U.atBtn.MouseButton1Click,function()local cur=U.input.Text if cur:match("@[%w_]*$")then
U.input.Text=cur:gsub("@[%w_]*$","")else local sep=(cur~=""and not cur:match("%s$"))and" "or""U.input.Text=cur..sep.."@"end F.updateSuggest()task.defer(function()if U.input and U.input.Parent then
pcall(function()U.input.CursorPosition=#U.input.Text+1 end)pcall(function()U.input:CaptureFocus()end)end end)end)U.jump=tbtn(U.main,"v",{size=uo(60,26),key="accent",ts=11})U.jump.Visible=false;U.jump.ZIndex=10
U.resize=mk("TextButton",{Size=uo(18,18),Position=u2(1,-18,1,-18),BackgroundTransparency=1,Text="//",TextSize=10,Font=fGB,BorderSizePixel=0,ZIndex=25},U.main)th(U.resize,"TextColor3","muted")
U.toasts=mk("Frame",{Size=uo(250,300),BackgroundTransparency=1,ZIndex=200},U.gui)mk("UIListLayout",{Padding=u1(0,4),SortOrder=soLO},U.toasts)
U.layer=mk("Frame",{Size=us(1,1),BackgroundTransparency=1,ZIndex=100,Visible=false},U.gui)U.modal=mk("Frame",{Size=us(1,1),BackgroundTransparency=1,ZIndex=40,Visible=false},U.gui)local function tryMatchChatSize()
pcall(function()local tcs=game:GetService("TextChatService")local win=tcs.ChatWindowConfiguration local sz=win.AbsoluteSize if sz and sz.X>120 and sz.Y>80 then P.W=clamp(sz.X+16,280,480)P.H=clamp(sz.Y+70,220,420)
S.isDirty=true F.layout()end end)end task.delay(3,tryMatchChatSize)function F.layout()local v=viewNow()P.W=clamp(P.W,CFG.MIN_W,max(CFG.MIN_W,v.X-8))P.H=clamp(P.H,CFG.MIN_H,max(CFG.MIN_H,v.Y-8))
if P.W>=240 and P.H>=220 then S.prevW,S.prevH=P.W,P.H end if not S.winX then S.winX=max(4,(v.X-P.W)/2);S.winY=max(4,(v.Y-P.H)/2)end S.winX=clamp(S.winX,0,max(0,v.X-30));S.winY=clamp(S.winY,0,max(0,v.Y-30))
U.main.Size=uo(P.W,P.H)U.main.Position=uo(S.winX,S.winY)local W,Hh=P.W,P.H local isNano=(W<115 or Hh<95)local isMicro=not isNano and(W<190 or Hh<165)local isCompact=not isNano and not isMicro and(W<285 or Hh<235)
local hidden=uo(6,Hh+80)if isNano then U.titleBar.Size=u2(1,0,0,22)U.dot.Position=uo(6,7)U.titleLbl.Visible=W>=85 U.titleLbl.Position=uo(18,0)U.titleLbl.Size=u2(1,-44,1,0)U.titleLbl.Text="CB"U.titleLbl.TextSize=10
U.bLang.Visible=false;U.bFind.Visible=false;U.bUsers.Visible=false;U.bMe.Visible=false;U.bSet.Visible=false U.bMin.Visible=true U.bMin.Size=uo(20,18)U.tbtns.Size=uo(22,22)U.tbtns.Position=u2(1,-24,0,0)
U.divider.Position=uo(0,22)U.nanoBox.Visible=true U.nanoBox.Position=uo(0,23)U.nanoBox.Size=u2(1,0,1,-23)local chIcon=S.chan=="announce"and"📢"or(S.chan=="game"and"🎮"or(S.chan=="scripts"and"📜"or(tostring(S.chan):sub(1,3)=="dm:"and"💭"or"💬")))
U.nanoBtn.Text=chIcon U.nanoBtn.TextSize=clamp(min(W,Hh)-42,13,20)U.tabsBar.Visible=false U.infoBar.Visible=false U.searchBox.Visible=false U.scroll.Visible=false U.typing.Visible=false
U.tokenBar.Visible=false U.replyBar.Visible=false U.suggest.Visible=false U.chatBar.Visible=false U.jump.Visible=false U.resize.Size=uo(14,14)U.resize.Position=u2(1,-14,1,-14)U.resize.Text="//"
if F.paintTabs then pcall(F.paintTabs)end return end U.nanoBox.Visible=false U.chatBar.Visible=true U.input.Visible=true U.scroll.Visible=true U.resize.Text="//"U.resize.Size=uo(18,18)U.resize.Position=u2(1,-18,1,-18)
U.titleLbl.Text=T("title")U.titleLbl.TextSize=isMicro and 11 or 13 local tbH=isMicro and 26 or(isCompact and 30 or 34)U.titleBar.Size=u2(1,0,0,tbH)U.dot.Position=uo(9,floor((tbH-8)/2))U.divider.Position=uo(0,tbH)
local showLang=W>=290 local showFind=W>=210 local showUsers=W>=250 local showMe=W>=175 U.bLang.Visible=showLang U.bFind.Visible=showFind U.bUsers.Visible=showUsers U.bMe.Visible=showMe U.bSet.Visible=true
U.bMin.Visible=true local btnH=max(20,tbH-8)for _,b in ipairs({U.bLang,U.bFind,U.bUsers,U.bMe,U.bSet,U.bMin})do b.Size=uo(b==U.bLang and 28 or(isMicro and 22 or 26),btnH)end
local visBtns=2+(showLang and 1 or 0)+(showFind and 1 or 0)+(showUsers and 1 or 0)+(showMe and 1 or 0)local tbtnsW=visBtns*(isMicro and 25 or 29)+4 U.tbtns.Size=uo(tbtnsW,tbH)U.tbtns.Position=u2(1,-(tbtnsW+4),0,0)
U.titleLbl.Visible=W>=145 U.titleLbl.Position=uo(22,0)U.titleLbl.Size=u2(1,-(tbtnsW+28),1,0)local top=tbH+4 local showTabs=Hh>=130 U.tabsBar.Visible=showTabs if showTabs then
local tabH=(isMicro or P.compact)and 22 or 26 U.tabsBar.Position=uo(6,top)U.tabsBar.Size=u2(1,-12,0,tabH)top=top+tabH+4 end local showInfo=Hh>=210 and W>=220 and not P.compact U.infoBar.Visible=showInfo
if showInfo then U.infoBar.Position=uo(6,top)U.infoBar.Size=u2(1,-12,0,18)top=top+21 end if U.searchBox.Visible then U.searchBox.Position=uo(6,top)U.searchBox.Size=u2(1,-12,0,24)top=top+27 end
local barH=isMicro and 32 or(isCompact and 36 or 40)local innerH=barH-8 local barY=Hh-(barH+6)local barW=W-12 U.chatBar.Position=uo(6,barY)U.chatBar.Size=uo(barW,barH)local showCmdBtn=W>=210 local showAtBtn=W>=275
local showEmoji=W>=150 local showPoll=W>=245 local leftX=4 local quickW=isMicro and 22 or 26 U.cmdBtn.Visible=showCmdBtn if showCmdBtn then U.cmdBtn.Position=uo(leftX,4)U.cmdBtn.Size=uo(quickW,innerH)
leftX=leftX+quickW+4 end U.atBtn.Visible=showAtBtn if showAtBtn then U.atBtn.Position=uo(leftX,4)U.atBtn.Size=uo(quickW,innerH)leftX=leftX+quickW+4 end local sendW=(W<220)and 30 or(isCompact and 44 or 54)
U.sendBtn.Text=(W<220)and">"or T("send")U.sendBtn.TextSize=(W<220)and 12 or 11 local emojiW=isMicro and 26 or 30 local pollW=isMicro and 26 or 30 local rightX=barW-4-sendW U.sendBtn.Position=uo(rightX,4)
U.sendBtn.Size=uo(sendW,innerH)U.pollBtn.Visible=showPoll if showPoll then rightX=rightX-4-pollW U.pollBtn.Position=uo(rightX,4)U.pollBtn.Size=uo(pollW,innerH)end U.emojiBtn.Visible=showEmoji if showEmoji then
rightX=rightX-4-emojiW U.emojiBtn.Position=uo(rightX,4)U.emojiBtn.Size=uo(emojiW,innerH)end local wrapW=max(36,rightX-leftX-4)U.inputWrap.Position=uo(leftX,4)U.inputWrap.Size=uo(wrapW,innerH)
U.tokenDot.Position=uo(7,floor((innerH-7)/2))U.input.Position=uo(18,0)U.input.Size=u2(1,-22,1,0)U.inputRich.Position=uo(18,0)U.inputRich.Size=u2(1,-22,1,0)local y=barY-3 local rbOn=U.replyBar.Visible and Hh>=120
U.replyBar.Position=rbOn and uo(6,y-20)or hidden U.replyBar.Size=u2(1,-12,0,20)if rbOn then y=y-22 end local tkOn=U.tokenBar.Visible and Hh>=105 U.tokenBar.Position=tkOn and uo(6,y-22)or hidden
U.tokenBar.Size=u2(1,-12,0,22)if tkOn then y=y-24 end local sgOn=U.suggest.Visible and Hh>=105 U.suggest.Position=sgOn and uo(6,y-26)or hidden U.suggest.Size=u2(1,-12,0,26)if sgOn then y=y-28 end
local showTyping=Hh>=180 and U.typing.Text~=""U.typing.Visible=Hh>=180 U.typing.Position=uo(8,y-14)U.typing.Size=u2(1,-16,0,14)local bottomEdge=showTyping and(y-15)or(y-2)U.scroll.Position=uo(6,top)
U.scroll.Size=u2(1,-12,0,max(0,bottomEdge-top))U.jump.Position=uo(max(6,W-68),max(top,bottomEdge-30))local tw=min(250,v.X-16)U.toasts.Size=uo(tw,300)local pos=P.toastPos
local tx=(pos=="tl"or pos=="bl")and 8 or(v.X-tw-8)local ty=(pos=="tl"or pos=="tr")and 8 or(v.Y-308)U.toasts.Position=uo(tx,ty)
U.toasts:FindFirstChildOfClass("UIListLayout").VerticalAlignment=(pos=="bl"or pos=="br")and Enum.VerticalAlignment.Bottom or Enum.VerticalAlignment.Top if F.paintTabs then pcall(F.paintTabs)end end
function F.toast(text,force,fn)if not force and not P.notify then return end
local b=mk("TextButton",{Size=u2(1,0,0,0),AutomaticSize=asY,Text="",BorderSizePixel=0,AutoButtonColor=false,LayoutOrder=floor(os.clock()*100)%100000},U.toasts)
th(b,"BackgroundColor3","title");corner(b,8);stroke(b,"accent",1,0.5);pad(b,10,6,10,6)lab(b,tostring(text),{wrap=true,auto=true,ts=12})
if fn then hook(b.MouseButton1Click,function()b:Destroy();fn()end)else hook(b.MouseButton1Click,function()b:Destroy()end)end Debris:AddItem(b,4)return b end function F.closeModal()
for _,c in ipairs(U.modal:GetChildren())do c:Destroy()end U.modal.Visible=false S.popN=0 end local function buildBox(parentFrame,title,w,h,z,onClose)local v=viewNow()w=min(w or 340,v.X-16)h=min(h or 420,v.Y-16)
local box=mk("Frame",{Size=uo(w,h),AnchorPoint=v2(0.5,0.5),Position=us(0.5,0.5),BorderSizePixel=0,ZIndex=z+1,Active=true},parentFrame)th(box,"BackgroundColor3","bg2");corner(box,12);stroke(box,"accent",1.2,0.45)
local head=mk("Frame",{Size=u2(1,0,0,34),BackgroundTransparency=1},box)lab(head,title,{size=u2(1,-44,1,0),pos=uo(14,0),bold=true,ts=14,trunc=true})
local hdiv=mk("Frame",{Size=u2(1,-16,0,1),Position=uo(8,34),BorderSizePixel=0},box)th(hdiv,"BackgroundColor3","bg3")
local x=mk("TextButton",{Size=uo(32,28),Position=u2(1,-36,0,3),BackgroundTransparency=1,Text="X",TextSize=13,Font=fGB,BorderSizePixel=0},head)th(x,"TextColor3","muted")hook(x.MouseButton1Click,onClose)
local scr=mk("ScrollingFrame",{Size=u2(1,-16,1,-42),Position=uo(8,36),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=3,CanvasSize=u2(),AutomaticCanvasSize=asY},box)list(scr,5);pad(scr,2,0,4,8)
return scr,box end function F.modalBox(title,w,h)F.closeModal()U.modal.Visible=true
local back=mk("TextButton",{Size=us(1,1),BackgroundColor3=c3(0,0,0),BackgroundTransparency=0.45,Text="",AutoButtonColor=false,ZIndex=40},U.modal)hook(back.MouseButton1Click,F.closeModal)
local scr,box=buildBox(U.modal,title,w,h,40,F.closeModal)return scr,F.closeModal,box end function F.popup(title,w,h)if not U.modal.Visible then local scr,closeFn,box=F.modalBox(title,w,h)return scr,closeFn,box end
S.popN=S.popN+1 local z=50+S.popN*4 local layer=mk("TextButton",{Size=us(1,1),BackgroundColor3=c3(0,0,0),BackgroundTransparency=0.5,Text="",AutoButtonColor=false,ZIndex=z},U.modal)local box
local function close()pcall(function()layer:Destroy()end);pcall(function()box:Destroy()end)end hook(layer.MouseButton1Click,close)local scr scr,box=buildBox(U.modal,title,w,h,z,close)return scr,close,box end
F.DEVROLE={id="_dev",name="DEV",color="#FAA81A",icon="",position=9999,isAdmin=true,mentionAll=true}function F.assignKeyFor(u)if not u or type(S.assign)~="table"then return nil end if S.assign[u]~=nil then return u end
local ln=tostring(u):lower()for k in pairs(S.assign)do if type(k)=="string"and k:lower()==ln then return k end end return nil end function F.isDev(u)if not u then return false end
return CFG.DEVELOPERS[u]==true or S.devs[tostring(u):lower()]==true end function F.invalidateRoleCache()S.roleMapCache=nil S.userRolesCache={}end
function F.roleById(id)if not id then return nil end if not S.roleMapCache then S.roleMapCache={}for _,r in ipairs(S.roles)do if r.id then S.roleMapCache[r.id]=r end end end return S.roleMapCache[id]end
function F.userRoles(u)if not u then return{}end S.userRolesCache=S.userRolesCache or{}local ln=tostring(u):lower()local cached=S.userRolesCache[ln]if cached then return cached end
local out,seen={},{}for key,set in pairs(S.assign)do if type(key)=="string"and key:lower()==ln and type(set)=="table"then for rid in pairs(set)do
if not seen[rid]then seen[rid]=true local r=F.roleById(rid)if r then out[#out+1]=r end end end end end tsort(out,function(x,y)if x.position~=y.position then return x.position>y.position end
return tostring(x.id)<tostring(y.id)end)S.userRolesCache[ln]=out return out end
function F.hasRole(u,rid)if not u or not rid then return false end for _,r in ipairs(F.userRoles(u))do if r.id==rid then return true end end return false end
function F.setRole(u,rid,on)if not u or not rid then return end F.invalidateRoleCache()local ln=tostring(u):lower()local canon for k,set in pairs(S.assign)do if type(k)=="string"and k:lower()==ln and type(set)=="table"then canon=canon or k
set[rid]=nil if not next(set)then S.assign[k]=nil end end end if on then canon=canon or u S.assign[canon]=S.assign[canon]or{}S.assign[canon][rid]=true end end function F.topRole(u)local l=F.userRoles(u);return l[1]end
function F.rank(u)if F.isDev(u)then return 10000 end local r=F.topRole(u)return r and r.position or 0 end function F.isAdmin(u)if F.isDev(u)then return true end
for _,r in ipairs(F.userRoles(u))do if r.isAdmin then return true end end return false end F.isStaff=F.isAdmin function F.canMentionAll(u)if F.isDev(u)then return true end
for _,r in ipairs(F.userRoles(u))do if r.mentionAll or r.isAdmin then return true end end return false end function F.canAnnounce(u)if F.isStaff(u)then return true end for _,r in ipairs(F.userRoles(u))do
if r.canAnnounce==true then return true end local rn=tostring(r.name or""):lower()
if rn:find("tester",1,true)or rn:find("test",1,true)or rn:find("dev",1,true)or rn:find("admin",1,true)or rn:find("mod",1,true)or rn:find("owner",1,true)or rn:find("staff",1,true)then return true end end return false end
function F.canAct(actor,target)if not actor or not target or actor==target then return false end if F.isDev(target)then return F.isDev(actor)end if not F.isAdmin(actor)then return false end
return F.rank(actor)>F.rank(target)end function F.applyRoles(obj,seq,trusted)if type(obj)~="table"then return end if not trusted and not F.isDev(obj.by)then return end seq=tonumber(seq)or tonumber(obj.seq)or 0
if seq<S.rolesSeq then return end local roles,assign={},{}for _,r in ipairs(type(obj.roles)=="table"and obj.roles or{})do if type(r)=="table"and r.id and r.name then roles[#roles+1]={
id=tostring(r.id),name=tostring(r.name),color=H.safeHex(r.color),icon=tostring(r.icon or""),position=tonumber(r.position)or 0,isAdmin=r.isAdmin==true,mentionAll=r.mentionAll==true,canAnnounce=r.canAnnounce==true,}
end end local userCase={}for u in pairs(S.users)do userCase[u:lower()]=u end userCase[P.username:lower()]=P.username for u,v in pairs(type(obj.assign)=="table"and obj.assign or{})do local set={}
if type(v)=="string"then set[v]=true elseif type(v)=="table"then for k,x in pairs(v)do if x==true then set[k]=true elseif type(x)=="string"then set[x]=true end end end if next(set)then local lk=tostring(u):lower()
local canon=userCase[lk]or tostring(u)if assign[canon]then for rid in pairs(set)do assign[canon][rid]=true end else assign[canon]=set end end end S.roles,S.assign,S.rolesSeq=roles,assign,seq F.invalidateRoleCache()S.isDirty=true
if F.layoutTabs then F.layoutTabs()end if S.booted and F.rebuildFeed then pcall(F.rebuildFeed)end F.emit("roles",roles)end function F.nextPosition()local m=0 for _,r in ipairs(S.roles)do m=max(m,r.position)end
return m+10 end function F.publishRoles(silent)if not F.isDev(P.username)then return end enqueue("send","POST","/api/roles",{by=P.username,base=S.rolesSeq,roles=S.roles,assign=S.assign},function(data,err)
if data and data.ok then S.rolesSeq=tonumber(data.seq)or S.rolesSeq if type(data.emojis)=="table"then local oldEs=S.emojiSeq S.sharedEmojis=data.emojis S.emojiSeq=tonumber(data.emojiSeq)or 0
if S.emojiSeq~=oldEs then S.isDirty=true end end if type(data.scripts)=="table"then local oldSs=S.scriptSeq S.scripts=data.scripts S.scriptSeq=tonumber(data.scriptSeq)or 0 if S.scriptSeq~=oldSs then S.isDirty=true
if S.chan=="scripts"and S.booted then pcall(F.rebuildFeed,true)end end end if type(data.roles)=="table"then F.applyRoles(data.roles,data.seq,true)end S.isDirty=true if not silent then F.toast(T("role_saved"),true)end
elseif data and data.error=="stale"and type(data.roles)=="table"then F.applyRoles(data.roles,data.seq,true)F.toast(T("roles_stale"),true)else F.toast(T("roles_fail")..tostring((data and data.error)or err),true)end
end)end function F.queueRoles()S.rolesToken=(S.rolesToken or 0)+1 local my=S.rolesToken task.delay(1.2,function()if S.rolesToken==my and NET.alive then F.publishRoles()end end)end function F.muted(u)
local m=S.mutes[u]if not m or not m.on then return false end if tonumber(m.exp)and m.exp>0 and m.exp<=H.now()then m.on=false;return false end return true end function F.applyMute(u,m)S.mutes[u]=m if u==P.username then
P.mute=m;S.isDirty=true if m.on then F.toast(T("you_muted")..(m.reason~=""and(": "..m.reason)or""),true)end end end function F.disp(t)t=tostring(t or"");return P.safeEmoji and H.safeText(t)or t end
function F.avatarUrl(uid)return"rbxthumb://type=AvatarHeadShot&id="..tostring(uid or 1).."&w=60&h=60"end function F.uidOf(name,hint)if name==P.username then return P.userId end local r=S.users[name]
return(r and r.userId)or hint or S.uidCache and S.uidCache[name]or 1 end function F.isLive(rec)if not rec or not rec.recvAt then return false end return(rec.age or 0)+(os.clock()-rec.recvAt)<=CFG.PRESENCE_TIMEOUT end
function F.userRec(name)if not name then return nil end if S.users[name]then return S.users[name]end local ln=tostring(name):lower()for u,r in pairs(S.users)do if tostring(u):lower()==ln then return r end end
return nil end function F.isScriptUser(name)if not name or name==""then return false end if tostring(name):lower()==P.username:lower()then return true end local rec=F.userRec(name)
if not rec or not rec.isScript then return false end return F.isLive(rec)end function F.touchUser(name,uid,display)if not name or name==""or name==P.username then return end local rec=S.users[name]if not rec then
rec={display=display or name,userId=tonumber(uid)or 1,status="",bio="",country="??",inGame=false,placeId=0,gameName="",jobId=""}S.users[name]=rec end rec.isScript=true rec.age,rec.recvAt=0,os.clock()end
function F.dmChan(a,b)if a:lower()>b:lower()then a,b=b,a end return"dm:"..a.."|"..b end function F.dmOther(chan)local a,b=tostring(chan):match("^dm:(.-)|(.+)$")if not a then return nil end
if a==P.username then return b end if b==P.username then return a end return nil end function F.dmUnreadTotal()local n=0;for _,v in pairs(S.dmUnread)do n=n+v end return n end function F.visibleIn(m,chan)
if m.chan~=chan then return false end if chan=="game"and m.place and m.place~=game.PlaceId then return false end return true end function F.mentions(content)local c=tostring(content or""):lower()
if c:find("@everyone",1,true)or c:find("@here",1,true)then return true end local me=P.username:lower()local i=c:find("@"..me,1,true)while i do local nxt=c:sub(i+#me+1,i+#me+1)
if not nxt:match("[%w_]")then return true end i=c:find("@"..me,i+1,true)end return false end function F.cleanEmojiName(s)s=H.trim(tostring(s or"")):gsub("^:+",""):gsub(":+$",""):gsub("[^%w_%-]","_"):sub(1,22)
return s~=""and s or"emoji"end function F.rebuildEmojiCache()
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
function F.ensureEmojiCache()
if not S._emoById or S._emoCacheSeq~=S.emojiSeq or S._emoCacheN~=#(P.customEmojis or{})then F.rebuildEmojiCache()end
end
function F.emojiInfoById(id)id=tostring(id or"")F.ensureEmojiCache()return S._emoById[id]end
function F.emojiIdByName(name)local ln=F.cleanEmojiName(name):lower()if ln==""then return nil end F.ensureEmojiCache()local hit=S._emoByName[ln]if hit then return hit.id,hit.name end return nil end function F.expandShortcodes(text)text=tostring(text or"")
text=text:gsub("<:([%w_%-]+):(%d+)>",function(_,id)if#id>=5 and#id<=15 then return"[img:"..id.."]"end return _ end)text=text:gsub(":([%w_%-]+):",function(nm)local id=F.emojiIdByName(nm)
if id then return"[img:"..id.."]"end local uni=CFG.SHORTCODES and CFG.SHORTCODES[nm:lower()]if uni then return uni end return":"..nm..":"end)return text end function F.parseImgs(content)local ids={}
local expanded=F.expandShortcodes(content)local text=tostring(expanded or""):gsub("%[img:(%d+)%]",function(id)if#ids<8 and#id>=5 and#id<=15 then ids[#ids+1]=id end return""end)text=H.trim(text:gsub("%s%s+"," "))
return text,ids end function F.parseInlineSegments(content)local expanded=F.expandShortcodes(content)local segs,imgCount,hasText={},0,false local pos=1 while pos<=#expanded do
local s,e,id=expanded:find("%[img:(%d+)%]",pos)if s then if s>pos then local txt=expanded:sub(pos,s-1)if H.trim(txt)~=""then hasText=true end segs[#segs+1]={kind="text",text=txt}end
if#id>=5 and#id<=15 and imgCount<10 then imgCount=imgCount+1 segs[#segs+1]={kind="img",id=id}end pos=e+1 else local txt=expanded:sub(pos)if H.trim(txt)~=""then hasText=true end
if txt~=""then segs[#segs+1]={kind="text",text=txt}end break end end return segs,imgCount,hasText end function F.plain(content)local expanded=F.expandShortcodes(content)
return(tostring(expanded or""):gsub("%[img:(%d+)%]",function(id)local info=F.emojiInfoById(id)return info and(":"..info.name..":")or T("img_tag")end))end function F.link(m)local prev=S.lastByChan[m.chan]
m.grp=prev~=nil and prev.author==m.author and not prev.deleted and not m.replyTo and math.abs((tonumber(m.ts)or 0)-(tonumber(prev.ts)or 0))<=CFG.GROUP_SECS m.prevId=prev and prev.packetId or nil
if prev then prev.nextG=m end S.lastByChan[m.chan]=m end function F.onDeleted(m)local n=m.nextG if n and n.grp and not m.grp then n.grp=false if S.frames[n.packetId]then F.dropFrame(n.packetId);F.renderMessage(n)end end
end function F.roleChip(parent,r,order,big)if not r then return nil end local col=H.hex(r.color)local h=big and 22 or 18 local ts=big and 12 or 10 local nameStr=F.disp(r.name or"Role")
local hasIcon=r.icon~=nil and tostring(r.icon)~=""local icSz=hasIcon and(h-4)or 0 local txtW=clamp(H.textW(nameStr,ts,fGB),12,big and 140 or 100)local padL=hasIcon and 5 or 7 local gap=hasIcon and 4 or 0 local padR=7
local chipW=padL+icSz+gap+txtW+padR local f=mk("Frame",{Size=uo(chipW,h),BackgroundColor3=col,BackgroundTransparency=0.82,BorderSizePixel=0,LayoutOrder=order or 0,ZIndex=5,ClipsDescendants=true,},parent)
corner(f,floor(h/2))local st=mk("UIStroke",{Color=col,Thickness=1,Transparency=0.32,ApplyStrokeMode=smBorder},f)st.ZIndex=5 if hasIcon then local ic=F.iconBox(f,r.icon,icSz)ic.Position=uo(padL,floor((h-icSz)/2))
ic.ZIndex=6 end mk("TextLabel",{Size=uo(txtW+2,h),Position=uo(padL+icSz+gap,0),BackgroundTransparency=1,Text=nameStr,TextColor3=col,Font=fGB,TextSize=ts,TextXAlignment=txL,
TextYAlignment=Enum.TextYAlignment.Center,TextTruncate=trEnd,BorderSizePixel=0,ZIndex=6,},f)return f end function F.pushRecentEmoji(e)
for i=#P.recentEmoji,1,-1 do if P.recentEmoji[i]==e then tremove(P.recentEmoji,i)end end tinsert(P.recentEmoji,1,e)while#P.recentEmoji>18 do tremove(P.recentEmoji)end S.isDirty=true end function F.quickEmoji()
local out,seen={},{}local function add(e)if e and not seen[e]and#out<4 then seen[e]=true;out[#out+1]=e end end for _,e in ipairs(P.recentEmoji)do add(e)end for _,e in ipairs(S.sharedEmojis or{})do
if e.id then add("img:"..tostring(e.id))end end for _,e in ipairs({"👍","😂","🔥","💀"})do add(e)end return out end function F.deleteSharedEmojis(ids,onDone)if type(ids)~="table"or#ids==0 then return end
enqueue("other","POST","/api/emoji",{by=P.username,ids=ids,id=ids[1],action=#ids>1 and"remove_multi"or"remove",},function(d,err)if d and d.ok then S.sharedEmojis=d.emojis or S.sharedEmojis
S.emojiSeq=tonumber(d.emojiSeq)or S.emojiSeq S.isDirty=true F.toast(T("emoji_removed").." ("..tostring(d.removed or#ids)..")",true)if onDone then onDone(true)end else F.netError((d and d.error)or err)
if onDone then onDone(false)end end end)end function F.openEmojiPreview(id,msgOrTopic,isScript)local info=F.emojiInfoById(id)or{id=id,name="emoji_"..tostring(id):sub(-4),by="?"}
local scr,close=F.popup(":"..info.name..":",280,250)local topRow=mk("Frame",{Size=u2(1,0,0,76),BackgroundTransparency=1},scr)local ic=F.iconBox(topRow,"img:"..id,64)ic.Position=uo(8,6)
lab(topRow,":"..F.disp(info.name)..":",{size=u2(1,-84,0,22),pos=uo(80,10),bold=true,ts=15,key="emojiText",trunc=true})lab(topRow,"ID: "..tostring(id),{size=u2(1,-84,0,16),pos=uo(80,32),ts=11,key="muted",trunc=true})
lab(topRow,"By: @"..F.disp(info.by or"?"),{size=u2(1,-84,0,16),pos=uo(80,48),ts=11,key="muted",trunc=true})local r1=row(scr,30)local bChat=rbtn(r1,T("emoji_insert_chat"),{key="accent",ts=11})
hook(bChat.MouseButton1Click,function()if type(close)=="function"then close()else F.closeModal()end U.input.Text=U.input.Text..(U.input.Text~=""and not U.input.Text:match("%s$")and" "or"")..":"..info.name..": "
F.updateSuggest()U.input:CaptureFocus()end)local bReact=rbtn(r1,T("emoji_react_btn"),{ts=11})hook(bReact.MouseButton1Click,function()if type(close)=="function"then close()else F.closeModal()end
if isScript and msgOrTopic then F.doScriptReact(msgOrTopic,"img:"..id)elseif msgOrTopic then F.doReact(msgOrTopic,"img:"..id)else local lastId=S.order[#S.order]
if lastId and S.msgs[lastId]then F.doReact(S.msgs[lastId],"img:"..id)end end end)local r2=row(scr,28)local bCopy=rbtn(r2,T("emoji_copy_name"),{ts=11})hook(bCopy.MouseButton1Click,function()
F.copyText(":"..info.name..":")if type(close)=="function"then close()else F.closeModal()end end)local bSave=rbtn(r2,T("emoji_save_loc"),{ts=11})hook(bSave.MouseButton1Click,function()P.customEmojiNames[id]=info.name;S._emoById=nil
local exists=false for _,x in ipairs(P.customEmojis)do if x==id then exists=true;break end end if not exists and#P.customEmojis<48 then tinsert(P.customEmojis,id)end S.isDirty=true F.toast(T("saved_ok"),true)
if type(close)=="function"then close()else F.closeModal()end end)if F.isStaff(P.username)or tostring(info.by or""):lower()==P.username:lower()then local bDel=tbtn(scr,T("emoji_del_srv"),{key="danger",h=28,ts=11})
hook(bDel.MouseButton1Click,function()F.deleteSharedEmojis({tostring(id)},function(ok)if ok then if type(close)=="function"then close()else F.closeModal()end end end)end)end end function F.openEmoji(opt)opt=opt or{}
local scr,close=F.popup(opt.title or T("emoji_pick"),390,520)local searchBar=mk("TextBox",{Size=u2(1,0,0,30),Text="",PlaceholderText=T("emoji_search_ph"),ClearTextOnFocus=false,Font=fG,TextSize=12,
BorderSizePixel=0,TextXAlignment=txL,LayoutOrder=1,},scr)th(searchBar,"BackgroundColor3","bg3");th(searchBar,"TextColor3","text");th(searchBar,"PlaceholderColor3","muted")corner(searchBar,8);pad(searchBar,10,0,10,0)
local tabsRow=row(scr,28);tabsRow.LayoutOrder=2 local body=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BackgroundTransparency=1,LayoutOrder=5},scr)list(body,6)local cur,delMode=opt.tab or P.emojiTab or"recent",false
local multiMode=false local selectedIds={}local function pick(e)F.pushRecentEmoji(e)if not opt.keepOpen then if type(close)=="function"then pcall(close)else F.closeModal()end end
if opt.onPick then pcall(opt.onPick,e)end end local show local function gridUnicode(parent,items)local g=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BackgroundTransparency=1},parent)
mk("UIGridLayout",{CellSize=uo(42,38),CellPadding=uo(4,4),SortOrder=soLO},g)for i,e in ipairs(items)do local b=mk("TextButton",{Text="",BorderSizePixel=0,LayoutOrder=i,AutoButtonColor=true,Active=true},g)
th(b,"BackgroundColor3","bg3");corner(b,8)local ic=F.iconBox(b,e,28)ic.Position=u2(0.5,-14,0.5,-14)hook(b.MouseButton1Click,function()pick(e)end)end end local function gridNamedImages(parent,entries,isServerShared)
local g=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BackgroundTransparency=1,LayoutOrder=10},parent)mk("UIGridLayout",{CellSize=uo(68,64),CellPadding=uo(5,5),SortOrder=soLO},g)local staff=F.isStaff(P.username)
for i,entry in ipairs(entries)do local id=tostring(entry.id)local nm=F.cleanEmojiName(entry.name or P.customEmojiNames[id]or("id_"..id:sub(-4)))local by=tostring(entry.by or P.username)
local canDel=(not isServerShared)or staff or(by:lower()==P.username:lower())local isSel=selectedIds[id]==true
local b=mk("TextButton",{Text="",BorderSizePixel=0,LayoutOrder=i,ClipsDescendants=true,AutoButtonColor=true,Active=true},g)th(b,"BackgroundColor3",isSel and"danger"or"bg3")corner(b,8)
mk("UIStroke",{Color=isSel and TH.danger or TH.accent,Thickness=isSel and 2 or 1,Transparency=isSel and 0.1 or 0.75,ApplyStrokeMode=smBorder},b)local ic=F.iconBox(b,"img:"..id,34)ic.Position=u2(0.5,-17,0,5)
lab(b,":"..nm..":",{size=u2(1,-6,0,16),pos=uo(3,42),ts=10,bold=true,align=txC,trunc=true,key=isSel and"text"or"emojiText",})if canDel and not multiMode then local xBtn=mk("TextButton",{Size=uo(18,18),
Position=u2(1,-20,0,2),BackgroundColor3=TH.danger,BackgroundTransparency=0.15,Text="X",TextColor3=c3(1,1,1),Font=fGB,TextSize=10,BorderSizePixel=0,ZIndex=6,},b)corner(xBtn,9)
hook(xBtn.MouseButton1Click,function()if isServerShared then F.deleteSharedEmojis({id},function(ok)if ok and body.Parent then show(cur)end end)else
for k=#P.customEmojis,1,-1 do if P.customEmojis[k]==id then tremove(P.customEmojis,k)end end P.customEmojiNames[id]=nil;S._emoById=nil S.isDirty=true show(cur)end end)end if multiMode and isServerShared and staff then
local chk=lab(b,isSel and"[x]"or"[ ]",{size=uo(20,20),pos=uo(3,2),ts=12,bold=true,key=isSel and"text"or"accent",})chk.ZIndex=6 end hook(b.MouseButton1Click,function()if isServerShared and multiMode and staff then
selectedIds[id]=not selectedIds[id]or nil show(cur)return end if delMode and canDel then if isServerShared then F.deleteSharedEmojis({id},function(ok)if ok and body.Parent then show(cur)end end)else
for k=#P.customEmojis,1,-1 do if P.customEmojis[k]==id then tremove(P.customEmojis,k)end end P.customEmojiNames[id]=nil;S._emoById=nil S.isDirty=true show(cur)end return end pick("img:"..id)end)end end
local function buildShareAndLocal(isSharedTab)local q=H.trim(searchBar.Text):lower():gsub("^:+",""):gsub(":+$","")local formCard=F.card(body,0)formCard.AutomaticSize=asY formCard.Size=u2(1,0,0,0)
formCard.LayoutOrder=1 pad(formCard,8,8,8,8);list(formCard,5)lab(formCard,T("img_hint"),{wrap=true,auto=true,ts=10,key="muted",layout=1})
local topInputRow=mk("Frame",{Size=u2(1,0,0,36),BackgroundTransparency=1,LayoutOrder=2},formCard)local idBox=mk("TextBox",{Size=u2(1,-44,0,32),Position=uo(0,2),
Text="",PlaceholderText=T("custom"),ClearTextOnFocus=false,Font=fG,TextSize=12,BorderSizePixel=0,TextXAlignment=txL,},topInputRow)
th(idBox,"BackgroundColor3","bg2");th(idBox,"TextColor3","text");th(idBox,"PlaceholderColor3","muted")corner(idBox,7);pad(idBox,8,0,8,0)
local pv=mk("Frame",{Size=uo(36,36),Position=u2(1,-36,0,0),BackgroundTransparency=1},topInputRow)th(pv,"BackgroundColor3","bg2");corner(pv,7)local nameBox=mk("TextBox",{Size=u2(1,0,0,30),
Text="",PlaceholderText=T("emoji_name_ph"),ClearTextOnFocus=false,Font=fG,TextSize=12,BorderSizePixel=0,TextXAlignment=txL,LayoutOrder=3,},formCard)
th(nameBox,"BackgroundColor3","bg2");th(nameBox,"TextColor3","text");th(nameBox,"PlaceholderColor3","muted")corner(nameBox,7);pad(nameBox,8,0,8,0)local shown=nil local function preview()local raw=H.trim(idBox.Text)
for _,c in ipairs(pv:GetChildren())do if not c:IsA("UICorner")then c:Destroy()end end local id=H.assetId(raw)if id then shown="img:"..id local ic=F.iconBox(pv,shown,32)ic.Position=uo(2,2)
if H.trim(nameBox.Text)==""then local known=F.emojiInfoById(id)if known and known.name then nameBox.Text=known.name end end elseif raw~=""and#raw<=16 then shown=raw local ic=F.iconBox(pv,raw,32)ic.Position=uo(2,2)else
shown=nil end end hook(idBox:GetPropertyChangedSignal("Text"),function()S.pvTok=(S.pvTok or 0)+1 local my=S.pvTok task.delay(0.35,function()if S.pvTok==my and pv.Parent then preview()end end)end)
local actRow=row(formCard,30);actRow.LayoutOrder=4 local saveLocB=rbtn(actRow,T("emoji_save_loc"),{size=u2(0.45,-3,1,0),ts=11})local shareSrvB=rbtn(actRow,T("emoji_share_srv"),{size=u2(0.55,-3,1,0),ts=11,key="accent"})
hook(saveLocB.MouseButton1Click,function()preview()if not shown then F.toast(T("img_bad"),true);return end if shown:sub(1,4)=="img:"then local id=shown:sub(5)
local nm=F.cleanEmojiName(nameBox.Text~=""and nameBox.Text or("emo_"..id:sub(-4)))P.customEmojiNames[id]=nm;S._emoById=nil local exists=false for _,x in ipairs(P.customEmojis)do if x==id then exists=true;break end end
if not exists then if#P.customEmojis>=48 then F.toast(T("img_full"),true);return end tinsert(P.customEmojis,id)end S.isDirty=true pick(shown)else pick(shown)end end)hook(shareSrvB.MouseButton1Click,function()
preview()if not shown or shown:sub(1,4)~="img:"then F.toast(T("img_bad"),true);return end local id=shown:sub(5)local nm=F.cleanEmojiName(nameBox.Text~=""and nameBox.Text or("emo_"..id:sub(-4)))
P.customEmojiNames[id]=nm;S._emoById=nil enqueue("other","POST","/api/emoji",{by=P.username,id=id,name=nm,action="add"},function(d,e)if d and d.ok then S.sharedEmojis=d.emojis or S.sharedEmojis
S.emojiSeq=tonumber(d.emojiSeq)or S.emojiSeq S.isDirty=true F.toast(T("emoji_shared_ok").." (:"..nm..":)",true)if body.Parent then show("shared")end else F.toast("! "..tostring((d and d.error)or e or"fail"),true)end
end)end)if isSharedTab then local staff=F.isStaff(P.username)if staff then local modBar=row(body,28);modBar.LayoutOrder=2 local mBtn=rbtn(modBar,(multiMode and"[x] "or"[ ] ")..T("emoji_del_multi"),{
size=u2(multiMode and 0.36 or 0.5,-3,1,0),ts=11,key=multiMode and"warn"or"bg3",})hook(mBtn.MouseButton1Click,function()multiMode=not multiMode if not multiMode then selectedIds={}end show("shared")end)
if multiMode then local cnt=0 for _ in pairs(selectedIds)do cnt=cnt+1 end local selAllB=rbtn(modBar,T("script_sel_all"),{size=u2(0.28,-3,1,0),ts=10})hook(selAllB.MouseButton1Click,function()
for _,e in ipairs(S.sharedEmojis or{})do local nm=tostring(e.name or""):lower()local id=tostring(e.id or"")if q==""or nm:find(q,1,true)or id:find(q,1,true)then selectedIds[id]=true end end show("shared")end)
local delSelB=rbtn(modBar,T("emoji_del_sel").." ("..cnt..")",{size=u2(0.36,-3,1,0),ts=10,key="danger",})hook(delSelB.MouseButton1Click,function()local ids={}for id in pairs(selectedIds)do ids[#ids+1]=id end
if#ids==0 then return end F.deleteSharedEmojis(ids,function(ok)if ok then selectedIds={}multiMode=false if body.Parent then show("shared")end end end)end)else
local sDelB=rbtn(modBar,(delMode and T("emoji_del_on")or T("img_del_mode")),{size=u2(0.5,-3,1,0),ts=11,key=delMode and"danger"or"bg3",})hook(sDelB.MouseButton1Click,function()delMode=not delMode show("shared")
end)end end local filtered={}for _,e in ipairs(S.sharedEmojis or{})do local nm=tostring(e.name or""):lower()local id=tostring(e.id or"")local by=tostring(e.by or""):lower()
if q==""or nm:find(q,1,true)or id:find(q,1,true)or by:find(q,1,true)then filtered[#filtered+1]=e end end lab(body,"Server Shared Emojis ("..#filtered.."/"..#(S.sharedEmojis or{})..")"..T("emoji_srv_hint"),{
wrap=true,auto=true,ts=10,key="muted",layout=3,})gridNamedImages(body,filtered,true)else local tools=row(body,28);tools.LayoutOrder=2
local del=rbtn(tools,T("img_del_mode"),{size=u2(0.5,-3,1,0),ts=11,key=delMode and"danger"or"bg3"})hook(del.MouseButton1Click,function()delMode=not delMode;show("img")end)
local clr=rbtn(tools,T("clear"),{size=u2(0.5,-3,1,0),key="danger",ts=11})hook(clr.MouseButton1Click,function()P.customEmojis={};S.isDirty=true;show("img")end)local entries={}for _,id in ipairs(P.customEmojis)do
local nm=P.customEmojiNames[id]or("emo_"..tostring(id):sub(-4))if q==""or nm:lower():find(q,1,true)or tostring(id):find(q,1,true)then entries[#entries+1]={id=id,name=nm,by=P.username}end end
gridNamedImages(body,entries,false)end end local tabDefs={{"recent",T("recent")},{"face",T("tab_face")},{"hand",T("tab_hand")},{"sym",T("tab_sym")},{"obj",T("tab_obj")},{"shared","Shared"},{"img",T("tab_img")},
}local tabBtns={}show=function(tab)cur=tab;P.emojiTab=tab for _,c in ipairs(body:GetChildren())do if not c:IsA("UIListLayout")then c:Destroy()end end
for k,b in pairs(tabBtns)do b.BackgroundColor3=(k==tab)and TH.accent or TH.bg3 end local q=H.trim(searchBar.Text):lower():gsub("^:+",""):gsub(":+$","")if tab=="shared"then buildShareAndLocal(true)elseif tab=="img"then
buildShareAndLocal(false)elseif tab=="recent"then local uni,imgs={},{}for _,e in ipairs(P.recentEmoji)do if tostring(e):sub(1,4)=="img:"then local id=tostring(e):sub(5)
local info=F.emojiInfoById(id)or{id=id,name="emo_"..id:sub(-4),by="?"}if q==""or tostring(info.name):lower():find(q,1,true)or id:find(q,1,true)then imgs[#imgs+1]=info end elseif q==""then uni[#uni+1]=e end end
for _,e in ipairs(S.sharedEmojis or{})do if q==""or tostring(e.name or""):lower():find(q,1,true)or tostring(e.id or""):find(q,1,true)then local dup=false
for _,x in ipairs(imgs)do if tostring(x.id)==tostring(e.id)then dup=true;break end end if not dup and#imgs<12 then imgs[#imgs+1]=e end end end if#uni==0 and q==""then for _,e in ipairs(CFG.REACT)do uni[#uni+1]=e end end
if#imgs>0 then lab(body,T("emoji_recent_custom"),{ts=10,key="muted",bold=true})gridNamedImages(body,imgs,false)end if#uni>0 then lab(body,T("emoji_standard"),{ts=10,key="muted",bold=true})gridUnicode(body,uni)end
else if q~=""then local matches={}for _,e in ipairs(S.sharedEmojis or{})do if tostring(e.name or""):lower():find(q,1,true)or tostring(e.id or""):find(q,1,true)then matches[#matches+1]=e end end if#matches>0 then
lab(body,T("emoji_matched").." ("..#matches..")",{ts=10,key="accent",bold=true})gridNamedImages(body,matches,true)end end gridUnicode(body,CFG.EMOJI[tab]or{})end end for i,d in ipairs(tabDefs)do
local b=tbtn(tabsRow,d[2],{size=u2(1/#tabDefs,-5,1,0),ts=10,layout=i})tabBtns[d[1]]=b hook(b.MouseButton1Click,function()show(d[1])end)end hook(searchBar:GetPropertyChangedSignal("Text"),function()show(cur)end)
show(cur)end function F.reactionMap(id)S.reactions[id]=S.reactions[id]or{};return S.reactions[id]end function F.makeReactionPill(parent,emoji,count,mine,order,onClick)local h=22 local icSz=15
local cStr=tostring(count or 1)local cW=max(8,H.textW(cStr,11,fGB))local pillW=6+icSz+4+cW+7 local b=mk("TextButton",{Text="",Size=uo(pillW,h),BorderSizePixel=0,AutoButtonColor=true,Active=true,ZIndex=20,
LayoutOrder=order or 1,},parent)th(b,"BackgroundColor3",mine and"accent"or"bg3")corner(b,11)local st=mk("UIStroke",{Color=mine and TH.accent or TH.muted,Thickness=1,Transparency=mine and 0.2 or 0.65,
ApplyStrokeMode=smBorder,},b)st.ZIndex=20 local ic=F.iconBox(b,emoji,icSz)ic.Position=uo(6,floor((h-icSz)/2))ic.ZIndex=21 local cl=lab(b,cStr,{size=uo(cW+2,h),pos=uo(6+icSz+4,0),ts=11,bold=true,})cl.ZIndex=21
if mine then themed(cl,function(x)x.TextColor3=H.lum(TH.accent)>0.55 and rgb(20,20,24)or c3(1,1,1)end)end if onClick then hook(b.MouseButton1Click,onClick)end return b end function F.renderReactions(id)
local holder=S.rxHolders and S.rxHolders[id]if not holder or not holder.Parent then return end for _,c in ipairs(holder:GetChildren())do if not c:IsA("UIListLayout")then c:Destroy()end end local map=S.reactions[id]or{}
local keys={}for e,users in pairs(map)do if next(users)then keys[#keys+1]=e end end tsort(keys)holder.Visible=#keys>0 holder.ZIndex=12 for i,e in ipairs(keys)do local n=0 for _ in pairs(map[e])do n=n+1 end
local mine=map[e][P.username]==true F.makeReactionPill(holder,e,n,mine,i,function()F.safeTap("rx:"..id..":"..e,function()F.doReact(S.msgs[id]or{packetId=id,chan=S.chan},e)end,0.32)end)end if#keys>0 then
local addB=mk("TextButton",{Text="+",Font=fGB,TextSize=12,Size=uo(24,22),BorderSizePixel=0,AutoButtonColor=true,Active=true,ZIndex=20,LayoutOrder=#keys+1,},holder)
th(addB,"BackgroundColor3","bg3");th(addB,"TextColor3","muted");corner(addB,11)hook(addB.MouseButton1Click,function()local m=S.msgs[id]or{packetId=id,chan=S.chan}
F.openEmoji({title=T("react"),onPick=function(e)F.doReact(m,e)end})end)end end function F.doReact(m,e)local t=os.clock()if t-S.reactAt<CFG.REACT_THRO then return end S.reactAt=t
if F.muted(P.username)then F.toast(T("muted"),true);return end local map=F.reactionMap(m.packetId)map[e]=map[e]or{}local add=not map[e][P.username]map[e][P.username]=add and true or nil S.isDirty=true
F.renderReactions(m.packetId)F.publish({type="react",target=m.packetId,emoji=e,by=P.username,action=add and"add"or"remove",chan=m.chan or S.chan})end function F.nearBottom()local s=U.scroll
return s.CanvasPosition.Y+s.AbsoluteWindowSize.Y>=s.AbsoluteCanvasSize.Y-50 end function F.snapBottom()local sc=U.scroll if not sc or not sc.Parent then return end
sc.CanvasPosition=v2(0,max(0,sc.AbsoluteCanvasSize.Y-sc.AbsoluteWindowSize.Y+40))end function F.scrollBottom()S.stickUntil=os.clock()+0.9 task.defer(function()task.wait()if not U.scroll.Parent then return end
F.snapBottom()S.newBelow=0;U.jump.Visible=false end)end function F.updateJump()local show=not F.nearBottom()and S.newBelow>0 U.jump.Visible=show if show then U.jump.Text="v "..S.newBelow end end
function F.dropFrame(id)local f=S.frames[id]if f then pcall(function()f:Destroy()end)end S.frames[id]=nil if S.rxHolders then S.rxHolders[id]=nil end if S.holdState then S.holdState[id]=nil end
if S.tapAt then S.tapAt[id]=nil end for i=#S.frameQ,1,-1 do if S.frameQ[i]==id then tremove(S.frameQ,i)end end end function F.trimFrames()while#S.frameQ>CFG.MAX_RENDER do local id=tremove(S.frameQ,1)F.dropFrame(id)end
end function F.matchSearch(m)local q=S.search if not q or q==""then return true end q=q:lower()return tostring(m.content or""):lower():find(q,1,true)~=nil or tostring(m.author or""):lower():find(q,1,true)~=nil end
function F.jumpToMsg(targetId)local tf=targetId and S.frames and S.frames[targetId]if not tf or not tf.Parent then return end pcall(function()
local dy=tf.AbsolutePosition.Y-U.scroll.AbsolutePosition.Y+U.scroll.CanvasPosition.Y-30 U.scroll.CanvasPosition=v2(0,max(0,dy))local orig=tf.BackgroundColor3 tf.BackgroundColor3=TH.accent
task.delay(0.55,function()if tf.Parent then tf.BackgroundColor3=orig end end)end)end function F.renderMessage(m)if not m or m.deleted or m.type~="msg"then return end
if not F.visibleIn(m,S.chan)or not F.matchSearch(m)then return end local id=m.packetId if S.frames[id]then return end S.rxHolders=S.rxHolders or{}local mine=m.author==P.username
local pinged=(not mine)and F.mentions(m.content)local grp=m.grp==true and not m.failed and P.group and S.search==""and m.prevId~=nil and S.frames[m.prevId]~=nil local frame=mk("Frame",{Size=u2(1,-4,0,0),AutomaticSize=asY,
BorderSizePixel=0,LayoutOrder=m.order or 0,Active=true,ClipsDescendants=false,},U.scroll)th(frame,"BackgroundColor3",mine and"own"or(pinged and"mention"or"bg2"),true)corner(frame,10)if pinged then stroke(frame,"mentionText",1,0.35)else stroke(frame,"bg3",1,0.65)end
pad(frame,10,grp and 4 or 7,8,grp and 4 or 7)local topR=F.topRole(m.author)local barCol=(topR and H.hex(topR.color))or(F.isDev(m.author)and H.hex(F.DEVROLE.color))or TH.accent
local bar=mk("Frame",{Size=u2(0,3,1,-8),Position=uo(0,4),BackgroundColor3=barCol,BorderSizePixel=0,ZIndex=2},frame)corner(bar,2)S.frames[id]=frame tinsert(S.frameQ,id)local compactAv=P.W<210
if not grp and not compactAv then local av=mk("ImageButton",{Size=uo(32,32),Position=uo(0,1),BackgroundTransparency=1,BorderSizePixel=0,Image=F.avatarUrl(m.uid or F.uidOf(m.author)),
AutoButtonColor=false,Active=true,ZIndex=8,},frame)corner(av,16)hook(av.MouseButton1Click,function()F.safeTap("av:"..id,function()F.openProfile(m.author)end)end)end local colX=(grp or compactAv)and 8 or 40
local rightReserve=grp and 24 or 4 local col=mk("Frame",{Position=uo(colX,0),Size=u2(1,-(colX+rightReserve),0,0),AutomaticSize=asY,BackgroundTransparency=1,ZIndex=3,},frame)list(col,4)if not grp then
local hdr=mk("Frame",{Size=u2(1,-64,0,20),BackgroundTransparency=1,LayoutOrder=1,ZIndex=4},col)mk("UIListLayout",{FillDirection=fdH,Padding=u1(0,5),SortOrder=soLO,VerticalAlignment=vaC,},hdr)
local dispStr=F.disp(m.display or m.author or"?")local nmW=clamp(H.textW(dispStr,13,fGB)+2,20,118)local nm=mk("TextButton",{Size=uo(nmW,18),BackgroundTransparency=1,Text=dispStr,Font=fGB,TextSize=13,
TextXAlignment=txL,TextTruncate=trEnd,LayoutOrder=1,BorderSizePixel=0,AutoButtonColor=false,Active=true,ZIndex=8,},hdr)hook(nm.MouseButton1Click,function()F.safeTap("nm:"..id,function()F.openProfile(m.author)end)
end)if topR then nm.TextColor3=H.hex(topR.color)else th(nm,"TextColor3","text")end if topR then F.roleChip(hdr,topR,2,false)elseif F.isDev(m.author)then F.roleChip(hdr,F.DEVROLE,2,false)end
local tStr=H.shortTime(m.ts)..(m.edited and(" "..T("edited"))or"")local tW=max(28,H.textW(tStr,10,fG)+4)local tm=mk("TextLabel",{Size=uo(tW,18),BackgroundTransparency=1,Text=tStr,Font=fG,TextSize=10,
TextXAlignment=txL,LayoutOrder=3,BorderSizePixel=0,ZIndex=4,},hdr)th(tm,"TextColor3","muted")if m.failed then local fStr=T("failed")local fl=mk("TextLabel",{Size=uo(H.textW(fStr,10,fGB)+4,18),
BackgroundTransparency=1,Text=fStr,Font=fGB,TextSize=10,LayoutOrder=4,BorderSizePixel=0,ZIndex=4,},hdr)th(fl,"TextColor3","danger")end end if m.replyTo then local rb=mk("TextButton",{Size=u2(1,0,0,20),Text="",
AutoButtonColor=true,BorderSizePixel=0,LayoutOrder=2,ZIndex=6,ClipsDescendants=true,},col)th(rb,"BackgroundColor3","bg3");corner(rb,6)
local rbar=mk("Frame",{Size=u2(0,3,1,-4),Position=uo(2,2),BackgroundColor3=barCol,BorderSizePixel=0,ZIndex=7},rb)corner(rbar,2)
local rl=lab(rb,">> @"..F.disp(m.replyAuthor or"?")..": "..F.disp(H.clip(F.plain(m.replySnippet or""),56)),{size=u2(1,-14,1,0),pos=uo(10,0),ts=10,key="muted",trunc=true,})rl.ZIndex=7
hook(rb.MouseButton1Click,function()F.jumpToMsg(m.replyTo)end)end local segs,imgCount,hasText=F.parseInlineSegments(m.content)if imgCount==0 then local rawDisp=F.disp(F.expandShortcodes(m.content))..(grp and m.edited and(" "..T("edited"))or"")
local body=lab(col,rawDisp,{wrap=true,auto=true,ts=P.textSize,layout=3})if rawDisp:find("@[%w_]+")or rawDisp:find(":[%w_%-]+:")then
themed(body,function(bLbl)local eHex=H.tohex(TH.emojiText or TH.accent)local escaped=H.esc(rawDisp):gsub("@([%w_]+)",function(u)
local colHex=H.tohex(F.mentionColorFor(u))return'<font color="'..colHex..'"><b>@'..u..'</b></font>'end):gsub(":([%w_%-]+):",function(em)
return'<font color="'..eHex..'"><b>:'..em..':</b></font>'end)bLbl.RichText=true bLbl.Text=escaped end)else body.RichText=false
end body.ZIndex=3 elseif not hasText then local ir=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BackgroundTransparency=1,LayoutOrder=3,ZIndex=4},col)
mk("UIListLayout",{FillDirection=fdH,Wraps=true,Padding=u1(0,6),SortOrder=soLO,VerticalAlignment=vaC},ir)local sz=imgCount==1 and 54 or 42 for i,seg in ipairs(segs)do if seg.kind=="img"then
local info=F.emojiInfoById(seg.id)local holder=mk("TextButton",{Size=uo(sz,sz+(info and 14 or 0)),BackgroundTransparency=1,Text="",BorderSizePixel=0,LayoutOrder=i,ZIndex=6,},ir)
local ib=F.iconBox(holder,"img:"..seg.id,sz)ib.ZIndex=6 if info and info.name then local tagL=lab(holder,":"..info.name..":",{size=u2(1,0,0,13),pos=uo(0,sz),ts=9,bold=true,key="emojiText",align=txC,trunc=true,})tagL.ZIndex=6 end
hook(holder.MouseButton1Click,function()F.openEmojiPreview(seg.id,m,false)end)end end else local flow=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BackgroundTransparency=1,LayoutOrder=3,ZIndex=4},col)
mk("UIListLayout",{FillDirection=fdH,Wraps=true,Padding=u1(0,3),SortOrder=soLO,VerticalAlignment=vaC},flow)local orderIdx=0 local inlineSz=clamp(P.textSize+8,20,26)for _,seg in ipairs(segs)do if seg.kind=="text"then
for word in tostring(seg.text):gmatch("%S+")do orderIdx=orderIdx+1 local wStr=F.disp(word)local wW=max(6,H.textW(wStr,P.textSize,fG)+2)local wl=mk("TextLabel",{Size=uo(wW,inlineSz),BackgroundTransparency=1,
Text=wStr,Font=fG,TextSize=P.textSize,TextXAlignment=txL,BorderSizePixel=0,LayoutOrder=orderIdx,ZIndex=4,},flow)if wStr:match("^@[%w_]+")then local u=wStr:match("^@([%w_]+)")wl.Font=fGB
themed(wl,function(x)x.TextColor3=F.mentionColorFor(u)end)elseif wStr:match("^:[%w_%-]+:$")then wl.Font=fGB th(wl,"TextColor3","emojiText")else th(wl,"TextColor3","text")end end elseif seg.kind=="img"then orderIdx=orderIdx+1
local info=F.emojiInfoById(seg.id)local eb=mk("TextButton",{
Size=uo(inlineSz,inlineSz),BackgroundTransparency=1,Text="",BorderSizePixel=0,LayoutOrder=orderIdx,ZIndex=6,},flow)local ib=F.iconBox(eb,"img:"..seg.id,inlineSz)ib.ZIndex=6
hook(eb.MouseButton1Click,function()F.openEmojiPreview(seg.id,m,false)end)end end end local jPlace,jJob=tostring(m.content or""):match("%[join:(%d+):([%w_%-]+)%]")if jPlace and jJob then
local jCard=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BorderSizePixel=0,LayoutOrder=4,ZIndex=6},col)th(jCard,"BackgroundColor3","bg3");corner(jCard,8);stroke(jCard,"ok",1,0.3);pad(jCard,6,5,6,5);list(jCard,3)
local isSameSrv=(tonumber(jPlace)==game.PlaceId and jJob==game.JobId)local jBtn=tbtn(jCard,isSameSrv and T("join_srv_self")or T("join_srv_btn"),{size=u2(1,0,0,24),key=isSameSrv and"bg2"or"ok",ts=11,r=6,layout=1,
})jBtn.ZIndex=7 local noteL=lab(jCard,T("delta_tp_short"),{wrap=true,auto=true,ts=9,key="warn",layout=2})noteL.ZIndex=7 hook(jBtn.MouseButton1Click,function()
if isSameSrv then F.toast(T("join_srv_self"),true);return end if F.armAutoTeleport then F.armAutoTeleport()end F.toast(T("delta_tp_note"),true)
pcall(function()TeleportService:TeleportToPlaceInstance(tonumber(jPlace),jJob,LP)end)end)end local rx=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BackgroundTransparency=1,LayoutOrder=5,Visible=false,ZIndex=12,
},col)mk("UIListLayout",{FillDirection=fdH,Wraps=true,Padding=u1(0,4),SortOrder=soLO,VerticalAlignment=vaC},rx)S.rxHolders[id]=rx F.renderReactions(id)if not grp then local qbar=mk("Frame",{Size=uo(62,20),
Position=u2(1,-62,0,0),BackgroundTransparency=1,ZIndex=10,},frame)mk("UIListLayout",{FillDirection=fdH,Padding=u1(0,2),HorizontalAlignment=Enum.HorizontalAlignment.Right,VerticalAlignment=vaC,SortOrder=soLO},qbar)
local qReact=mk("TextButton",{Size=uo(19,19),BackgroundTransparency=1,Text="😀",TextSize=11,Font=fGB,BorderSizePixel=0,LayoutOrder=1,ZIndex=11},qbar)th(qReact,"TextColor3","muted")
hook(qReact.MouseButton1Click,function()F.openEmoji({title=T("react"),onPick=function(e)F.doReact(m,e)end})end)
local qReply=mk("TextButton",{Size=uo(22,19),BackgroundTransparency=1,Text="Re",TextSize=10,Font=fGB,BorderSizePixel=0,LayoutOrder=2,ZIndex=11},qbar)th(qReply,"TextColor3","muted")
hook(qReply.MouseButton1Click,function()F.startReply(m)end)local menu=mk("TextButton",{Size=uo(20,19),BackgroundTransparency=1,Text="...",TextSize=12,Font=fGB,BorderSizePixel=0,LayoutOrder=3,ZIndex=11,Active=true,
},qbar)th(menu,"TextColor3","muted")hook(menu.MouseButton1Click,function()F.openCtx(m,menu.AbsolutePosition+v2(0,22))end)else local menu=mk("TextButton",{Size=uo(22,18),Position=u2(1,-22,0,0),
BackgroundTransparency=1,Text="...",TextSize=12,Font=fGB,BorderSizePixel=0,ZIndex=11,Active=true,},frame)th(menu,"TextColor3","muted")hook(menu.MouseButton1Click,function()F.openCtx(m,menu.AbsolutePosition+v2(0,20))
end)end local tap=mk("TextButton",{Size=u2(1,-42,1,0),Position=uo(42,0),BackgroundTransparency=1,Text="",ZIndex=1,Active=true,},frame)S.tapAt=S.tapAt or{}S.holdState=S.holdState or{}
hook(tap.InputBegan,function(input)if input.UserInputType~=mb1 and input.UserInputType~=utTouch then return end S.holdState[id]={t0=os.clock(),fired=false,input=input}task.delay(0.5,function()local hs=S.holdState[id]
if hs and not hs.fired and hs.input==input then hs.fired=true F.openCtx(m,v2(input.Position.X,input.Position.Y+24))end end)end)hook(tap.InputEnded,function(input)local hs=S.holdState[id]
if hs and hs.input==input then local dt=os.clock()-hs.t0 S.holdState[id]=nil if not hs.fired and dt<0.5 then if m.failed then F.resend(m);return end local now=os.clock()if S.tapAt[id]and now-S.tapAt[id]<0.4 then
S.tapAt[id]=nil F.openCtx(m,tap.AbsolutePosition+v2(20,20))else S.tapAt[id]=now end end end end)F.trimFrames()end function F.closeCtx()for _,c in ipairs(U.layer:GetChildren())do c:Destroy()end U.layer.Visible=false
end function F.copyText(s)local ok=pcall(function()if setclipboard then setclipboard(s)else toclipboard(s)end end)F.toast(ok and T("copy_ok")or"Clipboard Error",true)end function F.openCtx(m,pos)F.closeCtx()
U.layer.Visible=true local back=mk("TextButton",{Size=us(1,1),BackgroundTransparency=1,Text="",AutoButtonColor=false,ZIndex=100},U.layer)hook(back.MouseButton1Click,F.closeCtx)local menu=mk("Frame",{Size=uo(220,0),
AutomaticSize=asY,BorderSizePixel=0,ZIndex=101,},U.layer)th(menu,"BackgroundColor3","bg2");corner(menu,12)stroke(menu,"accent",1,0.55)pad(menu,8,8,8,8);list(menu,4)local v=viewNow()menu.Position=uo(clamp(pos.X,6,max(6,v.X-226)),clamp(pos.Y,6,max(6,v.Y-260)))
task.defer(function()if menu.Parent then local vv=viewNow()local mh=menu.AbsoluteSize.Y menu.Position=uo(clamp(pos.X,6,max(6,vv.X-226)),clamp(pos.Y,6,max(6,vv.Y-mh-8)))end end)local hdr=mk("Frame",{Size=u2(1,0,0,32),BackgroundTransparency=1,LayoutOrder=0},menu)lab(hdr,"💬  "..F.disp(H.clip(F.plain(m.content),30)),{
size=u2(1,0,1,0),ts=11,key="muted",trunc=true,})local qr=row(menu,32);qr.LayoutOrder=1 for _,e in ipairs(F.quickEmoji())do local b=tbtn(qr,"",{size=uo(38,32),r=8})local ic=F.iconBox(b,e,24)
ic.Position=u2(0.5,-12,0.5,-12)hook(b.MouseButton1Click,function()F.closeCtx();F.doReact(m,e)end)end local more=tbtn(qr,"+",{size=uo(38,32),r=8,key="accent",ts=16})hook(more.MouseButton1Click,function()F.closeCtx()
F.openEmoji({title=T("react"),onPick=function(e)F.doReact(m,e)end})end)local function item(text,fn,key)local b=tbtn(menu,text,{size=u2(1,0,0,28),key=key or"bg3",ts=12})b.TextXAlignment=txL
pad(b,12,0,10,0)hook(b.MouseButton1Click,function()F.closeCtx();fn()end)end item(T("reply"),function()F.startReply(m)end)item(T("copy"),function()F.copyText(F.plain(m.content))end)if m.author==P.username then item(T("edit"),function()F.startEdit(m)end)end if m.author==P.username or F.canAct(P.username,m.author)then item(T("delete"),function()F.deleteMsg(m)end,"danger")end
if m.author~=P.username then item(T("profile"),function()F.openProfile(m.author)end)item(T("report"),function()F.openReport(m.author,m)end,"warn")if F.canAct(P.username,m.author)then
item(T("mute"),function()F.openMute(m.author)end)end end end function F.chanName(c)if c=="general"then return T("general")elseif c=="announce"then return T("announcetab")elseif c=="game"then return T("game")
elseif c=="scripts"then return T("script_forum")elseif c=="staff"then return T("stafftab")end local o=F.dmOther(c)return o and("DM · "..o)or c end 
function F.updateInfo()local n=0 for _,r in pairs(S.users)do if F.isLive(r)then n=n+1 end end n=max(n,1)U.infoLbl.Text=n.." "..T("online").."  ·  "..F.chanName(S.chan)..(S.rtt and("  ·  "..floor(S.rtt).."ms")or"")end function F.cancelCompose()S.reply,S.editing=nil,nil U.replyBar.Visible=false F.layout()end function F.startReply(m)S.editing=nil S.reply={id=m.packetId,author=m.author,snippet=H.clip(F.plain(m.content),80)}
U.replyLbl.Text=T("reply_to")..F.disp(m.author)..": "..F.disp(S.reply.snippet)U.replyBar.Visible=true;F.layout();U.input:CaptureFocus()end function F.startEdit(m)S.reply=nil S.editing=m.packetId
U.replyLbl.Text=T("editing")U.replyBar.Visible=true;F.layout()U.input.Text=m.content U.input:CaptureFocus()end function F.deleteMsg(m)m.deleted=true F.dropFrame(m.packetId)F.onDeleted(m)
F.publish({type="delete",target=m.packetId,author=P.username,chan=m.chan})end function F.resend(m)m.failed=false F.dropFrame(m.packetId);F.renderMessage(m)
local pkt={type="msg",packetId=m.packetId,chan=m.chan,author=m.author,display=m.display,uid=m.uid,content=m.content,ts=m.ts,replyTo=m.replyTo,replyAuthor=m.replyAuthor,replySnippet=m.replySnippet,place=m.place}
F.publish(pkt,"send",function(ok)if not ok then m.failed=true;F.dropFrame(m.packetId);F.renderMessage(m)end end)end function F.selectChannel(chan)
if chan=="staff"and not F.isStaff(P.username)then F.toast(T("staff_only"),true);return end S.chan=chan if S.unread[chan]then S.unread[chan]=0 end S.dmUnread[chan]=nil S.newBelow=0;U.jump.Visible=false
S.search="";U.searchBox.Text="";U.searchBox.Visible=false if U.input then if chan=="announce"then local canPost=F.canAnnounce(P.username)pcall(function()U.input.TextEditable=canPost end)
U.input.PlaceholderText=canPost and T("announce_ph")or T("announce_ro")else pcall(function()U.input.TextEditable=true end)U.input.PlaceholderText=T("input")end end F.cancelCompose();F.layout()
F.rebuildFeed();F.paintTabs();F.updateInfo()U.typing.Text=""end F.SCRIPT_TAGS={"All","Saved","Universal","Current Game","Hub / GUI","PVP / Combat","Fun / Misc"}function F.cleanScriptSource(raw)local s=tostring(raw or"")
s=s:gsub("^%s*```[%w_%-]*%s+",""):gsub("%s*```%s*$","")s=s:gsub("“",'"'):gsub("”",'"'):gsub("‘","'"):gsub("’","'")s=s:gsub("…$","")return H.trim(s)end function F.doScriptReact(sc,emoji)if not sc or not sc.id then return end local t=os.clock()
if t-S.reactAt<CFG.REACT_THRO then return end S.reactAt=t if F.muted(P.username)then F.toast(T("muted"),true);return end sc.reactions=type(sc.reactions)=="table"and sc.reactions or{}
sc.reactions[emoji]=type(sc.reactions[emoji])=="table"and sc.reactions[emoji]or{}local add=not sc.reactions[emoji][P.username]sc.reactions[emoji][P.username]=add and true or nil
if not next(sc.reactions[emoji])then sc.reactions[emoji]=nil end S.isDirty=true if S.chan=="scripts"then F.rebuildFeed(true)end enqueue("other","POST","/api/scripts",{action="react",by=P.username,id=sc.id,
emoji=emoji,mode=add and"add"or"remove",},function(d)if d and d.ok and type(d.topic)=="table"then sc.reactions=d.topic.reactions or sc.reactions if S.chan=="scripts"then F.rebuildFeed(true)end end end)end
function F.deleteScriptTopics(ids,onDone)if type(ids)~="table"or#ids==0 then return end local idSet={}for _,id in ipairs(ids)do idSet[tostring(id)]=true end enqueue("other","POST","/api/scripts",{
action=#ids>1 and"delete_multi"or"delete",by=P.username,ids=ids,id=ids[1],},function(d,err)if d and d.ok then if type(d.scripts)=="table"then S.scripts=d.scripts else local keep={}for _,sc in ipairs(S.scripts)do
if not idSet[tostring(sc.id)]then keep[#keep+1]=sc end end S.scripts=keep end S.scriptSeq=tonumber(d.scriptSeq)or S.scriptSeq S.isDirty=true F.toast(T("script_deleted").." ("..tostring(d.removed or#ids)..")",true)
if S.chan=="scripts"then F.rebuildFeed(true)end if onDone then onDone(true)end else F.netError((d and d.error)or err)if onDone then onDone(false)end end end)end function F.openScriptReport(sc)if not sc then return end
local scr,close=F.popup(T("script_report"),340,340)lab(scr,"📜 "..F.disp(sc.title).." (by @"..F.disp(sc.author)..")",{bold=true,ts=12,wrap=true,auto=true,key="accent"})
local quickReasons={T("script_r_scam"),T("script_r_broken"),T("script_r_spam"),T("script_r_mal")}local rs=field(scr,T("reason"),"",true)lab(scr,T("script_quick_reason"),{ts=10,key="muted",bold=true})
for _,qr in ipairs(quickReasons)do local qb=tbtn(scr,"• "..qr,{h=26,ts=11,key="bg3"})qb.TextXAlignment=txL;pad(qb,8,0,8,0)hook(qb.MouseButton1Click,function()rs.Text=qr end)end
local go=tbtn(scr,T("report"),{key="warn",h=34})hook(go.MouseButton1Click,function()local r=H.trim(rs.Text)if r==""then F.toast(T("need_reason"),true);return end enqueue("other","POST","/api/scripts",{
action="report",by=P.username,id=sc.id,reason=H.clip(r,300),},function(d,err)if d and d.ok then sc.reports=type(sc.reports)=="table"and sc.reports or{}tinsert(sc.reports,{by=P.username,reason=r,ts=H.now()})
F.toast(T("report_sent"),true)if type(close)=="function"then close()else F.closeModal()end if S.chan=="scripts"then F.rebuildFeed(true)end else F.netError((d and d.error)or err)end end)end)end
function F.openScriptDetail(sc)if not sc then return end local scr,close=F.modalBox("📜 "..F.disp(sc.title),410,560)local metaCard=F.card(scr,0);metaCard.AutomaticSize=asY;metaCard.Size=u2(1,0,0,0)
pad(metaCard,10,8,10,8);list(metaCard,5)local authorRow=mk("Frame",{Size=u2(1,0,0,22),BackgroundTransparency=1},metaCard)
mk("UIListLayout",{FillDirection=fdH,Padding=u1(0,6),SortOrder=soLO,VerticalAlignment=vaC},authorRow)
local av=mk("ImageButton",{Size=uo(20,20),BackgroundTransparency=1,Image=F.avatarUrl(sc.uid or F.uidOf(sc.author)),BorderSizePixel=0,LayoutOrder=1},authorRow)corner(av,10)
hook(av.MouseButton1Click,function()F.openProfile(sc.author)end)local topR=F.topRole(sc.author)local authStr=F.disp(sc.display or sc.author or"?")local authBtn=mk("TextButton",{
Size=uo(clamp(H.textW(authStr,12,fGB)+4,24,130),20),BackgroundTransparency=1,Text=authStr,Font=fGB,TextSize=12,TextXAlignment=txL,TextTruncate=trEnd,BorderSizePixel=0,LayoutOrder=2,},authorRow)
if topR then authBtn.TextColor3=H.hex(topR.color)else th(authBtn,"TextColor3","text")end hook(authBtn.MouseButton1Click,function()F.openProfile(sc.author)end)if topR then F.roleChip(authorRow,topR,3,false)
elseif F.isDev(sc.author)then F.roleChip(authorRow,F.DEVROLE,3,false)end lab(metaCard,"["..F.disp(sc.tag or"Universal").."]  ·  "..H.shortTime(sc.ts),{ts=11,bold=true,key="accent"})if sc.desc and sc.desc~=""then
lab(metaCard,F.disp(sc.desc),{wrap=true,auto=true,ts=12})end if sc.gameName and sc.gameName~=""then lab(metaCard,"🎮 Game: "..F.disp(sc.gameName)..(sc.placeId and sc.placeId>0 and(" ("..tostring(sc.placeId)..")")or""),{
wrap=true,auto=true,ts=10,key="ok",})end F.section(scr,T("script_code"))local codeBox=mk("TextBox",{Size=u2(1,0,0,180),Text=tostring(sc.code or""),ClearTextOnFocus=false,TextEditable=false,MultiLine=true,
TextWrapped=true,Font=fCode,TextSize=11,TextXAlignment=txL,TextYAlignment=Enum.TextYAlignment.Top,BorderSizePixel=0,},scr)th(codeBox,"BackgroundColor3","bg3");th(codeBox,"TextColor3","text")
corner(codeBox,8);pad(codeBox,8,8,8,8)local act1=row(scr,32)local bCopy=rbtn(act1,T("copy"),{key="accent",size=u2(0.5,-3,1,0)})hook(bCopy.MouseButton1Click,function()F.copyText(tostring(sc.code or""))end)local bReact=rbtn(act1,T("react"),{size=u2(0.5,-3,1,0)})
hook(bReact.MouseButton1Click,function()F.openEmoji({title=T("react"),onPick=function(e)F.doScriptReact(sc,e)end})end)local act2=row(scr,30)local bProf=rbtn(act2,T("profile"),{ts=11})
hook(bProf.MouseButton1Click,function()F.openProfile(sc.author)end)local bRep=rbtn(act2,T("report"),{key="warn",ts=11})hook(bRep.MouseButton1Click,function()F.openScriptReport(sc)end)
if F.isStaff(P.username)and type(sc.reports)=="table"and#sc.reports>0 then F.section(scr,T("script_reports_hdr").." ("..#sc.reports..")")for _,rp in ipairs(sc.reports)do
local rc=F.card(scr,0);rc.AutomaticSize=asY;rc.Size=u2(1,0,0,0)pad(rc,8,5,8,5);list(rc,2)lab(rc,"@"..F.disp(rp.by or"?").." · "..H.shortTime(rp.ts),{ts=10,bold=true,key="warn"})
lab(rc,F.disp(rp.reason or""),{ts=11,wrap=true,auto=true})end end if F.isStaff(P.username)or tostring(sc.author):lower()==P.username:lower()then local bDel=tbtn(scr,T("script_del_this"),{key="danger",h=32})
hook(bDel.MouseButton1Click,function()F.deleteScriptTopics({sc.id},function(ok)if ok then if type(close)=="function"then close()else F.closeModal()end end end)end)end end function F.openScriptComposer()
if F.muted(P.username)then F.toast(T("muted"),true);return end if S.banned then F.toast(T("banned_you"),true);return end local scr,close=F.modalBox("+ "..T("script_new"),400,560)
local titleBox=field(scr,T("script_title"),"")titleBox.PlaceholderText=T("script_title_ph")lab(scr,T("script_tag"),{h=14,ts=10,bold=true,key="muted"})local chosenTag="Universal"
local tagRow=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BackgroundTransparency=1},scr)mk("UIListLayout",{FillDirection=fdH,Wraps=true,Padding=u1(0,4),SortOrder=soLO},tagRow)local tagBtns={}
local postTags={"Universal","Current Game","Hub / GUI","PVP / Combat","Fun / Misc"}local function paintTags()for t,b in pairs(tagBtns)do b.BackgroundColor3=(t==chosenTag)and TH.accent or TH.bg3 end end
for i,tg in ipairs(postTags)do local b=tbtn(tagRow,tg=="Current Game"and("🎮 "..H.clip(S.placeName~="?"and S.placeName or T("tag_cur_game"),18))or tg,{size=uo(112,26),ts=10,r=13,layout=i,})tagBtns[tg]=b
hook(b.MouseButton1Click,function()chosenTag=tg;paintTags()end)end paintTags()local descBox=field(scr,T("script_desc"),"",true)descBox.PlaceholderText=T("script_desc_ph")local codeHdr=row(scr,22)
lab(codeHdr,T("script_code"),{size=u2(1,-120,1,0),ts=10,bold=true,key="muted"})local codeBox if type(getclipboard)=="function"then local pst=tbtn(codeHdr,T("script_paste"),{size=uo(114,22),ts=10,key="bg3",r=6})
hook(pst.MouseButton1Click,function()pcall(function()local clipStr=getclipboard()if type(clipStr)=="string"and clipStr~=""and codeBox then codeBox.Text=clipStr end end)end)end codeBox=mk("TextBox",{
Size=u2(1,0,0,120),Text="",PlaceholderText='loadstring(game:HttpGet("https://..."))()',ClearTextOnFocus=false,MultiLine=true,TextWrapped=true,Font=fCode,TextSize=11,TextXAlignment=txL,
TextYAlignment=Enum.TextYAlignment.Top,BorderSizePixel=0,},scr)th(codeBox,"BackgroundColor3","bg3");th(codeBox,"TextColor3","text");th(codeBox,"PlaceholderColor3","muted")corner(codeBox,8);pad(codeBox,8,6,8,6)
local submit=tbtn(scr,"+ "..T("script_new"),{key="accent",h=36,ts=13})hook(submit.MouseButton1Click,function()local ttl=H.trim(titleBox.Text)local cd=F.cleanScriptSource(codeBox.Text)local ds=H.trim(descBox.Text)
if ttl==""or cd==""then F.toast(T("script_need_fields"),true)return end local finalTag=chosenTag=="Current Game"and H.clip(S.placeName~="?"and S.placeName or"Game",22)or chosenTag enqueue("send","POST","/api/scripts",{
action="create",by=P.username,display=P.display,uid=P.userId,title=H.clip(ttl,80),tag=finalTag,desc=H.clip(ds,300),code=cd:sub(1,15000),placeId=game.PlaceId,gameName=S.placeName,},function(d,err)
if d and d.ok then if type(d.scripts)=="table"then S.scripts=d.scripts elseif type(d.topic)=="table"then tinsert(S.scripts,d.topic)end S.scriptSeq=tonumber(d.scriptSeq)or S.scriptSeq S.isDirty=true
if type(close)=="function"then close()else F.closeModal()end F.toast(T("script_post_ok"),true)if S.chan=="scripts"then F.rebuildFeed(true)end else F.netError((d and d.error)or err)end end)end)end
function F.renderScriptForum()local staff=F.isStaff(P.username)local topBar=mk("Frame",{Size=u2(1,-4,0,0),AutomaticSize=asY,BorderSizePixel=0,LayoutOrder=1,},U.scroll)
th(topBar,"BackgroundColor3","bg2",true);corner(topBar,10);pad(topBar,8,8,8,8);list(topBar,6)local row1=row(topBar,30);row1.LayoutOrder=1 local postBtn=rbtn(row1,"+ "..T("script_new"),{key="accent",
size=staff and u2(0.54,-3,1,0)or u2(1,0,1,0),ts=12,})hook(postBtn.MouseButton1Click,F.openScriptComposer)if staff then local multiBtn=rbtn(row1,(S.scriptMultiMode and"[x] "or"[ ] ")..T("script_multi"),{
key=S.scriptMultiMode and"warn"or"bg3",size=u2(0.46,-3,1,0),ts=11,})hook(multiBtn.MouseButton1Click,function()S.scriptMultiMode=not S.scriptMultiMode if not S.scriptMultiMode then S.scriptSelected={}end
F.rebuildFeed(true)end)end if staff and S.scriptMultiMode then local selCount=0 for _ in pairs(S.scriptSelected)do selCount=selCount+1 end local bulkRow=row(topBar,28);bulkRow.LayoutOrder=2
local bAll=rbtn(bulkRow,T("script_sel_all"),{size=u2(0.28,-3,1,0),ts=10})hook(bAll.MouseButton1Click,function()for _,sc in ipairs(S.scripts or{})do S.scriptSelected[tostring(sc.id)]=true end F.rebuildFeed(true)end)
local bClr=rbtn(bulkRow,T("script_unsel"),{size=u2(0.26,-3,1,0),ts=10})hook(bClr.MouseButton1Click,function()S.scriptSelected={}F.rebuildFeed(true)end)
local bDel=rbtn(bulkRow,T("script_del_sel").." ("..selCount..")",{size=u2(0.46,-3,1,0),ts=10,key="danger",})hook(bDel.MouseButton1Click,function()local ids={}
for id in pairs(S.scriptSelected)do ids[#ids+1]=id end if#ids==0 then return end F.deleteScriptTopics(ids,function(ok)if ok then S.scriptSelected={};S.scriptMultiMode=false end end)end)end
local tagScroll=mk("ScrollingFrame",{Size=u2(1,0,0,24),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=0,CanvasSize=u2(),AutomaticCanvasSize=asX,
ScrollingDirection=Enum.ScrollingDirection.X,LayoutOrder=3,},topBar)mk("UIListLayout",{FillDirection=fdH,Padding=u1(0,4),SortOrder=soLO,VerticalAlignment=vaC},tagScroll)for i,tg in ipairs(F.SCRIPT_TAGS)do
local on=(S.scriptTagFilter or"All")==tg local dispTag=tg=="All"and T("tag_all")or(tg=="Saved"and T("tag_saved")or(tg=="Current Game"and T("tag_cur_game")or tg))local tgW=max(44,H.textW(dispTag,10,fGB)+18)
local b=mk("TextButton",{Size=uo(tgW,22),Text=dispTag,Font=fGB,TextSize=10,BorderSizePixel=0,LayoutOrder=i,},tagScroll)th(b,"BackgroundColor3",on and"accent"or"bg3")if on then
themed(b,function(x)x.TextColor3=H.lum(TH.accent)>0.55 and rgb(20,20,24)or c3(1,1,1)end)else th(b,"TextColor3","muted")end corner(b,11)hook(b.MouseButton1Click,function()S.scriptTagFilter=tg F.rebuildFeed(true)end)
end local q=H.trim(S.search or""):lower()local filtered={}for i=#(S.scripts or{}),1,-1 do local sc=S.scripts[i]if type(sc)=="table"and sc.id then local tagOk=(S.scriptTagFilter=="All"or not S.scriptTagFilter)
or(S.scriptTagFilter=="Saved"and P.savedScripts and P.savedScripts[tostring(sc.id)]==true)or(S.scriptTagFilter=="Current Game"and tonumber(sc.placeId)==game.PlaceId)
or(tostring(sc.tag or""):lower()==tostring(S.scriptTagFilter):lower())local searchOk=q==""or tostring(sc.title or""):lower():find(q,1,true)~=nil or tostring(sc.desc or""):lower():find(q,1,true)~=nil
or tostring(sc.author or""):lower():find(q,1,true)~=nil or tostring(sc.tag or""):lower():find(q,1,true)~=nil if tagOk and searchOk then filtered[#filtered+1]=sc end end end if#filtered==0 then
local emptyCard=F.card(U.scroll,64);emptyCard.LayoutOrder=2 pad(emptyCard,12,10,12,10)lab(emptyCard,T("script_empty"),{wrap=true,auto=true,ts=11,key="muted",align=txC})return end for idx,sc in ipairs(filtered)do
local sid=tostring(sc.id)local isSel=S.scriptSelected[sid]==true local canDel=staff or(tostring(sc.author or""):lower()==P.username:lower())local rptCount=type(sc.reports)=="table"and#sc.reports or 0
local card=mk("Frame",{Size=u2(1,-4,0,0),AutomaticSize=asY,BorderSizePixel=0,LayoutOrder=idx+10,},U.scroll)th(card,"BackgroundColor3",isSel and"mention"or"bg2",true)corner(card,12)pad(card,12,8,10,8)list(card,5)
local topR=F.topRole(sc.author)local barCol=(topR and H.hex(topR.color))or(F.isDev(sc.author)and H.hex(F.DEVROLE.color))or TH.accent mk("UIStroke",{Color=isSel and TH.danger or barCol,Thickness=isSel and 2 or 1,
Transparency=isSel and 0.15 or 0.65,ApplyStrokeMode=smBorder,},card)local metaTop=mk("Frame",{Size=u2(1,0,0,20),BackgroundTransparency=1,LayoutOrder=1},card)
mk("UIListLayout",{FillDirection=fdH,Padding=u1(0,5),SortOrder=soLO,VerticalAlignment=vaC},metaTop)if staff and S.scriptMultiMode then local chkBtn=tbtn(metaTop,isSel and"x"or"",{
size=uo(22,20),ts=11,key=isSel and"danger"or"bg3",r=6,layout=0,})hook(chkBtn.MouseButton1Click,function()S.scriptSelected[sid]=not S.scriptSelected[sid]or nil F.rebuildFeed(true)end)end
local tgStr=F.disp(sc.tag or"Universal")local tgPillW=clamp(H.textW(tgStr,10,fGB)+14,42,130)local tagPill=mk("Frame",{Size=uo(tgPillW,18),BorderSizePixel=0,LayoutOrder=1},metaTop)
th(tagPill,"BackgroundColor3","bg3");corner(tagPill,9)lab(tagPill,tgStr,{size=us(1,1),ts=10,bold=true,key="accent",align=txC,trunc=true})local tmStr=H.shortTime(sc.ts)
lab(metaTop,"· "..tmStr,{size=uo(H.textW(tmStr,10,fG)+14,18),ts=10,key="muted",layout=2})if staff and rptCount>0 then lab(metaTop,"! "..rptCount,{size=uo(38,18),ts=10,bold=true,key="warn",layout=3})end
local titleBtn=mk("TextButton",{Size=u2(1,0,0,20),BackgroundTransparency=1,Text=F.disp(sc.title or"Untitled"),Font=fGB,TextSize=13,TextXAlignment=txL,TextTruncate=trEnd,BorderSizePixel=0,LayoutOrder=2,},card)
th(titleBtn,"TextColor3","text")hook(titleBtn.MouseButton1Click,function()F.openScriptDetail(sc)end)local metaRow=mk("Frame",{Size=u2(1,0,0,20),BackgroundTransparency=1,LayoutOrder=3},card)
mk("UIListLayout",{FillDirection=fdH,Padding=u1(0,5),SortOrder=soLO,VerticalAlignment=vaC},metaRow)
local av=mk("ImageButton",{Size=uo(18,18),BackgroundTransparency=1,Image=F.avatarUrl(sc.uid or F.uidOf(sc.author)),BorderSizePixel=0,LayoutOrder=1},metaRow)corner(av,9)
hook(av.MouseButton1Click,function()F.openProfile(sc.author)end)local authStr=F.disp(sc.display or sc.author or"?")local authW=clamp(H.textW(authStr,11,fGB)+4,20,120)local authBtn=mk("TextButton",{Size=uo(authW,18),
BackgroundTransparency=1,Text=authStr,Font=fGB,TextSize=11,TextXAlignment=txL,TextTruncate=trEnd,BorderSizePixel=0,LayoutOrder=2,},metaRow)
if topR then authBtn.TextColor3=H.hex(topR.color)else th(authBtn,"TextColor3","text")end hook(authBtn.MouseButton1Click,function()F.openProfile(sc.author)end)if topR then F.roleChip(metaRow,topR,3,false)
elseif F.isDev(sc.author)then F.roleChip(metaRow,F.DEVROLE,3,false)end if sc.desc and sc.desc~=""then lab(card,F.disp(H.clip(sc.desc,160)),{wrap=true,auto=true,ts=11,key="muted",layout=4})end
local codePv=mk("TextButton",{Size=u2(1,0,0,38),Text=H.clip(tostring(sc.code or""),120),Font=fCode,TextSize=10,TextXAlignment=txL,TextYAlignment=Enum.TextYAlignment.Top,TextWrapped=true,TextTruncate=trEnd,
BorderSizePixel=0,LayoutOrder=5,},card)th(codePv,"BackgroundColor3","bg3");th(codePv,"TextColor3","text")corner(codePv,7);pad(codePv,8,5,8,5)hook(codePv.MouseButton1Click,function()F.openScriptDetail(sc)end)
local actRow=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BackgroundTransparency=1,LayoutOrder=6,ZIndex=8,},card)mk("UIListLayout",{FillDirection=fdH,Wraps=true,Padding=u1(0,5),SortOrder=soLO,
VerticalAlignment=vaC,},actRow)local bCopy=tbtn(actRow,T("copy"),{size=uo(56,26),ts=11,key="accent",r=6,layout=1})bCopy.ZIndex=10 hook(bCopy.MouseButton1Click,function()F.copyText(tostring(sc.code or""))end)
local bView=tbtn(actRow,T("script_view"),{size=uo(52,26),ts=11,key="bg3",r=6,layout=2})bView.ZIndex=10 hook(bView.MouseButton1Click,function()F.openScriptDetail(sc)end)
local isSaved=P.savedScripts and P.savedScripts[sid]==true local bSave=tbtn(actRow,isSaved and T("tag_saved")or T("save"),{size=uo(54,26),ts=10,key=isSaved and"warn"or"bg3",r=6,layout=3})bSave.ZIndex=10
hook(bSave.MouseButton1Click,function()P.savedScripts=P.savedScripts or{}if P.savedScripts[sid]then P.savedScripts[sid]=nil else P.savedScripts[sid]=true end S.isDirty=true F.rebuildFeed(true)end)
local bEmo=tbtn(actRow,"😀+",{size=uo(36,26),ts=11,key="bg3",r=6,layout=5})bEmo.ZIndex=10 hook(bEmo.MouseButton1Click,function()
F.openEmoji({title=T("react").." · "..H.clip(sc.title,20),onPick=function(e)F.doScriptReact(sc,e)end})end)local bRep=tbtn(actRow,T("report"),{size=uo(54,26),ts=10,key="warn",r=6,layout=5})bRep.ZIndex=10
hook(bRep.MouseButton1Click,function()F.openScriptReport(sc)end)if canDel then local bDel=tbtn(actRow,T("delete"),{size=uo(46,26),ts=10,key="danger",r=6,layout=6})bDel.ZIndex=10 hook(bDel.MouseButton1Click,function()
F.deleteScriptTopics({sid})end)end local rxMap=type(sc.reactions)=="table"and sc.reactions or{}local rxKeys={}for em,usrs in pairs(rxMap)do if type(usrs)=="table"and next(usrs)then rxKeys[#rxKeys+1]=em end end
tsort(rxKeys)if#rxKeys>0 then local rxHolder=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BackgroundTransparency=1,LayoutOrder=7,},card)
mk("UIListLayout",{FillDirection=fdH,Wraps=true,Padding=u1(0,4),SortOrder=soLO,VerticalAlignment=vaC},rxHolder)for rxi,em in ipairs(rxKeys)do local n=0 for _ in pairs(rxMap[em])do n=n+1 end
local mine=rxMap[em][P.username]==true F.makeReactionPill(rxHolder,em,n,mine,rxi,function()F.doScriptReact(sc,em)end)end end end end function F.rebuildFeed(keepScroll)
local savedCanvas=keepScroll and U.scroll.CanvasPosition or nil for _,c in ipairs(U.scroll:GetChildren())do if c:IsA("GuiObject")then pcall(function()c:Destroy()end)end end
S.frames,S.frameQ,S.rxHolders,S.holdState,S.tapAt={},{},{},{},{}F.pruneThemeReg()if S.chan=="scripts"then F.renderScriptForum()if savedCanvas then
task.defer(function()if U.scroll.Parent then U.scroll.CanvasPosition=savedCanvas end end)end return end if S.chan=="announce"and not F.canAnnounce(P.username)then
local aHdr=mk("Frame",{Size=u2(1,-4,0,0),AutomaticSize=asY,BorderSizePixel=0,LayoutOrder=-10},U.scroll)th(aHdr,"BackgroundColor3","bg2",true);corner(aHdr,10);pad(aHdr,8,6,8,6)
lab(aHdr,T("announce_ro"),{wrap=true,auto=true,ts=10,key="warn",align=txC})end local items={}for _,id in ipairs(S.order)do local m=S.msgs[id]if m then
if not m.deleted and F.visibleIn(m,S.chan)and F.matchSearch(m)then items[#items+1]=m end else local p=S.polls[id]if p and p.chan==S.chan and S.search==""then items[#items+1]=p end end end
for i=max(1,#items-CFG.MAX_RENDER+1),#items do local it=items[i]if it.isPoll then F.renderPoll(it)else F.renderMessage(it)end end if savedCanvas then
task.defer(function()if U.scroll.Parent then U.scroll.CanvasPosition=savedCanvas end end)else F.scrollBottom()end end for _,p in pairs(S.polls)do p.isPoll=true;p.votes=type(p.votes)=="table"and p.votes or{}end
function F.pollCounts(p)local counts,voters={},0 for _,ch in pairs(p.votes)do local any=false for idx in pairs(ch)do counts[idx]=(counts[idx]or 0)+1;any=true end if any then voters=voters+1 end end return counts,voters
end function F.renderPoll(p)if S.frames[p.id]then F.dropFrame(p.id)end local frame=mk("Frame",{Size=u2(1,-4,0,0),AutomaticSize=asY,BorderSizePixel=0,LayoutOrder=p.order or 0},U.scroll)
th(frame,"BackgroundColor3","bg2",true);corner(frame,8);stroke(frame,"accent",1,0.6);pad(frame,8,6,8,6);list(frame,4)S.frames[p.id]=frame tinsert(S.frameQ,p.id)
lab(frame,"📊 "..F.disp(p.q),{bold=true,wrap=true,auto=true,ts=13,layout=1})local counts,voters=F.pollCounts(p)local mine=p.votes[P.username]or{}local closed=p.closed or(tonumber(p.exp)and p.exp>0 and p.exp<=H.now())
for i,o in ipairs(p.o)do local c=counts[i]or 0 local frac=voters>0 and c/voters or 0
local b=mk("TextButton",{Size=u2(1,0,0,28),Text="",BorderSizePixel=0,ClipsDescendants=true,LayoutOrder=1+i,AutoButtonColor=not closed},frame)th(b,"BackgroundColor3","bg3");corner(b,7)
local fill=mk("Frame",{Size=u2(frac,0,1,0),BorderSizePixel=0,BackgroundTransparency=0.6},b)th(fill,"BackgroundColor3","accent")
lab(b,(mine[i]and"[x] "or"")..F.disp(o),{size=u2(1,-60,1,0),pos=uo(8,0),trunc=true,bold=mine[i]==true})lab(b,c.." · "..floor(frac*100+0.5).."%",{size=uo(56,28),pos=u2(1,-60,0,0),ts=10,key="muted",align=txR})
hook(b.MouseButton1Click,function()if not closed then F.votePoll(p,i)end end)end local foot=row(frame,22);foot.LayoutOrder=99
lab(foot,F.disp(p.author or"?").." · "..voters.." "..(L=="en"and"votes"or"phiếu")..(closed and(" · "..T("closed"))or"")..(p.multi and(" · "..T("poll_multi"))or""),{size=u2(1,-90,1,0),ts=10,key="muted",trunc=true})
if not closed and(p.author==P.username or F.isAdmin(P.username))then local cb=tbtn(foot,T("poll_close"),{size=uo(84,20),ts=10,key="danger",r=6})hook(cb.MouseButton1Click,function()
p.closed=true;F.renderPoll(p);S.isDirty=true F.publish({type="poll_close",pollId=p.id,closer=P.username,chan=p.chan})end)end end function F.votePoll(p,idx)if F.muted(P.username)then F.toast(T("muted"),true);return end
local mine=p.votes[P.username]or{}p.votes[P.username]=mine local add=not mine[idx]if add and not p.multi then for k in pairs(mine)do mine[k]=nil
F.publish({type="poll_vote",pollId=p.id,choice=k,voter=P.username,action="remove",chan=p.chan})end end mine[idx]=add and true or nil S.isDirty=true F.renderPoll(p)
F.publish({type="poll_vote",pollId=p.id,choice=idx,voter=P.username,action=add and"add"or"remove",chan=p.chan})end function F.openPoll()if tostring(S.chan):sub(1,3)=="dm:"then F.toast(T("no_poll_dm"),true);return end
local scr=F.modalBox(T("poll"),340,420)local q=field(scr,T("poll_q"),"")local opts={}for i=1,5 do opts[i]=field(scr,(L=="en"and"Option "or"Lựa chọn ")..i,"")end local multi=false
F.switch(scr,T("poll_multi"),function()return multi end,function(v)multi=v end)local go=tbtn(scr,T("poll_create"),{key="accent",h=34})hook(go.MouseButton1Click,function()local o={}
for _,b in ipairs(opts)do local t=H.trim(b.Text);if t~=""then o[#o+1]=H.clip(t,60)end end local qt=H.trim(q.Text)if qt==""or#o<2 then return end local id=H.uuid()S.orderN=S.orderN+1
local p={id=id,isPoll=true,q=H.clip(qt,120),o=o,multi=multi,author=P.username,chan=S.chan,votes={},order=S.orderN,ts=H.now()}S.polls[id]=p;tinsert(S.order,id);S.isDirty=true
F.closeModal();F.renderPoll(p);F.scrollBottom()F.publish({type="poll",packetId=id,pollId=id,question=p.q,options=o,multi=multi,author=P.username,chan=S.chan})end)end function F.heartbeat(off)
local body={u=P.username,d=P.display,id=P.userId,st=P.status,bio=P.bio,c=P.country,sg=P.showGame,pl=game.PlaceId,gn=S.placeName,jb=game.JobId,off=off and true or nil}
enqueue("other","POST","/api/presence",body,function(data,err)if data and data.ok then F.ingestPresence(data)end end)end function F.ingestPresence(data)local now=os.clock()for _,u in ipairs(data.users or{})do
local rec=S.users[u.u]or{}rec.display,rec.userId,rec.status,rec.bio,rec.country=u.d,tonumber(u.id)or 1,u.st or"",u.bio or"",u.c or"??"
rec.inGame,rec.placeId,rec.gameName,rec.jobId=u.sg==true,tonumber(u.pl)or 0,u.gn or"",u.jb or""rec.age=(tonumber(data.now)or 0)-(tonumber(u.ts)or 0)rec.recvAt=now rec.isScript=true S.users[u.u]=rec end
if type(data.mute)=="table"then F.applyMute(P.username,{on=true,reason=data.mute.reason or"",exp=tonumber(data.mute.exp)or 0,by=data.mute.by or""})end if type(data.banned)=="table"then S.banned=data.banned end
F.updateInfo()end function F.liveUsers()local out={}for u,r in pairs(S.users)do if F.isLive(r)then out[#out+1]=u end end
tsort(out,function(a,b)return tostring(S.users[a].display or a):lower()<tostring(S.users[b].display or b):lower()end)return out end function F.userRow(parent,u,o)o=o or{}local rec=S.users[u]or{}
local b=mk("TextButton",{Size=u2(1,0,0,38),Text="",BorderSizePixel=0,AutoButtonColor=true,LayoutOrder=o.layout or 0},parent)th(b,"BackgroundColor3","bg3");corner(b,8)
local av=mk("ImageLabel",{Size=uo(28,28),Position=uo(6,5),BackgroundTransparency=1,Image=F.avatarUrl(F.uidOf(u)),BorderSizePixel=0},b)corner(av,14)
local dot=mk("Frame",{Size=uo(9,9),Position=uo(26,26),BorderSizePixel=0},b)corner(dot,5);themed(dot,function(x)x.BackgroundColor3=(u==P.username or F.isLive(rec))and TH.ok or TH.muted end)local top=F.topRole(u)
local nm=lab(b,F.disp(rec.display or u),{size=u2(1,-(o.right or 60)-44,0,17),pos=uo(40,3),bold=true,trunc=true})if top then nm.TextColor3=H.hex(top.color)end local sub="@"..u
if o.sub then sub=o.sub elseif rec.status and rec.status~=""then sub=sub.." · "..rec.status end lab(b,F.disp(sub),{size=u2(1,-(o.right or 60)-44,0,14),pos=uo(40,20),ts=10,key="muted",trunc=true})
if o.click then hook(b.MouseButton1Click,function()o.click(u)end)end return b end function F.openOnline()local scr=F.modalBox(T("users"),350,440)
lab(scr,T("delta_tp_short"),{wrap=true,auto=true,ts=10,key="warn",layout=0})local live=F.liveUsers()if#live==0 then lab(scr,T("off"),{key="muted"})end
for i,u in ipairs(live)do F.userRow(scr,u,{layout=i,click=function(x)F.openProfile(x)end})end end function F.openDM(u)if u==P.username then return end P.dmList[u]=H.now();S.isDirty=true F.closeModal()
F.selectChannel(F.dmChan(P.username,u))end function F.openDMList()local scr=F.modalBox(T("dm"),340,420)local names={}for u in pairs(P.dmList)do names[#names+1]=u end
tsort(names,function(a,b)return(P.dmList[a]or 0)>(P.dmList[b]or 0)end)local nb=tbtn(scr,"+ "..T("pick_user"),{key="accent",h=32})
hook(nb.MouseButton1Click,function()F.pickUser({title=T("dm"),onPick=function(u)F.openDM(u)end})end)if#names==0 then lab(scr,T("no_dm"),{wrap=true,auto=true,key="muted"})end for i,u in ipairs(names)do
local un=S.dmUnread[F.dmChan(P.username,u)]or 0 F.userRow(scr,u,{layout=i+1,sub=un>0 and("• "..un.." "..T("jump_new"))or nil,click=function(x)F.openDM(x)end})end end function F.openProfile(u)if not u then return end
local rec=S.users[u]or{}local me=u==P.username local isDevU=F.isDev(u)local rlist=F.userRoles(u)local top=rlist[1]local accent=(top and H.hex(top.color))or(isDevU and H.hex(F.DEVROLE.color))or TH.accent
local scr=F.modalBox(T("profile"),380,560)local hd=mk("Frame",{Size=u2(1,0,0,116),BorderSizePixel=0},scr)th(hd,"BackgroundColor3","bg3");corner(hd,12)
local banner=mk("Frame",{Size=u2(1,0,0,56),BorderSizePixel=0,ZIndex=1},hd)banner.BackgroundColor3=accent corner(banner,12)local grad=mk("UIGradient",{Color=ColorSequence.new({ColorSequenceKeypoint.new(0,accent),
ColorSequenceKeypoint.new(0.5,H.mix(accent,c3(0,0,0),0.3)),ColorSequenceKeypoint.new(1,H.mix(accent,c3(1,1,1),0.15)),}),Rotation=25,},banner)
local mask=mk("Frame",{Size=u2(1,0,0,30),Position=u2(0,0,0,26),BorderSizePixel=0,ZIndex=2},hd);th(mask,"BackgroundColor3","bg3")corner(mask,12)local avFrame=mk("Frame",{Size=uo(76,76),Position=uo(16,20),
BackgroundColor3=TH.bg3,BorderSizePixel=0,ZIndex=5,},hd)corner(avFrame,38)local av=mk("ImageLabel",{Size=us(1,1),BackgroundTransparency=1,Image=F.avatarUrl(F.uidOf(u)),BorderSizePixel=0,ZIndex=6,},avFrame)
corner(av,38)local avStroke=mk("UIStroke",{Color=accent,Thickness=3,Transparency=0.1,ApplyStrokeMode=smBorder},avFrame)avStroke.ZIndex=7 local cc=(me and P.country)or rec.country or""if cc~=""and cc~="??"then
local flg=mk("TextLabel",{Size=uo(24,24),Position=u2(1,-22,1,-22),BackgroundColor3=TH.bg3,Text=H.flag(cc),Font=fGB,TextSize=14,BorderSizePixel=0,ZIndex=8,},avFrame)corner(flg,12)end local nameX=104
local nm=lab(hd,F.disp(me and P.display or rec.display or u),{size=u2(1,-(nameX+16),0,24),pos=uo(nameX,52),bold=true,ts=18,trunc=true,})nm.TextColor3=accent lab(hd,"@"..u,{size=u2(1,-(nameX+16),0,16),
pos=uo(nameX,76),ts=12,key="muted",trunc=true,})local live=me or F.isLive(rec)local pillW=100 local pill=mk("Frame",{Size=uo(pillW,20),Position=uo(nameX,92),BackgroundColor3=live and TH.ok or TH.muted,
BackgroundTransparency=0.78,BorderSizePixel=0,ZIndex=3,},hd)corner(pill,10)local pillLbl=lab(pill,live and T("live")or T("off"),{size=us(1,1),ts=10,bold=true,align=txC,})
pillLbl.TextColor3=live and TH.ok or TH.muted local wn=S.warns[u]if wn and#wn>0 then local wp=mk("Frame",{Size=uo(90,20),Position=uo(nameX+pillW+6,92),BackgroundColor3=TH.warn,BackgroundTransparency=0.78,
BorderSizePixel=0,ZIndex=3,},hd)corner(wp,10)local wl=lab(wp,#wn.." "..T("warnings"),{size=us(1,1),ts=10,bold=true,align=txC})wl.TextColor3=TH.warn end F.section(scr,T("roles")..(isDevU and" · DEV"or""))
local rolesCard=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BackgroundTransparency=1,},scr)mk("UIListLayout",{FillDirection=fdH,Wraps=true,Padding=u1(0,6),SortOrder=soLO,
HorizontalAlignment=Enum.HorizontalAlignment.Left,VerticalAlignment=vaC,},rolesCard)local hasAny=false local order=0 if isDevU then order=order+1 F.roleChip(rolesCard,F.DEVROLE,order,true)hasAny=true end
for _,r in ipairs(rlist)do order=order+1 F.roleChip(rolesCard,r,order,true)hasAny=true end if not hasAny then lab(rolesCard,"— "..T("no_roles").." —",{size=u2(1,0,0,24),ts=11,key="muted",align=txC})end
local stt=me and P.status or rec.status or""local bio=me and P.bio or rec.bio or""if stt~=""then lab(scr,"💬  "..F.disp(stt),{wrap=true,auto=true,ts=12})end if bio~=""then
lab(scr,F.disp(bio),{wrap=true,auto=true,ts=11,key="muted"})end if rec.inGame and rec.gameName and rec.gameName~=""then local gcard=F.card(scr,0)gcard.AutomaticSize=asY gcard.Size=u2(1,0,0,0)
pad(gcard,10,8,10,8);list(gcard,4)lab(gcard,"🎮  "..T("playing")..F.disp(rec.gameName),{wrap=true,auto=true,ts=11,key="ok"})if not me and rec.placeId and rec.placeId>0 then
local jb=tbtn(gcard,T("join"),{key="ok",h=28,ts=11})lab(gcard,T("delta_tp_note"),{wrap=true,auto=true,ts=10,key="warn"})hook(jb.MouseButton1Click,function()if F.armAutoTeleport then F.armAutoTeleport()end
F.toast(T("delta_tp_note"),true)pcall(function()if rec.jobId~=""then TeleportService:TeleportToPlaceInstance(rec.placeId,rec.jobId,LP)else TeleportService:Teleport(rec.placeId,LP)end end)end)end end if me then
local edCard=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BorderSizePixel=0},scr)th(edCard,"BackgroundColor3","bg3");corner(edCard,10);pad(edCard,10,8,10,10);list(edCard,5)
lab(edCard,string.upper(T("edit_profile")),{ts=11,bold=true,key="accent"})local fn=field(edCard,T("name"),P.display)local fs=field(edCard,T("status"),P.status)fs.PlaceholderText=T("status_ph")
lab(edCard,T("quick_status"),{ts=10,key="muted",bold=true})local stRow=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BackgroundTransparency=1},edCard)
mk("UIListLayout",{FillDirection=fdH,Wraps=true,Padding=u1(0,4),SortOrder=soLO},stRow)for idx,preset in ipairs({"🎮 Gaming","💻 Coding","AFK","🔥 Busy","X"})do
local sb=tbtn(stRow,preset,{size=uo(preset=="X"and 28 or 72,22),ts=10,key="bg2",r=11,layout=idx})hook(sb.MouseButton1Click,function()fs.Text=preset=="X"and""or preset end)end local fb=field(edCard,T("bio"),P.bio,true)
fb.PlaceholderText=T("bio_ph")local fc=field(edCard,T("country"),P.country)lab(edCard,T("quick_country"),{ts=10,key="muted",bold=true})
local ccRow=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BackgroundTransparency=1},edCard)mk("UIListLayout",{FillDirection=fdH,Wraps=true,Padding=u1(0,4),SortOrder=soLO},ccRow)
for idx,ccode in ipairs({"VN","US","JP","KR","GB","SG","??"})do local cb=tbtn(ccRow,H.flag(ccode).." "..ccode,{size=uo(46,22),ts=10,key="bg2",r=11,layout=idx})hook(cb.MouseButton1Click,function()fc.Text=ccode end)end
local sv=tbtn(edCard,T("save_profile"),{key="accent",h=32,ts=12})hook(sv.MouseButton1Click,function()P.display=H.clip(H.trim(fn.Text)~=""and H.trim(fn.Text)or LP.DisplayName,40)
P.status,P.bio=H.clip(H.trim(fs.Text),80),H.clip(H.trim(fb.Text),180)local c=H.trim(fc.Text):upper():sub(1,2)P.country=#c==2 and c or"??"S.isDirty=true;F.heartbeat(false);F.toast(T("saved_ok"),true)
F.openProfile(P.username)end)local r1=row(scr,32)local rqB=rbtn(r1,T("request_title"),{key="accent"});hook(rqB.MouseButton1Click,function()F.openRequest()end)
local eb=rbtn(r1,T("settings"));hook(eb.MouseButton1Click,function()F.openSettings()end)return end F.section(scr,T("actions"))local ar=row(scr,32)
local d=rbtn(ar,T("dm"),{key="accent"});hook(d.MouseButton1Click,function()F.openDM(u)end)local rp=rbtn(ar,T("report"),{key="warn"});hook(rp.MouseButton1Click,function()F.openReport(u)end)
if F.canAct(P.username,u)then F.section(scr,T("admin"))local r2=row(scr,32)local m1=rbtn(r2,T("mute"),{key="danger"});hook(m1.MouseButton1Click,function()F.openMute(u)end)
local m2=rbtn(r2,T("warn"),{key="warn"});hook(m2.MouseButton1Click,function()F.openWarn(u)end)local r3=row(scr,32)
local u1=rbtn(r3,T("unmute"));hook(u1.MouseButton1Click,function()F.publish({type="unmute",by=P.username,target=u,chan="staff"});F.toast(T("saved_ok"),true)end)
local u2=rbtn(r3,T("clear_warn"));hook(u2.MouseButton1Click,function()F.publish({type="clear_warn",by=P.username,target=u,chan="staff"});S.warns[u]=nil;F.toast(T("saved_ok"),true)end)end if F.isDev(P.username)then
local ar2=row(scr,32)local rl=rbtn(ar2,T("roles"),{key="accent"});hook(rl.MouseButton1Click,function()F.openUserRoles(u)end)if#rlist>0 then local rv=rbtn(ar2,T("revoke"),{key="danger"})
hook(rv.MouseButton1Click,function()enqueue("other","POST","/api/revoke",{by=P.username,u=u},function(d2,e2)if d2 and d2.ok then if d2.roles then F.applyRoles(d2.roles,d2.seq,true)end S.assign[u]=nil;S.isDirty=true
F.toast(T("revoked"),true);F.closeModal()else F.netError(d2 and d2.error or e2)end end)end)end end end function F.resolveUser(text,cb)text=H.trim(text):gsub("^@","")task.spawn(function()local uid,name
if text:match("^%d+$")then uid=tonumber(text)local ok,n=pcall(Players.GetNameFromUserIdAsync,Players,uid)name=ok and n or nil else local ok,id=pcall(Players.GetUserIdFromNameAsync,Players,text)if ok and id then uid=id
local ok2,n=pcall(Players.GetNameFromUserIdAsync,Players,id)name=ok2 and n or text end end if name and uid then S.users[name]=S.users[name]or{display=name,userId=uid}S.users[name].userId=S.users[name].userId or uid end
cb(name and{u=name,id=uid}or nil)end)end function F.pickUser(o)local scr,close=F.popup(o.title or T("pick_user"),340,450)local q=field(scr,"","")q.PlaceholderText=T("search_user")
local box=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BackgroundTransparency=1,LayoutOrder=3},scr)list(box,3)local function candidates()local seen,out={},{}
local function add(u)if u and not seen[u]then seen[u]=true;out[#out+1]=u end end add(P.username)for u in pairs(S.users)do add(u)end if o.assigned then for u in pairs(S.assign)do add(u)end end
for u in pairs(P.dmList)do add(u)end tsort(out,function(a,b)local la,lb=(a==P.username or F.isLive(S.users[a])),(b==P.username or F.isLive(S.users[b]))if la~=lb then return la end return a:lower()<b:lower()end)
return out end local function build()for _,c in ipairs(box:GetChildren())do if not c:IsA("UIListLayout")then c:Destroy()end end local needle=H.trim(q.Text):lower():gsub("^@","")local n,exact=0,false
for _,u in ipairs(candidates())do local rec=S.users[u]or{}if needle==""or u:lower():find(needle,1,true)or tostring(rec.display or""):lower():find(needle,1,true)then n=n+1 if n>60 then break end
if u:lower()==needle then exact=true end local rowB rowB=F.userRow(box,u,{layout=n,right=o.multi and 30 or 0,click=function(x)if o.multi then local on=not o.isOn(x)o.onToggle(x,on)
rowB:FindFirstChild("chk").Text=o.isOn(x)and"[x]"or""else close();o.onPick(x)end end})if o.multi then local c=lab(rowB,o.isOn(u)and"[x]"or"",{size=uo(24,38),pos=u2(1,-28,0,0),bold=true,ts=15,align=txC,key="ok"})
c.Name="chk"end end end if needle~=""and not exact and#needle>=3 then local fb=tbtn(box,T("roblox_find")..needle,{key="accent",h=32,layout=999})hook(fb.MouseButton1Click,function()fb.Text="…"
F.resolveUser(needle,function(r)if not r then if fb.Parent then fb.Text=T("not_found")end return end if o.multi then o.onToggle(r.u,true);if box.Parent then build()end else close();o.onPick(r.u)end end)end)end end
hook(q:GetPropertyChangedSignal("Text"),build)build()end function F.userField(parent,label,value)lab(parent,label,{h=14,ts=10,bold=true,key="muted"})
local r=mk("Frame",{Size=u2(1,0,0,28),BackgroundTransparency=1},parent)local b=mk("TextBox",{Size=u2(1,-34,1,0),Text=value or"",ClearTextOnFocus=false,Font=fG,TextSize=12,BorderSizePixel=0,TextXAlignment=txL},r)
th(b,"BackgroundColor3","bg3");th(b,"TextColor3","text");corner(b,7);pad(b,8,0,8,0)local p=tbtn(r,"@",{size=uo(30,28),pos=u2(1,-30,0,0),key="accent"})
hook(p.MouseButton1Click,function()F.pickUser({title=T("pick_user"),onPick=function(u)b.Text=u end})end)return b end function F.recentBy(user,n)local out={}for i=#S.order,1,-1 do local m=S.msgs[S.order[i]]
if m and m.author==user and not m.deleted then tinsert(out,1,{author=m.author,content=H.clip(F.plain(m.content),100)})if#out>=n then break end end end return out end function F.openReport(target,msg)
local scr=F.modalBox(T("report"),340,420)local tg=F.userField(scr,T("target"),target or"")local rs=field(scr,T("reason"),"",true)local pub=true
F.switch(scr,T("is_public"),function()return pub end,function(v)pub=v end)local go=tbtn(scr,T("report"),{key="warn",h=34})hook(go.MouseButton1Click,function()local t,r=H.trim(tg.Text),H.trim(rs.Text)
if t==""or r==""then F.toast(T("need_reason"),true);return end local ev=F.recentBy(t,3)if msg then ev={{author=msg.author,content=H.clip(F.plain(msg.content),100)}}end
F.publish({type="report",reporter=P.username,target=t,reason=H.clip(r,300),evidence=ev,isPublic=pub,chan="staff"})F.closeModal();F.toast(T("report_sent"),true)end)end function F.openMute(target)
local scr=F.modalBox(T("mute"),340,400)local tg=F.userField(scr,T("target"),target or"")local mn=field(scr,T("minutes"),"10")local rs=field(scr,T("reason"),"",true)local go=tbtn(scr,T("mute"),{key="danger",h=34})
hook(go.MouseButton1Click,function()local t=H.trim(tg.Text)if t==""then return end if not F.canAct(P.username,t)then F.toast(T("hier"),true);return end local mins=tonumber(mn.Text)or 0
F.publish({type="mute",by=P.username,target=t,reason=H.clip(H.trim(rs.Text),200),expires_at=mins>0 and(H.now()+mins*60)or 0,chan="staff"})F.closeModal();F.toast(T("mute_sent"),true)end)end function F.openWarn(target)
local scr=F.modalBox(T("warn"),340,340)local tg=F.userField(scr,T("target"),target or"")local rs=field(scr,T("reason"),"",true)local go=tbtn(scr,T("warn"),{key="warn",h=34})hook(go.MouseButton1Click,function()
local t,r=H.trim(tg.Text),H.trim(rs.Text)if t==""or r==""then F.toast(T("need_reason"),true);return end if not F.canAct(P.username,t)then F.toast(T("hier"),true);return end
F.publish({type="warn",by=P.username,target=t,reason=H.clip(r,200),chan="staff"})F.closeModal();F.toast(T("warn_sent"),true)end)end function F.openAdmin()
if not F.isStaff(P.username)then F.toast(T("staff_only"),true);return end local scr=F.modalBox(T("admin"),400,540)local r1=row(scr,30)
local b1=rbtn(r1,T("mute").."…",{key="danger"});hook(b1.MouseButton1Click,function()F.openMute("")end)local b2=rbtn(r1,T("warn").."…",{key="warn"});hook(b2.MouseButton1Click,function()F.openWarn("")end)
if F.isDev(P.username)then local rb=tbtn(scr,T("roles"),{key="accent",h=30})hook(rb.MouseButton1Click,function()F.openRoles()end)local ub=tbtn(scr,T("requests").." (Refresh)",{h=28,ts=11})
hook(ub.MouseButton1Click,function()enqueue("other","GET","/api/requests?by="..H.url(P.username),nil,function(d)if d and d.ok then S.requests=d.requests or{}S.bannedList=d.banned or{}F.toast("Refreshed",true);F.openAdmin()
else F.netError(d and d.error or"network")end end)end)end F.section(scr,T("requests"))local pending=S.requests or{}if#pending==0 then lab(scr,T("no_requests"),{key="muted"})else for i,rq in ipairs(pending)do
local c=F.card(scr,0);c.AutomaticSize=asY;c.Size=u2(1,0,0,0)pad(c,8,6,8,6);list(c,3);c.LayoutOrder=i lab(c,"👤 "..F.disp(rq.u).."  ·  "..H.shortTime(rq.ts),{bold=true,ts=12,trunc=true})local rn=rq.role
for _,r in ipairs(S.roles)do if r.id==rq.role then rn=r.name;break end end lab(c,"-> "..F.disp(tostring(rn))..(rq.reason~=""and("  ·  "..F.disp(rq.reason))or""),{ts=11,key="muted",wrap=true,auto=true})local rr=row(c,28)
local ap=rbtn(rr,T("approve"),{key="ok",ts=11,size=u2(0.32,-2,1,0)})hook(ap.MouseButton1Click,function()enqueue("other","POST","/api/approve",{by=P.username,u=rq.u,role=rq.role,action="approve"},function(d,e)
if d and d.ok then if d.roles then F.applyRoles(d.roles,d.seq,true)end for k,v in ipairs(S.requests)do if v.u==rq.u then tremove(S.requests,k);break end end F.toast(T("approve"),true);F.openAdmin()
else F.netError(d and d.error or e)end end)end)local rj=rbtn(rr,T("reject"),{ts=11,size=u2(0.32,-2,1,0)})hook(rj.MouseButton1Click,function()
enqueue("other","POST","/api/approve",{by=P.username,u=rq.u,action="reject"},function(d,e)if d and d.ok then for k,v in ipairs(S.requests)do if v.u==rq.u then tremove(S.requests,k);break end end
F.toast(T("dismiss"),true);F.openAdmin()else F.netError(d and d.error or e)end end)end)local bn=rbtn(rr,T("ban"),{key="danger",ts=11,size=u2(0.32,-2,1,0)})hook(bn.MouseButton1Click,function()
enqueue("other","POST","/api/approve",{by=P.username,u=rq.u,action="ban"},function(d,e)if d and d.ok then for k,v in ipairs(S.requests)do if v.u==rq.u then tremove(S.requests,k);break end end
F.toast(T("ban"),true);F.openAdmin()else F.netError(d and d.error or e)end end)end)end end if F.isDev(P.username)and#(S.bannedList or{})>0 then F.section(scr,T("banned_list").." ("..#S.bannedList..")")
for i,bn in ipairs(S.bannedList)do local c=F.card(scr,0);c.AutomaticSize=asY;c.Size=u2(1,0,0,0)pad(c,8,6,8,6);list(c,3)
lab(c,F.disp(bn.u)..(bn.reason~=""and("  ·  "..F.disp(bn.reason))or""),{bold=true,ts=12,trunc=true,key="danger"})local rr=row(c,26)local un=rbtn(rr,T("unban"),{key="ok",ts=11})
hook(un.MouseButton1Click,function()enqueue("other","POST","/api/unban",{by=P.username,u=bn.u},function(d,e)if d and d.ok then tremove(S.bannedList,i);S.bannedList={}F.toast(T("unbanned"),true);F.openAdmin()
else F.netError(d and d.error or e)end end)end)local pf=rbtn(rr,T("profile"),{ts=11})hook(pf.MouseButton1Click,function()F.openProfile(bn.u)end)end end F.section(scr,T("reports"))
if#S.reports==0 then lab(scr,T("no_reports"),{key="muted"})end for i=#S.reports,max(1,#S.reports-20),-1 do local rp=S.reports[i]local c=F.card(scr,0);c.AutomaticSize=asY;c.Size=u2(1,0,0,0);pad(c,8,6,8,6);list(c,3)
lab(c,(rp.isPublic and""or"🔒 ")..F.disp(rp.reporter).." -> "..F.disp(rp.target).."  ·  "..H.shortTime(rp.ts),{bold=true,ts=11,trunc=true})lab(c,F.disp(rp.reason),{wrap=true,auto=true,ts=11})
for _,e in ipairs(rp.evidence or{})do lab(c,"› "..F.disp(e.author)..": "..F.disp(e.content),{wrap=true,auto=true,ts=10,key="muted"})end local rr=row(c,26)
local pf=rbtn(rr,T("profile"),{ts=11});hook(pf.MouseButton1Click,function()F.openProfile(rp.target)end)local ak=rbtn(rr,T("dismiss"),{ts=11})hook(ak.MouseButton1Click,function()tremove(S.reports,i);S.isDirty=true
F.publish({type="report_ack",admin=P.username,target=rp.reporter,chan="staff"})F.openAdmin()end)end end
F.ROLE_COLORS={"#F04747","#E67E22","#F1C40F","#2ECC71","#1ABC9C","#3498DB","#5865F2","#9B59B6","#E91E63","#95A5A6","#FFFFFF","#FAA81A"}F.ROLE_ICONS={"👑","🌟","🔰","🔧","💎","🔥","🏆","🚀","🎮","💬","💖","💯"}F.ROLE_TEMPLATES={
{name="Owner",color="#F1C40F",icon="👑",isAdmin=true,mentionAll=true,canAnnounce=true},{name="Admin",color="#E74C3C",icon="🔰",isAdmin=true,mentionAll=true,canAnnounce=true},
{name="Mod",color="#3498DB",icon="🔧",isAdmin=true,mentionAll=false,canAnnounce=true},{name="Tester",color="#1ABC9C",icon="💎",isAdmin=false,mentionAll=false,canAnnounce=true},
{name="VIP",color="#9B59B6",icon="💎",isAdmin=false,mentionAll=false,canAnnounce=false},{name="Member",color="#2ECC71",icon="",isAdmin=false,mentionAll=false,canAnnounce=false},}function F.sortedRoles()local l={}
for _,r in ipairs(S.roles)do l[#l+1]=r end tsort(l,function(a,b)if a.position~=b.position then return a.position>b.position end return a.id<b.id end)return l end function F.roleMembers(r)local n=0
for _,set in pairs(S.assign)do if set[r.id]then n=n+1 end end return n end function F.moveRole(r,dir)local l=F.sortedRoles()local idx for i,x in ipairs(l)do if x==r then idx=i end end local j=idx and idx+dir
if not j or j<1 or j>#l then return end l[idx],l[j]=l[j],l[idx]for i,x in ipairs(l)do x.position=(#l-i+1)*10 end F.invalidateRoleCache()S.isDirty=true;F.queueRoles()end function F.openRoles(keep)
if not F.isDev(P.username)then F.toast(T("no_perm"),true);return end local scr=F.modalBox(T("roles"),400,580)local r1=row(scr,32)
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
if keep then task.defer(function()if scr.Parent then scr.CanvasPosition=keep end end)end end function F.openMembers(r)F.pickUser({title=F.disp(r.name).." · "..T("members"),multi=true,assigned=true,
isOn=function(u)return F.hasRole(u,r.id)end,onToggle=function(u,on)F.setRole(u,r.id,on)S.isDirty=true;F.queueRoles()end,})end function F.openUserRoles(u)local scr=F.popup(F.disp(u).." · "..T("roles"),320,400)
local l=F.sortedRoles()if#l==0 then lab(scr,T("no_roles"),{wrap=true,auto=true,key="muted"})end for i,r in ipairs(l)do local b=mk("TextButton",{Size=u2(1,0,0,36),Text="",BorderSizePixel=0,LayoutOrder=i},scr)
th(b,"BackgroundColor3","bg3");corner(b,8)F.roleChip(b,r,0,true).Position=uo(8,8)local ck=lab(b,"",{size=uo(28,36),pos=u2(1,-34,0,0),bold=true,ts=16,align=txC,key="ok"})
local function paint()ck.Text=F.hasRole(u,r.id)and"[x]"or""end paint()hook(b.MouseButton1Click,function()F.setRole(u,r.id,not F.hasRole(u,r.id))S.isDirty=true;paint();F.queueRoles()end)end end
function F.openRoleEditor(role)local isNew=role==nil
local d=role and{name=role.name,color=role.color,icon=role.icon or"",position=role.position,isAdmin=role.isAdmin,mentionAll=role.mentionAll,canAnnounce=role.canAnnounce==true}
or{name="",color="#5865F2",icon="",position=F.nextPosition(),isAdmin=false,mentionAll=false,canAnnounce=false}local scr=F.modalBox(isNew and T("role_new")or T("role_edit"),400,620)local pv=F.card(scr,40)
local pvRow=mk("Frame",{Size=u2(1,-16,1,0),Position=uo(8,0),BackgroundTransparency=1},pv)mk("UIListLayout",{FillDirection=fdH,Padding=u1(0,6),SortOrder=soLO,VerticalAlignment=vaC},pvRow)local function refreshPv()
for _,c in ipairs(pvRow:GetChildren())do if not c:IsA("UIListLayout")then c:Destroy()end end
mk("TextLabel",{AutomaticSize=asX,Size=uo(0,20),BackgroundTransparency=1,Text="Alice",Font=fGB,TextSize=13,TextColor3=H.hex(d.color),LayoutOrder=1,BorderSizePixel=0},pvRow)
F.roleChip(pvRow,{name=d.name~=""and d.name or"Role",color=d.color,icon=d.icon},2,true)end refreshPv()local nameBox=field(scr,T("role_name"),d.name)
hook(nameBox:GetPropertyChangedSignal("Text"),function()d.name=H.clip(nameBox.Text,24);refreshPv()end)lab(scr,T("role_color"),{h=14,ts=10,bold=true,key="muted"})
local pal=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BackgroundTransparency=1},scr)mk("UIGridLayout",{CellSize=uo(30,30),CellPadding=uo(5,5),SortOrder=soLO},pal)local pk for i,hx in ipairs(F.ROLE_COLORS)do
local b=mk("TextButton",{Text="",BackgroundColor3=H.hex(hx),BorderSizePixel=0,LayoutOrder=i},pal)corner(b,15);stroke(b,"muted",1,0.7)
hook(b.MouseButton1Click,function()d.color=hx;refreshPv();if pk then pk.set(hx)end end)end local holder=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BackgroundTransparency=1,Visible=false},scr)
local tgl=tbtn(scr,"🎨 "..T("color_palette"),{h=28,ts=11})hook(tgl.MouseButton1Click,function()if not pk then pk=F.colorPicker(holder,d.color,function(hex)d.color=hex;refreshPv()end)end holder.Visible=not holder.Visible
end)tgl.LayoutOrder=0;pal.LayoutOrder=0 lab(scr,T("role_icon"),{h=14,ts=10,bold=true,key="muted"})local ig=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BackgroundTransparency=1},scr)
mk("UIGridLayout",{CellSize=uo(34,34),CellPadding=uo(4,4),SortOrder=soLO},ig)for i,e in ipairs(F.ROLE_ICONS)do local b=tbtn(ig,e,{ts=16,r=7,layout=i})hook(b.MouseButton1Click,function()d.icon=e;refreshPv()end)end
local ir=row(scr,30)local pb=rbtn(ir,T("emoji_pick").."…",{key="accent"})hook(pb.MouseButton1Click,function()F.openEmoji({title=T("role_icon"),onPick=function(e)d.icon=e;refreshPv()end})end)
local cb=rbtn(ir,T("role_icon_clear"));hook(cb.MouseButton1Click,function()d.icon="";refreshPv()end)lab(scr,T("role_pos"),{h=14,ts=10,bold=true,key="muted"})local pr=row(scr,30)
local pl=lab(pr,tostring(d.position),{size=u2(1,-150,1,0),bold=true,ts=14,align=txC})local function stepB(txt,dv,order)local b=tbtn(pr,txt,{size=uo(34,28),layout=order,r=7})
hook(b.MouseButton1Click,function()d.position=clamp(d.position+dv,-1000,1000);pl.Text=tostring(d.position)end)end pl.LayoutOrder=3 stepB("-10",-10,1);stepB("-",-1,2);stepB("+",1,4);stepB("+10",10,5)
F.section(scr,T("role_perm"))F.switch(scr,T("role_admin"),function()return d.isAdmin end,function(v)d.isAdmin=v end)F.switch(scr,T("role_mention"),function()return d.mentionAll end,function(v)d.mentionAll=v end)
F.switch(scr,T("role_announce"),function()return d.canAnnounce end,function(v)d.canAnnounce=v end)local save=tbtn(scr,T("save"),{key="ok",h=34})hook(save.MouseButton1Click,function()local nm=H.trim(d.name)
if nm==""then F.toast(T("role_name_req"),true);return end if isNew then role={id=H.uuid():sub(1,8)};S.roles[#S.roles+1]=role end
role.name,role.color,role.icon,role.position,role.isAdmin,role.mentionAll,role.canAnnounce=nm,H.safeHex(d.color),d.icon,d.position,d.isAdmin,d.mentionAll,d.canAnnounce==true F.invalidateRoleCache()S.isDirty=true F.publishRoles()F.openRoles()end)if not isNew then
local mb=tbtn(scr,"👥 "..T("members").." ("..F.roleMembers(role)..")",{h=30})hook(mb.MouseButton1Click,function()F.openMembers(role)end)local del=tbtn(scr,T("delete"),{key="danger",h=30})local armed=false
hook(del.MouseButton1Click,function()if not armed then armed=true;del.Text=T("tap_again_del")task.delay(3,function()if del.Parent then armed=false;del.Text=T("delete")end end)return end
for i,x in ipairs(S.roles)do if x==role then tremove(S.roles,i)break end end for u,set in pairs(S.assign)do set[role.id]=nil;if not next(set)then S.assign[u]=nil end end F.invalidateRoleCache();S.isDirty=true;F.publishRoles();F.openRoles()end)
end end function F.autoContrast()local bgc=TH.bg if H.contrast(TH.text,bgc)<4.5 then P.custom.text=H.lum(bgc)<0.4 and"#F2F3F5"or"#111214"end F.computeTheme()
if H.contrast(TH.muted,bgc)<3 then P.custom.muted=H.tohex(H.mix(TH.text,bgc,0.38))end F.paintTheme();S.isDirty=true F.toast(T("contrast_done"),true)end function F.themeCode()local t={n=P.themeName,a=P.alpha,c={}}
for k,v in pairs(P.custom)do t.c[k]=v end return"CBT1:"..H.jenc(t)end function F.importTheme(code)local j=H.trim(code):match("^CBT1:(.+)$")local d=j and H.jdec(j)if type(d)~="table"then return false end
if THEMES[d.n]then P.themeName=d.n end P.custom={}for k,v in pairs(type(d.c)=="table"and d.c or{})do if(THEMES.dark[k]or k=="mentionText"or k=="emojiText")and tostring(v):match("^#%x%x%x%x%x%x$")then P.custom[k]=v end end
P.alpha=clamp(tonumber(d.a)or 0,0,0.85)F.paintTheme();S.isDirty=true return true end function F.openTheme()local scr=F.modalBox(T("theme"),400,640)F.section(scr,T("preview"))
local pv=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BorderSizePixel=0},scr)th(pv,"BackgroundColor3","bg",true);corner(pv,10);pad(pv,8,8,8,8);list(pv,4)local function sample(who,text,key,order)
local f=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BorderSizePixel=0,LayoutOrder=order},pv)th(f,"BackgroundColor3",key);corner(f,8);pad(f,8,4,8,4)lab(f,who.."  "..text,{ts=12,wrap=true,auto=true})end
sample("Alice",T("sample_hi"),"bg2",1)sample(T("you"),T("sample_reply"),"own",2)sample("Bob","@"..P.username..T("sample_ping"),"mention",3)local chipsR=row(pv,26);chipsR.LayoutOrder=4
tbtn(chipsR,"Accent",{size=u2(0.25,-5,1,0),key="accent",ts=11})tbtn(chipsR,"OK",{size=u2(0.25,-5,1,0),key="ok",ts=11})tbtn(chipsR,"Warn",{size=u2(0.25,-5,1,0),key="warn",ts=11})
tbtn(chipsR,"Danger",{size=u2(0.25,-5,1,0),key="danger",ts=11})F.section(scr,T("preset"))local pg=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BackgroundTransparency=1},scr)
mk("UIGridLayout",{CellSize=u2(1/3,-4,0,46),CellPadding=uo(5,5),SortOrder=soLO},pg)local selStrokes,rows={},{}local function paintSel()for n,s in pairs(selStrokes)do s.Transparency=(n==P.themeName)and 0 or 1 end end
local function refreshRows()F.computeTheme()for k,r in pairs(rows)do r.sw.BackgroundColor3=TH[k];r.hx.Text=H.tohex(TH[k])r.reset.Visible=P.custom[k]~=nil end end for i,name in ipairs(THEME_ORDER)do
local t=THEMES[name]local b=mk("TextButton",{Text="",BackgroundColor3=H.hex(t.bg2),BorderSizePixel=0,LayoutOrder=i,AutoButtonColor=true},pg)corner(b,8)
local s=mk("UIStroke",{Color=H.hex(t.accent),Thickness=2,Transparency=1,ApplyStrokeMode=smBorder},b)selStrokes[name]=s for j,k in ipairs({"bg","accent","text"})do
local sq=mk("Frame",{Size=uo(12,12),Position=uo(6+(j-1)*15,6),BackgroundColor3=H.hex(t[k]),BorderSizePixel=0},b)corner(sq,6)end
mk("TextLabel",{Size=u2(1,-8,0,18),Position=uo(6,24),BackgroundTransparency=1,Text=name,Font=fGB,TextSize=11,TextColor3=H.hex(t.text),TextXAlignment=txL,BorderSizePixel=0},b)
hook(b.MouseButton1Click,function()P.themeName=name;P.custom={};F.paintTheme();S.isDirty=true;paintSel();refreshRows()end)end paintSel()
F.slider(scr,T("alpha"),0,85,floor(P.alpha*100+0.5),{step=1,fmt=function(v)return v.."%"end,onChange=function(v)P.alpha=v/100;F.paintTheme()end,onDone=function()S.isDirty=true end})F.section(scr,T("accent_quick"))
local ag=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BackgroundTransparency=1},scr)mk("UIGridLayout",{CellSize=uo(34,30),CellPadding=uo(5,5),SortOrder=soLO},ag)for i,hx in ipairs(ACCENTS)do
local b=mk("TextButton",{Text="",BackgroundColor3=H.hex(hx),BorderSizePixel=0,LayoutOrder=i},ag)corner(b,8);stroke(b,"muted",1,0.7)
hook(b.MouseButton1Click,function()P.custom.accent=hx;F.paintTheme();S.isDirty=true;refreshRows()end)end F.section(scr,T("custom_colors"))local openKey for _,g in ipairs(COLOR_GROUPS)do
lab(scr,T(g[1]),{h=14,ts=10,bold=true,key="muted"})for _,k in ipairs(g[2])do local wrap=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BackgroundTransparency=1},scr)list(wrap,4)
local head=mk("TextButton",{Size=u2(1,0,0,32),Text="",BorderSizePixel=0,LayoutOrder=1},wrap)th(head,"BackgroundColor3","bg3");corner(head,8)local sw=mk("Frame",{Size=uo(22,22),Position=uo(6,5),BorderSizePixel=0},head)
corner(sw,6);stroke(sw,"muted",1,0.5)lab(head,T("ck_"..k),{size=u2(1,-150,1,0),pos=uo(34,0),trunc=true})local hx=lab(head,"",{size=uo(70,32),pos=u2(1,-102,0,0),ts=11,key="muted",align=txR})hx.Font=fCode
local rs=tbtn(head,"R",{size=uo(24,24),pos=u2(1,-28,0,4),ts=11,key="bg2",r=6})rows[k]={sw=sw,hx=hx,reset=rs}
local holder=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BackgroundTransparency=1,Visible=false,LayoutOrder=2},wrap)local pk
hook(rs.MouseButton1Click,function()P.custom[k]=nil;F.paintTheme();S.isDirty=true;refreshRows();if pk then pk.set(H.tohex(TH[k]))end end)hook(head.MouseButton1Click,function()if not pk then
pk=F.colorPicker(holder,H.tohex(TH[k]),function(hex)P.custom[k]=hex;F.paintTheme();S.isDirty=true sw.BackgroundColor3=TH[k];hx.Text=H.tohex(TH[k]);rs.Visible=true end)end
if openKey and openKey~=holder then openKey.Visible=false end holder.Visible=not holder.Visible openKey=holder.Visible and holder or nil end)end end refreshRows()local r1=row(scr,30)
local ac=rbtn(r1,T("auto_contrast"),{ts=11});hook(ac.MouseButton1Click,function()F.autoContrast();refreshRows()end)local rr=rbtn(r1,T("reset_all"),{key="danger",ts=11})
hook(rr.MouseButton1Click,function()P.themeName="midnight";P.custom={};P.alpha=0;F.paintTheme();S.isDirty=true;F.openTheme()end)local cp=tbtn(scr,T("theme_copy"),{h=30,ts=11})
hook(cp.MouseButton1Click,function()F.copyText(F.themeCode())end)local imp=field(scr,"","")imp.PlaceholderText=T("theme_paste")local ib=tbtn(scr,T("theme_import"),{key="accent",h=30,ts=11})
hook(ib.MouseButton1Click,function()if F.importTheme(imp.Text)then F.toast(T("theme_ok"),true);F.openTheme()else F.toast(T("theme_bad"),true)end end)end function F.openRequest()
local scr=F.modalBox(T("request_title"),380,500)lab(scr,T("request_intro"),{wrap=true,auto=true,ts=11,key="muted"})if#S.roles==0 then lab(scr,T("request_none"),{wrap=true,auto=true,ts=11,key="warn"})return end
if S.myRequest then lab(scr,T("request_pending"),{ts=12,bold=true,key="warn",wrap=true,auto=true})end lab(scr,T("request_role"),{h=14,ts=10,bold=true,key="muted"})local chosen=nil
local roleGrid=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BackgroundTransparency=1},scr)list(roleGrid,4)local buttons={}local sorted=F.sortedRoles()for i,r in ipairs(sorted)do local has=F.hasRole(P.username,r.id)
local b=mk("TextButton",{Size=u2(1,0,0,36),Text="",BorderSizePixel=0,LayoutOrder=i},roleGrid)th(b,"BackgroundColor3","bg3");corner(b,8)F.roleChip(b,r,0,true).Position=uo(8,8)
local ck=lab(b,has and"[x]"or"",{size=uo(32,36),pos=u2(1,-36,0,0),bold=true,ts=12,align=txC,key="ok"})buttons[#buttons+1]={r=r,b=b,ck=ck,has=has}hook(b.MouseButton1Click,function()if has then return end chosen=r
for _,x in ipairs(buttons)do if x.has then x.b.BackgroundColor3=TH.bg3 elseif x.r==r then x.b.BackgroundColor3=TH.accent;x.ck.Text="[x]"else x.b.BackgroundColor3=TH.bg3;x.ck.Text=""end end end)end
local rs=field(scr,T("request_reason"),"",true)local go=tbtn(scr,T("request_send"),{key="accent",h=34})hook(go.MouseButton1Click,function()if not chosen then F.toast(T("select_role"),true);return end
enqueue("other","POST","/api/request",{u=P.username,role=chosen.id,reason=H.clip(H.trim(rs.Text),200)},function(d,e)if d and d.ok then S.myRequest=d.request F.toast(T("request_sent"),true);F.closeModal()
elseif d and d.error=="pending"then F.toast(T("request_pending"),true)else F.netError(d and d.error or e)end end)end)end function F.exportSettings()
local t={lang=L,display=P.display,status=P.status,bio=P.bio,country=P.country,themeName=P.themeName,custom=P.custom,alpha=P.alpha,notify=P.notify,sound=P.sound,bubble=P.bubble,safeEmoji=P.safeEmoji,showGame=P.showGame,preview=P.preview,compact=P.compact,sameUser=P.sameUser,group=P.group,textSize=P.textSize,toastPos=P.toastPos,customEmojis=P.customEmojis,recentEmoji=P.recentEmoji,dmList=P.dmList}
return"CBS1:"..H.jenc(t)end function F.importSettings(code)local j=H.trim(code):match("^CBS1:(.+)$")local d=j and H.jdec(j)if type(d)~="table"then return false end
for _,k in ipairs({"display","status","bio","country","themeName","alpha","notify","sound","bubble","safeEmoji","showGame","preview","compact","sameUser","group","textSize","toastPos"})do if d[k]~=nil then P[k]=d[k]end
end if not THEMES[P.themeName]then P.themeName="midnight"end for _,k in ipairs({"custom","customEmojis","recentEmoji","dmList"})do if type(d[k])=="table"then P[k]=d[k]end end P.alpha=clamp(tonumber(P.alpha)or 0,0,0.85)
P.textSize=clamp(tonumber(P.textSize)or 13,11,20)if d.lang=="en"or d.lang=="vi"then L=d.lang end F.paintTheme();F.layout();S.isDirty=true return true end function F.setLang(l)L=l U.bLang.Text=L=="en"and"EN"or"VI"
U.input.PlaceholderText=T("input");U.searchBox.PlaceholderText=T("search");U.sendBtn.Text=T("send")U.titleLbl.Text=T("title")S.isDirty=true F.paintTabs();F.updateInfo()
if S.booted and F.rebuildFeed then pcall(F.rebuildFeed,true)end end function F.openSettings()local scr=F.modalBox(T("settings"),420,640)
local wrap=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BackgroundTransparency=1},scr)list(wrap,6)local hd=mk("Frame",{Size=u2(1,0,0,66),BorderSizePixel=0,LayoutOrder=1},wrap)
th(hd,"BackgroundColor3","bg3");corner(hd,12)local accent=TH.accent local grad=mk("UIGradient",{Color=ColorSequence.new(TH.bg3,H.mix(TH.bg3,accent,0.15)),Rotation=15,},hd)local av=mk("ImageLabel",{Size=uo(46,46),
Position=uo(10,10),BackgroundTransparency=1,Image=F.avatarUrl(F.uidOf(P.username)),BorderSizePixel=0,ZIndex=2,},hd)corner(av,23)stroke(av,"accent",2,0.2)
lab(hd,F.disp(P.display or P.username),{size=u2(1,-140,0,20),pos=uo(66,10),bold=true,ts=15,trunc=true})
lab(hd,"@"..P.username.."  ·  "..(L=="en"and"EN"or"VI"),{size=u2(1,-140,0,14),pos=uo(66,32),ts=10,key="muted",trunc=true})local pv=tbtn(hd,T("edit_profile_btn"),{key="accent",ts=10,size=uo(86,26),r=13})
pv.Position=u2(1,-88,0.5,-13)hook(pv.MouseButton1Click,function()F.openProfile(P.username)end)local lg=tbtn(hd,L=="en"and"EN"or"VI",{ts=10,size=uo(34,24),r=12,key="bg2"})lg.Position=u2(1,-126,0.5,-12)
hook(lg.MouseButton1Click,function()F.setLang(L=="en"and"vi"or"en");F.openSettings()end)local function sectionCard(icon,title)local c=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BorderSizePixel=0},wrap)
th(c,"BackgroundColor3","bg3");corner(c,10);pad(c,10,8,10,10);list(c,5)local hdr=mk("Frame",{Size=u2(1,0,0,22),BackgroundTransparency=1},c)
local sbar=mk("Frame",{Size=uo(3,14),Position=uo(0,4),BorderSizePixel=0},hdr);th(sbar,"BackgroundColor3","accent");corner(sbar,2)
local prefix=(icon=="⚙️")and"⚙️  "or""
lab(hdr,prefix..string.upper(title),{size=u2(1,-10,1,0),pos=uo(8,0),ts=11,bold=true,key="accent"})return c end local acc=sectionCard("👤",T("sec_account"))lab(acc,T("auth_info"),{ts=11,key="muted",wrap=true,auto=true})
local rq=tbtn(acc,T("request_title"),{key="accent",h=30})hook(rq.MouseButton1Click,F.openRequest)if S.myRequest then lab(acc,T("request_pending"),{ts=11,key="warn",wrap=true,auto=true})end
local prof=sectionCard("📝",T("profile"))local fn=field(prof,T("name"),P.display)local fs=field(prof,T("status"),P.status)local fb=field(prof,T("bio"),P.bio,true)local fc=field(prof,T("country"),P.country)
local sv=tbtn(prof,T("save"),{key="accent",h=30})hook(sv.MouseButton1Click,function()P.display=H.clip(H.trim(fn.Text)~=""and H.trim(fn.Text)or LP.DisplayName,40)
P.status,P.bio=H.clip(H.trim(fs.Text),80),H.clip(H.trim(fb.Text),180)local c=H.trim(fc.Text):upper():sub(1,2)P.country=#c==2 and c or"??"S.isDirty=true;F.heartbeat(false);F.toast(T("saved_ok"),true)end)
local gen=sectionCard("⚙️",T("sec_general"))local function sw(key,tk,cb)F.switch(gen,T(tk),function()return P[key]end,function(v)P[key]=v;S.isDirty=true;if cb then cb()end end)end
sw("notify","notify");sw("sound","sound");sw("bubble","bubble")sw("safeEmoji","safe_emoji",F.rebuildFeed)sw("showGame","share",function()F.heartbeat(false)end)sw("group","group_msgs",F.rebuildFeed)
sw("preview","preview");sw("compact","compact",F.layout)sw("sameUser","same_user")local app=sectionCard("🎨",T("sec_appear"))lab(app,T("quick_theme"),{ts=10,bold=true,key="muted"})
local qThemes={{"rose",T("rose_bright")},{"sakura","Sakura"},{"mint","Mint"},{"sky","Sky"},{"lavender","Lavender"},{"midnight","Midnight"},}
local qGrid=mk("Frame",{Size=u2(1,0,0,0),AutomaticSize=asY,BackgroundTransparency=1},app)mk("UIGridLayout",{CellSize=u2(1/3,-4,0,28),CellPadding=uo(4,4),SortOrder=soLO},qGrid)for i,qt in ipairs(qThemes)do
local t=THEMES[qt[1]]local b=mk("TextButton",{Text=qt[2],Font=fGB,TextSize=10,BackgroundColor3=H.hex(t.bg2),TextColor3=H.hex(t.text),BorderSizePixel=0,LayoutOrder=i,},qGrid)corner(b,7)
mk("UIStroke",{Color=H.hex(t.accent),Thickness=P.themeName==qt[1]and 2 or 1,Transparency=P.themeName==qt[1]and 0 or 0.5,ApplyStrokeMode=smBorder},b)hook(b.MouseButton1Click,function()
P.themeName=qt[1];P.custom={};F.paintTheme();S.isDirty=true;F.openSettings()end)end local tt=tbtn(app,T("theme_studio"),{key="accent",h=32})hook(tt.MouseButton1Click,F.openTheme)
F.slider(app,T("text_size"),11,20,P.textSize,{step=1,fmt=function(v)return v.."px"end,
onChange=function(v)P.textSize=v;U.input.TextSize=v;if U.inputRich then U.inputRich.TextSize=v end;if F.updateTokenFeedback then F.updateTokenFeedback(U.input.Text)end end,
onDone=function()S.isDirty=true;F.rebuildFeed()end,})local wr=row(app,28)local function wb(txt,fnc)local b=rbtn(wr,txt,{size=u2(0.25,-4,1,0),ts=10})
hook(b.MouseButton1Click,function()fnc();S.winX=nil;F.layout();S.isDirty=true;F.closeModal()end)end wb(T("nano_cube"),function()P.W,P.H=60,60 end)wb(T("small"),function()P.W,P.H=300,400 end)
wb(T("mid"),function()P.W,P.H=IS_MOBILE and 340 or 520,IS_MOBILE and 480 or 560 end)wb(T("fit_screen"),function()local v=viewNow();P.W,P.H=v.X-12,v.Y-12 end)
local tp=tbtn(app,T("toast_pos")..": "..P.toastPos,{h=28,ts=11})hook(tp.MouseButton1Click,function()local nx={tl="tr",tr="br",br="bl",bl="tl"}P.toastPos=nx[P.toastPos]or"tr"tp.Text=T("toast_pos")..": "..P.toastPos
F.layout();S.isDirty=true end)local dat=sectionCard("💾",T("sec_data"))local dr=row(dat,28)local ex=rbtn(dr,T("backup_copy"),{ts=11})hook(ex.MouseButton1Click,function()F.copyText(F.exportSettings())end)
local cc=rbtn(dr,T("clear_cache"),{ts=11})hook(cc.MouseButton1Click,function()S.reactions,S.polls,S.warns,S.reports={},{},{},{}S.isDirty=true;F.toast(T("cache_cleared"),true)end)
local im=field(dat,"","");im.PlaceholderText=T("backup_paste")local ib=tbtn(dat,T("backup_import"),{h=28,ts=11})hook(ib.MouseButton1Click,function()
if F.importSettings(im.Text)then F.toast(T("backup_ok"),true);F.openSettings()else F.toast(T("backup_bad"),true)end end)if F.isStaff(P.username)then local dev=sectionCard("👑",T("dev_hub"))local r1=row(dev,30)
local hb=rbtn(r1,"/ "..T("help_title"),{ts=11});hook(hb.MouseButton1Click,function()F.openHelp()end)local db=rbtn(r1,T("diag"),{ts=11});hook(db.MouseButton1Click,function()F.openDiag()end)local r2=row(dev,30)
local ab=rbtn(r2,T("admin"),{key="accent",ts=11});hook(ab.MouseButton1Click,function()F.openAdmin()end)if F.isDev(P.username)then
local rb=rbtn(r2,T("roles"),{key="accent",ts=11});hook(rb.MouseButton1Click,function()F.openRoles()end)end local r3=row(dev,30)local emB=rbtn(r3,T("dev_manage_emoji"),{key="warn",ts=11})
hook(emB.MouseButton1Click,function()P.emojiTab="shared"F.openEmoji({tab="shared",title=T("dev_manage_emoji_title"),onPick=function()end})end)local scB=rbtn(r3,T("dev_manage_script"),{key="ok",ts=11})
hook(scB.MouseButton1Click,function()F.closeModal()F.selectChannel("scripts")end)else local misc=sectionCard("🔧",T("sec_dev"))local r1=row(misc,30)
local hb=rbtn(r1,"/ "..T("help_title"),{ts=11});hook(hb.MouseButton1Click,function()F.openHelp()end)local db=rbtn(r1,T("diag"),{ts=11});hook(db.MouseButton1Click,function()F.openDiag()end)end
local st=tbtn(wrap,T("stop"),{key="danger",h=34})hook(st.MouseButton1Click,function()F.stop()end)lab(wrap,"CB43.0 · "..EXEC.." · "..(S.lpOn and"long-poll"or"poll"),{ts=10,key="muted",align=txC})end
function F.openHelp()local scr=F.modalBox(T("help_title"),360,480)for i,c in ipairs(F.cmdList)do if(not c.staff or F.isStaff(P.username))and(not c.dev or F.isDev(P.username))then
local b=mk("TextButton",{Size=u2(1,0,0,40),Text="",BorderSizePixel=0,LayoutOrder=i},scr)th(b,"BackgroundColor3","bg3");corner(b,8)
lab(b,"/"..c.name..(c.arg and(" "..c.arg)or""),{size=u2(1,-12,0,18),pos=uo(10,3),bold=true,key="accent"})lab(b,T(c.desc),{size=u2(1,-12,0,16),pos=uo(10,21),ts=10,key="muted",trunc=true})
hook(b.MouseButton1Click,function()F.closeModal();U.input.Text="/"..c.name.." ";U.input:CaptureFocus()end)end end end function F.diagText()local nM,nF=0,0 for _ in pairs(S.msgs)do nM=nM+1 end
for _ in pairs(S.frames)do nF=nF+1 end return tconcat({"CB43.0 · "..EXEC.." · "..(IS_MOBILE and"mobile"or"pc"),"user: "..P.username.." ("..P.userId..")","worker: "..CFG.PROXY,
"mode: "..(S.lpOn and"long-poll"or"poll").." · fails "..S.pollFail.." · lastOk "..string.format("%.1f",os.clock()-S.lastPollOk).."s ago",
"rtt: "..(S.rtt and(floor(S.rtt).."ms")or"n/a").." · sent ok/fail: "..S.sendOk.."/"..S.sendFail,"seq: "..H.num(S.lastSeq).." · rolesSeq: "..H.num(S.rolesSeq),
"queue send/other/fast: "..#NET.lanes.send.."/"..#NET.lanes.other.."/"..#NET.lanes.fast,"msgs "..nM.." · frames "..nF.." · theme-reg "..#reg,},"\n")end function F.openDiag()local scr=F.modalBox(T("diag"),400,540)
local info=lab(scr,F.diagText(),{wrap=true,auto=true,ts=11})info.Font=fCode local hl=lab(scr,"worker: …",{wrap=true,auto=true,ts=11,key="muted"})hl.Font=fCode local function health()
enqueue("other","GET","/api/health",nil,function(d,err)if not hl.Parent then return end if d and d.ok then
hl.Text=string.format("worker %s · store=%s · online=%s · items=%s · emojis=%s · scripts=%s · up=%ss",tostring(d.build),tostring(d.store),tostring(d.online),tostring(d.items),tostring(d.emojis or 0),tostring(d.scripts or 0),tostring(d.uptime))
else hl.Text="worker: error "..tostring(err)end end)end health()if F.isDev(P.username)then F.section(scr,T("proxy_panel"))for idx,u in ipairs(PROXY_POOL)do local isCur=(u==CFG.PROXY)
local cd=NET.cooldown[u]and max(0,math.ceil(NET.cooldown[u]-os.clock()))or 0 local c=F.card(scr,28)if isCur then stroke(c,"ok",1,0.25)end local tag=idx==1 and"Main"or("Backup "..(idx-1))
lab(c,string.format("#%d [%s] %s",idx,tag,isCur and T("proxy_active")or(cd>0 and("Quota Cooldown "..cd.."s")or"Standby")),{
size=u2(1,-16,1,0),pos=uo(8,0),ts=10,bold=isCur,key=isCur and"ok"or(cd>0 and"danger"or"muted"),trunc=true,})end end local r1=row(scr,30)local pg=rbtn(r1,T("ping"),{key="accent"})hook(pg.MouseButton1Click,function()
local t0=os.clock()enqueue("other","GET","/api/ping",nil,function(d)F.toast(d and d.ok and string.format("%d ms",floor((os.clock()-t0)*1000))or"Error",true)end)end)local rs=rbtn(r1,T("resync"))
hook(rs.MouseButton1Click,function()S.lastSeq=0;S.pollFail=0;S.lpOn=CFG.LONGPOLL>0;F.toast(T("resync"),true);F.closeModal()end)local cp=tbtn(scr,T("diag_copy"),{h=30})
hook(cp.MouseButton1Click,function()F.copyText(F.diagText())end)local rf=tbtn(scr,"Refresh",{h=28})hook(rf.MouseButton1Click,function()info.Text=F.diagText();health()end)end function F.pingSound()
if not P.sound then return end pcall(function()local s=Instance.new("Sound")s.SoundId=CFG.MENTION_SOUND;s.Volume=0.6;s.Parent=SoundService s:Play();Debris:AddItem(s,3)end)end function F.findPlayerHead(author)
if not author or author==""then return nil,nil end local ln=tostring(author):lower()local targetPl=nil for _,pl in ipairs(Players:GetPlayers())do if pl.Name:lower()==ln then targetPl=pl;break end end
if not targetPl then return nil,nil end local ch=targetPl.Character if not ch then return nil,targetPl end local head=ch:FindFirstChild("Head")or ch:FindFirstChild("HumanoidRootPart")or ch.PrimaryPart
return head,targetPl end function F.billboardContainer(head)local pg=LP and LP:FindFirstChildOfClass("PlayerGui")return pg or head end function F.bubble(author,text,chan)if not P.bubble then return end
chan=tostring(chan or"general")if chan~="general"and chan~="game"then return end pcall(function()local head,pl=F.findPlayerHead(author)if not head then return end local key=pl and pl.Name or tostring(author)
local old=S.bubbles[key]if old then pcall(function()old:Destroy()end);S.bubbles[key]=nil end local segs,imgCount,hasText=F.parseInlineSegments(text)local plainTxt=F.disp(H.clip(F.plain(text),90))
if plainTxt==""and imgCount==0 then return end local n=utf8.len(plainTxt)or#plainTxt local lines=hasText and clamp(math.ceil(n/24),1,4)or 1
local bW=(not hasText and imgCount>0)and clamp(imgCount*42+20,64,180)or clamp(max(90,n*8+28+imgCount*24),100,220)local bH=(not hasText and imgCount>0)and 48 or(lines*18+(imgCount>0 and 24 or 16))
local bb=Instance.new("BillboardGui")bb.Name="CB42Bubble_"..key bb.Adornee=head bb.Size=uo(bW,bH+8)bb.StudsOffset=Vector3.new(0,3.8,0)bb.AlwaysOnTop=true bb.MaxDistance=160 bb.LightInfluence=0
bb.Parent=F.billboardContainer(head)local card=Instance.new("Frame")card.Size=u2(1,0,1,-6)card.BackgroundColor3=TH.bg2 card.BackgroundTransparency=0.06 card.BorderSizePixel=0 card.Parent=bb corner(card,10)
local topR=F.topRole(author)local strokeCol=(topR and H.hex(topR.color))or(F.isDev(author)and H.hex(F.DEVROLE.color))or TH.accent
mk("UIStroke",{Color=strokeCol,Thickness=1.5,Transparency=0.2,ApplyStrokeMode=smBorder},card)pad(card,8,5,8,5)local tail=Instance.new("Frame")tail.Size=uo(8,8)tail.Position=u2(0.5,-4,1,-10)tail.Rotation=45
tail.BackgroundColor3=strokeCol tail.BorderSizePixel=0 tail.ZIndex=0 tail.Parent=bb if imgCount==0 then local l=Instance.new("TextLabel")l.Size=us(1,1)l.BackgroundTransparency=1 l.TextColor3=TH.text l.Font=fGB
l.TextSize=12 l.TextWrapped=true l.Text=plainTxt l.ZIndex=2 l.Parent=card else local flow=Instance.new("Frame")flow.Size=us(1,1)flow.BackgroundTransparency=1 flow.ZIndex=2 flow.Parent=card mk("UIListLayout",{
FillDirection=fdH,Wraps=true,Padding=u1(0,4),HorizontalAlignment=Enum.HorizontalAlignment.Center,VerticalAlignment=vaC,SortOrder=soLO,},flow)local ord=0 local emSz=hasText and 20 or 34 for _,seg in ipairs(segs)do
if seg.kind=="text"then for w in tostring(seg.text):gmatch("%S+")do ord=ord+1 local wStr=F.disp(w)local wl=Instance.new("TextLabel")wl.Size=uo(max(6,H.textW(wStr,12,fGB)+2),18)wl.BackgroundTransparency=1
wl.TextColor3=TH.text wl.Font=fGB wl.TextSize=12 wl.Text=wStr wl.LayoutOrder=ord wl.Parent=flow end elseif seg.kind=="img"then ord=ord+1 local ic=F.iconBox(flow,"img:"..seg.id,emSz,{layout=ord})ic.ZIndex=3 end end end
S.bubbles[key]=bb task.delay(6,function()if S.bubbles[key]==bb then S.bubbles[key]=nil end pcall(function()bb:Destroy()end)end)end)end function F.addMsg(m)S.orderN=S.orderN+1 m.order=S.orderN F.link(m)
S.msgs[m.packetId]=m tinsert(S.order,m.packetId)while#S.order>CFG.MAX_MESSAGES do local old=tremove(S.order,1)local om=S.msgs[old]if om and S.lastByChan[om.chan]==om then S.lastByChan[om.chan]=nil end
S.msgs[old]=nil;S.polls[old]=nil S.reactions[old]=nil F.dropFrame(old)end end function F.process(pkt,stale)if type(pkt)~="table"or not pkt.type then return end local t,id=pkt.type,pkt.packetId
if id and F.markSeen(id)then return end local me=P.username if t=="msg"then local chan=tostring(pkt.chan or"general")if chan=="staff"and not F.isStaff(me)then return end local other=F.dmOther(chan)
if chan:sub(1,3)=="dm:"and not other then return end if not id or S.msgs[id]then return end
local m={type="msg",packetId=id,chan=chan,author=tostring(pkt.author or"?"),display=pkt.display,uid=tonumber(pkt.uid),content=tostring(pkt.content or""),ts=tonumber(pkt.ts)or H.now(),replyTo=pkt.replyTo,replyAuthor=pkt.replyAuthor,replySnippet=pkt.replySnippet,place=tonumber(pkt.place)}
if m.uid then S.uidCache=S.uidCache or{};S.uidCache[m.author]=m.uid end F.addMsg(m)if other then P.dmList[other]=P.dmList[other]or H.now()end local mine=m.author==me
if chan==S.chan and F.visibleIn(m,S.chan)and F.matchSearch(m)and U.main.Visible then local was=F.nearBottom()F.renderMessage(m)
if was or mine then F.scrollBottom()else S.newBelow=S.newBelow+1;task.defer(F.updateJump)end elseif not mine and not stale then if other then S.dmUnread[chan]=(S.dmUnread[chan]or 0)+1
elseif S.unread[chan]~=nil then S.unread[chan]=S.unread[chan]+1 end F.paintTabs()end if not mine and not stale then F.touchUser(m.author,m.uid,m.display)local ping=F.mentions(m.content)if ping or other then
local head=F.disp(m.display or m.author)local body=P.preview and(": "..F.disp(H.clip(F.plain(m.content),70)))or""
F.toast((ping and"@ "or"DM ")..head..body,false,function()U.main.Visible=true;U.mini.Visible=false;F.selectChannel(chan)end)F.pingSound()end F.bubble(m.author,m.content,chan)if not U.main.Visible then
S.miniUnread=(S.miniUnread or 0)+1 U.miniBadge.Text=tostring(min(S.miniUnread,9));U.miniBadge.Visible=true end if S.typing[chan]then S.typing[chan][m.author]=nil end end F.emit("message",m,stale)elseif t=="edit"then
local m=S.msgs[pkt.target]if m and m.author==pkt.author then m.content=tostring(pkt.content or"");m.edited=true if S.frames[m.packetId]then F.dropFrame(m.packetId);F.renderMessage(m)end end elseif t=="delete"then
local m=S.msgs[pkt.target]if m and(m.author==pkt.author or F.isAdmin(pkt.author))then m.deleted=true;F.dropFrame(m.packetId);F.onDeleted(m)end elseif t=="react"then local e=tostring(pkt.emoji or"")
if e==""then return end local hitScript=false for _,sc in ipairs(S.scripts or{})do if sc.id==pkt.target or sc.id==pkt.scriptId then sc.reactions=type(sc.reactions)=="table"and sc.reactions or{}
sc.reactions[e]=type(sc.reactions[e])=="table"and sc.reactions[e]or{}sc.reactions[e][tostring(pkt.by)]=(pkt.action~="remove")and true or nil if not next(sc.reactions[e])then sc.reactions[e]=nil end hitScript=true end
end if hitScript then S.isDirty=true if S.chan=="scripts"and U.main.Visible then F.rebuildFeed(true)end return end local map=F.reactionMap(pkt.target)map[e]=map[e]or{}
map[e][tostring(pkt.by)]=(pkt.action~="remove")and true or nil S.isDirty=true F.renderReactions(pkt.target)elseif t=="script_post"then local sid=tostring(pkt.scriptId or id or"")if sid==""then return end
for _,x in ipairs(S.scripts)do if x.id==sid then return end end local topic={id=sid,title=tostring(pkt.title or"Untitled"),tag=tostring(pkt.tag or"Universal"),desc=tostring(pkt.desc or""),
code=tostring(pkt.code or""),author=tostring(pkt.author or"?"),display=tostring(pkt.display or pkt.author or"?"),uid=tonumber(pkt.uid)or 1,placeId=tonumber(pkt.placeId)or 0,gameName=tostring(pkt.gameName or""),
ts=tonumber(pkt.ts)or H.now(),reactions=type(pkt.reactions)=="table"and pkt.reactions or{},reports={},}tinsert(S.scripts,topic)S.isDirty=true if S.chan=="scripts"and U.main.Visible then F.rebuildFeed(true)
elseif pkt.author~=me and not stale then S.unread.scripts=(S.unread.scripts or 0)+1 F.paintTabs()end elseif t=="script_del"then local delSet={}for _,did in ipairs(type(pkt.ids)=="table"and pkt.ids or{pkt.id})do
if did then delSet[tostring(did)]=true end end local keep={}for _,sc in ipairs(S.scripts or{})do if not delSet[tostring(sc.id)]then keep[#keep+1]=sc end end S.scripts=keep S.isDirty=true
if S.chan=="scripts"and U.main.Visible then F.rebuildFeed(true)end elseif t=="typing"then local chan=tostring(pkt.chan or"general")
if pkt.author~=me and not stale then F.touchUser(pkt.author);S.typing[chan]=S.typing[chan]or{};S.typing[chan][pkt.author]=os.clock()end elseif t=="poll"then local pid=tostring(pkt.pollId or id)
local chan=tostring(pkt.chan or"general")if S.polls[pid]or chan:sub(1,3)=="dm:"then return end if chan=="staff"and not F.isStaff(me)then return end S.orderN=S.orderN+1
local p={id=pid,isPoll=true,q=tostring(pkt.question or""),o=type(pkt.options)=="table"and pkt.options or{},multi=pkt.multi==true,author=tostring(pkt.author or"?"),chan=chan,votes={},order=S.orderN,ts=tonumber(pkt.ts)or H.now(),exp=tonumber(pkt.expires_at)or 0}
S.polls[pid]=p;tinsert(S.order,pid);S.isDirty=true if chan==S.chan and U.main.Visible then F.renderPoll(p);F.scrollBottom()end elseif t=="poll_vote"then local p=S.polls[tostring(pkt.pollId)]if p then
local v=tostring(pkt.voter)p.votes[v]=p.votes[v]or{}local c=tonumber(pkt.choice)if c then p.votes[v][c]=(pkt.action~="remove")and true or nil end
if not p.multi and pkt.action~="remove"then for k in pairs(p.votes[v])do if k~=c then p.votes[v][k]=nil end end end if S.frames[p.id]then F.renderPoll(p)end S.isDirty=true end elseif t=="poll_close"then
local p=S.polls[tostring(pkt.pollId)]if p and(pkt.closer==p.author or F.isAdmin(pkt.closer))then p.closed=true;if S.frames[p.id]then F.renderPoll(p)end end elseif t=="mute"then
if F.isAdmin(pkt.by)and pkt.target then F.applyMute(tostring(pkt.target),{on=true,reason=tostring(pkt.reason or""),exp=tonumber(pkt.expires_at)or 0,by=tostring(pkt.by)})end elseif t=="unmute"then
if F.isAdmin(pkt.by)and pkt.target then S.mutes[pkt.target]=nil if pkt.target==me then P.mute={on=false,reason="",exp=0,by=""};S.isDirty=true;if not stale then F.toast(T("unmute"),true)end end end elseif t=="warn"then
if F.isAdmin(pkt.by)and pkt.target then S.warns[pkt.target]=S.warns[pkt.target]or{}tinsert(S.warns[pkt.target],{reason=tostring(pkt.reason or""),by=tostring(pkt.by),ts=tonumber(pkt.ts)or H.now()})S.isDirty=true
if pkt.target==me and not stale then F.toast(T("warn")..": "..tostring(pkt.reason or""),true)end end elseif t=="clear_warn"then if F.isAdmin(pkt.by)and pkt.target then S.warns[pkt.target]=nil;S.isDirty=true end
elseif t=="report"then if F.isStaff(me)then
tinsert(S.reports,{reporter=tostring(pkt.reporter),target=tostring(pkt.target),reason=tostring(pkt.reason or""),evidence=type(pkt.evidence)=="table"and pkt.evidence or{},isPublic=pkt.isPublic==true,ts=tonumber(pkt.ts)or H.now()})
while#S.reports>60 do tremove(S.reports,1)end S.isDirty=true if not stale then F.toast(T("report")..": "..F.disp(pkt.target),false,F.openAdmin)end end elseif t=="report_ack"then
if pkt.target==me and not stale then F.toast(T("ack"),true)end elseif t=="request"then if F.isStaff(me)then local dup=false for _,r in ipairs(S.requests)do if r.u==pkt.by then dup=true end end if not dup then
tinsert(S.requests,{u=tostring(pkt.by),role=tostring(pkt.role or""),reason=tostring(pkt.reason or""),ts=tonumber(pkt.ts)or H.now()})
if not stale then F.toast(T("request_title")..": "..F.disp(pkt.by),false,F.openAdmin)end end S.isDirty=true end if pkt.by==me then S.myRequest={u=me,role=pkt.role,reason=pkt.reason,ts=pkt.ts}end
elseif t=="request_result"then if pkt.target==me and pkt.action=="approve"then S.forceRoles=true end if pkt.target==me and not stale then if pkt.action=="approve"then S.myRequest=nil
F.toast(T("approve")..(pkt.role and(": "..pkt.role)or""),true)elseif pkt.action=="reject"then S.myRequest=nil F.toast(T("reject"),true)elseif pkt.action=="ban"then S.myRequest=nil
F.toast(T("ban"),true)end end elseif t=="roles"then F.applyRoles(pkt,pkt.seq,false)elseif t=="roles_part"then if not S.roleParts then S.roleParts={}end local seq=tonumber(pkt.seq)or 0
local total=tonumber(pkt.parts)or 0 local part=tonumber(pkt.part)or 0 if seq>0 and total>0 and part>0 then S.roleParts[seq]=S.roleParts[seq]or{by=pkt.by,total=total,got={},roles={},assign={}}local buf=S.roleParts[seq]
if buf.total==total and not buf.got[part]then buf.got[part]=true for _,it in ipairs(type(pkt.items)=="table"and pkt.items or{})do if type(it)=="table"then if it.k=="r"and type(it.v)=="table"then tinsert(buf.roles,it.v)
elseif it.k=="a"and type(it.u)=="string"and type(it.v)=="table"then buf.assign[it.u]=it.v end end end local gotN=0 for _ in pairs(buf.got)do gotN=gotN+1 end if gotN==buf.total then
F.applyRoles({type="roles",by=buf.by,seq=seq,roles=buf.roles,assign=buf.assign},seq,false)S.roleParts[seq]=nil end end end elseif t=="req_presence"then if pkt.author~=me and not stale then task.delay(0.4+math.random()*1.4,function()if NET.alive then F.heartbeat(false)end end)end end end function F.ingest(data,first)
if type(data.devs)=="table"then for _,n in ipairs(data.devs)do S.devs[tostring(n):lower()]=true end end S.strong=data.strong==true local nowMs=tonumber(data.nowMs)or 0 if type(data.users)=="table"then
pcall(F.ingestPresence,{ok=true,now=data.now,users=data.users,mute=data.mute,banned=data.banned})end if type(data.emojis)=="table"then S.sharedEmojis=data.emojis S.emojiSeq=tonumber(data.emojiSeq)or 0 end if type(data.roles)=="table"then
F.applyRoles(data.roles,data.rolesSeq,true)S.forceRoles=false end local srv=tonumber(data.rolesSeq)or 0 if srv==0 and data.ready==true and F.isDev(P.username)and#S.roles>0 and os.clock()-(S.rolesRepub or-999)>60 then
S.rolesRepub=os.clock();F.publishRoles(true)end local now=H.now()for _,m in ipairs(data.messages or{})do local seq=tonumber(m.seq)or 0 if seq>S.lastSeq then S.lastSeq=seq end local pkt=F.decode(m.c)if pkt then
local stale if nowMs>0 and seq>0 then stale=first or(nowMs-seq>30000)else stale=first or(tonumber(pkt.ts)~=nil and now-pkt.ts>30)end local ok,err=pcall(F.process,pkt,stale)
if not ok then warn("[CB42] process: "..tostring(err))end end end if S.lastSeq==0 then S.lastSeq=1 end end function F.sendNow()local rawInput=H.trim(U.input.Text)if rawInput==""then return end
if rawInput:sub(1,1)=="/"and F.slash(rawInput)then U.input.Text="";F.updateSuggest();return end if S.chan=="scripts"then F.openScriptComposer()return end if S.chan=="announce"and not F.canAnnounce(P.username)then
F.toast(T("announce_ro"),true)return end local text=F.expandShortcodes(rawInput)if#text>CFG.MAX_CONTENT then F.toast(T("too_long"),true);return end if F.muted(P.username)then F.toast(T("muted"),true);return end
if S.banned then F.toast(T("banned_you"),true);return end local lt=text:lower()if(lt:find("@everyone",1,true)or lt:find("@here",1,true))and not F.canMentionAll(P.username)then F.toast(T("no_ping"),true);return end
if S.editing then local m=S.msgs[S.editing]if m and m.author==P.username then m.content=text;m.edited=true if S.frames[m.packetId]then F.dropFrame(m.packetId);F.renderMessage(m)end F.bubble(P.username,text,m.chan)
F.publish({type="edit",target=m.packetId,author=P.username,content=text,chan=m.chan})end F.cancelCompose();U.input.Text="";return end local id=H.uuid()
local m={type="msg",packetId=id,chan=S.chan,author=P.username,display=P.display,uid=P.userId,content=text,ts=H.now(),place=S.chan=="game"and game.PlaceId or nil}
if S.reply then m.replyTo,m.replyAuthor,m.replySnippet=S.reply.id,S.reply.author,S.reply.snippet end F.addMsg(m)local other=F.dmOther(S.chan)if other then P.dmList[other]=H.now()end F.renderMessage(m);F.scrollBottom()
F.bubble(P.username,text,m.chan)U.input.Text="";F.cancelCompose();F.updateSuggest()S.activityAt=os.clock()
F.publish({type="msg",packetId=id,chan=m.chan,author=m.author,display=m.display,uid=m.uid,content=text,ts=m.ts,replyTo=m.replyTo,replyAuthor=m.replyAuthor,replySnippet=m.replySnippet,place=m.place},"send",function(ok)
if not ok then m.failed=true;F.dropFrame(id);F.renderMessage(m);F.toast(T("send_fail"),true)end end)S.isDirty=true end function F.insertEmoji()F.openEmoji({title=T("emoji_pick"),onPick=function(e)e=tostring(e or"")
if e==""then return end local tok=e if e:sub(1,4)=="img:"then local id=e:sub(5)local info=F.emojiInfoById(id)tok=(info and info.name)and(":"..info.name..":")or("[img:"..id.."]")local curTxt=U.input.Text
local sep=(curTxt~=""and not curTxt:match("%s$"))and" "or""U.input.Text=curTxt..sep..tok.." "else U.input.Text=U.input.Text..tok end F.updateSuggest()task.defer(function()if U.input and U.input.Parent then
pcall(function()U.input.CursorPosition=#U.input.Text+1 end)pcall(function()U.input:CaptureFocus()end)end end)end})end F.cmds,F.cmdList={},{}function F.command(name,desc,fn,opt)opt=opt or{}
local c={name=name,desc=desc,fn=fn,staff=opt.staff,dev=opt.dev,arg=opt.arg}F.cmds[name]=c for _,a in ipairs(opt.alias or{})do F.cmds[a]=c end
for i,x in ipairs(F.cmdList)do if x.name==name then tremove(F.cmdList,i)break end end tinsert(F.cmdList,c)return c end function F.slash(text)local cmd,arg=text:match("^/(%S+)%s*(.*)$")if not cmd then return false end
local c=F.cmds[cmd:lower()]if not c then return false end if c.dev and not F.isDev(P.username)then F.toast(T("no_perm"),true);return true end
if c.staff and not F.isStaff(P.username)then F.toast(T("staff_only"),true);return true end local ok,err=pcall(c.fn,H.trim(arg))if not ok then F.toast("/"..cmd..": "..tostring(err),true)end return true end
local function withUser(arg,fn)if arg==""then fn(nil)return end arg=arg:gsub("^@","")for u in pairs(S.users)do if u:lower()==arg:lower()then fn(u)return end end
F.resolveUser(arg,function(r)if r then fn(r.u)else F.toast(T("not_found"),true)end end)end F.command("help","c_help",function()F.openHelp()end,{alias={"?","commands"}})
F.command("online","c_online",function()F.openOnline()end,{alias={"who"}})F.command("find","c_find",function(a)U.searchBox.Visible=true;U.searchBox.Text=a;F.layout()end,{alias={"search"},arg="<text>"})
F.command("dm","c_dm",function(a)if a==""then F.openDMList()else withUser(a,function(u)if u then F.openDM(u)end end)end end,{alias={"w","msg"},arg="<name>"})
F.command("general","c_general",function()F.selectChannel("general")end)F.command("announce","announcetab",function()F.selectChannel("announce")end,{alias={"tb","thongbao"}})F.command("game","c_game",function()F.selectChannel("game")end)
F.command("scripts","c_scripts",function()F.selectChannel("scripts")end,{alias={"script","forum"}})F.command("staff","c_staff",function()F.selectChannel("staff")end,{staff=true})
F.command("profile","c_profile",function(a)withUser(a,function(u)F.openProfile(u or P.username)end)end,{alias={"me","user"},arg="[name]"})F.command("theme","c_theme",function()F.openTheme()end)
F.command("settings","c_settings",function()F.openSettings()end,{alias={"set"}})F.command("lang","c_lang",function()F.setLang(L=="en"and"vi"or"en")end)F.command("poll","c_poll",function()F.openPoll()end)
F.command("emoji","c_emoji",function()F.insertEmoji()end)F.command("report","c_report",function(a)withUser(a,function(u)F.openReport(u)end)end,{arg="[name]"})
F.command("roles","c_roles",function()F.openRoles()end,{dev=true})F.command("admin","c_admin",function()F.openAdmin()end,{staff=true})
F.command("mute","c_mute",function(a)withUser(a,function(u)F.openMute(u)end)end,{staff=true,arg="[name]"})F.command("warn","c_warn",function(a)withUser(a,function(u)F.openWarn(u)end)end,{staff=true,arg="[name]"})
F.command("unmute","c_unmute",function(a)withUser(a,function(u)
if u and F.canAct(P.username,u)then F.publish({type="unmute",by=P.username,target=u,chan="staff"});F.toast(T("saved_ok"),true)else F.toast(T("hier"),true)end end)end,{staff=true,alias={"clearmute"},arg="<name>"})
F.command("unwarn","c_unwarn",function(a)withUser(a,function(u)
if u and F.canAct(P.username,u)then F.publish({type="clear_warn",by=P.username,target=u,chan="staff"});S.warns[u]=nil;F.toast(T("saved_ok"),true)else F.toast(T("hier"),true)end
end)end,{staff=true,alias={"clearwarn"},arg="<name>"})F.command("react","c_react",function(a)local m=S.reply and S.msgs[S.reply.id];if m and a~=""then F.doReact(m,a)end end,{arg="<emoji>"})
F.command("request","c_request",function()F.openRequest()end,{alias={"xin"}})
F.command("status","c_status",function(a)P.status=H.clip(a,80);S.isDirty=true;F.heartbeat(false);F.toast(T("status_set"),true)end,{arg="<text>"})F.command("diag","c_diag",function()F.openDiag()end,{alias={"debug"}})
function F.armAutoTeleport()end hook(LP.OnTeleport,function()F.save(true)end)F.command("invite","c_invite",function(a)local note=H.trim(a)
local msg=(note~=""and(note.." ")or("🎮 "..F.disp(S.placeName or"Server").." "))..string.format("[join:%s:%s]",tostring(game.PlaceId),tostring(game.JobId))U.input.Text=msg F.sendNow()
end,{alias={"joinme","party"},arg="[note]"})F.command("fps","c_fps",function()local fps=floor(1/max(0.001,game:GetService("RunService").RenderStepped:Wait()))local rtt=S.rtt and(floor(S.rtt).."ms")or"—"
F.toast(string.format("FPS: %d · Ping: %s · Players: %d/%d",fps,rtt,#Players:GetPlayers(),Players.MaxPlayers),true)end,{alias={"stats"}})F.command("back","c_back",function()F.selectChannel("general")end)
F.command("clear","c_clear",function()for id in pairs(S.frames)do F.dropFrame(id)end F.toast("Cleared view",true)end,{alias={"cls"}})
F.command("copyjob","c_copyjob",function()F.copyText(string.format("PlaceId: %s | JobId: %s",tostring(game.PlaceId),tostring(game.JobId)))end,{alias={"jobid","server"}})F.command("rejoin","c_rejoin",function()
F.save(true);F.armAutoTeleport()F.toast("Rejoining server...",true)pcall(function()TeleportService:TeleportToPlaceInstance(game.PlaceId,game.JobId,LP)end)end,{alias={"rj"}})F.command("hop","c_hop",function()
F.save(true);F.armAutoTeleport()F.toast("Hopping to another server...",true)pcall(function()TeleportService:Teleport(game.PlaceId,LP)end)end,{alias={"serverhop"}})function F.tokColors()
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
function F.mentionColorFor(u)
local lu=tostring(u or""):lower()
local base=TH.mentionText or TH.accent
if lu==P.username:lower()then return H.ensureContrast(H.mix(base,TH.ok,0.35),TH.bg2,4.3)end
if lu=="everyone"or lu=="here"or lu=="all"then return H.ensureContrast(H.mix(base,TH.warn,0.45),TH.bg2,4.3)end
local role=F.topRole(u)
if role and not P.custom.mentionText then return H.ensureContrast(H.mix(H.hex(role.color),base,0.45),TH.bg2,4.3)end
return base
end
function F.resolveCmdToken(rawCmd)local TC=F.tokColors()local lc=tostring(rawCmd or""):lower()if lc==""then return{status="wait",col=TC.cmd_wait,label="/ (help, dm, scripts, emoji, poll...)"}end local exact=F.cmds[lc]if exact then
local allowed=(not exact.staff or F.isStaff(P.username))and(not exact.dev or F.isDev(P.username))if allowed then return{status="ok",col=TC.cmd_ok,cmd=exact,
label="/"..exact.name..(exact.arg and(" "..exact.arg)or"").." — "..T(exact.desc),}else return{status="bad",col=TC.cmd_bad,label="/"..rawCmd.." (Staff/Dev)"}end end for _,c in ipairs(F.cmdList)do
if(not c.staff or F.isStaff(P.username))and(not c.dev or F.isDev(P.username))and c.name:sub(1,#lc)==lc then return{status="wait",col=TC.cmd_wait,cmd=c,label="/"..rawCmd.." -> /"..c.name.." ("..T(c.desc)..")",
}end end return{status="bad",col=TC.cmd_bad,label="/"..rawCmd}end function F.resolveMentionToken(name,isAtEnd)local TC=F.tokColors()local ln=tostring(name or""):lower()if ln==""then
return{status="wait",col=TC.men_wait,label="@ (everyone, "..P.username.."...)"}end if ln=="everyone"or ln=="here"or ln=="all"then if F.canMentionAll(P.username)then
return{status="ok",col=F.mentionColorFor(ln),label="@"..ln}else return{status="bad",col=TC.men_bad,label="@"..ln.." (Role)"}end end if ln==P.username:lower()or(P.display and P.display:lower()==ln)then
return{status="ok",col=F.mentionColorFor(P.username),label="@"..P.username}end for u,r in pairs(S.users)do if u:lower()==ln or tostring(r.display or""):lower()==ln then return{status="ok",
col=F.mentionColorFor(u),label="@"..u..(r.display and r.display~=u and(" ("..r.display..")")or""),}end end for _,pl in ipairs(Players:GetPlayers())do
if pl.Name:lower()==ln or tostring(pl.DisplayName or""):lower()==ln then return{status="ok",col=F.mentionColorFor(pl.Name),
label="@"..pl.Name..(pl.DisplayName and pl.DisplayName~=pl.Name and(" ("..pl.DisplayName..")")or""),}end end for u,r in pairs(S.users)do
if u:lower():find(ln,1,true)or tostring(r.display or""):lower():find(ln,1,true)then return{status=isAtEnd and"wait"or"bad",col=isAtEnd and TC.men_wait or TC.men_bad,label="@"..name.." -> @"..u,}end
end for _,pl in ipairs(Players:GetPlayers())do if pl.Name:lower():find(ln,1,true)or tostring(pl.DisplayName or""):lower():find(ln,1,true)then return{status=isAtEnd and"wait"or"bad",
col=isAtEnd and TC.men_wait or TC.men_bad,label="@"..name.." -> @"..pl.Name,}end end if("everyone"):find(ln,1,true)==1 or("here"):find(ln,1,true)==1 then return{status=isAtEnd and"wait"or"bad",
col=isAtEnd and TC.men_wait or TC.men_bad,label="@"..name.." -> @everyone",}end return{status="bad",col=TC.men_bad,label="@"..name}end function F.resolveKnownMention(name)
local res=F.resolveMentionToken(name,false)if res and res.status=="ok"then return res.label,res.col end return nil end function F.resolveEmojiToken(rawName,isClosed)local TC=F.tokColors()local clean=F.cleanEmojiName(rawName):lower()
if rawName==""and not isClosed then return{status="wait",col=TC.emo_wait,label=":emoji: (fire, heart, skull, custom...)"}end local id,realNm=F.emojiIdByName(rawName)if id then return{
status=isClosed and"ok"or"wait",col=isClosed and TC.emo_ok or TC.emo_wait,icon="img:"..tostring(id),label=":"..tostring(realNm or rawName)..":"..(isClosed and""or" (nhấn : hoặc chọn)"),}end
local uni=CFG.SHORTCODES and CFG.SHORTCODES[clean]if uni then return{status=isClosed and"ok"or"wait",col=isClosed and TC.emo_ok or TC.emo_wait,icon=uni,
label=":"..clean..": "..uni..(isClosed and""or" (nhấn : hoặc chọn)"),}end if not isClosed and clean~=""then for _,e in ipairs(S.sharedEmojis or{})do local nm=tostring(e.name or"")
if nm:lower():find(clean,1,true)or tostring(e.id or""):find(clean,1,true)then return{status="wait",col=TC.emo_wait,icon="img:"..tostring(e.id),label=":"..rawName.." -> :"..nm..":",}end end
for cid,nm in pairs(P.customEmojiNames or{})do if tostring(nm):lower():find(clean,1,true)then return{status="wait",col=TC.emo_wait,icon="img:"..tostring(cid),label=":"..rawName.." -> :"..tostring(nm)..":",}
end end for _,cid in ipairs(P.customEmojis or{})do local sId=tostring(cid)local defNm=P.customEmojiNames[sId]or("emo_"..sId:sub(-4))if defNm:lower():find(clean,1,true)or sId:find(clean,1,true)then return{
status="wait",col=TC.emo_wait,icon="img:"..sId,label=":"..rawName.." -> :"..defNm..":",}end end for k,uChar in pairs(CFG.SHORTCODES or{})do if k:find(clean,1,true)then return{status="wait",
col=TC.emo_wait,icon=uChar,label=":"..rawName.." -> :"..k..": "..uChar,}end end end return{status="bad",col=TC.emo_bad,label=":"..tostring(rawName)..(isClosed and":"or""),}end
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
richParts[#richParts+1]=H.esc(ch)i=i+1 end end else richParts[#richParts+1]=H.esc(ch)i=i+1 end end local hasTokens=#tokens>0 local active=hasTokens and tokens[#tokens]or nil
local cmdActive,menActive,emoActive=nil,nil,nil for _,tk in ipairs(tokens)do if tk.kind=="cmd"then cmdActive=tk elseif tk.kind=="mention"then menActive=tk elseif tk.kind=="emoji"then emoActive=tk end end if U.cmdBtn then
U.cmdBtn.BackgroundColor3=cmdActive and cmdActive.col or TH.bg3 U.cmdBtn.TextColor3=cmdActive and c3(1,1,1)or TH.accent if U.cmdBtnStroke then U.cmdBtnStroke.Color=cmdActive and cmdActive.col or TH.bg3
U.cmdBtnStroke.Transparency=cmdActive and 0.05 or 0.5 end end if U.atBtn then U.atBtn.BackgroundColor3=menActive and menActive.col or TH.bg3 U.atBtn.TextColor3=menActive and c3(1,1,1)or(TH.mentionText or TH.warn) if U.atBtnStroke then
U.atBtnStroke.Color=menActive and menActive.col or TH.bg3 U.atBtnStroke.Transparency=menActive and 0.05 or 0.5 end end if U.emojiBtn then U.emojiBtn.BackgroundColor3=emoActive and emoActive.col or TH.bg3
if U.emojiBtnStroke then U.emojiBtnStroke.Color=emoActive and emoActive.col or TH.bg3 U.emojiBtnStroke.Transparency=emoActive and 0.05 or 0.5 end end if active then local col=active.col U.inputStroke.Color=col
U.inputStroke.Transparency=0.05 if U.chatBarStroke then U.chatBarStroke.Color=col U.chatBarStroke.Transparency=0.1 end if U.tokenDot then U.tokenDot.BackgroundColor3=col end
local maxW=(U.inputWrap and U.inputWrap.AbsoluteSize.X>40)and(U.inputWrap.AbsoluteSize.X-24)or 220 local fitsInBox=H.textW(text,P.textSize,fG)<=maxW
local isFocused=U.input and U.input:IsFocused()
if U.inputRich and fitsInBox and not isFocused and #tokens>0 then U.inputRich.TextSize=P.textSize U.inputRich.TextColor3=TH.text
U.inputRich.Text=tconcat(richParts)U.inputRich.Visible=true U.input.TextTransparency=1 U.input.TextColor3=col else if U.inputRich then U.inputRich.Visible=false end U.input.TextTransparency=0 U.input.TextColor3=col
end local prefix=""if active.kind=="cmd"then prefix=T(active.status=="ok"and"tok_cmd_ok"or(active.status=="wait"and"tok_cmd_wait"or"tok_cmd_bad"))elseif active.kind=="mention"then
prefix=T(active.status=="ok"and"tok_mention_ok"or(active.status=="wait"and"tok_mention_find"or"tok_mention_bad"))elseif active.kind=="emoji"then
prefix=T(active.status=="ok"and"tok_emoji_ok"or(active.status=="wait"and"tok_emoji_find"or"tok_emoji_bad"))end if active.icon then U.tokenIconHolder.Visible=true F.iconBox(U.tokenIconHolder,active.icon,16)end
U.tokenAccent.BackgroundColor3=col U.tokenStroke.Color=col U.tokenLbl.Position=uo(U.tokenIconHolder.Visible and 28 or 10,0)U.tokenLbl.Size=u2(1,U.tokenIconHolder.Visible and-114 or-96,1,0)
U.tokenLbl.Text=prefix..tostring(active.label or"")U.tokenLbl.TextColor3=col if U.tokenStatePill then U.tokenStatePill.BackgroundColor3=col U.tokenStatePill.TextColor3=H.lum(col)>0.6 and rgb(18,18,22)or c3(1,1,1)
U.tokenStatePill.Text=T(active.status=="ok"and"tok_state_ok"or(active.status=="wait"and"tok_state_wait"or"tok_state_bad"))end else if U.inputRich then U.inputRich.Visible=false end U.input.TextTransparency=0
U.input.TextColor3=TH.text U.inputStroke.Color=TH.bg3 U.inputStroke.Transparency=0.45 if U.chatBarStroke then U.chatBarStroke.Color=TH.bg3 U.chatBarStroke.Transparency=0.25 end if U.tokenDot then
U.tokenDot.BackgroundColor3=(text~="")and TH.accent or TH.muted end end local changed=(U.tokenBar.Visible~=hasTokens)U.tokenBar.Visible=hasTokens return changed end function F.updateSuggest()local text=U.input.Text
local tokChanged=F.updateTokenFeedback(text)local items={}local trimmedLead=text:match("^%s*(.*)$")or text if trimmedLead:sub(1,1)=="/"and not trimmedLead:find("%s")then local pre=trimmedLead:sub(2):lower()
for _,c in ipairs(F.cmdList)do if(not c.staff or F.isStaff(P.username))and(not c.dev or F.isDev(P.username))and c.name:sub(1,#pre)==pre then items[#items+1]={label="/"..c.name,fill="/"..c.name.." ",kind="cmd"}end end
else local emoWord=text:match(":([%w_%-]*)$")local word=text:match("@([%w_]*)$")if emoWord~=nil and not text:match(":([%w_%-]+):$")then local ew=emoWord:lower()local seenId={}for _,e in ipairs(S.sharedEmojis or{})do
local nm=tostring(e.name or"")local id=tostring(e.id or"")if id~=""and not seenId[id]and(ew==""or nm:lower():find(ew,1,true)or id:find(ew,1,true))then seenId[id]=true items[#items+1]={label=":"..nm..":",
icon="img:"..id,fill=text:gsub(":[%w_%-]*$",":"..nm..": "),kind="emoji",}if#items>=8 then break end end end for id,nm in pairs(P.customEmojiNames or{})do if#items>=8 then break end
if not seenId[tostring(id)]and(ew==""or tostring(nm):lower():find(ew,1,true))then seenId[tostring(id)]=true items[#items+1]={label=":"..nm..":",icon="img:"..tostring(id),fill=text:gsub(":[%w_%-]*$",":"..nm..": "),
kind="emoji",}end end for _,cid in ipairs(P.customEmojis or{})do if#items>=8 then break end local sId=tostring(cid)local nm=P.customEmojiNames[sId]or("emo_"..sId:sub(-4))
if not seenId[sId]and(ew==""or nm:lower():find(ew,1,true)or sId:find(ew,1,true))then seenId[sId]=true items[#items+1]={label=":"..nm..":",icon="img:"..sId,fill=text:gsub(":[%w_%-]*$",":"..nm..": "),kind="emoji",}
end end local scOrder={"fire","heart","skull","joy","sob","thumbsup","100","sparkles","crown","star","eyes","check","rocket","wave","pray","party","cool","thinking","gg","gem"}for _,k in ipairs(scOrder)do
if#items>=10 then break end local uChar=CFG.SHORTCODES and CFG.SHORTCODES[k]if uChar and(ew==""or k:find(ew,1,true))then items[#items+1]={label=":"..k..":",icon=uChar,fill=text:gsub(":[%w_%-]*$",":"..k..": "),
kind="emoji",}end end elseif word~=nil then local w=word:lower()local names={}local seenU={}local function addCandidate(u,disp)if not u or seenU[u:lower()]then return end
if w==""or u:lower():find(w,1,true)or tostring(disp or""):lower():find(w,1,true)then seenU[u:lower()]=true names[#names+1]=u end end for u,r in pairs(S.users)do addCandidate(u,r.display)end
for _,pl in ipairs(Players:GetPlayers())do addCandidate(pl.Name,pl.DisplayName)end tsort(names,function(a,b)local la,lb=F.isLive(S.users[a]),F.isLive(S.users[b])if la~=lb then return la end return a:lower()<b:lower()
end)if F.canMentionAll(P.username)then for _,x in ipairs({"everyone","here"})do if w==""or x:find(w,1,true)==1 then tinsert(names,1,x)end end end for i=1,min(#names,8)do items[#items+1]={label="@"..names[i],
fill=text:gsub("@[%w_]*$","@"..names[i].." "),kind="mention",user=names[i],}end end end for _,c in ipairs(U.suggest:GetChildren())do if not c:IsA("UIListLayout")then c:Destroy()end end local show=#items>0
for i,it in ipairs(items)do local hasIc=it.icon~=nil local lblW=clamp(H.textW(it.label,11,fGB)+4,24,150)local btnW=8+(hasIc and 20 or 0)+lblW+8
local b=mk("TextButton",{Size=uo(btnW,24),Text="",BorderSizePixel=0,LayoutOrder=i},U.suggest)th(b,"BackgroundColor3","bg2");corner(b,12)
local TC=F.tokColors()local chipCol=it.kind=="cmd"and TC.cmd_wait or(it.kind=="mention"and(it.user and F.mentionColorFor(it.user)or TC.men_ok)or TC.emo_ok)
mk("UIStroke",{Color=chipCol,Thickness=1.2,Transparency=0.2,ApplyStrokeMode=smBorder},b)if hasIc then local ic=F.iconBox(b,it.icon,16)ic.Position=uo(7,4)end local l=lab(b,it.label,{size=uo(lblW,24),
pos=uo(hasIc and 26 or 8,0),ts=11,bold=true,})l.TextColor3=chipCol hook(b.MouseButton1Click,function()U.input.Text=it.fill;F.updateSuggest();U.input:CaptureFocus()end)end
if U.suggest.Visible~=show or tokChanged then U.suggest.Visible=show;F.layout()end end function F.save(force)if not hasIO then return end
if not force and(not S.isDirty or os.clock()-S.lastSave<CFG.SAVE_THROTTLE)then return end S.lastSave=os.clock();S.isDirty=false local rx={}for id,m in pairs(S.reactions)do if S.msgs[id]and next(m)then rx[id]=m end end
local polls,n={},0 for id,p in pairs(S.polls)do n=n+1;if n<=60 then polls[id]=p end end local d={clientId=P.clientId,lang=L,display=P.display,status=P.status,bio=P.bio,country=P.country,
dmList=P.dmList,customEmojis=P.customEmojis,recentEmoji=P.recentEmoji,recentColors=P.recentColors,themeName=P.themeName,custom=P.custom,alpha=P.alpha,mute=P.mute,W=P.W,H=P.H,
notify=P.notify,sound=P.sound,bubble=P.bubble,safeEmoji=P.safeEmoji,showGame=P.showGame,preview=P.preview,compact=P.compact,sameUser=P.sameUser,group=P.group,textSize=P.textSize,toastPos=P.toastPos,
miniX=P.miniX,miniY=P.miniY,roles=S.roles,assign=S.assign,rolesSeq=S.rolesSeq,warns=S.warns,reports=S.reports,reactions=rx,polls=polls,
customEmojiNames=P.customEmojiNames,sharedEmojis=S.sharedEmojis,scripts=S.scripts,proxies=P.proxies,savedScripts=P.savedScripts,}local s=H.jenc(d)
if s then pcall(writefile,FILE,s)end end local drag,md local function isPress(i)return i.UserInputType==mb1 or i.UserInputType==utTouch end
local function isMove(i,ref)return(ref.UserInputType==utTouch and i==ref)or(ref.UserInputType==mb1 and i.UserInputType==Enum.UserInputType.MouseMovement)end
hook(U.titleBar.InputBegan,function(i)if isPress(i)then drag={kind="move",start=i.Position,ox=S.winX,oy=S.winY,input=i}end end)
hook(U.resize.InputBegan,function(i)if isPress(i)then drag={kind="size",start=i.Position,w=P.W,h=P.H,input=i}end end)hook(U.mini.InputBegan,function(i)
if isPress(i)then S.miniMoved=false;md={start=i.Position,ox=U.mini.Position.X.Offset,oy=U.mini.Position.Y.Offset,input=i,moved=false}end end)hook(UIS.InputChanged,function(i)local tk=S.track
if tk and isMove(i,tk.input)then pcall(tk.fn,i.Position)end if drag and isMove(i,drag.input)then local d=i.Position-drag.start
if drag.kind=="move"then S.winX,S.winY=drag.ox+d.X,drag.oy+d.Y else P.W,P.H=drag.w+d.X,drag.h+d.Y end F.layout()end if md and isMove(i,md.input)then local d=i.Position-md.start
if d.Magnitude>6 then md.moved=true;S.miniMoved=true end if md.moved then local v=viewNow()U.mini.Position=uo(clamp(md.ox+d.X,0,v.X-42),clamp(md.oy+d.Y,0,v.Y-42))end end end)hook(UIS.InputEnded,function(i)
if S.track and(i==S.track.input or(S.track.input.UserInputType==mb1 and i.UserInputType==mb1))then F.endTrack()end if drag and(i==drag.input or i.UserInputType==mb1)then drag=nil;S.isDirty=true end
if md and(i==md.input or i.UserInputType==mb1)then if md.moved then P.miniX,P.miniY=U.mini.Position.X.Offset,U.mini.Position.Y.Offset;S.isDirty=true end md=nil end end)hook(UIS.InputBegan,function(i,gp)
S.activityAt=os.clock()if not gp and i.KeyCode==Enum.KeyCode.RightShift then U.main.Visible=not U.main.Visible if U.main.Visible then U.mini.Visible=false end end end)local function showMain()
U.main.Visible=true;U.mini.Visible=false S.miniUnread=0;U.miniBadge.Visible=false F.selectChannel(S.chan)end hook(U.mini.MouseButton1Click,function()if S.miniMoved then S.miniMoved=false return end showMain()end)
hook(U.bMin.MouseButton1Click,function()U.main.Visible=false;U.mini.Visible=true end)hook(U.bLang.MouseButton1Click,function()F.setLang(L=="en"and"vi"or"en")end)hook(U.bFind.MouseButton1Click,function()
U.searchBox.Visible=not U.searchBox.Visible if not U.searchBox.Visible then U.searchBox.Text="";S.search="";F.rebuildFeed()else U.searchBox:CaptureFocus()end F.layout()end)
hook(U.searchBox:GetPropertyChangedSignal("Text"),function()S.search=U.searchBox.Text;F.rebuildFeed()end)hook(U.bUsers.MouseButton1Click,F.openOnline)hook(U.bMe.MouseButton1Click,function()F.openProfile(P.username)end)
hook(U.bSet.MouseButton1Click,F.openSettings)for name,b in pairs(U.tabs)do hook(b.MouseButton1Click,function()if name=="dm"then F.openDMList()else F.selectChannel(name)end end)end
hook(U.sendBtn.MouseButton1Click,F.sendNow)hook(U.input.Focused,function()F.updateTokenFeedback(U.input.Text)end)hook(U.input.FocusLost,function(enter)if enter then F.sendNow()else F.updateTokenFeedback(U.input.Text)end end)hook(U.input:GetPropertyChangedSignal("Text"),function()F.updateSuggest()local t=U.input.Text
if t~=""and t:sub(1,1)~="/"and os.clock()-S.lastType>CFG.TYPING_THROTTLE and not F.muted(P.username)then S.lastType=os.clock()F.publish({type="typing",author=P.username,chan=S.chan},"fast")end end)
hook(U.emojiBtn.MouseButton1Click,function()F.insertEmoji()end)hook(U.pollBtn.MouseButton1Click,F.openPoll)hook(U.replyX.MouseButton1Click,function()F.cancelCompose();U.input.Text=""end)
hook(U.jump.MouseButton1Click,function()F.scrollBottom()end)hook(U.scroll:GetPropertyChangedSignal("CanvasPosition"),function()if F.nearBottom()then S.newBelow=0 end F.updateJump()end)
hook(U.scroll:GetPropertyChangedSignal("AbsoluteCanvasSize"),function()if S.stickUntil and os.clock()<S.stickUntil then F.snapBottom()end end)local vcam=workspace.CurrentCamera
if vcam then hook(vcam:GetPropertyChangedSignal("ViewportSize"),F.layout)end local function pollDelay()local idleSec=os.clock()-S.activityAt if not U.main.Visible or(P.W<115 or P.H<95)then
return idleSec>60 and(CFG.POLL_AFK or 4)or CFG.POLL_IDLE end return idleSec<30 and CFG.POLL_FAST or(idleSec>120 and(CFG.POLL_AFK or 4)or CFG.POLL_IDLE)end local function pollLoop()while NET.alive do
local lp=S.lpOn and S.lastSeq>0 local since,wait,sweep=S.lastSeq,(lp and CFG.LONGPOLL or 0),false if S.lastSeq>0 and not S.strong and os.clock()-(S.sweepAt or 0)>=CFG.SWEEP then sweep=true
since,wait=max(1,S.lastSeq-CFG.OVERLAP_MS),0 end local rs=S.forceRoles and 0 or S.rolesSeq
local pQuery=(S.lastSeq==0 or os.clock()-(S.lastPresPiggy or 0)>40)and string.format("&d=%s&id=%d&st=%s&c=%s&sg=%d&pl=%d&gn=%s&jb=%s",H.url(P.display),P.userId,H.url(P.status),H.url(P.country),P.showGame and 1 or 0,P.showGame and game.PlaceId or 0,H.url(P.showGame and S.placeName or""),H.url(P.showGame and game.JobId or""))or""
if pQuery~=""then S.lastPresPiggy=os.clock()end
local path=string.format("/api/feed?since=%s&limit=%d&rs=%s&ss=%s&es=%s&u=%s&wait=%d%s",H.num(since),S.lastSeq==0 and CFG.HISTORY or 100,H.num(rs),H.num(S.scriptSeq or 0),H.num(S.emojiSeq or 0),H.url(P.username),wait,pQuery)local t0=os.clock()
local data,err=rawRequest("GET",path)if not NET.alive then break end if data and data.ok then if sweep then S.sweepAt=os.clock()end local first=S.lastSeq==0 S.pollFail,S.lpFails,S.lastPollOk=0,0,os.clock()
local ok,e=pcall(F.ingest,data,first)if not ok then warn("[CB42] ingest: "..tostring(e))end if first and not S.booted then F.afterBoot()end F.paintDot()
if not first then if#(data.messages or{})==0 and os.clock()-t0<0.35 then task.wait(lp and 0.25 or pollDelay())elseif not lp then task.wait(pollDelay())end end else S.pollFail=S.pollFail+1;S.lpFails=S.lpFails+1
if S.lpOn and S.lpFails>=3 then S.lpOn=false;S.lpRetryAt=os.clock()+CFG.LP_RETRY end F.paintDot()task.wait(min(5,0.5*S.pollFail))end
if not S.lpOn and S.lpRetryAt and os.clock()>S.lpRetryAt and CFG.LONGPOLL>0 then S.lpOn,S.lpFails,S.lpRetryAt=true,0,nil end end end local function heartbeatLoop()while NET.alive do task.wait(CFG.HEARTBEAT)
if NET.alive then F.heartbeat(false)end end end local function tickLoop()local n=0 while NET.alive do task.wait(0.5)n=n+1 local now=os.clock()local names={}for u,t in pairs(S.typing[S.chan]or{})do
if now-t<CFG.TYPING_TIMEOUT then names[#names+1]=u else S.typing[S.chan][u]=nil end end U.typing.Text=#names>0 and(F.disp(tconcat(names,", ",1,min(#names,3)))..T("typing").."…")or""if n%10==0 then local alive={}
for _,c in ipairs(conns)do if c.Connected then alive[#alive+1]=c end end conns=alive if#reg>800 then F.pruneThemeReg()end F.updateInfo()
if S.mutes[P.username]and not F.muted(P.username)and P.mute.on then P.mute.on=false;S.isDirty=true end pcall(F.refreshSame)if n%120==0 then local cnt=0 for _,r in pairs(S.users)do if F.isLive(r)then cnt=cnt+1 end end
if cnt<=1 and#Players:GetPlayers()>1 then F.publish({type="req_presence",author=P.username,chan="general"},"fast")end end end F.save(false)end end function F.refreshSame()if not P.sameUser then
for u,bb in pairs(S.sameBb)do pcall(function()bb:Destroy()end);S.sameBb[u]=nil end return end local alive={}local function headOf(pl)local ch=pl and pl.Character
return ch and(ch:FindFirstChild("Head")or ch:FindFirstChild("HumanoidRootPart")or ch.PrimaryPart)end local function pin(name,head)alive[name]=true local curBb=S.sameBb[name]
if curBb and curBb.Parent and curBb.Adornee==head then return end if curBb then pcall(function()curBb:Destroy()end)end local bb=Instance.new("BillboardGui")bb.Name="CB42Same_"..name bb.Adornee=head bb.Size=uo(44,20)
bb.StudsOffset=Vector3.new(0,2.5,0)bb.AlwaysOnTop=true bb.MaxDistance=160 bb.LightInfluence=0 bb.Parent=F.billboardContainer(head)local pill=Instance.new("Frame")pill.Size=us(1,1)pill.BackgroundColor3=TH.bg2
pill.BackgroundTransparency=0.15 pill.BorderSizePixel=0 pill.Parent=bb corner(pill,10)mk("UIStroke",{Color=TH.accent,Thickness=1.2,Transparency=0.25},pill)local l=Instance.new("TextLabel")l.Size=us(1,1)
l.BackgroundTransparency=1 l.Text="💬 CB"l.TextColor3=TH.accent l.TextSize=11 l.Font=fGB l.Parent=pill S.sameBb[name]=bb end for _,pl in ipairs(Players:GetPlayers())do if pl~=LP and F.isScriptUser(pl.Name)then
local h=headOf(pl)if h then pin(pl.Name,h)end end end for u,bb in pairs(S.sameBb)do if not alive[u]then pcall(function()bb:Destroy()end);S.sameBb[u]=nil end end end function F.afterBoot()if S.booted then return end
S.booted=true F.armAutoTeleport()F.layoutTabs();F.selectChannel(S.chan)F.toast(T("ready"),false)F.emit("ready")end function F.stop()if S.stopped then return end S.stopped=true F.save(true)
task.spawn(function()pcall(rawRequest,"POST","/api/presence",{u=P.username,off=true})end)task.delay(0.5,function()NET.alive=false end)F.emit("stop")for _,c in ipairs(conns)do pcall(function()c:Disconnect()end)end
for _,b in pairs(S.bubbles)do pcall(function()b:Destroy()end)end for _,b in pairs(S.sameBb or{})do pcall(function()b:Destroy()end)end pcall(function()U.gui:Destroy()end)
ENV.CB42_STOP=nil;ENV.CB41_STOP=nil;ENV.CB42=nil;ENV.CB41=nil end ENV.CB42_STOP=F.stop ENV.CB41_STOP=F.stop ENV.CB43_STOP=F.stop ENV.CB42={version="43.0",cfg=CFG,F=F,S=S,P=P,U=U,H=H,command=F.command,on=F.on,toast=F.toast,
send=function(text,chan)if chan then F.selectChannel(chan)end U.input.Text=tostring(text);F.sendNow()end,
request=F.openRequest,admin=F.openAdmin,roles=F.openRoles,diag=F.openDiag,}F.layout();F.paintTheme();F.layoutTabs();F.paintTabs();F.updateInfo()task.spawn(function()
local bestUrl,bestDt=CFG.PROXY,999
for idx,u in ipairs(PROXY_POOL)do
task.spawn(function()
local t0=os.clock()local ok,res=pcall(httpFn,{Url=u.."/api/ping",Method="GET"})
if ok and type(res)=="table"and(tonumber(res.StatusCode or res.Status)or 0)==200 then
local dt=os.clock()-t0
if dt<bestDt and S.pollFail>0 then bestDt=dt;CFG.PROXY=u;NET.idx=idx end
end
end)
end
local ok,info=pcall(function()return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)end)S.placeName=(ok and info and info.Name)or tostring(game.Name or"?")S.lastPresPiggy=0
end)task.spawn(pollLoop)task.spawn(heartbeatLoop)task.spawn(tickLoop)task.spawn(function()task.wait(30)while NET.alive do task.wait(300)
if S.lastPollOk==0 or os.clock()-S.lastPollOk>90 then S.pollFail=0 S.lpOn=CFG.LONGPOLL>0 S.lpFails=0 warn("[CB42] Watchdog: resync")end end end)if saved.W==nil and IS_MOBILE then P.W,P.H=340,480 end
print("[CB43] Chat Bridge v43.0 · "..EXEC.." · Dừng: getgenv().CB42_STOP()")
