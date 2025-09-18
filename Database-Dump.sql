create table public.spells_flat (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),

  -- Basis
  canonical_name text not null,
  short_name text,
  aliases text,                -- Semikolon-getrennt
  letter char(1) check (letter ~ '^[A-ZÄÖÜ]$'),
  complexity char(1) check (complexity in ('A','B','C','D','E','F')),
  traits text,                 -- Semikolon-getrennt
  source_book text default 'LCD',
  source_page integer,

  -- Probe
  probe_attr1 text check (probe_attr1 in ('MU','KL','IN','CH','FF','GE','KO','KK')),
  probe_attr2 text check (probe_attr2 in ('MU','KL','IN','CH','FF','GE','KO','KK')),
  probe_attr3 text check (probe_attr3 in ('MU','KL','IN','CH','FF','GE','KO','KK')),
  probe_base_mod integer,
  probe_vs_mr boolean,

  -- Komponenten & Anforderungen
  comp_concentration boolean,
  comp_sight boolean,
  comp_geste boolean,
  comp_formel boolean,
  comp_material text,
  req_contact_earth boolean,
  req_no_refined_metal boolean,
  req_focus_object boolean,
  comp_notes text,

  -- Zauberdauer
  cast_time_unit text,         -- Aktion/KR/SR/Min/h
  cast_time_value numeric,
  cast_time_formula text,      -- freie Formel, falls nötig
  cast_time_notes text,

  -- Reichweite
  range_type text,             -- Stufe | Fix | Formel | Wert+Einheit
  range_stage text,            -- Selbst/Berührung/3/7/21/49/Sicht/...
  range_value numeric,
  range_value_unit text,
  range_is_zfw boolean,        -- z.B. „ZfW Schritt“
  range_notes text,

  -- Ziel
  target_kind text,
  target_willing boolean,
  target_quantity integer,
  target_area_value numeric,
  target_area_unit text,
  target_notes text,

  -- Wirkungsdauer
  duration_type text,          -- augenblicklich | aufrechterhalten | feste Dauer | permanent
  duration_value numeric,
  duration_unit text,
  duration_cost_per_unit numeric,
  duration_cost_unit text,
  duration_notes text,

  -- Kosten
  cost_base_asp numeric,
  cost_per_unit_asp numeric,
  cost_per_unit_what text,     -- KR, 5 Stein, Schritt, ...
  cost_min_asp numeric,
  cost_perm_note text,
  cost_notes text,

  -- Erlaubte Spontane Modifikationen
  allow_mod_casttime boolean,
  allow_mod_cost boolean,
  allow_mod_range boolean,
  allow_mod_duration boolean,
  allow_mod_target boolean,
  allow_mod_multi_vol boolean,
  allow_mod_multi_invol boolean,
  allow_mod_erzwingen boolean,

  -- Varianten & Fließtexte (verlustfrei, frei formuliert)
  variants_text text,
  effect_summary text,
  reversalis text,
  antimagic_text text,
  notes text,

  -- Repräsentationen & Verbreitung (1–7), flach als Spalten
  rep_mag smallint,
  rep_elf smallint,
  rep_dru smallint,
  rep_hex smallint,
  rep_geo smallint,
  rep_srl smallint,
  rep_bor smallint,
  rep_ach smallint,
  rep_kop smallint,
  rep_sat smallint,
  rep_gro smallint,
  rep_mud smallint,
  rep_guel smallint,
  rep_alh smallint,
  rep_sch smallint,

  unique (canonical_name, source_book)
);

-- sinnvolle Indizes
create index spells_flat_name_tsv on public.spells_flat
  using gin (to_tsvector('german', coalesce(canonical_name,'') || ' ' || coalesce(short_name,'')));

create index spells_flat_traits_gin on public.spells_flat
  using gin (string_to_array(coalesce(traits,''), ';'));
