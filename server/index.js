const { SerialPort } = require('serialport');
const { ReadlineParser } = require('@serialport/parser-readline')

// Example usage:
const phoneNumber = '+639458301808'; // Replace with recipient's phone number
const message = 'Hello from Node.js!';

var port = new SerialPort({
    path: 'COM27',
    // path: 'USB\\VID_12D1&PID_14AC&MI_03\\8&19E72F8C&0&0003',
    baudRate: 9600,
    autoOpen: true,
});

port.on('open', async (err) => {
    if (err) {
        return console.log('Error opening port: ', err.message);
    }

    console.log('Port opened.');
    await sendSMS(phoneNumber, message);
    port.close();
});

// Read data that is available but keep the stream in "paused mode"
port.on('readable', function () {
    console.log('Data:', port.read());
});

// Switches the port into "flowing mode"
port.on('data', function (data) {
    console.log('Data:', data);
});


const parser = new ReadlineParser({ delimiter: '\r\n' });
port.pipe(parser);

parser.on('data', data => {
    console.log('Received:', data);
});

// Function to send AT commands and handle responses
function sendATCommand(command) {
    return new Promise((resolve, reject) => {
        port.write(command, err => {
            if (err) {
                reject(err);
            }
        });
        port.write('\r', err => {
            if (err) {
                reject(err);
            } else {
                resolve(true);
            }
        })
    });
}

async function sendSMS(phoneNumber, message) {
    try {
        await sendATCommand('AT+CMGF=1'); // Set SMS text mode
        let reply = await sendATCommand(`AT+CMGS="${phoneNumber}"`); // Specify the phone number
        console.log(reply);
        await sendATCommand(message); // Send the message
        await sendATCommand(String.fromCharCode(26)); // Send Ctrl+Z char
        console.log('SMS sent successfully');
    } catch (err) {
        console.error('Error sending SMS:', err);
    }
}