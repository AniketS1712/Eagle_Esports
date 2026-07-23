require('dotenv').config();
const { razorpay } = require('./src/lib/razorpay');

async function run() {
  try {
    const order = await razorpay.orders.create({
      amount: 200000,
      currency: 'INR',
      receipt: `topup_test`,
      notes: { userId: 'test' },
    });
    console.log('Success:', order);
  } catch (err) {
    console.error('Error:', err);
  }
}
run();
