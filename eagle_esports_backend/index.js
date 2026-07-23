require('dotenv').config()
const { validateEnv } = require('./src/lib/validate_env')
validateEnv()

const express = require('express')
const app = express()
const PORT = process.env.PORT || 3000

app.use((req, res, next) => {
  if (req.originalUrl === '/verify-payment') return next()
  express.json()(req, res, next)
})
app.get('/', (req, res) => {
  res.send('Eagle Esports Backend is running!');
});
app.use('/verify-payment', express.raw({ type: 'application/json' }))

const createOrderRouter = require('./src/routes/create_order')
const verifyPaymentRouter = require('./src/routes/verify_payment')
app.use('/create-order', createOrderRouter)
app.use('/verify-payment', verifyPaymentRouter)

app.get('/health', (req, res) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString() })
})

app.use((err, req, res, next) => {
  const errorMessage = err.error?.description || err.message || 'Internal server error'
  console.error('[Eagle Esport Backend Error]', errorMessage, err)
  res.status(500).json({ error: errorMessage })
})

app.listen(PORT, () => {
  console.log(`[Eagle Esport Backend] running on port ${PORT}`)
})
