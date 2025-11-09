const { createClient } = require('@supabase/supabase-js');

const url = 'https://yerbryysrnaraqmbhqdm.supabase.co';
const key = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InllcmJyeXlzcm5hcmFxbWJocWRtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTUwNjY4MTIsImV4cCI6MjA3MDY0MjgxMn0.jqAChRZ2f19chNlbl3PiAxydWkpnZSQhhEd6iLMiUyk';

const supabase = createClient(url, key);

async function clearOptions() {
  try {
    // Delete all translations first (foreign key constraint)
    const { error: transError } = await supabase
      .from('poll_option_translations')
      .delete()
      .neq('id', '00000000-0000-0000-0000-000000000000'); // Delete all

    if (transError) {
      console.error('Error deleting translations:', transError);
    } else {
      console.log('All translations deleted');
    }

    // Delete all poll votes
    const { error: votesError } = await supabase
      .from('poll_votes')
      .delete()
      .neq('id', '00000000-0000-0000-0000-000000000000'); // Delete all

    if (votesError) {
      console.error('Error deleting votes:', votesError);
    } else {
      console.log('All votes deleted');
    }

    // Delete all poll options
    const { error: optError } = await supabase
      .from('poll_options')
      .delete()
      .neq('id', '00000000-0000-0000-0000-000000000000'); // Delete all

    if (optError) {
      console.error('Error deleting options:', optError);
    } else {
      console.log('All options deleted');
    }

    console.log('All tables cleared successfully!');
  } catch (error) {
    console.error('Error:', error);
  }
}

clearOptions();
