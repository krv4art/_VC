#!/usr/bin/env python3
"""
Script to fix Supabase RPC functions via REST API
"""

import requests
import json

# Supabase configuration
SUPABASE_URL = "https://yerbryysrnaraqmbhqdm.supabase.co"
ANON_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InllcmJyeXlzcm5hcmFxbWJocWRtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTUwNjY4MTIsImV4cCI6MjA3MDY0MjgxMn0.jqAChRZ2f19chNlbl3PiAxydWkpnZSQhhEd6iLMiUyk"

headers = {
    "apikey": ANON_KEY,
    "Authorization": f"Bearer {ANON_KEY}",
    "Content-Type": "application/json"
}

def execute_sql(sql_query, query_name=""):
    """
    Try to execute SQL query via Supabase REST API
    This might not work with ANON key - requires service_role key
    """
    print(f"\n{'='*60}")
    print(f"Executing: {query_name}")
    print(f"{'='*60}")
    print(f"Query:\n{sql_query[:200]}...")

    # Try different endpoints
    endpoints = [
        f"{SUPABASE_URL}/rest/v1/rpc/exec",
        f"{SUPABASE_URL}/rest/v1/rpc/query",
    ]

    for endpoint in endpoints:
        try:
            response = requests.post(
                endpoint,
                headers=headers,
                json={"query": sql_query},
                timeout=30
            )
            print(f"\nEndpoint: {endpoint}")
            print(f"Status: {response.status_code}")
            print(f"Response: {response.text[:500]}")

            if response.status_code == 200:
                return True, response.json()
        except Exception as e:
            print(f"Error: {e}")

    return False, "Cannot execute SQL with ANON key"


# SQL for add_option_translations function
sql_add_option_translations = """
DROP FUNCTION IF EXISTS add_option_translations(UUID, JSONB, TEXT);

CREATE OR REPLACE FUNCTION add_option_translations(
  p_option_id UUID,
  p_translations JSONB,
  p_translation_status TEXT
) RETURNS jsonb AS $$
DECLARE
  v_lang_code TEXT;
  v_text TEXT;
  v_count INT := 0;
BEGIN
  -- Валидация
  IF p_option_id IS NULL THEN
    RETURN jsonb_build_object(
      'success', false,
      'error', 'invalid_option_id'
    );
  END IF;

  IF p_translations IS NULL OR p_translations::text = '{}' THEN
    RETURN jsonb_build_object(
      'success', false,
      'error', 'empty_translations'
    );
  END IF;

  -- Проходим по каждому переводу
  FOR v_lang_code, v_text IN
  SELECT key, value ->> 'text'
  FROM jsonb_each(p_translations)
  WHERE value ->> 'text' IS NOT NULL
  LOOP
    -- Проверяем, есть ли уже перевод для этого языка
    IF NOT EXISTS(
      SELECT 1 FROM poll_option_translations
      WHERE option_id = p_option_id AND language_code = v_lang_code
    ) THEN
      -- Добавляем новый перевод
      INSERT INTO poll_option_translations (option_id, language_code, text)
      VALUES (p_option_id, v_lang_code, v_text);
      v_count := v_count + 1;
    END IF;
  END LOOP;

  -- Обновляем статус перевода
  UPDATE poll_options
  SET translation_status = p_translation_status
  WHERE id = p_option_id;

  RETURN jsonb_build_object(
    'success', true,
    'error', null,
    'translations_added', v_count,
    'translation_status', p_translation_status
  );
END;
$$ LANGUAGE plpgsql;
"""

# SQL for get_pending_translations function
sql_get_pending_translations = """
DROP FUNCTION IF EXISTS get_pending_translations(INT);

CREATE OR REPLACE FUNCTION get_pending_translations(p_limit INT DEFAULT 10)
RETURNS TABLE (
  option_id UUID,
  original_text TEXT,
  language_code TEXT,
  created_at TIMESTAMPTZ
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    po.id,
    pot.text,
    po.translated_from_language,
    po.created_at
  FROM poll_options po
  LEFT JOIN poll_option_translations pot ON po.id = pot.option_id AND pot.language_code = po.translated_from_language
  WHERE po.translation_status = 'pending'
  ORDER BY po.created_at DESC
  LIMIT p_limit;
END;
$$ LANGUAGE plpgsql;
"""


def main():
    print("\n" + "="*60)
    print("SUPABASE RPC FUNCTIONS FIX SCRIPT")
    print("="*60)
    print("\nProject: yerbryysrnaraqmbhqdm")
    print(f"URL: {SUPABASE_URL}")
    print("\nNote: This script requires service_role key to execute SQL.")
    print("If execution fails, please copy the SQL queries and execute them")
    print("manually in Supabase Dashboard > SQL Editor.")
    print("\n" + "="*60)

    # Try to fix add_option_translations
    success1, result1 = execute_sql(sql_add_option_translations, "Fix add_option_translations")

    # Try to fix get_pending_translations
    success2, result2 = execute_sql(sql_get_pending_translations, "Fix get_pending_translations")

    # Summary
    print("\n" + "="*60)
    print("SUMMARY")
    print("="*60)

    if not success1 and not success2:
        print("\n[X] Cannot execute SQL with ANON key")
        print("\n[!] MANUAL FIX REQUIRED:")
        print("\n1. Open Supabase Dashboard:")
        print("   https://supabase.com/dashboard/project/yerbryysrnaraqmbhqdm/sql/new")
        print("\n2. Copy and execute these SQL queries:")
        print("\n" + "="*60)
        print("QUERY 1: Fix add_option_translations")
        print("="*60)
        print(sql_add_option_translations)
        print("\n" + "="*60)
        print("QUERY 2: Fix get_pending_translations")
        print("="*60)
        print(sql_get_pending_translations)
        print("\n" + "="*60)

        # Save SQL to files
        with open("e:/_VC/acs/fix_add_option_translations.sql", "w", encoding="utf-8") as f:
            f.write(sql_add_option_translations)
        with open("e:/_VC/acs/fix_get_pending_translations.sql", "w", encoding="utf-8") as f:
            f.write(sql_get_pending_translations)

        print("\n[OK] SQL queries saved to:")
        print("   - e:/_VC/acs/fix_add_option_translations.sql")
        print("   - e:/_VC/acs/fix_get_pending_translations.sql")

    else:
        if success1:
            print("\n[OK] add_option_translations fixed successfully")
        else:
            print("\n[X] add_option_translations fix failed")

        if success2:
            print("\n[OK] get_pending_translations fixed successfully")
        else:
            print("\n[X] get_pending_translations fix failed")


if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("\n\n❌ Aborted by user")
    except Exception as e:
        print(f"\n\n❌ Error: {e}")
