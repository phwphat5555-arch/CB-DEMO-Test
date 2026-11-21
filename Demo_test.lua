/**
 * ============================================================================
 * CHAT BRIDGE v47.6 — FILE 2: worker_47.6.js (SERVER BACKUP — ZERO-CF-WASTE MESH HUB)
 * ============================================================================
 * Nền tảng triển khai : Cloudflare Workers (Free Tier - 100k req/ngày mỗi Worker)
 * Danh sách 5 Server  :
 *   - Backup 1 : https://cb-roblox.phwphat5555.workers.dev
 *   - Backup 2 : https://backup.phwphat8888.workers.dev
 *   - Backup 3 : https://backupv2.sillydumb111.workers.dev
 *   - Backup 4 : https://backupv3.just-a-blur-000.workers.dev
 *   - Backup 5 : https://backup5.dumbnguyen5555.workers.dev
 *
 * Kiến trúc chuẩn v47.6 (CHIA ĐỀU 5 BÌNH + BYPASS DO + SPLIT-KEY STORAGE):
 * 1. BYPASS DURABLE OBJECT & EDGE CACHE:
 *    - `/api/ping` trả thẳng ở lớp Worker Edge (0 lượt gọi DO HUB).
 *    - `/api/images` xử lý ngay ở lớp Worker + bọc `caches.default` (max-age=14400 = 4 giờ).
 * 2. TÁCH 5 KHÓA LƯU TRỮ DO (`cb42:st:mod`, `scripts`, `profiles`, `chat`, `meta`):
 *    - Chỉ ghi đúng khóa thay đổi (`G.dirtyParts`), bỏ lưu `pres` xuống storage,
 *      tự động migrate 100% dữ liệu từ `cb42:state` cũ khi nạp lần đầu.
 * 3. CẮT VÒNG LẶP ĐỒNG BỘ THỪA + GỘP `seen` VÀO `/api/feed` + HỖ TRỢ `migrateTo`:
 *    - Không gọi `pullFromBoss` định kỳ 12s nữa (chỉ cold boot hoặc khi `stateTs` mới hơn).
 *    - Khoảng chờ đẩy nền khi không có `line` tăng lên 45s (`BOSS_PUSH_IDLE_MS = 45000`).
 *    - Nhận `&seen=id1,id2,...` (tối đa 30 ID) trực tiếp trên `GET /api/feed`.
 *    - Giữ `scheduled` là no-op (đã có `cron-job.org` 5 phút/lần giữ ấm Render).
 * ============================================================================
 */

// ============================================================================
// 1. CẤU HÌNH HẰNG SỐ HỆ THỐNG, DANH SÁCH MESH & GIÁ TRỊ MẶC ĐỊNH
// ============================================================================

const VERSION = "cb47.6-backup-mesh-worker";
const PREFIX = "CB42:";
const PROF_PREFIX = "CB46_PROF:";
const PRESENCE_TTL = 75;
const PREFIXES = [];
for (let v = 47; v >= 19; v--) PREFIXES.push("CB" + v + ":");

// Giá trị mặc định cấu hình chung (Secrets đọc 100% từ Cloudflare Environment Variables / Secrets)
const DEFAULT_BOSS_URL = "https://cb45-boss.onrender.com";
const DEFAULT_DATA_CH = "1548954134836405130";
const DEFAULT_ROLES_CH = "1548954139143184458";
const DEFAULT_DEVELOPERS = "phwphat5555";
const DEFAULT_PROFILE_WEBHOOK = "";
const DEFAULT_PROFILE_BOT_TOKEN = "";

// Danh sách 5 Server Backup liên kết Mesh trực tiếp với nhau
const DEFAULT_BACKUP_WORKERS = [
  { id: "b1", shortName: "Backup 1", url: "https://cb-roblox.phwphat5555.workers.dev" },
  { id: "b2", shortName: "Backup 2", url: "https://backup.phwphat8888.workers.dev" },
  { id: "b3", shortName: "Backup 3", url: "https://backupv2.sillydumb111.workers.dev" },
  { id: "b4", shortName: "Backup 4", url: "https://backupv3.just-a-blur-000.workers.dev" },
  { id: "b5", shortName: "Backup 5", url: "https://backup5.dumbnguyen5555.workers.dev" },
];

const CORS = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Methods": "GET,HEAD,POST,PATCH,DELETE,OPTIONS",
  "Access-Control-Allow-Headers": "*",
};

const MAX_ITEMS = 180;
const MAX_GENERAL_ARCHIVE = 120;
const MAX_CACHE = 200;
const MAX_EMOJIS = 250;
const MAX_SCRIPTS = 150;
const MAX_ANNOUNCES = 500;
const MAX_PUNISH = 250;
const MAX_USER_WARNS = 50;
const MAX_SEEN_MSGS = 400;
const MAX_GROUPS = 200;
const MAX_FEEDBACKS = 200;
const MAX_PROFILES = 600;
const REQS_KEEP = 500;
const LINE_MAX = 1800;
const REACT_MAX = 64;
const DEFAULT_GENERAL_CH = "";

const REFRESH_MS = 10000;
const BOSS_PULL_MS = 12000;
const BOSS_PUSH_IDLE_MS = 45000;
const MIGRATE_TO_TTL_MS = 300000;
const PEER_PULL_MS = 15000;
const STATE_KEY = "cb42:state";
const STATE_KEYS = {
  mod: "cb42:st:mod",
  scripts: "cb42:st:scripts",
  profiles: "cb42:st:profiles",
  chat: "cb42:st:chat",
  meta: "cb42:st:meta",
};
const STATE_PART_NAMES = ["mod", "scripts", "profiles", "chat"];
const STATE_TTL = 10000;
const STATE_DEBOUNCE = 3000;

const EPHEMERAL = new Set(["typing"]);
const SKIP_HISTORY = new Set(["presence", "typing", "seen", "req_presence", "roles_part", "pin", "announce", "bot_perms", "lockdown", "profile_sync", "profile_del", "profile_review"]);
const MUTE_BLOCK = new Set(["msg", "edit", "react", "poll", "poll_vote", "script_post", "script_edit", "script_react", "script_comment"]);
const RATE_TYPES = new Set(["msg", "edit", "react", "poll", "poll_vote", "poll_close", "delete", "script_post", "script_edit", "script_react", "script_comment", "group_sync", "feedback"]);
const SEND_BLOCK = new Set(["roles", "roles_part", "request_result", "request", "emoji_sync", "script_del", "pin", "announce", "bot_perms", "feedback_reply", "lockdown", "profile_sync", "profile_del", "profile_review"]);

// ============================================================================
// 2. BỘ NHỚ TRẠNG THÁI TOÀN CỤC (G) & CÁC HÀM TIỆN ÍCH
// ============================================================================

const G = {
  items: [],
  byPid: new Map(),
  idx: new Map(),
  polls: new Map(),
  pres: new Map(),
  offAt: new Map(),
  profiles: new Map(),
  profSeq: 0,
  profMsgMap: new Map(),
  profClearedAt: new Map(),
  profReviews: new Map(),
  profPendingKeys: new Set(),
  whInfoCache: new Map(),
  profChannelId: "",
  profWhId: "",
  profLastSyncAt: 0,
  profSyncing: null,
  waiters: new Set(),
  mutes: new Map(),
  warns: new Map(),
  banned: new Map(),
  reqs: new Map(),
  rate: new Map(),
  roles: null,
  rolesSeq: 0,
  rolePartBuf: new Map(),
  emojis: [],
  emojiSeq: 0,
  scripts: [],
  scriptSeq: 0,
  announces: [],
  announceSeq: 0,
  generalArchive: [],
  generalSeq: 0,
  countedPids: new Set(),
  deletedIds: new Set(),
  punishments: [],
  modSeq: 0,
  seenBy: new Map(),
  seenSeq: 0,
  groups: new Map(),
  groupSeq: 0,
  feedbacks: new Map(),
  feedbackSeq: 0,
  lockdown: { active: false, by: "", reason: "", ts: 0, seq: 0 },
  lockdownSeq: 0,

  seq: 0,
  ready: false,
  lastRefresh: 0,
  refreshing: null,
  backoffUntil: 0,
  lastDid: "",
  rolesLoadedAt: 0,

  // Đồng bộ Mesh với các Backup Workers còn lại & Đánh thức Boss Server (Render.com)
  lastBossPullAt: 0,
  bossPulling: null,
  lastBossPushAt: 0,
  lastPeerPushAt: 0,
  lastPeerPullAt: 0,
  bossOk: false,
  migrateTo: "",
  migrateToUntil: 0,
  selfHost: "",
  proxyId: "b1",
  proxyName: "Backup 1",

  // Lưu trữ Store (DO HUB tách 5 khóa / KV / Cache API)
  store: undefined,
  stateInit: false,
  stateTs: 0,
  stateDirty: false,
  dirtyParts: new Set(),
  stateTimer: false,
  stateTimerAt: 0,
  stateFail: 0,
  stateSyncAt: 0,
  stateSyncing: null,
  cacheSnapAt: 0,

  dataQ: [],
  dataTimer: false,
  dataTimerAt: 0,
  presSyncAt: new Map(),
  devKey: "",
  devCache: new Set(),
  bgCtx: null,
  quota: { day: "", inboundDay: 0, rpmWin: [], bossSyncDay: 0, limit: 100000 },
  started: Date.now(),
};

const nowSec = () => Math.floor(Date.now() / 1000);
const sleep = (ms) => new Promise((r) => setTimeout(r, ms));
const utcDayStr = () => new Date().toISOString().slice(0, 10);

function ensureQuotaDay() {
  const day = utcDayStr();
  if (G.quota.day !== day) {
    G.quota.day = day;
    G.quota.inboundDay = 0;
    G.quota.bossSyncDay = 0;
    G.quota.rpmWin = [];
  }
}

function trackInboundQuota() {
  ensureQuotaDay();
  const now = Date.now();
  G.quota.inboundDay++;
  G.quota.rpmWin.push(now);
  while (G.quota.rpmWin.length > 0 && now - G.quota.rpmWin[0] > 60000) G.quota.rpmWin.shift();
}

function getQuotaSnapshot() {
  ensureQuotaDay();
  const now = Date.now();
  while (G.quota.rpmWin.length > 0 && now - G.quota.rpmWin[0] > 60000) G.quota.rpmWin.shift();
  return {
    day: G.quota.day,
    inboundDay: G.quota.inboundDay,
    inboundRpm: G.quota.rpmWin.length,
    bossSyncDay: G.quota.bossSyncDay,
    limit: G.quota.limit || 100000,
  };
}

const bg = (ctx, p) => {
  const q = Promise.resolve(p).catch(() => {});
  const c = ctx || G.bgCtx;
  try {
    if (c && typeof c.waitUntil === "function") c.waitUntil(q);
  } catch (e) {}
};

const clientIp = (req) => {
  const h = req && req.headers;
  if (!h || typeof h.get !== "function") return "x";
  const xff = h.get("cf-connecting-ip") || h.get("x-real-ip") || h.get("x-forwarded-for") || h.get("fly-client-ip") || "x";
  return String(xff).split(",")[0].trim() || "x";
};

const resolveEnv = (env) => {
  const base = env && typeof env === "object" ? env : {};
  let proc = {};
  try {
    if (typeof process !== "undefined" && process.env) proc = process.env;
  } catch (e) {}
  const merged = { ...proc, ...base };
  return {
    ...merged,
    DATA_CH: merged.DATA_CH || DEFAULT_DATA_CH,
    ROLES_CH: merged.ROLES_CH || DEFAULT_ROLES_CH,
    GENERAL_CH: merged.GENERAL_CH || DEFAULT_GENERAL_CH,
    DEVELOPERS: merged.DEVELOPERS || DEFAULT_DEVELOPERS,
    BOSS_URL: merged.BOSS_URL || DEFAULT_BOSS_URL,
    PROFILE_WEBHOOK: merged.PROFILE_WEBHOOK || DEFAULT_PROFILE_WEBHOOK,
    PROFILE_BOT_TOKEN: merged.PROFILE_BOT_TOKEN || DEFAULT_PROFILE_BOT_TOKEN,
    PROFILE_CH: merged.PROFILE_CH || "",
  };
};

function getBossUrl(env) {
  const raw = String((env && env.BOSS_URL) || DEFAULT_BOSS_URL).trim().replace(/\/+$/, "");
  return /^https?:\/\//i.test(raw) ? raw : "";
}

function getBackupPeers(env) {
  const customRaw = String((env && (env.BACKUP_WORKERS || env.PEER_WORKERS)) || "")
    .split(/[\s,]+/)
    .map((x) => x.trim().replace(/\/+$/, ""))
    .filter((x) => /^https?:\/\//i.test(x));
  const list =
    customRaw.length > 0
      ? customRaw.map((url, idx) => ({ id: `b${idx + 1}`, shortName: `Backup ${idx + 1}`, url }))
      : DEFAULT_BACKUP_WORKERS.map((b) => ({ ...b, url: b.url.replace(/\/+$/, "") }));
  return list.filter((b) => {
    if (b.id === G.proxyId) return false;
    if (G.selfHost && b.url.toLowerCase().includes(G.selfHost.toLowerCase())) return false;
    return true;
  });
}

function computeSyncKey(env) {
  const raw = String((env && (env.SYNC_SECRET || env.BOT_TOKEN)) || "").trim().replace(/^Bot\s+/i, "");
  if (!raw) return "";
  let h1 = 0x811c9dc5;
  let h2 = 0x01000193;
  for (let i = 0; i < raw.length; i++) {
    const c = raw.charCodeAt(i);
    h1 ^= c;
    h1 = Math.imul(h1, 0x01000193) >>> 0;
    h2 ^= c ^ (i & 0xff);
    h2 = Math.imul(h2, 0x811c9dc5) >>> 0;
  }
  return "cb45_" + h1.toString(16).padStart(8, "0") + h2.toString(16).padStart(8, "0");
}

function verifySyncAuth(req, url, env) {
  const expected = computeSyncKey(env);
  if (!expected) return true;
  const h = req && req.headers;
  const headerKey = String((h && typeof h.get === "function" ? h.get("x-boss-auth") : h?.["x-boss-auth"]) || "").trim();
  const queryKey = String(url.searchParams.get("key") || "").trim();
  return headerKey === expected || queryKey === expected;
}

function detectProxyIdentity(hostname) {
  const h = String(hostname || "").toLowerCase();
  if (!h) return;
  G.selfHost = h;
  if (h.includes("cb-roblox.")) {
    G.proxyId = "b1";
    G.proxyName = "Backup 1";
  } else if (h.startsWith("backup.")) {
    G.proxyId = "b2";
    G.proxyName = "Backup 2";
  } else if (h.startsWith("backupv2.")) {
    G.proxyId = "b3";
    G.proxyName = "Backup 3";
  } else if (h.startsWith("backupv3.")) {
    G.proxyId = "b4";
    G.proxyName = "Backup 4";
  } else if (h.startsWith("backup5.")) {
    G.proxyId = "b5";
    G.proxyName = "Backup 5";
  } else {
    G.proxyId = "b1";
    G.proxyName = "Backup 1";
  }
}

function json(data, status = 200) {
  return new Response(JSON.stringify(data), {
    status,
    headers: { ...CORS, "Content-Type": "application/json", "Cache-Control": "no-store" },
  });
}

function clip(s, n) {
  const a = Array.from(String(s ?? ""));
  return a.length > n ? a.slice(0, n - 1).join("") + "…" : a.join("");
}

const cleanName = (s) => String(s || "").trim().slice(0, 40);
const isSystemActor = (name, pkt = null) => {
  const ln = String(name || "").trim().toLowerCase();
  if (!ln || ln === "?" || ln === "discordbot" || ln === "discord" || ln === "system") return true;
  if (pkt && Number(pkt.uid) === 1 && String(pkt.display || "").startsWith("[Discord]")) return true;
  return false;
};
const cleanEmojiName = (s) => {
  const cleaned = String(s || "").trim().replace(/^:+|:+$/g, "").replace(/[^A-Za-z0-9_-]/g, "_").slice(0, 24);
  return cleaned || "emoji";
};

const VALID_PT_MODES = new Set(["solid", "gradient", "mesh", "glass", "image"]);
const VALID_PT_FONTS = new Set(["gotham", "sans", "mono", "rounded", "fantasy", "arcade", "scifi", "patrick"]);
const VALID_PT_FITS = new Set(["crop", "fit", "stretch", "tile"]);
const VALID_PT_ICON_FITS = new Set(["crop", "fit", "stretch"]);
const VALID_PT_ASPECTS = new Set(["auto", "1:1", "16:9", "4:3", "3:4", "9:16", "21:9"]);
const VALID_PT_DECS = new Set(["none", "chroma", "flame", "cyber", "frost", "gold", "void", "sakura", "emerald", "crimson", "sunset", "aurora", "rgb", "custom"]);
const VALID_PT_RANIMS = new Set(["none", "spin", "pulse", "rainbow"]);
const VALID_PT_NEFFS = new Set(["solid", "gradient", "neon", "gold", "ice", "cyber", "flame", "sakura", "aurora", "rgb", "custom"]);
const VALID_PT_NANIMS = new Set(["none", "shimmer", "pulse", "rainbow"]);
const VALID_PT_WIDGETS = new Set(["bio", "scripts", "game", "stats", "music"]);
function cleanHex(v) {
  return /^#[0-9a-fA-F]{6}$/.test(String(v || "")) ? String(v).toUpperCase() : "";
}
function clampPtInt(v, min, max, def) {
  if (v === undefined || v === null || v === "") return undefined;
  const n = Number(v);
  if (!Number.isFinite(n)) return def;
  return Math.max(min, Math.min(max, Math.round(n)));
}
function clampPtNum(v, min, max, def, prec = 10) {
  if (v === undefined || v === null || v === "") return undefined;
  const n = Number(v);
  if (!Number.isFinite(n)) return def;
  return Math.round(Math.max(min, Math.min(max, n)) * prec) / prec;
}
function sanitizeProfTheme(raw, fallback = null) {
  if (raw === null || raw === "") return null;
  if (!raw || typeof raw !== "object") return fallback;
  const out = {};
  const bg = cleanHex(raw.bg);
  const acc = cleanHex(raw.acc);
  const txt = cleanHex(raw.txt);
  const g1 = cleanHex(raw.g1);
  const g2 = cleanHex(raw.g2);
  const g3 = cleanHex(raw.g3);
  const bgImg = clip(String(raw.bgImg || "").replace(/[^0-9]/g, ""), 16);
  const mode = VALID_PT_MODES.has(String(raw.mode || "")) ? String(raw.mode) : "";
  const font = VALID_PT_FONTS.has(String(raw.font || "")) ? String(raw.font) : "";
  if (bg) out.bg = bg;
  if (acc) out.acc = acc;
  if (txt) out.txt = txt;
  if (g1) out.g1 = g1;
  if (g2) out.g2 = g2;
  if (g3) out.g3 = g3;
  if (bgImg) out.bgImg = bgImg;
  if (mode) out.mode = mode;
  if (font) out.font = font;
  const gRot = clampPtInt(raw.gRot, 0, 360, 0);
  const gMix = clampPtInt(raw.gMix, 15, 100, 65);
  const rad = clampPtInt(raw.rad, 3, 16, 10);
  const bgOp = clampPtInt(raw.bgOp, 15, 100, 82);
  const bgDim = clampPtInt(raw.bgDim, 0, 75, 25);
  if (gRot !== undefined) out.gRot = gRot;
  if (gMix !== undefined) out.gMix = gMix;
  if (rad !== undefined) out.rad = rad;
  if (raw.glow !== undefined) out.glow = Boolean(raw.glow);
  if (bgOp !== undefined) out.bgOp = bgOp;
  if (bgDim !== undefined) out.bgDim = bgDim;

  // Image framing (banner, avatar icon, card wallpaper)
  if (VALID_PT_FITS.has(String(raw.bf || ""))) out.bf = String(raw.bf);
  const bz = clampPtInt(raw.bz, 100, 300, 100);
  const bx = clampPtInt(raw.bx, -100, 100, 0);
  const by = clampPtInt(raw.by, -100, 100, 0);
  const bh = clampPtInt(raw.bh, 64, 150, 96);
  if (bz !== undefined) out.bz = bz;
  if (bx !== undefined) out.bx = bx;
  if (by !== undefined) out.by = by;
  if (VALID_PT_ASPECTS.has(String(raw.ba || ""))) out.ba = String(raw.ba);
  if (bh !== undefined) out.bh = bh;

  if (VALID_PT_ICON_FITS.has(String(raw.if || ""))) out.if = String(raw.if);
  const iz = clampPtInt(raw.iz, 100, 300, 100);
  const ix = clampPtInt(raw.ix, -100, 100, 0);
  const iy = clampPtInt(raw.iy, -100, 100, 0);
  const ir = clampPtInt(raw.ir, 0, 50, 50);
  if (iz !== undefined) out.iz = iz;
  if (ix !== undefined) out.ix = ix;
  if (iy !== undefined) out.iy = iy;
  if (VALID_PT_ASPECTS.has(String(raw.ia || ""))) out.ia = String(raw.ia);
  if (ir !== undefined) out.ir = ir;

  if (VALID_PT_FITS.has(String(raw.wf || ""))) out.wf = String(raw.wf);
  const wz = clampPtInt(raw.wz, 100, 300, 100);
  const wx = clampPtInt(raw.wx, -100, 100, 0);
  const wy = clampPtInt(raw.wy, -100, 100, 0);
  if (wz !== undefined) out.wz = wz;
  if (wx !== undefined) out.wx = wx;
  if (wy !== undefined) out.wy = wy;
  if (VALID_PT_ASPECTS.has(String(raw.wa || ""))) out.wa = String(raw.wa);

  // Discord-like profile cosmetics & Board widgets
  if (VALID_PT_DECS.has(String(raw.avDec || ""))) out.avDec = String(raw.avDec);
  const rc1 = cleanHex(raw.rc1);
  const rc2 = cleanHex(raw.rc2);
  const rc3 = cleanHex(raw.rc3);
  if (rc1) out.rc1 = rc1;
  if (rc2) out.rc2 = rc2;
  if (rc3) out.rc3 = rc3;
  const rw = clampPtInt(raw.rw, 1, 6, 3);
  const rrot = clampPtInt(raw.rrot, 0, 360, 35);
  if (rw !== undefined) out.rw = rw;
  if (rrot !== undefined) out.rrot = rrot;
  if (raw.rglow === false || raw.rglow === true) out.rglow = Boolean(raw.rglow);
  if (VALID_PT_RANIMS.has(String(raw.ranim || ""))) out.ranim = String(raw.ranim);
  if (VALID_PT_NEFFS.has(String(raw.nEff || ""))) out.nEff = String(raw.nEff);
  const nc1 = cleanHex(raw.nc1);
  const nc2 = cleanHex(raw.nc2);
  const nc3 = cleanHex(raw.nc3);
  const nsc = cleanHex(raw.nsc);
  if (nc1) out.nc1 = nc1;
  if (nc2) out.nc2 = nc2;
  if (nc3) out.nc3 = nc3;
  if (nsc) out.nsc = nsc;
  const nsw = clampPtNum(raw.nsw, 0, 3, 1, 10);
  const nrot = clampPtInt(raw.nrot, 0, 360, 15);
  if (nsw !== undefined) out.nsw = nsw;
  if (nrot !== undefined) out.nrot = nrot;
  if (raw.nglow === false || raw.nglow === true) out.nglow = Boolean(raw.nglow);
  if (VALID_PT_NANIMS.has(String(raw.nanim || ""))) out.nanim = String(raw.nanim);
  if (raw.mHide === true) out.mHide = true;
  if (typeof raw.tag === "string") {
    const cleanTag = clip(raw.tag.replace(/[\r\n\t`]+/g, " ").trim(), 36);
    if (cleanTag) out.tag = cleanTag;
  }
  if (typeof raw.pinSc === "string") {
    const cleanPin = clip(raw.pinSc.replace(/[^a-zA-Z0-9_-]/g, ""), 48);
    if (cleanPin) out.pinSc = cleanPin;
  }
  if (typeof raw.wOrder === "string") {
    const parts = raw.wOrder
      .split(",")
      .map((s) => s.trim().toLowerCase())
      .filter((s) => VALID_PT_WIDGETS.has(s));
    const uniq = [];
    for (const p of parts) if (!uniq.includes(p)) uniq.push(p);
    if (uniq.length > 0) out.wOrder = clip(uniq.join(","), 40);
  }
  if (typeof raw.abLbl === "string") {
    const cleanAb = clip(raw.abLbl.replace(/[\r\n\t]+/g, " ").trim(), 40);
    if (cleanAb) out.abLbl = cleanAb;
  }
  if (typeof raw.hiTxt === "string") {
    const cleanHi = clip(raw.hiTxt.replace(/[\r\n\t]+/g, " ").trim(), 70);
    if (cleanHi) out.hiTxt = cleanHi;
  }
  if (typeof raw.music === "string") {
    const cleanMusic = clip(raw.music.replace(/[\r\n\t]+/g, ",").trim(), 160);
    if (cleanMusic) out.music = cleanMusic;
  }

  return Object.keys(out).length > 0 ? out : fallback;
}

const snowMs = (id) => {
  try { return Number((BigInt(id) >> 22n) + 1420070400000n); } catch (e) { return 0; }
};
const cmpId = (a, b) => {
  try { const x = BigInt(a), y = BigInt(b); return x < y ? -1 : x > y ? 1 : 0; } catch (e) { return 0; }
};

// ============================================================================
// 3. PHÂN QUYỀN, ROLE, MUTE, BAN & RATE LIMITER
// ============================================================================

function devSet(env) {
  const raw = String(env.DEVELOPERS || DEFAULT_DEVELOPERS);
  if (G.devKey !== raw) {
    G.devKey = raw;
    G.devCache = new Set(raw.split(",").map((x) => x.trim().toLowerCase()).filter(Boolean));
  }
  return G.devCache;
}
const devNames = (env) => [...devSet(env)].filter((x) => !/^\d+$/.test(x));
function isDev(env, name) {
  return !!name && devSet(env).has(String(name).toLowerCase());
}

function userRoleList(name) {
  const r = G.roles;
  if (!name || !r || !Array.isArray(r.roles) || !r.assign) return [];
  if (G._roleCacheSeq !== G.rolesSeq || !G._roleUserMap) {
    G._roleCacheSeq = G.rolesSeq;
    const byId = new Map();
    for (const roleObj of r.roles) if (roleObj && roleObj.id) byId.set(roleObj.id, roleObj);
    const uMap = new Map();
    for (const k of Object.keys(r.assign)) {
      const lnKey = k.toLowerCase();
      const a = r.assign[k];
      const list = typeof a === "string" ? [a] : Array.isArray(a) ? a : a && typeof a === "object" ? Object.keys(a).filter((x) => a[x]) : [];
      let set = uMap.get(lnKey);
      if (!set) { set = new Set(); uMap.set(lnKey, set); }
      for (const id of list) if (byId.has(id)) set.add(byId.get(id));
    }
    G._roleUserMap = uMap;
  }
  const matched = G._roleUserMap.get(String(name).toLowerCase());
  return matched ? [...matched] : [];
}

const isAdminName = (name) => userRoleList(name).some((r) => r.isAdmin === true);
const isStaffName = (env, name) => isDev(env, name) || isAdminName(name);
const canAnnounceName = (env, name) =>
  isStaffName(env, name) ||
  userRoleList(name).some((r) => r.canAnnounce === true || /tester|test|dev|admin|mod|owner|staff|log/i.test(String(r.name || "")));

function assignKeyOf(name) {
  if (!G.roles || !G.roles.assign) return null;
  const ln = String(name || "").toLowerCase();
  for (const k of Object.keys(G.roles.assign)) if (k.toLowerCase() === ln) return k;
  return null;
}

function dropAssign(name) {
  if (!G.roles || !G.roles.assign) return false;
  const ln = String(name || "").toLowerCase();
  let hit = false;
  for (const k of Object.keys(G.roles.assign)) {
    if (k.toLowerCase() === ln) {
      delete G.roles.assign[k];
      hit = true;
    }
  }
  return hit;
}

function isBanned(name) {
  if (!name) return null;
  const k = String(name).toLowerCase();
  const b = G.banned.get(k);
  if (!b) return null;
  if (b.exp > 0 && b.exp <= nowSec()) {
    G.banned.delete(k);
    return null;
  }
  return b;
}

function mutedNow(name) {
  if (!name) return null;
  const k = String(name).toLowerCase();
  const m = G.mutes.get(k);
  if (!m) return null;
  if (m.exp > 0 && m.exp <= nowSec()) {
    G.mutes.delete(k);
    return null;
  }
  return m;
}

function limited(key, max, ms) {
  const t = Date.now();
  const a = (G.rate.get(key) || []).filter((x) => t - x < ms);
  a.push(t);
  G.rate.set(key, a);
  if (G.rate.size > 3000) {
    for (const [k, v] of G.rate) if (!v.length || t - v[v.length - 1] > 60000) G.rate.delete(k);
  }
  return a.length > max;
}

// ============================================================================
// 4. LƯU TRỮ TRẠNG THÁI CLOUDFLARE (DO HUB / KV / CACHE API)
// ============================================================================

function parseContent(content) {
  if (typeof content !== "string") return null;
  for (const p of PREFIXES) {
    if (content.startsWith(p)) {
      try {
        const o = JSON.parse(content.slice(p.length));
        return o && typeof o === "object" ? o : null;
      } catch (e) {
        return null;
      }
    }
  }
  return null;
}

function initStore(env, ctx) {
  if (G.store !== undefined) return;
  if (ctx && ctx.storage && typeof ctx.storage.get === "function") {
    G.store = { kind: "do", get: (k) => ctx.storage.get(k), put: (k, v) => ctx.storage.put(k, v) };
  } else if (env.FEED && typeof env.FEED.get === "function") {
    G.store = {
      kind: "kv",
      get: async (k) => {
        const raw = await env.FEED.get(k);
        return raw ? JSON.parse(raw) : undefined;
      },
      put: (k, v) => env.FEED.put(k, JSON.stringify(v)),
    };
  } else if (typeof caches !== "undefined" && caches && caches.default && typeof caches.default.match === "function") {
    G.store = {
      kind: "cache",
      get: async (k) => {
        try {
          const r = await caches.default.match("https://cb45-state.internal/" + encodeURIComponent(k));
          return r && r.ok ? await r.json() : undefined;
        } catch (e) {
          return undefined;
        }
      },
      put: async (k, v) => {
        try {
          await caches.default.put(
            "https://cb45-state.internal/" + encodeURIComponent(k),
            new Response(JSON.stringify(v), {
              headers: { "Content-Type": "application/json", "Cache-Control": "public, max-age=86400" },
            })
          );
        } catch (e) {}
      },
    };
  } else {
    G.store = null;
  }
}

function upsertProfile(src, opts = {}) {
  if (!src || typeof src !== "object") return null;
  const u = cleanName(src.u || src.author || src.by || "");
  if (!u || isSystemActor(u, src)) return null;
  const uKey = u.toLowerCase();
  const prev = G.profiles.get(uKey) || {};
  const allowClear = opts.allowClear === true;
  const isOffline = opts.offline === true;
  const forceReset = opts.forceReset === true;
  const rawTs = Number(src.lastSeen || src.ts) || nowSec();
  if (forceReset) {
    const clearedTs = Math.max(G.profClearedAt.get(uKey) || 0, rawTs);
    G.profClearedAt.set(uKey, clearedTs);
    while (G.profClearedAt.size > 400) G.profClearedAt.delete(G.profClearedAt.keys().next().value);
    const resetEntry = {
      u: prev.u && prev.u !== "?" ? prev.u : u,
      d: prev.u && prev.u !== "?" ? prev.u : u,
      id: Number(src.id ?? src.uid) || Number(prev.id) || 0,
      st: "",
      bio: "",
      c: "??",
      pb: "",
      pi: "",
      pt: null,
      sg: false,
      pl: 0,
      gn: "",
      jb: "",
      proxyId: prev.proxyId || G.proxyId,
      proxyName: prev.proxyName || G.proxyName,
      mc: Number(prev.mc) || 0,
      lastSeen: Number(prev.lastSeen) || rawTs,
      ts: rawTs,
    };
    G.profiles.delete(uKey);
    G.profiles.set(uKey, resetEntry);
    while (G.profiles.size > MAX_PROFILES) G.profiles.delete(G.profiles.keys().next().value);
    G.profSeq = Math.max(Date.now(), (G.profSeq || 0) + 1);
    return resetEntry;
  }
  const clearedAt = G.profClearedAt.get(uKey) || 0;
  if (clearedAt > 0 && rawTs <= clearedAt) {
    return prev.u ? prev : null;
  }
  const prevTs = Number(prev.ts || prev.lastSeen) || 0;
  const nextTs = Math.max(prevTs, rawTs);
  const preferSrc = allowClear || rawTs >= prevTs;
  const incomingId = Number(src.id ?? src.uid) || 0;
  const prevId = Number(prev.id) || 0;
  const pickStr = (key, maxLen, isDigits) => {
    const hasSrc = src[key] !== undefined && src[key] !== null;
    if (hasSrc) {
      let s = String(src[key]);
      if (isDigits) s = s.replace(/[^0-9]/g, "");
      s = clip(s, maxLen);
      if (allowClear && preferSrc) return s;
      if (s && (preferSrc || !prev[key])) return s;
    }
    return prev[key] || "";
  };
  let nextPt = prev.pt || null;
  if (src.pt !== undefined) {
    if (src.pt && typeof src.pt === "object") {
      const cleaned = sanitizeProfTheme(src.pt, allowClear ? null : nextPt);
      if (cleaned && (allowClear || preferSrc || !nextPt)) nextPt = cleaned;
      else if (!cleaned && allowClear && preferSrc) nextPt = null;
    } else if ((src.pt === null || src.pt === "") && allowClear && preferSrc) {
      nextPt = null;
    }
  }
  const nextD = clip(
    (preferSrc && src.d && src.d !== "?") ? src.d : (prev.d && prev.d !== "?") ? prev.d : (src.display && src.display !== "?") ? src.display : u,
    40
  );
  const sg = src.sg !== undefined ? Boolean(src.sg) : (Number(src.pl) > 0 ? true : prev.sg || false);
  const nextEntry = {
    u: (prev.u && prev.u !== "?" && !preferSrc) ? prev.u : u,
    d: nextD || u,
    id: (preferSrc && incomingId > 1) ? incomingId : (prevId > 1 ? prevId : (incomingId > 0 ? incomingId : prevId)),
    st: pickStr("st", 80, false),
    bio: pickStr("bio", 180, false),
    c: (() => {
      const nc = src.c ? clip(src.c, 3) : "";
      if (nc && nc !== "??" && (preferSrc || !prev.c || prev.c === "??")) return nc;
      return prev.c || nc || "??";
    })(),
    pb: pickStr("pb", 16, true),
    pi: pickStr("pi", 16, true),
    pt: nextPt,
    sg,
    pl: Number(src.pl) || prev.pl || 0,
    gn: clip(src.gn || prev.gn || "", 60),
    jb: isOffline ? "" : clip(src.jb || prev.jb || "", 64),
    proxyId: src.proxyId && src.proxyId !== "boss" ? src.proxyId : prev.proxyId || G.proxyId,
    proxyName: src.proxyName && !String(src.proxyName).includes("Boss") ? src.proxyName : prev.proxyName || G.proxyName,
    mc: Math.max(Number(prev.mc) || 0, Number(src.mc) || 0),
    lastSeen: nextTs,
    ts: nextTs,
  };
  G.profiles.delete(uKey);
  G.profiles.set(uKey, nextEntry);
  while (G.profiles.size > MAX_PROFILES) {
    let evictKey = null;
    for (const [k, v] of G.profiles) {
      if (!hasCustomProfileData(v)) {
        evictKey = k;
        break;
      }
    }
    if (!evictKey) evictKey = G.profiles.keys().next().value;
    if (!evictKey) break;
    G.profiles.delete(evictKey);
  }
  if (allowClear || hasCustomProfileData(nextEntry)) {
    G.profSeq = Math.max(Date.now(), (G.profSeq || 0) + 1);
  }
  return nextEntry;
}

function isUserOfflineAt(uKey, ts) {
  const uk = String(uKey || "").toLowerCase();
  if (!uk) return false;
  const offTs = G.offAt.get(uk) || 0;
  return offTs > 0 && (Number(ts) || 0) <= offTs;
}

function markUserOffline(uRaw, ts = nowSec(), extra = null) {
  const u = cleanName(uRaw || (extra && extra.u) || "");
  if (!u || isSystemActor(u, extra)) return 0;
  const uKey = u.toLowerCase();
  const cur = G.pres.get(uKey);
  const offTs = Number(ts) || nowSec();
  const curLiveTs = cur ? Number(cur.ts) || 0 : 0;
  if (cur && curLiveTs > offTs) return 0;
  const effTs = Math.max(offTs, Number(G.offAt.get(uKey)) || 0);
  G.offAt.delete(uKey);
  G.offAt.set(uKey, effTs);
  while (G.offAt.size > 600) G.offAt.delete(G.offAt.keys().next().value);
  upsertProfile({ ...(cur || {}), ...(extra || {}), u, sg: false, jb: "", lastSeen: effTs, ts: effTs }, { allowClear: false, offline: true });
  if (cur && effTs >= curLiveTs) {
    G.pres.delete(uKey);
  }
  return effTs;
}

function prunePresenceMap(nowS = nowSec(), keepUserKey = "") {
  let pruned = false;
  for (const [pk, pv] of G.pres) {
    if (!pv || isUserOfflineAt(pk, pv.ts) || (pk !== keepUserKey && nowS - (Number(pv.ts) || 0) > PRESENCE_TTL)) {
      if (pv) upsertProfile({ ...pv, sg: false, jb: "" }, { allowClear: false, offline: true });
      G.pres.delete(pk);
      pruned = true;
    }
  }
  return pruned;
}

function mergeLockdownState(inc, incSeq = 0) {
  if (!inc || typeof inc !== "object") return false;
  const ts = Number(inc.ts) || 0;
  const seq = Math.max(Number(incSeq) || 0, Number(inc.seq) || 0, ts > 0 ? ts * 1000 : 0);
  const curTs = Number(G.lockdown && G.lockdown.ts) || 0;
  const curSeq = Math.max(Number(G.lockdownSeq) || 0, Number(G.lockdown && G.lockdown.seq) || 0, curTs > 0 ? curTs * 1000 : 0);
  const nextActive = Boolean(inc.active);
  const nextBy = cleanName(inc.by || "");
  const nextReason = clip(String(inc.reason || ""), 200);
  if (seq > curSeq || (seq === curSeq && nextActive !== Boolean(G.lockdown && G.lockdown.active))) {
    const changed =
      nextActive !== Boolean(G.lockdown && G.lockdown.active) ||
      nextBy !== String((G.lockdown && G.lockdown.by) || "") ||
      nextReason !== String((G.lockdown && G.lockdown.reason) || "") ||
      ts !== curTs;
    G.lockdown = {
      active: nextActive,
      by: nextBy,
      reason: nextReason,
      ts: ts || (nextActive ? nowSec() : 0),
      seq,
    };
    G.lockdownSeq = seq;
    return changed;
  }
  return false;
}

function mergeSeenByMap(rawSeenBy, incomingSeq = 0) {
  if (!rawSeenBy || typeof rawSeenBy !== "object") return false;
  let seenUpdated = false;
  const nowS = nowSec();
  for (const [rawMid, vmap] of Object.entries(rawSeenBy)) {
    const mid = String(rawMid || "").trim().slice(0, 64);
    if (!mid || G.deletedIds.has(mid) || !vmap || typeof vmap !== "object") continue;
    const cur = G.seenBy.get(mid) || {};
    let midChanged = false;
    for (const [rawViewer, rawTs] of Object.entries(vmap)) {
      const viewer = cleanName(rawViewer);
      if (!viewer || isSystemActor(viewer)) continue;
      const vLow = viewer.toLowerCase();
      const exKey = Object.keys(cur).find((k) => k.toLowerCase() === vLow);
      const nTs = Number(rawTs) || nowS;
      if (exKey) {
        if (nTs > (Number(cur[exKey]) || 0)) {
          cur[exKey] = nTs;
          midChanged = true;
          seenUpdated = true;
        }
      } else if (Object.keys(cur).length < 60) {
        cur[viewer] = nTs;
        midChanged = true;
        seenUpdated = true;
      }
    }
    if (midChanged || !G.seenBy.has(mid)) {
      if (Object.keys(cur).length > 0) {
        G.seenBy.delete(mid);
        G.seenBy.set(mid, cur);
        while (G.seenBy.size > MAX_SEEN_MSGS) G.seenBy.delete(G.seenBy.keys().next().value);
      }
    }
  }
  const rSeq = Number(incomingSeq) || 0;
  if (seenUpdated) {
    G.seenSeq = Math.max(Date.now(), G.seenSeq + 1, rSeq);
  } else if (rSeq > G.seenSeq) {
    G.seenSeq = rSeq;
  }
  return seenUpdated;
}

function getRecentProfilesForSync(limit = 60) {
  const arr = [];
  for (const [, p] of G.profiles) {
    if (p && p.u && !isSystemActor(p.u, p)) arr.push(p);
  }
  arr.sort((a, b) => {
    const aCust = hasCustomProfileData(a) ? 1 : 0;
    const bCust = hasCustomProfileData(b) ? 1 : 0;
    if (aCust !== bCust) return bCust - aCust;
    return (Number(b.ts || b.lastSeen) || 0) - (Number(a.ts || a.lastSeen) || 0);
  });
  const out = {};
  for (const p of arr.slice(0, limit)) {
    out[String(p.u).toLowerCase()] = p;
  }
  return out;
}

function mergeProfilesSync(s) {
  if (!s || typeof s !== "object") return false;
  let changed = false;
  if (s.offAt && typeof s.offAt === "object") {
    for (const [k, v] of Object.entries(s.offAt)) {
      const uk = String(k || "").toLowerCase();
      const ts = Number(v) || 0;
      if (!uk || ts <= 0) continue;
      const curLive = G.pres.get(uk);
      const curLiveTs = curLive ? Number(curLive.ts) || 0 : 0;
      if (curLive && curLiveTs > ts) continue;
      if (ts > (G.offAt.get(uk) || 0)) {
        G.offAt.delete(uk);
        G.offAt.set(uk, ts);
        while (G.offAt.size > 600) G.offAt.delete(G.offAt.keys().next().value);
      }
      if (curLive && curLiveTs <= ts) {
        upsertProfile({ ...curLive, sg: false, jb: "", lastSeen: ts, ts }, { allowClear: false, offline: true });
        G.pres.delete(uk);
        changed = true;
      }
    }
  }
  if (s.profReviews && typeof s.profReviews === "object") {
    for (const [k, rv] of Object.entries(s.profReviews)) {
      if (!rv || typeof rv !== "object") continue;
      const uk = String(k || rv.u || "").toLowerCase();
      if (!uk) continue;
      const rTs = Number(rv.ts) || 0;
      const curRv = G.profReviews.get(uk);
      const nextU = cleanName(rv.u || k) || k;
      const nextStatus = String(rv.status || "pending");
      const nextBy = String(rv.by || "");
      const nextReason = clip(String(rv.reason || ""), 200);
      const curTs = curRv ? Number(curRv.ts) || 0 : -1;
      if (!curRv || rTs > curTs || (rTs === curTs && (curRv.status !== nextStatus || curRv.by !== nextBy || curRv.reason !== nextReason))) {
        G.profReviews.set(uk, {
          u: nextU,
          status: nextStatus,
          by: nextBy,
          reason: nextReason,
          ts: rTs,
        });
        if (nextStatus === "approved" && rTs >= (G.profClearedAt.get(uk) || 0)) {
          G.profClearedAt.delete(uk);
        }
        changed = true;
      }
    }
  }
  if (s.profClearedAt && typeof s.profClearedAt === "object") {
    const profList = Array.isArray(s.profiles)
      ? s.profiles
      : s.profiles && typeof s.profiles === "object"
        ? Object.values(s.profiles)
        : [];
    for (const [k, v] of Object.entries(s.profClearedAt)) {
      const ts = Number(v) || 0;
      const uk = String(k || "").toLowerCase();
      if (!uk || ts <= (G.profClearedAt.get(uk) || 0)) continue;
      const curRv = G.profReviews.get(uk);
      if (curRv && curRv.status === "approved" && (Number(curRv.ts) || 0) > ts) continue;
      const curProf = G.profiles.get(uk);
      if (curProf && (Number(curProf.ts) || 0) > ts && hasCustomProfileData(curProf)) continue;
      const snapProf = profList.find((p) => p && String(p.u || "").toLowerCase() === uk);
      if (snapProf && (Number(snapProf.ts) || 0) > ts && hasCustomProfileData(snapProf)) continue;
      G.profClearedAt.set(uk, ts);
      upsertProfile({ u: k, ts }, { forceReset: true });
      if (G.pres.has(uk)) {
        Object.assign(G.pres.get(uk), { d: cleanName(k) || k, st: "", bio: "", c: "??", pb: "", pi: "", pt: null });
      }
      changed = true;
    }
  }
  if (s.profiles && typeof s.profiles === "object") {
    const entries = Array.isArray(s.profiles) ? s.profiles : Object.values(s.profiles);
    for (const v of entries) {
      if (v && typeof v === "object" && v.u) {
        const uk = String(v.u).toLowerCase();
        upsertProfile(v, { allowClear: false, offline: !G.pres.has(uk) });
      }
    }
  }
  const incProfSeq = Number(s.profSeq) || 0;
  if (incProfSeq > (G.profSeq || 0)) G.profSeq = incProfSeq;
  return changed;
}

function bumpProfileMsgCount(author, pid, pkt) {
  const u = cleanName(author || "");
  if (!u || u === "?") return 0;
  const pKey = pid ? String(pid) : "";
  const uKey = u.toLowerCase();
  if (pKey && G.countedPids.has(pKey)) {
    const existing = G.profiles.get(uKey) || G.pres.get(uKey);
    return Number(existing && existing.mc) || 0;
  }
  if (pKey) {
    G.countedPids.add(pKey);
    if (G.countedPids.size > 1200) G.countedPids.delete(G.countedPids.keys().next().value);
  }
  const cur = G.profiles.get(uKey) || G.pres.get(uKey) || {};
  const nextMc = Math.max((Number(cur.mc) || 0) + 1, Number(pkt && pkt.mc) || 0);
  upsertProfile({
    u,
    d: (pkt && pkt.display) || cur.d || u,
    id: Number(pkt && pkt.uid) || cur.id || 0,
    pl: Number(pkt && pkt.place) || cur.pl || 0,
    gn: (pkt && pkt.gameName) || cur.gn || "",
    mc: nextMc,
    ts: Number(pkt && pkt.ts) || nowSec(),
  }, { allowClear: false });
  const live = G.pres.get(uKey);
  if (live) live.mc = Math.max(Number(live.mc) || 0, nextMc);
  return nextMc;
}

function buildPublicProfile(uKey) {
  const nowS = nowSec();
  prunePresenceMap(nowS);
  const live = G.pres.get(uKey);
  const prof = G.profiles.get(uKey);
  if (live && !isUserOfflineAt(uKey, live.ts) && nowS - (Number(live.ts) || 0) <= PRESENCE_TTL) {
    const mergedProf = upsertProfile(live, { allowClear: false }) || prof || {};
    const mergedOut = {
      ...mergedProf,
      ...live,
      d: live.d && live.d !== "?" ? live.d : mergedProf.d || live.u,
      st: live.st || mergedProf.st || "",
      bio: live.bio || mergedProf.bio || "",
      c: live.c && live.c !== "??" ? live.c : mergedProf.c || "??",
      pb: live.pb || mergedProf.pb || "",
      pi: live.pi || mergedProf.pi || "",
      pt: live.pt && typeof live.pt === "object" && Object.keys(live.pt).length ? live.pt : mergedProf.pt || null,
      mc: Math.max(Number(live.mc) || 0, Number(mergedProf.mc) || 0),
      online: true,
      lastSeen: Number(live.ts) || nowS,
    };
    return {
      online: true,
      profile: mergedOut,
    };
  }
  if (prof) {
    return {
      online: false,
      profile: {
        ...prof,
        sg: false,
        jb: "",
        online: false,
        lastSeen: Number(prof.lastSeen || prof.ts) || 0,
      },
    };
  }
  for (let i = G.scripts.length - 1; i >= 0; i--) {
    const sc = G.scripts[i];
    if (sc && String(sc.author || "").toLowerCase() === uKey) {
      const seeded = upsertProfile({ u: sc.author, d: sc.display || sc.author, id: sc.uid || 0, pl: sc.placeId || 0, gn: sc.gameName || "", ts: sc.ts || nowS }, { allowClear: false, offline: true });
      if (seeded) return { online: false, profile: { ...seeded, sg: false, jb: "", online: false } };
    }
  }
  for (const fb of G.feedbacks.values()) {
    if (fb && String(fb.author || "").toLowerCase() === uKey) {
      const seeded = upsertProfile({ u: fb.author, d: fb.display || fb.author, id: fb.uid || 0, pl: fb.placeId || 0, gn: fb.gameName || "", ts: fb.ts || nowS }, { allowClear: false, offline: true });
      if (seeded) return { online: false, profile: { ...seeded, sg: false, jb: "", online: false } };
    }
  }
  for (let i = G.items.length - 1; i >= 0; i--) {
    const it = G.items[i];
    if (!it || typeof it.content !== "string") continue;
    const pkt = parseContent(it.content);
    if (!pkt) continue;
    const aName = cleanName(pkt.author || pkt.by || "");
    if (!aName || aName.toLowerCase() !== uKey || isSystemActor(aName, pkt)) continue;
    const seeded = upsertProfile({ u: aName, d: pkt.display || aName, id: pkt.uid || 0, pl: pkt.place || 0, gn: pkt.gameName || "", ts: Number(pkt.ts) || Math.floor((Number(it.seq) || 0) / 1000) || nowS }, { allowClear: false, offline: true });
    if (seeded) return { online: false, profile: { ...seeded, sg: false, jb: "", online: false } };
  }
  return { online: false, profile: null };
}

function snapshotStatePart(partName) {
  if (partName === "mod") {
    return {
      roles: G.roles,
      rolesSeq: G.rolesSeq,
      mutes: Object.fromEntries(G.mutes),
      warns: Object.fromEntries(G.warns),
      banned: Object.fromEntries(G.banned),
      reqs: Object.fromEntries([...G.reqs.entries()].slice(-REQS_KEEP)),
      punishments: G.punishments,
      modSeq: G.modSeq,
      lockdown: G.lockdown,
      lockdownSeq: G.lockdownSeq,
      deletedIds: [...G.deletedIds].slice(-1000),
    };
  }
  if (partName === "scripts") {
    return {
      scripts: G.scripts,
      scriptSeq: G.scriptSeq,
      emojis: G.emojis,
      emojiSeq: G.emojiSeq,
    };
  }
  if (partName === "profiles") {
    return {
      profiles: Object.fromEntries([...G.profiles.entries()].slice(-MAX_PROFILES)),
      profSeq: G.profSeq,
      profClearedAt: Object.fromEntries([...G.profClearedAt.entries()].slice(-100)),
      profReviews: Object.fromEntries([...G.profReviews.entries()].slice(-300)),
      offAt: Object.fromEntries([...G.offAt.entries()].slice(-300)),
    };
  }
  if (partName === "chat") {
    return {
      generalArchive: G.generalArchive.filter((x) => x && x.pid && !G.deletedIds.has(String(x.pid))).slice(-MAX_GENERAL_ARCHIVE),
      generalSeq: G.generalSeq,
      announces: G.announces,
      announceSeq: G.announceSeq,
      groups: Object.fromEntries([...G.groups.entries()].slice(-MAX_GROUPS)),
      groupSeq: G.groupSeq,
      feedbacks: Object.fromEntries([...G.feedbacks.entries()].slice(-MAX_FEEDBACKS)),
      feedbackSeq: G.feedbackSeq,
      seenBy: Object.fromEntries([...G.seenBy.entries()].slice(-MAX_SEEN_MSGS)),
      seenSeq: G.seenSeq,
    };
  }
  return { ts: G.stateTs };
}

function snapshotState() {
  // Bỏ lưu `pres` (TTL 75s, chỉ giữ trên RAM G.pres) để giảm mạnh dung lượng serialize & storage
  return {
    ts: G.stateTs,
    ...snapshotStatePart("mod"),
    ...snapshotStatePart("scripts"),
    ...snapshotStatePart("profiles"),
    ...snapshotStatePart("chat"),
  };
}

function applyStateSnapshot(s) {
  if (!s || typeof s !== "object") return;
  const rin = s.roles;
  if (rin && typeof rin === "object" && Array.isArray(rin.roles)) {
    const seq = Number(rin.seq || s.rolesSeq) || 0;
    if (seq >= G.rolesSeq) {
      G.roles = rin;
      G.rolesSeq = seq;
    }
  }
  if (Array.isArray(s.deletedIds)) {
    for (const id of s.deletedIds) {
      if (id) {
        const sid = String(id);
        G.deletedIds.add(sid);
        G.seenBy.delete(sid);
      }
    }
  }
  const now = nowSec();
  if (s.mutes && typeof s.mutes === "object") {
    for (const [k, v] of Object.entries(s.mutes)) {
      if (v && (!v.exp || v.exp > now)) G.mutes.set(k.toLowerCase(), v);
    }
  }
  if (s.warns && typeof s.warns === "object") {
    for (const [k, v] of Object.entries(s.warns)) {
      if (Array.isArray(v) && v.length) G.warns.set(k.toLowerCase(), v);
    }
  }
  if (s.banned && typeof s.banned === "object") {
    for (const [k, v] of Object.entries(s.banned)) {
      if (v && (!v.exp || v.exp > now)) G.banned.set(k.toLowerCase(), v);
    }
  }
  if (Array.isArray(s.emojis)) {
    const es = Number(s.emojiSeq) || 0;
    if (es >= G.emojiSeq) {
      G.emojis = s.emojis;
      G.emojiSeq = es;
    }
  }
  if (Array.isArray(s.scripts)) {
    const ss = Number(s.scriptSeq) || 0;
    if (ss >= G.scriptSeq) {
      for (const sc of s.scripts) if (sc && !Array.isArray(sc.comments)) sc.comments = [];
      G.scripts = s.scripts;
      G.scriptSeq = ss;
    }
  }
  if (Array.isArray(s.announces)) {
    const as = Number(s.announceSeq) || 0;
    if (as >= G.announceSeq) {
      G.announces = s.announces.filter((x) => x && x.packetId && !G.deletedIds.has(String(x.packetId)));
      G.announceSeq = as;
    }
  }
  if (Array.isArray(s.punishments)) {
    const ms = Number(s.modSeq) || 0;
    if (ms >= G.modSeq) {
      G.punishments = s.punishments.filter((x) => x && x.id && !G.deletedIds.has(String(x.id)));
      G.modSeq = ms;
    }
  }
  if (s.seenBy && typeof s.seenBy === "object") {
    if (mergeSeenByMap(s.seenBy, s.seenSeq)) notify();
  }
  if (s.groups && typeof s.groups === "object") {
    const gs = Number(s.groupSeq) || 0;
    if (gs >= G.groupSeq) {
      for (const [k, v] of Object.entries(s.groups)) {
        if (v && typeof v === "object" && v.id) G.groups.set(k, v);
      }
      G.groupSeq = gs;
    }
  }
  if (s.feedbacks && typeof s.feedbacks === "object") {
    const fbs = Number(s.feedbackSeq) || 0;
    if (fbs >= G.feedbackSeq) {
      for (const [k, v] of Object.entries(s.feedbacks)) {
        if (v && typeof v === "object" && v.id) G.feedbacks.set(k, v);
      }
      G.feedbackSeq = fbs;
    }
  }
  if (s.lockdown && typeof s.lockdown === "object") {
    if (mergeLockdownState(s.lockdown, s.lockdownSeq)) notify();
  }
  const genList = Array.isArray(s.generalArchive) ? s.generalArchive : Array.isArray(s.generalItems) ? s.generalItems : null;
  if (genList) {
    const gs = Number(s.generalSeq) || 0;
    if (gs > G.generalSeq) G.generalSeq = gs;
    for (const gi of genList) {
      if (!gi || typeof gi !== "object" || typeof gi.c !== "string") continue;
      const pkt = parseContent(gi.c);
      if (!pkt || !pkt.type) continue;
      const pid = String(pkt.packetId || gi.pid || "");
      if (pid && G.deletedIds.has(pid)) continue;
      insert(pkt, gi.c, null, false, Number(gi.seq) || Number(pkt._s) || 0);
    }
  }
  mergeProfilesSync(s);
  if (s.pres && typeof s.pres === "object") {
    for (const [k, v] of Object.entries(s.pres)) {
      const uk = String(k || (v && v.u) || "").toLowerCase();
      if (!uk || !v || typeof v !== "object") continue;
      const vTs = Number(v.ts) || 0;
      const offNow = isUserOfflineAt(uk, vTs) || now - vTs > PRESENCE_TTL;
      upsertProfile(v, { allowClear: false, offline: offNow });
      if (!offNow) {
        const cur = G.pres.get(uk);
        if (!cur || vTs >= (Number(cur.ts) || 0)) {
          G.pres.set(uk, v);
        }
      }
    }
  }
  prunePresenceMap(now);
  if (s.reqs && typeof s.reqs === "object") {
    for (const [k, v] of Object.entries(s.reqs)) {
      if (v) G.reqs.set(k.toLowerCase(), v);
    }
  }
}

const CACHE_STATE_URL = "https://cb45-state.internal/kvsnap/" + encodeURIComponent(STATE_KEY);

async function cacheStatePut(snap) {
  try {
    if (typeof caches === "undefined" || !caches || !caches.default) return;
    await caches.default.put(
      CACHE_STATE_URL,
      new Response(JSON.stringify(snap), {
        headers: { "Content-Type": "application/json", "Cache-Control": "public, max-age=900" },
      })
    );
  } catch (e) {}
}

async function cacheStateGet() {
  try {
    if (typeof caches === "undefined" || !caches || !caches.default) return undefined;
    const r = await caches.default.match(CACHE_STATE_URL);
    return r && r.ok ? await r.json() : undefined;
  } catch (e) {
    return undefined;
  }
}

async function syncState(env, ctx, force) {
  if (!G.store) return;
  if (G.store.kind === "do" && G.stateInit && !force) return;
  if (!force && Date.now() - G.stateSyncAt < (G.store.kind === "do" ? STATE_TTL : 3500)) return;
  if (G.stateSyncing) return G.stateSyncing;
  G.stateSyncing = (async () => {
    try {
      if (G.store.kind === "do") {
        // Đọc song song 5 khóa tách biệt trên Durable Object HUB
        const [metaObj, modObj, scriptsObj, profilesObj, chatObj] = await Promise.all([
          G.store.get(STATE_KEYS.meta),
          G.store.get(STATE_KEYS.mod),
          G.store.get(STATE_KEYS.scripts),
          G.store.get(STATE_KEYS.profiles),
          G.store.get(STATE_KEYS.chat),
        ]);
        const hasSplit = Boolean(
          (metaObj && typeof metaObj === "object") ||
            (modObj && typeof modObj === "object") ||
            (scriptsObj && typeof scriptsObj === "object") ||
            (profilesObj && typeof profilesObj === "object") ||
            (chatObj && typeof chatObj === "object")
        );
        if (hasSplit) {
          const rts = Number(metaObj && metaObj.ts) || 0;
          if (!G.stateInit || rts > G.stateTs) {
            // Nạp `mod` trước để có `deletedIds` lọc chính xác `chat` (generalArchive/announces/seenBy)
            if (modObj && typeof modObj === "object") applyStateSnapshot(modObj);
            if (scriptsObj && typeof scriptsObj === "object") applyStateSnapshot(scriptsObj);
            if (profilesObj && typeof profilesObj === "object") applyStateSnapshot(profilesObj);
            if (chatObj && typeof chatObj === "object") applyStateSnapshot(chatObj);
            if (rts > G.stateTs) G.stateTs = rts;
          }
        } else {
          // Migration an toàn: nếu chưa có 5 khóa mới thì đọc fallback từ `cb42:state` cũ để giữ nguyên 100% dữ liệu
          const legacy = await G.store.get(STATE_KEY);
          if (legacy && typeof legacy === "object") {
            const rts = Number(legacy.ts) || 0;
            applyStateSnapshot(legacy);
            if (rts > G.stateTs) G.stateTs = rts;
            saveStateSoon(ctx, 1500, "all");
          }
        }
        G.stateInit = true;
        return;
      }
      if (G.store.kind === "kv") {
        const cs = await cacheStateGet();
        const cts = cs && typeof cs === "object" ? Number(cs.ts) || 0 : 0;
        if (cts > G.stateTs) {
          applyStateSnapshot(cs);
          G.stateTs = cts;
          G.stateInit = true;
        }
      }
      const s = await G.store.get(STATE_KEY);
      if (s && typeof s === "object") {
        const rts = Number(s.ts) || 0;
        if (!G.stateInit || rts > G.stateTs || G.store.kind !== "do") {
          applyStateSnapshot(s);
          if (rts > G.stateTs) G.stateTs = rts;
        }
      }
      G.stateInit = true;
    } catch (e) {
    } finally {
      G.stateSyncAt = Date.now();
      G.stateSyncing = null;
    }
  })();
  return G.stateSyncing;
}

function markDirtyParts(partName = "all") {
  if (Array.isArray(partName)) {
    let added = false;
    for (const p of partName) {
      if (STATE_PART_NAMES.includes(p)) {
        G.dirtyParts.add(p);
        added = true;
      }
    }
    if (!added) for (const p of STATE_PART_NAMES) G.dirtyParts.add(p);
  } else if (typeof partName === "string" && STATE_PART_NAMES.includes(partName)) {
    G.dirtyParts.add(partName);
  } else {
    for (const p of STATE_PART_NAMES) G.dirtyParts.add(p);
  }
}

function saveStateSoon(ctx, customDelayMs = 0, partName = "all") {
  markDirtyParts(partName);
  G.stateDirty = true;
  if (!G.store) return;
  const t = Date.now();
  const isDo = G.store.kind === "do";
  const isKv = G.store.kind === "kv";
  const baseWait = isKv
    ? customDelayMs > 0
      ? Math.max(1200, customDelayMs)
      : Math.max(18000, STATE_DEBOUNCE)
    : Math.max(STATE_DEBOUNCE, customDelayMs || 0);
  if ((isKv || G.store.kind === "cache") && t - (G.cacheSnapAt || 0) >= (customDelayMs > 0 && customDelayMs <= 2000 ? 400 : 2000)) {
    G.cacheSnapAt = t;
    G.stateTs = Math.max(t, G.stateTs + 1);
    bg(ctx, cacheStatePut(snapshotState()));
  }
  if (G.stateTimer && t - G.stateTimerAt < baseWait + 8000) return;
  G.stateTimer = true;
  G.stateTimerAt = t;
  bg(
    ctx,
    (async () => {
      await sleep(baseWait);
      G.stateTimer = false;
      G.stateDirty = false;
      const partsToSave = new Set(G.dirtyParts);
      G.dirtyParts.clear();
      if (partsToSave.size === 0) return;
      G.stateTs = Math.max(Date.now(), G.stateTs + 1);
      try {
        if (isDo) {
          // Chỉ `storage.put` đúng các khóa bị thay đổi + khóa meta nhẹ (không chạm vào các phần không đổi)
          const writes = [];
          for (const p of partsToSave) {
            if (STATE_KEYS[p]) writes.push(G.store.put(STATE_KEYS[p], snapshotStatePart(p)));
          }
          writes.push(G.store.put(STATE_KEYS.meta, { ts: G.stateTs }));
          await Promise.all(writes);
        } else {
          const snap = snapshotState();
          await G.store.put(STATE_KEY, snap);
          if (isKv) await cacheStatePut(snap);
        }
        G.stateFail = 0;
      } catch (e) {
        for (const p of partsToSave) G.dirtyParts.add(p);
        G.stateDirty = true;
        G.stateFail++;
        if (G.stateFail < 6 && G.dirtyParts.size > 0) bg(ctx, sleep(2000).then(() => saveStateSoon(ctx, 0, [...G.dirtyParts])));
        else G.stateDirty = false;
        return;
      }
      if (G.dirtyParts.size > 0) saveStateSoon(ctx, 0, [...G.dirtyParts]);
    })()
  );
}

// ============================================================================
// 4B. KHO LƯU TRỮ DATA PROFILE VĨNH VIỄN TRÊN DISCORD (OFFLINE FULL THEME)
// ============================================================================

async function resolveWebhookInfo(url) {
  if (!url) return null;
  const cleanUrl = url.split("?")[0];
  if (G.whInfoCache.has(cleanUrl)) return G.whInfoCache.get(cleanUrl);
  try {
    const r = await fetch(cleanUrl, { method: "GET", headers: { Accept: "application/json" } });
    if (r.ok) {
      const info = await r.json();
      if (info && info.id) {
        G.whInfoCache.set(cleanUrl, info);
        return info;
      }
    }
  } catch (e) {}
  return null;
}

function getProfileWebhook(env) {
  return String((env && env.PROFILE_WEBHOOK) || DEFAULT_PROFILE_WEBHOOK).trim().split("?")[0];
}

function getProfileBotToken(env) {
  return String((env && (env.PROFILE_BOT_TOKEN || env.BOT_TOKEN)) || DEFAULT_PROFILE_BOT_TOKEN)
    .trim()
    .replace(/^Bot\s+/i, "");
}

async function dProfFetch(env, apiPath, method = "GET", body = undefined) {
  const primary = getProfileBotToken(env);
  const fallback = String((env && env.BOT_TOKEN) || "").trim().replace(/^Bot\s+/i, "");
  const tokens = [primary];
  if (fallback && fallback !== primary) tokens.push(fallback);
  for (const tk of tokens) {
    if (!tk) continue;
    const init = {
      method,
      headers: {
        Authorization: `Bot ${tk}`,
        "Content-Type": "application/json",
        "User-Agent": "DiscordBot (https://cb-roblox.workers.dev, 46.0)",
      },
    };
    if (body !== undefined) init.body = typeof body === "string" ? body : JSON.stringify(body);
    try {
      const r = await fetch("https://discord.com/api/v10/" + apiPath, init);
      if ((r.status === 401 || r.status === 403) && tokens.length > 1 && tk === primary) continue;
      return r;
    } catch (e) {}
  }
  return null;
}

async function resolveProfileChannelInfo(env) {
  if (G.profChannelId) return { chId: G.profChannelId, whId: G.profWhId };
  const whUrl = getProfileWebhook(env);
  const info = await resolveWebhookInfo(whUrl);
  if (info && info.channel_id) {
    G.profChannelId = String(info.channel_id);
    G.profWhId = String(info.id || "");
  } else if (env && env.PROFILE_CH) {
    G.profChannelId = String(env.PROFILE_CH).trim();
  }
  return { chId: G.profChannelId, whId: G.profWhId };
}

function buildProfileCloudRecord(prof) {
  if (!prof || typeof prof !== "object") return null;
  const u = cleanName(prof.u || "");
  if (!u || u === "?") return null;
  const pt = prof.pt && typeof prof.pt === "object" ? sanitizeProfTheme(prof.pt, null) : null;
  return {
    v: 1,
    u,
    d: clip(prof.d || u, 40),
    id: Number(prof.id) || 0,
    st: clip(prof.st || "", 80),
    bio: clip(prof.bio || "", 180),
    c: clip(prof.c || "??", 3),
    pb: clip(String(prof.pb || "").replace(/[^0-9]/g, ""), 16),
    pi: clip(String(prof.pi || "").replace(/[^0-9]/g, ""), 16),
    ...(pt && Object.keys(pt).length ? { pt } : {}),
    mc: Number(prof.mc) || 0,
    pl: Number(prof.pl) || 0,
    gn: clip(prof.gn || "", 60),
    lastSeen: Number(prof.lastSeen || prof.ts) || nowSec(),
    ts: Number(prof.ts || prof.lastSeen) || nowSec(),
  };
}

function profileContentSig(rec) {
  if (!rec) return "";
  return JSON.stringify({
    u: rec.u,
    d: rec.d,
    id: rec.id,
    st: rec.st,
    bio: rec.bio,
    c: rec.c,
    pb: rec.pb,
    pi: rec.pi,
    pt: rec.pt || null,
  });
}

function hasCustomProfileData(rec) {
  if (!rec) return false;
  if (rec.pb || rec.pi || rec.bio || rec.st) return true;
  if (rec.pt && typeof rec.pt === "object" && Object.keys(rec.pt).length > 0) return true;
  if (rec.c && rec.c !== "??") return true;
  if (rec.d && rec.u && rec.d !== rec.u) return true;
  return false;
}

function buildProfileCloudLine(uKey, rec) {
  const copy = { ...rec };
  let line = `${PROF_PREFIX}${uKey}:${JSON.stringify(copy)}`;
  if (line.length > 1950) {
    copy.gn = clip(copy.gn || "", 24);
    line = `${PROF_PREFIX}${uKey}:${JSON.stringify(copy)}`;
  }
  if (line.length > 1950) {
    copy.bio = clip(copy.bio || "", 100);
    line = `${PROF_PREFIX}${uKey}:${JSON.stringify(copy)}`;
  }
  return line.slice(0, 1980);
}

function buildProfileCloudEmbed(rec) {
  const pt = rec.pt || {};
  const accHex = cleanHex(pt.acc);
  const color = accHex ? parseInt(accHex.slice(1), 16) : 0x5865f2;
  const themeSummary = [
    `Mode: \`${pt.mode || "solid"}\``,
    pt.bg ? `Bg: \`${pt.bg}\`` : "",
    pt.acc ? `Acc: \`${pt.acc}\`` : "",
    pt.txt ? `Txt: \`${pt.txt}\`` : "",
    pt.font ? `Font: \`${pt.font}\`` : "",
    pt.avDec && pt.avDec !== "none" ? `Ring: \`${pt.avDec}${pt.ranim && pt.ranim !== "none" ? `/${pt.ranim}` : ""}\`` : "",
    pt.nEff && pt.nEff !== "solid" ? `NameFX: \`${pt.nEff}${pt.nanim && pt.nanim !== "none" ? `/${pt.nanim}` : ""}\`` : "",
  ].filter(Boolean).join(" • ");

  const fields = [
    { name: "👤 Tài khoản", value: `**${rec.d || rec.u}** (\`@${rec.u}\` • UID: \`${rec.id || 0}\` • Quốc gia: \`${rec.c || "??"}\`)`, inline: false },
  ];
  if (pt.abLbl || pt.hiTxt) {
    fields.push({
      name: "📝 Board Custom Labels",
      value: `${pt.abLbl ? `• Nhãn mục: \`${pt.abLbl}\`\n` : ""}${pt.hiTxt ? `• Lời chào: **${pt.hiTxt}**` : ""}`.trim(),
      inline: false,
    });
  }
  if (rec.st || pt.tag) {
    fields.push({
      name: "💬 Trạng thái & Flair",
      value: `${rec.st ? `Status: *${rec.st}*` : ""}${rec.st && pt.tag ? " • " : ""}${pt.tag ? `Flair: \`${pt.tag}\`` : ""}`,
      inline: false,
    });
  }
  if (rec.bio) {
    fields.push({ name: "📖 Tiểu sử (Bio)", value: clip(rec.bio, 250), inline: false });
  }
  fields.push({
    name: "🎨 Theme & Ảnh Profile",
    value: clip(
      `${themeSummary}\nBanner: \`${rec.pb || "none"}\` • Icon: \`${rec.pi || "none"}\` • Wallpaper: \`${pt.bgImg || "none"}\``,
      950
    ),
    inline: false,
  });

  return {
    title: `🪪 Hồ sơ Đám mây: ${rec.d || rec.u} (@${rec.u})`,
    color,
    fields,
    footer: { text: `CB47 Profile Data • Kiểm duyệt thủ công qua Dashboard Bot Discord • key=${rec.u.toLowerCase()}` },
    timestamp: new Date((Number(rec.ts) || nowSec()) * 1000).toISOString(),
  };
}

function parseProfileCloudMsg(m) {
  if (!m || typeof m !== "object" || typeof m.content !== "string") return null;
  for (const line of m.content.split("\n")) {
    if (!line.startsWith(PROF_PREFIX)) continue;
    try {
      const rest = line.slice(PROF_PREFIX.length);
      const colonIdx = rest.indexOf(":");
      const jsonStr = colonIdx !== -1 && rest[0] !== "{" ? rest.slice(colonIdx + 1) : rest;
      const obj = JSON.parse(jsonStr);
      if (!obj || typeof obj !== "object" || !obj.u) continue;
      const u = cleanName(obj.u);
      if (!u || u === "?") continue;
      const uKey = u.toLowerCase();
      const msgTs = Math.floor(Date.parse(m.timestamp || "") / 1000) || Math.floor(snowMs(m.id) / 1000) || nowSec();
      const rec = buildProfileCloudRecord({ ...obj, u, ts: Number(obj.ts) || msgTs, lastSeen: Number(obj.lastSeen) || msgTs });
      if (!rec) continue;
      return {
        uKey,
        rec,
        msgId: String(m.id || ""),
        chId: String(m.channel_id || ""),
        whId: String(m.webhook_id || ""),
        msgTs,
      };
    } catch (e) {}
  }
  return null;
}

async function syncProfilesFromDiscordChannel(env, ctx, isColdBoot = false, force = false) {
  if (G.profSyncing) return G.profSyncing;
  const now = Date.now();
  if (!force && !isColdBoot && G.profLastSyncAt && now - G.profLastSyncAt < 15000) return 0;

  G.profSyncing = (async () => {
    try {
      const { chId } = await resolveProfileChannelInfo(env);
      if (!chId) return 0;
      const allMsgs = [];
      let reachedStart = false;
      let beforeId = "";
      const maxPages = isColdBoot || force ? 5 : 2;
      for (let pg = 0; pg < maxPages; pg++) {
        const qBefore = beforeId ? `&before=${beforeId}` : "";
        const rp = await dProfFetch(env, `channels/${chId}/messages?limit=100${qBefore}`, "GET");
        if (!rp || !rp.ok) {
          if (pg === 0) return 0;
          break;
        }
        const arrP = await rp.json();
        if (!Array.isArray(arrP) || !arrP.length) {
          reachedStart = true;
          break;
        }
        allMsgs.push(...arrP);
        if (arrP.length < 100) {
          reachedStart = true;
          break;
        }
        const sortedP = arrP.slice().sort((a, b) => cmpId(a.id, b.id));
        const nextBefore = sortedP[0] && sortedP[0].id;
        if (!nextBefore || nextBefore === beforeId) break;
        beforeId = nextBefore;
      }

      allMsgs.sort((a, b) => cmpId(a.id, b.id));
      const seenInScan = new Map();
      for (const m of allMsgs) {
        const parsed = parseProfileCloudMsg(m);
        if (!parsed) continue;
        seenInScan.set(parsed.uKey, parsed);
      }

      // Chỉ đồng bộ bổ sung (additive) — TUYỆT ĐỐI không tự động xóa dữ liệu Profile khi quét thiếu hoặc lệch tin nhắn Discord;
      // mọi thao tác kiểm duyệt/xóa Profile đều phải do Dev/Admin bấm thủ công trên Bot Discord.
      let touched = false;
      let count = 0;
      for (const [uKey, info] of seenInScan.entries()) {
        const clearedAt = G.profClearedAt.get(uKey) || 0;
        if (clearedAt > 0 && info.msgTs <= clearedAt && (Number(info.rec.ts) || 0) <= clearedAt) continue;
        const sig = profileContentSig(info.rec);
        upsertProfile(info.rec, { allowClear: false, offline: !G.pres.has(uKey) });
        if (!G.profReviews.has(uKey) && hasCustomProfileData(info.rec)) {
          G.profReviews.set(uKey, { u: info.rec.u, status: "pending", by: "", reason: "", ts: Number(info.rec.ts) || info.msgTs || nowSec() });
        }
        G.profMsgMap.set(uKey, {
          whMsgId: info.msgId,
          chId: info.chId || chId,
          u: info.rec.u,
          sig,
          updatedAt: Date.now(),
        });
        count++;
        touched = true;
      }
      if (touched) saveStateSoon(ctx, 0, "profiles");
      G.profLastSyncAt = Date.now();
      return count;
    } catch (e) {
      return 0;
    } finally {
      G.profSyncing = null;
    }
  })();

  return G.profSyncing;
}

async function saveProfileToDiscordCloud(env, ctx, profEntry, forceUpdate = false) {
  const rec = buildProfileCloudRecord(profEntry);
  if (!rec) return { ok: false, error: "invalid_profile" };
  const uKey = rec.u.toLowerCase();
  const sig = profileContentSig(rec);
  const existing = G.profMsgMap.get(uKey);
  if (!forceUpdate && existing && existing.sig === sig) {
    return { ok: true, unchanged: true };
  }
  if (!forceUpdate && !existing && !hasCustomProfileData(rec)) {
    return { ok: true, skipped: true };
  }

  if (!existing && G.profLastSyncAt === 0) {
    await syncProfilesFromDiscordChannel(env, ctx, false, true);
  }
  const curMap = G.profMsgMap.get(uKey);
  if (!forceUpdate && curMap && curMap.sig === sig) {
    return { ok: true, unchanged: true };
  }

  const whUrl = getProfileWebhook(env);
  if (!whUrl) return { ok: false, error: "no_profile_webhook" };
  const payload = {
    username: "CB47 Profile Storage",
    content: buildProfileCloudLine(uKey, rec),
    embeds: [buildProfileCloudEmbed(rec)],
    allowed_mentions: { parse: [] },
  };

  if (curMap && curMap.whMsgId) {
    try {
      const rPatch = await fetch(`${whUrl}/messages/${curMap.whMsgId}?wait=true`, {
        method: "PATCH",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(payload),
      });
      if (rPatch.ok) {
        const d = await rPatch.json().catch(() => ({}));
        G.profMsgMap.set(uKey, {
          whMsgId: String((d && d.id) || curMap.whMsgId),
          chId: String((d && d.channel_id) || curMap.chId || G.profChannelId),
          u: rec.u,
          sig,
          updatedAt: Date.now(),
        });
        return { ok: true, updated: true, whMsgId: String((d && d.id) || curMap.whMsgId) };
      }
      if (rPatch.status === 403 || rPatch.status === 404) {
        G.profMsgMap.delete(uKey);
      }
    } catch (e) {}
  }

  try {
    const rPost = await fetch(`${whUrl}?wait=true`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(payload),
    });
    if (rPost.ok) {
      const d = await rPost.json().catch(() => ({}));
      if (d && d.channel_id && !G.profChannelId) G.profChannelId = String(d.channel_id);
      if (d && d.id) {
        G.profMsgMap.set(uKey, {
          whMsgId: String(d.id),
          chId: String(d.channel_id || G.profChannelId),
          u: rec.u,
          sig,
          updatedAt: Date.now(),
        });
      }
      return { ok: true, created: true, whMsgId: String((d && d.id) || "") };
    }
  } catch (e) {}
  return { ok: false, error: "webhook_failed" };
}

function scheduleProfileCloudSave(env, ctx, profEntry) {
  if (!profEntry || !profEntry.u) return;
  const uKey = String(profEntry.u).toLowerCase();
  const clearedAt = G.profClearedAt.get(uKey) || 0;
  if (clearedAt > 0 && (Number(profEntry.ts) || 0) <= clearedAt) return;
  const rec = buildProfileCloudRecord(profEntry);
  if (!rec) return;
  const sig = profileContentSig(rec);
  const existing = G.profMsgMap.get(uKey);
  if (existing && existing.sig === sig) return;
  if (!existing && !hasCustomProfileData(rec)) return;
  if (G.profPendingKeys.has(uKey)) return;
  G.profPendingKeys.add(uKey);
  bg(
    ctx,
    saveProfileToDiscordCloud(env, ctx, profEntry, false)
      .catch(() => {})
      .finally(() => {
        G.profPendingKeys.delete(uKey);
      })
  );
}

async function deleteUserProfileData(env, ctx, target, actorName = "Admin", reason = "") {
  const cleanTarget = cleanName(target || "");
  if (!cleanTarget) return { ok: false, error: "u" };
  const uKey = cleanTarget.toLowerCase();
  const prevRv = G.profReviews.get(uKey);
  const prevProf = G.profiles.get(uKey);
  const ts = Math.max(nowSec(), (Number(prevRv && prevRv.ts) || 0) + 1, (Number(prevProf && prevProf.ts) || 0) + 1);

  const prevMap = G.profMsgMap.get(uKey);
  G.profMsgMap.delete(uKey);
  upsertProfile({ u: cleanTarget, ts }, { forceReset: true });
  if (G.pres.has(uKey)) {
    Object.assign(G.pres.get(uKey), { d: cleanTarget, st: "", bio: "", c: "??", pb: "", pi: "", pt: null });
  }

  const whUrl = getProfileWebhook(env);
  const { chId } = await resolveProfileChannelInfo(env);
  let deletedDiscordCount = 0;

  if (prevMap && prevMap.whMsgId) {
    try {
      const rDelWh = await fetch(`${whUrl}/messages/${prevMap.whMsgId}`, { method: "DELETE" });
      if (rDelWh.ok) deletedDiscordCount++;
    } catch (e) {}
    if (prevMap.chId || chId) {
      const rDelBot = await dProfFetch(env, `channels/${prevMap.chId || chId}/messages/${prevMap.whMsgId}`, "DELETE");
      if (rDelBot && rDelBot.ok) deletedDiscordCount++;
    }
  }

  if (chId) {
    try {
      const rList = await dProfFetch(env, `channels/${chId}/messages?limit=100`, "GET");
      if (rList && rList.ok) {
        const arr = await rList.json();
        if (Array.isArray(arr)) {
          for (const m of arr) {
            const parsed = parseProfileCloudMsg(m);
            if (parsed && parsed.uKey === uKey && m.id) {
              const rDel = await dProfFetch(env, `channels/${chId}/messages/${m.id}`, "DELETE");
              if (rDel && rDel.ok) deletedDiscordCount++;
            }
          }
        }
      }
    } catch (e) {}
  }

  const cleanReason = clip(String(reason || "Xóa dữ liệu Profile bởi Dev/Admin trên Discord"), 240);
  const cleanBy = cleanName(actorName || "Admin");
  G.profReviews.set(uKey, {
    u: cleanTarget,
    status: "cleared",
    by: cleanBy,
    reason: cleanReason,
    ts,
  });
  G.profSeq = Math.max(Date.now(), (G.profSeq || 0) + 1);
  emitPkt(env, ctx, {
    type: "profile_del",
    packetId: "pfd-" + uKey + "-" + ts + "-" + Math.random().toString(36).slice(2, 5),
    target: cleanTarget,
    by: cleanBy,
    reason: cleanReason,
    manual: true,
    chan: "punish",
    ts,
  });
  saveStateSoon(ctx, 0, "profiles");
  return { ok: true, target: cleanTarget, deletedDiscordCount };
}

function approveUserProfileReview(env, ctx, target, actorName = "Admin", reason = "") {
  const cleanTarget = cleanName(target || "");
  if (!cleanTarget) return { ok: false, error: "u" };
  const uKey = cleanTarget.toLowerCase();
  const prevRv = G.profReviews.get(uKey);
  const ts = Math.max(nowSec(), (Number(prevRv && prevRv.ts) || 0) + 1, (G.profClearedAt.get(uKey) || 0) + 1);
  const cleanBy = cleanName(actorName || "Admin");
  const cleanReason = clip(String(reason || "Đã duyệt / giải duyệt thủ công trên Discord"), 200);
  G.profClearedAt.delete(uKey);
  G.profReviews.set(uKey, {
    u: cleanTarget,
    status: "approved",
    by: cleanBy,
    reason: cleanReason,
    ts,
  });
  G.profSeq = Math.max(Date.now(), (G.profSeq || 0) + 1);
  emitPkt(env, ctx, {
    type: "profile_review",
    packetId: "pfr-" + uKey + "-" + ts + "-" + Math.random().toString(36).slice(2, 5),
    action: "approve",
    target: cleanTarget,
    by: cleanBy,
    reason: cleanReason,
    chan: "general",
    ts,
  });
  saveStateSoon(ctx, 0, "profiles");
  return { ok: true, target: cleanTarget, status: "approved", ts };
}

// ============================================================================
// 5. LIÊN KẾT MESH 5 SERVER BACKUP (`/api/peer-sync`) & ĐÁNH THỨC BOSS 24/7
// ============================================================================

/**
 * Phát sóng tức thì gói tin mới (`line`) và danh sách người chơi Online từ Server Backup này
 * sang 4 Server Backup còn lại (`POST /api/peer-sync`) VÀ báo về Server Boss (`POST /api/boss-sync`).
 * Chạy ngầm qua `ctx.waitUntil` để người chơi nhận phản hồi tức thì mà mọi Server vẫn liên kết 100%!
 */
function ingestLinesFromSync(env, ctx, lines) {
  if (!Array.isArray(lines)) return false;
  let added = false;
  for (const rawItem of lines) {
    const l = typeof rawItem === "string" ? rawItem : rawItem && typeof (rawItem.c || rawItem.line) === "string" ? (rawItem.c || rawItem.line) : "";
    if (!l || l.length < 8) continue;
    const pkt = parseContent(l);
    if (pkt && pkt.type) {
      const eph = EPHEMERAL.has(pkt.type);
      applyState(env, pkt, true, ctx);
      const item = insert(pkt, l, null, eph, Number(pkt._s) || 0);
      if (item) added = true;
    }
  }
  return added;
}

function broadcastMeshAndBossSoon(env, ctx, line = "") {
  const now = Date.now();
  const authKey = computeSyncKey(env);
  const nowS = nowSec();
  prunePresenceMap(nowS);
  const activeUsers = [...G.pres.values()].filter((u) => u && !isUserOfflineAt(u.u, u.ts) && nowS - (Number(u.ts) || 0) <= PRESENCE_TTL);

  // Gửi 1 request duy nhất về Boss.js trên Render.com (Render Free Tier KHÔNG giới hạn request!).
  // Boss.js sẽ tự động:
  //   1. Trả về danh sách người chơi Online toàn cụm + các gói tin mới từ các Backup khác.
  //   2. Chỉ đẩy (/api/peer-sync) sang những Server Backup nào ĐANG CÓ NGƯỜI CHƠI ONLINE (tiết kiệm 100% Cloudflare cho các Backup trống).
  // Chỉ khi Boss.js đang bảo trì/mất kết nối VÀ có gói tin mới (line) thì mới fallback đẩy P2P trực tiếp.
  const bossUrl = getBossUrl(env);
  if (bossUrl && (!G.selfHost || !bossUrl.toLowerCase().includes(G.selfHost.toLowerCase()))) {
    if (line || now - G.lastBossPushAt >= BOSS_PUSH_IDLE_MS) {
      G.lastBossPushAt = now;
      bg(
        ctx,
        (async () => {
          const ctrl = typeof AbortController === "function" ? new AbortController() : null;
          const timer = ctrl ? setTimeout(() => { try { ctrl.abort(); } catch (e) {} }, 4500) : null;
          let syncedViaBoss = false;
          try {
            ensureQuotaDay();
            G.quota.bossSyncDay++;
            const r = await fetch(`${bossUrl}/api/boss-sync`, {
              method: "POST",
              headers: {
                "Content-Type": "application/json",
                ...(authKey ? { "x-boss-auth": authKey } : {}),
              },
              body: JSON.stringify({
                proxyId: G.proxyId,
                proxyName: G.proxyName,
                users: activeUsers,
                offAt: Object.fromEntries([...G.offAt.entries()].slice(-160)),
                line: line || undefined,
                emojiSeq: G.emojiSeq,
                scriptSeq: G.scriptSeq,
                lockdown: G.lockdown,
                lockdownSeq: G.lockdownSeq,
                seenSeq: G.seenSeq,
                seenBy: Object.fromEntries([...G.seenBy.entries()].slice(-MAX_SEEN_MSGS)),
                profSeq: G.profSeq,
                profiles: getRecentProfilesForSync(40),
                profClearedAt: Object.fromEntries([...G.profClearedAt.entries()].slice(-100)),
                profReviews: Object.fromEntries([...G.profReviews.entries()].slice(-150)),
                quota: getQuotaSnapshot(),
              }),
              ...(ctrl ? { signal: ctrl.signal } : {}),
            });
            if (r.ok) {
              syncedViaBoss = true;
              G.bossOk = true;
              const d = await r.json();
              let changed = false;
              const dirty = new Set();
              if (d && typeof d.migrateTo === "string" && /^https?:\/\//i.test(d.migrateTo.trim())) {
                G.migrateTo = d.migrateTo.trim().replace(/\/+$/, "");
                G.migrateToUntil = Date.now() + MIGRATE_TO_TTL_MS;
              } else if (d && d.ok) {
                G.migrateTo = "";
                G.migrateToUntil = 0;
              }
              if (d && d.lockdown && typeof d.lockdown === "object") {
                if (mergeLockdownState(d.lockdown, d.lockdownSeq)) {
                  changed = true;
                  dirty.add("mod");
                }
              }
              if (d && mergeProfilesSync(d)) {
                changed = true;
                dirty.add("profiles");
              }
              if (d && Array.isArray(d.users)) {
                if (mergeRemoteUsers(d.users)) changed = true;
              }
              if (d && Array.isArray(d.recentItems)) {
                if (ingestLinesFromSync(env, ctx, d.recentItems)) {
                  changed = true;
                  dirty.add("chat");
                }
              }
              if (d && d.seenBy && typeof d.seenBy === "object") {
                if (mergeSeenByMap(d.seenBy, d.seenSeq)) {
                  changed = true;
                  dirty.add("chat");
                }
              }
              if (dirty.size > 0) {
                saveStateSoon(ctx, 1200, [...dirty]);
              }
              if (changed) {
                notify();
              }
              if (d && Number(d.stateTs) > G.stateTs) {
                await pullFromBoss(env, ctx, true);
              }
            }
          } catch (e) {
            G.bossOk = false;
          } finally {
            if (timer) clearTimeout(timer);
          }

          // Fallback P2P khẩn cấp: chỉ gọi khi Boss.js không phản hồi VÀ có tin nhắn mới cần phát sóng
          if (!syncedViaBoss && line) {
            const peers = getBackupPeers(env);
            for (const peer of peers) {
              try {
                await fetch(`${peer.url}/api/peer-sync`, {
                  method: "POST",
                  headers: {
                    "Content-Type": "application/json",
                    ...(authKey ? { "x-boss-auth": authKey } : {}),
                  },
                  body: JSON.stringify({
                    fromId: G.proxyId,
                    fromName: G.proxyName,
                    users: activeUsers,
                    offAt: Object.fromEntries([...G.offAt.entries()].slice(-160)),
                    line,
                    seenSeq: G.seenSeq,
                    seenBy: Object.fromEntries([...G.seenBy.entries()].slice(-MAX_SEEN_MSGS)),
                    lockdown: G.lockdown,
                    lockdownSeq: G.lockdownSeq,
                    profSeq: G.profSeq,
                    profiles: getRecentProfilesForSync(40),
                    profClearedAt: Object.fromEntries([...G.profClearedAt.entries()].slice(-100)),
                    profReviews: Object.fromEntries([...G.profReviews.entries()].slice(-150)),
                    stateTs: G.stateTs,
                  }),
                });
              } catch (e) {}
            }
          }
        })()
      );
    }
  }
}

function mergeRemoteUsers(users, fallbackProxyId = "b1", fallbackProxyName = "Backup 1") {
  if (!Array.isArray(users)) return false;
  const nowS = nowSec();
  let changed = false;
  for (const u of users) {
    if (!u || !u.u) continue;
    const uKey = String(u.u).toLowerCase();
    const uTs = Number(u.ts) || nowS;
    if (u.off === true || isUserOfflineAt(uKey, uTs)) {
      if (u.off === true) markUserOffline(u.u, uTs, u);
      continue;
    }
    const isExpired = nowS - uTs > PRESENCE_TTL;
    const savedProf = upsertProfile(u, { allowClear: false, offline: isExpired });
    if (isExpired) continue;
    const cur = G.pres.get(uKey) || {};
    const clearedAt = G.profClearedAt.get(uKey) || 0;
    const recentlyCleared = clearedAt > 0 && uTs <= clearedAt;
    if (recentlyCleared) continue;
    if (!cur.ts || uTs >= (Number(cur.ts) || 0)) {
      const fb = savedProf || cur;
      const rawPt = u.pt && typeof u.pt === "object" ? sanitizeProfTheme(u.pt, null) : null;
      const cleanC = u.c && u.c !== "??" ? u.c : fb.c || "??";
      G.offAt.delete(uKey);
      G.pres.set(uKey, {
        ...fb,
        ...u,
        u: cleanName(u.u),
        d: u.d && u.d !== "?" ? u.d : fb.d || cleanName(u.u),
        st: u.st ? clip(u.st, 80) : fb.st || "",
        bio: u.bio ? clip(u.bio, 180) : fb.bio || "",
        c: cleanC,
        pb: u.pb ? clip(String(u.pb).replace(/[^0-9]/g, ""), 16) : fb.pb || "",
        pi: u.pi ? clip(String(u.pi).replace(/[^0-9]/g, ""), 16) : fb.pi || "",
        pt: rawPt || fb.pt || null,
        mc: Math.max(Number(u.mc) || 0, Number(fb.mc) || 0),
        proxyId: u.proxyId && u.proxyId !== "boss" ? u.proxyId : fallbackProxyId,
        proxyName: u.proxyName && !String(u.proxyName).includes("Boss") ? u.proxyName : fallbackProxyName,
        ts: uTs,
      });
      changed = true;
    }
  }
  if (prunePresenceMap(nowS)) changed = true;
  return changed;
}

/**
 * [POST /api/peer-sync] Endpoint nhận gói tin và danh sách người chơi Online từ 4 Server Backup khác hoặc từ Server Boss.
 * Giúp cả 5 Server Backup liên kết tức thì (<100ms) với nhau!
 */
async function handlePeerSync(req, env, ctx, url) {
  if (!verifySyncAuth(req, url, env)) {
    return json({ ok: false, error: "unauthorized_sync" }, 401);
  }
  let b;
  try {
    b = await req.json();
  } catch (e) {
    return json({ ok: false, error: "json" }, 400);
  }

  const fromId = String(b.fromId || "b1").slice(0, 16);
  const fromName = String(b.fromName || "Backup 1").slice(0, 24);
  const dirty = new Set();

  if (b.lockdown && typeof b.lockdown === "object") {
    if (mergeLockdownState(b.lockdown, b.lockdownSeq)) dirty.add("mod");
  }

  if (mergeProfilesSync(b)) dirty.add("profiles");

  if (Array.isArray(b.users)) {
    mergeRemoteUsers(b.users, fromId === "boss" ? "b1" : fromId, fromId === "boss" ? "Backup 1" : fromName);
  }

  if (b.seenBy && typeof b.seenBy === "object") {
    if (mergeSeenByMap(b.seenBy, b.seenSeq)) dirty.add("chat");
  }

  const processPeerLine = (rawLine) => {
    if (typeof rawLine !== "string" || rawLine.length < 8) return;
    const pkt = parseContent(rawLine);
    if (!pkt || !pkt.type) return;
    const eph = EPHEMERAL.has(pkt.type);
    const trusted = fromId === "boss" || pkt.type !== "roles";
    const pid = pkt.packetId ? String(pkt.packetId) : "";
    const existed = pid && (G.byPid.has(pid) || G.deletedIds.has(pid));
    applyState(env, pkt, trusted, ctx);
    const item = insert(pkt, rawLine, null, eph, Number(pkt._s) || 0);
    if (item && pkt.type === "msg" && !existed) {
      bumpProfileMsgCount(pkt.author, pid, pkt);
      if (String(pkt.chan || "general") === "general") dirty.add("chat");
    }
  };

  if (typeof b.line === "string" && b.line.length >= 8) {
    processPeerLine(b.line);
  }

  if (Array.isArray(b.lines)) {
    for (const l of b.lines) processPeerLine(l);
  }

  if (dirty.size > 0) saveStateSoon(ctx, 0, [...dirty]);
  notify();
  return json({
    ok: true,
    proxyId: G.proxyId,
    proxyName: G.proxyName,
    online: G.pres.size,
    now: nowSec(),
  });
}

/**
 * Kéo trạng thái quản trị nhẹ (Mute/Ban/Warn/Role/Lockdown) từ Boss.js (`/api/boss-state`)
 * đồng thời đánh thức Boss.js trên Render.com Free Tier.
 */
async function pullFromBoss(env, ctx, force = false) {
  const bossUrl = getBossUrl(env);
  if (!bossUrl) return false;
  if (G.selfHost && bossUrl.toLowerCase().includes(G.selfHost.toLowerCase())) return false;
  const now = Date.now();
  if (!force && now - G.lastBossPullAt < BOSS_PULL_MS) return G.bossOk;
  if (G.bossPulling) return G.bossPulling;

  G.lastBossPullAt = now;
  G.bossPulling = (async () => {
    const ctrl = typeof AbortController === "function" ? new AbortController() : null;
    const timer = ctrl ? setTimeout(() => { try { ctrl.abort(); } catch (e) {} }, 6000) : null;
    try {
      const authKey = computeSyncKey(env);
      const r = await fetch(`${bossUrl}/api/boss-state?proxyId=${encodeURIComponent(G.proxyId)}`, {
        method: "GET",
        headers: {
          Accept: "application/json",
          "Cache-Control": "no-cache",
          ...(authKey ? { "x-boss-auth": authKey } : {}),
        },
        ...(ctrl ? { signal: ctrl.signal } : {}),
      });
      if (timer) clearTimeout(timer);
      if (!r.ok) {
        G.bossOk = false;
        return false;
      }
      const data = await r.json();
      if (data && data.ok && data.state) {
        G.bossOk = true;
        const incTs = Number(data.state.ts) || 0;
        const hadNewerTs = incTs > G.stateTs;
        applyStateSnapshot(data.state);
        if (hadNewerTs) G.stateTs = incTs;
        const rec = Array.isArray(data.recentItems) ? data.recentItems : Array.isArray(data.state.recentItems) ? data.state.recentItems : [];
        let addedRec = false;
        if (rec.length) {
          addedRec = ingestLinesFromSync(env, ctx, rec);
        }
        if (hadNewerTs) {
          saveStateSoon(ctx, 0, "all");
        } else if (addedRec) {
          saveStateSoon(ctx, 0, "chat");
        }
        notify();
        return true;
      }
    } catch (e) {
      if (timer) clearTimeout(timer);
      G.bossOk = false;
    }
    return false;
  })().finally(() => {
    G.bossPulling = null;
  });

  return G.bossPulling;
}

/**
 * Đánh thức Boss Server (Render.com) và đồng bộ nền tiết kiệm tối đa:
 * - KHÔNG gọi `pullFromBoss` định kỳ 12s nữa; chỉ gọi khi mới cold boot (`!G.bossOk`).
 * - Chỉ đẩy nền khi không có `line` sau mỗi 45 giây (`BOSS_PUSH_IDLE_MS`).
 */
function wakeBossInBackground(env, ctx) {
  if (!G.bossOk && Date.now() - G.lastBossPullAt >= BOSS_PULL_MS) {
    bg(ctx, pullFromBoss(env, ctx, false));
  }
  if (G.pres.size > 0 && Date.now() - G.lastBossPushAt >= BOSS_PUSH_IDLE_MS) {
    broadcastMeshAndBossSoon(env, ctx, "");
  }
}

// ============================================================================
// 6. ÁP DỤNG GÓI TIN TRẠNG THÁI & HÀNG ĐỢI TIN NHẮN (LONG-POLLING)
// ============================================================================

function notify() {
  for (const f of [...G.waiters]) f();
}

function waitInsert(ms) {
  return new Promise((res) => {
    const done = () => {
      clearTimeout(t);
      G.waiters.delete(done);
      res();
    };
    const t = setTimeout(done, ms);
    G.waiters.add(done);
  });
}

function rolesLines(seq, by, roles, assign) {
  const whole = PREFIX + JSON.stringify({ type: "roles", by, roles, assign, seq, packetId: "roles-" + seq });
  if (whole.length <= 1900) return { whole, parts: [] };
  const items = [];
  for (const r of roles) items.push({ k: "r", v: r });
  for (const u of Object.keys(assign)) items.push({ k: "a", u, v: assign[u] });
  const head = PREFIX.length + JSON.stringify({ type: "roles_part", by, seq, part: 99, parts: 99, items: [], packetId: "roles-" + seq + "-99" }).length;
  const budget = LINE_MAX - head - 16;
  const chunks = [];
  let cur = [];
  let size = 0;
  for (const it of items) {
    const s = JSON.stringify(it).length + 1;
    if (cur.length && size + s > budget) {
      chunks.push(cur);
      cur = [];
      size = 0;
    }
    cur.push(it);
    size += s;
  }
  if (cur.length) chunks.push(cur);
  const parts = chunks.map((list, i) =>
    PREFIX + JSON.stringify({
      type: "roles_part",
      by,
      seq,
      part: i + 1,
      parts: chunks.length,
      items: list,
      packetId: "roles-" + seq + "-" + (i + 1),
    })
  );
  return { whole: null, parts };
}

function collectRolePart(env, pkt, ctx) {
  const seq = Number(pkt.seq) || 0;
  const total = Number(pkt.parts) || 0;
  const idx = Number(pkt.part) || 0;
  if (!seq || total < 1 || total > 200 || idx < 1 || idx > total) return;
  if (seq < G.rolesSeq) return;
  let b = G.rolePartBuf.get(seq);
  if (!b) {
    b = { by: String(pkt.by || ""), total, got: new Set(), roles: [], assign: {} };
    G.rolePartBuf.set(seq, b);
    if (G.rolePartBuf.size > 20) G.rolePartBuf.delete(G.rolePartBuf.keys().next().value);
  }
  if (b.total !== total) return;
  if (!b.got.has(idx)) {
    b.got.add(idx);
    for (const it of Array.isArray(pkt.items) ? pkt.items : []) {
      if (!it || typeof it !== "object") continue;
      if (it.k === "r" && it.v && typeof it.v === "object") b.roles.push(it.v);
      else if (it.k === "a" && typeof it.u === "string" && it.v && typeof it.v === "object") b.assign[it.u] = it.v;
    }
  }
  if (b.got.size === b.total) {
    G.rolePartBuf.delete(seq);
    applyState(env, { type: "roles", by: b.by, seq, roles: b.roles, assign: b.assign }, true, ctx);
  }
}

function pushPunishment(entry, ctx) {
  const id = String(entry.id || entry.packetId || ("pn-" + Date.now() + "-" + Math.random().toString(36).slice(2, 6)));
  if (G.deletedIds.has(id) || G.punishments.some((x) => x.id === id)) return null;
  const item = {
    id,
    action: String(entry.action || entry.type || "warn"),
    target: cleanName(entry.target || entry.u || "?"),
    by: cleanName(entry.by || "?"),
    reason: clip(String(entry.reason || ""), 300),
    exp: Number(entry.expires_at ?? entry.exp) || 0,
    ts: Number(entry.ts) || nowSec(),
  };
  G.punishments.push(item);
  while (G.punishments.length > MAX_PUNISH) G.punishments.shift();
  G.modSeq = Math.max(Date.now(), G.modSeq + 1);
  saveStateSoon(ctx, 0, "mod");
  notify();
  return item;
}

function buildGroupChan(id) {
  return "dm:" + id;
}

function applyState(env, pkt, trusted, ctx) {
  const t = pkt.type;
  if (t === "roles") {
    if (!(trusted || isDev(env, pkt.by))) return;
    const seq = Number(pkt.seq) || Date.now();
    if (seq < G.rolesSeq) return;
    if (seq === G.rolesSeq && G.roles) return;
    G.roles = {
      roles: Array.isArray(pkt.roles) ? pkt.roles : [],
      assign: pkt.assign && typeof pkt.assign === "object" ? pkt.assign : {},
      by: pkt.by,
      seq,
    };
    G.rolesSeq = seq;
    saveStateSoon(ctx, 0, "mod");
  } else if (t === "roles_part") {
    if (!(trusted || isDev(env, pkt.by))) return;
    collectRolePart(env, pkt, ctx);
  } else if (t === "lockdown") {
    if (!(trusted || isStaffName(env, pkt.by))) return;
    const rawTs = Number(pkt.ts) || 0;
    const ts = rawTs || nowSec();
    const seq = Number(pkt.seq) > 0 ? Number(pkt.seq) : (rawTs > 0 ? rawTs * 1000 : Math.max(Date.now(), G.lockdownSeq + 1));
    const changed = mergeLockdownState(
      {
        active: Boolean(pkt.active),
        by: cleanName(pkt.by || "Admin"),
        reason: clip(String(pkt.reason || ""), 200),
        ts,
        seq,
      },
      seq
    );
    if (changed) {
      saveStateSoon(ctx, 0, "mod");
      notify();
    }
  } else if (t === "mute") {
    if (!pkt.target) return;
    if (!trusted && !isStaffName(env, pkt.by)) return;
    const targetName = cleanName(pkt.target);
    const reason = clip(String(pkt.reason || ""), 300);
    const exp = Number(pkt.expires_at) || 0;
    const by = cleanName(pkt.by || "");
    const ts = Number(pkt.ts) || nowSec();
    G.mutes.set(targetName.toLowerCase(), { u: targetName, reason, exp, by, ts });
    pushPunishment({ id: pkt.packetId, action: "mute", target: targetName, by, reason, exp, ts }, ctx);
  } else if (t === "unmute") {
    if (!pkt.target) return;
    if (!trusted && !isStaffName(env, pkt.by)) return;
    const targetName = cleanName(pkt.target);
    const reason = clip(String(pkt.reason || ""), 300);
    const by = cleanName(pkt.by || "");
    const ts = Number(pkt.ts) || nowSec();
    G.mutes.delete(targetName.toLowerCase());
    pushPunishment({ id: pkt.packetId, action: "unmute", target: targetName, by, reason, exp: 0, ts }, ctx);
  } else if (t === "warn") {
    if (!pkt.target) return;
    if (!trusted && !isStaffName(env, pkt.by)) return;
    const targetName = cleanName(pkt.target);
    const key = targetName.toLowerCase();
    const ts = Number(pkt.ts) || nowSec();
    const wid = String(pkt.packetId || ("w-" + ts + "-" + key));
    const reason = clip(String(pkt.reason || ""), 300);
    const by = cleanName(pkt.by || "");
    const list = G.warns.get(key) || [];
    if (!list.some((w) => w.id === wid)) {
      list.push({ id: wid, u: targetName, reason, by, ts });
      while (list.length > MAX_USER_WARNS) list.shift();
      G.warns.set(key, list);
    }
    pushPunishment({ id: wid, action: "warn", target: targetName, by, reason, exp: 0, ts }, ctx);
  } else if (t === "clear_warn") {
    if (!pkt.target) return;
    if (!trusted && !isStaffName(env, pkt.by)) return;
    const targetName = cleanName(pkt.target);
    const key = targetName.toLowerCase();
    const reason = clip(String(pkt.reason || ""), 300);
    const by = cleanName(pkt.by || "");
    const ts = Number(pkt.ts) || nowSec();
    const curList = G.warns.get(key) || [];
    if (pkt.warnId) {
      const next = curList.filter((w) => String(w.id) !== String(pkt.warnId));
      if (next.length) G.warns.set(key, next);
      else G.warns.delete(key);
    } else if (Number(pkt.warnIndex) > 0 && Number(pkt.warnIndex) <= curList.length) {
      curList.splice(Number(pkt.warnIndex) - 1, 1);
      if (curList.length) G.warns.set(key, curList);
      else G.warns.delete(key);
    } else {
      G.warns.delete(key);
    }
    pushPunishment({ id: pkt.packetId, action: "clear_warn", target: targetName, by, reason, exp: 0, ts }, ctx);
  } else if (t === "ban") {
    if (!pkt.target) return;
    if (!trusted && !isStaffName(env, pkt.by)) return;
    const targetName = cleanName(pkt.target);
    const reason = clip(String(pkt.reason || "Vi phạm quy định"), 300);
    const exp = Number(pkt.expires_at || pkt.exp) || 0;
    const by = cleanName(pkt.by || "");
    const ts = Number(pkt.ts) || nowSec();
    G.banned.set(targetName.toLowerCase(), { u: targetName, reason, exp, by, ts });
    pushPunishment({ id: pkt.packetId, action: "ban", target: targetName, by, reason, exp, ts }, ctx);
  } else if (t === "unban") {
    if (!pkt.target) return;
    if (!trusted && !isStaffName(env, pkt.by)) return;
    const targetName = cleanName(pkt.target);
    const reason = clip(String(pkt.reason || ""), 300);
    const by = cleanName(pkt.by || "");
    const ts = Number(pkt.ts) || nowSec();
    G.banned.delete(targetName.toLowerCase());
    pushPunishment({ id: pkt.packetId, action: "unban", target: targetName, by, reason, exp: 0, ts }, ctx);
  } else if (t === "revoke") {
    if (!pkt.target) return;
    if (!trusted && !isDev(env, pkt.by)) return;
    const targetName = cleanName(pkt.target);
    const reason = clip(String(pkt.reason || ""), 300);
    const by = cleanName(pkt.by || "");
    const ts = Number(pkt.ts) || nowSec();
    pushPunishment({ id: pkt.packetId, action: "revoke", target: targetName, by, reason, exp: 0, ts }, ctx);
  } else if (t === "punish_del") {
    if (!trusted && !isStaffName(env, pkt.by || pkt.author)) return;
    const ids = new Set(Array.isArray(pkt.ids) ? pkt.ids.map(String) : [String(pkt.target || pkt.id || "")]);
    for (const id of ids) if (id) G.deletedIds.add(id);
    const before = G.punishments.length;
    G.punishments = G.punishments.filter((x) => !ids.has(String(x.id)));
    if (G.punishments.length !== before) {
      G.modSeq = Math.max(Date.now(), G.modSeq + 1);
      saveStateSoon(ctx, 0, "mod");
      notify();
    }
  } else if (t === "seen") {
    const viewer = cleanName(pkt.by || pkt.author || "");
    if (!viewer || isSystemActor(viewer, pkt)) return;
    const rawIds = Array.isArray(pkt.ids) ? pkt.ids : pkt.target ? [pkt.target] : [];
    const ts = Number(pkt.ts) || nowSec();
    const patch = {};
    for (const rawId of rawIds.slice(0, 40)) {
      const mid = String(rawId || "").trim().slice(0, 64);
      if (mid && !G.deletedIds.has(mid)) patch[mid] = { [viewer]: ts };
    }
    if (mergeSeenByMap(patch, Number(pkt.seq) || 0)) {
      saveStateSoon(ctx, 1200, "chat");
      notify();
    }
  } else if (t === "request") {
    const key = String(pkt.by || "").toLowerCase();
    if (!key) return;
    const ts = Number(pkt.ts) || 0;
    const cur = G.reqs.get(key);
    if (!cur || (Number(cur.ts) || 0) < ts) {
      G.reqs.set(key, { u: cleanName(pkt.by), role: String(pkt.role || "").slice(0, 24), reason: clip(String(pkt.reason || ""), 200), ts, status: "pending" });
    }
  } else if (t === "request_result") {
    const key = String(pkt.target || "").toLowerCase();
    const cur = G.reqs.get(key);
    const map = { approve: "approved", reject: "rejected", ban: "banned" };
    if (cur && map[pkt.action] && (!pkt.ts || Number(pkt.ts) >= (Number(cur.ts) || 0))) cur.status = map[pkt.action];
    if (pkt.action === "ban" && pkt.target) {
      const targetName = cleanName(pkt.target);
      const reason = clip(String(pkt.reason || "Bị từ chối xin quyền"), 300);
      const by = cleanName(pkt.by || "");
      const ts = Number(pkt.ts) || nowSec();
      G.banned.set(key, { u: targetName, reason, exp: 0, by, ts });
      pushPunishment({ id: "ban-" + key + "-" + ts, action: "ban", target: targetName, by, reason, exp: 0, ts }, ctx);
    }
  } else if (t === "msg") {
    if (String(pkt.chan || "") === "announce") {
      const pid = String(pkt.packetId || "");
      if (pid && !G.deletedIds.has(pid) && (trusted || canAnnounceName(env, pkt.author)) && !G.announces.some((x) => x.packetId === pid)) {
        G.announces.push({
          type: "msg",
          packetId: pid,
          chan: "announce",
          author: cleanName(pkt.author || "?"),
          display: clip(String(pkt.display || pkt.author || "?"), 40),
          uid: Number(pkt.uid) || 1,
          content: String(pkt.content || "").slice(0, 1200),
          ts: Number(pkt.ts) || nowSec(),
          replyTo: pkt.replyTo || undefined,
          replyAuthor: pkt.replyAuthor || undefined,
          replySnippet: pkt.replySnippet || undefined,
          fwdFrom: pkt.fwdFrom || undefined,
          fwdChan: pkt.fwdChan || undefined,
          edited: pkt.edited === true ? true : undefined,
          reactions: pkt.reactions && typeof pkt.reactions === "object" ? pkt.reactions : {},
          _s: Number(pkt._s) || 0,
        });
        while (G.announces.length > MAX_ANNOUNCES) G.announces.shift();
        G.announceSeq = Math.max(Date.now(), G.announceSeq + 1);
        saveStateSoon(ctx, 0, "chat");
        notify();
      }
    }
  } else if (t === "edit") {
    const tg = String(pkt.target || "");
    const ann = G.announces.find((x) => x.packetId === tg && x.type === "msg");
    if (ann && (trusted || String(ann.author).toLowerCase() === String(pkt.author || "").toLowerCase() || isStaffName(env, pkt.author))) {
      ann.content = String(pkt.content || "").slice(0, 1200);
      ann.edited = true;
      const oldItem = G.byPid.get(tg);
      if (oldItem) oldItem.content = stamp(PREFIX + JSON.stringify({ ...ann, reactions: undefined }), oldItem.seq);
      G.announceSeq = Math.max(Date.now(), G.announceSeq + 1);
      saveStateSoon(ctx, 0, "chat");
      notify();
    }
  } else if (t === "delete") {
    const tg = String(pkt.target || "");
    if (tg) {
      const actor = cleanName(pkt.by || pkt.author || "");
      const staff = trusted || isStaffName(env, actor);
      const idxAnn = G.announces.findIndex((x) => x.packetId === tg);
      const isAnn = idxAnn !== -1 || String(pkt.chan || "") === "announce";
      const idxPun = G.punishments.findIndex((x) => x.id === tg);
      const isPun = idxPun !== -1 || String(pkt.chan || "") === "punish";
      const refIdx = G.idx.get(tg);
      const isOwnMsg = !isAnn && !isPun && actor && refIdx && String(refIdx.a || "").toLowerCase() === actor.toLowerCase();
      if (staff || isOwnMsg) {
        G.deletedIds.add(tg);
        G.seenBy.delete(tg);
        if (idxAnn !== -1) {
          G.announces.splice(idxAnn, 1);
          G.announceSeq = Math.max(Date.now(), G.announceSeq + 1);
        }
        if (idxPun !== -1 && staff) {
          G.punishments.splice(idxPun, 1);
          G.modSeq = Math.max(Date.now(), G.modSeq + 1);
        }
        G.polls.delete(tg);
        G.generalArchive = G.generalArchive.filter((x) => x.pid !== tg);
        const oldItem = G.byPid.get(tg);
        if (oldItem) {
          G.byPid.delete(tg);
          G.items = G.items.filter((i) => i.pid !== tg);
        }
        saveStateSoon(ctx, 0, ["mod", "chat"]);
        notify();
      }
    }
  } else if (t === "poll") {
    const pid = String(pkt.pollId || pkt.packetId || "");
    if (G.deletedIds.has(pid)) return;
    G.polls.set(pid, {
      q: String(pkt.question || ""),
      o: Array.isArray(pkt.options) ? pkt.options : [],
      multi: pkt.multi === true,
      exp: Number(pkt.expires_at) || 0,
    });
    if (G.polls.size > MAX_CACHE) G.polls.delete(G.polls.keys().next().value);
    if (String(pkt.chan || "") === "announce" && pid && (trusted || canAnnounceName(env, pkt.author)) && !G.announces.some((x) => x.packetId === pid)) {
      G.announces.push({
        type: "poll",
        packetId: pid,
        pollId: pid,
        chan: "announce",
        question: String(pkt.question || ""),
        options: Array.isArray(pkt.options) ? pkt.options : [],
        multi: pkt.multi === true,
        author: cleanName(pkt.author || "?"),
        ts: Number(pkt.ts) || nowSec(),
        expires_at: Number(pkt.expires_at) || 0,
        votes: pkt.votes && typeof pkt.votes === "object" ? pkt.votes : {},
        closed: pkt.closed === true,
        _s: Number(pkt._s) || 0,
      });
      while (G.announces.length > MAX_ANNOUNCES) G.announces.shift();
      G.announceSeq = Math.max(Date.now(), G.announceSeq + 1);
      saveStateSoon(ctx, 0, "chat");
      notify();
    }
  } else if (t === "poll_vote") {
    const pid = String(pkt.pollId || "");
    const annPoll = G.announces.find((x) => x.type === "poll" && (x.pollId === pid || x.packetId === pid));
    if (annPoll && pkt.voter) {
      const voter = cleanName(pkt.voter);
      const ch = Number(pkt.choice);
      if (voter && ch > 0) {
        annPoll.votes = annPoll.votes || {};
        annPoll.votes[voter] = annPoll.votes[voter] || {};
        if (pkt.action === "remove") delete annPoll.votes[voter][ch];
        else {
          if (!annPoll.multi) annPoll.votes[voter] = {};
          annPoll.votes[voter][ch] = true;
        }
        G.announceSeq = Math.max(Date.now(), G.announceSeq + 1);
        saveStateSoon(ctx, 0, "chat");
        notify();
      }
    }
  } else if (t === "poll_close") {
    const pid = String(pkt.pollId || "");
    const annPoll = G.announces.find((x) => x.type === "poll" && (x.pollId === pid || x.packetId === pid));
    if (annPoll && (trusted || annPoll.author === pkt.closer || isStaffName(env, pkt.closer))) {
      annPoll.closed = true;
      G.announceSeq = Math.max(Date.now(), G.announceSeq + 1);
      saveStateSoon(ctx, 0, "chat");
      notify();
    }
  } else if (t === "script_post") {
    const sid = String(pkt.scriptId || pkt.packetId || "");
    if (!sid || G.scripts.some((x) => x.id === sid)) return;
    G.scripts.push({
      id: sid,
      title: clip(String(pkt.title || "Untitled Script"), 80),
      tag: clip(String(pkt.tag || "Universal"), 24),
      desc: clip(String(pkt.desc || ""), 300),
      code: String(pkt.code || "").slice(0, 15000),
      author: cleanName(pkt.author || "?"),
      display: clip(String(pkt.display || pkt.author || "?"), 40),
      uid: Number(pkt.uid) || 1,
      placeId: Number(pkt.placeId) || 0,
      gameName: clip(String(pkt.gameName || ""), 60),
      ts: Number(pkt.ts) || nowSec(),
      reactions: pkt.reactions && typeof pkt.reactions === "object" ? pkt.reactions : {},
      comments: Array.isArray(pkt.comments) ? pkt.comments : [],
      reports: [],
      ver: Math.max(1, Number(pkt.ver) || 1),
      editedAt: Number(pkt.editedAt) || 0,
      editedBy: pkt.editedBy ? cleanName(pkt.editedBy) : "",
      changelog: clip(String(pkt.changelog || ""), 120),
    });
    while (G.scripts.length > MAX_SCRIPTS) G.scripts.shift();
    upsertProfile({
      u: pkt.author,
      d: pkt.display || pkt.author,
      id: pkt.uid,
      pl: pkt.placeId,
      gn: pkt.gameName,
      ts: Number(pkt.ts) || nowSec(),
    }, { allowClear: false });
    G.scriptSeq = Math.max(Date.now(), G.scriptSeq + 1);
    saveStateSoon(ctx, 0, "scripts");
    notify();
  } else if (t === "script_edit") {
    const sid = String(pkt.scriptId || pkt.target || "");
    const by = cleanName(pkt.editedBy || pkt.by || pkt.author || "");
    const sc = G.scripts.find((x) => x.id === sid);
    if (sc && (trusted || isStaffName(env, by) || String(sc.author || "").toLowerCase() === by.toLowerCase())) {
      const edAt = Number(pkt.editedAt || pkt.ts) || nowSec();
      if (edAt >= (Number(sc.editedAt) || 0)) {
        if (pkt.title) sc.title = clip(String(pkt.title).trim(), 80);
        if (pkt.tag) sc.tag = clip(String(pkt.tag).trim(), 24) || sc.tag;
        if (pkt.desc !== undefined) sc.desc = clip(String(pkt.desc || "").trim(), 300);
        if (typeof pkt.code === "string" && pkt.code.trim()) sc.code = pkt.code.slice(0, 15000);
        const pktVer = Number(pkt.ver);
        sc.ver = pktVer > 0 ? Math.max(Number(sc.ver) || 1, pktVer) : Math.max(1, Number(sc.ver) || 1) + 1;
        sc.editedAt = edAt;
        sc.editedBy = by || sc.author;
        if (pkt.changelog !== undefined) sc.changelog = clip(String(pkt.changelog || ""), 120);
        G.scriptSeq = Math.max(Date.now(), G.scriptSeq + 1);
        saveStateSoon(ctx, 0, "scripts");
        notify();
      }
    }
  } else if (t === "script_comment") {
    const sid = String(pkt.scriptId || pkt.target || "");
    const cid = String(pkt.commentId || pkt.packetId || "");
    const sc = G.scripts.find((x) => x.id === sid);
    if (sc && cid) {
      sc.comments = Array.isArray(sc.comments) ? sc.comments : [];
      if (!sc.comments.some((c) => c.id === cid)) {
        const cText = clip(String(pkt.content || pkt.text || ""), 500);
        sc.comments.push({
          id: cid,
          author: cleanName(pkt.author || pkt.by || "?"),
          display: clip(String(pkt.display || pkt.author || pkt.by || "?"), 40),
          uid: Number(pkt.uid) || 1,
          content: cText,
          text: cText,
          ts: Number(pkt.ts) || nowSec(),
        });
        while (sc.comments.length > 100) sc.comments.shift();
        upsertProfile({
          u: pkt.author || pkt.by,
          d: pkt.display || pkt.author || pkt.by,
          id: pkt.uid,
          ts: Number(pkt.ts) || nowSec(),
        }, { allowClear: false });
        G.scriptSeq = Math.max(Date.now(), G.scriptSeq + 1);
        saveStateSoon(ctx, 0, "scripts");
        notify();
      }
    }
  } else if (t === "script_comment_del") {
    const sid = String(pkt.scriptId || pkt.target || "");
    const cid = String(pkt.commentId || pkt.id || "");
    const by = cleanName(pkt.by || pkt.author || "");
    const sc = G.scripts.find((x) => x.id === sid);
    if (sc && cid && Array.isArray(sc.comments)) {
      const cObj = sc.comments.find((c) => c.id === cid);
      if (cObj && (trusted || isStaffName(env, by) || String(cObj.author).toLowerCase() === by.toLowerCase() || String(sc.author).toLowerCase() === by.toLowerCase())) {
        sc.comments = sc.comments.filter((c) => c.id !== cid);
        G.scriptSeq = Math.max(Date.now(), G.scriptSeq + 1);
        saveStateSoon(ctx, 0, "scripts");
        notify();
      }
    }
  } else if (t === "script_del") {
    if (!trusted && !isStaffName(env, pkt.by)) return;
    const ids = new Set(Array.isArray(pkt.ids) ? pkt.ids.map(String) : [String(pkt.id || "")]);
    const before = G.scripts.length;
    G.scripts = G.scripts.filter((x) => !ids.has(String(x.id)));
    if (G.scripts.length !== before) {
      G.scriptSeq = Math.max(Date.now(), G.scriptSeq + 1);
      saveStateSoon(ctx, 0, "scripts");
      notify();
    }
  } else if (t === "react" || t === "script_react") {
    const tg = String(pkt.target || pkt.scriptId || "");
    const em = String(pkt.emoji || "");
    const by = cleanName(pkt.by || "");
    if (tg && em && by) {
      const sc = G.scripts.find((x) => x.id === tg);
      if (sc) {
        sc.reactions = sc.reactions || {};
        sc.reactions[em] = sc.reactions[em] || {};
        if (pkt.action === "remove") {
          delete sc.reactions[em][by];
          if (!Object.keys(sc.reactions[em]).length) delete sc.reactions[em];
        } else sc.reactions[em][by] = true;
        G.scriptSeq = Math.max(Date.now(), G.scriptSeq + 1);
        saveStateSoon(ctx, 0, "scripts");
        notify();
      }
      const ann = G.announces.find((x) => x.packetId === tg);
      if (ann) {
        ann.reactions = ann.reactions || {};
        ann.reactions[em] = ann.reactions[em] || {};
        if (pkt.action === "remove") {
          delete ann.reactions[em][by];
          if (!Object.keys(ann.reactions[em]).length) delete ann.reactions[em];
        } else ann.reactions[em][by] = true;
        G.announceSeq = Math.max(Date.now(), G.announceSeq + 1);
        saveStateSoon(ctx, 0, "chat");
        notify();
      }
    }
  } else if (t === "emoji_sync") {
    const act = String(pkt.action || "add");
    if (act === "add" || act === "rename") {
      const id = String(pkt.id || "").replace(/[^0-9]/g, "").slice(0, 15);
      const name = cleanEmojiName(pkt.name);
      const by = cleanName(pkt.by || "?");
      if (id && id.length >= 5) {
        const ex = G.emojis.find((e) => e.id === id);
        if (ex) ex.name = name;
        else if (G.emojis.length < MAX_EMOJIS) G.emojis.push({ id, name, by, ts: Number(pkt.ts) || nowSec() });
        G.emojiSeq = Math.max(Date.now(), G.emojiSeq + 1);
        saveStateSoon(ctx, 0, "scripts");
      }
    } else if (act === "remove") {
      const ids = new Set(Array.isArray(pkt.ids) ? pkt.ids.map(String) : [String(pkt.id || "")]);
      const before = G.emojis.length;
      G.emojis = G.emojis.filter((e) => !ids.has(String(e.id)));
      if (G.emojis.length !== before) {
        G.emojiSeq = Math.max(Date.now(), G.emojiSeq + 1);
        saveStateSoon(ctx, 0, "scripts");
      }
    }
  } else if (t === "group_sync") {
    const act = String(pkt.action || "create");
    const gid = String(pkt.id || "").replace(/[^A-Za-z0-9_-]/g, "").slice(0, 32);
    const by = cleanName(pkt.by || pkt.owner || "");
    if (!gid || !by) return;
    if (act === "create" || act === "update") {
      const rawMembers = Array.isArray(pkt.members) ? pkt.members : [];
      const memberSet = new Map();
      memberSet.set(by.toLowerCase(), by);
      for (const m of rawMembers.slice(0, 30)) {
        const cm = cleanName(m);
        if (cm) memberSet.set(cm.toLowerCase(), cm);
      }
      const members = [...memberSet.values()];
      if (members.length < 2) return;
      const existing = G.groups.get(gid);
      if (existing && !trusted && !isStaffName(env, by) && !existing.members.some((x) => x.toLowerCase() === by.toLowerCase())) return;
      const owner = existing ? existing.owner : by;
      const gObj = {
        id: gid,
        name: clip(String(pkt.name || (existing && existing.name) || ("Nhóm của " + owner)), 40),
        icon: clip(String(pkt.icon || (existing && existing.icon) || "👥").trim() || "👥", 16),
        owner,
        members,
        chan: buildGroupChan(gid),
        ts: Number(pkt.ts) || (existing && existing.ts) || nowSec(),
      };
      G.groups.set(gid, gObj);
      while (G.groups.size > MAX_GROUPS) G.groups.delete(G.groups.keys().next().value);
      G.groupSeq = Math.max(Date.now(), G.groupSeq + 1);
      saveStateSoon(ctx, 0, "chat");
      notify();
    } else if (act === "delete") {
      const existing = G.groups.get(gid);
      if (existing && (trusted || isStaffName(env, by) || String(existing.owner).toLowerCase() === by.toLowerCase())) {
        G.groups.delete(gid);
        G.groupSeq = Math.max(Date.now(), G.groupSeq + 1);
        saveStateSoon(ctx, 0, "chat");
        notify();
      }
    }
  } else if (t === "feedback") {
    const fid = String(pkt.id || pkt.feedbackId || pkt.packetId || "").slice(0, 48);
    const author = cleanName(pkt.author || pkt.by || "");
    if (!fid || !author) return;
    if (!G.feedbacks.has(fid)) {
      const fbObj = {
        id: fid,
        kind: pkt.kind === "bug" ? "bug" : "suggest",
        author,
        display: clip(String(pkt.display || author), 40),
        uid: Number(pkt.uid) || 1,
        category: clip(String(pkt.category || (pkt.kind === "bug" ? "UI / Script" : "Tính năng mới")), 40),
        severity: clip(String(pkt.severity || "Trung bình"), 24),
        title: clip(String(pkt.title || ""), 100),
        content: clip(String(pkt.content || ""), 1200),
        steps: clip(String(pkt.steps || ""), 600),
        exec: clip(String(pkt.exec || "?"), 32),
        device: clip(String(pkt.device || "?"), 16),
        placeId: Number(pkt.placeId) || 0,
        gameName: clip(String(pkt.gameName || ""), 60),
        rtt: clip(String(pkt.rtt || ""), 20),
        seen: pkt.seen === true,
        seenBy: pkt.seenBy ? cleanName(pkt.seenBy) : "",
        seenAt: Number(pkt.seenAt) || 0,
        status: String(pkt.status || "pending"),
        replies: Array.isArray(pkt.replies) ? pkt.replies.slice(0, 20) : [],
        ts: Number(pkt.ts) || nowSec(),
      };
      G.feedbacks.set(fid, fbObj);
      while (G.feedbacks.size > MAX_FEEDBACKS) G.feedbacks.delete(G.feedbacks.keys().next().value);
      G.feedbackSeq = Math.max(Date.now(), G.feedbackSeq + 1);
      saveStateSoon(ctx, 0, "chat");
      notify();
    }
  } else if (t === "feedback_reply") {
    const fid = String(pkt.feedbackId || pkt.targetId || pkt.id || "").slice(0, 48);
    const fbObj = G.feedbacks.get(fid);
    if (fbObj && (trusted || isStaffName(env, pkt.by || pkt.author))) {
      const by = cleanName(pkt.by || pkt.author || "Developer");
      const ts = Number(pkt.ts) || nowSec();
      fbObj.seen = true;
      fbObj.seenBy = fbObj.seenBy || by;
      fbObj.seenAt = fbObj.seenAt || ts;
      if (pkt.status) fbObj.status = String(pkt.status);
      else if (pkt.replyText) fbObj.status = "replied";
      else if (fbObj.status === "pending") fbObj.status = "seen";
      if (pkt.replyText) {
        fbObj.replies = Array.isArray(fbObj.replies) ? fbObj.replies : [];
        const rId = String(pkt.packetId || ("fbr-" + ts));
        if (!fbObj.replies.some((r) => r.id === rId)) {
          fbObj.replies.push({
            id: rId,
            by,
            text: clip(String(pkt.replyText), 600),
            kind: String(pkt.replyKind || "reply"),
            ts,
          });
        }
      }
      G.feedbackSeq = Math.max(Date.now(), G.feedbackSeq + 1);
      saveStateSoon(ctx, 0, "chat");
      notify();
    }
  } else if (t === "presence") {
    const u = cleanName(pkt.u || pkt.author || "");
    if (!u) return;
    const uKey = u.toLowerCase();
    const ts = Number(pkt.ts) || nowSec();
    if (pkt.off) {
      markUserOffline(u, ts, pkt);
      notify();
      return;
    }
    if (isUserOfflineAt(uKey, ts)) return;
    const prev = G.pres.get(uKey) || G.profiles.get(uKey) || {};
    const sg = pkt.sg === true || Number(pkt.pl) > 0;
    const clearedAt = G.profClearedAt.get(uKey) || 0;
    if (clearedAt > 0 && ts <= clearedAt) return;
    const incPt = pkt.pt && typeof pkt.pt === "object" ? sanitizeProfTheme(pkt.pt, null) : null;
    const cleanD = pkt.d && pkt.d !== "?" ? clip(pkt.d, 40) : "";
    const cleanC = pkt.c && pkt.c !== "??" ? clip(pkt.c, 3) : "";
    const cleanPb = pkt.pb ? clip(String(pkt.pb).replace(/[^0-9]/g, ""), 16) : "";
    const cleanPi = pkt.pi ? clip(String(pkt.pi).replace(/[^0-9]/g, ""), 16) : "";
    const entry = {
      u,
      d: cleanD || (prev.d && prev.d !== "?" ? prev.d : u),
      id: Number(pkt.id || pkt.uid) || prev.id || 0,
      st: pkt.st ? clip(pkt.st, 80) : prev.st || "",
      bio: pkt.bio ? clip(pkt.bio, 180) : prev.bio || "",
      c: cleanC || prev.c || "??",
      pb: cleanPb || prev.pb || "",
      pi: cleanPi || prev.pi || "",
      pt: incPt || prev.pt || null,
      sg,
      pl: sg ? Number(pkt.pl) || prev.pl || 0 : 0,
      gn: sg ? clip(pkt.gn || prev.gn || "", 60) : "",
      jb: sg ? clip(pkt.jb || prev.jb || "", 64) : "",
      mc: Math.max(Number(pkt.mc) || 0, Number(prev.mc) || 0),
      proxyId: pkt.proxyId && pkt.proxyId !== "boss" ? pkt.proxyId : prev.proxyId || G.proxyId,
      proxyName: pkt.proxyName && !String(pkt.proxyName).includes("Boss") ? pkt.proxyName : prev.proxyName || G.proxyName,
      ts,
    };
    const isFresh = nowSec() - ts <= PRESENCE_TTL;
    upsertProfile(entry, { allowClear: false, offline: !isFresh });
    if (isFresh && ts >= (Number(prev.ts) || 0)) {
      G.offAt.delete(uKey);
      G.pres.set(uKey, entry);
    }
  } else if (t === "profile_sync") {
    const u = cleanName(pkt.u || pkt.author || "");
    if (!u) return;
    const uKey = u.toLowerCase();
    const ts = Number(pkt.ts) || nowSec();
    const clearedAt = G.profClearedAt.get(uKey) || 0;
    if (clearedAt > 0 && ts < clearedAt) return;
    if (clearedAt > 0 && ts >= clearedAt) G.profClearedAt.delete(uKey);
    const prev = G.profiles.get(uKey) || G.pres.get(uKey) || {};
    const pt = pkt.pt !== undefined ? sanitizeProfTheme(pkt.pt, null) : prev.pt || null;
    const entry = {
      u,
      d: clip(pkt.d || prev.d || u, 40),
      id: Number(pkt.id || pkt.uid) || prev.id || 0,
      st: pkt.st !== undefined ? clip(pkt.st || "", 80) : prev.st || "",
      bio: pkt.bio !== undefined ? clip(pkt.bio || "", 180) : prev.bio || "",
      c: clip(pkt.c || prev.c || "??", 3),
      pb: pkt.pb !== undefined ? clip(String(pkt.pb || "").replace(/[^0-9]/g, ""), 16) : prev.pb || "",
      pi: pkt.pi !== undefined ? clip(String(pkt.pi || "").replace(/[^0-9]/g, ""), 16) : prev.pi || "",
      pt,
      mc: Math.max(Number(prev.mc) || 0, Number(pkt.mc) || 0),
      pl: Number(pkt.pl) || prev.pl || 0,
      gn: clip(pkt.gn || prev.gn || "", 60),
      ts,
    };
    const saved = upsertProfile(entry, { allowClear: true, preferSrc: true, offline: !G.pres.has(uKey) }) || entry;
    if (hasCustomProfileData(saved)) {
      const curRv = G.profReviews.get(uKey);
      if (!curRv || curRv.status === "cleared") {
        G.profReviews.set(uKey, { u: saved.u, status: "pending", by: "", reason: "", ts });
      }
    }
    if (G.pres.has(uKey)) {
      const live = G.pres.get(uKey);
      Object.assign(live, {
        d: saved.d,
        id: saved.id || live.id || 0,
        st: saved.st,
        bio: saved.bio,
        c: saved.c,
        pb: saved.pb,
        pi: saved.pi,
        pt: saved.pt,
        mc: Math.max(Number(live.mc) || 0, Number(saved.mc) || 0),
      });
    }
    G.profSeq = Math.max(Date.now(), (G.profSeq || 0) + 1);
    saveStateSoon(ctx, 0, "profiles");
    notify();
  } else if (t === "profile_del") {
    const target = cleanName(pkt.target || pkt.u || "");
    if (!target) return;
    const actor = cleanName(pkt.by || pkt.author || "");
    if (!pkt.manual && actor.toLowerCase() !== target.toLowerCase()) return;
    if (!trusted && !isStaffName(env, actor) && actor.toLowerCase() !== target.toLowerCase()) return;
    const uKey = target.toLowerCase();
    const ts = Number(pkt.ts) || nowSec();
    const curProf = G.profiles.get(uKey);
    const curRv = G.profReviews.get(uKey);
    if (curProf && (Number(curProf.ts) || 0) > ts && hasCustomProfileData(curProf)) return;
    if (curRv && curRv.status === "approved" && (Number(curRv.ts) || 0) > ts) return;
    G.profMsgMap.delete(uKey);
    upsertProfile({ u: target, ts }, { forceReset: true });
    G.profReviews.set(uKey, { u: target, status: "cleared", by: actor || "Admin", reason: clip(String(pkt.reason || ""), 200), ts });
    if (G.pres.has(uKey)) {
      Object.assign(G.pres.get(uKey), { d: target, st: "", bio: "", c: "??", pb: "", pi: "", pt: null });
    }
    G.profSeq = Math.max(Date.now(), (G.profSeq || 0) + 1);
    saveStateSoon(ctx, 0, "profiles");
    notify();
  } else if (t === "profile_review") {
    const target = cleanName(pkt.target || pkt.u || "");
    if (!target) return;
    const actor = cleanName(pkt.by || pkt.author || "");
    if (!trusted && !isStaffName(env, actor)) return;
    const uKey = target.toLowerCase();
    const act = String(pkt.action || "approve").toLowerCase();
    const ts = Number(pkt.ts) || nowSec();
    if (act === "approve" || act === "unblock" || act === "restore") {
      G.profClearedAt.delete(uKey);
      G.profReviews.set(uKey, { u: target, status: "approved", by: actor || "Admin", reason: clip(String(pkt.reason || ""), 200), ts });
    } else if (act === "pending") {
      G.profReviews.set(uKey, { u: target, status: "pending", by: actor, reason: clip(String(pkt.reason || ""), 200), ts });
    }
    G.profSeq = Math.max(Date.now(), (G.profSeq || 0) + 1);
    saveStateSoon(ctx, 0, "profiles");
    notify();
  }

  if (t === "msg" || t === "typing" || t === "seen") {
    const actUser = cleanName(pkt.author || pkt.by || "");
    const hasExplicitTs = Number(pkt.ts) > 0 || Number(pkt._s) > 0;
    const pktTs = Number(pkt.ts) || (pkt._s ? Math.floor(Number(pkt._s) / 1000) : nowSec());
    if (actUser && !isSystemActor(actUser, pkt)) {
      const uKey = actUser.toLowerCase();
      const isOff = isUserOfflineAt(uKey, pktTs) || nowSec() - pktTs > PRESENCE_TTL;
      upsertProfile({
        u: actUser,
        d: pkt.display || actUser,
        id: Number(pkt.uid) || 0,
        pl: Number(pkt.place) || 0,
        gn: pkt.gameName || "",
        mc: Number(pkt.mc) || 0,
        ts: pktTs,
      }, { allowClear: false, offline: isOff });
      if (!isOff && (hasExplicitTs || G.pres.has(uKey))) {
        const prev = G.pres.get(uKey);
        if (!prev || pktTs >= (Number(prev.ts) || 0)) {
          const profFallback = G.profiles.get(uKey) || {};
          const hasPlace = Number(pkt.place) > 0 || (prev && Number(prev.pl) > 0);
          G.pres.set(uKey, {
            u: actUser,
            d: clip(pkt.display || (prev && prev.d) || profFallback.d || actUser, 40),
            id: Number(pkt.uid) || (prev && prev.id) || profFallback.id || 0,
            st: (prev && prev.st) || profFallback.st || "",
            bio: (prev && prev.bio) || profFallback.bio || "",
            c: (prev && prev.c) || profFallback.c || "??",
            pb: (prev && prev.pb) || profFallback.pb || "",
            pi: (prev && prev.pi) || profFallback.pi || "",
            pt: (prev && prev.pt) || profFallback.pt || null,
            sg: hasPlace || !!(prev && prev.sg),
            pl: Number(pkt.place) || (prev && prev.pl) || 0,
            gn: clip(pkt.gameName || (prev && prev.gn) || "", 60),
            jb: clip(pkt.job || (prev && prev.jb) || "", 64),
            mc: Math.max(Number(pkt.mc) || 0, Number(prev && prev.mc) || 0, Number(profFallback.mc) || 0),
            proxyId: (prev && prev.proxyId) || G.proxyId,
            proxyName: (prev && prev.proxyName) || G.proxyName,
            ts: pktTs,
          });
        }
      }
    }
  }
}

function insert(pkt, content, syn, eph, seqHint) {
  const pid = String(pkt.packetId || syn || "");
  if (pid && (G.byPid.has(pid) || G.deletedIds.has(pid))) return null;
  const chan = String(pkt.chan || "general");
  let dm = null;
  if (pkt.type === "group_sync" && Array.isArray(pkt.notifyMembers || pkt.members)) {
    dm = (pkt.notifyMembers || pkt.members).map((x) => String(x || "").toLowerCase()).filter(Boolean);
  } else if (chan.startsWith("dm:grp_")) {
    const parts = chan.slice(3).split("|").map((x) => x.trim().toLowerCase()).filter(Boolean);
    const grpId = parts[0];
    const grpObj = G.groups.get(grpId);
    const fallbackMembers = parts.slice(1).filter((x) => !x.startsWith("grp_"));
    dm = grpObj && Array.isArray(grpObj.members)
      ? grpObj.members.map((x) => String(x).toLowerCase())
      : fallbackMembers;
  } else if (chan.startsWith("dm:")) {
    const parts = chan.slice(3).split("|").map((x) => x.trim().toLowerCase()).filter(Boolean);
    const members = parts.filter((x) => !x.startsWith("grp_"));
    if (members.length >= 2) {
      dm = members;
    } else {
      const grpKey = parts.find((x) => x.startsWith("grp_"));
      const grpObj = grpKey ? G.groups.get(grpKey) : null;
      dm = grpObj && Array.isArray(grpObj.members) ? grpObj.members.map((x) => String(x).toLowerCase()) : ["?", "?"];
    }
  }
  let seq = Number(seqHint) || 0;
  if (seq > 0) {
    if (seq > G.seq) G.seq = seq;
  } else {
    G.seq = Math.max(Date.now(), G.seq + 1);
    seq = G.seq;
  }
  const so = pkt.type === "report" || pkt.type === "request" || (chan === "staff" && pkt.type === "msg");
  const item = {
    seq,
    at: Date.now(),
    pid,
    content,
    chan,
    place: Number(pkt.place) || 0,
    job: String(pkt.job || ""),
    dm,
    so,
    eph: !!eph,
  };
  if (eph) {
    const t = Date.now();
    G.items = G.items.filter((i) => !i.eph || t - i.at < 10000);
  }
  let k = G.items.length;
  while (k > 0 && G.items[k - 1].seq > seq) k--;
  G.items.splice(k, 0, item);
  if (pid) G.byPid.set(pid, item);
  if (!eph && chan === "general" && (pkt.type === "msg" || pkt.type === "poll") && pid && !G.deletedIds.has(pid)) {
    if (!G.generalArchive.some((x) => x.pid === pid)) {
      const entry = { seq, pid, c: stamp(content, seq) };
      let gk = G.generalArchive.length;
      while (gk > 0 && G.generalArchive[gk - 1].seq > seq) gk--;
      G.generalArchive.splice(gk, 0, entry);
      while (G.generalArchive.length > MAX_GENERAL_ARCHIVE) G.generalArchive.shift();
      G.generalSeq = Math.max(Date.now(), G.generalSeq + 1);
    }
  }
  if (chan === "announce" && pid) {
    const ann = G.announces.find((x) => x.packetId === pid);
    if (ann && !ann._s) ann._s = seq;
  }
  while (G.items.length > MAX_ITEMS) {
    let dropIdx = G.items.findIndex((x) => x.content && x.content.includes('"type":"seen"'));
    if (dropIdx === -1) dropIdx = G.items.findIndex((x) => x.chan !== "announce" && x.chan !== "punish" && x.chan !== "general");
    if (dropIdx === -1) dropIdx = G.items.findIndex((x) => x.chan !== "announce" && x.chan !== "punish");
    if (dropIdx === -1) break;
    const o = G.items.splice(dropIdx, 1)[0];
    if (o && o.pid) G.byPid.delete(o.pid);
  }
  if (pkt.type === "msg" && pid) {
    G.idx.set(pid, { a: pkt.author, c: clip(pkt.content, 120), ch: chan });
    if (G.idx.size > 800) G.idx.delete(G.idx.keys().next().value);
  }
  notify();
  return item;
}

function stamp(line, seq) {
  if (!line.startsWith(PREFIX)) return line;
  try {
    const o = JSON.parse(line.slice(PREFIX.length));
    if (!o || typeof o !== "object") return line;
    o._s = seq;
    const out = PREFIX + JSON.stringify(o);
    return out.length <= 1990 ? out : line;
  } catch (e) {
    return line;
  }
}

// ============================================================================
// 7. GIAO TIẾP DISCORD DATA_CH & ĐỒNG BỘ MESH TOÀN MẠNG
// ============================================================================

function dFetch(env, path, method, body) {
  const token = String(env.BOT_TOKEN || "").trim().replace(/^Bot\s+/i, "");
  const init = {
    method,
    headers: {
      Authorization: `Bot ${token}`,
      "Content-Type": "application/json",
      "User-Agent": "DiscordBot (https://cb-roblox.workers.dev, 46.0)",
    },
  };
  if (body !== undefined) init.body = typeof body === "string" ? body : JSON.stringify(body);
  return fetch("https://discord.com/api/v10/" + path, init);
}

async function dPost(env, ch, content) {
  if (!ch || !env.BOT_TOKEN) return null;
  for (let i = 0; i < 3; i++) {
    let r;
    try {
      r = await dFetch(env, `channels/${ch}/messages`, "POST", {
        content: String(content || "").slice(0, 1990),
        allowed_mentions: { parse: [] },
      });
    } catch (e) {
      await sleep(300);
      continue;
    }
    if (r.status === 429) {
      let w = 1;
      try { w = (await r.json()).retry_after || 1; } catch (e) {}
      await sleep(Math.min(4000, w * 1000 + 100));
      continue;
    }
    if (r.ok) {
      try { return await r.json(); } catch (e) { return null; }
    }
    return null;
  }
  return null;
}

function queueDataPost(env, ctx, line, syncMesh = true) {
  // Luôn phát sóng tức thì sang 4 Server Backup còn lại và Server Boss (trừ khi đã phát sóng riêng luồng đầy đủ)
  if (syncMesh) broadcastMeshAndBossSoon(env, ctx, line);
  if (!env.BOT_TOKEN || !env.DATA_CH) return;
  G.dataQ.push(line);
  const now = Date.now();
  if (G.dataTimer && now - (G.dataTimerAt || 0) < 4000) return;
  G.dataTimer = true;
  G.dataTimerAt = now;
  bg(
    ctx,
    (async () => {
      await sleep(150);
      G.dataTimer = false;
      const q = G.dataQ.splice(0, G.dataQ.length);
      if (!q.length || !env.DATA_CH) return;
      let cur = "";
      for (const l of q) {
        if (!l) continue;
        if (cur && cur.length + 1 + l.length > 1950) {
          await dPost(env, env.DATA_CH, cur);
          cur = l;
        } else {
          cur = cur ? cur + "\n" + l : l;
        }
      }
      if (cur) await dPost(env, env.DATA_CH, cur);
    })()
  );
}

function emitPkt(env, ctx, pkt) {
  const line = PREFIX + JSON.stringify(pkt);
  const item = insert(pkt, line, null, false);
  const out = item ? stamp(line, item.seq) : line;
  queueDataPost(env, ctx, out);
  return item;
}

async function loadRolesChannel(env) {
  if (!env.ROLES_CH || !env.BOT_TOKEN) return;
  const r2 = await dFetch(env, `channels/${env.ROLES_CH}/messages?limit=40`, "GET");
  if (!r2.ok) return;
  const arr2 = await r2.json();
  if (!Array.isArray(arr2)) return;
  const ordered = arr2.slice().sort((a, b) => cmpId(a.id, b.id));
  for (const m of ordered) {
    if (typeof m.content !== "string") continue;
    for (const line of m.content.split("\n")) {
      const p = parseContent(line);
      if (p && (p.type === "roles" || p.type === "roles_part")) applyState(env, p, true, null);
    }
  }
}

async function refresh(env, ctx, force = false) {
  if (G.refreshing) return G.refreshing;
  const t = Date.now();
  if (!force && t - G.lastRefresh < REFRESH_MS) return;

  G.refreshing = (async () => {
    try {
      if (force || !G.bossOk) {
        await pullFromBoss(env, ctx, force);
      }
      if (G.profLastSyncAt === 0) await syncProfilesFromDiscordChannel(env, ctx, !G.lastDid, false);

      if (!env.BOT_TOKEN || !env.DATA_CH || Date.now() < G.backoffUntil) {
        G.ready = true;
        return;
      }
      const cold = !G.lastDid;
      if (env.ROLES_CH && (cold || Date.now() - G.rolesLoadedAt > 180000)) {
        G.rolesLoadedAt = Date.now();
        await loadRolesChannel(env);
      }
      if (cold && env.GENERAL_CH && G.generalArchive.length < 20) {
        try {
          const rg = await dFetch(env, `channels/${env.GENERAL_CH}/messages?limit=80`, "GET");
          if (rg.ok) {
            const gArr = await rg.json();
            if (Array.isArray(gArr)) {
              gArr.sort((a, b) => cmpId(a.id, b.id));
              for (const m of gArr) {
                if (typeof m.content !== "string") continue;
                const lines = m.content.split("\n");
                for (let li = 0; li < lines.length; li++) {
                  const pkt = parseContent(lines[li]);
                  if (!pkt || !pkt.type) continue;
                  applyState(env, pkt, true, ctx);
                  if (!SKIP_HISTORY.has(pkt.type)) insert(pkt, lines[li], `g:${m.id}:${li}`, false, Number(pkt._s) || snowMs(m.id));
                }
              }
            }
          }
        } catch (e) {}
      }
      const q = G.lastDid ? `&after=${G.lastDid}` : "";
      const r = await dFetch(env, `channels/${env.DATA_CH}/messages?limit=50${q}`, "GET");
      if (r.status === 429) {
        let w = 2;
        try { w = (await r.json()).retry_after || 2; } catch (e) {}
        G.backoffUntil = Date.now() + Math.min(10000, w * 1000 + 200);
        return;
      }
      if (!r.ok) return;
      const arr = await r.json();
      if (!Array.isArray(arr)) return;
      arr.sort((a, b) => cmpId(a.id, b.id));
      for (const m of arr) {
        if (!G.lastDid || cmpId(m.id, G.lastDid) > 0) G.lastDid = m.id;
        if (typeof m.content !== "string") continue;
        const lines = m.content.split("\n");
        for (let li = 0; li < lines.length; li++) {
          const pkt = parseContent(lines[li]);
          if (!pkt || !pkt.type) continue;
          const trustHistory = pkt.type !== "roles" && pkt.type !== "roles_part";
          applyState(env, pkt, trustHistory, ctx);
          if (SKIP_HISTORY.has(pkt.type)) continue;
          insert(pkt, lines[li], `d:${m.id}:${li}`, false, Number(pkt._s) || snowMs(m.id));
        }
      }
      G.ready = true;
    } catch (e) {}
    G.lastRefresh = Date.now();
  })().finally(() => {
    G.refreshing = null;
  });

  return G.refreshing;
}

// ============================================================================
// 8. CÁC HÀM XỬ LÝ API ENDPOINT CHO ROBLOX CLIENT (CB.lua)
// ============================================================================

function maybeBroadcastPresence(env, ctx, entry, isOff = false, changedServer = false) {
  if ((changedServer || isOff) && G.store && G.store.kind !== "kv") {
    saveStateSoon(ctx, 1200, "profiles");
  }
  if (!entry || !entry.u) {
    broadcastMeshAndBossSoon(env, ctx, "");
    return;
  }
  const uKey = String(entry.u).toLowerCase();
  const nowS = Number(entry.ts) || nowSec();
  const lastSync = G.presSyncAt.get(uKey) || 0;
  if (isOff === true || changedServer || lastSync === 0 || nowS - lastSync >= PRESENCE_TTL) {
    G.presSyncAt.set(uKey, nowS);
    while (G.presSyncAt.size > 600) G.presSyncAt.delete(G.presSyncAt.keys().next().value);
    const pkt = {
      type: "presence",
      packetId: "pr-" + uKey + "-" + nowS + (isOff ? "-off" : ""),
      u: entry.u,
      d: entry.d || entry.u,
      id: entry.id || 0,
      st: entry.st || "",
      bio: entry.bio || "",
      c: entry.c || "??",
      pb: entry.pb || "",
      pi: entry.pi || "",
      pt: entry.pt || null,
      sg: isOff ? false : !!entry.sg,
      mc: Number(entry.mc) || 0,
      pl: isOff ? 0 : entry.pl || 0,
      gn: isOff ? "" : entry.gn || "",
      jb: isOff ? "" : entry.jb || "",
      proxyId: G.proxyId,
      proxyName: G.proxyName,
      off: isOff ? true : undefined,
      ts: nowS,
    };
    const line = PREFIX + JSON.stringify(pkt);
    insert(pkt, line, null, true);
    queueDataPost(env, ctx, line);
  } else {
    broadcastMeshAndBossSoon(env, ctx, "");
  }
}

async function handleFeed(req, env, ctx, url) {
  const q = url.searchParams;
  const since = Number(q.get("since")) || 0;
  const limit = Math.min(MAX_ITEMS, Math.max(1, Number(q.get("limit")) || 60));
  const wait = Math.min(25, Math.max(0, Number(q.get("wait")) || 0));
  const rs = Number(q.get("rs")) || 0;
  const ss = Number(q.get("ss")) || 0;
  const es = Number(q.get("es")) || 0;
  const as = Number(q.get("as")) || 0;
  const ms = Number(q.get("ms")) || 0;
  const vws = Number(q.get("vws")) || 0;
  const gs = Number(q.get("gs")) || 0;
  const fbs = Number(q.get("fbs")) || 0;
  const lks = Number(q.get("lks")) || 0;
  const rawU = cleanName(q.get("u"));
  const me = rawU.toLowerCase();
  const gpl = Number(q.get("gpl")) || 0;
  const gjb = String(q.get("gjb") || "").trim();
  const staffView = !!me && isStaffName(env, me);

  if (rawU) {
    const nowInit = Math.max(nowSec(), (G.offAt.get(me) || 0) + 1);
    G.offAt.delete(me);
    const curProf = G.profiles.get(me) || {};
    const prevLive = G.pres.get(me) || {};
    const prev = { ...curProf, ...prevLive, d: prevLive.d || curProf.d, st: prevLive.st || curProf.st, bio: prevLive.bio || curProf.bio, c: (prevLive.c && prevLive.c !== "??") ? prevLive.c : curProf.c, pb: prevLive.pb || curProf.pb, pi: prevLive.pi || curProf.pi, pt: prevLive.pt || curProf.pt };
    const clearedAt = G.profClearedAt.get(me) || 0;
    const recentlyCleared = clearedAt > 0 && nowInit - clearedAt <= 60;
    const hasExplicitSg = q.has("sg");
    const sg = hasExplicitSg ? q.get("sg") === "1" || q.get("sg") === "true" : prev.sg !== undefined ? prev.sg : gpl > 0;
    const nextPl = sg ? Number(q.get("pl")) || gpl || prev.pl || 0 : 0;
    const nextJb = sg ? clip(q.get("jb") || gjb || prev.jb || "", 64) : "";
    const nextGn = sg ? clip(q.get("gn") || prev.gn || "", 60) : "";
    let pt = recentlyCleared ? null : prev.pt || null;
    if (!recentlyCleared) {
      const rawPtj = String(q.get("ptj") || "").trim();
      if (rawPtj && rawPtj !== "{}") {
        try {
          pt = sanitizeProfTheme(JSON.parse(rawPtj), prev.pt || null);
        } catch (e) {}
      } else if (q.get("ptb") || q.get("pta") || q.get("ptt") || q.get("ptbi") || q.get("ptm") || q.get("ptf")) {
        pt = sanitizeProfTheme(
          {
            ...(pt || {}),
            ...(q.get("ptb") ? { bg: q.get("ptb") } : {}),
            ...(q.get("pta") ? { acc: q.get("pta") } : {}),
            ...(q.get("ptt") ? { txt: q.get("ptt") } : {}),
            ...(q.get("ptbi") ? { bgImg: q.get("ptbi") } : {}),
            ...(q.get("ptm") ? { mode: q.get("ptm") } : {}),
            ...(q.get("ptf") ? { font: q.get("ptf") } : {}),
          },
          prev.pt || null
        );
      }
    }
    const qD = String(q.get("d") || "").trim();
    const qSt = String(q.get("st") || "").trim();
    const qBio = String(q.get("bio") || "").trim();
    const qC = String(q.get("c") || "").trim();
    const qPb = String(q.get("pb") || "").replace(/[^0-9]/g, "");
    const qPi = String(q.get("pi") || "").replace(/[^0-9]/g, "");
    const changedSrv = !prevLive.u || prev.pl !== nextPl || prev.jb !== nextJb || (nextGn && prev.gn !== nextGn) || prev.proxyId !== G.proxyId;
    const entry = {
      u: rawU,
      d: clip(recentlyCleared ? rawU : (qD && qD !== "?" ? qD : prev.d || rawU), 40),
      id: Number(q.get("id")) || prev.id || 0,
      st: recentlyCleared ? "" : qSt ? clip(qSt, 80) : prev.st || "",
      bio: recentlyCleared ? "" : qBio ? clip(qBio, 180) : prev.bio || "",
      c: recentlyCleared ? "??" : clip((qC && qC !== "??") ? qC : prev.c || "??", 3),
      pb: recentlyCleared ? "" : qPb ? clip(qPb, 16) : prev.pb || "",
      pi: recentlyCleared ? "" : qPi ? clip(qPi, 16) : prev.pi || "",
      pt,
      sg,
      pl: nextPl,
      gn: nextGn,
      jb: nextJb,
      proxyId: G.proxyId,
      proxyName: G.proxyName,
      mc: Math.max(Number(prev.mc) || 0, Number(q.get("mc")) || 0),
      ts: nowInit,
    };
    G.pres.set(me, entry);
    const savedProf = upsertProfile(entry, { allowClear: false });
    if (!recentlyCleared && hasCustomProfileData(savedProf || entry)) scheduleProfileCloudSave(env, ctx, savedProf || entry);
    maybeBroadcastPresence(env, ctx, entry, false, changedSrv);

    // Gộp `seen` đi nhờ ngay trong GET /api/feed (&seen=id1,id2,..., tối đa 30 ID) để giảm request POST /api/send
    const rawSeenParam = String(q.get("seen") || "").trim();
    if (rawSeenParam && !isSystemActor(rawU)) {
      const seenIds = rawSeenParam
        .split(",")
        .map((s) => String(s || "").trim().slice(0, 64))
        .filter((mid) => mid && !G.deletedIds.has(mid))
        .slice(0, 30);
      if (seenIds.length > 0) {
        const seenTs = nowSec();
        const patch = {};
        for (const mid of seenIds) patch[mid] = { [rawU]: seenTs };
        if (mergeSeenByMap(patch, 0)) {
          saveStateSoon(ctx, 1200, "chat");
          notify();
          broadcastMeshAndBossSoon(env, ctx, "");
        }
      }
    }
  }

  if (!G.ready) await refresh(env, ctx, true);
  else bg(ctx, refresh(env, ctx, false));

  for (const a of G.announces) {
    if (a && a.packetId && !G.deletedIds.has(String(a.packetId)) && !G.byPid.has(String(a.packetId))) {
      const line = PREFIX + JSON.stringify(a);
      insert(a, line, null, false, Number(a._s) || (Number(a.ts) || nowSec()) * 1000);
    }
  }
  for (const gi of G.generalArchive) {
    if (gi && gi.pid && !G.deletedIds.has(String(gi.pid)) && !G.byPid.has(String(gi.pid))) {
      const gp = parseContent(gi.c);
      if (gp && gp.type) insert(gp, gi.c, null, false, Number(gi.seq) || Number(gp._s) || 0);
    }
  }

  const isMemberOfChan = (i) => {
    if (i.chan && i.chan.startsWith("dm:grp_")) {
      if (Array.isArray(i.dm) && i.dm.length > 0 && i.content && i.content.includes('"type":"group_sync"')) {
        return !!(me && i.dm.includes(me));
      }
      const grpId = i.chan.slice(3).split("|")[0];
      const grp = G.groups.get(grpId);
      if (grp && Array.isArray(grp.members)) {
        return !!(me && grp.members.some((m) => String(m).toLowerCase() === me));
      }
      return !!(me && Array.isArray(i.dm) && i.dm.includes(me));
    }
    return !i.dm || (me && i.dm.includes(me));
  };
  const visible = (i) =>
    isMemberOfChan(i) &&
    (!i.so || staffView) &&
    (i.chan !== "game" || ((!gpl || !i.place || i.place === gpl) && (!gjb || !i.job || i.job === gjb)));

  const collect = () => {
    const out = [];
    const arr = G.items;
    const n = arr.length;
    if (since > 0) {
      let lo = 0;
      let hi = n;
      while (lo < hi) {
        const mid = (lo + hi) >> 1;
        if (arr[mid].seq <= since) lo = mid + 1;
        else hi = mid;
      }
      for (let k = lo; k < n; k++) {
        const i = arr[k];
        if (visible(i)) out.push({ seq: i.seq, c: i.content });
      }
    } else {
      let regCount = 0;
      for (let k = n - 1; k >= 0; k--) {
        const i = arr[k];
        if (i.eph || !visible(i)) continue;
        if (i.chan === "announce") {
          out.push({ seq: i.seq, c: i.content });
        } else if (regCount < limit) {
          regCount++;
          out.push({ seq: i.seq, c: i.content });
        }
      }
      out.reverse();
    }
    return out;
  };

  const rolesChanged = () => (since === 0 && G.rolesSeq > 0) || (q.has("rs") && G.rolesSeq > rs);
  const scriptsChanged = () => since === 0 || (q.has("ss") && G.scriptSeq > ss);
  const emojisChanged = () => since === 0 || (q.has("es") && G.emojiSeq > es);
  const announcesChanged = () => since === 0 || (q.has("as") && G.announceSeq > as);
  const modChanged = () => since === 0 || (q.has("ms") && G.modSeq > ms);
  const seenChanged = () => since === 0 || (q.has("vws") && G.seenSeq > vws);
  const groupsChanged = () => since === 0 || (q.has("gs") && G.groupSeq > gs);
  const feedbacksChanged = () => since === 0 || (q.has("fbs") && G.feedbackSeq > fbs);
  const lockdownChanged = () => q.has("lks") && G.lockdownSeq > lks;
  const anyStateChanged = () =>
    rolesChanged() ||
    scriptsChanged() ||
    emojisChanged() ||
    announcesChanged() ||
    modChanged() ||
    seenChanged() ||
    groupsChanged() ||
    feedbacksChanged() ||
    lockdownChanged();

  let out = collect();
  if (!out.length && wait > 0 && since > 0 && !anyStateChanged()) {
    const startedAt = Date.now();
    const end = startedAt + wait * 1000;
    let refreshed = false;
    let lastNonDoSync = startedAt;
    const isDo = Boolean(G.store && G.store.kind === "do");
    while (!out.length && !anyStateChanged() && Date.now() < end) {
      const t = Date.now();
      if (!isDo && t - lastNonDoSync >= 3000) {
        lastNonDoSync = t;
        await syncState(env, ctx, true).catch(() => {});
        out = collect();
        if (out.length || anyStateChanged()) break;
      }
      if (!refreshed && t - startedAt >= 5500) {
        refreshed = true;
        bg(ctx, refresh(env, ctx, false));
      }
      await waitInsert(Math.min(2500, end - t));
      out = collect();
    }
  }

  const nowS = nowSec();
  if (rawU && G.pres.has(me)) {
    const myPres = G.pres.get(me);
    myPres.ts = Math.max(nowS, Number(myPres.ts) || 0);
    G.offAt.delete(me);
    upsertProfile(myPres, { allowClear: false });
  }
  prunePresenceMap(nowS, me);
  for (const [mk, mv] of G.mutes) {
    if (mv && mv.exp > 0 && mv.exp <= nowS) G.mutes.delete(mk);
  }
  for (const [bk, bv] of G.banned) {
    if (bv && bv.exp > 0 && bv.exp <= nowS) G.banned.delete(bk);
  }

  const mInfo = rawU ? mutedNow(rawU) : null;
  const bInfo = rawU ? isBanned(rawU) : null;
  const sendMod = modChanged();
  const visibleGroups = groupsChanged()
    ? [...G.groups.values()].filter(
        (g) => staffView || !me || (Array.isArray(g.members) && g.members.some((m) => String(m).toLowerCase() === me))
      )
    : undefined;
  const visibleFeedbacks = feedbacksChanged()
    ? [...G.feedbacks.values()].filter((f) => staffView || (me && String(f.author || "").toLowerCase() === me)).slice(-60)
    : undefined;

  const activeMigrateTo = G.migrateTo && Date.now() < (G.migrateToUntil || 0) ? G.migrateTo : "";
  if (!activeMigrateTo && G.migrateTo) {
    G.migrateTo = "";
    G.migrateToUntil = 0;
  }

  return json({
    ok: true,
    proxyId: G.proxyId,
    proxyName: G.proxyName,
    migrateTo: activeMigrateTo || undefined,
    messages: out,
    strong: !!(G.store && G.store.kind === "do"),
    ready: !!(G.ready && (G.stateInit || !G.store)),
    nowMs: Date.now(),
    rolesSeq: G.rolesSeq,
    roles: rolesChanged() ? G.roles : undefined,
    emojis: emojisChanged() ? G.emojis : undefined,
    emojiSeq: G.emojiSeq,
    scriptSeq: G.scriptSeq,
    scripts: scriptsChanged() ? G.scripts : undefined,
    announceSeq: G.announceSeq,
    announces: announcesChanged() ? G.announces : undefined,
    modSeq: G.modSeq,
    punishments: sendMod ? G.punishments : undefined,
    mutesAll: sendMod ? Object.fromEntries(G.mutes) : undefined,
    warnsAll: sendMod ? Object.fromEntries(G.warns) : undefined,
    bannedAll: sendMod ? Object.fromEntries(G.banned) : undefined,
    seenSeq: G.seenSeq,
    seenBy: seenChanged() ? Object.fromEntries(G.seenBy) : undefined,
    groupSeq: G.groupSeq,
    groups: visibleGroups,
    feedbackSeq: G.feedbackSeq,
    feedbacks: visibleFeedbacks,
    lockdown: G.lockdown,
    lockdownSeq: G.lockdownSeq,
    profSeq: G.profSeq,
    users: [...G.pres.values()],
    profiles: since === 0 ? [...G.profiles.values()].filter((p) => p && p.u && !isSystemActor(p.u)).slice(-250) : undefined,
    devs: devNames(env),
    mute: mInfo ? { reason: mInfo.reason, exp: mInfo.exp, by: mInfo.by, ts: mInfo.ts } : null,
    banned: bInfo ? { reason: bInfo.reason, exp: bInfo.exp, by: bInfo.by, ts: bInfo.ts } : null,
    pending: staffView ? [...G.reqs.values()].filter((r) => r.status === "pending").length : 0,
    now: nowS,
  });
}

async function handleSend(req, env, ctx) {
  const ip = clientIp(req);
  if (limited("ip:" + ip, 40, 5000)) return json({ ok: false, error: "rate", retry_after: 2 }, 429);
  let body;
  try {
    body = await req.json();
  } catch (e) {
    return json({ ok: false, error: "json" }, 400);
  }
  const content = String(body.content || "");
  if (content.length < 8 || content.length > 1950) return json({ ok: false, error: "size" }, 413);
  const pkt = parseContent(content);
  if (!pkt || !pkt.type) return json({ ok: false, error: "packet" }, 400);
  const t = String(pkt.type);
  if (SEND_BLOCK.has(t)) return json({ ok: false, error: "forbidden_type" }, 403);
  if (t === "react" || t === "script_react") {
    const tg = String(pkt.target || pkt.scriptId || "");
    const em = String(pkt.emoji || "");
    if (!tg || tg.length > REACT_MAX || !em || em.length > REACT_MAX) return json({ ok: false, error: "react" }, 400);
  }
  const ident = String(pkt.by || pkt.author || pkt.voter || pkt.closer || pkt.reporter || pkt.target || "").slice(0, 40);
  const banned = isBanned(ident);
  if (banned && !isDev(env, ident)) {
    return json({ ok: false, error: "banned", reason: banned.reason, exp: banned.exp }, 403);
  }
  if (RATE_TYPES.has(t) && ident && limited("u:" + ident.toLowerCase(), 16, 10000)) {
    return json({ ok: false, error: "rate", retry_after: 3 }, 429);
  }
  if (G.lockdown && G.lockdown.active && MUTE_BLOCK.has(t) && !isStaffName(env, ident)) {
    return json(
      {
        ok: false,
        error: "lockdown",
        by: G.lockdown.by || "Admin",
        reason: `🔒 Kênh chat toàn server đang tạm khóa bởi @${G.lockdown.by}: ${G.lockdown.reason || "Chống spam"}`,
        exp: 0,
      },
      403
    );
  }
  if (MUTE_BLOCK.has(t)) {
    const m = mutedNow(pkt.author || pkt.by || pkt.voter);
    if (m) return json({ ok: false, error: "muted", reason: m.reason, exp: m.exp }, 403);
  }
  if (String(pkt.chan || "") === "announce" && (t === "msg" || t === "edit" || t === "poll") && !canAnnounceName(env, ident)) {
    return json({ ok: false, error: "announce_only" }, 403);
  }
  if (String(pkt.chan || "") === "punish" && (t === "msg" || t === "edit" || t === "poll") && !isStaffName(env, ident)) {
    return json({ ok: false, error: "staff_only" }, 403);
  }
  if ((t === "mute" || t === "unmute" || t === "warn" || t === "clear_warn" || t === "ban" || t === "unban" || t === "punish_del") && !isStaffName(env, ident)) {
    return json({ ok: false, error: "staff_only" }, 403);
  }
  if (t === "delete") {
    const tg = String(pkt.target || "");
    const staff = isStaffName(env, ident);
    if (!staff) {
      const isAnnTarget = String(pkt.chan || "") === "announce" || G.announces.some((x) => x.packetId === tg);
      const isPunTarget = String(pkt.chan || "") === "punish" || G.punishments.some((x) => x.id === tg);
      if (isAnnTarget || isPunTarget) return json({ ok: false, error: "staff_only" }, 403);
      const refIdx = G.idx.get(tg);
      if (refIdx && String(refIdx.a || "").toLowerCase() !== ident.toLowerCase()) {
        return json({ ok: false, error: "forbidden" }, 403);
      }
    }
  }
  const eph = EPHEMERAL.has(t);
  applyState(env, pkt, false, ctx);
  const item = insert(pkt, content, null, eph);
  if (!item) return json({ ok: true, dup: true });
  let nextMc;
  if (t === "msg") {
    nextMc = bumpProfileMsgCount(pkt.author, pkt.packetId, pkt);
  }
  const stamped = stamp(content, item.seq);
  if (String(pkt.chan || "general") === "general" && (t === "msg" || t === "poll")) {
    saveStateSoon(ctx, 0, "chat");
    if (env.GENERAL_CH && env.BOT_TOKEN) {
      bg(ctx, dPost(env, env.GENERAL_CH, stamped));
    }
  } else if (t === "msg" || t === "seen") {
    saveStateSoon(ctx, t === "seen" ? 1200 : 0, "chat");
  }
  if (!eph) {
    queueDataPost(env, ctx, stamped);
  } else {
    broadcastMeshAndBossSoon(env, ctx, stamped);
  }
  return json({ ok: true, seq: item.seq, ...(nextMc !== undefined ? { mc: nextMc } : {}) });
}

async function handlePresence(req, env, ctx) {
  const ip = clientIp(req);
  if (limited("pip:" + ip, 40, 10000)) return json({ ok: false, error: "rate" }, 429);
  let b;
  try {
    b = await req.json();
  } catch (e) {
    return json({ ok: false }, 400);
  }
  const u = cleanName(b.u);
  if (!u) return json({ ok: false, error: "u" }, 400);
  const uKey = u.toLowerCase();
  const t = nowSec();
  const clearedAt = G.profClearedAt.get(uKey) || 0;
  const recentlyCleared = clearedAt > 0 && t - clearedAt <= 60;
  if (b.off) {
    const cur = G.pres.get(uKey) || G.profiles.get(uKey) || {};
    const offTs = markUserOffline(u, Math.max(t, (Number(cur.ts) || 0) + 1), {
      ...cur,
      u,
      d: recentlyCleared ? u : b.d || cur.d || u,
      id: Number(b.id) || cur.id || 0,
      st: recentlyCleared ? "" : b.st !== undefined ? b.st : cur.st,
      bio: recentlyCleared ? "" : b.bio !== undefined ? b.bio : cur.bio,
      pb: recentlyCleared ? "" : b.pb !== undefined ? b.pb : cur.pb,
      pi: recentlyCleared ? "" : b.pi !== undefined ? b.pi : cur.pi,
      pt: recentlyCleared ? null : b.pt !== undefined ? b.pt : cur.pt,
    });
    saveStateSoon(ctx, 0, "profiles");
    notify();
    maybeBroadcastPresence(env, ctx, { u, d: recentlyCleared ? u : b.d || cur.d, id: Number(b.id) || cur.id, ts: offTs }, true, true);
  } else {
    const liveTs = Math.max(t, (G.offAt.get(uKey) || 0) + 1);
    G.offAt.delete(uKey);
    const sg = b.sg !== undefined ? Boolean(b.sg) : Number(b.pl) > 0;
    const curProfP = G.profiles.get(uKey) || {};
    const prevLiveP = G.pres.get(uKey) || {};
    const prev = { ...curProfP, ...prevLiveP, d: prevLiveP.d || curProfP.d, st: prevLiveP.st || curProfP.st, bio: prevLiveP.bio || curProfP.bio, c: (prevLiveP.c && prevLiveP.c !== "??") ? prevLiveP.c : curProfP.c, pb: prevLiveP.pb || curProfP.pb, pi: prevLiveP.pi || curProfP.pi, pt: prevLiveP.pt || curProfP.pt };
    let pt = recentlyCleared ? null : prev.pt || null;
    if (!recentlyCleared && b.pt && typeof b.pt === "object") {
      const cleaned = sanitizeProfTheme(b.pt, null);
      if (cleaned) pt = cleaned;
    }
    const nextPl = sg ? Number(b.pl) || prev.pl || 0 : 0;
    const nextGn = sg ? clip(b.gn || prev.gn || "", 60) : "";
    const nextJb = sg ? clip(b.jb || prev.jb || "", 64) : "";
    const bSt = b.st !== undefined ? clip(String(b.st || "").trim(), 80) : "";
    const bBio = b.bio !== undefined ? clip(String(b.bio || "").trim(), 180) : "";
    const bC = b.c ? clip(String(b.c || "").trim(), 3) : "";
    const bPb = b.pb !== undefined ? clip(String(b.pb || "").replace(/[^0-9]/g, ""), 16) : "";
    const bPi = b.pi !== undefined ? clip(String(b.pi || "").replace(/[^0-9]/g, ""), 16) : "";
    const bD = b.d ? clip(String(b.d || "").trim(), 40) : "";
    const changedSrv = !prevLiveP.u || prev.pl !== nextPl || prev.jb !== nextJb || (nextGn && prev.gn !== nextGn) || prev.proxyId !== G.proxyId;
    const entry = {
      u,
      d: recentlyCleared ? u : (bD && bD !== "?" ? bD : prev.d || u),
      id: Number(b.id) || prev.id || 0,
      st: recentlyCleared ? "" : bSt || prev.st || "",
      bio: recentlyCleared ? "" : bBio || prev.bio || "",
      c: recentlyCleared ? "??" : (bC && bC !== "??" ? bC : prev.c || "??"),
      pb: recentlyCleared ? "" : bPb || prev.pb || "",
      pi: recentlyCleared ? "" : bPi || prev.pi || "",
      pt,
      sg,
      pl: nextPl,
      gn: nextGn,
      jb: nextJb,
      proxyId: G.proxyId,
      proxyName: G.proxyName,
      mc: Math.max(Number(prev.mc) || 0, Number(b.mc) || 0),
      ts: liveTs,
    };
    G.pres.set(uKey, entry);
    const savedProf = upsertProfile(entry, { allowClear: false });
    saveStateSoon(ctx, 0, "profiles");
    if (!recentlyCleared && hasCustomProfileData(savedProf || entry)) scheduleProfileCloudSave(env, ctx, savedProf || entry);
    maybeBroadcastPresence(env, ctx, entry, false, changedSrv);
  }
  prunePresenceMap(t);
  const users = [...G.pres.values()];
  const m = mutedNow(u);
  const bn = isBanned(u);
  return json({
    ok: true,
    proxyId: G.proxyId,
    proxyName: G.proxyName,
    now: t,
    users,
    mute: m ? { reason: m.reason, exp: m.exp, by: m.by } : null,
    banned: bn ? { reason: bn.reason, exp: bn.exp } : null,
  });
}

function cleanRoles(body) {
  const roles = [];
  const ids = new Set();
  for (const r of (Array.isArray(body.roles) ? body.roles : []).slice(0, 40)) {
    if (!r || typeof r !== "object") continue;
    const id = String(r.id || "").replace(/[^A-Za-z0-9_-]/g, "").slice(0, 16);
    const name = clip(String(r.name || "").trim(), 24);
    if (!id || !name || ids.has(id)) continue;
    ids.add(id);
    const color = /^#[0-9a-fA-F]{6}$/.test(String(r.color)) ? String(r.color).toUpperCase() : "#5865F2";
    const ic = typeof r.icon === "string" ? r.icon : "";
    const icon = /^img:\d{1,15}$/.test(ic) || (ic.length > 0 && ic.length <= 8 && !/[\u0000-\u001f]/.test(ic)) ? ic : "";
    roles.push({
      id,
      name,
      color,
      icon,
      position: Math.max(-1000, Math.min(1000, Number(r.position) || 0)),
      isAdmin: r.isAdmin === true,
      mentionAll: r.mentionAll === true,
      canAnnounce: r.canAnnounce === true,
    });
  }
  const assign = {};
  const lower = new Map();
  const src = body.assign && typeof body.assign === "object" ? body.assign : {};
  let n = 0;
  for (const u of Object.keys(src)) {
    if (n >= 800) break;
    if (!/^[A-Za-z0-9_]{1,40}$/.test(u)) continue;
    const v = src[u];
    const list = Array.isArray(v) ? v : typeof v === "string" ? [v] : v && typeof v === "object" ? Object.keys(v).filter((k) => v[k]) : [];
    const set = {};
    for (const rid of list.slice(0, 12)) if (ids.has(String(rid))) set[String(rid)] = true;
    if (!Object.keys(set).length) continue;
    const lk = u.toLowerCase();
    let key = lower.get(lk);
    if (!key) {
      key = u;
      lower.set(lk, key);
      assign[key] = {};
      n++;
    }
    Object.assign(assign[key], set);
  }
  return { roles, assign };
}

function broadcastRoles(env, ctx, by) {
  const g = G.roles;
  const built = rolesLines(g.seq, by, g.roles, g.assign);
  if (built.whole) {
    insert({ type: "roles", by, roles: g.roles, assign: g.assign, seq: g.seq, packetId: "roles-" + g.seq }, built.whole, null, false);
    if (env.ROLES_CH) bg(ctx, dPost(env, env.ROLES_CH, built.whole));
    queueDataPost(env, ctx, built.whole);
  } else {
    for (const line of built.parts) {
      if (env.ROLES_CH) bg(ctx, dPost(env, env.ROLES_CH, line));
      queueDataPost(env, ctx, line);
    }
  }
  saveStateSoon(ctx, 0, "mod");
  notify();
}

async function handleRoles(req, env, ctx) {
  let body;
  try {
    body = await req.json();
  } catch (e) {
    return json({ ok: false, error: "json" }, 400);
  }
  const by = cleanName(body.by);
  if (!isDev(env, by)) return json({ ok: false, error: "forbidden" }, 403);
  await pullFromBoss(env, ctx, true);
  const base = Number(body.base) || 0;
  if (G.roles && G.rolesSeq > base && body.force !== true) {
    return json({ ok: false, error: "stale", seq: G.rolesSeq, roles: G.roles }, 409);
  }
  const { roles, assign } = cleanRoles(body || {});
  G.roles = { roles, assign, by, seq: Math.max(Date.now(), G.rolesSeq + 1) };
  G.rolesSeq = G.roles.seq;
  broadcastRoles(env, ctx, by);
  return json({ ok: true, seq: G.roles.seq, roles: G.roles });
}

async function handleRequest(req, env, ctx) {
  const ip = clientIp(req);
  if (limited("rq:" + ip, 6, 300000)) return json({ ok: false, error: "rate", retry_after: 60 }, 429);
  let b;
  try {
    b = await req.json();
  } catch (e) {
    return json({ ok: false, error: "json" }, 400);
  }
  const u = cleanName(b.u);
  const rid = String(b.role || "").slice(0, 24);
  const reason = clip(String(b.reason || ""), 200);
  if (!u) return json({ ok: false, error: "u" }, 400);
  if (!rid) return json({ ok: false, error: "role" }, 400);
  const key = u.toLowerCase();
  const banned = isBanned(u);
  if (banned) return json({ ok: false, error: "banned", reason: banned.reason }, 403);
  const cur = G.reqs.get(key);
  if (cur && cur.status === "pending") return json({ ok: false, error: "pending" }, 409);
  if (!G.roles || !G.roles.roles.find((r) => r.id === rid)) return json({ ok: false, error: "role_not_found" }, 404);
  const r = { u, role: rid, reason, ts: nowSec(), status: "pending" };
  G.reqs.set(key, r);
  saveStateSoon(ctx, 0, "mod");
  const pkt = { type: "request", packetId: "req-" + key + "-" + r.ts, by: u, role: rid, reason, chan: "staff", ts: r.ts };
  emitPkt(env, ctx, pkt);
  return json({ ok: true, request: r });
}

async function handleApprove(req, env, ctx) {
  let b;
  try {
    b = await req.json();
  } catch (e) {
    return json({ ok: false, error: "json" }, 400);
  }
  const by = cleanName(b.by);
  if (!isDev(env, by)) return json({ ok: false, error: "forbidden" }, 403);
  const u = cleanName(b.u);
  const rid = String(b.role || "").slice(0, 24);
  const action = String(b.action || "approve");
  if (!u) return json({ ok: false, error: "u" }, 400);
  const key = u.toLowerCase();
  await pullFromBoss(env, ctx, true);
  if (action === "reject") {
    const r = G.reqs.get(key);
    if (r) {
      r.status = "rejected";
      r.by = by;
      r.ts2 = nowSec();
    }
    saveStateSoon(ctx, 0, "mod");
    emitPkt(env, ctx, { type: "request_result", packetId: "rr-" + key + "-" + nowSec(), by, target: u, action: "reject", chan: "staff", ts: nowSec() });
    return json({ ok: true });
  }
  if (action === "ban") {
    const r = G.reqs.get(key);
    const banReason = clip(String(b.reason || "Bị từ chối xin quyền / Vi phạm quy định"), 300);
    const ts = nowSec();
    if (r) {
      r.status = "banned";
      r.by = by;
      r.ts2 = ts;
    }
    G.banned.set(key, { u, reason: banReason, exp: 0, by, ts });
    if (G.roles && dropAssign(u)) {
      G.roles.seq = Math.max(Date.now(), G.rolesSeq + 1);
      G.rolesSeq = G.roles.seq;
      broadcastRoles(env, ctx, by);
    }
    const pid = "ban-" + key + "-" + ts;
    pushPunishment({ id: pid, action: "ban", target: u, by, reason: banReason, exp: 0, ts }, ctx);
    emitPkt(env, ctx, { type: "request_result", packetId: "rr-" + key + "-" + ts, by, target: u, reason: banReason, action: "ban", chan: "staff", ts });
    emitPkt(env, ctx, { type: "ban", packetId: pid, by, target: u, reason: banReason, chan: "punish", ts });
    return json({ ok: true });
  }
  if (!rid) return json({ ok: false, error: "role" }, 400);
  if (!G.roles) G.roles = { roles: [], assign: {}, by, seq: Date.now() };
  const role = G.roles.roles.find((x) => x.id === rid);
  if (!role) return json({ ok: false, error: "role_not_found" }, 404);
  const ak = assignKeyOf(u) || u;
  if (!G.roles.assign[ak]) G.roles.assign[ak] = {};
  G.roles.assign[ak][rid] = true;
  G.roles.seq = Math.max(Date.now(), G.rolesSeq + 1);
  G.rolesSeq = G.roles.seq;
  G.roles.by = by;
  broadcastRoles(env, ctx, by);
  const r = G.reqs.get(key);
  if (r) {
    r.status = "approved";
    r.by = by;
    r.ts2 = nowSec();
  }
  saveStateSoon(ctx, 0, "mod");
  emitPkt(env, ctx, { type: "request_result", packetId: "rr-" + key + "-" + nowSec(), by, target: u, role: role.name, action: "approve", chan: "staff", ts: nowSec() });
  return json({ ok: true, seq: G.roles.seq, roles: G.roles });
}

async function handleRevoke(req, env, ctx) {
  let b;
  try {
    b = await req.json();
  } catch (e) {
    return json({ ok: false, error: "json" }, 400);
  }
  const by = cleanName(b.by);
  if (!isDev(env, by)) return json({ ok: false, error: "forbidden" }, 403);
  const u = cleanName(b.u);
  if (!u) return json({ ok: false, error: "u" }, 400);
  if (isDev(env, u)) return json({ ok: false, error: "cannot_revoke_dev" }, 403);
  await pullFromBoss(env, ctx, true);
  if (!G.roles) return json({ ok: false, error: "no_roles" }, 404);
  const reason = clip(String(b.reason || "Thu hồi quyền (Role) bởi Developer"), 300);
  const ts = nowSec();
  dropAssign(u);
  G.roles.seq = Math.max(Date.now(), G.rolesSeq + 1);
  G.rolesSeq = G.roles.seq;
  broadcastRoles(env, ctx, by);
  const pid = "rev-" + u.toLowerCase() + "-" + ts;
  pushPunishment({ id: pid, action: "revoke", target: u, by, reason, exp: 0, ts }, ctx);
  emitPkt(env, ctx, { type: "revoke", packetId: pid, by, target: u, reason, chan: "punish", ts });
  return json({ ok: true, seq: G.roles.seq, roles: G.roles });
}

async function handleUnban(req, env, ctx) {
  let b;
  try {
    b = await req.json();
  } catch (e) {
    return json({ ok: false, error: "json" }, 400);
  }
  const by = cleanName(b.by);
  if (!isStaffName(env, by)) return json({ ok: false, error: "forbidden" }, 403);
  const u = cleanName(b.u);
  if (!u) return json({ ok: false, error: "u" }, 400);
  const key = u.toLowerCase();
  const reason = clip(String(b.reason || "Được gỡ cấm (Unbanned) bởi Dev/Admin"), 300);
  const ts = nowSec();
  G.banned.delete(key);
  G.reqs.delete(key);
  const pid = "unb-" + key + "-" + ts;
  pushPunishment({ id: pid, action: "unban", target: u, by, reason, exp: 0, ts }, ctx);
  emitPkt(env, ctx, { type: "unban", packetId: pid, by, target: u, reason, chan: "punish", ts });
  return json({ ok: true });
}

async function handleRequestsList(req, env, ctx, url) {
  const u = cleanName(url.searchParams.get("by"));
  if (!isStaffName(env, u)) return json({ ok: false, error: "forbidden" }, 403);
  await refresh(env, ctx, true);
  const list = [...G.reqs.values()].filter((r) => r.status === "pending");
  const banned = [...G.banned.entries()].map(([k, v]) => ({ u: k, ...v }));
  return json({ ok: true, requests: list, banned });
}

async function handleEmoji(req, env, ctx) {
  const ip = clientIp(req);
  if (limited("em:" + ip, 25, 60000)) return json({ ok: false, error: "rate" }, 429);
  let b;
  try {
    b = await req.json();
  } catch (e) {
    return json({ ok: false, error: "json" }, 400);
  }
  const by = cleanName(b.by);
  if (!by) return json({ ok: false, error: "by" }, 400);
  if (isBanned(by) && !isDev(env, by)) return json({ ok: false, error: "banned" }, 403);
  const action = String(b.action || "add");
  const staff = isStaffName(env, by);
  if (action === "remove" || action === "remove_multi") {
    const rawIds = Array.isArray(b.ids) ? b.ids : b.id ? [b.id] : [];
    const targetIds = new Set(rawIds.map((x) => String(x || "").replace(/[^0-9]/g, "")).filter(Boolean));
    if (!targetIds.size) return json({ ok: false, error: "id" }, 400);
    if (!staff) {
      const allMine = [...targetIds].every((tid) => {
        const found = G.emojis.find((e) => e.id === tid);
        return found && String(found.by || "").toLowerCase() === by.toLowerCase();
      });
      if (!allMine || targetIds.size > 1) return json({ ok: false, error: "forbidden" }, 403);
    }
    const before = G.emojis.length;
    G.emojis = G.emojis.filter((e) => !targetIds.has(String(e.id)));
    const removedCount = before - G.emojis.length;
    if (removedCount > 0) {
      G.emojiSeq = Math.max(Date.now(), G.emojiSeq + 1);
      saveStateSoon(ctx, 0, "scripts");
      emitPkt(env, ctx, { type: "emoji_sync", packetId: "ems-" + Date.now(), action: "remove", ids: [...targetIds], by, chan: "general", ts: nowSec() });
      notify();
    }
    return json({ ok: true, removed: removedCount, emojis: G.emojis, emojiSeq: G.emojiSeq });
  }
  if (action === "rename") {
    const id = String(b.id || "").replace(/[^0-9]/g, "").slice(0, 15);
    const name = cleanEmojiName(b.name);
    const target = G.emojis.find((e) => e.id === id);
    if (!target) return json({ ok: false, error: "not_found" }, 404);
    if (!staff && String(target.by || "").toLowerCase() !== by.toLowerCase()) return json({ ok: false, error: "forbidden" }, 403);
    target.name = name;
    G.emojiSeq = Math.max(Date.now(), G.emojiSeq + 1);
    saveStateSoon(ctx, 0, "scripts");
    notify();
    return json({ ok: true, emojis: G.emojis, emojiSeq: G.emojiSeq });
  }
  if (mutedNow(by)) return json({ ok: false, error: "muted" }, 403);
  const id = String(b.id || "").replace(/[^0-9]/g, "").slice(0, 15);
  const name = cleanEmojiName(b.name);
  if (!id || id.length < 5) return json({ ok: false, error: "id" }, 400);
  const existing = G.emojis.find((e) => e.id === id);
  if (existing) {
    if (staff || String(existing.by || "").toLowerCase() === by.toLowerCase()) {
      existing.name = name;
      G.emojiSeq = Math.max(Date.now(), G.emojiSeq + 1);
      saveStateSoon(ctx, 0, "scripts");
      notify();
      return json({ ok: true, updated: true, emojis: G.emojis, emojiSeq: G.emojiSeq });
    }
    return json({ ok: false, error: "exists" }, 409);
  }
  if (G.emojis.length >= MAX_EMOJIS) return json({ ok: false, error: "full" }, 400);
  G.emojis.push({ id, name, by, ts: nowSec() });
  G.emojiSeq = Math.max(Date.now(), G.emojiSeq + 1);
  saveStateSoon(ctx, 0, "scripts");
  emitPkt(env, ctx, { type: "emoji_sync", packetId: "ema-" + id + "-" + Date.now(), action: "add", id, name, by, chan: "general", ts: nowSec() });
  notify();
  return json({ ok: true, emojis: G.emojis, emojiSeq: G.emojiSeq });
}

function emitScriptSyncPacket(env, ctx, fullPkt, rawCode) {
  const code = String(rawCode || "");
  const fullLine = PREFIX + JSON.stringify(fullPkt);
  const item = insert(fullPkt, fullLine, null, false);
  const fullOut = item ? stamp(fullLine, item.seq) : fullLine;
  // Tách biệt luồng phát sóng HTTP (/api/boss-sync & /api/peer-sync) để giữ nguyên tối đa 15.000 ký tự code
  broadcastMeshAndBossSoon(env, ctx, fullOut);
  // Chuỗi đẩy vào queueDataPost lên Discord DATA_CH cắt ngắn code xuống tối đa 1.100 ký tự
  const discordPkt = { ...fullPkt, code: code.slice(0, 1100) };
  let discordLine = PREFIX + JSON.stringify(discordPkt);
  while (discordLine.length > 1920 && discordPkt.code.length > 80) {
    discordPkt.code = discordPkt.code.slice(0, Math.max(80, Math.floor(discordPkt.code.length * 0.75)));
    discordLine = PREFIX + JSON.stringify(discordPkt);
  }
  const discordOut = item ? stamp(discordLine, item.seq) : discordLine;
  queueDataPost(env, ctx, discordOut, false);
}

async function handleScripts(req, env, ctx) {
  const ip = clientIp(req);
  if (limited("sc:" + ip, 30, 60000)) return json({ ok: false, error: "rate" }, 429);
  let b = {};
  if (req.method === "POST") {
    try {
      b = await req.json();
    } catch (e) {
      return json({ ok: false, error: "json" }, 400);
    }
  }
  const action = String(b.action || "list");
  const by = cleanName(b.by || b.author || b.reporter || "");
  if (action === "list") return json({ ok: true, scripts: G.scripts, scriptSeq: G.scriptSeq });
  if (!by) return json({ ok: false, error: "by" }, 400);
  const banned = isBanned(by);
  if (banned && !isDev(env, by)) return json({ ok: false, error: "banned", reason: banned.reason }, 403);
  const staff = isStaffName(env, by);

  if (action === "create" || action === "post") {
    const m = mutedNow(by);
    if (m) return json({ ok: false, error: "muted", reason: m.reason, exp: m.exp }, 403);
    if (limited("sc_post:" + by.toLowerCase(), 4, 60000)) return json({ ok: false, error: "rate" }, 429);
    const title = clip(String(b.title || "").trim(), 80);
    const tag = clip(String(b.tag || "Universal").trim(), 24) || "Universal";
    const desc = clip(String(b.desc || "").trim(), 300);
    const code = String(b.code || "").slice(0, 15000);
    if (!title || !code.trim()) return json({ ok: false, error: "missing_fields" }, 400);
    const id = String(b.id || "sc-" + Date.now() + "-" + Math.random().toString(36).slice(2, 7));
    const topic = {
      id,
      title,
      tag,
      desc,
      code,
      author: by,
      display: clip(String(b.display || by), 40),
      uid: Number(b.uid) || 1,
      placeId: Number(b.placeId) || 0,
      gameName: clip(String(b.gameName || ""), 60),
      ts: nowSec(),
      reactions: {},
      comments: [],
      reports: [],
      ver: 1,
      editedAt: 0,
      editedBy: "",
      changelog: "",
    };
    G.scripts.push(topic);
    while (G.scripts.length > MAX_SCRIPTS) G.scripts.shift();
    upsertProfile({
      u: by,
      d: topic.display || by,
      id: topic.uid,
      pl: topic.placeId,
      gn: topic.gameName,
      ts: Number(topic.ts) || nowSec(),
    }, { allowClear: false });
    G.scriptSeq = Math.max(Date.now(), G.scriptSeq + 1);
    saveStateSoon(ctx, 0, "scripts");
    notify();
    const fullPkt = {
      type: "script_post",
      packetId: id,
      scriptId: id,
      title,
      tag,
      desc,
      code,
      author: by,
      display: topic.display,
      uid: topic.uid,
      placeId: topic.placeId,
      gameName: topic.gameName,
      ver: 1,
      chan: "scripts",
      ts: topic.ts,
    };
    emitScriptSyncPacket(env, ctx, fullPkt, code);
    return json({ ok: true, topic, scripts: G.scripts, scriptSeq: G.scriptSeq });
  }

  if (action === "edit" || action === "update") {
    const m = mutedNow(by);
    if (m) return json({ ok: false, error: "muted", reason: m.reason, exp: m.exp }, 403);
    if (limited("sc_edit:" + by.toLowerCase(), 8, 60000)) return json({ ok: false, error: "rate" }, 429);
    const sid = String(b.scriptId || b.id || "");
    if (!sid) return json({ ok: false, error: "id" }, 400);
    const sc = G.scripts.find((x) => x.id === sid);
    if (!sc) return json({ ok: false, error: "not_found" }, 404);
    if (!staff && String(sc.author || "").toLowerCase() !== by.toLowerCase()) {
      return json({ ok: false, error: "forbidden" }, 403);
    }
    const nextTitle = b.title !== undefined ? clip(String(b.title || "").trim(), 80) : sc.title;
    const nextTag = b.tag !== undefined ? (clip(String(b.tag || "").trim(), 24) || sc.tag) : sc.tag;
    const nextDesc = b.desc !== undefined ? clip(String(b.desc || "").trim(), 300) : sc.desc;
    const nextCode = b.code !== undefined ? String(b.code || "").slice(0, 15000) : sc.code;
    const nextChangelog = b.changelog !== undefined ? clip(String(b.changelog || "").trim(), 120) : "";
    if (!nextTitle || !String(nextCode || "").trim()) return json({ ok: false, error: "missing_fields" }, 400);

    sc.title = nextTitle;
    sc.tag = nextTag;
    sc.desc = nextDesc;
    sc.code = nextCode;
    sc.ver = Math.max(1, Number(sc.ver) || 1) + 1;
    sc.editedAt = nowSec();
    sc.editedBy = by;
    if (nextChangelog) sc.changelog = nextChangelog;

    G.scriptSeq = Math.max(Date.now(), G.scriptSeq + 1);
    saveStateSoon(ctx, 0, "scripts");
    notify();
    const editPkt = {
      type: "script_edit",
      packetId: "sedit-" + sid + "-" + Date.now() + "-" + Math.random().toString(36).slice(2, 5),
      scriptId: sid,
      title: sc.title,
      tag: sc.tag,
      desc: sc.desc,
      code: sc.code,
      ver: sc.ver,
      changelog: sc.changelog || "",
      editedAt: sc.editedAt,
      editedBy: by,
      by,
      author: sc.author,
      chan: "scripts",
      ts: sc.editedAt,
    };
    emitScriptSyncPacket(env, ctx, editPkt, sc.code);
    return json({ ok: true, topic: sc, scripts: G.scripts, scriptSeq: G.scriptSeq });
  }

  if (action === "comment") {
    const m = mutedNow(by);
    if (m) return json({ ok: false, error: "muted", reason: m.reason, exp: m.exp }, 403);
    if (limited("sc_cmt:" + by.toLowerCase(), 10, 30000)) return json({ ok: false, error: "rate" }, 429);
    const sid = String(b.scriptId || b.id || "");
    const content = clip(String(b.text || b.content || "").trim(), 500);
    if (!sid || !content) return json({ ok: false, error: "missing_fields" }, 400);
    const sc = G.scripts.find((x) => x.id === sid);
    if (!sc) return json({ ok: false, error: "not_found" }, 404);
    sc.comments = Array.isArray(sc.comments) ? sc.comments : [];
    const cid = String(b.commentId || (b.scriptId && b.id ? b.id : "") || "cmt-" + Date.now() + "-" + Math.random().toString(36).slice(2, 6));
    const cObj = {
      id: cid,
      author: by,
      display: clip(String(b.display || by), 40),
      uid: Number(b.uid) || 1,
      text: content,
      content,
      ts: nowSec(),
    };
    sc.comments.push(cObj);
    while (sc.comments.length > 100) sc.comments.shift();
    G.scriptSeq = Math.max(Date.now(), G.scriptSeq + 1);
    saveStateSoon(ctx, 0, "scripts");
    notify();
    emitPkt(env, ctx, {
      type: "script_comment",
      packetId: cid,
      commentId: cid,
      scriptId: sid,
      target: sid,
      author: by,
      display: cObj.display,
      uid: cObj.uid,
      text: content,
      content,
      chan: "scripts",
      ts: cObj.ts,
    });
    return json({ ok: true, comment: cObj, topic: sc, scriptSeq: G.scriptSeq });
  }

  if (action === "comment_del") {
    const sid = String(b.scriptId || b.id || "");
    const cid = String(b.commentId || "");
    if (!sid || !cid) return json({ ok: false, error: "missing_fields" }, 400);
    const sc = G.scripts.find((x) => x.id === sid);
    if (!sc || !Array.isArray(sc.comments)) return json({ ok: false, error: "not_found" }, 404);
    const cObj = sc.comments.find((c) => c.id === cid);
    if (!cObj) return json({ ok: false, error: "comment_not_found" }, 404);
    if (!staff && String(cObj.author || "").toLowerCase() !== by.toLowerCase() && String(sc.author || "").toLowerCase() !== by.toLowerCase()) {
      return json({ ok: false, error: "forbidden" }, 403);
    }
    sc.comments = sc.comments.filter((c) => c.id !== cid);
    G.scriptSeq = Math.max(Date.now(), G.scriptSeq + 1);
    saveStateSoon(ctx, 0, "scripts");
    notify();
    emitPkt(env, ctx, {
      type: "script_comment_del",
      packetId: "cdel-" + Date.now() + "-" + Math.random().toString(36).slice(2, 5),
      scriptId: sid,
      commentId: cid,
      by,
      chan: "scripts",
      ts: nowSec(),
    });
    return json({ ok: true, topic: sc, scriptSeq: G.scriptSeq });
  }

  if (action === "react") {
    const m = mutedNow(by);
    if (m) return json({ ok: false, error: "muted", reason: m.reason }, 403);
    const id = String(b.id || "");
    const emoji = String(b.emoji || "").slice(0, REACT_MAX);
    if (!id || !emoji) return json({ ok: false, error: "react" }, 400);
    const sc = G.scripts.find((x) => x.id === id);
    if (!sc) return json({ ok: false, error: "not_found" }, 404);
    sc.reactions = sc.reactions || {};
    sc.reactions[emoji] = sc.reactions[emoji] || {};
    const has = !!sc.reactions[emoji][by];
    const mode = b.mode === "add" || b.mode === "remove" ? b.mode : has ? "remove" : "add";
    if (mode === "remove") {
      delete sc.reactions[emoji][by];
      if (!Object.keys(sc.reactions[emoji]).length) delete sc.reactions[emoji];
    } else sc.reactions[emoji][by] = true;
    G.scriptSeq = Math.max(Date.now(), G.scriptSeq + 1);
    saveStateSoon(ctx, 0, "scripts");
    notify();
    emitPkt(env, ctx, {
      type: "react",
      packetId: "srx-" + id + "-" + Date.now() + "-" + Math.random().toString(36).slice(2, 5),
      target: id,
      scriptId: id,
      emoji,
      by,
      action: mode,
      chan: "scripts",
      ts: nowSec(),
    });
    return json({ ok: true, topic: sc, scriptSeq: G.scriptSeq });
  }

  if (action === "report") {
    const id = String(b.id || "");
    const reason = clip(String(b.reason || "").trim(), 300);
    if (!id || !reason) return json({ ok: false, error: "reason" }, 400);
    const sc = G.scripts.find((x) => x.id === id);
    if (!sc) return json({ ok: false, error: "not_found" }, 404);
    sc.reports = Array.isArray(sc.reports) ? sc.reports : [];
    if (!sc.reports.some((r) => String(r.by).toLowerCase() === by.toLowerCase())) {
      sc.reports.push({ by, reason, ts: nowSec() });
    }
    G.scriptSeq = Math.max(Date.now(), G.scriptSeq + 1);
    saveStateSoon(ctx, 0, "scripts");
    notify();
    emitPkt(env, ctx, {
      type: "report",
      packetId: "scrpt-" + id + "-" + nowSec(),
      reporter: by,
      target: sc.author,
      topicId: sc.id,
      topicTitle: sc.title,
      reason: `[Script: ${sc.title}] ${reason}`,
      evidence: [{ author: sc.author, content: `${sc.title} — ${clip(sc.code, 100)}` }],
      isPublic: true,
      chan: "staff",
      ts: nowSec(),
    });
    return json({ ok: true, scriptSeq: G.scriptSeq });
  }

  if (action === "delete" || action === "delete_multi") {
    const rawIds = Array.isArray(b.ids) ? b.ids : b.id ? [b.id] : [];
    const targetIds = new Set(rawIds.map((x) => String(x || "")).filter(Boolean));
    if (!targetIds.size) return json({ ok: false, error: "id" }, 400);
    if (!staff) {
      const allMine = [...targetIds].every((tid) => {
        const sc = G.scripts.find((x) => x.id === tid);
        return sc && String(sc.author || "").toLowerCase() === by.toLowerCase();
      });
      if (!allMine || targetIds.size > 1) return json({ ok: false, error: "forbidden" }, 403);
    }
    const before = G.scripts.length;
    G.scripts = G.scripts.filter((x) => !targetIds.has(String(x.id)));
    const removed = before - G.scripts.length;
    if (removed > 0) {
      G.scriptSeq = Math.max(Date.now(), G.scriptSeq + 1);
      saveStateSoon(ctx, 0, "scripts");
      notify();
      emitPkt(env, ctx, { type: "script_del", packetId: "sdel-" + Date.now(), ids: [...targetIds], by, chan: "scripts", ts: nowSec() });
    }
    return json({ ok: true, removed, scripts: G.scripts, scriptSeq: G.scriptSeq });
  }

  return json({ ok: false, error: "unknown_action" }, 400);
}

async function handleGroups(req, env, ctx) {
  const ip = clientIp(req);
  if (limited("grp:" + ip, 30, 60000)) return json({ ok: false, error: "rate" }, 429);
  let b;
  try {
    b = await req.json();
  } catch (e) {
    return json({ ok: false, error: "json" }, 400);
  }
  const action = String(b.action || "create");
  const by = cleanName(b.by || b.owner || "");
  if (!by) return json({ ok: false, error: "by" }, 400);
  const banned = isBanned(by);
  if (banned && !isDev(env, by)) return json({ ok: false, error: "banned", reason: banned.reason }, 403);
  const m = mutedNow(by);
  if (m && action !== "leave") return json({ ok: false, error: "muted", reason: m.reason }, 403);
  const staff = isStaffName(env, by);
  const byKey = by.toLowerCase();

  if (action === "create") {
    const rawMembers = Array.isArray(b.members) ? b.members : String(b.members || "").split(/[,\s|]+/);
    const mapM = new Map();
    mapM.set(byKey, by);
    for (const rm of rawMembers.slice(0, 25)) {
      const cm = cleanName(rm);
      if (cm) mapM.set(cm.toLowerCase(), cm);
    }
    const members = [...mapM.values()];
    if (members.length < 2) return json({ ok: false, error: "need_members" }, 400);
    const gid = String(b.id || b.groupId || "grp_" + Date.now().toString(36) + "_" + Math.random().toString(36).slice(2, 6))
      .replace(/[^A-Za-z0-9_-]/g, "")
      .slice(0, 32);
    const name = clip(String(b.name || "").trim() || "Nhóm của " + by, 40);
    const icon = clip(String(b.icon || "👥").trim() || "👥", 16);
    const ts = nowSec();
    const gObj = { id: gid, name, icon, owner: by, members, chan: buildGroupChan(gid), ts, updatedAt: ts };
    G.groups.set(gid, gObj);
    while (G.groups.size > MAX_GROUPS) G.groups.delete(G.groups.keys().next().value);
    G.groupSeq = Math.max(Date.now(), G.groupSeq + 1);
    saveStateSoon(ctx, 0, "chat");
    notify();
    emitPkt(env, ctx, {
      type: "group_sync",
      packetId: "gs-" + gid + "-" + Date.now(),
      action: "create",
      id: gid,
      name,
      icon,
      owner: by,
      by,
      members,
      chan: gObj.chan,
      ts,
    });
    return json({ ok: true, group: gObj, groupSeq: G.groupSeq });
  }

  const gid = String(b.groupId || b.id || "").replace(/[^A-Za-z0-9_-]/g, "").slice(0, 32);
  const gObj = G.groups.get(gid);
  if (!gObj) return json({ ok: false, error: "not_found" }, 404);
  const isOwner = String(gObj.owner || "").toLowerCase() === byKey || staff;
  const isMember = gObj.members.some((x) => x.toLowerCase() === byKey) || staff;
  if (!isMember) return json({ ok: false, error: "forbidden" }, 403);
  const prevMembers = Array.isArray(gObj.members) ? [...gObj.members] : [];

  if (action === "delete") {
    if (!isOwner) return json({ ok: false, error: "owner_only" }, 403);
    G.groups.delete(gid);
    G.groupSeq = Math.max(Date.now(), G.groupSeq + 1);
    saveStateSoon(ctx, 0, "chat");
    notify();
    emitPkt(env, ctx, { type: "group_sync", packetId: "gsd-" + gid + "-" + Date.now(), action: "delete", id: gid, by, members: prevMembers, notifyMembers: prevMembers, ts: nowSec() });
    return json({ ok: true, groupSeq: G.groupSeq });
  }

  if (action === "rename") {
    const newName = clip(String(b.name || "").trim(), 40);
    if (!newName) return json({ ok: false, error: "name" }, 400);
    gObj.name = newName;
    if (b.icon !== undefined) gObj.icon = clip(String(b.icon || "👥").trim() || "👥", 16);
  } else if (action === "add_member") {
    const rawAdd = Array.isArray(b.members) ? b.members : String(b.target || b.member || b.members || "").split(/[,\s|]+/);
    const mapM = new Map(gObj.members.map((x) => [x.toLowerCase(), x]));
    for (const rm of rawAdd) {
      const cm = cleanName(rm);
      if (cm && mapM.size < 30) mapM.set(cm.toLowerCase(), cm);
    }
    gObj.members = [...mapM.values()];
  } else if (action === "remove_member" || action === "kick_member") {
    if (!isOwner) return json({ ok: false, error: "owner_only" }, 403);
    const target = cleanName(b.target || b.member || "").toLowerCase();
    if (!target || target === String(gObj.owner || "").toLowerCase()) return json({ ok: false, error: "cannot_remove_owner" }, 400);
    gObj.members = gObj.members.filter((x) => x.toLowerCase() !== target);
  } else if (action === "leave") {
    gObj.members = gObj.members.filter((x) => x.toLowerCase() !== byKey);
    if (gObj.members.length < 2) {
      G.groups.delete(gid);
      G.groupSeq = Math.max(Date.now(), G.groupSeq + 1);
      saveStateSoon(ctx, 0, "chat");
      notify();
      emitPkt(env, ctx, { type: "group_sync", packetId: "gsd-" + gid + "-" + Date.now(), action: "delete", id: gid, by, members: prevMembers, notifyMembers: prevMembers, ts: nowSec() });
      return json({ ok: true, deleted: true, groupSeq: G.groupSeq });
    }
    if (String(gObj.owner || "").toLowerCase() === byKey) gObj.owner = gObj.members[0];
  } else {
    return json({ ok: false, error: "unknown_action" }, 400);
  }

  gObj.chan = buildGroupChan(gid);
  gObj.updatedAt = nowSec();
  G.groups.set(gid, gObj);
  G.groupSeq = Math.max(Date.now(), G.groupSeq + 1);
  saveStateSoon(ctx, 0, "chat");
  notify();
  const notifyMembers = [...new Set([...prevMembers, ...(gObj.members || [])])];
  emitPkt(env, ctx, {
    type: "group_sync",
    packetId: "gsu-" + gid + "-" + Date.now(),
    action: "update",
    id: gid,
    name: gObj.name,
    icon: gObj.icon,
    owner: gObj.owner,
    by,
    members: gObj.members,
    notifyMembers,
    chan: gObj.chan,
    ts: nowSec(),
  });
  return json({ ok: true, group: gObj, groupSeq: G.groupSeq });
}

async function handleFeedback(req, env, ctx, url) {
  const ip = clientIp(req);
  if (req.method === "GET") {
    const u = cleanName(url.searchParams.get("u") || "").toLowerCase();
    const staff = u && isStaffName(env, u);
    const list = [...G.feedbacks.values()].filter((f) => staff || !u || String(f.author || "").toLowerCase() === u);
    return json({ ok: true, feedbacks: list, feedbackSeq: G.feedbackSeq });
  }
  if (limited("fb_ip:" + ip, 12, 60000)) return json({ ok: false, error: "rate", retry_after: 5 }, 429);
  let b;
  try {
    b = await req.json();
  } catch (e) {
    return json({ ok: false, error: "json" }, 400);
  }
  const by = cleanName(b.by || b.author || "");
  if (!by) return json({ ok: false, error: "by" }, 400);
  const banned = isBanned(by);
  if (banned && !isDev(env, by)) return json({ ok: false, error: "banned", reason: banned.reason }, 403);

  // Chuyển tiếp sang Boss.js để Boss đăng thẻ nút bấm Discord, đồng thời phát sóng sang 4 Server Backup còn lại
  const bossUrl = getBossUrl(env);
  if (bossUrl && (!G.selfHost || !bossUrl.toLowerCase().includes(G.selfHost.toLowerCase()))) {
    try {
      const rBoss = await fetch(`${bossUrl}/api/feedback`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(b),
      });
      if (rBoss.ok) {
        const dBoss = await rBoss.json();
        if (dBoss && dBoss.ok && dBoss.feedback) {
          G.feedbacks.set(dBoss.feedback.id, dBoss.feedback);
          G.feedbackSeq = Math.max(Date.now(), Number(dBoss.feedbackSeq) || G.feedbackSeq + 1);
          saveStateSoon(ctx, 0, "chat");
          broadcastMeshAndBossSoon(env, ctx, PREFIX + JSON.stringify({ type: "feedback", packetId: "fb-" + dBoss.feedback.id, ...dBoss.feedback, chan: "staff" }));
          return json(dBoss);
        }
      }
    } catch (e) {}
  }

  if (limited("fb_u:" + by.toLowerCase(), 5, 60000)) return json({ ok: false, error: "rate", retry_after: 10 }, 429);
  const kind = b.kind === "bug" ? "bug" : "suggest";
  const content = clip(String(b.content || b.desc || b.reason || "").trim(), 1200);
  const title = clip(String(b.title || "").trim(), 100);
  if (!content) return json({ ok: false, error: "missing_content" }, 400);
  const ts = nowSec();
  const fid = String(
    b.id ||
      (kind === "bug" ? "BG-" : "SG-") +
        ts.toString(36).toUpperCase().slice(-4) +
        "-" +
        Math.random().toString(36).slice(2, 5).toUpperCase()
  )
    .replace(/[^A-Za-z0-9_-]/g, "")
    .slice(0, 24);

  const fbObj = {
    id: fid,
    kind,
    author: by,
    display: clip(String(b.display || by), 40),
    uid: Number(b.uid) || 1,
    category: clip(String(b.category || (kind === "bug" ? "UI / Script" : "Tính năng mới")), 40),
    severity: clip(String(b.severity || "Trung bình"), 24),
    title: title || (kind === "bug" ? "Báo cáo lỗi" : "Đóng góp ý tưởng"),
    content,
    steps: clip(String(b.steps || ""), 600),
    exec: clip(String(b.exec || "?"), 32),
    device: clip(String(b.device || "?"), 16),
    placeId: Number(b.placeId) || 0,
    gameName: clip(String(b.gameName || ""), 60),
    rtt: clip(String(b.rtt || ""), 20),
    seen: false,
    seenBy: "",
    seenAt: 0,
    status: "pending",
    replies: [],
    ts,
  };

  G.feedbacks.set(fid, fbObj);
  while (G.feedbacks.size > MAX_FEEDBACKS) G.feedbacks.delete(G.feedbacks.keys().next().value);
  G.feedbackSeq = Math.max(Date.now(), G.feedbackSeq + 1);
  saveStateSoon(ctx, 0, "chat");
  notify();

  emitPkt(env, ctx, { type: "feedback", packetId: "fb-" + fid, ...fbObj, chan: "staff" });
  return json({ ok: true, feedback: fbObj, feedbackSeq: G.feedbackSeq });
}

const CURATED_IMAGES = [
  { id: "11738982195", name: "Cyberpunk Neon City Banner", cat: "banner" },
  { id: "13693244698", name: "Dark Aesthetic Anime Sky", cat: "banner" },
  { id: "1084991215", name: "Galaxy Nebula Space Banner", cat: "banner" },
  { id: "6403436054", name: "Synthwave Sunset Grid", cat: "banner" },
  { id: "9069609200", name: "Crimson Red Samurai Background", cat: "banner" },
  { id: "11379209612", name: "Blue Lightning Storm Banner", cat: "banner" },
  { id: "6031094678", name: "Verified Crown Badge Icon", cat: "icon" },
  { id: "6031068433", name: "Developer Shield Emblem", cat: "icon" },
  { id: "11834572110", name: "Anime Cat Glitch Avatar Icon", cat: "icon" },
  { id: "6031280882", name: "Golden Star Prestige Icon", cat: "icon" },
];

async function handleImageSearch(req, env, url) {
  const q = String(url.searchParams.get("q") || "").trim();
  const cat = String(url.searchParams.get("cat") || "").trim().toLowerCase();
  const page = Math.max(1, Math.min(10, Math.round(Number(url.searchParams.get("page")) || 1)));
  const pageSize = 24;
  const results = [];
  const seen = new Set();
  const pushImg = (id, name, category, creator) => {
    const cleanId = String(id || "").replace(/[^0-9]/g, "");
    if (!cleanId || seen.has(cleanId)) return;
    seen.add(cleanId);
    results.push({
      id: cleanId,
      name: clip(String(name || "Asset #" + cleanId), 60),
      cat: category || "image",
      creator: clip(String(creator || "Roblox"), 32),
    });
  };
  let remoteCount = 0;
  if (page === 1 && /^\d{5,16}$/.test(q)) pushImg(q, `Roblox Image ID #${q}`, cat || "custom", "Roblox");
  if (q.length >= 2) {
    try {
      const apiUrl = `https://apis.roblox.com/toolbox-service/v1/marketplace/13?keyword=${encodeURIComponent(q)}&num=24&pageNumber=${page}`;
      const r = await fetch(apiUrl, { headers: { "User-Agent": "Roblox/WinInet", Accept: "application/json" } });
      if (r.ok) {
        const data = await r.json();
        const ids = Array.isArray(data && data.data) ? data.data.map((x) => x.id).filter(Boolean).slice(0, 24) : [];
        remoteCount = ids.length;
        if (ids.length > 0) {
          try {
            const detRes = await fetch(`https://apis.roblox.com/toolbox-service/v1/items/details?assetIds=${ids.join(",")}`, {
              headers: { "User-Agent": "Roblox/WinInet", Accept: "application/json" },
            });
            if (detRes.ok) {
              const detData = await detRes.json();
              const idSet = new Set(ids.map(String));
              for (const entry of (detData && detData.data) || []) {
                if (entry && entry.asset && entry.asset.id && idSet.has(String(entry.asset.id))) {
                  pushImg(entry.asset.id, entry.asset.name || q, cat || "search", (entry.creator && entry.creator.name) || "Roblox");
                }
              }
            }
          } catch (e) {}
          for (const rawId of ids) pushImg(rawId, `${q} (#${rawId})`, cat || "search", "Roblox");
        }
      }
    } catch (e) {}
  }
  let sliced = results;
  let hasMore = remoteCount >= 18;
  if (page === 1 || results.length === 0) {
    const localPool = [];
    const ql = q.toLowerCase();
    for (const em of G.emojis) {
      if (!ql || String(em.name || "").toLowerCase().includes(ql) || String(em.id).includes(ql)) {
        localPool.push({ id: em.id, name: `Emoji :${em.name}:`, cat: "emoji", creator: "Emoji" });
      }
    }
    for (const item of CURATED_IMAGES) {
      if ((!cat || item.cat === cat || !ql) && (!ql || item.name.toLowerCase().includes(ql) || item.cat.includes(ql))) {
        localPool.push(item);
      }
    }
    if (page === 1 && !results.length && !localPool.length) {
      for (const item of CURATED_IMAGES) localPool.push(item);
    }
    if (page === 1) {
      for (const item of localPool) pushImg(item.id, item.name, item.cat, item.creator || "Curated");
      sliced = results.slice(0, pageSize);
    } else if (localPool.length > (page - 1) * pageSize && q.length < 2) {
      const start = (page - 1) * pageSize;
      for (const item of localPool.slice(start, start + pageSize)) pushImg(item.id, item.name, item.cat, item.creator || "Curated");
      sliced = results;
      hasMore = start + pageSize < localPool.length;
    }
  } else {
    sliced = results.slice(0, pageSize);
  }
  return json({ ok: true, page, hasMore, items: sliced, results: sliced });
}

function health(env) {
  const nowS = nowSec();
  prunePresenceMap(nowS);
  return json({
    ok: true,
    role: "backup",
    description: "Server Backup: Nơi player trò chuyện và mọi server liên kết Mesh với nhau",
    proxyId: G.proxyId,
    proxyName: G.proxyName,
    build: VERSION,
    protocol: PREFIX.slice(0, -1),
    bossUrl: getBossUrl(env),
    bossOk: G.bossOk,
    meshPeers: getBackupPeers(env).map((p) => p.url),
    store: G.store ? G.store.kind : "none",
    stateTs: G.stateTs,
    lockdown: G.lockdown,
    lockdownSeq: G.lockdownSeq,
    seenSeq: G.seenSeq,
    profSeq: G.profSeq,
    items: G.items.length,
    generalArchive: G.generalArchive.length,
    online: G.pres.size,
    users: [...G.pres.values()],
    waiting: G.waiters.size,
    emojis: G.emojis.length,
    scripts: G.scripts.length,
    groups: G.groups.size,
    feedbacks: G.feedbacks.size,
    announces: G.announces.length,
    punishments: G.punishments.length,
    mutes: G.mutes.size,
    warns: G.warns.size,
    banned: G.banned.size,
    rolesSeq: G.rolesSeq,
    quota: getQuotaSnapshot(),
    uptime: Math.floor((Date.now() - G.started) / 1000),
    now: nowS,
  });
}

// ============================================================================
// 9. BỘ ĐỊNH TUYẾN (ROUTER), CRON KEEP-ALIVE 24/7 & DURABLE OBJECT HUB
// ============================================================================

async function handleGetProfile(req, env, ctx, url) {
  if (url.searchParams.get("list") === "1" || url.searchParams.get("all") === "1") {
    if (!G.ready) await refresh(env, ctx, false);
    if (G.profLastSyncAt === 0 || Date.now() - G.profLastSyncAt > 20000) {
      await syncProfilesFromDiscordChannel(env, ctx, false, false);
    }
    if (url.searchParams.get("from") !== "boss" && (G.profiles.size < 3 || Date.now() - (G.profBossListAt || 0) > 25000)) {
      const bossUrl = getBossUrl(env);
      if (bossUrl && !(G.selfHost && bossUrl.toLowerCase().includes(G.selfHost.toLowerCase()))) {
        G.profBossListAt = Date.now();
        const ctrl = typeof AbortController === "function" ? new AbortController() : null;
        const timer = ctrl ? setTimeout(() => { try { ctrl.abort(); } catch (e) {} }, 2500) : null;
        try {
          const rB = await fetch(`${bossUrl}/api/profile?list=1&from=worker`, {
            method: "GET",
            headers: { Accept: "application/json", "Cache-Control": "no-cache" },
            ...(ctrl ? { signal: ctrl.signal } : {}),
          });
          if (timer) clearTimeout(timer);
          if (rB && rB.ok) {
            const dB = await rB.json();
            if (dB && dB.ok && Array.isArray(dB.users)) {
              for (const bu of dB.users) {
                if (bu && bu.u && !isSystemActor(bu.u, bu)) {
                  upsertProfile(bu, { allowClear: false, offline: !bu.online });
                }
              }
            }
          }
        } catch (e) {
          if (timer) clearTimeout(timer);
        }
      }
    }
    const nowS = nowSec();
    prunePresenceMap(nowS);
    for (const live of G.pres.values()) {
      if (live && live.u && !isSystemActor(live.u, live) && !isUserOfflineAt(live.u, live.ts) && nowS - (Number(live.ts) || 0) <= PRESENCE_TTL) {
        upsertProfile(live, { allowClear: false });
      }
    }
    const list = [];
    for (const prof of G.profiles.values()) {
      if (!prof || !prof.u || isSystemActor(prof.u, prof)) continue;
      const uKey = String(prof.u).toLowerCase();
      const live = G.pres.get(uKey);
      const isOnline = !!(live && !isUserOfflineAt(uKey, live.ts) && nowS - (Number(live.ts) || 0) <= PRESENCE_TTL);
      const src = isOnline ? live : prof;
      list.push({
        u: src.u || prof.u,
        d: src.d || prof.d || prof.u,
        id: Number(src.id || prof.id) || 0,
        st: src.st !== undefined ? src.st : prof.st || "",
        bio: src.bio !== undefined ? src.bio : prof.bio || "",
        c: src.c || prof.c || "??",
        pb: src.pb !== undefined ? src.pb : prof.pb || "",
        pi: src.pi !== undefined ? src.pi : prof.pi || "",
        pt: src.pt !== undefined ? src.pt : prof.pt || null,
        sg: isOnline ? Boolean(live.sg) : false,
        pl: isOnline ? Number(live.pl) || 0 : Number(prof.pl) || 0,
        gn: isOnline ? live.gn || "" : prof.gn || "",
        jb: isOnline ? live.jb || "" : "",
        mc: Math.max(Number(src.mc) || 0, Number(prof.mc) || 0),
        proxyId: (isOnline && live.proxyId) || prof.proxyId || G.proxyId,
        proxyName: (isOnline && live.proxyName) || prof.proxyName || G.proxyName,
        lastSeen: isOnline ? Number(live.ts) || nowS : Number(prof.lastSeen || prof.ts) || 0,
        ts: isOnline ? Number(live.ts) || nowS : Number(prof.ts) || 0,
        online: isOnline,
      });
    }
    list.sort((a, b) => {
      if (a.online !== b.online) return a.online ? -1 : 1;
      return (b.lastSeen || b.ts || 0) - (a.lastSeen || a.ts || 0);
    });
    return json({ ok: true, users: list, total: list.length, now: nowS });
  }
  const target = cleanName(url.searchParams.get("u") || url.searchParams.get("user") || "");
  if (!target) return json({ ok: false, error: "u" }, 400);
  const uKey = target.toLowerCase();
  if (!G.ready) await refresh(env, ctx, false);
  let res = buildPublicProfile(uKey);
  const needsCloudSync = !res.profile || !hasCustomProfileData(res.profile) || !G.profMsgMap.has(uKey);
  if (needsCloudSync && (!res.online || Date.now() - G.profLastSyncAt > 15000 || G.profLastSyncAt === 0)) {
    await syncProfilesFromDiscordChannel(env, ctx, false, !res.profile || !hasCustomProfileData(res.profile));
    res = buildPublicProfile(uKey);
  }
  const isSparse = !res.profile || (!res.profile.pb && !res.profile.pi && !res.profile.pt && !res.profile.bio && !(Number(res.profile.id) > 1));
  if (isSparse && url.searchParams.get("from") !== "boss") {
    const bossUrl = getBossUrl(env);
    if (bossUrl && !(G.selfHost && bossUrl.toLowerCase().includes(G.selfHost.toLowerCase()))) {
      const ctrl = typeof AbortController === "function" ? new AbortController() : null;
      const timer = ctrl ? setTimeout(() => { try { ctrl.abort(); } catch (e) {} }, 2500) : null;
      try {
        const r = await fetch(`${bossUrl}/api/profile?u=${encodeURIComponent(target)}&from=worker`, {
          method: "GET",
          headers: { Accept: "application/json", "Cache-Control": "no-cache" },
          ...(ctrl ? { signal: ctrl.signal } : {}),
        });
        if (timer) clearTimeout(timer);
        if (r && r.ok) {
          const data = await r.json();
          if (data && data.ok && data.profile && typeof data.profile === "object") {
            const merged = upsertProfile(data.profile, { allowClear: false, offline: !data.online });
            if (merged) {
              saveStateSoon(ctx, 0, "profiles");
              res = { online: Boolean(data.online), profile: { ...merged, online: Boolean(data.online), ...(data.online ? {} : { sg: false, jb: "" }) } };
            }
          }
        }
      } catch (e) {
        if (timer) clearTimeout(timer);
      }
    }
  }
  return json({
    ok: true,
    found: Boolean(res.profile),
    online: res.online,
    cloudStored: G.profMsgMap.has(uKey),
    review: G.profReviews.get(uKey) || null,
    profile: res.profile,
    now: nowSec(),
  });
}

async function handlePostProfile(req, env, ctx) {
  let b;
  try {
    b = await req.json();
  } catch (e) {
    return json({ ok: false, error: "json" }, 400);
  }
  const action = String((b && b.action) || "save").toLowerCase();

  if (action === "approve" || action === "unblock" || action === "restore") {
    const by = cleanName(b.by || b.actor || "");
    const target = cleanName(b.target || b.u || "");
    const reason = clip(String(b.reason || "Đã duyệt / giải duyệt thủ công trên Discord"), 200);
    if (!by || !target) return json({ ok: false, error: "missing_fields" }, 400);
    if (!isStaffName(env, by)) return json({ ok: false, error: "forbidden" }, 403);
    const rvRes = approveUserProfileReview(env, ctx, target, by, reason);
    return json({
      ok: true,
      ...rvRes,
      review: G.profReviews.get(target.toLowerCase()) || null,
      profile: buildPublicProfile(target.toLowerCase()).profile,
      now: nowSec(),
    });
  }

  if (action === "delete" || action === "clear" || action === "reset") {
    const by = cleanName(b.by || b.actor || "");
    const target = cleanName(b.target || b.u || "");
    const reason = clip(String(b.reason || "Xóa dữ liệu Profile bởi Dev/Admin"), 240);
    if (!by || !target) return json({ ok: false, error: "missing_fields" }, 400);
    const isSelf = by.toLowerCase() === target.toLowerCase();
    const staff = isStaffName(env, by);
    if (!isSelf && !staff) return json({ ok: false, error: "forbidden" }, 403);
    if (isDev(env, target) && !isSelf && !isDev(env, by)) return json({ ok: false, error: "cannot_clear_dev" }, 403);
    if (!isSelf && !isDev(env, by) && isAdminName(target)) return json({ ok: false, error: "forbidden" }, 403);
    const delRes = await deleteUserProfileData(env, ctx, target, by, reason);
    return json({
      ok: true,
      deleted: true,
      ...delRes,
      review: G.profReviews.get(target.toLowerCase()) || null,
      profile: buildPublicProfile(target.toLowerCase()).profile,
      now: nowSec(),
    });
  }

  const u = cleanName(b.u || b.author || "");
  if (!u || u === "?") return json({ ok: false, error: "u" }, 400);
  const banned = isBanned(u);
  if (banned && !isDev(env, u)) return json({ ok: false, error: "banned", reason: banned.reason }, 403);
  const uKey = u.toLowerCase();
  if (limited("prof_save:" + uKey, 10, 30000)) return json({ ok: false, error: "rate", retry_after: 5 }, 429);

  const ts = Math.max(nowSec(), (G.profClearedAt.get(uKey) || 0) + 1);
  G.profClearedAt.delete(uKey);
  const prevLive = G.pres.get(uKey);
  const entry = upsertProfile(
    {
      u,
      d: b.d,
      id: b.id,
      st: b.st,
      bio: b.bio,
      c: b.c,
      pb: b.pb,
      pi: b.pi,
      pt: b.pt !== undefined ? b.pt : null,
      mc: b.mc,
      pl: b.pl,
      gn: b.gn,
      ts,
    },
    { allowClear: true, preferSrc: true, offline: !prevLive }
  );
  if (!entry) return json({ ok: false, error: "invalid_profile" }, 400);

  if (prevLive) {
    Object.assign(prevLive, {
      d: entry.d,
      id: entry.id || prevLive.id || 0,
      st: entry.st,
      bio: entry.bio,
      c: entry.c,
      pb: entry.pb,
      pi: entry.pi,
      pt: entry.pt,
      mc: entry.mc,
      ts,
    });
  }

  const cloudRes = await saveProfileToDiscordCloud(env, ctx, entry, true);
  if (hasCustomProfileData(entry)) {
    const curRv = G.profReviews.get(uKey);
    if (!curRv || curRv.status === "cleared") {
      G.profReviews.set(uKey, { u: entry.u, status: "pending", by: "", reason: "", ts });
    }
  }
  const syncPkt = {
    type: "profile_sync",
    packetId: "pfs-" + uKey + "-" + Date.now(),
    u: entry.u,
    d: entry.d,
    id: entry.id,
    st: entry.st,
    bio: entry.bio,
    c: entry.c,
    pb: entry.pb,
    pi: entry.pi,
    pt: entry.pt,
    mc: entry.mc,
    pl: entry.pl,
    gn: entry.gn,
    chan: "general",
    ts,
  };
  let line = PREFIX + JSON.stringify(syncPkt);
  if (line.length > 1940) {
    delete syncPkt.gn;
    line = PREFIX + JSON.stringify(syncPkt);
  }
  G.profSeq = Math.max(Date.now(), (G.profSeq || 0) + 1);
  if (line.length <= 1940) {
    emitPkt(env, ctx, syncPkt);
  } else {
    insert(syncPkt, line, null, false);
    broadcastMeshAndBossSoon(env, ctx, line);
  }
  saveStateSoon(ctx, 0, "profiles");

  return json({
    ok: true,
    cloudSaved: Boolean(cloudRes && cloudRes.ok),
    review: G.profReviews.get(uKey) || null,
    profile: buildPublicProfile(uKey).profile,
    now: nowSec(),
  });
}

async function route(req, env, ctx) {
  trackInboundQuota();
  const url = new URL(req.url);
  if (url.hostname && url.hostname !== "hub" && url.hostname !== "localhost") {
    detectProxyIdentity(url.hostname);
  }
  const path = url.pathname.replace(/\/+$/, "") || "/";
  if (ctx && typeof ctx.waitUntil === "function") G.bgCtx = ctx;

  try {
    if (path === "/api/ping") {
      if (url.searchParams.get("source") !== "boss-keepalive") {
        wakeBossInBackground(env, ctx);
      }
      return json({ ok: true, role: "backup", proxyId: G.proxyId, proxyName: G.proxyName, now: nowSec(), ms: Date.now() });
    }
    initStore(env, ctx);
    if (path === "/" || path === "/api/health") {
      await syncState(env, ctx, false);
      return health(env);
    }
    await syncState(env, ctx, false);
    wakeBossInBackground(env, ctx);

    // Endpoint đồng bộ Mesh trực tiếp giữa 5 Server Backup và Server Boss
    if (path === "/api/peer-sync" && req.method === "POST") return await handlePeerSync(req, env, ctx, url);

    // Các API phục vụ Roblox Client (CB.lua)
    if (path === "/api/images" && req.method === "GET") return await handleImageSearch(req, env, url);
    if (path === "/api/profile" && req.method === "GET") return await handleGetProfile(req, env, ctx, url);
    if (path === "/api/profile" && req.method === "POST") return await handlePostProfile(req, env, ctx);
    if (path === "/api/feedback" && (req.method === "POST" || req.method === "GET")) return await handleFeedback(req, env, ctx, url);
    if (path === "/api/feed" && req.method === "GET") return await handleFeed(req, env, ctx, url);
    if (path === "/api/send" && req.method === "POST") return await handleSend(req, env, ctx);
    if (path === "/api/presence" && req.method === "POST") return await handlePresence(req, env, ctx);
    if (path === "/api/roles" && req.method === "POST") return await handleRoles(req, env, ctx);
    if (path === "/api/request" && req.method === "POST") return await handleRequest(req, env, ctx);
    if (path === "/api/approve" && req.method === "POST") return await handleApprove(req, env, ctx);
    if (path === "/api/revoke" && req.method === "POST") return await handleRevoke(req, env, ctx);
    if (path === "/api/unban" && req.method === "POST") return await handleUnban(req, env, ctx);
    if (path === "/api/requests" && req.method === "GET") return await handleRequestsList(req, env, ctx, url);
    if (path === "/api/emoji" && req.method === "POST") return await handleEmoji(req, env, ctx);
    if (path === "/api/scripts" && (req.method === "POST" || req.method === "GET")) return await handleScripts(req, env, ctx);
    if (path === "/api/groups" && req.method === "POST") return await handleGroups(req, env, ctx);
    if (path === "/api/cron") {
      await refresh(env, ctx, true);
      return json({ ok: true, refreshed: true, now: nowSec() });
    }
    return json({ ok: false, error: "not_found" }, 404);
  } catch (e) {
    return json({ ok: false, error: String((e && e.message) || e) }, 500);
  }
}

async function handleImageSearchEdge(req, env, ctx, url) {
  const normQ = String(url.searchParams.get("q") || "").trim().toLowerCase();
  const normCat = String(url.searchParams.get("cat") || "").trim().toLowerCase();
  const normPage = Math.max(1, Math.min(10, Math.round(Number(url.searchParams.get("page")) || 1)));
  const cacheKeyUrl = `https://cb47-img-cache.internal/api/images?v=476&q=${encodeURIComponent(normQ)}&cat=${encodeURIComponent(normCat)}&page=${normPage}`;
  const hasCache = typeof caches !== "undefined" && caches && caches.default && typeof caches.default.match === "function";

  if (hasCache) {
    try {
      const cached = await caches.default.match(cacheKeyUrl);
      if (cached && cached.ok) {
        const headers = new Headers(cached.headers);
        for (const [k, v] of Object.entries(CORS)) headers.set(k, v);
        headers.set("X-CB-Cache", "HIT");
        return new Response(cached.body, { status: cached.status, headers });
      }
    } catch (e) {}
  }

  const rawResp = await handleImageSearch(req, env, url);
  const bodyText = await rawResp.text();
  const headers = {
    ...CORS,
    "Content-Type": "application/json",
    "Cache-Control": "public, max-age=14400",
    "X-CB-Cache": "MISS",
  };
  const edgeResp = new Response(bodyText, { status: rawResp.status, headers });
  if (hasCache && rawResp.ok) {
    bg(
      ctx,
      caches.default.put(cacheKeyUrl, edgeResp.clone()).catch(() => {})
    );
  }
  return edgeResp;
}

async function handleIncoming(req, env, ctx) {
  const resolved = resolveEnv(env);
  if (req.method === "OPTIONS") return new Response(null, { headers: CORS });

  const url = new URL(req.url);
  if (url.hostname && url.hostname !== "hub" && url.hostname !== "localhost") {
    detectProxyIdentity(url.hostname);
  }
  const path = url.pathname.replace(/\/+$/, "") || "/";

  // Bypass Durable Object HUB cho các route không cần trạng thái (tốn 0 lượt gọi DO!)
  if (path === "/api/ping") {
    if (req.method === "HEAD") {
      return new Response(null, {
        status: 200,
        headers: { ...CORS, "Content-Type": "application/json", "Cache-Control": "no-store" },
      });
    }
    return json({
      ok: true,
      role: "backup",
      build: VERSION,
      edgeBypass: true,
      proxyId: G.proxyId,
      proxyName: G.proxyName,
      now: nowSec(),
      ms: Date.now(),
    });
  }

  // Xử lý /api/images ngay tại lớp Worker + Edge Cache 4 tiếng (chỉ fallback vào DO nếu cần tìm emoji cục bộ với cat=emoji)
  if (path === "/api/images" && req.method === "GET") {
    const reqCat = String(url.searchParams.get("cat") || "").trim().toLowerCase();
    if (reqCat !== "emoji" || !(resolved.HUB && typeof resolved.HUB.idFromName === "function")) {
      return await handleImageSearchEdge(req, resolved, ctx, url);
    }
  }

  if (resolved.HUB && typeof resolved.HUB.idFromName === "function") {
    try {
      const stub = resolved.HUB.get(resolved.HUB.idFromName("main"));
      return await stub.fetch(req);
    } catch (e) {
      return json({ ok: false, error: "hub_unavailable", detail: String((e && e.message) || e) }, 503);
    }
  }
  return route(req, resolved, ctx);
}

// Lưu ý: Để KHÔNG lãng phí 100,000 req/ngày của Cloudflare Free Tier, ta KHÔNG dùng Cloudflare Cron.
// Việc giữ ấm Render.com 24/7 được thực hiện bởi Web Trigger bên ngoài (cron-job.org / UptimeRobot / GitHub Actions)
// bắn thẳng vào https://cb45-boss.onrender.com/api/ping (tốn 0 request Cloudflare).
export default {
  fetch: handleIncoming,
  async scheduled(_event, _env, _ctx) {
    // No-op: Không chạy tác vụ ngầm trên Cloudflare để tiết kiệm 100% quota Cloudflare Free Tier.
  },
};

export const config = { runtime: "edge" };

export class Hub {
  constructor(state, env) {
    this.state = state;
    this.env = resolveEnv(env);
  }
  async fetch(request) {
    return route(request, this.env, this.state);
  }
}
