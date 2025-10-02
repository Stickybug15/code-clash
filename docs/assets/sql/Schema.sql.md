```sql
-- =========================
-- Levels
-- =========================
CREATE TABLE public.levels (
  id UUID PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT
  data jsonb
);

-- =========================
-- Player Level Scores
-- (raw values per attempt)
-- =========================
CREATE TABLE public.player_level_scores (
  id UUID PRIMARY KEY,
  user_id UUID NOT NULL,
  level_id UUID NOT NULL REFERENCES public.levels(id) ON DELETE CASCADE,
  speed_seconds FLOAT,         -- End Time - Start Time
  accuracy_score INTEGER,      -- Correct Lines - Error Count
  normalized_speed FLOAT,      -- 0-100
  normalized_accuracy FLOAT,   -- 0-100
  created_at TIMESTAMPTZ DEFAULT now()
);

-- =========================
-- Best Level Scores
-- (keeps each player's best normalized scores per level)
-- =========================
CREATE TABLE public.player_best_level_scores (
  user_id UUID NOT NULL,
  level_id UUID NOT NULL REFERENCES public.levels(id) ON DELETE CASCADE,
  best_speed_seconds FLOAT,
  best_accuracy_score INTEGER,
  best_normalized_speed FLOAT,
  best_normalized_accuracy FLOAT,
  last_updated TIMESTAMPTZ DEFAULT now(),
  PRIMARY KEY (user_id, level_id)
);

-- =========================
-- Mastery / Proficiency
-- (global per-player performance)
-- =========================
CREATE TABLE public.player_mastery (
  user_id UUID PRIMARY KEY,
  proficiency FLOAT,          -- average of normalized scores across levels
  last_updated TIMESTAMPTZ DEFAULT now()
);
```
