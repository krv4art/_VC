#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Script to replace "Chat" navbar label with "Consultant" in all localization files
"""

import json
import os

# Directory containing .arb files
import sys
script_dir = os.path.dirname(os.path.abspath(__file__))
l10n_dir = os.path.join(script_dir, 'lib', 'l10n')

# Translations for "Consultant" in each language
translations = {
    'app_en.arb': 'Consultant',
    'app_ru.arb': 'Консультант',
    'app_uk.arb': 'Консультант',
    'app_de.arb': 'Beauty-Berater',
    'app_es.arb': 'Asesor de belleza',
    'app_es_ES.arb': 'Asesor de belleza',
    'app_es_419.arb': 'Asesor de belleza',
    'app_fr.arb': 'Conseiller beauté',
    'app_it.arb': 'Consulente di bellezza',
    'app_pt.arb': 'Consultor',
    'app_pt_BR.arb': 'Consultor',
    'app_pt_PT.arb': 'Consultor',
    'app_pl.arb': 'Konsultant kosmetyczny',
    'app_cs.arb': 'Konzultant',
    'app_ro.arb': 'Consultant',
    'app_hu.arb': 'Tanacsado',
    'app_tr.arb': 'Danışman',
    'app_nl.arb': 'Consultant',
    'app_da.arb': 'Konsulent',
    'app_sv.arb': 'Konsult',
    'app_no.arb': 'Konsulent',
    'app_fi.arb': 'Konsultti',
    'app_el.arb': 'Σύμβουλος',
    'app_ar.arb': 'مستشار',
    'app_hi.arb': 'सलाहकार',
    'app_th.arb': 'ที่ปรึกษา',
    'app_vi.arb': 'Cố vấn',
    'app_id.arb': 'Konsultan',
    'app_ja.arb': 'コンサルタント',
    'app_ko.arb': '컨설턴트',
    'app_zh.arb': '顾问',
    'app_zh_CN.arb': '顾问',
    'app_zh_TW.arb': '顧問',
}

def update_file(filepath, new_value):
    """Update aiChatNav value in a single .arb file"""
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            data = json.load(f)

        old_value = data.get('aiChatNav', 'N/A')

        if 'aiChatNav' in data:
            data['aiChatNav'] = new_value

            with open(filepath, 'w', encoding='utf-8') as f:
                json.dump(data, f, ensure_ascii=False, indent=2)

            return True, old_value, new_value
        else:
            return False, None, None

    except Exception as e:
        print(f'[ERROR] {os.path.basename(filepath)}: {str(e)}')
        return False, None, None

def main():
    updated_count = 0
    not_found_count = 0

    print('Updating aiChatNav translations...\n')

    for filename, translation in translations.items():
        filepath = os.path.join(l10n_dir, filename)

        if not os.path.exists(filepath):
            print(f'[SKIP] {filename}: File not found')
            not_found_count += 1
            continue

        success, old_value, new_value = update_file(filepath, translation)

        if success:
            print(f'[OK] {filename}')
            updated_count += 1
        else:
            print(f'[WARN] {filename}: aiChatNav key not found')

    print(f'\n--- Summary ---')
    print(f'Updated: {updated_count} files')
    print(f'Not found: {not_found_count} files')
    print(f'\nDone! Run "flutter gen-l10n" to regenerate localizations.')

if __name__ == '__main__':
    main()
