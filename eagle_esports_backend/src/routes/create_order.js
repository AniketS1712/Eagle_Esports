const express = require('express')
const router = express.Router()
const { razorpay } = require('../lib/razorpay')
const { supabaseAdmin } = require('../lib/supabase_admin')

router.post('/', async (req, res, next) => {
  try {
    const { amount, userId } = req.body

    // 1. Validate request body
    if (!amount || !userId) {
      return res.status(400).json({
        error: 'amount and userId are required',
      })
    }

    const amountNum = Number(amount)
    if (isNaN(amountNum) || amountNum <= 0) {
      return res.status(400).json({ error: 'amount must be a positive number' })
    }

    console.log('[create-order] Checking for amount:', amountNum)
    const { data: allOptions } = await supabaseAdmin.from('topup_options').select('*')
    console.log('[create-order] All options in DB:', allOptions)

    // 2. Validate amount exists in topup_options table
    // This prevents users from sending arbitrary amounts not in the approved list
    const { data: option, error: optionError } = await supabaseAdmin
      .from('topup_options')
      .select('id, amount')
      .eq('amount', amountNum)
      .eq('is_active', true)
      .maybeSingle()

    if (optionError) throw optionError
    if (!option) {
      return res.status(400).json({
        error: 'Invalid top-up amount — not in approved list',
      })
    }

    // 3. Validate user exists in profiles table
    const { data: profile, error: profileError } = await supabaseAdmin
      .from('profiles')
      .select('id')
      .eq('id', userId)
      .maybeSingle()

    if (profileError) throw profileError
    if (!profile) {
      return res.status(404).json({ error: 'User not found' })
    }

    // 4. Create Razorpay order
    // amount is stored in paise (1 rupee = 100 paise)
    const order = await razorpay.orders.create({
      amount: amountNum * 100,
      currency: 'INR',
      receipt: `topup_${userId.substring(0, 8)}_${Date.now()}`,
      notes: {
        // Notes are passed back in the webhook payload
        // so Node.js knows which user to credit
        userId: userId,
        talonAmount: amountNum,
      },
    })

    // 5. Return order details to Flutter
    // Flutter uses orderId + keyId to open Razorpay checkout
    return res.status(200).json({
      orderId: order.id,
      amount: amountNum,
      currency: 'INR',
      keyId: process.env.RAZORPAY_KEY_ID,
    })
  } catch (err) {
    next(err)
  }
})

module.exports = router
