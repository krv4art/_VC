#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Script to replace "Scan" navbar label with "Scanner" in all localization files
"""

import json
import os

# Directory containing .arb files
import sys
script_dir = os.path.dirname(os.path.abspath(__file__))
l10n_dir = os.path.join(script_dir, 'lib', 'l10n')

# Translations for "Scanner" in each language
translations = {
    'app_en.arb': 'Scanner',
    'app_ru.arb': 'Сканер',
    'app_uk.arb': 'Сканер',
    'app_de.arb': 'Scanner',
    'app_es.arb': 'Escáner',
    'app_es_ES.arb': 'Escáner',
    'app_es_419.arb': 'Escáner',
    'app_fr.arb': 'Scanner',
    'app_it.arb': 'Scanner',
    'app_pt.arb': 'Scanner',
    'app_pt_BR.arb': 'Scanner',
    'app_pt_PT.arb': 'Scanner',
    'app_pl.arb': 'Skaner',
    'app_cs.arb': 'Skener',
    'app_ro.arb': 'Scanner',
    'app_hu.arb': 'Szkenner',
    'app_tr.arb': 'Tarayıcı',
    'app_nl.arb': 'Scanner',
    'app_da.arb': 'Scanner',
    'app_sv.arb': 'Skanner',
    'app_no.arb': 'Skanner',
    'app_fi.arb': 'Skanneri',
    'app_el.arb': 'Σαρωτής',
    'app_ar.arb': 'ماسح ضوئي',
    'app_hi.arb': 'स्कैनर',
    'app_th.arb': 'เครื่องสแกน',
    'app_vi.arb': 'Máy quét',
    'app_id.arb': 'Pemindai',
    'app_ja.arb': 'スキャナー',
    'app_ko.arb': '스캐너',
    'app_zh.arb': '扫描仪',
    'app_zh_CN.arb': '扫描仪',
    'app_zh_TW.arb': '掃描儀',
}

def update_file(filepath, new_value):
    """Update scan value in a single .arb file"""
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            data = json.load(f)

        old_value = data.get('scan', 'N/A')

        if 'scan' in data:
            data['scan'] = new_value

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

    print('Updating scan translations to Scanner...\n')

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
            print(f'[WARN] {filename}: scan key not found')

    print(f'\n--- Summary ---')
    print(f'Updated: {updated_count} files')
    print(f'Not found: {not_found_count} files')
    print(f'\nDone! Run "flutter gen-l10n" to regenerate localizations.')

if __name__ == '__main__':
    main()
