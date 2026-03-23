// ═══════════════════════════════════════════════════
//   SARKARIALERT.IN — CONFIG v2
//   Fill in these 3 values. Nothing else to change!
// ═══════════════════════════════════════════════════
//
// HOW TO GET SUPABASE VALUES:
//   1. Go to supabase.com → Your Project
//   2. Click Settings → API
//   3. Copy "Project URL" → SUPABASE_URL
//   4. Copy "anon public" key → SUPABASE_KEY

const SUPABASE_URL = "https://qfgszbyvdsqdasskdtqo.supabase.co";
const SUPABASE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFmZ3N6Ynl2ZHNxZGFzc2tkdHFvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzQyMDkwNjIsImV4cCI6MjA4OTc4NTA2Mn0.L91IriQ_razBVZspGsygTVlmKMem3DriEnoxsd5j2wc";
const ADMIN_PASSWORD = "Paswan@7656";  // ← CHANGE THIS!

// ── Site Info ──────────────────────────────────────
const SITE_NAME    = "SarkariAlert.in";
const SITE_TAGLINE = "India's Fastest Govt Job Portal";
const SITE_URL     = "https://sarkarialert.netlify.app";

// ── Section Config ─────────────────────────────────
// This controls section names, icons, and page filenames
const SECTIONS = [
  { key: "jobs",        label: "Latest Jobs",    icon: "💼", page: "jobs.html",        color: "#0B1D3A" },
  { key: "results",     label: "Results",         icon: "📋", page: "results.html",     color: "#1B8A4E" },
  { key: "admit_cards", label: "Admit Cards",     icon: "🎫", page: "admit.html",       color: "#1565C0" },
  { key: "syllabus",    label: "Syllabus",        icon: "📚", page: "syllabus.html",    color: "#6A0DAD" },
  { key: "schemes",     label: "Schemes/Yojana",  icon: "🏛️", page: "schemes.html",     color: "#C0392B" },
  { key: "answer_keys", label: "Answer Keys",     icon: "📝", page: "answer_keys.html", color: "#E65100" },
];

// ── Category Config ────────────────────────────────
const CATEGORIES = [
  { key: "railway", label: "Railway",       icon: "🚂", color: "#1565C0" },
  { key: "upsc",    label: "UPSC/SSC",      icon: "🏛️", color: "#6A0DAD" },
  { key: "banking", label: "Banking",       icon: "🏦", color: "#097A47" },
  { key: "defence", label: "Defence/Police",icon: "🛡️", color: "#B71C1C" },
  { key: "state",   label: "State Govt",    icon: "🗺️", color: "#E65100" },
];

// ── Status Config ──────────────────────────────────
const STATUSES = [
  { key: "open",      label: "Apply Open",      color: "#097A47", bg: "#E5F5ED" },
  { key: "soon",      label: "Coming Soon",     color: "#1565C0", bg: "#E8F0FE" },
  { key: "closed",    label: "Closed",          color: "#6C757D", bg: "#F1F3F8" },
  { key: "declared",  label: "Result Declared", color: "#097A47", bg: "#E5F5ED" },
  { key: "available", label: "Available",       color: "#E65100", bg: "#FFF3E0" },
  { key: "result_out",label: "Result Out",      color: "#097A47", bg: "#E5F5ED" },
];

// ── Supabase helpers (used by all pages) ──────────
async function dbFetch(query) {
  const url = `${SUPABASE_URL}/rest/v1/${query}`;
  const res = await fetch(url, {
    headers: { apikey: SUPABASE_KEY, Authorization: `Bearer ${SUPABASE_KEY}` }
  });
  if (!res.ok) throw new Error(await res.text());
  return res.json();
}

async function dbInsert(table, data) {
  const res = await fetch(`${SUPABASE_URL}/rest/v1/${table}`, {
    method: "POST",
    headers: {
      apikey: SUPABASE_KEY,
      Authorization: `Bearer ${SUPABASE_KEY}`,
      "Content-Type": "application/json",
      Prefer: "return=representation",
    },
    body: JSON.stringify(data),
  });
  if (!res.ok) throw new Error(await res.text());
  return res.json();
}

async function dbUpdate(table, id, data) {
  const res = await fetch(`${SUPABASE_URL}/rest/v1/${table}?id=eq.${id}`, {
    method: "PATCH",
    headers: {
      apikey: SUPABASE_KEY,
      Authorization: `Bearer ${SUPABASE_KEY}`,
      "Content-Type": "application/json",
      Prefer: "return=representation",
    },
    body: JSON.stringify(data),
  });
  if (!res.ok) throw new Error(await res.text());
  return res.json();
}

async function dbDelete(table, id) {
  const res = await fetch(`${SUPABASE_URL}/rest/v1/${table}?id=eq.${id}`, {
    method: "DELETE",
    headers: { apikey: SUPABASE_KEY, Authorization: `Bearer ${SUPABASE_KEY}` },
  });
  if (!res.ok) throw new Error(await res.text());
}

// ── Check if Supabase is configured ───────────────
const SUPABASE_READY = (
  SUPABASE_URL !== "YOUR_PROJECT_URL_HERE" &&
  SUPABASE_URL.includes("supabase.co")
);
