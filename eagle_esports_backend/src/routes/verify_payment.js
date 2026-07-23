const express = require('express')
const crypto = require('crypto')
const router = express.Router()
const { supabaseAdmin } = require('../lib/supabase_admin')

router.post('/', async (req, res) => {
  // 1. Verify Razorpay webhook signature FIRST (before parsing)
  // Must use the raw Buffer (req.body) not the parsed string
  // to reproduce the exact bytes Razorpay signed
  const receivedSignature = req.headers['x-razorpay-signature']
  if (!receivedSignature) {
    console.error('[verify-payment] Missing signature header')
    return res.status(400).json({ error: 'Missing signature' })
  }

  const expectedSignature = crypto
    .createHmac('sha256', process.env.RAZORPAY_WEBHOOK_SECRET)
    .update(req.body)
    .digest('hex')

  const expectedBuffer = Buffer.from(expectedSignature, 'hex')
  const receivedBuffer = Buffer.from(receivedSignature, 'hex')

  // timingSafeEqual requires buffers of the same length
  if (expectedBuffer.length !== receivedBuffer.length) {
    console.error('[verify-payment] Signature length mismatch')
    return res.status(400).json({ error: 'Invalid signature length' })
  }

  const signaturesMatch = crypto.timingSafeEqual(expectedBuffer, receivedBuffer)

  if (!signaturesMatch) {
    console.error('[verify-payment] Signature mismatch — possible spoofed request')
    return res.status(400).json({ error: 'Invalid signature' })
  }

  // 2. Parse raw body
  let payload
  try {
    payload = JSON.parse(req.body.toString())
  } catch {
    console.error('[verify-payment] Failed to parse webhook body')
    return res.status(400).json({ error: 'Invalid payload' })
  }

  // 3. Only act on payment.captured events
  // Return 200 for all other events — Razorpay expects 200 for every delivery
  if (payload.event !== 'payment.captured') {
    return res.status(200).json({ received: true })
  }

  // 4. Extract data from payload
  // notes were set by create_order.js when creating the order
  const notes = payload.payload?.payment?.entity?.notes ?? {}
  const userId = notes.userId
  const talonAmount = Number(notes.talonAmount)

  if (!userId || isNaN(talonAmount) || talonAmount <= 0) {
    console.error('[verify-payment] Missing or invalid notes in payload', notes)
    // Return 200 so Razorpay does not keep retrying — this is a data issue
    // Log it for manual investigation
    return res.status(200).json({ received: true, warning: 'Invalid notes' })
  }

  // 5. Credit the user's Talon wallet via Postgres function
  // Uses service_role client — bypasses RLS
  const { error: creditError } = await supabaseAdmin.rpc('credit_wallet', {
    p_user_id: userId,
    p_amount: talonAmount,
    p_category: 'topup',
    p_reference_id: null,
    p_description: `Wallet top-up — ₹${talonAmount}`,
  })

  if (creditError) {
    console.error('[verify-payment] credit_wallet failed:', creditError.message)
    // Return 500 so Razorpay retries the webhook delivery
    return res.status(500).json({ error: 'Failed to credit wallet' })
  }

  console.log(
    `[verify-payment] Credited ${talonAmount} Talons to user ${userId.substring(0, 8)}...`
  )

  return res.status(200).json({ received: true })
})

module.exports = router
