require('dotenv').config();
const { supabaseAdmin } = require('./src/lib/supabase_admin');

async function run() {
  const { data: allOptions } = await supabaseAdmin.from('topup_options').select('*');
  console.log('All options:', JSON.stringify(allOptions, null, 2));

  const amountNum = 2000;
  const { data: option, error: optionError } = await supabaseAdmin
      .from('topup_options')
      .select('id, amount')
      .eq('amount', amountNum)
      .eq('is_active', true)
      .maybeSingle()

  console.log('Filtered Option:', option, 'Error:', optionError);
  process.exit(0);
}
run();
