#!/usr/bin/env python3
import re

# Read the file
with open('lib/screens/language_screen.dart', 'r', encoding='utf-8') as f:
    content = f.read()

# Fix 1: Remove empty lines between } and final
content = re.sub(r'\];(\n\s*\n)+(\s*)final List<Map<String, String>> sortedLanguages', r'];\n\n\2final List<Map<String, String>> sortedLanguages', content)

# Fix 2: Update animation count from 28 to 12
content = content.replace('// With 28 elements (27 languages + 1 button), each starting at 0.03 intervals', '// With 12 elements (11 languages + 1 button), each starting at 0.06 intervals')
content = content.replace('_animations = List.generate(28, (index) {', '_animations = List.generate(12, (index) {')
content = content.replace('final startTime = index * 0.03;', 'final startTime = index * 0.06;')

# Fix 3: Update getLanguageName to only include supported languages
old_switch = r'''    String getLanguageName\(String code\) \{
      switch \(code\) \{
        case 'ar':
          return l10n\.language_ar;
        case 'cs':
          return l10n\.language_cs;
        case 'da':
          return l10n\.language_da;
        case 'de':
          return l10n\.language_de;
        case 'el':
          return l10n\.language_el;
        case 'en':
          return l10n\.language_en;
        case 'es':
          return l10n\.language_es;
        case 'fi':
          return l10n\.language_fi;
        case 'fr':
          return l10n\.language_fr;
        case 'hi':
          return l10n\.language_hi;
        case 'hu':
          return l10n\.language_hu;
        case 'id':
          return l10n\.language_id;
        case 'it':
          return l10n\.language_it;
        case 'ja':
          return l10n\.language_ja;
        case 'ko':
          return l10n\.language_ko;
        case 'nl':
          return l10n\.language_nl;
        case 'no':
          return l10n\.language_no;
        case 'pl':
          return l10n\.language_pl;
        case 'pt':
          return l10n\.language_pt;
        case 'ro':
          return l10n\.language_ro;
        case 'ru':
          return l10n\.language_ru;
        case 'sv':
          return l10n\.language_sv;
        case 'th':
          return l10n\.language_th;
        case 'tr':
          return l10n\.language_tr;
        case 'uk':
          return l10n\.language_uk;
        case 'vi':
          return l10n\.language_vi;
        case 'zh':
          return l10n\.language_zh;
        default:
          return code;
      \}
    \}'''

new_switch = '''    String getLanguageName(String code) {
      switch (code) {
        case 'ar':
          return l10n.language_ar;
        case 'cs':
          return l10n.language_cs;
        case 'da':
          return l10n.language_da;
        case 'de':
          return l10n.language_de;
        case 'el':
          return l10n.language_el;
        case 'en':
          return l10n.language_en;
        case 'es':
          return l10n.language_es;
        case 'fr':
          return l10n.language_fr;
        case 'it':
          return l10n.language_it;
        case 'ru':
          return l10n.language_ru;
        case 'uk':
          return l10n.language_uk;
        default:
          return code;
      }
    }'''

content = re.sub(old_switch, new_switch, content, flags=re.MULTILINE)

# Write the file
with open('lib/screens/language_screen.dart', 'w', encoding='utf-8') as f:
    f.write(content)

print("Fixed language_screen.dart")
