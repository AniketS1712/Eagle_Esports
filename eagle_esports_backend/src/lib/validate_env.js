function validateEnv() {
  const required = [
    'PORT',
    'RAZORPAY_KEY_ID',
    'RAZORPAY_KEY_SECRET',
    'SUPABASE_URL',
    'SUPABASE_SERVICE_ROLE_KEY',
  ]
  const missing = required.filter((key) => !process.env[key])
  if (missing.length > 0) {
    throw new Error(
      `Missing required environment variables: ${missing.join(', ')}`
    )
  }
}

module.exports = { validateEnv }
