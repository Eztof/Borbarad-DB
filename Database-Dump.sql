-- WARNING: This schema is for context only and is not meant to be run.
-- Table order and constraints may not be valid for execution.

CREATE TABLE public.app_settings (
  key text NOT NULL,
  value jsonb NOT NULL,
  updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT app_settings_pkey PRIMARY KEY (key)
);
CREATE TABLE public.diary (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone,
  user_id uuid,
  author_name text,
  title text NOT NULL,
  body_html text NOT NULL,
  av_date jsonb NOT NULL,
  tags text,
  signature text,
  CONSTRAINT diary_pkey PRIMARY KEY (id),
  CONSTRAINT diary_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id)
);
CREATE TABLE public.events (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  created_at timestamp with time zone DEFAULT now(),
  user_id uuid,
  type text DEFAULT 'story'::text CHECK (type = ANY (ARRAY['nsc_encounter'::text, 'object_found'::text, 'story'::text, 'travel'::text])),
  title text NOT NULL,
  description text,
  av_date jsonb NOT NULL,
  av_date_end jsonb,
  related_nsc_id uuid,
  related_object_id uuid,
  related_hero_id uuid,
  location text,
  CONSTRAINT events_pkey PRIMARY KEY (id),
  CONSTRAINT events_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id),
  CONSTRAINT events_related_nsc_id_fkey FOREIGN KEY (related_nsc_id) REFERENCES public.nscs(id),
  CONSTRAINT events_related_object_id_fkey FOREIGN KEY (related_object_id) REFERENCES public.objects(id),
  CONSTRAINT events_related_hero_id_fkey FOREIGN KEY (related_hero_id) REFERENCES public.heroes(id)
);
CREATE TABLE public.heroes (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  created_at timestamp with time zone DEFAULT now(),
  user_id uuid,
  name text NOT NULL,
  species text,
  profession text,
  notes text,
  ap_total integer DEFAULT 0,
  lp_current integer DEFAULT 30,
  lp_max integer DEFAULT 30,
  purse_dukaten integer DEFAULT 0,
  purse_silbertaler integer DEFAULT 0,
  purse_heller integer DEFAULT 0,
  purse_kreuzer integer DEFAULT 0,
  CONSTRAINT heroes_pkey PRIMARY KEY (id),
  CONSTRAINT heroes_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id)
);
CREATE TABLE public.nachteil (
  id integer NOT NULL DEFAULT nextval('nachteil_id_seq'::regclass),
  name text NOT NULL UNIQUE,
  CONSTRAINT nachteil_pkey PRIMARY KEY (id)
);
CREATE TABLE public.nscs (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  created_at timestamp with time zone DEFAULT now(),
  user_id uuid,
  name text NOT NULL,
  tags text,
  image_url text,
  biography text,
  first_encounter jsonb,
  last_encounter jsonb,
  whereabouts text,
  is_active boolean DEFAULT true,
  CONSTRAINT nscs_pkey PRIMARY KEY (id),
  CONSTRAINT nscs_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id)
);
CREATE TABLE public.nscs_history (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  created_at timestamp with time zone DEFAULT now(),
  nsc_id uuid NOT NULL,
  action text NOT NULL CHECK (action = ANY (ARRAY['insert'::text, 'update'::text])),
  changed_by uuid,
  changed_by_name text,
  data jsonb NOT NULL,
  CONSTRAINT nscs_history_pkey PRIMARY KEY (id),
  CONSTRAINT nscs_history_nsc_id_fkey FOREIGN KEY (nsc_id) REFERENCES public.nscs(id),
  CONSTRAINT nscs_history_changed_by_fkey FOREIGN KEY (changed_by) REFERENCES auth.users(id)
);
CREATE TABLE public.objects (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  created_at timestamp with time zone DEFAULT now(),
  user_id uuid,
  name text NOT NULL,
  tags text,
  image_url text,
  description text,
  first_seen jsonb,
  last_seen jsonb,
  location text,
  is_active boolean DEFAULT true,
  CONSTRAINT objects_pkey PRIMARY KEY (id),
  CONSTRAINT objects_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id)
);
CREATE TABLE public.objects_history (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  created_at timestamp with time zone DEFAULT now(),
  object_id uuid NOT NULL,
  action text NOT NULL CHECK (action = ANY (ARRAY['insert'::text, 'update'::text])),
  changed_by uuid,
  changed_by_name text,
  data jsonb NOT NULL,
  CONSTRAINT objects_history_pkey PRIMARY KEY (id),
  CONSTRAINT objects_history_object_id_fkey FOREIGN KEY (object_id) REFERENCES public.objects(id),
  CONSTRAINT objects_history_changed_by_fkey FOREIGN KEY (changed_by) REFERENCES auth.users(id)
);
CREATE TABLE public.profiles (
  user_id uuid NOT NULL,
  username text NOT NULL UNIQUE,
  email_stash text NOT NULL UNIQUE,
  created_at timestamp with time zone DEFAULT now(),
  active_hero_id uuid,
  CONSTRAINT profiles_pkey PRIMARY KEY (user_id),
  CONSTRAINT profiles_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id),
  CONSTRAINT profiles_active_hero_id_fkey FOREIGN KEY (active_hero_id) REFERENCES public.heroes(id)
);
CREATE TABLE public.quelle (
  id integer NOT NULL DEFAULT nextval('quelle_id_seq'::regclass),
  code text NOT NULL,
  titel text NOT NULL,
  auflage text,
  verlag text,
  jahr integer,
  CONSTRAINT quelle_pkey PRIMARY KEY (id)
);
CREATE TABLE public.sf__tag (
  sf_id integer NOT NULL,
  tag_id integer NOT NULL,
  CONSTRAINT sf__tag_pkey PRIMARY KEY (sf_id, tag_id),
  CONSTRAINT sf__tag_sf_id_fkey FOREIGN KEY (sf_id) REFERENCES public.sonderfertigkeit(id),
  CONSTRAINT sf__tag_tag_id_fkey FOREIGN KEY (tag_id) REFERENCES public.tag(id)
);
CREATE TABLE public.sf__talent (
  sf_id integer NOT NULL,
  talent_id integer NOT NULL,
  CONSTRAINT sf__talent_pkey PRIMARY KEY (sf_id, talent_id),
  CONSTRAINT sf__talent_sf_id_fkey FOREIGN KEY (sf_id) REFERENCES public.sonderfertigkeit(id),
  CONSTRAINT sf__talent_talent_id_fkey FOREIGN KEY (talent_id) REFERENCES public.talent(id)
);
CREATE TABLE public.sf__tradition (
  sf_id integer NOT NULL,
  tradition_id integer NOT NULL,
  CONSTRAINT sf__tradition_pkey PRIMARY KEY (sf_id, tradition_id),
  CONSTRAINT sf__tradition_sf_id_fkey FOREIGN KEY (sf_id) REFERENCES public.sonderfertigkeit(id),
  CONSTRAINT sf__tradition_tradition_id_fkey FOREIGN KEY (tradition_id) REFERENCES public.tradition(id)
);
CREATE TABLE public.sf__waffengruppe (
  sf_id integer NOT NULL,
  waffengruppe_id integer NOT NULL,
  CONSTRAINT sf__waffengruppe_pkey PRIMARY KEY (sf_id, waffengruppe_id),
  CONSTRAINT sf__waffengruppe_sf_id_fkey FOREIGN KEY (sf_id) REFERENCES public.sonderfertigkeit(id),
  CONSTRAINT sf__waffengruppe_waffengruppe_id_fkey FOREIGN KEY (waffengruppe_id) REFERENCES public.waffengruppe(id)
);
CREATE TABLE public.sf_konflikt (
  id integer NOT NULL DEFAULT nextval('sf_konflikt_id_seq'::regclass),
  sf_id integer NOT NULL,
  ausschluss_sf_id integer NOT NULL,
  bemerkung text,
  CONSTRAINT sf_konflikt_pkey PRIMARY KEY (id),
  CONSTRAINT sf_konflikt_sf_id_fkey FOREIGN KEY (sf_id) REFERENCES public.sonderfertigkeit(id),
  CONSTRAINT sf_konflikt_ausschluss_sf_id_fkey FOREIGN KEY (ausschluss_sf_id) REFERENCES public.sonderfertigkeit(id)
);
CREATE TABLE public.sf_kosten (
  id integer NOT NULL DEFAULT nextval('sf_kosten_id_seq'::regclass),
  sf_id integer NOT NULL,
  stufe_id integer,
  betrag integer,
  ist_variabel boolean NOT NULL DEFAULT false,
  formel text,
  bemerkung text,
  CONSTRAINT sf_kosten_pkey PRIMARY KEY (id),
  CONSTRAINT sf_kosten_sf_id_fkey FOREIGN KEY (sf_id) REFERENCES public.sonderfertigkeit(id),
  CONSTRAINT sf_kosten_stufe_id_fkey FOREIGN KEY (stufe_id) REFERENCES public.sf_stufe(id)
);
CREATE TABLE public.sf_modifikator (
  id integer NOT NULL DEFAULT nextval('sf_modifikator_id_seq'::regclass),
  sf_id integer NOT NULL,
  stufe_id integer,
  ziel_typ text NOT NULL,
  ziel_ref text,
  operator USER-DEFINED NOT NULL DEFAULT 'add'::wirk_operator,
  wert_num numeric,
  wert_wuerfel text,
  bedingung text,
  stapelregel text,
  CONSTRAINT sf_modifikator_pkey PRIMARY KEY (id),
  CONSTRAINT sf_modifikator_sf_id_fkey FOREIGN KEY (sf_id) REFERENCES public.sonderfertigkeit(id),
  CONSTRAINT sf_modifikator_stufe_id_fkey FOREIGN KEY (stufe_id) REFERENCES public.sf_stufe(id)
);
CREATE TABLE public.sf_nutzung (
  id integer NOT NULL DEFAULT nextval('sf_nutzung_id_seq'::regclass),
  sf_id integer NOT NULL,
  stufe_id integer,
  aktivierung USER-DEFINED NOT NULL DEFAULT 'passiv'::aktionstyp,
  aktionen_kosten numeric,
  dauer_typ text,
  dauer_wert text,
  bedingung text,
  CONSTRAINT sf_nutzung_pkey PRIMARY KEY (id),
  CONSTRAINT sf_nutzung_sf_id_fkey FOREIGN KEY (sf_id) REFERENCES public.sonderfertigkeit(id),
  CONSTRAINT sf_nutzung_stufe_id_fkey FOREIGN KEY (stufe_id) REFERENCES public.sf_stufe(id)
);
CREATE TABLE public.sf_nutzung_ressource (
  id integer NOT NULL DEFAULT nextval('sf_nutzung_ressource_id_seq'::regclass),
  nutzung_id integer NOT NULL,
  typ USER-DEFINED NOT NULL,
  betrag integer,
  formel text,
  bemerkung text,
  CONSTRAINT sf_nutzung_ressource_pkey PRIMARY KEY (id),
  CONSTRAINT sf_nutzung_ressource_nutzung_id_fkey FOREIGN KEY (nutzung_id) REFERENCES public.sf_nutzung(id)
);
CREATE TABLE public.sf_pre_attribut (
  id integer NOT NULL DEFAULT nextval('sf_pre_attribut_id_seq'::regclass),
  sf_id integer NOT NULL,
  attribut USER-DEFINED NOT NULL,
  operator USER-DEFINED NOT NULL DEFAULT '>='::vergleich_op,
  wert integer NOT NULL,
  CONSTRAINT sf_pre_attribut_pkey PRIMARY KEY (id),
  CONSTRAINT sf_pre_attribut_sf_id_fkey FOREIGN KEY (sf_id) REFERENCES public.sonderfertigkeit(id)
);
CREATE TABLE public.sf_pre_kultur (
  id integer NOT NULL DEFAULT nextval('sf_pre_kultur_id_seq'::regclass),
  sf_id integer NOT NULL,
  kultur text NOT NULL,
  CONSTRAINT sf_pre_kultur_pkey PRIMARY KEY (id),
  CONSTRAINT sf_pre_kultur_sf_id_fkey FOREIGN KEY (sf_id) REFERENCES public.sonderfertigkeit(id)
);
CREATE TABLE public.sf_pre_nachteil (
  id integer NOT NULL DEFAULT nextval('sf_pre_nachteil_id_seq'::regclass),
  sf_id integer NOT NULL,
  nachteil_id integer NOT NULL,
  CONSTRAINT sf_pre_nachteil_pkey PRIMARY KEY (id),
  CONSTRAINT sf_pre_nachteil_sf_id_fkey FOREIGN KEY (sf_id) REFERENCES public.sonderfertigkeit(id),
  CONSTRAINT sf_pre_nachteil_nachteil_id_fkey FOREIGN KEY (nachteil_id) REFERENCES public.nachteil(id)
);
CREATE TABLE public.sf_pre_profession (
  id integer NOT NULL DEFAULT nextval('sf_pre_profession_id_seq'::regclass),
  sf_id integer NOT NULL,
  profession text NOT NULL,
  CONSTRAINT sf_pre_profession_pkey PRIMARY KEY (id),
  CONSTRAINT sf_pre_profession_sf_id_fkey FOREIGN KEY (sf_id) REFERENCES public.sonderfertigkeit(id)
);
CREATE TABLE public.sf_pre_sf (
  id integer NOT NULL DEFAULT nextval('sf_pre_sf_id_seq'::regclass),
  sf_id integer NOT NULL,
  braucht_sf_id integer NOT NULL,
  min_stufe_id integer,
  CONSTRAINT sf_pre_sf_pkey PRIMARY KEY (id),
  CONSTRAINT sf_pre_sf_sf_id_fkey FOREIGN KEY (sf_id) REFERENCES public.sonderfertigkeit(id),
  CONSTRAINT sf_pre_sf_braucht_sf_id_fkey FOREIGN KEY (braucht_sf_id) REFERENCES public.sonderfertigkeit(id),
  CONSTRAINT sf_pre_sf_min_stufe_id_fkey FOREIGN KEY (min_stufe_id) REFERENCES public.sf_stufe(id)
);
CREATE TABLE public.sf_pre_talent (
  id integer NOT NULL DEFAULT nextval('sf_pre_talent_id_seq'::regclass),
  sf_id integer NOT NULL,
  talent_id integer NOT NULL,
  min_taw integer NOT NULL,
  CONSTRAINT sf_pre_talent_pkey PRIMARY KEY (id),
  CONSTRAINT sf_pre_talent_sf_id_fkey FOREIGN KEY (sf_id) REFERENCES public.sonderfertigkeit(id),
  CONSTRAINT sf_pre_talent_talent_id_fkey FOREIGN KEY (talent_id) REFERENCES public.talent(id)
);
CREATE TABLE public.sf_pre_tradition (
  id integer NOT NULL DEFAULT nextval('sf_pre_tradition_id_seq'::regclass),
  sf_id integer NOT NULL,
  tradition_id integer NOT NULL,
  CONSTRAINT sf_pre_tradition_pkey PRIMARY KEY (id),
  CONSTRAINT sf_pre_tradition_sf_id_fkey FOREIGN KEY (sf_id) REFERENCES public.sonderfertigkeit(id),
  CONSTRAINT sf_pre_tradition_tradition_id_fkey FOREIGN KEY (tradition_id) REFERENCES public.tradition(id)
);
CREATE TABLE public.sf_pre_vorteil (
  id integer NOT NULL DEFAULT nextval('sf_pre_vorteil_id_seq'::regclass),
  sf_id integer NOT NULL,
  vorteil_id integer NOT NULL,
  CONSTRAINT sf_pre_vorteil_pkey PRIMARY KEY (id),
  CONSTRAINT sf_pre_vorteil_sf_id_fkey FOREIGN KEY (sf_id) REFERENCES public.sonderfertigkeit(id),
  CONSTRAINT sf_pre_vorteil_vorteil_id_fkey FOREIGN KEY (vorteil_id) REFERENCES public.vorteil(id)
);
CREATE TABLE public.sf_pre_waffengruppe (
  id integer NOT NULL DEFAULT nextval('sf_pre_waffengruppe_id_seq'::regclass),
  sf_id integer NOT NULL,
  waffengruppe_id integer NOT NULL,
  CONSTRAINT sf_pre_waffengruppe_pkey PRIMARY KEY (id),
  CONSTRAINT sf_pre_waffengruppe_sf_id_fkey FOREIGN KEY (sf_id) REFERENCES public.sonderfertigkeit(id),
  CONSTRAINT sf_pre_waffengruppe_waffengruppe_id_fkey FOREIGN KEY (waffengruppe_id) REFERENCES public.waffengruppe(id)
);
CREATE TABLE public.sf_quelle (
  id integer NOT NULL DEFAULT nextval('sf_quelle_id_seq'::regclass),
  sf_id integer NOT NULL,
  stufe_id integer,
  quelle_id integer NOT NULL,
  seite text,
  errata_hint text,
  CONSTRAINT sf_quelle_pkey PRIMARY KEY (id),
  CONSTRAINT sf_quelle_sf_id_fkey FOREIGN KEY (sf_id) REFERENCES public.sonderfertigkeit(id),
  CONSTRAINT sf_quelle_stufe_id_fkey FOREIGN KEY (stufe_id) REFERENCES public.sf_stufe(id),
  CONSTRAINT sf_quelle_quelle_id_fkey FOREIGN KEY (quelle_id) REFERENCES public.quelle(id)
);
CREATE TABLE public.sf_stufe (
  id integer NOT NULL DEFAULT nextval('sf_stufe_id_seq'::regclass),
  sf_id integer NOT NULL,
  bezeichnung text NOT NULL,
  reihenfolge integer NOT NULL DEFAULT 1,
  CONSTRAINT sf_stufe_pkey PRIMARY KEY (id),
  CONSTRAINT sf_stufe_sf_id_fkey FOREIGN KEY (sf_id) REFERENCES public.sonderfertigkeit(id)
);
CREATE TABLE public.sf_version (
  id integer NOT NULL DEFAULT nextval('sf_version_id_seq'::regclass),
  sf_id integer NOT NULL,
  gueltig_ab date NOT NULL,
  aenderung text NOT NULL,
  CONSTRAINT sf_version_pkey PRIMARY KEY (id),
  CONSTRAINT sf_version_sf_id_fkey FOREIGN KEY (sf_id) REFERENCES public.sonderfertigkeit(id)
);
CREATE TABLE public.sf_voraussetzung_text (
  id integer NOT NULL DEFAULT nextval('sf_voraussetzung_text_id_seq'::regclass),
  sf_id integer NOT NULL,
  text text NOT NULL,
  CONSTRAINT sf_voraussetzung_text_pkey PRIMARY KEY (id),
  CONSTRAINT sf_voraussetzung_text_sf_id_fkey FOREIGN KEY (sf_id) REFERENCES public.sonderfertigkeit(id)
);
CREATE TABLE public.sf_voraussetzungsgruppe (
  id integer NOT NULL DEFAULT nextval('sf_voraussetzungsgruppe_id_seq'::regclass),
  sf_id integer NOT NULL,
  logik USER-DEFINED NOT NULL DEFAULT 'alle'::voraussetz_logik,
  bemerkung text,
  CONSTRAINT sf_voraussetzungsgruppe_pkey PRIMARY KEY (id),
  CONSTRAINT sf_voraussetzungsgruppe_sf_id_fkey FOREIGN KEY (sf_id) REFERENCES public.sonderfertigkeit(id)
);
CREATE TABLE public.sf_voraussetzungsgruppe_item (
  id integer NOT NULL DEFAULT nextval('sf_voraussetzungsgruppe_item_id_seq'::regclass),
  gruppe_id integer NOT NULL,
  typ text NOT NULL,
  ref_id integer,
  text text,
  CONSTRAINT sf_voraussetzungsgruppe_item_pkey PRIMARY KEY (id),
  CONSTRAINT sf_voraussetzungsgruppe_item_gruppe_id_fkey FOREIGN KEY (gruppe_id) REFERENCES public.sf_voraussetzungsgruppe(id)
);
CREATE TABLE public.sf_wirkung_text (
  id integer NOT NULL DEFAULT nextval('sf_wirkung_text_id_seq'::regclass),
  sf_id integer NOT NULL,
  stufe_id integer,
  text text NOT NULL,
  CONSTRAINT sf_wirkung_text_pkey PRIMARY KEY (id),
  CONSTRAINT sf_wirkung_text_sf_id_fkey FOREIGN KEY (sf_id) REFERENCES public.sonderfertigkeit(id),
  CONSTRAINT sf_wirkung_text_stufe_id_fkey FOREIGN KEY (stufe_id) REFERENCES public.sf_stufe(id)
);
CREATE TABLE public.sonderfertigkeit (
  id integer NOT NULL DEFAULT nextval('sonderfertigkeit_id_seq'::regclass),
  name text NOT NULL,
  kurzname text,
  kategorie text NOT NULL,
  status USER-DEFINED NOT NULL DEFAULT 'offiziell'::sf_status,
  regelwerk text NOT NULL DEFAULT 'DSA 4.1'::text,
  beschreibung_kurz text,
  einzigartig boolean NOT NULL DEFAULT false,
  stapelbar boolean NOT NULL DEFAULT false,
  bemerkung text,
  CONSTRAINT sonderfertigkeit_pkey PRIMARY KEY (id)
);
CREATE TABLE public.tag (
  id integer NOT NULL DEFAULT nextval('tag_id_seq'::regclass),
  name text NOT NULL UNIQUE,
  CONSTRAINT tag_pkey PRIMARY KEY (id)
);
CREATE TABLE public.tags (
  name text NOT NULL,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT tags_pkey PRIMARY KEY (name)
);
CREATE TABLE public.talent (
  id integer NOT NULL DEFAULT nextval('talent_id_seq'::regclass),
  name text NOT NULL UNIQUE,
  gruppe text NOT NULL,
  regelwerk text DEFAULT 'DSA 4.1'::text,
  CONSTRAINT talent_pkey PRIMARY KEY (id)
);
CREATE TABLE public.tradition (
  id integer NOT NULL DEFAULT nextval('tradition_id_seq'::regclass),
  name text NOT NULL UNIQUE,
  art text NOT NULL,
  CONSTRAINT tradition_pkey PRIMARY KEY (id)
);
CREATE TABLE public.vorteil (
  id integer NOT NULL DEFAULT nextval('vorteil_id_seq'::regclass),
  name text NOT NULL UNIQUE,
  CONSTRAINT vorteil_pkey PRIMARY KEY (id)
);
CREATE TABLE public.waffengruppe (
  id integer NOT NULL DEFAULT nextval('waffengruppe_id_seq'::regclass),
  name text NOT NULL UNIQUE,
  CONSTRAINT waffengruppe_pkey PRIMARY KEY (id)
);
