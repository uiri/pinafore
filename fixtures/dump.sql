PGDMP          9                v            mastodon_development    10.2    10.2 �   �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                       false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                       false            �           1262    38312    mastodon_development    DATABASE     �   CREATE DATABASE mastodon_development WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_US.UTF-8' LC_CTYPE = 'en_US.UTF-8';
 $   DROP DATABASE mastodon_development;
             nolan    false                        2615    2200    public    SCHEMA        CREATE SCHEMA public;
    DROP SCHEMA public;
             nolan    false                        0    0    SCHEMA public    COMMENT     6   COMMENT ON SCHEMA public IS 'standard public schema';
                  nolan    false    3                        3079    12544    plpgsql 	   EXTENSION     ?   CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;
    DROP EXTENSION plpgsql;
                  false                       0    0    EXTENSION plpgsql    COMMENT     @   COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';
                       false    1                       1255    38313    timestamp_id(text)    FUNCTION     Y  CREATE FUNCTION timestamp_id(table_name text) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
  DECLARE
    time_part bigint;
    sequence_base bigint;
    tail bigint;
  BEGIN
    time_part := (
      -- Get the time in milliseconds
      ((date_part('epoch', now()) * 1000))::bigint
      -- And shift it over two bytes
      << 16);

    sequence_base := (
      'x' ||
      -- Take the first two bytes (four hex characters)
      substr(
        -- Of the MD5 hash of the data we documented
        md5(table_name ||
          '69283236cfae0066ef13109248240c43' ||
          time_part::text
        ),
        1, 4
      )
    -- And turn it into a bigint
    )::bit(16)::bigint;

    -- Finally, add our sequence number to our base, and chop
    -- it to the last two bytes
    tail := (
      (sequence_base + nextval(table_name || '_id_seq'))
      & 65535);

    -- Return the time part and the sequence part. OR appears
    -- faster here than addition, but they're equivalent:
    -- time_part has no trailing two bytes, and tail is only
    -- the last two bytes.
    RETURN time_part | tail;
  END
$$;
 4   DROP FUNCTION public.timestamp_id(table_name text);
       public       nolan    false    1    3            �            1259    38314    account_domain_blocks    TABLE     �   CREATE TABLE account_domain_blocks (
    id bigint NOT NULL,
    domain character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    account_id bigint
);
 )   DROP TABLE public.account_domain_blocks;
       public         nolan    false    3            �            1259    38320    account_domain_blocks_id_seq    SEQUENCE     ~   CREATE SEQUENCE account_domain_blocks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public.account_domain_blocks_id_seq;
       public       nolan    false    3    196                       0    0    account_domain_blocks_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE account_domain_blocks_id_seq OWNED BY account_domain_blocks.id;
            public       nolan    false    197            �            1259    38322    account_moderation_notes    TABLE       CREATE TABLE account_moderation_notes (
    id bigint NOT NULL,
    content text NOT NULL,
    account_id bigint NOT NULL,
    target_account_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);
 ,   DROP TABLE public.account_moderation_notes;
       public         nolan    false    3            �            1259    38328    account_moderation_notes_id_seq    SEQUENCE     �   CREATE SEQUENCE account_moderation_notes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 6   DROP SEQUENCE public.account_moderation_notes_id_seq;
       public       nolan    false    3    198                       0    0    account_moderation_notes_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE account_moderation_notes_id_seq OWNED BY account_moderation_notes.id;
            public       nolan    false    199            �            1259    38330    accounts    TABLE       CREATE TABLE accounts (
    id bigint NOT NULL,
    username character varying DEFAULT ''::character varying NOT NULL,
    domain character varying,
    secret character varying DEFAULT ''::character varying NOT NULL,
    private_key text,
    public_key text DEFAULT ''::text NOT NULL,
    remote_url character varying DEFAULT ''::character varying NOT NULL,
    salmon_url character varying DEFAULT ''::character varying NOT NULL,
    hub_url character varying DEFAULT ''::character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    note text DEFAULT ''::text NOT NULL,
    display_name character varying DEFAULT ''::character varying NOT NULL,
    uri character varying DEFAULT ''::character varying NOT NULL,
    url character varying,
    avatar_file_name character varying,
    avatar_content_type character varying,
    avatar_file_size integer,
    avatar_updated_at timestamp without time zone,
    header_file_name character varying,
    header_content_type character varying,
    header_file_size integer,
    header_updated_at timestamp without time zone,
    avatar_remote_url character varying,
    subscription_expires_at timestamp without time zone,
    silenced boolean DEFAULT false NOT NULL,
    suspended boolean DEFAULT false NOT NULL,
    locked boolean DEFAULT false NOT NULL,
    header_remote_url character varying DEFAULT ''::character varying NOT NULL,
    statuses_count integer DEFAULT 0 NOT NULL,
    followers_count integer DEFAULT 0 NOT NULL,
    following_count integer DEFAULT 0 NOT NULL,
    last_webfingered_at timestamp without time zone,
    inbox_url character varying DEFAULT ''::character varying NOT NULL,
    outbox_url character varying DEFAULT ''::character varying NOT NULL,
    shared_inbox_url character varying DEFAULT ''::character varying NOT NULL,
    followers_url character varying DEFAULT ''::character varying NOT NULL,
    protocol integer DEFAULT 0 NOT NULL,
    memorial boolean DEFAULT false NOT NULL,
    moved_to_account_id bigint
);
    DROP TABLE public.accounts;
       public         nolan    false    3            �            1259    38358    accounts_id_seq    SEQUENCE     q   CREATE SEQUENCE accounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.accounts_id_seq;
       public       nolan    false    200    3                       0    0    accounts_id_seq    SEQUENCE OWNED BY     5   ALTER SEQUENCE accounts_id_seq OWNED BY accounts.id;
            public       nolan    false    201            �            1259    38360    admin_action_logs    TABLE     o  CREATE TABLE admin_action_logs (
    id bigint NOT NULL,
    account_id bigint,
    action character varying DEFAULT ''::character varying NOT NULL,
    target_type character varying,
    target_id bigint,
    recorded_changes text DEFAULT ''::text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);
 %   DROP TABLE public.admin_action_logs;
       public         nolan    false    3            �            1259    38368    admin_action_logs_id_seq    SEQUENCE     z   CREATE SEQUENCE admin_action_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.admin_action_logs_id_seq;
       public       nolan    false    202    3                       0    0    admin_action_logs_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE admin_action_logs_id_seq OWNED BY admin_action_logs.id;
            public       nolan    false    203            �            1259    38370    ar_internal_metadata    TABLE     �   CREATE TABLE ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);
 (   DROP TABLE public.ar_internal_metadata;
       public         nolan    false    3            �            1259    38376    blocks    TABLE     �   CREATE TABLE blocks (
    id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    account_id bigint NOT NULL,
    target_account_id bigint NOT NULL
);
    DROP TABLE public.blocks;
       public         nolan    false    3            �            1259    38379    blocks_id_seq    SEQUENCE     o   CREATE SEQUENCE blocks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.blocks_id_seq;
       public       nolan    false    3    205                       0    0    blocks_id_seq    SEQUENCE OWNED BY     1   ALTER SEQUENCE blocks_id_seq OWNED BY blocks.id;
            public       nolan    false    206            �            1259    38381    conversation_mutes    TABLE     �   CREATE TABLE conversation_mutes (
    id bigint NOT NULL,
    conversation_id bigint NOT NULL,
    account_id bigint NOT NULL
);
 &   DROP TABLE public.conversation_mutes;
       public         nolan    false    3            �            1259    38384    conversation_mutes_id_seq    SEQUENCE     {   CREATE SEQUENCE conversation_mutes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.conversation_mutes_id_seq;
       public       nolan    false    207    3                       0    0    conversation_mutes_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE conversation_mutes_id_seq OWNED BY conversation_mutes.id;
            public       nolan    false    208            �            1259    38386    conversations    TABLE     �   CREATE TABLE conversations (
    id bigint NOT NULL,
    uri character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);
 !   DROP TABLE public.conversations;
       public         nolan    false    3            �            1259    38392    conversations_id_seq    SEQUENCE     v   CREATE SEQUENCE conversations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.conversations_id_seq;
       public       nolan    false    3    209                       0    0    conversations_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE conversations_id_seq OWNED BY conversations.id;
            public       nolan    false    210            �            1259    38394    custom_emojis    TABLE     L  CREATE TABLE custom_emojis (
    id bigint NOT NULL,
    shortcode character varying DEFAULT ''::character varying NOT NULL,
    domain character varying,
    image_file_name character varying,
    image_content_type character varying,
    image_file_size integer,
    image_updated_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    disabled boolean DEFAULT false NOT NULL,
    uri character varying,
    image_remote_url character varying,
    visible_in_picker boolean DEFAULT true NOT NULL
);
 !   DROP TABLE public.custom_emojis;
       public         nolan    false    3            �            1259    38403    custom_emojis_id_seq    SEQUENCE     v   CREATE SEQUENCE custom_emojis_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.custom_emojis_id_seq;
       public       nolan    false    3    211            	           0    0    custom_emojis_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE custom_emojis_id_seq OWNED BY custom_emojis.id;
            public       nolan    false    212            �            1259    38405    domain_blocks    TABLE     7  CREATE TABLE domain_blocks (
    id bigint NOT NULL,
    domain character varying DEFAULT ''::character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    severity integer DEFAULT 0,
    reject_media boolean DEFAULT false NOT NULL
);
 !   DROP TABLE public.domain_blocks;
       public         nolan    false    3            �            1259    38414    domain_blocks_id_seq    SEQUENCE     v   CREATE SEQUENCE domain_blocks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.domain_blocks_id_seq;
       public       nolan    false    213    3            
           0    0    domain_blocks_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE domain_blocks_id_seq OWNED BY domain_blocks.id;
            public       nolan    false    214            �            1259    38416    email_domain_blocks    TABLE     �   CREATE TABLE email_domain_blocks (
    id bigint NOT NULL,
    domain character varying DEFAULT ''::character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);
 '   DROP TABLE public.email_domain_blocks;
       public         nolan    false    3            �            1259    38423    email_domain_blocks_id_seq    SEQUENCE     |   CREATE SEQUENCE email_domain_blocks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public.email_domain_blocks_id_seq;
       public       nolan    false    215    3                       0    0    email_domain_blocks_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE email_domain_blocks_id_seq OWNED BY email_domain_blocks.id;
            public       nolan    false    216            �            1259    38425 
   favourites    TABLE     �   CREATE TABLE favourites (
    id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    account_id bigint NOT NULL,
    status_id bigint NOT NULL
);
    DROP TABLE public.favourites;
       public         nolan    false    3            �            1259    38428    favourites_id_seq    SEQUENCE     s   CREATE SEQUENCE favourites_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.favourites_id_seq;
       public       nolan    false    3    217                       0    0    favourites_id_seq    SEQUENCE OWNED BY     9   ALTER SEQUENCE favourites_id_seq OWNED BY favourites.id;
            public       nolan    false    218            �            1259    38430    follow_requests    TABLE       CREATE TABLE follow_requests (
    id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    account_id bigint NOT NULL,
    target_account_id bigint NOT NULL,
    show_reblogs boolean DEFAULT true NOT NULL
);
 #   DROP TABLE public.follow_requests;
       public         nolan    false    3            �            1259    38434    follow_requests_id_seq    SEQUENCE     x   CREATE SEQUENCE follow_requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.follow_requests_id_seq;
       public       nolan    false    219    3                       0    0    follow_requests_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE follow_requests_id_seq OWNED BY follow_requests.id;
            public       nolan    false    220            �            1259    38436    follows    TABLE       CREATE TABLE follows (
    id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    account_id bigint NOT NULL,
    target_account_id bigint NOT NULL,
    show_reblogs boolean DEFAULT true NOT NULL
);
    DROP TABLE public.follows;
       public         nolan    false    3            �            1259    38440    follows_id_seq    SEQUENCE     p   CREATE SEQUENCE follows_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.follows_id_seq;
       public       nolan    false    3    221                       0    0    follows_id_seq    SEQUENCE OWNED BY     3   ALTER SEQUENCE follows_id_seq OWNED BY follows.id;
            public       nolan    false    222            �            1259    38442    imports    TABLE     �  CREATE TABLE imports (
    id bigint NOT NULL,
    type integer NOT NULL,
    approved boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    data_file_name character varying,
    data_content_type character varying,
    data_file_size integer,
    data_updated_at timestamp without time zone,
    account_id bigint NOT NULL
);
    DROP TABLE public.imports;
       public         nolan    false    3            �            1259    38449    imports_id_seq    SEQUENCE     p   CREATE SEQUENCE imports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.imports_id_seq;
       public       nolan    false    3    223                       0    0    imports_id_seq    SEQUENCE OWNED BY     3   ALTER SEQUENCE imports_id_seq OWNED BY imports.id;
            public       nolan    false    224            �            1259    38451    invites    TABLE     Y  CREATE TABLE invites (
    id bigint NOT NULL,
    user_id bigint,
    code character varying DEFAULT ''::character varying NOT NULL,
    expires_at timestamp without time zone,
    max_uses integer,
    uses integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);
    DROP TABLE public.invites;
       public         nolan    false    3            �            1259    38459    invites_id_seq    SEQUENCE     p   CREATE SEQUENCE invites_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.invites_id_seq;
       public       nolan    false    225    3                       0    0    invites_id_seq    SEQUENCE OWNED BY     3   ALTER SEQUENCE invites_id_seq OWNED BY invites.id;
            public       nolan    false    226            �            1259    38461    list_accounts    TABLE     �   CREATE TABLE list_accounts (
    id bigint NOT NULL,
    list_id bigint NOT NULL,
    account_id bigint NOT NULL,
    follow_id bigint NOT NULL
);
 !   DROP TABLE public.list_accounts;
       public         nolan    false    3            �            1259    38464    list_accounts_id_seq    SEQUENCE     v   CREATE SEQUENCE list_accounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.list_accounts_id_seq;
       public       nolan    false    3    227                       0    0    list_accounts_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE list_accounts_id_seq OWNED BY list_accounts.id;
            public       nolan    false    228            �            1259    38466    lists    TABLE     �   CREATE TABLE lists (
    id bigint NOT NULL,
    account_id bigint NOT NULL,
    title character varying DEFAULT ''::character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);
    DROP TABLE public.lists;
       public         nolan    false    3            �            1259    38473    lists_id_seq    SEQUENCE     n   CREATE SEQUENCE lists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.lists_id_seq;
       public       nolan    false    3    229                       0    0    lists_id_seq    SEQUENCE OWNED BY     /   ALTER SEQUENCE lists_id_seq OWNED BY lists.id;
            public       nolan    false    230            �            1259    38475    media_attachments    TABLE     '  CREATE TABLE media_attachments (
    id bigint NOT NULL,
    status_id bigint,
    file_file_name character varying,
    file_content_type character varying,
    file_file_size integer,
    file_updated_at timestamp without time zone,
    remote_url character varying DEFAULT ''::character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    shortcode character varying,
    type integer DEFAULT 0 NOT NULL,
    file_meta json,
    account_id bigint,
    description text
);
 %   DROP TABLE public.media_attachments;
       public         nolan    false    3            �            1259    38483    media_attachments_id_seq    SEQUENCE     z   CREATE SEQUENCE media_attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.media_attachments_id_seq;
       public       nolan    false    3    231                       0    0    media_attachments_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE media_attachments_id_seq OWNED BY media_attachments.id;
            public       nolan    false    232            �            1259    38485    mentions    TABLE     �   CREATE TABLE mentions (
    id bigint NOT NULL,
    status_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    account_id bigint
);
    DROP TABLE public.mentions;
       public         nolan    false    3            �            1259    38488    mentions_id_seq    SEQUENCE     q   CREATE SEQUENCE mentions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.mentions_id_seq;
       public       nolan    false    3    233                       0    0    mentions_id_seq    SEQUENCE OWNED BY     5   ALTER SEQUENCE mentions_id_seq OWNED BY mentions.id;
            public       nolan    false    234            �            1259    38490    mutes    TABLE       CREATE TABLE mutes (
    id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    account_id bigint NOT NULL,
    target_account_id bigint NOT NULL,
    hide_notifications boolean DEFAULT true NOT NULL
);
    DROP TABLE public.mutes;
       public         nolan    false    3            �            1259    38494    mutes_id_seq    SEQUENCE     n   CREATE SEQUENCE mutes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.mutes_id_seq;
       public       nolan    false    3    235                       0    0    mutes_id_seq    SEQUENCE OWNED BY     /   ALTER SEQUENCE mutes_id_seq OWNED BY mutes.id;
            public       nolan    false    236            �            1259    38496    notifications    TABLE       CREATE TABLE notifications (
    id bigint NOT NULL,
    activity_id bigint,
    activity_type character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    account_id bigint,
    from_account_id bigint
);
 !   DROP TABLE public.notifications;
       public         nolan    false    3            �            1259    38502    notifications_id_seq    SEQUENCE     v   CREATE SEQUENCE notifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.notifications_id_seq;
       public       nolan    false    3    237                       0    0    notifications_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE notifications_id_seq OWNED BY notifications.id;
            public       nolan    false    238            �            1259    38504    oauth_access_grants    TABLE     n  CREATE TABLE oauth_access_grants (
    id bigint NOT NULL,
    token character varying NOT NULL,
    expires_in integer NOT NULL,
    redirect_uri text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    revoked_at timestamp without time zone,
    scopes character varying,
    application_id bigint NOT NULL,
    resource_owner_id bigint NOT NULL
);
 '   DROP TABLE public.oauth_access_grants;
       public         nolan    false    3            �            1259    38510    oauth_access_grants_id_seq    SEQUENCE     |   CREATE SEQUENCE oauth_access_grants_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public.oauth_access_grants_id_seq;
       public       nolan    false    3    239                       0    0    oauth_access_grants_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE oauth_access_grants_id_seq OWNED BY oauth_access_grants.id;
            public       nolan    false    240            �            1259    38512    oauth_access_tokens    TABLE     X  CREATE TABLE oauth_access_tokens (
    id bigint NOT NULL,
    token character varying NOT NULL,
    refresh_token character varying,
    expires_in integer,
    revoked_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    scopes character varying,
    application_id bigint,
    resource_owner_id bigint
);
 '   DROP TABLE public.oauth_access_tokens;
       public         nolan    false    3            �            1259    38518    oauth_access_tokens_id_seq    SEQUENCE     |   CREATE SEQUENCE oauth_access_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public.oauth_access_tokens_id_seq;
       public       nolan    false    3    241                       0    0    oauth_access_tokens_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE oauth_access_tokens_id_seq OWNED BY oauth_access_tokens.id;
            public       nolan    false    242            �            1259    38520    oauth_applications    TABLE     �  CREATE TABLE oauth_applications (
    id bigint NOT NULL,
    name character varying NOT NULL,
    uid character varying NOT NULL,
    secret character varying NOT NULL,
    redirect_uri text NOT NULL,
    scopes character varying DEFAULT ''::character varying NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    superapp boolean DEFAULT false NOT NULL,
    website character varying,
    owner_type character varying,
    owner_id bigint
);
 &   DROP TABLE public.oauth_applications;
       public         nolan    false    3            �            1259    38528    oauth_applications_id_seq    SEQUENCE     {   CREATE SEQUENCE oauth_applications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.oauth_applications_id_seq;
       public       nolan    false    3    243                       0    0    oauth_applications_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE oauth_applications_id_seq OWNED BY oauth_applications.id;
            public       nolan    false    244            �            1259    38530    preview_cards    TABLE       CREATE TABLE preview_cards (
    id bigint NOT NULL,
    url character varying DEFAULT ''::character varying NOT NULL,
    title character varying DEFAULT ''::character varying NOT NULL,
    description character varying DEFAULT ''::character varying NOT NULL,
    image_file_name character varying,
    image_content_type character varying,
    image_file_size integer,
    image_updated_at timestamp without time zone,
    type integer DEFAULT 0 NOT NULL,
    html text DEFAULT ''::text NOT NULL,
    author_name character varying DEFAULT ''::character varying NOT NULL,
    author_url character varying DEFAULT ''::character varying NOT NULL,
    provider_name character varying DEFAULT ''::character varying NOT NULL,
    provider_url character varying DEFAULT ''::character varying NOT NULL,
    width integer DEFAULT 0 NOT NULL,
    height integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    embed_url character varying DEFAULT ''::character varying NOT NULL
);
 !   DROP TABLE public.preview_cards;
       public         nolan    false    3            �            1259    38548    preview_cards_id_seq    SEQUENCE     v   CREATE SEQUENCE preview_cards_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.preview_cards_id_seq;
       public       nolan    false    3    245                       0    0    preview_cards_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE preview_cards_id_seq OWNED BY preview_cards.id;
            public       nolan    false    246            �            1259    38550    preview_cards_statuses    TABLE     l   CREATE TABLE preview_cards_statuses (
    preview_card_id bigint NOT NULL,
    status_id bigint NOT NULL
);
 *   DROP TABLE public.preview_cards_statuses;
       public         nolan    false    3            �            1259    38553    reports    TABLE     �  CREATE TABLE reports (
    id bigint NOT NULL,
    status_ids bigint[] DEFAULT '{}'::bigint[] NOT NULL,
    comment text DEFAULT ''::text NOT NULL,
    action_taken boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    account_id bigint NOT NULL,
    action_taken_by_account_id bigint,
    target_account_id bigint NOT NULL
);
    DROP TABLE public.reports;
       public         nolan    false    3            �            1259    38562    reports_id_seq    SEQUENCE     p   CREATE SEQUENCE reports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.reports_id_seq;
       public       nolan    false    3    248                       0    0    reports_id_seq    SEQUENCE OWNED BY     3   ALTER SEQUENCE reports_id_seq OWNED BY reports.id;
            public       nolan    false    249            �            1259    38564    schema_migrations    TABLE     K   CREATE TABLE schema_migrations (
    version character varying NOT NULL
);
 %   DROP TABLE public.schema_migrations;
       public         nolan    false    3            �            1259    38570    session_activations    TABLE     �  CREATE TABLE session_activations (
    id bigint NOT NULL,
    session_id character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    user_agent character varying DEFAULT ''::character varying NOT NULL,
    ip inet,
    access_token_id bigint,
    user_id bigint NOT NULL,
    web_push_subscription_id bigint
);
 '   DROP TABLE public.session_activations;
       public         nolan    false    3            �            1259    38577    session_activations_id_seq    SEQUENCE     |   CREATE SEQUENCE session_activations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public.session_activations_id_seq;
       public       nolan    false    251    3                       0    0    session_activations_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE session_activations_id_seq OWNED BY session_activations.id;
            public       nolan    false    252            �            1259    38579    settings    TABLE     �   CREATE TABLE settings (
    id bigint NOT NULL,
    var character varying NOT NULL,
    value text,
    thing_type character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    thing_id bigint
);
    DROP TABLE public.settings;
       public         nolan    false    3            �            1259    38585    settings_id_seq    SEQUENCE     q   CREATE SEQUENCE settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.settings_id_seq;
       public       nolan    false    3    253                       0    0    settings_id_seq    SEQUENCE OWNED BY     5   ALTER SEQUENCE settings_id_seq OWNED BY settings.id;
            public       nolan    false    254            �            1259    38587    site_uploads    TABLE     �  CREATE TABLE site_uploads (
    id bigint NOT NULL,
    var character varying DEFAULT ''::character varying NOT NULL,
    file_file_name character varying,
    file_content_type character varying,
    file_file_size integer,
    file_updated_at timestamp without time zone,
    meta json,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);
     DROP TABLE public.site_uploads;
       public         nolan    false    3                        1259    38594    site_uploads_id_seq    SEQUENCE     u   CREATE SEQUENCE site_uploads_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.site_uploads_id_seq;
       public       nolan    false    3    255                       0    0    site_uploads_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE site_uploads_id_seq OWNED BY site_uploads.id;
            public       nolan    false    256                       1259    38596    status_pins    TABLE     �   CREATE TABLE status_pins (
    id bigint NOT NULL,
    account_id bigint NOT NULL,
    status_id bigint NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);
    DROP TABLE public.status_pins;
       public         nolan    false    3                       1259    38601    status_pins_id_seq    SEQUENCE     t   CREATE SEQUENCE status_pins_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.status_pins_id_seq;
       public       nolan    false    3    257                       0    0    status_pins_id_seq    SEQUENCE OWNED BY     ;   ALTER SEQUENCE status_pins_id_seq OWNED BY status_pins.id;
            public       nolan    false    258                       1259    38603    statuses    TABLE       CREATE TABLE statuses (
    id bigint DEFAULT timestamp_id('statuses'::text) NOT NULL,
    uri character varying,
    text text DEFAULT ''::text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    in_reply_to_id bigint,
    reblog_of_id bigint,
    url character varying,
    sensitive boolean DEFAULT false NOT NULL,
    visibility integer DEFAULT 0 NOT NULL,
    spoiler_text text DEFAULT ''::text NOT NULL,
    reply boolean DEFAULT false NOT NULL,
    favourites_count integer DEFAULT 0 NOT NULL,
    reblogs_count integer DEFAULT 0 NOT NULL,
    language character varying,
    conversation_id bigint,
    local boolean,
    account_id bigint NOT NULL,
    application_id bigint,
    in_reply_to_account_id bigint
);
    DROP TABLE public.statuses;
       public         nolan    false    274    3                       1259    38617    statuses_id_seq    SEQUENCE     q   CREATE SEQUENCE statuses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.statuses_id_seq;
       public       nolan    false    3                       1259    38619    statuses_tags    TABLE     Z   CREATE TABLE statuses_tags (
    status_id bigint NOT NULL,
    tag_id bigint NOT NULL
);
 !   DROP TABLE public.statuses_tags;
       public         nolan    false    3                       1259    38622    stream_entries    TABLE     !  CREATE TABLE stream_entries (
    id bigint NOT NULL,
    activity_id bigint,
    activity_type character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    hidden boolean DEFAULT false NOT NULL,
    account_id bigint
);
 "   DROP TABLE public.stream_entries;
       public         nolan    false    3                       1259    38629    stream_entries_id_seq    SEQUENCE     w   CREATE SEQUENCE stream_entries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.stream_entries_id_seq;
       public       nolan    false    3    262                        0    0    stream_entries_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE stream_entries_id_seq OWNED BY stream_entries.id;
            public       nolan    false    263                       1259    38631    subscriptions    TABLE     �  CREATE TABLE subscriptions (
    id bigint NOT NULL,
    callback_url character varying DEFAULT ''::character varying NOT NULL,
    secret character varying,
    expires_at timestamp without time zone,
    confirmed boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    last_successful_delivery_at timestamp without time zone,
    domain character varying,
    account_id bigint NOT NULL
);
 !   DROP TABLE public.subscriptions;
       public         nolan    false    3            	           1259    38639    subscriptions_id_seq    SEQUENCE     v   CREATE SEQUENCE subscriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.subscriptions_id_seq;
       public       nolan    false    3    264            !           0    0    subscriptions_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE subscriptions_id_seq OWNED BY subscriptions.id;
            public       nolan    false    265            
           1259    38641    tags    TABLE     �   CREATE TABLE tags (
    id bigint NOT NULL,
    name character varying DEFAULT ''::character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);
    DROP TABLE public.tags;
       public         nolan    false    3                       1259    38648    tags_id_seq    SEQUENCE     m   CREATE SEQUENCE tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 "   DROP SEQUENCE public.tags_id_seq;
       public       nolan    false    3    266            "           0    0    tags_id_seq    SEQUENCE OWNED BY     -   ALTER SEQUENCE tags_id_seq OWNED BY tags.id;
            public       nolan    false    267                       1259    38650    users    TABLE     �  CREATE TABLE users (
    id bigint NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip inet,
    last_sign_in_ip inet,
    admin boolean DEFAULT false NOT NULL,
    confirmation_token character varying,
    confirmed_at timestamp without time zone,
    confirmation_sent_at timestamp without time zone,
    unconfirmed_email character varying,
    locale character varying,
    encrypted_otp_secret character varying,
    encrypted_otp_secret_iv character varying,
    encrypted_otp_secret_salt character varying,
    consumed_timestep integer,
    otp_required_for_login boolean DEFAULT false NOT NULL,
    last_emailed_at timestamp without time zone,
    otp_backup_codes character varying[],
    filtered_languages character varying[] DEFAULT '{}'::character varying[] NOT NULL,
    account_id bigint NOT NULL,
    disabled boolean DEFAULT false NOT NULL,
    moderator boolean DEFAULT false NOT NULL,
    invite_id bigint
);
    DROP TABLE public.users;
       public         nolan    false    3                       1259    38664    users_id_seq    SEQUENCE     n   CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.users_id_seq;
       public       nolan    false    3    268            #           0    0    users_id_seq    SEQUENCE OWNED BY     /   ALTER SEQUENCE users_id_seq OWNED BY users.id;
            public       nolan    false    269                       1259    38666    web_push_subscriptions    TABLE     6  CREATE TABLE web_push_subscriptions (
    id bigint NOT NULL,
    endpoint character varying NOT NULL,
    key_p256dh character varying NOT NULL,
    key_auth character varying NOT NULL,
    data json,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);
 *   DROP TABLE public.web_push_subscriptions;
       public         nolan    false    3                       1259    38672    web_push_subscriptions_id_seq    SEQUENCE        CREATE SEQUENCE web_push_subscriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 4   DROP SEQUENCE public.web_push_subscriptions_id_seq;
       public       nolan    false    3    270            $           0    0    web_push_subscriptions_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE web_push_subscriptions_id_seq OWNED BY web_push_subscriptions.id;
            public       nolan    false    271                       1259    38674    web_settings    TABLE     �   CREATE TABLE web_settings (
    id bigint NOT NULL,
    data json,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    user_id bigint
);
     DROP TABLE public.web_settings;
       public         nolan    false    3                       1259    38680    web_settings_id_seq    SEQUENCE     u   CREATE SEQUENCE web_settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.web_settings_id_seq;
       public       nolan    false    272    3            %           0    0    web_settings_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE web_settings_id_seq OWNED BY web_settings.id;
            public       nolan    false    273            �	           2604    38682    account_domain_blocks id    DEFAULT     v   ALTER TABLE ONLY account_domain_blocks ALTER COLUMN id SET DEFAULT nextval('account_domain_blocks_id_seq'::regclass);
 G   ALTER TABLE public.account_domain_blocks ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    197    196            �	           2604    38683    account_moderation_notes id    DEFAULT     |   ALTER TABLE ONLY account_moderation_notes ALTER COLUMN id SET DEFAULT nextval('account_moderation_notes_id_seq'::regclass);
 J   ALTER TABLE public.account_moderation_notes ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    199    198            
           2604    38684    accounts id    DEFAULT     \   ALTER TABLE ONLY accounts ALTER COLUMN id SET DEFAULT nextval('accounts_id_seq'::regclass);
 :   ALTER TABLE public.accounts ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    201    200            
           2604    38685    admin_action_logs id    DEFAULT     n   ALTER TABLE ONLY admin_action_logs ALTER COLUMN id SET DEFAULT nextval('admin_action_logs_id_seq'::regclass);
 C   ALTER TABLE public.admin_action_logs ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    203    202            
           2604    38686 	   blocks id    DEFAULT     X   ALTER TABLE ONLY blocks ALTER COLUMN id SET DEFAULT nextval('blocks_id_seq'::regclass);
 8   ALTER TABLE public.blocks ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    206    205            
           2604    38687    conversation_mutes id    DEFAULT     p   ALTER TABLE ONLY conversation_mutes ALTER COLUMN id SET DEFAULT nextval('conversation_mutes_id_seq'::regclass);
 D   ALTER TABLE public.conversation_mutes ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    208    207            
           2604    38688    conversations id    DEFAULT     f   ALTER TABLE ONLY conversations ALTER COLUMN id SET DEFAULT nextval('conversations_id_seq'::regclass);
 ?   ALTER TABLE public.conversations ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    210    209            
           2604    38689    custom_emojis id    DEFAULT     f   ALTER TABLE ONLY custom_emojis ALTER COLUMN id SET DEFAULT nextval('custom_emojis_id_seq'::regclass);
 ?   ALTER TABLE public.custom_emojis ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    212    211            
           2604    38690    domain_blocks id    DEFAULT     f   ALTER TABLE ONLY domain_blocks ALTER COLUMN id SET DEFAULT nextval('domain_blocks_id_seq'::regclass);
 ?   ALTER TABLE public.domain_blocks ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    214    213             
           2604    38691    email_domain_blocks id    DEFAULT     r   ALTER TABLE ONLY email_domain_blocks ALTER COLUMN id SET DEFAULT nextval('email_domain_blocks_id_seq'::regclass);
 E   ALTER TABLE public.email_domain_blocks ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    216    215            !
           2604    38692    favourites id    DEFAULT     `   ALTER TABLE ONLY favourites ALTER COLUMN id SET DEFAULT nextval('favourites_id_seq'::regclass);
 <   ALTER TABLE public.favourites ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    218    217            #
           2604    38693    follow_requests id    DEFAULT     j   ALTER TABLE ONLY follow_requests ALTER COLUMN id SET DEFAULT nextval('follow_requests_id_seq'::regclass);
 A   ALTER TABLE public.follow_requests ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    220    219            %
           2604    38694 
   follows id    DEFAULT     Z   ALTER TABLE ONLY follows ALTER COLUMN id SET DEFAULT nextval('follows_id_seq'::regclass);
 9   ALTER TABLE public.follows ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    222    221            '
           2604    38695 
   imports id    DEFAULT     Z   ALTER TABLE ONLY imports ALTER COLUMN id SET DEFAULT nextval('imports_id_seq'::regclass);
 9   ALTER TABLE public.imports ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    224    223            *
           2604    38696 
   invites id    DEFAULT     Z   ALTER TABLE ONLY invites ALTER COLUMN id SET DEFAULT nextval('invites_id_seq'::regclass);
 9   ALTER TABLE public.invites ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    226    225            +
           2604    38697    list_accounts id    DEFAULT     f   ALTER TABLE ONLY list_accounts ALTER COLUMN id SET DEFAULT nextval('list_accounts_id_seq'::regclass);
 ?   ALTER TABLE public.list_accounts ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    228    227            -
           2604    38698    lists id    DEFAULT     V   ALTER TABLE ONLY lists ALTER COLUMN id SET DEFAULT nextval('lists_id_seq'::regclass);
 7   ALTER TABLE public.lists ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    230    229            0
           2604    38699    media_attachments id    DEFAULT     n   ALTER TABLE ONLY media_attachments ALTER COLUMN id SET DEFAULT nextval('media_attachments_id_seq'::regclass);
 C   ALTER TABLE public.media_attachments ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    232    231            1
           2604    38700    mentions id    DEFAULT     \   ALTER TABLE ONLY mentions ALTER COLUMN id SET DEFAULT nextval('mentions_id_seq'::regclass);
 :   ALTER TABLE public.mentions ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    234    233            3
           2604    38701    mutes id    DEFAULT     V   ALTER TABLE ONLY mutes ALTER COLUMN id SET DEFAULT nextval('mutes_id_seq'::regclass);
 7   ALTER TABLE public.mutes ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    236    235            4
           2604    38702    notifications id    DEFAULT     f   ALTER TABLE ONLY notifications ALTER COLUMN id SET DEFAULT nextval('notifications_id_seq'::regclass);
 ?   ALTER TABLE public.notifications ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    238    237            5
           2604    38703    oauth_access_grants id    DEFAULT     r   ALTER TABLE ONLY oauth_access_grants ALTER COLUMN id SET DEFAULT nextval('oauth_access_grants_id_seq'::regclass);
 E   ALTER TABLE public.oauth_access_grants ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    240    239            6
           2604    38704    oauth_access_tokens id    DEFAULT     r   ALTER TABLE ONLY oauth_access_tokens ALTER COLUMN id SET DEFAULT nextval('oauth_access_tokens_id_seq'::regclass);
 E   ALTER TABLE public.oauth_access_tokens ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    242    241            9
           2604    38705    oauth_applications id    DEFAULT     p   ALTER TABLE ONLY oauth_applications ALTER COLUMN id SET DEFAULT nextval('oauth_applications_id_seq'::regclass);
 D   ALTER TABLE public.oauth_applications ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    244    243            F
           2604    38706    preview_cards id    DEFAULT     f   ALTER TABLE ONLY preview_cards ALTER COLUMN id SET DEFAULT nextval('preview_cards_id_seq'::regclass);
 ?   ALTER TABLE public.preview_cards ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    246    245            J
           2604    38707 
   reports id    DEFAULT     Z   ALTER TABLE ONLY reports ALTER COLUMN id SET DEFAULT nextval('reports_id_seq'::regclass);
 9   ALTER TABLE public.reports ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    249    248            L
           2604    38708    session_activations id    DEFAULT     r   ALTER TABLE ONLY session_activations ALTER COLUMN id SET DEFAULT nextval('session_activations_id_seq'::regclass);
 E   ALTER TABLE public.session_activations ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    252    251            M
           2604    38709    settings id    DEFAULT     \   ALTER TABLE ONLY settings ALTER COLUMN id SET DEFAULT nextval('settings_id_seq'::regclass);
 :   ALTER TABLE public.settings ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    254    253            O
           2604    38710    site_uploads id    DEFAULT     d   ALTER TABLE ONLY site_uploads ALTER COLUMN id SET DEFAULT nextval('site_uploads_id_seq'::regclass);
 >   ALTER TABLE public.site_uploads ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    256    255            R
           2604    38711    status_pins id    DEFAULT     b   ALTER TABLE ONLY status_pins ALTER COLUMN id SET DEFAULT nextval('status_pins_id_seq'::regclass);
 =   ALTER TABLE public.status_pins ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    258    257            \
           2604    38712    stream_entries id    DEFAULT     h   ALTER TABLE ONLY stream_entries ALTER COLUMN id SET DEFAULT nextval('stream_entries_id_seq'::regclass);
 @   ALTER TABLE public.stream_entries ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    263    262            _
           2604    38713    subscriptions id    DEFAULT     f   ALTER TABLE ONLY subscriptions ALTER COLUMN id SET DEFAULT nextval('subscriptions_id_seq'::regclass);
 ?   ALTER TABLE public.subscriptions ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    265    264            a
           2604    38714    tags id    DEFAULT     T   ALTER TABLE ONLY tags ALTER COLUMN id SET DEFAULT nextval('tags_id_seq'::regclass);
 6   ALTER TABLE public.tags ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    267    266            j
           2604    38715    users id    DEFAULT     V   ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);
 7   ALTER TABLE public.users ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    269    268            k
           2604    38716    web_push_subscriptions id    DEFAULT     x   ALTER TABLE ONLY web_push_subscriptions ALTER COLUMN id SET DEFAULT nextval('web_push_subscriptions_id_seq'::regclass);
 H   ALTER TABLE public.web_push_subscriptions ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    271    270            l
           2604    38717    web_settings id    DEFAULT     d   ALTER TABLE ONLY web_settings ALTER COLUMN id SET DEFAULT nextval('web_settings_id_seq'::regclass);
 >   ALTER TABLE public.web_settings ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    273    272            �          0    38314    account_domain_blocks 
   TABLE DATA               X   COPY account_domain_blocks (id, domain, created_at, updated_at, account_id) FROM stdin;
    public       nolan    false    196   ��      �          0    38322    account_moderation_notes 
   TABLE DATA               o   COPY account_moderation_notes (id, content, account_id, target_account_id, created_at, updated_at) FROM stdin;
    public       nolan    false    198   �      �          0    38330    accounts 
   TABLE DATA               E  COPY accounts (id, username, domain, secret, private_key, public_key, remote_url, salmon_url, hub_url, created_at, updated_at, note, display_name, uri, url, avatar_file_name, avatar_content_type, avatar_file_size, avatar_updated_at, header_file_name, header_content_type, header_file_size, header_updated_at, avatar_remote_url, subscription_expires_at, silenced, suspended, locked, header_remote_url, statuses_count, followers_count, following_count, last_webfingered_at, inbox_url, outbox_url, shared_inbox_url, followers_url, protocol, memorial, moved_to_account_id) FROM stdin;
    public       nolan    false    200   !�      �          0    38360    admin_action_logs 
   TABLE DATA               ~   COPY admin_action_logs (id, account_id, action, target_type, target_id, recorded_changes, created_at, updated_at) FROM stdin;
    public       nolan    false    202   G      �          0    38370    ar_internal_metadata 
   TABLE DATA               K   COPY ar_internal_metadata (key, value, created_at, updated_at) FROM stdin;
    public       nolan    false    204   d      �          0    38376    blocks 
   TABLE DATA               T   COPY blocks (id, created_at, updated_at, account_id, target_account_id) FROM stdin;
    public       nolan    false    205   �      �          0    38381    conversation_mutes 
   TABLE DATA               F   COPY conversation_mutes (id, conversation_id, account_id) FROM stdin;
    public       nolan    false    207   �      �          0    38386    conversations 
   TABLE DATA               A   COPY conversations (id, uri, created_at, updated_at) FROM stdin;
    public       nolan    false    209   �      �          0    38394    custom_emojis 
   TABLE DATA               �   COPY custom_emojis (id, shortcode, domain, image_file_name, image_content_type, image_file_size, image_updated_at, created_at, updated_at, disabled, uri, image_remote_url, visible_in_picker) FROM stdin;
    public       nolan    false    211   7      �          0    38405    domain_blocks 
   TABLE DATA               \   COPY domain_blocks (id, domain, created_at, updated_at, severity, reject_media) FROM stdin;
    public       nolan    false    213   T      �          0    38416    email_domain_blocks 
   TABLE DATA               J   COPY email_domain_blocks (id, domain, created_at, updated_at) FROM stdin;
    public       nolan    false    215   q      �          0    38425 
   favourites 
   TABLE DATA               P   COPY favourites (id, created_at, updated_at, account_id, status_id) FROM stdin;
    public       nolan    false    217   �      �          0    38430    follow_requests 
   TABLE DATA               k   COPY follow_requests (id, created_at, updated_at, account_id, target_account_id, show_reblogs) FROM stdin;
    public       nolan    false    219   �      �          0    38436    follows 
   TABLE DATA               c   COPY follows (id, created_at, updated_at, account_id, target_account_id, show_reblogs) FROM stdin;
    public       nolan    false    221   �      �          0    38442    imports 
   TABLE DATA               �   COPY imports (id, type, approved, created_at, updated_at, data_file_name, data_content_type, data_file_size, data_updated_at, account_id) FROM stdin;
    public       nolan    false    223   :      �          0    38451    invites 
   TABLE DATA               a   COPY invites (id, user_id, code, expires_at, max_uses, uses, created_at, updated_at) FROM stdin;
    public       nolan    false    225   W      �          0    38461    list_accounts 
   TABLE DATA               D   COPY list_accounts (id, list_id, account_id, follow_id) FROM stdin;
    public       nolan    false    227   t      �          0    38466    lists 
   TABLE DATA               G   COPY lists (id, account_id, title, created_at, updated_at) FROM stdin;
    public       nolan    false    229   �      �          0    38475    media_attachments 
   TABLE DATA               �   COPY media_attachments (id, status_id, file_file_name, file_content_type, file_file_size, file_updated_at, remote_url, created_at, updated_at, shortcode, type, file_meta, account_id, description) FROM stdin;
    public       nolan    false    231   �      �          0    38485    mentions 
   TABLE DATA               N   COPY mentions (id, status_id, created_at, updated_at, account_id) FROM stdin;
    public       nolan    false    233   Z      �          0    38490    mutes 
   TABLE DATA               g   COPY mutes (id, created_at, updated_at, account_id, target_account_id, hide_notifications) FROM stdin;
    public       nolan    false    235   �      �          0    38496    notifications 
   TABLE DATA               u   COPY notifications (id, activity_id, activity_type, created_at, updated_at, account_id, from_account_id) FROM stdin;
    public       nolan    false    237   �      �          0    38504    oauth_access_grants 
   TABLE DATA               �   COPY oauth_access_grants (id, token, expires_in, redirect_uri, created_at, revoked_at, scopes, application_id, resource_owner_id) FROM stdin;
    public       nolan    false    239   �      �          0    38512    oauth_access_tokens 
   TABLE DATA               �   COPY oauth_access_tokens (id, token, refresh_token, expires_in, revoked_at, created_at, scopes, application_id, resource_owner_id) FROM stdin;
    public       nolan    false    241   S2      �          0    38520    oauth_applications 
   TABLE DATA               �   COPY oauth_applications (id, name, uid, secret, redirect_uri, scopes, created_at, updated_at, superapp, website, owner_type, owner_id) FROM stdin;
    public       nolan    false    243   �P      �          0    38530    preview_cards 
   TABLE DATA               �   COPY preview_cards (id, url, title, description, image_file_name, image_content_type, image_file_size, image_updated_at, type, html, author_name, author_url, provider_name, provider_url, width, height, created_at, updated_at, embed_url) FROM stdin;
    public       nolan    false    245   N�      �          0    38550    preview_cards_statuses 
   TABLE DATA               E   COPY preview_cards_statuses (preview_card_id, status_id) FROM stdin;
    public       nolan    false    247   k�      �          0    38553    reports 
   TABLE DATA               �   COPY reports (id, status_ids, comment, action_taken, created_at, updated_at, account_id, action_taken_by_account_id, target_account_id) FROM stdin;
    public       nolan    false    248   ��      �          0    38564    schema_migrations 
   TABLE DATA               -   COPY schema_migrations (version) FROM stdin;
    public       nolan    false    250   ��      �          0    38570    session_activations 
   TABLE DATA               �   COPY session_activations (id, session_id, created_at, updated_at, user_agent, ip, access_token_id, user_id, web_push_subscription_id) FROM stdin;
    public       nolan    false    251   ��      �          0    38579    settings 
   TABLE DATA               Y   COPY settings (id, var, value, thing_type, created_at, updated_at, thing_id) FROM stdin;
    public       nolan    false    253   ��      �          0    38587    site_uploads 
   TABLE DATA               �   COPY site_uploads (id, var, file_file_name, file_content_type, file_file_size, file_updated_at, meta, created_at, updated_at) FROM stdin;
    public       nolan    false    255   ��      �          0    38596    status_pins 
   TABLE DATA               Q   COPY status_pins (id, account_id, status_id, created_at, updated_at) FROM stdin;
    public       nolan    false    257   ��      �          0    38603    statuses 
   TABLE DATA                 COPY statuses (id, uri, text, created_at, updated_at, in_reply_to_id, reblog_of_id, url, sensitive, visibility, spoiler_text, reply, favourites_count, reblogs_count, language, conversation_id, local, account_id, application_id, in_reply_to_account_id) FROM stdin;
    public       nolan    false    259   �      �          0    38619    statuses_tags 
   TABLE DATA               3   COPY statuses_tags (status_id, tag_id) FROM stdin;
    public       nolan    false    261   ��      �          0    38622    stream_entries 
   TABLE DATA               m   COPY stream_entries (id, activity_id, activity_type, created_at, updated_at, hidden, account_id) FROM stdin;
    public       nolan    false    262   �      �          0    38631    subscriptions 
   TABLE DATA               �   COPY subscriptions (id, callback_url, secret, expires_at, confirmed, created_at, updated_at, last_successful_delivery_at, domain, account_id) FROM stdin;
    public       nolan    false    264   ��      �          0    38641    tags 
   TABLE DATA               9   COPY tags (id, name, created_at, updated_at) FROM stdin;
    public       nolan    false    266   �      �          0    38650    users 
   TABLE DATA                 COPY users (id, email, created_at, updated_at, encrypted_password, reset_password_token, reset_password_sent_at, remember_created_at, sign_in_count, current_sign_in_at, last_sign_in_at, current_sign_in_ip, last_sign_in_ip, admin, confirmation_token, confirmed_at, confirmation_sent_at, unconfirmed_email, locale, encrypted_otp_secret, encrypted_otp_secret_iv, encrypted_otp_secret_salt, consumed_timestep, otp_required_for_login, last_emailed_at, otp_backup_codes, filtered_languages, account_id, disabled, moderator, invite_id) FROM stdin;
    public       nolan    false    268   4�      �          0    38666    web_push_subscriptions 
   TABLE DATA               k   COPY web_push_subscriptions (id, endpoint, key_p256dh, key_auth, data, created_at, updated_at) FROM stdin;
    public       nolan    false    270   �      �          0    38674    web_settings 
   TABLE DATA               J   COPY web_settings (id, data, created_at, updated_at, user_id) FROM stdin;
    public       nolan    false    272   :�      &           0    0    account_domain_blocks_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('account_domain_blocks_id_seq', 1, false);
            public       nolan    false    197            '           0    0    account_moderation_notes_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('account_moderation_notes_id_seq', 1, false);
            public       nolan    false    199            (           0    0    accounts_id_seq    SEQUENCE SET     6   SELECT pg_catalog.setval('accounts_id_seq', 3, true);
            public       nolan    false    201            )           0    0    admin_action_logs_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('admin_action_logs_id_seq', 1, false);
            public       nolan    false    203            *           0    0    blocks_id_seq    SEQUENCE SET     5   SELECT pg_catalog.setval('blocks_id_seq', 1, false);
            public       nolan    false    206            +           0    0    conversation_mutes_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('conversation_mutes_id_seq', 1, false);
            public       nolan    false    208            ,           0    0    conversations_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('conversations_id_seq', 46, true);
            public       nolan    false    210            -           0    0    custom_emojis_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('custom_emojis_id_seq', 1, false);
            public       nolan    false    212            .           0    0    domain_blocks_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('domain_blocks_id_seq', 1, false);
            public       nolan    false    214            /           0    0    email_domain_blocks_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('email_domain_blocks_id_seq', 1, false);
            public       nolan    false    216            0           0    0    favourites_id_seq    SEQUENCE SET     9   SELECT pg_catalog.setval('favourites_id_seq', 1, false);
            public       nolan    false    218            1           0    0    follow_requests_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('follow_requests_id_seq', 1, false);
            public       nolan    false    220            2           0    0    follows_id_seq    SEQUENCE SET     5   SELECT pg_catalog.setval('follows_id_seq', 4, true);
            public       nolan    false    222            3           0    0    imports_id_seq    SEQUENCE SET     6   SELECT pg_catalog.setval('imports_id_seq', 1, false);
            public       nolan    false    224            4           0    0    invites_id_seq    SEQUENCE SET     6   SELECT pg_catalog.setval('invites_id_seq', 1, false);
            public       nolan    false    226            5           0    0    list_accounts_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('list_accounts_id_seq', 1, false);
            public       nolan    false    228            6           0    0    lists_id_seq    SEQUENCE SET     4   SELECT pg_catalog.setval('lists_id_seq', 1, false);
            public       nolan    false    230            7           0    0    media_attachments_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('media_attachments_id_seq', 9, true);
            public       nolan    false    232            8           0    0    mentions_id_seq    SEQUENCE SET     6   SELECT pg_catalog.setval('mentions_id_seq', 3, true);
            public       nolan    false    234            9           0    0    mutes_id_seq    SEQUENCE SET     4   SELECT pg_catalog.setval('mutes_id_seq', 1, false);
            public       nolan    false    236            :           0    0    notifications_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('notifications_id_seq', 7, true);
            public       nolan    false    238            ;           0    0    oauth_access_grants_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('oauth_access_grants_id_seq', 134, true);
            public       nolan    false    240            <           0    0    oauth_access_tokens_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('oauth_access_tokens_id_seq', 286, true);
            public       nolan    false    242            =           0    0    oauth_applications_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('oauth_applications_id_seq', 169, true);
            public       nolan    false    244            >           0    0    preview_cards_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('preview_cards_id_seq', 1, false);
            public       nolan    false    246            ?           0    0    reports_id_seq    SEQUENCE SET     6   SELECT pg_catalog.setval('reports_id_seq', 1, false);
            public       nolan    false    249            @           0    0    session_activations_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('session_activations_id_seq', 154, true);
            public       nolan    false    252            A           0    0    settings_id_seq    SEQUENCE SET     7   SELECT pg_catalog.setval('settings_id_seq', 1, false);
            public       nolan    false    254            B           0    0    site_uploads_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('site_uploads_id_seq', 1, false);
            public       nolan    false    256            C           0    0    status_pins_id_seq    SEQUENCE SET     9   SELECT pg_catalog.setval('status_pins_id_seq', 2, true);
            public       nolan    false    258            D           0    0    statuses_id_seq    SEQUENCE SET     7   SELECT pg_catalog.setval('statuses_id_seq', 72, true);
            public       nolan    false    260            E           0    0    stream_entries_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('stream_entries_id_seq', 72, true);
            public       nolan    false    263            F           0    0    subscriptions_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('subscriptions_id_seq', 1, false);
            public       nolan    false    265            G           0    0    tags_id_seq    SEQUENCE SET     3   SELECT pg_catalog.setval('tags_id_seq', 1, false);
            public       nolan    false    267            H           0    0    users_id_seq    SEQUENCE SET     3   SELECT pg_catalog.setval('users_id_seq', 3, true);
            public       nolan    false    269            I           0    0    web_push_subscriptions_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('web_push_subscriptions_id_seq', 1, false);
            public       nolan    false    271            J           0    0    web_settings_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('web_settings_id_seq', 3, true);
            public       nolan    false    273            n
           2606    38721 0   account_domain_blocks account_domain_blocks_pkey 
   CONSTRAINT     g   ALTER TABLE ONLY account_domain_blocks
    ADD CONSTRAINT account_domain_blocks_pkey PRIMARY KEY (id);
 Z   ALTER TABLE ONLY public.account_domain_blocks DROP CONSTRAINT account_domain_blocks_pkey;
       public         nolan    false    196            q
           2606    38723 6   account_moderation_notes account_moderation_notes_pkey 
   CONSTRAINT     m   ALTER TABLE ONLY account_moderation_notes
    ADD CONSTRAINT account_moderation_notes_pkey PRIMARY KEY (id);
 `   ALTER TABLE ONLY public.account_moderation_notes DROP CONSTRAINT account_moderation_notes_pkey;
       public         nolan    false    198            u
           2606    38725    accounts accounts_pkey 
   CONSTRAINT     M   ALTER TABLE ONLY accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.accounts DROP CONSTRAINT accounts_pkey;
       public         nolan    false    200            |
           2606    38727 (   admin_action_logs admin_action_logs_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY admin_action_logs
    ADD CONSTRAINT admin_action_logs_pkey PRIMARY KEY (id);
 R   ALTER TABLE ONLY public.admin_action_logs DROP CONSTRAINT admin_action_logs_pkey;
       public         nolan    false    202            �
           2606    38729 .   ar_internal_metadata ar_internal_metadata_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);
 X   ALTER TABLE ONLY public.ar_internal_metadata DROP CONSTRAINT ar_internal_metadata_pkey;
       public         nolan    false    204            �
           2606    38731    blocks blocks_pkey 
   CONSTRAINT     I   ALTER TABLE ONLY blocks
    ADD CONSTRAINT blocks_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.blocks DROP CONSTRAINT blocks_pkey;
       public         nolan    false    205            �
           2606    38733 *   conversation_mutes conversation_mutes_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY conversation_mutes
    ADD CONSTRAINT conversation_mutes_pkey PRIMARY KEY (id);
 T   ALTER TABLE ONLY public.conversation_mutes DROP CONSTRAINT conversation_mutes_pkey;
       public         nolan    false    207            �
           2606    38735     conversations conversations_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY conversations
    ADD CONSTRAINT conversations_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.conversations DROP CONSTRAINT conversations_pkey;
       public         nolan    false    209            �
           2606    38737     custom_emojis custom_emojis_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY custom_emojis
    ADD CONSTRAINT custom_emojis_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.custom_emojis DROP CONSTRAINT custom_emojis_pkey;
       public         nolan    false    211            �
           2606    38739     domain_blocks domain_blocks_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY domain_blocks
    ADD CONSTRAINT domain_blocks_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.domain_blocks DROP CONSTRAINT domain_blocks_pkey;
       public         nolan    false    213            �
           2606    38741 ,   email_domain_blocks email_domain_blocks_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY email_domain_blocks
    ADD CONSTRAINT email_domain_blocks_pkey PRIMARY KEY (id);
 V   ALTER TABLE ONLY public.email_domain_blocks DROP CONSTRAINT email_domain_blocks_pkey;
       public         nolan    false    215            �
           2606    38743    favourites favourites_pkey 
   CONSTRAINT     Q   ALTER TABLE ONLY favourites
    ADD CONSTRAINT favourites_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.favourites DROP CONSTRAINT favourites_pkey;
       public         nolan    false    217            �
           2606    38745 $   follow_requests follow_requests_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY follow_requests
    ADD CONSTRAINT follow_requests_pkey PRIMARY KEY (id);
 N   ALTER TABLE ONLY public.follow_requests DROP CONSTRAINT follow_requests_pkey;
       public         nolan    false    219            �
           2606    38747    follows follows_pkey 
   CONSTRAINT     K   ALTER TABLE ONLY follows
    ADD CONSTRAINT follows_pkey PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.follows DROP CONSTRAINT follows_pkey;
       public         nolan    false    221            �
           2606    38749    imports imports_pkey 
   CONSTRAINT     K   ALTER TABLE ONLY imports
    ADD CONSTRAINT imports_pkey PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.imports DROP CONSTRAINT imports_pkey;
       public         nolan    false    223            �
           2606    38751    invites invites_pkey 
   CONSTRAINT     K   ALTER TABLE ONLY invites
    ADD CONSTRAINT invites_pkey PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.invites DROP CONSTRAINT invites_pkey;
       public         nolan    false    225            �
           2606    38753     list_accounts list_accounts_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY list_accounts
    ADD CONSTRAINT list_accounts_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.list_accounts DROP CONSTRAINT list_accounts_pkey;
       public         nolan    false    227            �
           2606    38755    lists lists_pkey 
   CONSTRAINT     G   ALTER TABLE ONLY lists
    ADD CONSTRAINT lists_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.lists DROP CONSTRAINT lists_pkey;
       public         nolan    false    229            �
           2606    38757 (   media_attachments media_attachments_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY media_attachments
    ADD CONSTRAINT media_attachments_pkey PRIMARY KEY (id);
 R   ALTER TABLE ONLY public.media_attachments DROP CONSTRAINT media_attachments_pkey;
       public         nolan    false    231            �
           2606    38759    mentions mentions_pkey 
   CONSTRAINT     M   ALTER TABLE ONLY mentions
    ADD CONSTRAINT mentions_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.mentions DROP CONSTRAINT mentions_pkey;
       public         nolan    false    233            �
           2606    38761    mutes mutes_pkey 
   CONSTRAINT     G   ALTER TABLE ONLY mutes
    ADD CONSTRAINT mutes_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.mutes DROP CONSTRAINT mutes_pkey;
       public         nolan    false    235            �
           2606    38763     notifications notifications_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.notifications DROP CONSTRAINT notifications_pkey;
       public         nolan    false    237            �
           2606    38765 ,   oauth_access_grants oauth_access_grants_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY oauth_access_grants
    ADD CONSTRAINT oauth_access_grants_pkey PRIMARY KEY (id);
 V   ALTER TABLE ONLY public.oauth_access_grants DROP CONSTRAINT oauth_access_grants_pkey;
       public         nolan    false    239            �
           2606    38767 ,   oauth_access_tokens oauth_access_tokens_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY oauth_access_tokens
    ADD CONSTRAINT oauth_access_tokens_pkey PRIMARY KEY (id);
 V   ALTER TABLE ONLY public.oauth_access_tokens DROP CONSTRAINT oauth_access_tokens_pkey;
       public         nolan    false    241            �
           2606    38769 *   oauth_applications oauth_applications_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY oauth_applications
    ADD CONSTRAINT oauth_applications_pkey PRIMARY KEY (id);
 T   ALTER TABLE ONLY public.oauth_applications DROP CONSTRAINT oauth_applications_pkey;
       public         nolan    false    243            �
           2606    38771     preview_cards preview_cards_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY preview_cards
    ADD CONSTRAINT preview_cards_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.preview_cards DROP CONSTRAINT preview_cards_pkey;
       public         nolan    false    245            �
           2606    38773    reports reports_pkey 
   CONSTRAINT     K   ALTER TABLE ONLY reports
    ADD CONSTRAINT reports_pkey PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.reports DROP CONSTRAINT reports_pkey;
       public         nolan    false    248            �
           2606    38775 (   schema_migrations schema_migrations_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);
 R   ALTER TABLE ONLY public.schema_migrations DROP CONSTRAINT schema_migrations_pkey;
       public         nolan    false    250            �
           2606    38777 ,   session_activations session_activations_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY session_activations
    ADD CONSTRAINT session_activations_pkey PRIMARY KEY (id);
 V   ALTER TABLE ONLY public.session_activations DROP CONSTRAINT session_activations_pkey;
       public         nolan    false    251            �
           2606    38779    settings settings_pkey 
   CONSTRAINT     M   ALTER TABLE ONLY settings
    ADD CONSTRAINT settings_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.settings DROP CONSTRAINT settings_pkey;
       public         nolan    false    253            �
           2606    38781    site_uploads site_uploads_pkey 
   CONSTRAINT     U   ALTER TABLE ONLY site_uploads
    ADD CONSTRAINT site_uploads_pkey PRIMARY KEY (id);
 H   ALTER TABLE ONLY public.site_uploads DROP CONSTRAINT site_uploads_pkey;
       public         nolan    false    255            �
           2606    38783    status_pins status_pins_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY status_pins
    ADD CONSTRAINT status_pins_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.status_pins DROP CONSTRAINT status_pins_pkey;
       public         nolan    false    257            �
           2606    38785    statuses statuses_pkey 
   CONSTRAINT     M   ALTER TABLE ONLY statuses
    ADD CONSTRAINT statuses_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.statuses DROP CONSTRAINT statuses_pkey;
       public         nolan    false    259            �
           2606    38787 "   stream_entries stream_entries_pkey 
   CONSTRAINT     Y   ALTER TABLE ONLY stream_entries
    ADD CONSTRAINT stream_entries_pkey PRIMARY KEY (id);
 L   ALTER TABLE ONLY public.stream_entries DROP CONSTRAINT stream_entries_pkey;
       public         nolan    false    262            �
           2606    38789     subscriptions subscriptions_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY subscriptions
    ADD CONSTRAINT subscriptions_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.subscriptions DROP CONSTRAINT subscriptions_pkey;
       public         nolan    false    264            �
           2606    38791    tags tags_pkey 
   CONSTRAINT     E   ALTER TABLE ONLY tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);
 8   ALTER TABLE ONLY public.tags DROP CONSTRAINT tags_pkey;
       public         nolan    false    266            �
           2606    38793    users users_pkey 
   CONSTRAINT     G   ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public         nolan    false    268            �
           2606    38795 2   web_push_subscriptions web_push_subscriptions_pkey 
   CONSTRAINT     i   ALTER TABLE ONLY web_push_subscriptions
    ADD CONSTRAINT web_push_subscriptions_pkey PRIMARY KEY (id);
 \   ALTER TABLE ONLY public.web_push_subscriptions DROP CONSTRAINT web_push_subscriptions_pkey;
       public         nolan    false    270            �
           2606    38797    web_settings web_settings_pkey 
   CONSTRAINT     U   ALTER TABLE ONLY web_settings
    ADD CONSTRAINT web_settings_pkey PRIMARY KEY (id);
 H   ALTER TABLE ONLY public.web_settings DROP CONSTRAINT web_settings_pkey;
       public         nolan    false    272            �
           1259    38798    account_activity    INDEX     l   CREATE UNIQUE INDEX account_activity ON notifications USING btree (account_id, activity_id, activity_type);
 $   DROP INDEX public.account_activity;
       public         nolan    false    237    237    237            �
           1259    38799    hashtag_search_index    INDEX     ^   CREATE INDEX hashtag_search_index ON tags USING btree (lower((name)::text) text_pattern_ops);
 (   DROP INDEX public.hashtag_search_index;
       public         nolan    false    266    266            o
           1259    38800 4   index_account_domain_blocks_on_account_id_and_domain    INDEX     �   CREATE UNIQUE INDEX index_account_domain_blocks_on_account_id_and_domain ON account_domain_blocks USING btree (account_id, domain);
 H   DROP INDEX public.index_account_domain_blocks_on_account_id_and_domain;
       public         nolan    false    196    196            r
           1259    38801 ,   index_account_moderation_notes_on_account_id    INDEX     p   CREATE INDEX index_account_moderation_notes_on_account_id ON account_moderation_notes USING btree (account_id);
 @   DROP INDEX public.index_account_moderation_notes_on_account_id;
       public         nolan    false    198            s
           1259    38802 3   index_account_moderation_notes_on_target_account_id    INDEX     ~   CREATE INDEX index_account_moderation_notes_on_target_account_id ON account_moderation_notes USING btree (target_account_id);
 G   DROP INDEX public.index_account_moderation_notes_on_target_account_id;
       public         nolan    false    198            v
           1259    38803    index_accounts_on_uri    INDEX     B   CREATE INDEX index_accounts_on_uri ON accounts USING btree (uri);
 )   DROP INDEX public.index_accounts_on_uri;
       public         nolan    false    200            w
           1259    38804    index_accounts_on_url    INDEX     B   CREATE INDEX index_accounts_on_url ON accounts USING btree (url);
 )   DROP INDEX public.index_accounts_on_url;
       public         nolan    false    200            x
           1259    38805 %   index_accounts_on_username_and_domain    INDEX     f   CREATE UNIQUE INDEX index_accounts_on_username_and_domain ON accounts USING btree (username, domain);
 9   DROP INDEX public.index_accounts_on_username_and_domain;
       public         nolan    false    200    200            y
           1259    38806 +   index_accounts_on_username_and_domain_lower    INDEX     �   CREATE INDEX index_accounts_on_username_and_domain_lower ON accounts USING btree (lower((username)::text), lower((domain)::text));
 ?   DROP INDEX public.index_accounts_on_username_and_domain_lower;
       public         nolan    false    200    200    200            }
           1259    38807 %   index_admin_action_logs_on_account_id    INDEX     b   CREATE INDEX index_admin_action_logs_on_account_id ON admin_action_logs USING btree (account_id);
 9   DROP INDEX public.index_admin_action_logs_on_account_id;
       public         nolan    false    202            ~
           1259    38808 4   index_admin_action_logs_on_target_type_and_target_id    INDEX     }   CREATE INDEX index_admin_action_logs_on_target_type_and_target_id ON admin_action_logs USING btree (target_type, target_id);
 H   DROP INDEX public.index_admin_action_logs_on_target_type_and_target_id;
       public         nolan    false    202    202            �
           1259    38809 0   index_blocks_on_account_id_and_target_account_id    INDEX     |   CREATE UNIQUE INDEX index_blocks_on_account_id_and_target_account_id ON blocks USING btree (account_id, target_account_id);
 D   DROP INDEX public.index_blocks_on_account_id_and_target_account_id;
       public         nolan    false    205    205            �
           1259    38810 :   index_conversation_mutes_on_account_id_and_conversation_id    INDEX     �   CREATE UNIQUE INDEX index_conversation_mutes_on_account_id_and_conversation_id ON conversation_mutes USING btree (account_id, conversation_id);
 N   DROP INDEX public.index_conversation_mutes_on_account_id_and_conversation_id;
       public         nolan    false    207    207            �
           1259    38811    index_conversations_on_uri    INDEX     S   CREATE UNIQUE INDEX index_conversations_on_uri ON conversations USING btree (uri);
 .   DROP INDEX public.index_conversations_on_uri;
       public         nolan    false    209            �
           1259    38812 +   index_custom_emojis_on_shortcode_and_domain    INDEX     r   CREATE UNIQUE INDEX index_custom_emojis_on_shortcode_and_domain ON custom_emojis USING btree (shortcode, domain);
 ?   DROP INDEX public.index_custom_emojis_on_shortcode_and_domain;
       public         nolan    false    211    211            �
           1259    38813    index_domain_blocks_on_domain    INDEX     Y   CREATE UNIQUE INDEX index_domain_blocks_on_domain ON domain_blocks USING btree (domain);
 1   DROP INDEX public.index_domain_blocks_on_domain;
       public         nolan    false    213            �
           1259    38814 #   index_email_domain_blocks_on_domain    INDEX     e   CREATE UNIQUE INDEX index_email_domain_blocks_on_domain ON email_domain_blocks USING btree (domain);
 7   DROP INDEX public.index_email_domain_blocks_on_domain;
       public         nolan    false    215            �
           1259    38815 %   index_favourites_on_account_id_and_id    INDEX     _   CREATE INDEX index_favourites_on_account_id_and_id ON favourites USING btree (account_id, id);
 9   DROP INDEX public.index_favourites_on_account_id_and_id;
       public         nolan    false    217    217            �
           1259    38816 ,   index_favourites_on_account_id_and_status_id    INDEX     t   CREATE UNIQUE INDEX index_favourites_on_account_id_and_status_id ON favourites USING btree (account_id, status_id);
 @   DROP INDEX public.index_favourites_on_account_id_and_status_id;
       public         nolan    false    217    217            �
           1259    38817    index_favourites_on_status_id    INDEX     R   CREATE INDEX index_favourites_on_status_id ON favourites USING btree (status_id);
 1   DROP INDEX public.index_favourites_on_status_id;
       public         nolan    false    217            �
           1259    38818 9   index_follow_requests_on_account_id_and_target_account_id    INDEX     �   CREATE UNIQUE INDEX index_follow_requests_on_account_id_and_target_account_id ON follow_requests USING btree (account_id, target_account_id);
 M   DROP INDEX public.index_follow_requests_on_account_id_and_target_account_id;
       public         nolan    false    219    219            �
           1259    38819 1   index_follows_on_account_id_and_target_account_id    INDEX     ~   CREATE UNIQUE INDEX index_follows_on_account_id_and_target_account_id ON follows USING btree (account_id, target_account_id);
 E   DROP INDEX public.index_follows_on_account_id_and_target_account_id;
       public         nolan    false    221    221            �
           1259    38820    index_invites_on_code    INDEX     I   CREATE UNIQUE INDEX index_invites_on_code ON invites USING btree (code);
 )   DROP INDEX public.index_invites_on_code;
       public         nolan    false    225            �
           1259    38821    index_invites_on_user_id    INDEX     H   CREATE INDEX index_invites_on_user_id ON invites USING btree (user_id);
 ,   DROP INDEX public.index_invites_on_user_id;
       public         nolan    false    225            �
           1259    38822 -   index_list_accounts_on_account_id_and_list_id    INDEX     v   CREATE UNIQUE INDEX index_list_accounts_on_account_id_and_list_id ON list_accounts USING btree (account_id, list_id);
 A   DROP INDEX public.index_list_accounts_on_account_id_and_list_id;
       public         nolan    false    227    227            �
           1259    38823     index_list_accounts_on_follow_id    INDEX     X   CREATE INDEX index_list_accounts_on_follow_id ON list_accounts USING btree (follow_id);
 4   DROP INDEX public.index_list_accounts_on_follow_id;
       public         nolan    false    227            �
           1259    38824 -   index_list_accounts_on_list_id_and_account_id    INDEX     o   CREATE INDEX index_list_accounts_on_list_id_and_account_id ON list_accounts USING btree (list_id, account_id);
 A   DROP INDEX public.index_list_accounts_on_list_id_and_account_id;
       public         nolan    false    227    227            �
           1259    38825    index_lists_on_account_id    INDEX     J   CREATE INDEX index_lists_on_account_id ON lists USING btree (account_id);
 -   DROP INDEX public.index_lists_on_account_id;
       public         nolan    false    229            �
           1259    38826 %   index_media_attachments_on_account_id    INDEX     b   CREATE INDEX index_media_attachments_on_account_id ON media_attachments USING btree (account_id);
 9   DROP INDEX public.index_media_attachments_on_account_id;
       public         nolan    false    231            �
           1259    38827 $   index_media_attachments_on_shortcode    INDEX     g   CREATE UNIQUE INDEX index_media_attachments_on_shortcode ON media_attachments USING btree (shortcode);
 8   DROP INDEX public.index_media_attachments_on_shortcode;
       public         nolan    false    231            �
           1259    38828 $   index_media_attachments_on_status_id    INDEX     `   CREATE INDEX index_media_attachments_on_status_id ON media_attachments USING btree (status_id);
 8   DROP INDEX public.index_media_attachments_on_status_id;
       public         nolan    false    231            �
           1259    38829 *   index_mentions_on_account_id_and_status_id    INDEX     p   CREATE UNIQUE INDEX index_mentions_on_account_id_and_status_id ON mentions USING btree (account_id, status_id);
 >   DROP INDEX public.index_mentions_on_account_id_and_status_id;
       public         nolan    false    233    233            �
           1259    38830    index_mentions_on_status_id    INDEX     N   CREATE INDEX index_mentions_on_status_id ON mentions USING btree (status_id);
 /   DROP INDEX public.index_mentions_on_status_id;
       public         nolan    false    233            �
           1259    38831 /   index_mutes_on_account_id_and_target_account_id    INDEX     z   CREATE UNIQUE INDEX index_mutes_on_account_id_and_target_account_id ON mutes USING btree (account_id, target_account_id);
 C   DROP INDEX public.index_mutes_on_account_id_and_target_account_id;
       public         nolan    false    235    235            �
           1259    38832 (   index_notifications_on_account_id_and_id    INDEX     j   CREATE INDEX index_notifications_on_account_id_and_id ON notifications USING btree (account_id, id DESC);
 <   DROP INDEX public.index_notifications_on_account_id_and_id;
       public         nolan    false    237    237            �
           1259    38833 4   index_notifications_on_activity_id_and_activity_type    INDEX     }   CREATE INDEX index_notifications_on_activity_id_and_activity_type ON notifications USING btree (activity_id, activity_type);
 H   DROP INDEX public.index_notifications_on_activity_id_and_activity_type;
       public         nolan    false    237    237            �
           1259    38834 "   index_oauth_access_grants_on_token    INDEX     c   CREATE UNIQUE INDEX index_oauth_access_grants_on_token ON oauth_access_grants USING btree (token);
 6   DROP INDEX public.index_oauth_access_grants_on_token;
       public         nolan    false    239            �
           1259    38835 *   index_oauth_access_tokens_on_refresh_token    INDEX     s   CREATE UNIQUE INDEX index_oauth_access_tokens_on_refresh_token ON oauth_access_tokens USING btree (refresh_token);
 >   DROP INDEX public.index_oauth_access_tokens_on_refresh_token;
       public         nolan    false    241            �
           1259    38836 .   index_oauth_access_tokens_on_resource_owner_id    INDEX     t   CREATE INDEX index_oauth_access_tokens_on_resource_owner_id ON oauth_access_tokens USING btree (resource_owner_id);
 B   DROP INDEX public.index_oauth_access_tokens_on_resource_owner_id;
       public         nolan    false    241            �
           1259    38837 "   index_oauth_access_tokens_on_token    INDEX     c   CREATE UNIQUE INDEX index_oauth_access_tokens_on_token ON oauth_access_tokens USING btree (token);
 6   DROP INDEX public.index_oauth_access_tokens_on_token;
       public         nolan    false    241            �
           1259    38838 3   index_oauth_applications_on_owner_id_and_owner_type    INDEX     {   CREATE INDEX index_oauth_applications_on_owner_id_and_owner_type ON oauth_applications USING btree (owner_id, owner_type);
 G   DROP INDEX public.index_oauth_applications_on_owner_id_and_owner_type;
       public         nolan    false    243    243            �
           1259    38839    index_oauth_applications_on_uid    INDEX     ]   CREATE UNIQUE INDEX index_oauth_applications_on_uid ON oauth_applications USING btree (uid);
 3   DROP INDEX public.index_oauth_applications_on_uid;
       public         nolan    false    243            �
           1259    38840    index_preview_cards_on_url    INDEX     S   CREATE UNIQUE INDEX index_preview_cards_on_url ON preview_cards USING btree (url);
 .   DROP INDEX public.index_preview_cards_on_url;
       public         nolan    false    245            �
           1259    38841 =   index_preview_cards_statuses_on_status_id_and_preview_card_id    INDEX     �   CREATE INDEX index_preview_cards_statuses_on_status_id_and_preview_card_id ON preview_cards_statuses USING btree (status_id, preview_card_id);
 Q   DROP INDEX public.index_preview_cards_statuses_on_status_id_and_preview_card_id;
       public         nolan    false    247    247            �
           1259    38842    index_reports_on_account_id    INDEX     N   CREATE INDEX index_reports_on_account_id ON reports USING btree (account_id);
 /   DROP INDEX public.index_reports_on_account_id;
       public         nolan    false    248            �
           1259    38843 "   index_reports_on_target_account_id    INDEX     \   CREATE INDEX index_reports_on_target_account_id ON reports USING btree (target_account_id);
 6   DROP INDEX public.index_reports_on_target_account_id;
       public         nolan    false    248            �
           1259    38844 '   index_session_activations_on_session_id    INDEX     m   CREATE UNIQUE INDEX index_session_activations_on_session_id ON session_activations USING btree (session_id);
 ;   DROP INDEX public.index_session_activations_on_session_id;
       public         nolan    false    251            �
           1259    38845 $   index_session_activations_on_user_id    INDEX     `   CREATE INDEX index_session_activations_on_user_id ON session_activations USING btree (user_id);
 8   DROP INDEX public.index_session_activations_on_user_id;
       public         nolan    false    251            �
           1259    38846 1   index_settings_on_thing_type_and_thing_id_and_var    INDEX     {   CREATE UNIQUE INDEX index_settings_on_thing_type_and_thing_id_and_var ON settings USING btree (thing_type, thing_id, var);
 E   DROP INDEX public.index_settings_on_thing_type_and_thing_id_and_var;
       public         nolan    false    253    253    253            �
           1259    38847    index_site_uploads_on_var    INDEX     Q   CREATE UNIQUE INDEX index_site_uploads_on_var ON site_uploads USING btree (var);
 -   DROP INDEX public.index_site_uploads_on_var;
       public         nolan    false    255            �
           1259    38848 -   index_status_pins_on_account_id_and_status_id    INDEX     v   CREATE UNIQUE INDEX index_status_pins_on_account_id_and_status_id ON status_pins USING btree (account_id, status_id);
 A   DROP INDEX public.index_status_pins_on_account_id_and_status_id;
       public         nolan    false    257    257            �
           1259    38849    index_statuses_20180106    INDEX     l   CREATE INDEX index_statuses_20180106 ON statuses USING btree (account_id, id DESC, visibility, updated_at);
 +   DROP INDEX public.index_statuses_20180106;
       public         nolan    false    259    259    259    259            �
           1259    38850 !   index_statuses_on_conversation_id    INDEX     Z   CREATE INDEX index_statuses_on_conversation_id ON statuses USING btree (conversation_id);
 5   DROP INDEX public.index_statuses_on_conversation_id;
       public         nolan    false    259            �
           1259    38851     index_statuses_on_in_reply_to_id    INDEX     X   CREATE INDEX index_statuses_on_in_reply_to_id ON statuses USING btree (in_reply_to_id);
 4   DROP INDEX public.index_statuses_on_in_reply_to_id;
       public         nolan    false    259            �
           1259    38852 -   index_statuses_on_reblog_of_id_and_account_id    INDEX     o   CREATE INDEX index_statuses_on_reblog_of_id_and_account_id ON statuses USING btree (reblog_of_id, account_id);
 A   DROP INDEX public.index_statuses_on_reblog_of_id_and_account_id;
       public         nolan    false    259    259            �
           1259    38853    index_statuses_on_uri    INDEX     I   CREATE UNIQUE INDEX index_statuses_on_uri ON statuses USING btree (uri);
 )   DROP INDEX public.index_statuses_on_uri;
       public         nolan    false    259            �
           1259    38854     index_statuses_tags_on_status_id    INDEX     X   CREATE INDEX index_statuses_tags_on_status_id ON statuses_tags USING btree (status_id);
 4   DROP INDEX public.index_statuses_tags_on_status_id;
       public         nolan    false    261            �
           1259    38855 +   index_statuses_tags_on_tag_id_and_status_id    INDEX     r   CREATE UNIQUE INDEX index_statuses_tags_on_tag_id_and_status_id ON statuses_tags USING btree (tag_id, status_id);
 ?   DROP INDEX public.index_statuses_tags_on_tag_id_and_status_id;
       public         nolan    false    261    261            �
           1259    38856 ;   index_stream_entries_on_account_id_and_activity_type_and_id    INDEX     �   CREATE INDEX index_stream_entries_on_account_id_and_activity_type_and_id ON stream_entries USING btree (account_id, activity_type, id);
 O   DROP INDEX public.index_stream_entries_on_account_id_and_activity_type_and_id;
       public         nolan    false    262    262    262            �
           1259    38857 5   index_stream_entries_on_activity_id_and_activity_type    INDEX        CREATE INDEX index_stream_entries_on_activity_id_and_activity_type ON stream_entries USING btree (activity_id, activity_type);
 I   DROP INDEX public.index_stream_entries_on_activity_id_and_activity_type;
       public         nolan    false    262    262            �
           1259    38858 2   index_subscriptions_on_account_id_and_callback_url    INDEX     �   CREATE UNIQUE INDEX index_subscriptions_on_account_id_and_callback_url ON subscriptions USING btree (account_id, callback_url);
 F   DROP INDEX public.index_subscriptions_on_account_id_and_callback_url;
       public         nolan    false    264    264            �
           1259    38859    index_tags_on_name    INDEX     C   CREATE UNIQUE INDEX index_tags_on_name ON tags USING btree (name);
 &   DROP INDEX public.index_tags_on_name;
       public         nolan    false    266            �
           1259    38860    index_users_on_account_id    INDEX     J   CREATE INDEX index_users_on_account_id ON users USING btree (account_id);
 -   DROP INDEX public.index_users_on_account_id;
       public         nolan    false    268            �
           1259    38861 !   index_users_on_confirmation_token    INDEX     a   CREATE UNIQUE INDEX index_users_on_confirmation_token ON users USING btree (confirmation_token);
 5   DROP INDEX public.index_users_on_confirmation_token;
       public         nolan    false    268            �
           1259    38862    index_users_on_email    INDEX     G   CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);
 (   DROP INDEX public.index_users_on_email;
       public         nolan    false    268            �
           1259    38863 !   index_users_on_filtered_languages    INDEX     X   CREATE INDEX index_users_on_filtered_languages ON users USING gin (filtered_languages);
 5   DROP INDEX public.index_users_on_filtered_languages;
       public         nolan    false    268            �
           1259    38864 #   index_users_on_reset_password_token    INDEX     e   CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);
 7   DROP INDEX public.index_users_on_reset_password_token;
       public         nolan    false    268            �
           1259    38865    index_web_settings_on_user_id    INDEX     Y   CREATE UNIQUE INDEX index_web_settings_on_user_id ON web_settings USING btree (user_id);
 1   DROP INDEX public.index_web_settings_on_user_id;
       public         nolan    false    272            z
           1259    38866    search_index    INDEX     C  CREATE INDEX search_index ON accounts USING gin ((((setweight(to_tsvector('simple'::regconfig, (display_name)::text), 'A'::"char") || setweight(to_tsvector('simple'::regconfig, (username)::text), 'B'::"char")) || setweight(to_tsvector('simple'::regconfig, (COALESCE(domain, ''::character varying))::text), 'C'::"char"))));
     DROP INDEX public.search_index;
       public         nolan    false    200    200    200    200            3           2606    38867    web_settings fk_11910667b2    FK CONSTRAINT     }   ALTER TABLE ONLY web_settings
    ADD CONSTRAINT fk_11910667b2 FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;
 D   ALTER TABLE ONLY public.web_settings DROP CONSTRAINT fk_11910667b2;
       public       nolan    false    2810    272    268                        2606    38872 #   account_domain_blocks fk_206c6029bd    FK CONSTRAINT     �   ALTER TABLE ONLY account_domain_blocks
    ADD CONSTRAINT fk_206c6029bd FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 M   ALTER TABLE ONLY public.account_domain_blocks DROP CONSTRAINT fk_206c6029bd;
       public       nolan    false    2677    200    196                       2606    38877     conversation_mutes fk_225b4212bb    FK CONSTRAINT     �   ALTER TABLE ONLY conversation_mutes
    ADD CONSTRAINT fk_225b4212bb FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 J   ALTER TABLE ONLY public.conversation_mutes DROP CONSTRAINT fk_225b4212bb;
       public       nolan    false    207    200    2677            -           2606    38882    statuses_tags fk_3081861e21    FK CONSTRAINT     |   ALTER TABLE ONLY statuses_tags
    ADD CONSTRAINT fk_3081861e21 FOREIGN KEY (tag_id) REFERENCES tags(id) ON DELETE CASCADE;
 E   ALTER TABLE ONLY public.statuses_tags DROP CONSTRAINT fk_3081861e21;
       public       nolan    false    261    266    2803                       2606    38887    follows fk_32ed1b5560    FK CONSTRAINT     ~   ALTER TABLE ONLY follows
    ADD CONSTRAINT fk_32ed1b5560 FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 ?   ALTER TABLE ONLY public.follows DROP CONSTRAINT fk_32ed1b5560;
       public       nolan    false    221    200    2677                       2606    38892 !   oauth_access_grants fk_34d54b0a33    FK CONSTRAINT     �   ALTER TABLE ONLY oauth_access_grants
    ADD CONSTRAINT fk_34d54b0a33 FOREIGN KEY (application_id) REFERENCES oauth_applications(id) ON DELETE CASCADE;
 K   ALTER TABLE ONLY public.oauth_access_grants DROP CONSTRAINT fk_34d54b0a33;
       public       nolan    false    239    243    2760                       2606    38897    blocks fk_4269e03e65    FK CONSTRAINT     }   ALTER TABLE ONLY blocks
    ADD CONSTRAINT fk_4269e03e65 FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 >   ALTER TABLE ONLY public.blocks DROP CONSTRAINT fk_4269e03e65;
       public       nolan    false    200    205    2677            "           2606    38902    reports fk_4b81f7522c    FK CONSTRAINT     ~   ALTER TABLE ONLY reports
    ADD CONSTRAINT fk_4b81f7522c FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 ?   ALTER TABLE ONLY public.reports DROP CONSTRAINT fk_4b81f7522c;
       public       nolan    false    248    2677    200            1           2606    38907    users fk_50500f500d    FK CONSTRAINT     |   ALTER TABLE ONLY users
    ADD CONSTRAINT fk_50500f500d FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 =   ALTER TABLE ONLY public.users DROP CONSTRAINT fk_50500f500d;
       public       nolan    false    268    2677    200            /           2606    38912    stream_entries fk_5659b17554    FK CONSTRAINT     �   ALTER TABLE ONLY stream_entries
    ADD CONSTRAINT fk_5659b17554 FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 F   ALTER TABLE ONLY public.stream_entries DROP CONSTRAINT fk_5659b17554;
       public       nolan    false    2677    200    262            	           2606    38917    favourites fk_5eb6c2b873    FK CONSTRAINT     �   ALTER TABLE ONLY favourites
    ADD CONSTRAINT fk_5eb6c2b873 FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 B   ALTER TABLE ONLY public.favourites DROP CONSTRAINT fk_5eb6c2b873;
       public       nolan    false    2677    217    200                       2606    38922 !   oauth_access_grants fk_63b044929b    FK CONSTRAINT     �   ALTER TABLE ONLY oauth_access_grants
    ADD CONSTRAINT fk_63b044929b FOREIGN KEY (resource_owner_id) REFERENCES users(id) ON DELETE CASCADE;
 K   ALTER TABLE ONLY public.oauth_access_grants DROP CONSTRAINT fk_63b044929b;
       public       nolan    false    268    239    2810                       2606    38927    imports fk_6db1b6e408    FK CONSTRAINT     ~   ALTER TABLE ONLY imports
    ADD CONSTRAINT fk_6db1b6e408 FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 ?   ALTER TABLE ONLY public.imports DROP CONSTRAINT fk_6db1b6e408;
       public       nolan    false    223    200    2677                       2606    38932    follows fk_745ca29eac    FK CONSTRAINT     �   ALTER TABLE ONLY follows
    ADD CONSTRAINT fk_745ca29eac FOREIGN KEY (target_account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 ?   ALTER TABLE ONLY public.follows DROP CONSTRAINT fk_745ca29eac;
       public       nolan    false    200    221    2677                       2606    38937    follow_requests fk_76d644b0e7    FK CONSTRAINT     �   ALTER TABLE ONLY follow_requests
    ADD CONSTRAINT fk_76d644b0e7 FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 G   ALTER TABLE ONLY public.follow_requests DROP CONSTRAINT fk_76d644b0e7;
       public       nolan    false    219    200    2677                       2606    38942    follow_requests fk_9291ec025d    FK CONSTRAINT     �   ALTER TABLE ONLY follow_requests
    ADD CONSTRAINT fk_9291ec025d FOREIGN KEY (target_account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 G   ALTER TABLE ONLY public.follow_requests DROP CONSTRAINT fk_9291ec025d;
       public       nolan    false    219    200    2677                       2606    38947    blocks fk_9571bfabc1    FK CONSTRAINT     �   ALTER TABLE ONLY blocks
    ADD CONSTRAINT fk_9571bfabc1 FOREIGN KEY (target_account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 >   ALTER TABLE ONLY public.blocks DROP CONSTRAINT fk_9571bfabc1;
       public       nolan    false    200    205    2677            %           2606    38952 !   session_activations fk_957e5bda89    FK CONSTRAINT     �   ALTER TABLE ONLY session_activations
    ADD CONSTRAINT fk_957e5bda89 FOREIGN KEY (access_token_id) REFERENCES oauth_access_tokens(id) ON DELETE CASCADE;
 K   ALTER TABLE ONLY public.session_activations DROP CONSTRAINT fk_957e5bda89;
       public       nolan    false    251    241    2756                       2606    38957    media_attachments fk_96dd81e81b    FK CONSTRAINT     �   ALTER TABLE ONLY media_attachments
    ADD CONSTRAINT fk_96dd81e81b FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE SET NULL;
 I   ALTER TABLE ONLY public.media_attachments DROP CONSTRAINT fk_96dd81e81b;
       public       nolan    false    231    2677    200                       2606    38962    mentions fk_970d43f9d1    FK CONSTRAINT        ALTER TABLE ONLY mentions
    ADD CONSTRAINT fk_970d43f9d1 FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 @   ALTER TABLE ONLY public.mentions DROP CONSTRAINT fk_970d43f9d1;
       public       nolan    false    200    233    2677            0           2606    38967    subscriptions fk_9847d1cbb5    FK CONSTRAINT     �   ALTER TABLE ONLY subscriptions
    ADD CONSTRAINT fk_9847d1cbb5 FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 E   ALTER TABLE ONLY public.subscriptions DROP CONSTRAINT fk_9847d1cbb5;
       public       nolan    false    2677    200    264            )           2606    38972    statuses fk_9bda1543f7    FK CONSTRAINT        ALTER TABLE ONLY statuses
    ADD CONSTRAINT fk_9bda1543f7 FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 @   ALTER TABLE ONLY public.statuses DROP CONSTRAINT fk_9bda1543f7;
       public       nolan    false    259    2677    200            !           2606    38977     oauth_applications fk_b0988c7c0a    FK CONSTRAINT     �   ALTER TABLE ONLY oauth_applications
    ADD CONSTRAINT fk_b0988c7c0a FOREIGN KEY (owner_id) REFERENCES users(id) ON DELETE CASCADE;
 J   ALTER TABLE ONLY public.oauth_applications DROP CONSTRAINT fk_b0988c7c0a;
       public       nolan    false    268    243    2810            
           2606    38982    favourites fk_b0e856845e    FK CONSTRAINT     �   ALTER TABLE ONLY favourites
    ADD CONSTRAINT fk_b0e856845e FOREIGN KEY (status_id) REFERENCES statuses(id) ON DELETE CASCADE;
 B   ALTER TABLE ONLY public.favourites DROP CONSTRAINT fk_b0e856845e;
       public       nolan    false    2790    217    259                       2606    38987    mutes fk_b8d8daf315    FK CONSTRAINT     |   ALTER TABLE ONLY mutes
    ADD CONSTRAINT fk_b8d8daf315 FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 =   ALTER TABLE ONLY public.mutes DROP CONSTRAINT fk_b8d8daf315;
       public       nolan    false    200    235    2677            #           2606    38992    reports fk_bca45b75fd    FK CONSTRAINT     �   ALTER TABLE ONLY reports
    ADD CONSTRAINT fk_bca45b75fd FOREIGN KEY (action_taken_by_account_id) REFERENCES accounts(id) ON DELETE SET NULL;
 ?   ALTER TABLE ONLY public.reports DROP CONSTRAINT fk_bca45b75fd;
       public       nolan    false    200    248    2677                       2606    38997    notifications fk_c141c8ee55    FK CONSTRAINT     �   ALTER TABLE ONLY notifications
    ADD CONSTRAINT fk_c141c8ee55 FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 E   ALTER TABLE ONLY public.notifications DROP CONSTRAINT fk_c141c8ee55;
       public       nolan    false    2677    200    237            *           2606    39002    statuses fk_c7fa917661    FK CONSTRAINT     �   ALTER TABLE ONLY statuses
    ADD CONSTRAINT fk_c7fa917661 FOREIGN KEY (in_reply_to_account_id) REFERENCES accounts(id) ON DELETE SET NULL;
 @   ALTER TABLE ONLY public.statuses DROP CONSTRAINT fk_c7fa917661;
       public       nolan    false    200    259    2677            '           2606    39007    status_pins fk_d4cb435b62    FK CONSTRAINT     �   ALTER TABLE ONLY status_pins
    ADD CONSTRAINT fk_d4cb435b62 FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 C   ALTER TABLE ONLY public.status_pins DROP CONSTRAINT fk_d4cb435b62;
       public       nolan    false    257    2677    200            &           2606    39012 !   session_activations fk_e5fda67334    FK CONSTRAINT     �   ALTER TABLE ONLY session_activations
    ADD CONSTRAINT fk_e5fda67334 FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;
 K   ALTER TABLE ONLY public.session_activations DROP CONSTRAINT fk_e5fda67334;
       public       nolan    false    268    2810    251                       2606    39017 !   oauth_access_tokens fk_e84df68546    FK CONSTRAINT     �   ALTER TABLE ONLY oauth_access_tokens
    ADD CONSTRAINT fk_e84df68546 FOREIGN KEY (resource_owner_id) REFERENCES users(id) ON DELETE CASCADE;
 K   ALTER TABLE ONLY public.oauth_access_tokens DROP CONSTRAINT fk_e84df68546;
       public       nolan    false    268    241    2810            $           2606    39022    reports fk_eb37af34f0    FK CONSTRAINT     �   ALTER TABLE ONLY reports
    ADD CONSTRAINT fk_eb37af34f0 FOREIGN KEY (target_account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 ?   ALTER TABLE ONLY public.reports DROP CONSTRAINT fk_eb37af34f0;
       public       nolan    false    248    2677    200                       2606    39027    mutes fk_eecff219ea    FK CONSTRAINT     �   ALTER TABLE ONLY mutes
    ADD CONSTRAINT fk_eecff219ea FOREIGN KEY (target_account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 =   ALTER TABLE ONLY public.mutes DROP CONSTRAINT fk_eecff219ea;
       public       nolan    false    200    235    2677                        2606    39032 !   oauth_access_tokens fk_f5fc4c1ee3    FK CONSTRAINT     �   ALTER TABLE ONLY oauth_access_tokens
    ADD CONSTRAINT fk_f5fc4c1ee3 FOREIGN KEY (application_id) REFERENCES oauth_applications(id) ON DELETE CASCADE;
 K   ALTER TABLE ONLY public.oauth_access_tokens DROP CONSTRAINT fk_f5fc4c1ee3;
       public       nolan    false    241    2760    243                       2606    39037    notifications fk_fbd6b0bf9e    FK CONSTRAINT     �   ALTER TABLE ONLY notifications
    ADD CONSTRAINT fk_fbd6b0bf9e FOREIGN KEY (from_account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 E   ALTER TABLE ONLY public.notifications DROP CONSTRAINT fk_fbd6b0bf9e;
       public       nolan    false    200    2677    237                       2606    39042    accounts fk_rails_2320833084    FK CONSTRAINT     �   ALTER TABLE ONLY accounts
    ADD CONSTRAINT fk_rails_2320833084 FOREIGN KEY (moved_to_account_id) REFERENCES accounts(id) ON DELETE SET NULL;
 F   ALTER TABLE ONLY public.accounts DROP CONSTRAINT fk_rails_2320833084;
       public       nolan    false    2677    200    200            +           2606    39047    statuses fk_rails_256483a9ab    FK CONSTRAINT     �   ALTER TABLE ONLY statuses
    ADD CONSTRAINT fk_rails_256483a9ab FOREIGN KEY (reblog_of_id) REFERENCES statuses(id) ON DELETE CASCADE;
 F   ALTER TABLE ONLY public.statuses DROP CONSTRAINT fk_rails_256483a9ab;
       public       nolan    false    259    259    2790                       2606    39052    lists fk_rails_3853b78dac    FK CONSTRAINT     �   ALTER TABLE ONLY lists
    ADD CONSTRAINT fk_rails_3853b78dac FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 C   ALTER TABLE ONLY public.lists DROP CONSTRAINT fk_rails_3853b78dac;
       public       nolan    false    200    2677    229                       2606    39057 %   media_attachments fk_rails_3ec0cfdd70    FK CONSTRAINT     �   ALTER TABLE ONLY media_attachments
    ADD CONSTRAINT fk_rails_3ec0cfdd70 FOREIGN KEY (status_id) REFERENCES statuses(id) ON DELETE SET NULL;
 O   ALTER TABLE ONLY public.media_attachments DROP CONSTRAINT fk_rails_3ec0cfdd70;
       public       nolan    false    259    2790    231                       2606    39062 ,   account_moderation_notes fk_rails_3f8b75089b    FK CONSTRAINT     �   ALTER TABLE ONLY account_moderation_notes
    ADD CONSTRAINT fk_rails_3f8b75089b FOREIGN KEY (account_id) REFERENCES accounts(id);
 V   ALTER TABLE ONLY public.account_moderation_notes DROP CONSTRAINT fk_rails_3f8b75089b;
       public       nolan    false    200    2677    198                       2606    39067 !   list_accounts fk_rails_40f9cc29f1    FK CONSTRAINT     �   ALTER TABLE ONLY list_accounts
    ADD CONSTRAINT fk_rails_40f9cc29f1 FOREIGN KEY (follow_id) REFERENCES follows(id) ON DELETE CASCADE;
 K   ALTER TABLE ONLY public.list_accounts DROP CONSTRAINT fk_rails_40f9cc29f1;
       public       nolan    false    227    221    2716                       2606    39072    mentions fk_rails_59edbe2887    FK CONSTRAINT     �   ALTER TABLE ONLY mentions
    ADD CONSTRAINT fk_rails_59edbe2887 FOREIGN KEY (status_id) REFERENCES statuses(id) ON DELETE CASCADE;
 F   ALTER TABLE ONLY public.mentions DROP CONSTRAINT fk_rails_59edbe2887;
       public       nolan    false    2790    259    233                       2606    39077 &   conversation_mutes fk_rails_5ab139311f    FK CONSTRAINT     �   ALTER TABLE ONLY conversation_mutes
    ADD CONSTRAINT fk_rails_5ab139311f FOREIGN KEY (conversation_id) REFERENCES conversations(id) ON DELETE CASCADE;
 P   ALTER TABLE ONLY public.conversation_mutes DROP CONSTRAINT fk_rails_5ab139311f;
       public       nolan    false    2696    209    207            (           2606    39082    status_pins fk_rails_65c05552f1    FK CONSTRAINT     �   ALTER TABLE ONLY status_pins
    ADD CONSTRAINT fk_rails_65c05552f1 FOREIGN KEY (status_id) REFERENCES statuses(id) ON DELETE CASCADE;
 I   ALTER TABLE ONLY public.status_pins DROP CONSTRAINT fk_rails_65c05552f1;
       public       nolan    false    257    259    2790                       2606    39087 !   list_accounts fk_rails_85fee9d6ab    FK CONSTRAINT     �   ALTER TABLE ONLY list_accounts
    ADD CONSTRAINT fk_rails_85fee9d6ab FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 K   ALTER TABLE ONLY public.list_accounts DROP CONSTRAINT fk_rails_85fee9d6ab;
       public       nolan    false    2677    227    200            2           2606    39092    users fk_rails_8fb2a43e88    FK CONSTRAINT     �   ALTER TABLE ONLY users
    ADD CONSTRAINT fk_rails_8fb2a43e88 FOREIGN KEY (invite_id) REFERENCES invites(id) ON DELETE SET NULL;
 C   ALTER TABLE ONLY public.users DROP CONSTRAINT fk_rails_8fb2a43e88;
       public       nolan    false    268    2723    225            ,           2606    39097    statuses fk_rails_94a6f70399    FK CONSTRAINT     �   ALTER TABLE ONLY statuses
    ADD CONSTRAINT fk_rails_94a6f70399 FOREIGN KEY (in_reply_to_id) REFERENCES statuses(id) ON DELETE SET NULL;
 F   ALTER TABLE ONLY public.statuses DROP CONSTRAINT fk_rails_94a6f70399;
       public       nolan    false    259    259    2790                       2606    39102 %   admin_action_logs fk_rails_a7667297fa    FK CONSTRAINT     �   ALTER TABLE ONLY admin_action_logs
    ADD CONSTRAINT fk_rails_a7667297fa FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 O   ALTER TABLE ONLY public.admin_action_logs DROP CONSTRAINT fk_rails_a7667297fa;
       public       nolan    false    2677    200    202                       2606    39107 ,   account_moderation_notes fk_rails_dd62ed5ac3    FK CONSTRAINT     �   ALTER TABLE ONLY account_moderation_notes
    ADD CONSTRAINT fk_rails_dd62ed5ac3 FOREIGN KEY (target_account_id) REFERENCES accounts(id);
 V   ALTER TABLE ONLY public.account_moderation_notes DROP CONSTRAINT fk_rails_dd62ed5ac3;
       public       nolan    false    200    198    2677            .           2606    39112 !   statuses_tags fk_rails_df0fe11427    FK CONSTRAINT     �   ALTER TABLE ONLY statuses_tags
    ADD CONSTRAINT fk_rails_df0fe11427 FOREIGN KEY (status_id) REFERENCES statuses(id) ON DELETE CASCADE;
 K   ALTER TABLE ONLY public.statuses_tags DROP CONSTRAINT fk_rails_df0fe11427;
       public       nolan    false    2790    259    261                       2606    39117 !   list_accounts fk_rails_e54e356c88    FK CONSTRAINT     �   ALTER TABLE ONLY list_accounts
    ADD CONSTRAINT fk_rails_e54e356c88 FOREIGN KEY (list_id) REFERENCES lists(id) ON DELETE CASCADE;
 K   ALTER TABLE ONLY public.list_accounts DROP CONSTRAINT fk_rails_e54e356c88;
       public       nolan    false    2731    229    227                       2606    39122    invites fk_rails_ff69dbb2ac    FK CONSTRAINT     ~   ALTER TABLE ONLY invites
    ADD CONSTRAINT fk_rails_ff69dbb2ac FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;
 E   ALTER TABLE ONLY public.invites DROP CONSTRAINT fk_rails_ff69dbb2ac;
       public       nolan    false    225    2810    268            �      x������ � �      �      x������ � �      �      x���ǲ�H���=E�n�����#�0���ރ��ꯙ����6��JA��<�|_"��;i���K���o��e�W˦}X�v�_�|�s��i������;K�<=�a������rd1��z���)�t<��cϩ�P�z߀���@�ۖ� �J-�b��v�s|C[��ԫ��8�oJd�eVgy�_]�N�ҘC�,:���>
�\��L݊r�
�2k=J�q���v@�S�o�����xu4HĊUa������������ʔ���{�Sԝ6�*��^2?Ւ�����m�=m	�q��(R�6P���S�A��� %h���%�]6>�U����&��a��w��m纷�L�����%*XL�}pT4e�6i����` �V�X���{��<�g����,�Y9q�I��,%�[��!��n>/�84�x�k�\g��� H�Co1MSBq�`��֗Y�띰ɺ@�[���<����ΫI&|��k��v��(�vզ�+'�c=��׳P���k�e���9�w��ա�s"`��P���� e� d|$����C{���{c����Ѫ��q��M�dsǭo�'�ݍOkڟ���#�폶�-9~L#�k��tq���Y��|��K��8HT%�g󀧑{U�n�sBG��:�ӡ褘�t&.d-J�=��wZ1����i����ͬ��"��`�ԡ�r��>�$���R��c8wBpۼ1@4Ew���I�Qp��BQwW�'��l�ᬕh��-t���:�O�ׇz�ɟ1 ���Y�w������g�&��v���vR�>V`*��d�=�Й&'H�:�J�LL�����ecX���ъ�;�x����V
)|@/����Z -��&bk����D���j���h9� K��ƃ�q1T9|�6@N��x
�5ݰ��h��g�
[?5{uC4���,cA�8Sx�+ş�3Ky߷��N)���q8��� p��"�H�۫� �;qz���r}jA���w\F���xfѶ�}��p���n6�Kѷ��궜��c��f���re9~�Lκ<&So���ӮRz��J�0�y:N{Ц�:�^�k�&8x�0E���9ݜ�-.<�
a�V��5��)Q������i�v��#��-��$^���I����VSG�:?�n$]�­�?�|D:������4l	�m`*�U�^�н�Њ��(���imj�r�E%��}�~���Ғ���������U�~f��`��Mp@̩��q�P�]�����j�s֘���R�9G��m�.���*���G<F�ۡ4�e���S�p�"afd��C>����ʁ���u��@�Ϙz��*���P�\�:��cQ�"����TM�H��y6����V���C�+���w�����w�����w�����w�u�����O'�O���������0���S� �䕝q9������
�@~�?����K����}�������0r����u}xu�hs'���+ ]K���tx%(�c��ꞟ�A��>B��� �t?�bV�#Ʊ۩�cT� ���[��k��V ��x�:ݚ�⎉�"�r��p5wf���T��p�2tWợi���G��$��M�#7,2����R2��f��=y�e�|۳�;� d��{��n{�����*n�L��q'�TC����Û:��P�VB���7��?	T����F�6�ܒ�鮬�
�e���� <H��ZႭH��3Ea����0�e#�d�(���սAv%�7_\��Ț���G�J�'o�m�n#C��k{��$M`�>�J�թ���������y%]����&��%
T�;�,��n����4
V�W��B���C�hb�.��X72��9��ṯ��~��)0�q�@�Ɗ_݇;XoԞ�"��?� SM칾�2Ώ��=�b߼Y��.���I�m[���e� i�I�����	���c�rӺg�T��NgVX��kx�2�Ɗ��b��nVy9�v�>����;���1F����6hǞ��O�75��{g���X�$�� /���S�i�:/�p�p^ܧ��i�d�s�x<};�=�@OM噇'�ǲ��:�0�7��/�͝Y>.aj4�s��2}nB
��|��n�V���=�1����T������$M�/�d�L�Jv�<R9��#�ŋH9b�gy+�mE%��Լ�N�W�=��:�u*�}ƿ7��c���"٦:h��>u8�:�2��cw��sv�+'��f*4���[$�Ԧt�R���Aޞ~�#P�n>���$_u��A�#<QH��W�JC��H<����߁2Y�XcoP��,f䩍h�B@�QW�� &^�S�bݹ�&��w�A���An��qn���G�h�q!����Ԓ�sv��s�:M�,d� �*��8�h��͇�5hciȍ��hVߓtZ� �wb�N��>*��Z0��_��<3�CQ%~��%�ў}��P�Cr��-W�}�2;�=v���X��j�)Q^�!YL� �}�������~קyZ�r`Dxz�G�m������4���=�.��[zWƨv����B�w��d���C\�,j��q/���{e\��INX�%�C�O�x+�ح�U�p*�����L�����f Iq`�A|VxG�l�z��:�]���"������[��;����I��FO{{RT�����|���:��_ߡ׫��_ߡ׫��_ߡ�u���_ߡ׫��_ߡ׫�_~�5�A�� ��Aa���_0����u����?��4���[�=:��,)fde؈�Ñ����IZ-��q0�n]��f���
�a$��Xg��""D-Y�j��a�g d�n.�)X{u��>���o!UAr	p
��������{����gǜ��'����0H��������x)+�!��V��(g�O�H�s!*�ѧ�Zg7ȹ�{�ܟN����W���:V��vJ�Hn��`���@�eb�Yüf�!�����UGb� �S�)�".ZW�1���8K��پ�}�,S�(J�]���>����Ō�K,�����l�CZ���MТ������J,�H.��T�3�}��ΣK���;1�Y�\�hE�-��|���v�&c/��nQ�?�HUjZ��GU�	��� �K@�dKܷb�ՑYk߻���np��8IӥW�G�����/=
��+ػN�#tN�ު��\wc������t:f�p�@�J��P&��J�P+��c�����$&[��"�꼬T��2,�Km䑐��;V��q����@�o9�w���5�P�d5A�W�����G7
�t��C O�����0�Y��DE ��0g��6��lY��H������vUx�nﻆB��N2^��4ۑ#A]���[2�7P��C�:�bk���+yu'�����Υ���:��l���-Q�y6�MJ+ڎ;�f�x��W>�9<�Aehnt���RJ�!�W���|�έ� L��75N	�9x���[�HP��Ua�Y1O�t�i��.�k:�� ,�K|���fS}�Ǜ,zu}��3�8P�=p��`l28{<����������T���-\\q�Av�6_��#�2�_e<����|��&��2���=��0�Q���ތ�{S����f��"N�16�x:z��B�B�`2��D�vd����Sm�9Qg������H*@�:�=z۫���Cw�9���!�����x2�S��}�r��r�Q��q��g^lut� -ӳ.H�,u�}�Ū�ؤz�aҠ��S�j���U%�n���%����+�Z��g:oqN�����my+���ʻ�Y5�;�,.k�:�.�Q_e`[E��J����?��I�:�j���`��?��ۃ�Էxݬ&��U���!mUM6압I�O��`ܽȕ�feDg��˴?�ƙWu��.��g��2RY#S�g�X@�ݶ�a3<���0t����}��.B|�������=þC�W�þC���`�w��b�wv��_}�C�
A�a�o(�w�"�?��?O��A�K    x���>�����/�����      �      x������ � �      �   ?   x�K�+�,���M�+�LI-K��/ ��-t�t--������M�LM�Hq��qqq ��h      �      x������ � �      �      x������ � �      �   :  x�}�ۑ!E�WQl��Dh�p�?��j��r��GwF�A�|����,��/Y�R/���1���"��5�T}= 2u>���	9�H���(p�g��?}#�8��T��D��s0�N@�p4G�������*��F$�!���,�F$��:2+��H�N�C�g���	�)b��/���`�"�%G�"�N�k�\h�oD���/�a-zfl�Y�2J��X�H�V]`}O�r}@$ȫ.��s�{�!R�U��"h�oD����a��F�ȫ�1��^݈y�2�H�}#R�U�P�:��GH�Uͽ��kRl�̾&����b�${bK��oC��(�롘�v�H�Q*#�Y< 2l�^�(��&d�'��}��������]�������ʾa��d_υ՚qd7D��|�6a>z����1�!h {#2`U������bGd�*���k���ȀU]П.�����X�=�%=����#r����P�R?m�9��*�F�|��!r�U\R��ٺ#��^�'���*��mP�<@6�o����)�|���������� ���KD      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �   b   x�}���@D��n6 a6�X��G�E�ɞ߇A3E�j+bAQ�l6bJ���M�4���х�5�$�r/�h&}��m�&�tH����xo��{?U�.�      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �   �  x�ՖOS�H���OA�'�=���7l�I�
�TQ�$���oR|�m� �Y��TmT>���߼�VT12���!D 5�[(�/�)2}9��4�.��HA`N���6؆��C��F�K�5hGb��H^#Y�:�[�����m��p���`������nƣ�u:I:_��q��H:��l&�xt�L:�a3Y��I')��$�I���Ƞ��B g�%w/?����#��!:��P��|��Y���@�!��W����eq݂��2�� ��1Y�b�3?��ڒ� �֑�Z����B�ѻ��?�|>��S{���_������#
-|DJޣ�8�@!M�s�E�֑�#�z���2�� *���mlu�$��U���E�ٞ������a/�R�)Rx����m������)R�~���[�)I�H��W��"/�2p�QYa��X���:�X:�тfo��4%r����W��lg9�v�mx�s�֝��=�0V����T���bŶr�/��m���ā����2�`�1��)�G;�b�����H�f/*��C\�����o��t�^�[�j�A4���d�	[�^�j+�%T������G���9��"�z:'u;΋٫��SD���e-4��F�J�=6%@켑y|�8�
�rv���]���3�1��]e�r�r�E���Q�5JL�diY���=���e����B��<��ԉ&L\4��H���6���t|m�/�γaN{���	ק�� �A��T\��S��&�Hk����I;i����ٻF7)��Q�~��K$�PK?S������n�x4�G;[;�w2����z�\ɑr��k���%©�F ��U"�Cg
 �c��	|���E0�qdKM�0���E�V�A��<_�>�uoz�^o������*	��[��?a�      �   a   x�}̱1��Y�xAw���j���pb8�Ń]\�+jRѫg���Dݓ7��΍�$�H����?����D0���Ho�~���ԩ���afo�+l      �      x������ � �      �   �   x�}�;�0���9E/P˯$N��X��vA���#E��叾�f`��v|@�}%Y�n]��!�S��� I@�tj�Z��4'���߯c���ew��P,�PEm���\&���kfѫ�N��r=I[��YWG���g�AS �S�f��MS L)} �a_      �      x���Yrd�q�����T	$&.�+�FK
��{#�}yJt�Y�ӡ쐻�lY��L��hٹ�1��WI)ka��{i�U{��R�?]56���si��>�s�����}�����9��������T��o��?���?���������h����ڜ����?K�����>cy��CȇP}J��j�O����c�i������<�<���!��ruo_���:�����Pj.�w��)�����A��>�N J|]~K�
���`����d���g���k�<J+y;]����|��J��[ڥ�(;�8S�w��S�3%\<�J��)�@�X���)�Z�K%��Ou���d�S�.Ց�.��Ezrm�K~k��@��u��cH]�O	(	���,��ت:B�Yu�\CUG�1��j_}�5{P��y.�[kqn�@Q��c.�J�J�S��Gz�HS�8]�m�^ܖ��c�#��▤�E�.y��WZ%$?�b��������	\!�K�?%�H ?�`��5��^E��B���Ϲbm2m���UҜ2U{��V��b~�J��cȗR˱�i����t�f�9z�n��f���Τ��{lv���k�.��*諷���өd�c<��
	�ǎ���u��0�ECL3/>ouLOݽ�U|�#,J(G���'����g��h�.���N	0c�Q[\p_�.�Ji-��h��2_Q$֝{��N�zl��F�@J�����B9��g�#�H�ӯ1{7�;<;|w�R�i��Dd�U�����j��Q��3ȟ�<�O�S�+��z�`\,�!2�/ɥ����F�.����g��:m-�uP���'=���@B� $��P�(�D��X�j�m��>n� ��H���66_�,�>hϽ��.��(��R���+TTA�S��tj+��i�d�ܺ�+ja��	H֢��^4�y�������}P>]~J-�MѽBt8�q���X⃢�n�\��;8Fٽ�ť��&�Z*$�ˌ	���`t,aQ��3��|�EW$CG2Fǒ�S˝� ���=��!6~�[�1�ؗ�V��L�F�2L,=*��	��D������0��|��%�\;��\{�|�f����S����&Zt���?��
��?��I���^�P�5�t����^�B�wF�#�4�B*���(�ckNUv��\]�SZb�2���� =�0��c���唀�ԇ��k�-�e�,}6���RtTJG��
�h��1j�I�ÔQP���������6�+Rk��(��w���Y��0<Xб�ƆJ©9Z߆�3��@�V
C�	��cr�)��i�)��X���ՠ}��L�&��;��Rd�#)>~�'�XE������]r��g�H����
��<u�^��?ʨ�%�ЩR㞱Y+(�k����B��`�i{��w�~ ���)C�����'$R#d8��԰>N8ʭd�&�2q��K�}D`Im�@Zl���sϮ��{�����3"��w{�
��B9љ!c1���z6�>je�q��F�Fu�� KtyH��ao��4"@�Q\����*"��� ^s���@��F]#�+	5���SE#.,N5�S��q���K����aj|�B8d@(Z�E�􈨃<����F�& 2��Z�_�X�7���{���l6a���\�pJ��C�>��N�����9�2�{ڳb�fut(E�Q����r�f��@Y�e_h$R��Xng�?�gb)����ɴ�)SE�́������z�;� �L� �`�*9�$��F[��S����Rq�������y�S'GSE�L ��1���{t(���((�����rp:襖������sw�������!��;e`��YPh�O�Xw�W�:�ߓ�Cr�V�ί尝���;S�P�ݖ���9(���|��I~�@ӔN&9�,b�J���ѧ���cXi���{z�É���/�o��CG �@�?���M	�����8���|��Ĺ��6���!R)s1�J��%u^�ٽ���#Ͳ��rct����^�
嚲�� ���g��yj>��#d�_�]�v�ei�|��$�,!�܌A�BzB���"�	���
z}9F���_���p}/� ��艀i^Ml�U���i�X����O��3�����(|�iY�w��
���I�&#3 ���<�g�9�	�m�8����ZWH������QWL ⯴Po/�F��8$��\��5ȱ��̂d�1N�M(kD��6��&�Z�d�L�zK�;k�.��u�^��&ޞ��߁�B��K=	�dd�Ǭ�<��FƤ�ҤE~��0l��%b!�S);���Z�@��'�@��;��;��B�d=q����� �\ ��3���Lu�S���(�ŭ�m�����[�O�Zܖv�&��gR�-D{���?d�͝i}4I3I�ݶc@���B�bD�q�1�	��F/�(yؒ|��B��)ζ���1TmAꘁqYHL��f۲=����S��7{L�e�\�8j̐�2uL~�d��t4k��]��	���eh��l+�@w��1-)WJ^��<r�i��R�|�Άu`����5��m��H�;{�P�}�.ET��]�@��01s0 ���&�;:�Sl����6�<�܂�ng��-��7g�
���SW�c�{�c���
������Ya� \)������ ې�dtj���;�"��OpB8���r\�-�ɘ̼#��V�R�ؓ��Ml+�k$�X�4���X rD��*��XtSFN�P.qs��&�R�y��t܊�jR� ���nm:x/��������*��C�����C�f�c���1_�$up� o¯����ܦl7&�q΢d5�K9�T�����]x�v��֍��)%�x�Ep]� ��>|��'�A5��ԾA2��:���:�*^�p9.T�}]�M�����c��#\�(�c��I�^��Mc��[c���=�13�q�0N���_n�����o��
)�LN��M�iz0
�f�b���ĸ[ım���>�e��p�M��$G��Π~������&�	%DE<.���އB	u������r�Ěm��(���q��D�J�k������@^�.����+�PF�.]���9�㦄�K�l&��m�=��ڰ6<7c��ԙ��x��'�Y��[o5tE`��ЕJm���.�XH��]�Y���ga��3?m�{�ĩ�U������)f���s>y�|A)���z��c&����&I��5$姄!�1�03>?��#E���A�7Iq�p�z$;��a+�qҪT�}��`_(��a��EK����p�K�A��^�e�������PMȓ��H1>6NLg.� ��EDt�u�ImQ:�-�����L�	6�ާ��R����;�t�� �YQ\g��#�.~�uu?I�$Q,�.�u����G�>�5 !�}u$�Cx۵�}|�"�_�MQ\!�ѥ�҈(^���w������0�jގ�B�l��v������qSY3�`N��A 1dp<RT�6(['�(�Up��-�/#TRz.j�C������ݶ|����Wu�)��,-ǐ�J�IR���
���ٹ�U���qk�3�#�5���
�{<�c�훋+���`��:�1�7e}�4�nN�u�T]r���P� ���	[u��0K��@Pf��U�]w�$b;����9�0m�;caߠ(Z�{�;AQ5w��g�F��d�H�=*.��I�l$�h�����e��Lv����ؾ�j�7,zm���CQ����W���k�)%��㾪mA19 jDx�h�u�S�~
��� }zd�;�
!�������(�Q����֝%���M�帳�WgKw͔�N�&�+���ҡO-���5�`��(���j���bӶ���}++-@?#@|�۳C�^b	�l�tNWTe�41��V$NA�CH����ݐ��m�^���[�cճ���a��W
���H�ёw�/���Ǚ�N����ߕ�*�Q@��,uz�66.��52��ȉ-�S^�Lv��o��X*����t2˧R�p����    P�S<��5�G�`��O�?���o��XR:����Z�� }� ���Kr��ì�A{	�������q��V�?Ry���@��mBJ�щ���$)���&�eHU׽����~_�T[y�X��&�-��َ�i�o:�ö���%*���7�F��Zީ��lK���L�s����v��8�~��eJ'S�x�{�]���I\T�q��@��AW;ٱ�	c�&e�[��� :���l��NZ���]�q0˩���Rk8w)͢+,zE�W4���R�\���a�_-����/~ [C�!}ۮ�
E����y���d[A�1^r#|��E\j�;�i��;bΡ�p=	�$`܌��m��)剻v�m�P�@�y�z�Q�H�nCx�Ń���))�^�09�4��c+��c�!�ޮ	�-���#��;�B� ��Y0R�,fC�`)�J2�oS���J�ޥB�ޫ�9Ƭ�����6��6%H���\](����"8?�`�L�`������a�ֲ��DG�� �:���Js�a��hp����&�yE�)��v�B��3F�9=��*O~��9�I��uƽI�A�a���8����f�n���L��wRx��'>�p]sʏ���so�Nv j{������F=a�RHu�n�e��	u�@
!��^����N�ZO�Bl��#�����]:^g�����<��ŧg�VZ�ݻ������۠j�*�]Rqo{5�PB�/�]�>r}�Eǒ��R��5���O��`�s<a3T^���HrKw�]�dl�'R �h~:�+b�Vܣc��ʉlF�E�c!!��ߔ�/�H#�^�?5�,��y;�b���c���B���ד#�,�(�lv�P�
hа4�»�#a���ʊ辜7��=��׌hs2��o󂝠.��l����
юG_-'}����c�Ⱥ�r��F��d��m./:l�}����uvdmą���R�5�*o��ѳI�ي���%�ݒ%藾j�*$��K�"���0�Ѵ�-����ۘܵ����[���Gya�?
�>h·��JA"�
"��4��^�/�b�GhH��0�72�rΆ�:�!��@��"M)'�-�?J|�J����
2�����X�)��c��DrB������Zj����8�~g�#C�ѝ���!Jv��s��T]�v�U�u�T�f�4o	�3_��6��ڤ��j�Z�5N��-;�|
E�7��D����6�Llw��#���ƚ�� ��iG-:'�C@��}_�r��|�ܴ{��B�/!h;�J�V))��RL�Q�i-[R�vz;������+�:G��j�z��JvJ0�	�R�%]�+-�����+�b۝���{�v)n�`כ0l	g�{�8�@W��zR[
ab)�	���p�k��2f6ηB�Bw�Gn��Ed��	Sc� ��v)!������).'���\-�8������־���K �~���K����"�u��]�̶F��Y���EmA����`ǈ�&8گ�i#� sJo��_�@�搾7�+d/6O����k�(<�!��j%7J�A� ������W٢�&f%�_�츝�<H�����
�{�P�1�� �cI�{Y��ы�vz8��Z~v�-���� �H�n�o�ғ���zutr���Z�B�[�?�p]�3�=|n�ǖ�����䉣�=�H��i{ӣ���΄��-��ΡZ��,�ׅ�_B&hʑ������nv�O��l�9�=}m���mAR�ҟ�.��-*vg����۰dG�#��F����B��Q���f�v��u��W��ۡ6~6���#���h�_��!߹&�w���@Ѥ�>�1Tb�Ǔ����E�D��Lec�=�wb�}z[�)A�#8v��g��u�>G�˺���b�=�:��ҧ���Ӻ�xk��e�2q�L bT�Ξ7)#�r��`O��.�`�*bo(��;�skO�5N�t����-䟎B:^?��ť��L�����_����WJ`�t���J&3b3��|gv�]�Jt���v:���B�-�AS�f��j�\�������ޢx{
/-_T��~��.چ��V�4]����"u���d��	�~Ĥ����,.�Dm�ێ�u'��d�����Vu��hs�	;��C���){* ���,\�dpu.$��tJ_��ˮ�6>�b�C��Ea��1s���a�!m�^��+�5΀PRF�&��Н�����lNy�jBd�.�l4�����8���"�`*�lv+��y�i�|�N���>���[��%d��7Y�����<�����Oɮr�@�i�X���1zY��d����+�����4������|���7��S�z2���a�:#�������V����;���@gcB
���쨿��;���bKF��{c�W���ey���9-tgLݞ s���²mh:Cln�໫��.�׎ �K]wN�~4�g*��!B%�ٝ��zu�f1!ژ�L���"$�	[Ǡ+(
��f�Ps���k�$�o��;����u4����!����Zz�7z��r����D&�i�s����K���T[ã�졔�M����������@1���0��p�R�nU���-P"L��m-���Wg��-a�K����V׬6E�QgB
sa�J��.����S[��~}_Sz�l;�x�A�by��z�(�`�̂"�����Cк5%ĩ���X��Ѵ@�v�~ Z��.|F9�\���mC�����Q�k>�j'��H�Y������e���|��4@�,���K��vC�0�S�����w�hg/��+$x��}M-f~),�J2��Fm�WB�|�NS��˺����z˸����	%�^}��+d�M���I/�G�($5e��������{馒�H(n�F-ڴU;��ݺ��U��\f���}��%w셋ĸ��7�+�j�D�����U��z��vm!��Y�v�=F���o����ؑ�*ν��\o�>ϫ�z��G_6�=�8\j�z������m��[�/�U�H�#��(�~�I���[TrE�˽W�B��_O��G�\Z�ōY�s�,yR�\Y���aٙ �~.�	�B5�j߷[���@-i-�ك���x=�'���04��}D�z�./Cke���ζ?�9��L��v���H}ԛ�D6���+���+$��<�=���E��f� e/q�j�a��fgٽk�S�͗m-��
_��k�vF�;A[(>����"��Pt]�c��Qa�=¯�2.s�z���$�E��slu`��FT�@f�K��0	f�k�筷�I[�P�~��#���vwt*���� ����
�G,w�e���T~b4<����W(�?�Qd\��؊����h�V����@L�v`��׎�����ɩ�m���uq�#����� ś^}E����4\܀�����G?P�
�8�l��_�ɩ���{�v��3	�������0[�[)]�b/Q���.�����.�!�t̾r��Ne%�x��Xo���;�*���Yv)~�/��z���7�
g�M�9\��^��D����M��v��+%_��Vϊ�[lE5��>����}���!l~��q��s;���.��ݗnm�$�= ��|Ĩ��k�uH!�UhMm�"�g������<?&�}��Ǉ-$]���TX�U{mm&��&����2���1�[U\Z�,�_��]:�?��4����*>#��9��͏�j�9�-�:'cOaq��'�?�����jԑ��/�vE��c���@��?-�6ў������[ �{-`��<6Ǉ�w�꼢=t��v�d������5�����и����u��ķ~�B&�����S;׎n�ਏ�=w�'v�[H��'�Ϟ(���͔f��nDZ(���nF~�a��M����i{���1�L���޷[�����҂=��w��Ji7�ot��_.���Y����[��=9��_���s;�:T.{�v�FUG/�!�Z}��K���&�]k�9]`e��~����^��\�7s������!K�^�17
V�c@��b����Z4q�{b�2q(-R�;| �   ^��jjo�z:�B$?�����|��}��;�ֳ�+���|o�خ���(�ݜL��P��d3���սJ�x��.�#��f��oR��.���UR�ܐA)��Rt��\������eBiB˃P'��R��L�kD�Hv�m��
!6�����=���<?>>�ƕh�      �      x�}�[�f�m��?���Qԁ�A��FG`����Uq��
v:�v��%�~��5j�۰��M�c�}�)V۫���3�f�sהZ�bU�������;�����)�G�O�o��6�������_��������������G��>�]��ي�^׌�Z�Y���Ciu�\G?#u['��Y���r=��k�~T~$|[��<�>��z��J:C�!%�Uj��@1�[F�1�,d�U�� 1�?�k��d��KpI哲e�����Z�a6+����VZ\���L�jm�R�5�lC�=�����!�x���?���'H/%�����Ӟ3��jj9�=d���s�gV�<�ػM͑�(s��o?1~S�b��>�����d�S�8�FYg��v?Yvʡ�|V+U�$rQ���N[����+8�[|��%|Ԓ�b!hM��X�"]m���I4k顜�̄�:�Z���T���K���Ȣ���C|?���4�U�٫�c)����/E�B�.��g �vΟ�c���藯�����O��Ѱlκ�D�,��������V��\4LR�Z*s�h�`�b����VB�x]����}JXᄳ{ ~/�EXv��1eXZ�HUs��ݜ��0��@�Y3�- R��[��|��P|����4Nt�F	��G�樷��Yr�{����fi��k�LQ����Gπܾ�E�?��oP'�:W�9�vHzO��6��Y����qo�J��O�0�������\�{���G)����0ɻ�V�~�g�(��2�!�a��r�Ͷ��K��P��(��_�����ܩ��B��HJ���ܱL9���Ϟ]S�d%$�p��2^���Ol�[�����G��~Nk%��o�LkҬǺ�����#���6�L��`��#<���t����g͓�uNɻ�GΜe)�WҤ�@�3@���I���~��Hj/�G���T�r����gxԩ��q���p��� J��ݤ���$��B ��\�U��?���Uj(\�ޱ_�3��B�A����v-c������ʢ��=��VKJG��D�����7��-�C���)��7e�'����iP�s:�FcO0����A��/?ZA~�zM����p�s��%N=nC�� �@,�=�����<`�L����i s�#|�o5�D.�5xxN��6�Ȟ��Z� B�-0Cf����ikt?l�8����W����謹�8�	�lRuna�'�������ye,E�we$+�#��/������z�5@_vb2驒~��[֕���2��V�O��*�;������G�l_ݽ��Q/��%�>N����z�I*��HAj��[4���
���2 ���r����凶+櫣�T#l#�2$�@���E��d���3I>Cs�	:��f����Gx`�Jz9{G�T?��m/Ӆ]�Z�(���K�3�������@d��(��;V���~T��y���;��ɚ�^lx/�J)����͸BGs�e���s�@O^PT�D�*m>��n�|�zG�,����$1ʴ�VEWu�%�!�֧q�k��,���.;����x�o���ꩣ^���"����"��!F`ŏp�:#�,��ؔؑ������@�ܢ;����:4�=�S2 ?�������v��h��GR����͵\[�@��ݾ�R���䠗�z�C����Q���I)�O�=� �-���OB@�7/��K/F�	�ZWZ�b��?H� ��������"gm��h�؎����B���8��_�B����=N����w�+����<Ijwy������k׊����/JQ��M�����t㏆���(|�W�Sa5r]{����/������$/m".p+� �T���S����[��|}���DѦ���\���xG�xZ�!L���rR4���+�>�/�U�������nΖ�R's%�Q���l��/�c^�P�8X̨c��}*�7C>��;�c�8�X��H֓J� �]w]؎��Y������z�/��}�n�3Dn����(��9����_p+<[uD��̓���N�-[��ō"�\�[|�Z�g������C>dP��|Z`,<�
[āIֲ��Jb���[_���B���u�������-�숏C
��
t�7�	��h ���b�]�V -��SmS�N� �aDO���-]3������\�^V#�2�u��>�`�� �J�6�����������ѯH���͎�>���?�ʮ�ѓ�'BE�q� ��Q�K0�m�������K{!���:�ȿ�}qȵ�hh�����uD�	)E��{��C��M��}��u�._k������/��-I1I�۰��D,�>��*���,�lo+���`R��È���3����Mw};��CEtHR���BS��@c��L1���{)x�K��;>��*/�=��Ge7��F��A�q�9@%�'l��C�f�j�npX���������(-��	-�w�=�������W���m�ʁo��()�S
h)��@ >�v�a����#59�fc����W�W�Z�a��_�b�H�@n��vc�#��\�ÿQ[�Oƕ���9}t�o��6V�g��խ.o��f_��0xQ�� �3zp��]dy�AǺ^ROD��$�tol�glh� ���i��l,|L�>���&�5O�
�`��r�`ps���ڑ�4���>z�ⶳ;�=�f[5�稠n��'V��8-S�x���	�g���d�/h�/ =�E��m�_Ll#��B��v��N���393	�"�3w�:�Ұ��<�M�_�0��V�����[@�DW4���[GO�h��v}�)H��%'�?Jf�^���^�֪��e� �O���#��~9��5IBpɇ��3<�V�N�x��w6yby_@{|6Ep����6D�>r ���]Ayψ�c�OB_�«ux(��7�kQ���B�� �7�/���GK��e�������bd�9�Cp7���`iG�P{nC'�fC.h�� TA�']�����AY��g�ѐuwOT.�A{����.���t��|53_}���6��<IH~��^	�GY�����(�t��&�wH �ذ>�8��r�6!�;��x�~��^����Hp�#��*��$x�Iӣۭ�jA�Gx�s+��������U�x�..&hΖ}��=��\�>���UA����bX�w~h�D=�6\�]@�$DӀ����A���t!ւ���9��z�j����I(���-5k�~D*�>��̛���N�#x:�_d9��Tv*��<pt�C�v
����0��Dm�*Ş�[��_�fg&i�x�@��
��܆��w*e������|9=!Aa%��`O4�� �(~]ط��i8Ft�u������J7CQ�ʩ1��R+���󓧹Y*0s명�$� $l%������ow�uyM&�]���c�QHh$��g���^�R9á�jm7����������P�p�CmYJq��h��u��6���!Ć���?P�؎��_���D��������~���O���V�oY��s�Z���ʓ��q��Lr�ָ�������4��@��u�gL�����3��Uى�;�5[�_C92
 �βIЫ �]@�		N�^�(=�.�B2��μcE��
��@�����F5ԉ_�|�r��r<��8�����^�:�'	ه��ML�5[�w�N;؟�;�N{}��!`A�|W�B7=��V�5	ӓ���7d -��|��\��,|j�����ϙ�֦pSse^�����Ϝ�
�k���u{�j0�9��!T��6@S��bJ�Zt��uf�@G� �+� կ7����S�D?,���h�3xN�|�9�|uQ������{��CxEB�����}�,� "l��3�9��4,��:8	$A�DO�p^Ӓ7���?�^ݘ`����F���@I��P�Հv��8����A؏1:;��ۘ�{A?�����ߊ�SA��9��k�P��MK�Tj��l� }  �Ӏ��'��=_+�w�WI�XѤ��x�@2��G+A�l~ ]E|��<��k��2��(��ے'���� T9���+?�8���ܫ�!O���0X�rohZ��d�0��&h��A;@%���cq�EOC.��s�i�&�+g��fPآ
�XzD�(�E9�_�/bY�ap���|��:y��%�|a ~��x�7T;]P���L>�=>����u`��:l�wJϵ��֗<]9b|:ޛ�2H��D�T�����X�+Bx��.��z.��q�h�}���~��÷HK5ù���W>n��ɂ���
 �����F$fuܭn���W��Eޖ��/|�ŋ�*��睃�K��|�	�;" �yW� �d!�1�+nt�.~�I�/}��_��z�O���!3����ġg� ˨ ,PLD��r�H�kk��G��kgJ�o��� �n"���K7-x�!~��!�I���'�W���c�c��p� P�� ��p��圖����p�{h��ޑ�ie�>$����PK����Q>������"}>������-ي#	��c������"J-��F�+:�-�n�- 
2�?�����Ku����G'Ox"�O���Df��#S8rM�������6\�����|�`3�/�Y�(d�bK�4�D�j�U��2���7Cx?�����+��_?��k���>���:�2���ʾ�1AI�:�9̈́��3�R|����?zD4&���9m%���1�}�eS� � p�%$�Y�����EƗ� V��p4xJ�|֡�RHw���AE5���Lh��gK#���;�%��\~b���W�x�(A�n�fd�`�4��bK�D�(2�.a- �*�uD�h�?R�<vT�ڜ��;����:�O'�כ�ݔ�N]��g�˪�ɹ�~����q�_S�*P�}`����m��.k��_	�P��PR�/��c(#no"� [�ڂ+�૯���ۏ:\>��������ᓱ�=�8��� !�	y�FS9������o����>r����W#�U�a=�����ziC 5X�l��\C��!	����0��Ǉ� �\GOW�$L8��/	w?u6��H����X�<!�I7�����6��@��B���@���>�y�j��AסwJ�p��]=� d���D�� +ń�0��_/ y�ů���}��FB�p����|�K����q�VxL�76Iy�")�����p��)~QI�z��I�?��P'5�v��G���F�����F_�]*���	���/�Ư���Y�&}n�c �_�:)G���{9��>Yz�.�B���2�ۢ���Z�'��E���R��گ�L �O�x�����z�~p�h��v�I�� ������x��Z�JB�����Wv������2̄�0��y�9F��C��ޑ��]4@��|q�ȼ\�z�2Z��d�����} �x��;�EF��D��OP�����9��
�h����&��^/a���W*�w��g"��MԹ�Ig�䯢8�	����|���0�_��̴W
o�������^��<��.�dݛ| >�?��wّ��.�(@���`���s�$c�K���Q�~��r��X�� c��_�e�#R'��<�K+�4���d�@������w<��_�׭��|�ߩ  ��A����F(������Թ��Ti��V�M s����ɰ߂3��v�=  	"���67�(��	�y�`�t�%<�R�'����q���L,���X}B8��I �u�i� �u���  M��S�p�X�B�C�����?		 �_�?�'�iF��ߩ Bw'�/e�3�������%?��v����#���f ���/=&��-�q�(��8�����;ԔA�G����X��/{I�'>T�~�� �Q"���h���b�����M�	�8��t�C�����Z�����ğ�g.����@�@��!��c�����O��0���Pկ��P�,��iT���7q���$�`O��AA�����߷]8���22�7���Mͷ�Av��d/*4�b1�Si�_����{0������1D�nl��@7�@<����wD(�٫�s c�ԼƏ�P�`B���v�����f��k�>�>\{Z�+�U�^���5�X�\��~��OҒ�]��a ������$�ί�FM��j
�L��YZ��e��PP��y�W�,l���o� 0�Ϥ  ��-��I�{~�8�����U�N����o0������O�o�J��/{ P�gM؍LF��;�`\U�V�"�>�!Qk�Xla9I�v���(��������� �t
�Ƀ�?b�`  �+��]I�d��hoDP�ハ�`�#~���
��@�q��ѓ�o�v%����_�v~���p2�4�l8J�솫M���������-_	���O�Gj]�:������	2�M�0�-Y�:��e��v7���۟�l�N�ڃ?`��FL~����vD�U�������2��@��eZnr�R���-�S�-�(X����F>&~�z����j�����o�7�PJk��������y$s��$@�0�a@�X�p��q:��w��F�l�̳��S̾E��8��(M~!X1u�����!���a���l��+����B5j�
l��XU�Zf�~U�}���@.�����g �9~��_|��<��IM��)E��ѩ?_m`8y|d� _{�������}���3�Ũ�<��?,�m�����ҋ�m� �ݟ��F���#�ύ�n������@c<��3�� ���[!� X��!��q�!v-dD���y.I��N�&H8���Gy�FQ���]X���'�4/��t����ȫu�Fe���B�t�W��u'E�׊?ܾ��x� $��B_����g�%�z� ���,��s���F��������}��r�a�3�H�����iB�y���I=�U�z��]�u�P�fg�e.�I\0���h,��,@��p�b%a6sY���F]��y�(��כ`/ۡ(�Y���^���ϾA�k)�/r]��Ƨ��^ԗ��I����?����kd��PW_A��"yy�������b��^ғ� ��Iĉ!�A�2�ߋ|^$�v�I�SE�F����5Z�߿_z�)G��W(���Pm���2){�[ݢ�_ ]3x��`�Ӂ���lP�o���[>�. =G��!/ �O�yq e4r`g�H��<�]R�\�/'u�gO���y��y�G�z�~/�9�r����=����o�:�H;��ղ�p�����0(���߇��Ɉ/��m�;�����j~5i/�� ���)d��#R��p�{���'6�8�ڐ��898��ݴg�>�������$"zoj�^E�������	uδ؊tm�k ���\_Ç�h؃�A��c\7r�/�>To��:�V��+����� �4�^�������5��[mu,LqU�+���݇�����I��0&���?'1���ƽN�AG���5��W����Ѳ�vo��V�����Q1HO��?�t���a�e�_|�����?���r��      �      x���ɒ-�qdׁ�����!?��w����&D (
�(��>�U/2oI�&�(���p��LM�����g���U���'�M��ƙ�1nٺ�M1���ܶ���������]��Us��zk����A٘�{5�aF�����ٮ[��Y�c�}w������~�}��?���~������p/���/���j�����������?~���[�͸�寶~�a�˥dJ�n����׏�������˿֑�nuM�f�3cV���gj�N��s�f�J&��Gn��8'���	��0x����8��c�\f˷���k�}����d��ŝ�:������o��/���?~�������������������������?���om����G�޼�5�}���_�+��?���_o������i3�4���RJ�W<%����9�S��C�Y���JK�7�裧Ԍ�5l?Fs�ƽ3?k�Q[٭W���3L^�]��:�0���r|�>ѽ\-5���,~Z�f>����YS�)��O�O7��Z޾/�a�IH����3[�3n��sYu�����:�j�p�/���\1lw�_bɥ��y����<l��?/��廥;şJ~�Z4>�{v?x��m���x�E,�	4�̒硬)u�&��}D3mI ��a�����i��V�9��x�4m��tw�Dfx�B�#�*!�y�υ;뤟�q&'op���K����>F7[l��F �e �5zK���>�L���b�L�LvC'b�ڳz_G�+����[6�$Y���N�0����~�tg���B<;�o[�h3�0��BW���ݫfӛm<z�sW�gH{u�5��-�����c�y���e��Yː���s褴����m��iJ������wKw*?-�	r�%��ji�5kLja��&���+h�����sx2���<�ڊ(ޤ�h@�f[-xk%"�����K$Do7?W����ּJ&�Y��O�i�	����@�������Hɯ`�l��l]�<4Dgc���H8�ÅP��TG)&O���B�� �J*�ĞZݘ#)� &I�i��!��O)���,D��I��|(J�݃4a�e�15���خ�է�~!M�7��x���Jg�Y����nyv�O0^ޖɒ�͏���K��.�xڅʇ�+Ѽ��u��D���:��o�y�f\D�wX��u��K���:�f� �ķ�%!�|��B���cz~t�UCZ����q���Ư�7�L���MT?�{Ő���nMt��m;��,�ڝ���e �����O�D�^���K�|9��Z�Ǫ1E�t3k�nIO��j#�3�-�H~G���|ׄ��7��&3�|����p��ҭ�.�z#$F�6<WDw��c5���	�#V/D]͘�%�&�r3���D��f��`��[��J���ag�����G�����F�EB�6�ټP|_���ʭ�.��5�z���Ӂ0 b��o���J�W�c�
���,��3��XK�-ٞ�YE|����a�0M~@��|jn�0Ϯ�Ќ��f&�Lɹ��nMta�f(�;W���EX��� JZ!�ͅ�]�,��n�p�]��#5j
ե��ҍ�=Fq��k zF�z���ĪqM��|�⇏�����u��DZ=p�-�J4�f��HSYhg�Q�@
|*� z�!��wۤ~�-��RE`�Vjф�f��]g+	'WB�VQ!�O�?�%��bz!����e��D^mm���H���y�a���GГ}���A�{e�TҶ��,sDr��ۢ�!�yؽ���{H5��Pđ k^=b�;dg�,�Lo]}�D��B���1|�tk���J ��׮�B�T.,iLU��Q!�څ,�mB谄��a�v���8�����b��
�.�5�s��Nd{mK�eE?�P^��g��[]�un~�f:
��G(�Bv���eH�3�7��!�0� �卫��勝�f�|ߠ}^��"�<��CxBy�g�(�6��=�����ȅWrH���ҝ�܅Y�P� �R��������~u;F'Օ�A��l�=� P1v׽?Ȁ0�|���g�]k�!��D�E�@�H$�ڄs�b(w}�D�ux�o��tk����cpc*��YF�u�+6�@�2<�@߆�XV	�&�C|���c28I/"J�D�B����C qX"���].��m�$�=f1�Љ��I��\�5хYk�+W��:|�"e{(�#*�T~���Js��N:n Y����c�[��S7�Nwtu�_��= :x�d�e��h�mo�͇M�O�ᒵ[]�5a$i�g�2�J�AajS�@�^:�bJp�?��3�E1璷9�Y>�V�A�'�aN�@�"YɃ�8v���MZ �!G�af��x���OK�&�rkT$���^��xL�r6rɶ� ynmvr[��,�1xd�m̶W!GI�����P҆F�s������zB��Jj9;�)���qv���K~�tk��^�&`Sa���W&�Ax�����U�"�F�e�6Au�ª�x�޲[�gXx�^�bu7������Pf�v?�ѰC(/m�����ҭ�.�ݝG����� �����LPv�e�7{x�s5n�����#�\��Pݤ��R0h�ƪ�2A�.F�óPs�H�k%��l�6QPf/�yc�[�5х[�Q<
�;�[�s;�*���%<I�Lf��Q뫭�m�+@k@e�8Ӧ��P�y�vN�Ƚuv��B��d���Z$w�g��N;D��?��Eץ[]�uCSL����
2�d���:�(7�*��8�=BpVA�����	=��*n�A�b*{�{!�ol��a�$���v�;�V=�����	Y��ҭ�.��Nl�ӱ���u8fq~�����@1������^��+G�9�- :nC��[�v��M8(����i�Ԛ��0z�$ 6Q��D>n���t{>}aױO�A�
��@W(�u�K�O�I�n�Xm�'��9Jt1�l�d"��lk���i�)�=:��J���D���GJ�n}�]��U���L��ҭ�.p�&����E�M�1�u�<����1�#�$���'��s��=�Ҏ�aYT,�g��iGٓ�VՑ���s�j6ٙ��p]>\}eD~��ҭ�.X����Jsm7{2�4�][qe�\	�] /�D����I;�_��-���s�1o�фC7pk5S��-QH�� ,3���L ���&�SF�|�r[�p� ���n��ǜS;;݊Y�e+�Qu���f@�����6�|�#G
�nl]�F$�H������QL�n@h����6�C�HO糪b��}�_�ǧ�[]��.f&�Bl��x���<"U/���( 8\ ���M�"�y�)=���`�C�Yh0�vʀ�v�:f*�yX;�[�E���<��̇ϯB��R�e��DWn͇5��"���νDi5@E@5E
%�jh�u#�ک:�7�h�q��F�O%�53�5ZX�W��=§T�a���J���O����1/okJ_���ҭ�.`=W]��,a+���<Q��*$%�N��k8m���A��gܰko��>��Px$��(4��gَS�\�[����ԋ6֞7�����[�i鶜��P�:M����,u �x7`��h�����b�x�>�^hsT$F۸���*��Ć���:����p��+\2�6O�a�g_��P��9~Z��gףꮢ(r0���P
<�͛�b�Y}�!H�$=�lR��h�&ܩy�h�z���q�1�
 c�n$2d�&ۥic|��z��?�E.�H4�_���ҭ�>U8+�3�z�u 
Lg�
7ZsL1�D踒�ą����S���,��	0�H_�/,a/x����
jX�j���/�c!���~���/g�Io:��tk���-��6�0c���kmΐ�c��A��� UA��q��!wZ�ARZM���O�m�0Y@���V�U;��˰ �����-{=ͭ��;J���	q��t�ײU���D��;������ڲ5�Ǟ�6ġ�-�ɶ*0*�}�g�w�M�    
NY$0̫c^C�[e��s�ΡFH��U��z������'����-\_L4ANmp�� W��TM��!���`�~�~,��:�<FAq���[1)�:U;BR��0 y'�3W*����"��D����opʟ��u��D��-��_C�v+�F�4�"��O[��2�I�#%��ʃ����8�P�<�t�3��ͦ��<�Y���y�ߢT|�}#w��&
 ��ν��ҭ��e3�1]rR1�I>A�r�S �ml)ѯ=IB /A�Bv�n3�kՠU<�`W�C����w��$�'�lA�H����cC�j����A#�=�f0�k�}Z��닉��;��:�%�Ϊ��F�!�ld�M}��
ԫm��y/�r)�p�B�V�:6`,\r{�@�~Z���d���^�&��>��:*�šľ[�5�E���OP"�	r:-�eȵ�B"~�:`�()�ǹJ�P�b��%�jb�ZK��4rXmq����+�Я��JM"�>m���jK�zߖ�.�f��V��� 4��A�t�ԣ�<Ʃ�,������c�!PY�Ĥ��cǜ�Te_�:e�d�xY��2��Ie�V��1���<�#���5�?+������i��D�m�8�d����&�|)��f�g�
.UL�ndND���-�A�q�[�y��-9����a�]ؘxB�h� ���*�P3�b�ûE���WT���E��n�z�#��p���t��t](۲�}�jJ�Z'���6�Չ�1|F��n���H9(t�@7�c�2Z����\�a������Ƣs�t���ҭ��E�AH���	Y]t��dS��$%�oB�ou��z��j7�H��*��#(z	�)]=�14�C��?�y�*�Y��$�����L��h�7��K��f��5"-�s�}��Ɩ�Gy�#h�T�8C���(lP,i$X��g�8�+�E�J�����dɍĲ+���-B���rMhf�p]v�楻�f��K�&�$��zɛ��]I�)��!}[��ӈ�8 3���eR���-����=��6:vC�²�j�����]3���<��[��!��{Q̯��o2��tk�|="ڛv�Ԗ
�z@1f]yE��s[���8\4��$����X�XSF�iנ@^�Ԡ�������ᴍ�M��b��$�9��g�x��7� N��+}Z�eן.1(���{���\t�ǜ70u��Q����tT����UH��$;]�䵚C�Pq]�����d�#q2�Z%�A�S�`� IZ��r�m��tk�KF�� 5vma�pL��������*��u�t�d(�xD�#}��>�9J��m�*Csa�2�tV��m�y�f̂p�Di��H�4��4dݍ�J|���ҭ�.{���AӔ����L���A!UVǩR>4��j�T�*�U����������F�Vv	&��bӠ $�{ޟ����.?�ڋ������n��D,�Ԑ�3N�W��Mefޮ��a���L��Ή͞���Y�@�����|JF���a�)X*�T�" 0��SU�cͳ5���&��E(��hץ[]@QE��&�7��&�M�J���QuG��b��� �@3OS�FYD{��������l
j������\��݆�Y�|��� )|���B����i��D׺KJ9��-������dY�N�2{i��N�${ˬH��12.E7�o��r�3?�,{��y�BV18�us[;����<����J�|�hץ�[՗]G3�!�x��p=�e<��NO��Gs���n�@��\��0�hq6��zC�x�-:����QJ�-"�*-Bn�b ����?�w͇�/Iɷ[D��nMt�uD��f���3%C�t6mc&E�A"|&���"�R���:t]��hz[a.�D���5T:�<���E���Ƣt#��Oh��ÇD�Cԥ����?-ݚ�rHē/�?{���=b,�̦Q@~]�³��$7c�ţ)p�Iu�!%H'��W��)�$���m]�:n�|�!���tj2Ҝ��q�ٵ-a�&�OK�&��`g�x�0I���d&"\�kG�$m����^'5@���̊ظv7]�U��Jui1�+Le��X��(S�]���l�~+i�aY�6�vC���?-ݚ�®kp�S���Äja'�"�d�6���1�y�7R��v@����.��aH�����N~�@������u���O���u������Z��4��ҭ�.�:��� jk&�6�m�-)}
t�"�?7]N��!�-yD�$Úuq�\���$��3��X {5 �ݥK��H�Nfk%`c���M��j�W�i��D�ʋ���N#��kH:&���w����F���ka��r��M]�3�CﳃR.��g'�t߬`����zЦ�2�d`�5b[Oc�N:�Ц�7,�.ݚ(_M$��
� �Ę5fw�JdgU��R�euߪ�U����� h4c�=*�Nģ�|�J�ր��v5K��1�nt�<���ު�[7Q����o��tk��F�j@`��C�b&.J��yh��U���]�>�z�64[��T���K�y�C�����2H��.uҁ����lc/*�'��=.��E��ľ��ҭ�.���u���K0a�|��gXΚ�/���<<��(4D�9�?��AG@���@���N�����5�t}/Rj��X��5���YE�ED�ۅ�OK�y.��j����m@l� [Rʡ#q�
D��}�eb�z�p��t��!E!\u\��ǪT��ή#RTq�+b�*���'thؚ�a�>���WQ��͐OK�&���}p�gC�箵��7��Wݱ���h*
SR���J#`*��V���Yٖѕ"a�>H� �4kW}ZQ@=̈7�p�v��E�|����[]���V�`A�Ҷn��^��Ɔ	ĝ���X�{-]mu��MO:�ME���ޓ�ETڕ�#���/2;���3��-��t�Õ6P���EP���OK�&�v�+�O<�'����U&+.>��Λu}{��n2�m�}Ġ���a�z^��ж��dg1Φs=�͍�s���>��1�5O+�,m����nMt��P���h��ͺA��NE��<��K
2=u�.��VXI�	ӄ��t��:?������R�ơ�X�x���|��%��j��=	�>���B4�z;"��tk���м��Bi����Kş�.̾��2z�\˺{_ۀ��h���Վ��>!�|�jX�%m�\J�#ʻ�Ϻ)�\1�эv���]�q��{+z��tk������y汴�΃�@�_(|_ �|%�P���ʪ 3e���Cg��C����W���r��۪�2�W_����w�{䄂|~�Dμ�6��R�u��Dn-��_U�[�%"9�tH14")mK��
;�E�d`~��6ϫõ";�1��E}�HzY��3 �Da�V*q� tv�́���tʯ>���_�~Y��2waE��3\mU�V5�TD�3�*���F�Eܠ�{٢�La�ӊt���b�4w�Z���˻�k�t�haa�ȗU�����h1��0Q��D(j�n��D�n�%J����*+Znƭ��:=�HRE�d0K�3@����sQ�
6�B�jV��#�0��H�����|�<�c7�C�<l�$W�҇/���ҭ�.X�&R$�!�d읒;��n��D���4Q!6��/���dg�OjX�
0�XG�Ⱥ0RY�l'^#C���7�wP�ViO{i˿�Q�ˉ���[]�j�\��O�.f��x��7]�ͥ#����Ư��͙�5K
Y���h�[��j��'����	�gߚ'a�U2ƣI�X+~�%:�wK��/�	��y@���Q���s�0���sg�����;w>7R:00K��	�^m_x�Z\�h��v���C�· Â%�l�q�ٻV�lP_֥��lt]���e3ēj�z���IM�QG?OT��K�*oly��Wo"x���Nm�̱u���
H� g8�ԉ�83�b*�٬��]��F��Q~�?�]&�R�_��|Y�M�h��m �N>�cj�E�nF9]l8R�)�<W�J��
�    �x;���0��D����K]�v\e�"ͱ�-x�2�A�Y�.�n��G=��̇�/Ϗ�r��e��D�NcՌ��n��U�>T@mVU���Q�j�VH�x\m����Swλ��Gܦ��`RI��)G�F���%Xd��ȷtT`��ޯ>��?��+�݉�g�Ն��ι5^�B�����U;}?V�1t-����o��_X�h��0*З��34��95�_����.ɓ˪�|(��>՞���V�䢩�K��/K�&��"5�,ދ�`��ɘBjd�jr.��^TrN͘Q��]����Z�X�64���CJ���: ����d��N	���+$bH+��0'~��w�x]�5�E�xQmQJ=��zLĄ��j?Mʸ�pլ���a�Q�0o72dd;�P�c}1;aԌ����{�m�W�5vC��$��j
Y윜�����p
W_�-����-/��5QD
W�&k7I_-��4�щ<�&��V�A�ȆZը��8�'�#�-v��*ӀnU�j��*͠�C��J;Dޫ;��уF5p:�YG�/藥����Y*�����ZM���P/����2�B�}nr��3���V�H��_<!u�.z}������fZ��V�Յ?���ab�j�������mt�1Bp�^׹!�h���I�|V������sZ\+�l����I ccV|PYN�T���!�b��;�J͜���:r%	�U�}Z�E���>Zc��lj��ֶL��9�E�i��v���pVv8�=����~�}A��|f�\���e�����'��n��^$�)aT��{<���2D��Ɨ_�nMtQ ��<�7���f)ЕaC!��B��?oWA�%��rQ)�ԑ2n3� �U�m&;&��n+l��<�>@�e��낅&�^��ڣuק9����ץ[]������A�.�5��p`�Q�Ԉ�@d���-D�&�[��!Z���P�C/:�NJ�=��ݨ;Q����;0	fM2#CZ밐U���~�/|��7ft]��i�c"�&��.�v^�l ��ЄR�k�\_��;3O:&a����U)5m�U���Ҧ�.UҮ�[�`X<;j�j��$�]cx�%��K�&��v�u��D׻�$�4{ԉk������%���TC��ט��%ĖN|��5�O#�lz�*��g������mU7ݝC��FW,h�U�c7ӣ'i?vΜFU�����K�&��G� r�M�Y�:�9�n'�M�`�-�m7�����Y���j��4�a@G �a����؂%���ζm�U�&[�:�,���e��ُ}~�wK�&��,Tgcr}#�p%EO>�1���Nt-��QQL
�@v��3���*�Ιpu�w=Upp���YV�H¿O0R�1"��OcQ=u	��Dץ{bd�F�Ũv���H\��ԭ��&�ë��(�뮂N:�ͺ�=��^]��Pu�Y7�3$e���S��l��5�( [4ϡ;� _3>���y�V�|�to�륽��W\ai�[F�@�+~�,�4��&;]�f�+s,9��/�@���H�ޥ�Z�4�{�VGCw��ڮ/�C��Y���쀋����C+���mt���6���*��{i�Ȥ�0U��n�(η�OE4�y�ak� ��>t����C��N@n������5x�ͩ�V9�e�����G��$���OK�6�l��C�00��e97*ВƼ�.��D�M�+m�Z�E�qt�(�������G�娖+d�	 +¥t-.B5A",q�S�UV��,J�篃�,���kǇ��/�6�`h��ִ��tL�5W��geճ:h��-IO;�N=!T}��K]�sE���bY��`��.P��x0�e������"�ht��]�nM����|)���B(O�|��Cu��_k�G����{$�j��Y��|�����\����-����g��tę
It9f�]v:��?�k^�C��t�u��D�]�P��~�2���f %����y!DH=�;�\�Z��z�8�:#WO���D��VIj���V1	q���wMy9��a��'"�̙��'��!(s9S��-�r���'�d�Ό�H���[u�����*0L5O�9j�~�W\lɣ?4�&�؃R�ٰ��zw ~�槗:�J%�8��L1b.E����?����j�[��k=L3.E�ƞ��FUCy����=�+2J�4���j8;��E����f"��8[f\�T�vv�'7�Q�e�'S�k��ɀܳeF�C`t�ӻ�9��ҽ��E4QB����pnC���v˪�6w�ko��*G�	��Ͱ@�;������go�� ݬq��3�Z������pg���l��O�H�޿�S�n�}Z�E�K�W�|�b��UY�=�V��I]Y��p��B*f�ӟ7�q4�9��&-�}CѬ�UR�c�i��5s"��N�I//cA�=�Ԣ�\jן��ϥ�A��B#��#i\hm�ϝՒ �Ff֜ث�;ћTh�6�b�=t�V\63��v�\#���#B(��i/)��$�tQI�e��k%����G���]ont]�����А咰���q�5�m-���~vM�2�xS��SW�4[F2d�I"|��uWĭ��׮�ٵFlh�fkV���ƶ6���٩��l�l^�X�lt]��ѧ����[Q*"&��*�ؚx�1<q`��@���ܪQ/�9̖8�5��C����צ�f[�ʢ�79e�$F,�Q*.v��mT5,�:r�ž.������A�*4 HW�sY�{�;�D@D�l����}���wԝO��]�S���|�*�U�Eu�4=N��}��=r�NennGB枆�*"����U�~Z����LmG��`
���V�He�4fS��ڊ��Ԥ�H���p��:*�])�c/�>����SK�*QGث�~�����ƩI	��Ɗjp��`�#ޅ�DT��C>-������Ќ�i�Զ���95M�T�B hE����k��҈��Ǯ�F��.���&��������5�9�Q-��+hX�._�Ax.��_Ub�_�$|�n��Fס�$g�����&��B�%M�NS���h����ζ�S���n�`#�swe���鎬�t�C������T��1�����ܶ�� y��:��}��F�2��_W�gE�z���k�ҮL���u��%K�@�=Ҭ�c��p�ijҷ�a6ݯѬ���uW��t�d��R��X��6Y�a'`6�f��-���h[D�Q�d�:���@B	����iw�-�.����lC��:|�X���Rwt{j:4Q�y�L���� �b�ncg-wV'��t���˩O��n��F����V�������(�ȡ�;ɢ�\pդ2[cf�8���٧�"\u�G��5���cB��DN�$8��i�u�c���e��	�9~��R���r�e�/�O��vwV������5t@��<�\P�+z]Xl%8�A��}���y�@��5�?�@&�!ۨ7��Gdc���[K��Pt�����p0$��x�P���wK�6�n�/B��
'�p������74�	)�[�x�LF,n�Z[��W�eyU�鮬E�&�2�q��ȍ�W�$µ���u�A=�xN�#!ı�~����e���wK�6��lЂO�N�� �xP��NY%[kH�ꎢv��[����uĚ��S�p4�yT�N��2U��TE��vRi?J�kܥ=KoV~�F��h��z��ҽ��w�\��jݳI<��5�7��k"L���.� A��`US\_�z�����~�_�.D�.7���q�3�D��"���+�\˛]��mt�]#q͚�ëLD,�
q/��N�ރni*����u�5����h\H�xT�^v������3�T���U��5�
�U��p���IO�Q�����ם���{]��M��+bG�#&�[��J��E��M� �h�E]����ǒ���_L޵w��}���F�Sð���)^�u	r �`���m�_��t�"�K�6�� j�y�H�5������h~�żQݕS��]�$��6�P�G�ٜm°AC����69T1T\W����M��&=�x �u��=��wC��r����!    �K�6���S8m
z�n3��X5xF��j;�j��M����b�H��ËK7n�{�v�H>�}O0�et�H�h���h����?����(�P~��u��F�M��fA,���F�]�K�P�'��a��1�m��d�s,�?T��*1����p���'8�mjpX�h��`uM����_tي`���to�k7�ѥ2�&���4���j�8k�S�W�=�}$u{��\V��[�˫�	bM�M	rn������y����6WT�D��0;��V>�E�j��5����ҭ��C��[�@פ��p��N�V��c�g.��&������.�a���� �v�f��`	=M ��jV��U�7vvy\!P�R�+`�a��y�1�R��F�K�6��줾q�� `�����C�fX�^���F�ՆpmW݈����8/�F.�ov����:�9>`5�l��:QK^Lx��n9��Y���"���v]��хgg5�T�r�߱}�#a�)㴤�֦9���'�.z�|\R�!�ѝyV�6aw��\5�\��>Wj�2J9NmV�拪�����!H^���g6�c��F�ͧ�]W�= k�:њ�gM5�$-��ǹ�=ӕ�TT�J`x
h܃ ��e�>�|m���4�gV�
9����4�8Q{�9O�+=�v�4D0j�����uo��ҽ������j��LOj�VZ�N������m�n�ե�5�Q5���>ͦ��7x���*�g��W�z۪I���)aQη���y�����WȾ��[�ZO��3q/�wB�-hz'R4剀�3�b���ͺ��	|��.�.�>b-¾T�K��i�0Y�],j���I7��N���>����yyMj��S�i��F�zؿի�ת�'|�jydrYs��\t˕�5�\�h�� �$���t��t"j����i�3��:=�ڿE�zvC�Y��-Z{8�+i�}G�OK�6�6{�:�n�T]� bå�2�b#g]��ܺ��S@�F74�(@ZU��`�ȉc�g�ܬܚ�V0��[ixX�>r�����pg��ټ��u��F���+ Ԋ�2�U�+�ܩMS���B���������Ѣ��Js(G�s�:п�Mf����1:߾�\S��(�:j�;3�̦>W���U�����|eٟ��mt���\5P_�P;�:5I?�ؘc�gsEd,a&Q2д�x�pԚ���ِ�d��k	��RN�ǶF����H�f���z�"�4D4�ғc,��}Z���u����	*P���1�o�'>Zב^nX
��W�
C�KkA�wC{�ޚ�Ô�i�r���%1��$D��82Bg<kъ�nb��h?-���S7c����^��\�_lm�g���YL�i�6I@��4���rfL�U��얜%k�Y�h��A�d]S����aUt��=��c<���͏�K�6�Q�;*�Z�y䬙�zb4c��K�%m����cP��1�kB%�
�pKբQ��ԗ�ZVL:A ��G} W1�gR���6�آ��*��0T:�{���{�\�Be$kE�Cf:?��V�u�u��Q\>T���w@W���gV5ϲ�k[���EX�m��ԆUC��f��Y3��U5����X}=Y��to�k��s�	4��B^xE-�8��mM��I>F����9��=�q��'����e"�u�Z�j�"���a��4Ƅh�|c�d�e4��a%�I!�7/�.�s��ܢ\��F3��5�;h���w"��jZ�YY�i��ef�Q�n�k���t)`e�	��,K ��g�G&v8����#/�㖇�,��$�'z�!ץ���i�.J�Fj_39U��� �e�`&�|Z��N��NO�L��MU!�����<���k�j����J|���O�Ƹ�ܦ�(�9��Bqݵ�n��F��o�(Y�?����(2Ԭ��f���p<M%��Jݩ��K�,�/����VS�Y_����ZQg�[ ����Ͳkκ(���T廇w�C���7�v]���%�3�5I<��l�d����yN�U�@j�ڲY�s����8I��j��{>�� K[��4C�39�(�� �yvЮ�QW�EcvQ)�q��ҽ����Fp$pAi:���!��!�m*��ևkï��l8��U�8��M�L^�C�4]�y`����H�cN��V��9Ak��i}�(<α�}Y��۩ѧ�{];��p�H�&zh��N��X����J�4| #�؃� ��B�9�"g�{�*�	�T������0]F6�#4�>6dM|8֢9�V����u�%� ���T>uBi����K�;��9�w+z�.�3���V�hvj���3~��A15�[Ш�A;�Ty�	~�iH+���<�w���U��OK�6�pl2m-5q"NF�4TFPA�����Cj��f�j(��љ�zC�6��a'�x��G��d�K�l=��1v�l��};�����L��!�&]y��D��ҽ����}8�rj�wv+�֖���x��;�m���w$��8k�QzU[Ӛe ��]r�Pu��t�@W]Ӝ���� EŔ�i��?bx�̫|��ץ{�}9!�jŬr�����ԧ@����M玚����U��B�C�m2n��{R��%ݽ���X5 k"�'�S�d��n����6
X� �<��to��>��yV�jl�d����A��G5�-:G#r���"G��������s*1�m�Xyk�8YRg�$���R϶8�9|�wW�E|\�����h�E~.���:�BmU���UP���N
�-�Ȕ���t�B���������tWj����`�X�iDF�����45��E����d���|<�'� �K0���X��kWMl��i)����N�AB�6���QY��\�V||K�<a-���0�((6��F�{�m���ڇ��[��W7��b[c3\�n3=�i�9b&���W<��t�G-2H?aM#�!�77��Q��h��[� �?�b���N����u��v���#Y�����0:�'�T*t��^��"����]Ә$2��x��Wc�wy]���E�/�XBH������v�f��x�ȍ�u++�U��E+����˟��W0���7��n��+��O0�J��ku�$�A;xy<�7��W�c�Ə�K�<�ZQ1�!vX�����:�`�ͪ�1���h(��^C�J֤�(��0����������,�&�B���4���~����xp���̼RE���^�c��FW<�0Du���c]��D��O�K�_.�X�����)(�T���F�`M�p���P�#��w*666[��wĴ�A���X�
��n����o�묚�Gץ{y��}6����m������鎸�lMU�͗��LD�?;��zt]#�As�j�S�w�QG�K����Ui��ԃ�W)	&��q�ʋ�;��[��ES�ofm?����Wj#:��y:�6�[-�W�a-7x���(���c$�;<h5�+����.���FlZ��A=R{Z�"�4s6����#�l�@��z��i�>ҮS����5��9�Ռ�8��U�o
Tt)�>յU\�Z�t7�#�lXM�W_o�W!T������lĵ�/�V3�̉z	���wF���OT�ϥ{?��Ԫf�[/�P�P�0��o�R2K�\�x��m`�S�U�j�9��W'؀FԼ#~��rW��Rr7�,5��������4�v�5�>���[�y+￮�[���p×!y�����}]���v�2��2.��Ǡ^�����&��v"�ݻ��x�?Js�]&6�tկ �E�"KLޜ�lA���z��L�o���{�\��&�fuXq�U���-H�t��M��nr�U����w#'����J6BO�V��C7h0!ց5��h�mkҼ-��=���\��7>H�jN�~6{]���E�n`Y���!$}���P�9?��}��+bW�fNsa�)/��8&����3*S�~��L횡���3�OoG�\�tՑz��pi���a^�1��
��'{k?�����l5uﱵ;?G�d�%���3�	;+"׊t'�����{ E   >��Z��6��ƢЇ�����y�h�'��[C��YV�Q��ui˹�����!���l�ﯿ��/�zp'      �      x������ � �      �      x������ � �      �      x������ � �      �   �  x�U�[��0D��bF<m����:�p\N��n�t\@ALt��s������墩�N����|q�M����
'�[>?)����=�+��	�7r�?7�C
�]�T��E:��Oմ�,�O���\�s8<cS]*��eC3��P�{S<�E����#�e�� �l.'�SUd`̰A��!N,5Ym"��sX%t�)Nl�É�ųSX`���v��7���#..G��͒�ŕ�O���qӼ��͋�u�G�մ�|jmCa�C����߃�o�zJ�ZQ>/B	��~��EǓ�F����\���َ}Rh�n0#A�i9��+���з������#��;G���-������0��F����`�u#�(�#)'#Go�4a���A�>��oF�����A�cs�E���h��,읺�V�$�=�Ԍ�I� ���y�BnGS�"�/cd�-gSzn5RfoB�]3�� $�[�3\o��D>l��c�Ş�[�^�ױ=��� <��X��B]�'%�g�����G��83�������c�+qh�W/����ȵ'h���S����C�Z|�[�����P�2X@iĩ��b(8ǲh�^���{��q��-��#�"�'c��u�{ђD����nG����T9��`��A�@���l���xF�|���������{��LJ��l*�^׍�{�Ut�-�O�bHw�e�ڔ�;z�W}��0�Y���nw�Ze��/���8��ګ�v������*K��      �   �  x�͖K�7��5������-��
�<p&Y8$Y���qgڴ���IO��=i�U���������=U�Z)9�O1�@�*8`x	�ÌqaZ����Y�Iw�?��]ڨ���]*�����������n�o�_g�wH��v����]����ۇ��wl����t���n���ߴ�a;�����mL8�@��oRO��Ӵ	�N<������X��jI,ՠL*5r��s9!X,D	פ���^͇��n�(��_�_o����<�g�˱x���/]|�ڴ@�5 �̐:��zY!GgbQ�(��q����v����o:9�4�N�t(:%L���Z_j��k�Q��g�Ee!��W�5l@����6�j^J�4c��2$�֋Q�g8�'2�פUpz8q��GE�V)��I+�P U�R�9?5�8��߅u0҉1Li�F���b����(#0���9�.�.x�k�:8����Yb͆�U=I�L�W�������n�K��'N��������L>űe+a#]5�K��������#���A��2�&ߡ>�j^s��z�����0���-8^�V�N�4��L���Vߐ�m� 0Ze�-_6�-�w$�v�oϥup�rHy�")qH5��g.�Qi�
��]���8�xUZ�)�T&�^*��I�RdI-��t`��E��}��KꥴN=r�u7772\��      �      x������ � �      �      x������ � �      �   O   x�}̱�0D��L�l�1�Y��I�&r����Y��Y\3wXh#4;ص.`�خ��$�^kE�����Q	�H�!"U>      �   �
  x��[[sSG~��o�����Oa���� �@QE,c[r,����d���9�|R�W������'%'!y�>�����bqqxpp6�rtv:�/ ���������dz0_-���A2``��Ǹ���!��#��%(��������F�A�G�Q�̏/��g��@~ �L6�	�_�D���&Y�H1�㐆�l�l�4PBEA6�ā���%JH(`B�K�6A"�X7yN���
є�w�4��-�U�p��y�`�>���>z�n�\�C�F|��TC����C�[��P�Ѡ�/����7 ���j5�����`���y	����04�`�4e�0$�#-� �O4(B[p��I�s�V��I�E�d�F��$N`��`�8l�|��f�����I?�PM��C����;jBd�jTI>�-Tmg" u�x/�`�䷓�h��M���^��;�&orBB�c%�k�D��j6y�ũ�=�ԟ8$T0V�����2�MI���K�6(bt!�!�I�@��r��f���z��E���VZ��d�?h�>�h�mi��?}ۣ��	�)Ȑ�/�h��l�I�%�x{eb��z��.�5OD��.U�Ѵ)��Mp��n5���?A�>E!z������)�|��u�b�w�C۩(����Hm�d:��	yf��W��k1��T�v*�A�Ð�/�T˜Ԡ�TX�U5y��[��v*֑6�?��j&ө�!B�{`�����!�l�bºY�j&ӎ�6:j1�ai
��ӿ��V�\d�*@�n�%���29�;��mUZ�P_�!K_�J@�4^�XS!M�i�T!۫X|�A�C��`��9z��tE��l
���� �݊���VR�
0�N9�	�0:�RV�G�v+�#b���ڂ���x�ej@6hU�j��1�n�L�nE�����Z�t�~��[qҩ(� ��`�t+��a-�hY���;�J
�|�>n��Of��G��\;����l�zvyv�aƘ��09�]ׯLZ��Q���sߢ�^t�����N�M�/+Y{+�o�)�U��!�6I��G�!���R�׳����譔���g��X���/K�k)���t5@tFH��&���Y7%�E{*�V���� ��t����r�����޷�b1VI�O;O�>\����Cx�o��W���5���&y�$Н���ĺԣo<1u�O'ɠ�����%�F�|��r��EorO����G��ۋ��;��"�D�R�H�}�M��H��]�z��sW�h�t�<�`7�+�t#��t��ͷ�}u��������~��7����ֿ�gZ|���������|z�����w��bI��~ery��1�Q?cҬw�ǽ���u8L�kr~��8���d��o�u�0�/f����8~ߕ�H��TMz/d�lgd��>%�����.ѝ,�����oy3e��g_N���gV��=3��n#kS�1%VS"��F|�̣RJ���T5.���.����]A;du��KSB���7�����]~ �q{�S�@ߜ����x{V>������g�o�~��~�����Cr�����Nǳ�f�UF�r�*�39�t':����O?����������ϟ?}���ľ�����+2���xy5�ԕ��Q��C� ��N～,N��G�J~{=���r�[:s'��������BC��y\[��f�ߔ��P��ю��$���^�����r�e�w>�Ϗ���dqy[@���G�My�ٸ.�"R�̲�O������8�����d��b�gӳ���qZ���2y]<��^N%3y4�{�Z�dZ���5=�̵�[z��d�P�M�����cɼ3�$MpȻk�e+���~l������[�^����
vi�P\�� ��j�P�R�K<O�I<bp(�I�N��v��eG:i��w���Oj�%�����72��8��O:U�+�-Wv�އ��$oD�?;��q)��P�b�**�"�Q����I�H��g7��a�J`�M`UF��ʨ��8�<Q���:����v�!Z0�J��b�2���	"�*��Mީ��uЎ22>��7���ەQI ��
�J�d�'�u�N2��$�1*��W�ە�\�!H�^؛�Z�b����uЎ2��]�c��h�]�rEh ��&�V&֏��u�n2�i��m�Ě~�ڎѣ39�21i�Y�����E��h�FG�,A^��Mv�L���úhGQ@e�A:Z��Q	
Z�m�X�BT�#��t"��j�}���(�FG��|����n���ad]�������q[��b��ʕ�.<TJ@6�c�遥�v��N羹�Y�����6��B.�$��y��t(������Q`��J���Åͧ�Ҥ�����v���	}��Ϲ%��0�������'��ʦ�3�zhG:�$���h�FF��;� pL���&�ԾM��C;�H���	�kt�|�-��*�LM�sid]���}2R$���Ě-д�G(��d���1�۲[�hGS�#��g�kt��Q���V䥉tJ���tю:���n�5:Lm�� )�`Bne�t;�.�M�#�%���cEUG�5:L�|߄����,+�C�qU�hG�Z"�q�]��b��J�5N�P9�l�p[u��B�}�7|۟Y�*Z�QQq9��uQ�C�ҤÔ~��:h7�wA���gP�Q`/&�iV1�-�E[X�;�,M��pظ�ݸhs݋6�/#��ڄ�lI��,�k��zL��{I���������u�      �      x������ � �      �   �  x�}�Kr9D��)|3@|Bט�lf������]�j�Ho���$����zsskV?��������`��;��ڿ����%��`m~�~|�O���׺�=��N=�����V�N&[�R��'}I�	������*OД�^Ј֌*�R(D�	�Ҁ��JP�M�����Hw����Q�����P�F|��'�	@A��z1i���4��P'�@��4
��I�JI���PS�R�U���Je2k2C��>O���0���IMK1���鞪�"�^�%Mjz���0�Cl�V�O��&5M�,M+Ї[�"]��'iR�UOT����b��L��)MjڊU�W��W�Q�q|�ޥIM_���Fw9��Z�]c�ֻ4�i,��U+���*��ֲz�&5���[�0�eB�x��v��4;@:�{jX;ݫ��Ot�&5�%D�T�r ��T��r}�&5�%X��:�}U*H=����&U^TWAg=��V���8�.MjzKG�r�J�3Wz:kJ���qظ��� B�8���YS����`0��(�{jÓ��5�IMo��o�+�gVuQk�OҤ�����V$��Q�0��5��Lg��t��V�erE�������9��$P�:1�O�㙵�R��Ҥ�rh�ǼV[�LR�\�ʎa�$���O��P�ޒ�[	�A��z��Y%�70j˦k!t|LLv��c�I���*�1(jE��Pu;�Q���I����8oS�� BYfP��Y�Ҥ��T�Q�l��g�ΐ-�t�7iR���5���-�_��:/�z�&�_�f(AΛ|E(>&f&���Ҥ�E���eK�ZЄ��aߤAU�M��"�A��&_���
	��?�oҤ^޲9c;vsV�b��ԱK��I������Z�얊Q
S�,u�M���[(cx-i�v�:[rE���o��Aդ�',��mO�b���^�Ҥ^��D�1�� ���'�H�8I�~y+�P4�@�b5�}���ǣ��I��!��I�խj�.W(c��aq�&�_�á>����*�ބ	���I���dU�Ɩ�u3�=\@*�it1��(��N��km'iRkRm���}K5;��*� M*'������
S��)� M���bMA��+�X���es�&U��pLUz�/W(T�m�'iR��b 6x@�يP�g<�rwiR[RQn�ë�LX}P)�/iR=�{1z։���뒮wiR/ga3�Xb�l���
E	��$Mj$u�.����%CGa��OԔ�QR��]7�+T1L2Ɔ�xI�zyk�Z�s��S����L&'+<�$�]�jÔ�#K�zu�&5�%(UL��@��2AO���&5��d�0dD��ohL4F��4��,Lڹc&�P}X��5[*�]��t�j�>j�b!#:�/�{�K���B �Юb�hw�izɀ�2��+crḱ�5]��R�Ҥ��LY��an�B���K��ܥA�����<Ɩur��6� z�^`�&5}5�l����
K6r�|'iR�Y>#��{�c�A~���4������`t�,      �      x������ � �      �      x������ � �      �   �  x�}�]s�@���_�o]��/v�j"6�jlё��D#H�
���b�ԯag`��=�s�"	�^��E2	��5�9 �������m4T)�Kl�67TY��YPG�g_�p3tgR���m;_΋��:i��Ü��u{��բ�컲��y������� �TZ(M�8+��>���hN�Y��}��^2*��[1+z{��I���5NV���,=s`Q�R�LZx(i[��P�@��9�����n���]w�� xV��β�b�-u��q3��������UY[���]�Na�H���YT��'��mo��E�?�3����O���H�$a�]�Ǫ�`Q��s}�)�.�F�����2��eNP�����p����hhZ���L�ww��y���d��p ��KQ�,&AaN�Wׄ�c���0%��#LS��7E�2������M����(HK�cb�e�l����j�_���O      �      x������ � �      �     x��KO�0���@9�Ռ_�s�P�r�������fc6�h���o*� NH�4��>'�σ[�*�.�b���0Ɲ��W��>V�T'yY�uuv��Ϧ`����7�C<�.��iu�LE.��[U����U�ZO�6���ⰺ�R�|~�J�;�C��w��G-c?!n�}��Q�؇�b
���r����U������?����S�������jw��mq��ک��r0�TG�<�I(�����7d�h�T�Oi���E�z���ؿ�I���2�&���\�!�:�vX��9���/{�����w@gQ!Ԓ�"ɤ5�9�5�H���@��s����l�m�n�Ϲ�B��R8�ʾey�I9FB�,e9X�-RT��%ʒʂ�̨
Gs.)V'@+%���R��!ai�A���+�3ܡ2^Ke����F���F��>L�ć��GY��+W���yf��(9W&��	І�ey  uML�"�ӱx�,��LܼN�D)�D,�2�%��J�F�(��=���h�l��+]��ϥ���|6��Ʌ��     