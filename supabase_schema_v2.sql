-- ═══════════════════════════════════════════════════════════
--   SARKARIALERT.IN — UPGRADED DATABASE SCHEMA v2
--   Run this in Supabase SQL Editor (Settings → SQL Editor)
--   This REPLACES your old table. Run once only.
-- ═══════════════════════════════════════════════════════════

-- Drop old table if it exists (CAUTION: this deletes old data)
-- Comment out the next line if you want to keep your existing data
-- DROP TABLE IF EXISTS jobs;

-- Create the unified posts table (handles ALL sections)
CREATE TABLE IF NOT EXISTS posts (
  id            BIGSERIAL PRIMARY KEY,

  -- ── SECTION (which page this post appears on) ──
  section       TEXT NOT NULL DEFAULT 'jobs',
  -- Values: 'jobs' | 'results' | 'admit_cards' | 'syllabus' | 'schemes' | 'answer_keys'

  -- ── BASIC INFO ──
  title         TEXT NOT NULL,
  dept          TEXT,
  cat           TEXT DEFAULT 'state',
  -- Values: 'railway' | 'upsc' | 'banking' | 'defence' | 'state'

  icon          TEXT DEFAULT '🏛️',
  summary       TEXT,   -- short one-line summary for cards

  -- ── JOB DETAILS ──
  vacancies     TEXT,
  qual          TEXT,   -- qualification required
  age           TEXT,   -- age limit
  fee_gen       TEXT,   -- fee for General/OBC/EWS
  fee_sc        TEXT,   -- fee for SC/ST/Female/PwBD

  -- ── DATES ──
  notif_date    TEXT,   -- notification release date
  start_date    TEXT,   -- application start date
  last_date     TEXT,   -- last date to apply / result date / exam date
  exam_date     TEXT,   -- exam date (for jobs & admit cards)
  result_date   TEXT,   -- result declaration date (for results)

  -- ── LINKS ──
  apply_link    TEXT,   -- official apply / result check link
  official_site TEXT,   -- official website domain (for citation)
  pdf_link      TEXT,   -- PDF link (for syllabus, admit card, answer key)

  -- ── CONTENT ──
  content       TEXT,   -- full detailed HTML content (Claude writes this)
  notes         TEXT,   -- additional notes / selection process

  -- ── STATUS & FLAGS ──
  status        TEXT DEFAULT 'open',
  -- Values: 'open' | 'soon' | 'closed' | 'result_out' | 'available' | 'declared'
  is_new        BOOLEAN DEFAULT TRUE,
  is_hot        BOOLEAN DEFAULT FALSE,
  is_important  BOOLEAN DEFAULT FALSE,

  -- ── AUTO TAGS (comma separated, auto-generated) ──
  tags          TEXT,

  -- ── TIMESTAMPS ──
  created_at    TIMESTAMPTZ DEFAULT NOW(),
  updated_at    TIMESTAMPTZ DEFAULT NOW()
);

-- ── INDEXES for fast filtering ──
CREATE INDEX IF NOT EXISTS idx_posts_section ON posts(section);
CREATE INDEX IF NOT EXISTS idx_posts_cat     ON posts(cat);
CREATE INDEX IF NOT EXISTS idx_posts_status  ON posts(status);
CREATE INDEX IF NOT EXISTS idx_posts_created ON posts(created_at DESC);

-- ── ROW LEVEL SECURITY ──
ALTER TABLE posts ENABLE ROW LEVEL SECURITY;

-- Allow public READ (visitors can see posts)
CREATE POLICY "Public can read posts"
  ON posts FOR SELECT USING (true);

-- Allow full access via anon key (admin panel uses anon key)
CREATE POLICY "Anon full access"
  ON posts FOR ALL USING (true) WITH CHECK (true);

-- ── AUTO-UPDATE timestamp ──
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN NEW.updated_at = NOW(); RETURN NEW; END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS posts_updated_at ON posts;
CREATE TRIGGER posts_updated_at
  BEFORE UPDATE ON posts
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();


-- ═══════════════════════════════════════════════════════════
--   SEED DATA — 6 sample posts across all sections
--   (Delete this section if you don't want sample data)
-- ═══════════════════════════════════════════════════════════

INSERT INTO posts (section, title, dept, cat, icon, vacancies, qual, age, fee_gen, fee_sc, notif_date, last_date, exam_date, status, apply_link, official_site, is_new, is_hot, tags, summary) VALUES

-- JOBS
('jobs', 'RRB ALP Recruitment 2026 — Assistant Loco Pilot (CEN 01/2026)', 'Railway Recruitment Board', 'railway', '🚂', '11,127', '10th + ITI / Diploma', '18–30 years', '₹500', '₹250', '16 March 2026', '14 June 2026', 'TBA', 'soon', 'https://www.rrbapply.gov.in/', 'rrbapply.gov.in', TRUE, TRUE, 'railway,loco pilot,iti,10th pass,rrb', 'RRB ALP 2026 — 11,127 vacancies for Assistant Loco Pilot. Applications open 15 May 2026.'),

('jobs', 'RBI Assistant Recruitment 2026', 'Reserve Bank of India', 'banking', '🏦', '650', 'Graduate (50%)', '20–28 years', '₹450', '₹50', 'March 2026', 'Check rbi.org.in', 'TBA', 'open', 'https://opportunities.rbi.org.in/', 'rbi.org.in', TRUE, TRUE, 'rbi,banking,graduate,bank jobs', '650 posts for RBI Assistant. Apply now at rbi.org.in.'),

-- RESULTS
('results', 'UPSC Civil Services Final Result 2025 Declared — Anuj Agnihotri AIR 1', 'Union Public Service Commission', 'upsc', '🏛️', '958 Selected', 'Any Graduate', '21–32 years', '₹100', 'NIL', '6 March 2026', '6 March 2026', '24 May 2026 (Prelims Next)', 'declared', 'https://upsc.gov.in/', 'upsc.gov.in', TRUE, TRUE, 'upsc,ias,ips,civil services,final result,2025', 'UPSC CSE 2025 Final Result declared. 958 candidates recommended. Anuj Agnihotri AIR 1.'),

('results', 'IBPS RRB Clerk Mains Result 2026 Declared — CRP RRBs XIV', 'Institute of Banking Personnel Selection', 'banking', '🏦', '8,002 Posts', 'Graduate', '20–28 years', '₹850', '₹175', '15 March 2026', '15 March 2026', 'Allotment by 15 Apr 2026', 'declared', 'https://www.ibps.in/', 'ibps.in', TRUE, FALSE, 'ibps,rrb,clerk,banking,result,mains', 'IBPS RRB Clerk Mains Result 2026 declared. Provisional allotment by 15 April 2026.'),

-- ADMIT CARDS
('admit_cards', 'UPSC CSE Prelims 2026 Admit Card — Download Now', 'Union Public Service Commission', 'upsc', '🎫', '—', 'Any Graduate', '21–32 years', '₹100', 'NIL', 'May 2026', 'Exam: 24 May 2026', '24 May 2026', 'soon', 'https://upsconline.nic.in/', 'upsconline.nic.in', TRUE, TRUE, 'upsc,admit card,prelims,hall ticket,2026', 'UPSC CSE Prelims 2026 admit card expected 2 weeks before 24 May exam.'),

-- SYLLABUS
('syllabus', 'SSC CGL 2026 Syllabus & Exam Pattern — Tier 1 & Tier 2', 'Staff Selection Commission', 'upsc', '📚', '14,582 Posts', 'Graduation', '18–32 years', '₹100', 'NIL', '31 March 2026', 'Download PDF', 'TBA', 'available', 'https://ssc.gov.in/', 'ssc.gov.in', TRUE, FALSE, 'ssc,cgl,syllabus,exam pattern,tier 1,tier 2', 'Complete SSC CGL 2026 syllabus. Tier 1 (Computer Based) + Tier 2 pattern with topic-wise marks.');
