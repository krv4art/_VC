const { createClient } = require('@supabase/supabase-js');

const url = 'https://yerbryysrnaraqmbhqdm.supabase.co';
const key = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InllcmJyeXlzcm5hcmFxbWJocWRtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTUwNjY4MTIsImV4cCI6MjA3MDY0MjgxMn0.jqAChRZ2f19chNlbl3PiAxydWkpnZSQhhEd6iLMiUyk';

const supabase = createClient(url, key);

const options = [
  {
    en: 'Very Interested',
    ru: 'Очень интересует',
    uk: 'Дуже цікаво',
    de: 'Sehr interessant',
    es: 'Muy interesado',
    fr: 'Très intéressé',
    it: 'Molto interessato'
  },
  {
    en: 'Somewhat Interested',
    ru: 'Частично интересует',
    uk: 'Частково цікаво',
    de: 'Etwas interessant',
    es: 'Algo interesado',
    fr: 'Un peu intéressé',
    it: 'Abbastanza interessato'
  },
  {
    en: 'Not Interested',
    ru: 'Не интересует',
    uk: 'Не цікаво',
    de: 'Nicht interessant',
    es: 'No interesado',
    fr: 'Pas intéressé',
    it: 'Non interessato'
  },
  {
    en: 'Need More Information',
    ru: 'Нужна дополнительная информация',
    uk: 'Потрібна додаткова інформація',
    de: 'Brauche mehr Informationen',
    es: 'Necesito más información',
    fr: 'Besoin de plus d\'informations',
    it: 'Ho bisogno di più informazioni'
  }
];

const languages = ['en', 'ru', 'uk', 'de', 'es', 'fr', 'it'];

async function insertOptions() {
  try {
    for (const option of options) {
      // Insert poll option
      const { data: pollOption, error: pollError } = await supabase
        .from('poll_options')
        .insert([{ vote_count: 0, is_user_created: false }])
        .select()
        .single();

      if (pollError) {
        console.error('Error inserting poll option:', pollError);
        continue;
      }

      console.log('Inserted poll option:', pollOption.id);

      // Insert translations
      const translations = languages.map(lang => ({
        option_id: pollOption.id,
        language_code: lang,
        text: option[lang]
      }));

      const { error: transError } = await supabase
        .from('poll_option_translations')
        .insert(translations);

      if (transError) {
        console.error('Error inserting translations:', transError);
      } else {
        console.log('Inserted translations for option:', pollOption.id);
      }
    }

    console.log('All options inserted successfully!');
  } catch (error) {
    console.error('Error:', error);
  }
}

insertOptions();
